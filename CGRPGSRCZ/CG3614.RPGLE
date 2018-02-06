     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Get Status of print generator job')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3614 - Midas CG Midas CG Get Status of Print Generator job *
      *                                                               *
      *  Function:  This module will check whether the                *
      *             Print Generator job is active                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 17Oct01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
 
      ** Job Information format 0100
     DJobI0100         DS           256
     D JobI_ByteRtn                  10I 0
     D JobI_ByteAvl                  10I 0
     D JobI_JobName                  10A
     D JobI_UserID                   10A
     D JobI_JobNbr                    6A
     D JobI_IntJob                   16A
     D JobI_Status                   10A
     D JobI_Type                      1A
     D JobI_SbType                    1A
     D JobI_Reserv1                   2A
     D JobI_RunPty                   10I 0
     D JobI_TimeSlc                  10I 0
     D JobI_DftWait                  10I 0
     D JobI_Purge                    10A
 
      ** UDC data area
     D CgData        E DS                  EXTNAME(CGDTA) DTAARA(CGDTA)
     D DAPGJM                 55     80
 
      ** Get job information
     DGetJobInfo       PR           256
     D JobQual                       26    VALUE
 
     C                   EVAL      RtnCde = *BLANK
     C                   IN        CgData
      ** If job information are filled for one of the print generator
      ** jobs check whether they have terminated
     C                   IF        DABLK1 <> *BLANK OR
     C                             DABLK2 <> *BLANK OR
     C                             DABLK3 <> *BLANK OR
     C                             DABLK4 <> *BLANK OR
     C                             DABLK5 <> *BLANK OR
     C                             DABLK6 <> *BLANK OR
     C                             DAPGJM <> *BLANK
     C                   EXSR      CheckJobSts
     C                   ENDIF
 
     C                   SETON                                        LR
      *****************************************************************
      *                                                               *
      * Check Job Status                                              *
      *                                                               *
      *****************************************************************
     C     CheckJobSts   BEGSR
      *
     C                   EVAL      JobI0100 = GetJobInfo(DAPGJM)
     C                   IF        JobI_Status <> '*OUTQ'
     C                             AND JobI_Status <> '*NOT_FOUND'
     C                   EVAL      RtnCde = '*BUSY'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      JobI0100 = GetJobInfo(DABLK1)
     C                   IF        JobI_Status <> '*OUTQ'
     C                             AND JobI_Status <> '*NOT_FOUND'
     C                   EVAL      RtnCde = '*BUSY'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      JobI0100 = GetJobInfo(DABLK2)
     C                   IF        JobI_Status <> '*OUTQ'
     C                             AND JobI_Status <> '*NOT_FOUND'
     C                   EVAL      RtnCde = '*BUSY'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      JobI0100 = GetJobInfo(DABLK3)
     C                   IF        JobI_Status <> '*OUTQ'
     C                             AND JobI_Status <> '*NOT_FOUND'
     C                   EVAL      RtnCde = '*BUSY'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      JobI0100 = GetJobInfo(DABLK4)
     C                   IF        JobI_Status <> '*OUTQ'
     C                             AND JobI_Status <> '*NOT_FOUND'
     C                   EVAL      RtnCde = '*BUSY'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      JobI0100 = GetJobInfo(DABLK5)
     C                   IF        JobI_Status <> '*OUTQ'
     C                             AND JobI_Status <> '*NOT_FOUND'
     C                   EVAL      RtnCde = '*BUSY'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      JobI0100 = GetJobInfo(DABLK6)
     C                   IF        JobI_Status <> '*OUTQ'
     C                             AND JobI_Status <> '*NOT_FOUND'
     C                   EVAL      RtnCde = '*BUSY'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDSR
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
 
     C     *ENTRY        PLIST
      ** Return Code
      ** '*BUSY' the job has been launched and is either
      **           *ACTIVE or *JOBQ
     C                   PARM                    RtnCde            7
 
     C                   ENDSR
      *****************************************************************
      * Get job information                                           *
      *****************************************************************
     PGetJobInfo       B
     DGetJobInfo       PI           256
     D Job_Qual                      26    VALUE
 
     DApi_Format       S              8
     DJob_Int          S             16
     DInf_Len          S              4B 0
 
      ** Job Information format 0100
     DJob_Inf          DS           256
     D JobI_ByteRtn                  10I 0
     D JobI_ByteAvl                  10I 0
     D JobI_JobName                  10A
     D JobI_UserID                   10A
     D JobI_JobNbr                    6A
     D JobI_IntJob                   16A
     D JobI_Status                   10A
     D JobI_Type                      1A
     D JobI_SbType                    1A
     D JobI_Reserv1                   2A
     D JobI_RunPty                   10I 0
     D JobI_TimeSlc                  10I 0
     D JobI_DftWait                  10I 0
     D JobI_Purge                    10A
 
     C                   EVAL      Inf_Len = 256
 
     C                   CALL(E)   'QUSRJOBI'
     C                   PARM                    Job_Inf
     C                   PARM                    Inf_Len
     C                   PARM      'JOBI0100'    Api_Format
     C                   PARM                    Job_Qual
     C                   PARM      *BLANKS       Job_Int
 
     C                   IF        %ERROR
     C                   EVAL      JobI_Status = '*NOT_FOUND'
     C                   ENDIF
 
     C                   RETURN    Job_Inf
 
     P                 E
