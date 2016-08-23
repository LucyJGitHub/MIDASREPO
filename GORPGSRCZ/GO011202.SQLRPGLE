     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas GO Bulk Sync Global Layer GZRECOMD Deletions')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO011202 - Bulk Sync Global Layer GZRECOMD Deletions         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *---------------------------------------------------------------*
      *  ]] NB do not change this program without considering         *
      *  ]] changes to GORECOMD and GO011201.                         *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. CGP017   *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
      *
      ** File Declarations
      *
     FACNTDLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Dropped Global Retail Accounts
 
     FRECOM     IF   E           K DISK    INFSR(*PSSR)
      ** Retail Commisions Logical File
 
      ** Variables/Constants/Data Structure Declarations
      *
     D I_ZONE          S             10A
     D I#ERMS          S             50A   INZ
     D RunBefore       S              1N   INZ
     D RowsReturned    S              5U 0 INZ
     D SQLOK           C                   CONST(0)
     D SQLEoF          C                   CONST(100)
     D True            C                   CONST(*ON)
     D False           C                   CONST(*OFF)
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
     D Z_RECOM       E DS                  INZ EXTNAME(RECOMD)
      ** Zonal RECOM Data Structure
 
     D G_RECOM       E DS                  INZ EXTNAME(RECOMD)
     D                                     PREFIX(G_)
      ** Global RECOM Data Structure
 
     D G_LOGS        E DS                  INZ EXTNAME(GOSBLOGPD)
      ** Global Log GPSBLOGPD Data Structure
 
      ** Array Variables
      ** - Current Index, Previous Index, Trailer Index
 
     D ArrSize         C                   CONST(900)
     D EntryFound      S              1N   INZ
     D CIdx            S              3S 0 INZ
     D PIdx            S                   INZ LIKE(CIdx)
     D TIdx            S                   INZ LIKE(CIdx)
 
     D Branch          S                   INZ LIKE(G_BRCA)
     D                                     DIM(ArrSize)
      ** Branches
 
     D COUNTS          DS                  INZ QUALIFIED
     D                                     DIM(ArrSize)
     D  BSCntW                             LIKE(BSCNTW)
     D  BSCntD                             LIKE(BSCNTD)
     D  BSCntU                             LIKE(BSCNTU)
      ** Written, deleted, updated records count per branch
 
     D SYNTOTAL        DS                  INZ LIKEDS(COUNTS)
      ** Sync Log Totals
 
      ** Timelog Variables
 
     D StartTStamp     S               Z   INZ
     D EndTStamp       S               Z   INZ
     D FormattedTm     S               T   TIMFMT(*HMS:)
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN ROUTINE                                                  *
      *                                                               *
      *****************************************************************
 
     C                   READ      ACNTDLL0
     C                   DOW       NOT %EOF(ACNTDLL0)
 
     C     ACCNTK        SETLL     RECOM
     C                   IF        NOT %EQUAL(RECOM)
 
     C/EXEC SQL
     C+ select * into :G_RECOM from GZRECOMD
     C+ where BRCA = :BRCA
     C+   and CNUM = :CNUM
     C+   and CCY  = :CCY
     C+   and ACOD = :ACOD
     C+   and ACSQ = :ACSQ
     C+ fetch first row only
     C/END-EXEC
 
     C                   IF        SQLCODE <> SQLOK AND
     C                             SQLCODE <> SQLEoF
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        SQLCODE <> SQLEoF
     C                   EVAL      I#BFAF = 'B'
     C                   EXSR      UPD_GLOBFILE
     C                   EXSR      UPD_SYNTOT
     C                   ENDIF
 
     C                   ENDIF
     C                   READ      ACNTDLL0
     C                   ENDDO
 
     C                   EXSR      WRT_SYNLOG
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      * UPD_GLOBFILE - Calls GPRECOMD program to update global file   *
      * Called By: Main Routine                                       *
      * Calls: GPRECOMD                                               *
      *                                                               *
      *****************************************************************
 
     C     UPD_GLOBFILE  BEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_RECOM
     C                   EVAL      I#AIMG = G_RECOM
      /COPY GPCPYSRCG,GPRECOMD
     C                   ENDSR
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * UPD_SYNTOT - Update Synchronization Totals                    *
      * Called By: Main Routine                                       *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     UPD_SYNTOT    BEGSR
 
      ** Do a search on branches and totals if array not empty
 
     C                   IF        TIdx <> 0
 
      ** If branch changed, perform search, otherwise,
      ** set current index to previous index
 
     C                   IF        G_BRCA <> Branch(PIdx)
     C                   EVAL      CIdx = %LOOKUP(G_BRCA : Branch :
     C                                            1 : TIdx)
     C                   ELSE
     C                   EVAL      CIdx = PIdx
     C                   ENDIF
 
     C                   ENDIF
 
      ** If not found, add entries to next available array element
      ** DBASE error when array capacity exceeded
 
     C                   IF        TIdx + 1 > ArrSize
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        CIdx = 0
     C                   EVAL      TIdx = TIdx + 1
     C                   EVAL      CIdx = TIdx
     C                   EVAL      Branch(CIdx) = G_BRCA
     C                   ENDIF
 
      ** Increment deleted record counter on branch
 
     C                   EVAL      Counts(CIdx).BSCntD =
     C                               Counts(CIdx).BSCntD + 1
 
      ** Increment Grand Totals on deleted records
 
     C                   EVAL      SYNTOTAL.BSCntD = SYNTOTAL.BSCntD + 1
 
      ** Set previous index to current index
 
     C                   EVAL      PIdx = CIdx
 
     C                   ENDSR
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * WRT_SYNLOG - Write to Synchronization Log                     *
      * Called By: Main Routine                                       *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     WRT_SYNLOG    BEGSR
 
      ** Write overall totals
 
     C                   EVAL-CORR G_LOGS = SYNTOTAL
     C                   EVAL      BSBRCA = '***'
 
     C                   EVAL      BSDATE = %CHAR(PSRunDate)
     C                   EVAL      BSJOB  = PSJobName
     C                   EVAL      BSUSER = PSUser
     C                   EVAL      BSJOBN = %CHAR(PSJobNo)
 
      ** Get sync job end time
 
     C                   EVAL      EndTStamp = %TIMESTAMP()
     C                   EVAL      FormattedTm = %TIME(EndTStamp)
     C                   EVAL      BSETIM = %CHAR(FormattedTm)
 
      ** Calculate duration of job in seconds unit
 
     C                   EVAL      BSTOS = %DIFF(EndTStamp :
     C                                           StartTSTamp :
     C                                           *SECONDS)
     C/EXEC SQL
     C+ insert into GPSBLOGPD
     C+ values :G_LOGS
     C/END-EXEC
 
     C                   IF        SQLCODE <> SQLOK
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Write branch totals
 
     C                   EVAL      CIdx = 1
     C                   DOW       CIdx <= TIdx
 
     C                   EVAL-CORR G_LOGS = Counts(CIdx)
     C                   EVAL      BSBRCA = Branch(CIdx)
 
     C/EXEC SQL
     C+ insert into GPSBLOGPD
     C+ values :G_LOGS
     C/END-EXEC
 
     C                   IF        SQLCODE <> SQLOK
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      CIdx = CIdx + 1
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation routine                               *
      * Called By: Automatically at first program call                *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE
 
      ** Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
 
      ** Delete existing log records
 
     C                   EVAL      BSFILE = 'GZRECOMD'
     C                   EVAL      BSZONE = I_ZONE
 
     C/EXEC SQL
     C+ delete from GPSBLOGPD
     C+  where BSFILE = :BSFILE
     C+    and BSZONE = :BSZONE
     C/END-EXEC
 
      ** Get sync job start time
 
     C                   EVAL      StartTStamp = %TIMESTAMP()
     C                   EVAL      FormattedTm = %TIME(StartTStamp)
     C                   EVAL      BSSTIM = %CHAR(FormattedTm)
 
     C                   ENDSR
      ********************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Subroutine to handle errors                           *
      * Called By: EXSR, Program Errors                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        NOT RunBefore
     C                   EVAL      RunBefore = True
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
