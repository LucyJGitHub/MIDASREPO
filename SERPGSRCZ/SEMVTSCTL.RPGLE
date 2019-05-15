     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Interface Controller')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSCTL - Movements Status Interface Controller      *
      *                                                               *
      *  Function: This Program Validates Movements Status      for   *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE039  *CREATE    Date 27Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEVMVTSPD UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SEVMVTSD0:SEVMVTSDD)
     F                                     COMMIT
      ** Valid Movements Status File
 
     FSEIMVTSPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Invalid Movements Status File
 
     FSEVMVTSL0 IF   E           K DISK    INFSR(*PSSR)
      ** Valid Movement Status by Front Office Id.
 
     FSEVMVTSL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEVMVTSD0:SEVMVTSD1)
      ** Valid Movement Status by Movement Key (without sequence) and Timestamp
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      /COPY WNCPYSRC,SEMVTSC001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      **Incoming Header
 
     D NewScnIFld    E DS                  EXTNAME(SEMVTS1PD)
      ** Incoming Movement in screen format - Input/output fields
 
     D NewScnOFld    E DS                  EXTNAME(SEMVTS2PD)
      ** Incoming Movement in screen format - Output only fields
 
     D ExtData       E DS                  EXTNAME(SEMVEXPD)
      ** Incoming Movement Extra Data in screen format
 
     D NewSEMVTS     E DS                  EXTNAME(SEVMVTSPD)
      ** Valid Movement Status layout
 
     D SEMVTS        E DS                  EXTNAME(SEMVTSPD)
      ** (Current) Movement Status in file format
 
     D CurScnIFld    E DS                  EXTNAME(SEMVTS1PD) PREFIX(C_)
      ** (Current) Movement in screen format - Input/output fields
 
     D CurScnOFld    E DS                  EXTNAME(SEMVTS2PD) PREFIX(C_)
      ** (Current) Movement in screen format - Output only fields
 
     D OKMvtFlags    E DS                  EXTNAME(SEEMVTSPD)
      ** Error indicators
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access programs - long data structure
 
      ** Split up of the Movement Reference
     D DDMvtRef        DS
     D  DDMvtTRRF                     6A
     D  DDMvtTRTY                     1A
     D  DDMvtNTDT                     6A
     D  DDMvtSQNR                     3S 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('SEMVTSUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,SEMVTSC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SEMVTSC003
 
      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.
      *
     C                   MOVEL     Trans5001     NewScnIfld
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
      *
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,SEMVTSC004
 
      ** Check if valid Movement Status details exists (Front Office Id.)
      *
     C                   EXSR      ChkValFrnt
      *
      ** If valid movement details does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Check if valid Movement Status details exists (Midas Reference)
      *
     C                   EXSR      ChkValMids
      *
      ** If valid Transaction does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid Transaction details file.
      *
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,SEMVTSC005
 
      ** Validate Action Code
      *
     C                   EXSR      ValAction
 
      /COPY WNCPYSRC,SEMVTSC006
 
      ** If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing depends upon Action Code
      *
     C                   SELECT
      ** Processing for Inserts
     C                   WHEN         DDACTN = 'I'
      *
      /COPY WNCPYSRC,SEMVTSC007
      *
     C                   EXSR      ValidateMv
      *
      /COPY WNCPYSRC,SEMVTSC008
      *
      ** Processing for Amends or Changes
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
      *
      /COPY WNCPYSRC,SEMVTSC009
      *
     C                   EXSR      CvtMvts
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        DDACTN = 'A' AND GHSUBS <> *BLANK AND
     C                             %Scan(GHSUBS:NewScnIFld) > 0
     C                   EXSR      DtaSubs
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEMVTSC010
      *
     C                   EXSR      ValidateMv
      *
      /COPY WNCPYSRC,SEMVTSC011
      *
     C                   ENDSL
 
     C     INVALID       TAG
      *
      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program
      *
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,SEMVTSC012
 
 B1  C                   IF        ARERRMOD <> *BLANK
     C                   EVAL      MQErrLong = 'Error in module ' + ARERRMOD
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
      *
 X1  C                   ELSE
      *
      ** Processing for Error checking/write to database
      *
      /COPY WNCPYSRC,SEMVTSC013
      *
     C                   EXSR      CheckWrite
      *
      /COPY WNCPYSRC,SEMVTSC014
      *
      ** If valid, send data queue entry to prompt DB update program
      *
 B2  C                   IF        Idx = 0
      *
      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *Blank        Return
      *
 B3  C                   IF        Return = *Blank
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
      /COPY ZACPYSRC,DTAQCHK
      *
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEMVTSC015
 
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      * ChkValFrnt - Check if the Front Office Id. already exists in the valid file
      ********************************************************************
     C     ChkValFrnt    BEGSR
      *
     C     APFOTRANID    CHAIN     SEVMVTSD0
      *
      ** If record found...
      *
     C                   IF        %Found(SEVMVTSL0)
      *
      ** ..delay, then repeat check
      *
     C                   CALLB     'ZACDELAY'
      *
     C     APFOTRANID    CHAIN     SEVMVTSD0
      *
      ** Error if still present
      *
     C                   IF        %Found(SEVMVTSL0)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTRRF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkValMids - Check if the Midas Reference already exists in the valid file
      *****************************************************************
     C     ChkValMids    BEGSR
      *
      ** Key list for file SEVMVTSL1
      *
     C     KSEVMVTSL1    KLIST
     C                   KFLD                    VTMTRRF
     C                   KFLD                    VTMTRTY
     C                   KFLD                    VTMNTDT
      *
      ** Setup key
      *
     C                   EVAL      VTMTRRF = DDTRRF
     C                   EVAL      VTMTRTY = DDTRTY
      *
     C                   IF        DDNTDT <> *Blanks
     C                   CALLB     'ZDATE1'
     C                   PARM      DDNTDT        DateIn            6
     C     VTMNTDT       PARM                    DaynoOut          5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
     C                   ELSE
     C                   EVAL      ErrorFlag = 'Y'
     C                   ENDIF
      *
      ** If the key seems Ok
      *
     C                   IF        DDTRRF <> *Blanks AND
     C                             (DDTRTY = 'W' OR DDTRTY = 'T'
     C                                           OR DDTRTY = 'D') AND
     C                             ErrorFlag <> 'Y'
      *
      ** Check for Transaction on Valid file
      *
     C     KSEVMVTSL1    CHAIN     SEVMVTSD1
      *
      ** If record found...
      *
     C                   IF        %Found(SEVMVTSL1)
      *
      ** ..delay, then repeat check
      *
     C                   CALLB     'ZACDELAY'
      *
     C     KSEVMVTSL1    CHAIN     SEVMVTSD1
      *
      ** Error if still present
      *
     C                   IF        %Found(SEVMVTSL1)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTRRF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValAction  - Routine to validate action code versus the
      *              Front Office Id. / Midas Reference supplied
      *****************************************************************
     C     ValAction     BEGSR
      *
      ** If Insert, ensure that the related transaction exists and is correct
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      ValIMvts
     C     Idx           CABGT     0             EndValAct
     C                   ENDIF
      *
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas Movement Reference is not present
      **  (including a check for the existence of the replacement character
      **   at the Midas Movement Reference level).
      **  (Please note that ErrorFlag has been set up in ChkValMids).
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas Movement Reference).
      *
      **  We assume no substitution has been defined for the transaction ID
      *
     C                   EVAL      DDMvtTRRF = DDTRRF
     C                   EVAL      DDMvtTRTY = DDTRTY
     C                   EVAL      DDMvtNTDT = DDNTDT
     C                   EVAL      DDMvtSQNR = DDSQNR
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   MOVEL     DDSQNR        WWTEST4           4
     C                   MOVE      '0'           WWTEST4
     C                   TESTN                   WWTEST4              99
      *
     C                   IF        DDTRRF = *Blanks OR (DDTRTY <> 'T'
     C                              AND DDTRTY <> 'W' AND DDTRTY <> 'D') OR
     C                             ErrorFlag = 'Y' OR NOT *IN99 OR
     C                             %Scan(GHSUBS:DDMvtRef) > 0
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeofOp = *Blanks
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate action code versus Movement IDs supplied
      ** The Movement in file format from the SE database is retrieved
      ** as well.
      *
     C                   CALLB     'SEMVTSRTV'
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM      *Blanks       RetCodeOut
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      ** Response mode (no SPF checking required)
     C                   PARM      *Blank        RespMode          1
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Front Office Transaction ID
     C                   PARM      APFOTRANID    FOTRID           20
      ** (Midas) Movement Reference
     C                   PARM                    DDMvtRef
      *
      ** INPUT/OUPUT PARAMETERS
      ** Booking Branch of the linked Transaction (trade or DPMV)
     C                   PARM                    P@BRCA
      *
      ** OUPUT PARAMETERS
      ** Transaction Details in File Format
     C                   PARM                    SEMVTS
      ** OK - Action code and first key field of the movement reference
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDTRRFOK          1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
     C     EndValAct     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValIMvts - Verify that the linked transaction exists and is valid
      *****************************************************************
     C     ValIMvts      BEGSR
      *
      ** Call the retrieve transaction module
      *
     C                   CALLB     'SEMVTSRTT'
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeOut
      ** Transaction Reference
     C                   PARM                    DDTRRF
      *
      ** INPUT/OUTPUT PARAMETERS:
      ** Transaction Type
     C                   PARM      DDTRTY        P@TRTY            1
      *
      ** OUTPUT PARAMETERS:
      ** OK Indicators
     C                   PARM                    DDTRRFOK          1
     C                   PARM                    DDTRTYOK          1
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
      ** Booking Branch and Date of the retrieved Transaction
     C                   PARM                    P@BRCA            3
     C                   PARM                    P@TRDT            5 0
      *
      ** If there is no error, verify that there can be no confusion on
      ** the transaction type
      *
     C                   IF        DDTRTY <> *Blank
      *
     C                   IF        Idx = 0 AND DDTRTY <> P@TRTY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'SE03931'
     C                   EVAL      MsgDtaArr(Idx)  = DDTRTY + P@TRTY
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        Idx = 0
     C                   EVAL      DDTRTY = P@TRTY
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CvtMvts - Convert the current file record into screen fields
      *****************************************************************
     C     CvtMvts       BEGSR
      *
      ** Put the complete (pre-existing) Movement into the Valid
      ** file record - fields in this will be updated during processing
      *
     C                   MOVE      SEMVTS        NewSEMVTS
      *
      ** Convert the Movement Status record to screen format
      *
     C                   CALLB     'SEMVTSCVT'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Movement Details in file format
     C                   PARM                    SEMVTS
      *
      ** OUTPUT PARAMETERS
      ** (Current) Movement in screen format - Input/output fields
     C                   PARM                    CurScnIFld
      ** (Current) Movement in screen format - Output only fields
     C                   PARM                    CurScnOFld
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      * ValidateMv - Movement Status Details validation
      ******************************************************************
     C     ValidateMv    BEGSR
      *
     C                   CALLB     'SEMVTSVAL'
      ** INPUT PARAMETERS
      ** Movement Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields (No utility for the CTL function)
     C                   PARM                    NewScnOFld
      ** Current Transaction Details in screen format
     C                   PARM                    CurScnIfld
      ** Calling Module Code (*SIN, *RPR, etc...)
     C                   PARM      '*CTL'        CallerCode        4
      ** Date of the linked Transaction
      ** (from the RTT module, used only in insert mode)
     C                   PARM                    P@TRDT
      *
      ** OUTPUT PARAMETERS
      ** Transaction Details OK inds
     C                   PARM                    OKMvtFlags
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    NewSEMVTS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DtaSubs - Data Substitution
      *****************************************************************
     C     DtaSubs       BEGSR
      *
      ** Substitute the data for the various parts of the movement,
      *
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'APDTASUBS'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Substitution character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      NewScnIfld    IncData        2000
      ** Current Data
     C                   PARM      CurScnIFld    CurData        2000
      *
     C                   MOVEL     IncData       NewScnIFld
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *****************************************************************
     C     CheckWrite    BEGSR
      *
      ** If no errors were found:
      **    - set up additional data
      **    - write a record to the Valid file
      **    - use std message handler to report transaction status
      ** If any errors were found:
      **    - write a record to the Invalid file
      **    - call the message handler to pass the errors back
      **    - use std message handler to report transaction status
      ** The index to the error arrays is checked for presence/absence of
      **  errors
      *
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
      *
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   WRITE     SEVMVTSDD
     C                   EXSR      CallMsgHdl
     C                   ENDIF
      *
     C     Idx           IFGT      0
     C                   EXSR      SetupInval
      *
      ** Only write to invalid files if repair in back office
      *
     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     SEIMVTSD0
     C                   ENDIF
      *
     C                   EXSR      CallMsgHdl
     C                   ENDIF
      *
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetCycle- Reset error information that is gradually
      *    updated during each run of this program
      *****************************************************************
     C     ResetCycle    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
     C                   RESET                   FldNoArr
      *
     C                   CLEAR                   NewScnOFld
     C                   CLEAR                   CurScnIFld
     C                   CLEAR                   CurScnOFld
     C                   MOVE      *ALL'Y'       OKMvtFlags
     C                   CLEAR                   NewSEMVTS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupInval - Set up additional fields that are needed on the
      *        invalid file record.
      *****************************************************************
     C     SetupInval    BEGSR
      *
      ** Include Header fields that need to be o/p to the Invalid files
      *
     C                   EVAL      DDFOTRANID = APFOTRANID
     C                   EVAL      DDFOASOCID = APFOASOCID
     C                   EVAL      DDRPRLOCN  = APRPRLOCN
     C                   MOVE      TimeStamp     DDTMESTMP
      *
      ** Transaction Status and Midas Transaction Reference
      ** for use by the message handler
      *
     C                   EVAL      TranStatus = 'F'
      *
     C                   EVAL      DDMvtTRRF = DDTRRF
     C                   EVAL      DDMvtTRTY = DDTRTY
     C                   EVAL      DDMvtNTDT = DDNTDT
     C                   EVAL      DDMvtSQNR = DDSQNR
      *
      /COPY WNCPYSRC,SEMVTSC016
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupValid - Set up additional fields that are needed on the
      *    Valid file record.
      *****************************************************************
     C     SetupValid    BEGSR
      *
      ** Set Valid file field(s) that are needed for all Action Codes
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      VTMTRBB = P@BRCA                             From RTT Module
     C                   ENDIF
      *
     C                   EVAL      VTMLCTP = DDACTN
      *
      ** Include Header fields that need to be o/p to the Valid file
      *
     C                   EVAL      VTMFRNT = APFOTRANID
     C                   EVAL      VTMAFRT = APFOASOCID
     C                   EVAL      VTMREPA = APRPRLOCN
      *
      ** Transaction Status and Midas Transaction Reference
      ** for use by the message handler
      *
     C                   EVAL      TranStatus = 'S'
      *
     C                   EVAL      DDMvtTRRF = VTMTRRF
     C                   EVAL      DDMvtTRTY = VTMTRTY
     C                   EVAL      DDMvtNTDT = DDNTDT
     C                   EVAL      DDMvtSQNR = VTMSQNR
      *
      *
      /COPY WNCPYSRC,SEMVTSC017
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CallMsgHdl - Call the Message Handling module                 *
      *****************************************************************
     C     CallMsgHdl    BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
      *
     C     1             DO        ArrayMax      Ix
      *
     C                   IF        FldNameArr(Ix) <> *blanks
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C   20              EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRPRLOCN
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCNFVALFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTRANID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (6A, from caller)
     C                   PARM                    DDMvtRef
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRESPMODE
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRPYQUEUE
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      ** Common header information (DS) from source system
     C                   PARM                    HeadIn
      ** Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Set up the Module ID, used to make the Transaction number unique
      *
     C                   EVAL      ModuleID = 'SE'
      *
      ** Access Bank details via access program
      ** (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access API ICD via access program
      ** (database error handling done in access program)
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APMVTSDTQ'
      *
      /COPY WNCPYSRC,SEMVTSC018
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
