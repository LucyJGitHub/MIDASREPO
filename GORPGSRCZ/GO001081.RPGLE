     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Populate Subsystem Data File')                *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO001081 - Midas GO Populate Subsystem Data File             *
      *                                                               *
      *  Function: To get active jobs information on a subsystem      *
      *            depending on the parameter passed:                 *
      *                                                               *
      *            If Mode = '*STAT', returns the status of the job   *
      *            specified on the Job Name parameter.               *
      *                                                               *
      *            If Mode = '*COUNT', returns the number of jobs w/  *
      *            status equal to the value of the Status parameter. *
      *                                                               *
      *            If Mode = '*OUTF', list all active jobs on the     *
      *            subsystem to PF/GOSBSDPD.                          *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD020696A          Date 01Jul13               *
      *                 MD020696 *CREATE   Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020696A - Insert parameter 'MODE' such that program will   *
      *              only get subsystem details depending on this     *
      *              parameter.                                       *
      *  MD020696 - Dashboard doesn't show proper value of Jobs in    *
      *             MSGW status. Use API to get active jobs from sub- *
      *             system instead of using the spooled file from     *
      *             WRKACTJOB *PRINT                                  *
      *                                                               *
      *****************************************************************
 
     FGOSBSDPD  O    E             DISK    INFSR(*PSSR)
 
      ** Prototype for API Create User Space
 
     D QUSCRTUS        PR                  EXTPGM('QUSCRTUS')
     D  QUsrSpc                      20A   CONST
     D  QExtAttr                     10A   CONST
     D  QInitialSize                 10I 0 CONST
     D  QInitialVal                   1A   CONST
     D  QPublicAuth                  10A   CONST
     D  QText                        50A   CONST
     D  QReplace                     10A   CONST
     D  QErrorCode                  256A   OPTIONS(*NOPASS:*VARSIZE)
 
      ** Prototype for API Retrieve User Space
 
     D QUSRTVUS        PR                  EXTPGM('QUSRTVUS')
     D  QRtvUserSpace                20A
     D  QRtvStartPos                 10I 0
     D  QRtvDataLen                  10I 0
     D  QRtvRcvrVar                  56A
     D  QErrorCode                  256A
 
      ** Prototype for API List Jobs
 
     D QUSLJOB         PR                  EXTPGM('QUSLJOB')
     D  QJobUsrSpace                 20A
     D  QJobFmtName                   8A   CONST
     D  QJobName                     26A
     D  QJobStatus                   10A   CONST
     D  QErrorCode                  256A
 
      ** Prototype for API Retrieve Job Information
 
     D QUSRJOBI        PR                  EXTPGM('QUSRJOBI')
     D  QRtvJobRcvVar               111A
     D  QRtvJobLenVar                10I 0
     D  QRtvJobFmtNme                 8A   CONST
     D  QRtvJobName                  26A
     D  QRtvJobIntID                 16A   CONST
     D  QErrorCode                  256A
 
      ** Prototype for API Delete User Space                                               MD020696A
                                                                                           MD020696A
     D QUSDLTUS        PR                  EXTPGM('QUSDLTUS')                              MD020696A
     D  QDltUsrSpc                   20A   CONST                                           MD020696A
     D  QErrorCode                  256A                                                   MD020696A
                                                                                           MD020696A
     D UserSpaceName   DS                  INZ
      ** User Space Name and Location
     D  UsrSpcName                   10A   INZ('SBSJOBS')
     D  UsrSpcLib                    10A   INZ('QTEMP')
 
     D QRTVUSVar       DS                  INZ
      ** Retrieved data attributes from QUSRTVJOB API
     D  UsrSpcOffset                 10I 0
     D  UsrReserved                  10I 0
     D  UsrSpcEntry                  10I 0
     D  UsrSpcEntSz                  10I 0
 
     D LJOB100Fmt      DS                  INZ QUALIFIED
      ** JOBL0100 Format Returned from QUSLJOB API
     D  LJobDetails            1     26
     D  LJobName               1     10
     D  LJobUsrNme            11     20
     D  LJobNumber            21     26
     D  LIntrnalJobID         27     42
     D  LJobStatus            43     52
     D  LJobType              53     53
     D  LJobSubType           54     54
     D  LReserved             55     56
 
     D RJOB200Fmt      DS                  INZ QUALIFIED
      ** JOBI0200 Format Returned from QUSRJOBI API
     D  RBytesReturn           1      4B 0
     D  RRytesAvail            5      8B 0
     D  RJobName               9     18
     D  RJobUsrNme            19     28
     D  RJobNumber            29     34
     D  RIntrnalJobID         35     50
     D  RJobStatus            51     60
     D  RJobType              61     61
     D  RJobSubType           62     62
     D  RSubsysName           63     72
     D  RActJobStat          108    111
 
     D APIError        DS                  INZ QUALIFIED
      ** API error handling structure
     D  ByteProvided                 10I 0
     D  ByteAvailable                10I 0
     D  MessageID                     7A
     D  Reserved                      1A
     D  ErrorInfo                   240A
 
      ** Entry Parameters
 
     D P_QualJobName   S             26A
     D P_Subsystem     S             10A
     D P_JobStatus     S              4A                                                   MD020696A
     D P_Mode          S              6A                                                   MD020696A
     D P_RtnStatus     S              4A                                                   MD020696A
     D P_RtnCount      S              5S 0                                                 MD020696A
 
      ** Work Variables
 
     D UsrSpcSize      S             10I 0
     D UsrSpcDesc      S             50A
     D StartPos        S             10I 0
     D LenOfData       S             10I 0
     D Counter         S              9P 0
     D W_RecvrVar      S             56A
     D W_RecvrLen      S             10I 0 INZ(111)
     D W_JobName       S             26A
 
     D  LDA          E DS                  INZ EXTNAME( LDA )
     D  @RUN           S              1A   INZ(*BLANKS)
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Processing Routine                                       *
      *                                                               *
      *****************************************************************
 
      ** Create user space for QUSLJOB API
 
     C                   CALLP     QUSCRTUS( UserSpaceName
     C                                     : 'USRSPC'
     C                                     : UsrSpcSize
     C                                     : x'00'
     C                                     : '*ALL'
     C                                     : UsrSpcDesc
     C                                     : '*YES'
     C                                     : APIError )
 
     C                   EXSR      ChkJobStats
 
      ** Delete the user space                                                             MD020696A
                                                                                           MD020696A
     C                   CALLP     QUSDLTUS( UserSpaceName                                 MD020696A
     C                                     : APIError )                                    MD020696A
                                                                                           MD020696A
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine at program startup                *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
                                                                                           MD020696A
      ** Input Parameter                                                                   MD020696A
                                                                                           MD020696A
     C                   PARM                    P_QualJobName
     C                   PARM                    P_Subsystem
     C                   PARM                    P_JobStatus                               MD020696A
     C                   PARM                    P_Mode                                    MD020696A
                                                                                           MD020696A
      ** Output Parameter                                                                  MD020696A
                                                                                           MD020696A
     C                   PARM                    P_RtnStatus                               MD020696A
     C                   PARM                    P_RtnCount                                MD020696A
 
      ** Set user space attributes
 
     C                   EVAL      UsrSpcSize = 5000
     C                   EVAL      UsrSpcDesc =
     C                               'Temporary Workspace for SBSJOBS'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkJobStats - Check Job Status Subroutine                     *
      *                                                               *
      *****************************************************************
     C     ChkJobStats   BEGSR
 
      ** Call QUSLJOB API to list the active jobs
 
     C                   CALLP     QUSLJOB( UserSpaceName
     C                                    : 'JOBL0100'
     C                                    : P_QualJobName
     C                                    : '*ACTIVE'
     C                                    : APIError )
 
     C                   IF        APIError.MessageID <> ' '
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Run QUSRTVUS API to get user space data attributes
      ** These attributes starts at position 125
 
     C                   EVAL      StartPos  = 125
     C                   EVAL      LenOfData = 16
 
     C                   CALLP     QUSRTVUS( UserSpaceName
     C                                     : StartPos
     C                                     : LenOfData
     C                                     : W_RecvrVar
     C                                     : APIError )
 
     C                   IF        APIError.MessageID <> ' '
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve the Job List Entries
 
     C                   EVAL      QRTVUSVar = W_RecvrVar
     C                   EVAL      StartPos  = UsrSpcOffset + 1
     C                   EVAL      LenOfData = UsrSpcEntSz
     C                   EVAL      Counter = 1
 
      ** Begin reading entries from user space data
 
     C                   DOW       Counter <= UsrSpcEntry
 
     C                   CALLP     QUSRTVUS( UserSpaceName
     C                                     : StartPos
     C                                     : LenOfData
     C                                     : LJOB100Fmt
     C                                     : APIError )
 
     C                   IF        APIError.MessageID <> ' '
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Using the retrieved job details,
      ** call QUSRJOBI API to get the active jobs information
 
     C                   EVAL      W_JobName = LJOB100FMT.LJobDetails
 
     C                   CALLP     QUSRJOBI( RJOB200Fmt
     C                                     : W_RecvrLen
     C                                     : 'JOBI0200'
     C                                     : W_JobName
     C                                     : ' '
     C                                     : APIError )
 
     C                   IF        APIError.MessageID <> ' '
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Output the retrieved data for the subsystem's active jobs
 
     C                   IF        RJOB200Fmt.RSubsysName =
     C                             P_Subsystem
                                                                                           MD020696A
     C                   IF        P_Mode = '*STAT' and                                    MD020696A
     C                             %SUBST(P_QualJobName:1:10) =                            MD020696A
     C                             RJOB200Fmt.RJobName                                     MD020696A
     C                   EVAL      P_RtnStatus = RJOB200Fmt.RActJobStat                    MD020696A
     C                   ENDIF                                                             MD020696A
                                                                                           MD020696A
     C                   IF        P_Mode = '*COUNT' and                                   MD020696A
     C                             P_JobStatus = RJOB200Fmt.RActJobStat                    MD020696A
     C                   EVAL      P_RtnCount = P_RtnCount + 1                             MD020696A
     C                   ENDIF                                                             MD020696A
                                                                                           MD020696A
     C                   IF        P_Mode = '*OUTF'                                        MD020696A
     C                   EVAL      FSUBSYS  = RJOB200Fmt.RSubsysName
     C                   EVAL      FJOBNAM  = RJOB200Fmt.RJobName
     C                   EVAL      FJOBUSR  = RJOB200Fmt.RJobUsrNme
     C                   EVAL      FJOBNBR  = RJOB200Fmt.RJobNumber
     C                   EVAL      FJOBSTAT = RJOB200Fmt.RActJobStat
     C                   WRITE     GOSBSDD0
     C                   ENDIF                                                             MD020696A
                                                                                           MD020696A
     C                   ENDIF
 
     C                   EVAL      StartPos = StartPos + LenOfData
     C                   EVAL      Counter = Counter + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Error Handling Subroutine                             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANKS
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
