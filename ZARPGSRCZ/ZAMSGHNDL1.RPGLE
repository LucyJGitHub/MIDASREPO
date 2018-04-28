     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA API Message handler')
      *****************************************************************
      *                                                               *
      *  Midas - Common Routines                                      *
      *                                                               *
      *  ZAMSGHNDL1 - API Message handler                             *
      *                                                               *
      *  Function:  This module sends messages to the program message *
      *             queue, or deals with them otherwise, depending    *
      *             on the source of the transaction.                 *
      *                                                               *
      *  Component of: ZAMESSAGE - ZA messages service program        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG27041           Date 01Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27041 - Incorrect mapping for MQ STCQ                     *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
     FZATRNLOGPDO  A E             DISK    INFSR(*PSSR)
      ** Transaction log file
     F                                     COMMIT
 
      ** Note that the commit or rollback for these files will be done
      ** in the controlling component.
 
     FZATRNERRPDO  A E             DISK    INFSR(*PSSR)
      ** Transaction error messages file
     F                                     COMMIT
 
      *****************************************************************
      **
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARR1
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The name of the screen message handling procedure
     D SndScnMsg       C                   CONST('ZAMSGTOSCN')
 
      ** The name of procedure to clear the program messages
     D ClrPgmMsg       C                   CONST('ZAMSGCLRPG')
 
      ** The name of the procedure to send messages to the front office
     D SndFOMsg        C                   CONST('ZAMSGTOFO')
 
      ** The name of the procedure to send messages to the System Operator
     D MsgToOper       C                   CONST('ZAMSGTOOPR')
 
      ** The name of the procedure to get the complete message from a
      ** message file
     D RtvCompMsg      C                   CONST('ZAMSGRTVMS')
 
      ** The name of the procedure to find the start of the blanks at the
      ** end of a string
     D FndStrEnd       C                   CONST('ZASTREND')
 
      ** The maximum number of messages to process for Front Office
      ** notification
     D MaxMessage      C                   CONST(10)
 
      ** Literal for confirmation message header
     D ConfirmTxt      C                   CONST('MCONFIRM')
 
      ** Literal for error message header
     D ErrorTxt        C                   CONST('MTOTERR ')
 
      ** Literal for system name
     D SystemName      C                   CONST('MIDAS   ')
 
      ** The length of the MQDetail field
     D MQDetLen        C                   CONST(102)
 
      ** Mapping location for MQ message header
     D MQMapLoc        C                   CONST('A')
 
      ** Number of parameters before the message file array (used
      ** to check whether the array has been passed)
     D ParmB4MsgF      C                   CONST(19)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Data Structures and Arrays           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** List of field numbers (Array of <ArrayMax> 5,0 packed
     D FldNoArray      S              5P 0 DIM(ArrayMax3)
 
     D MsgHeader     E DS                  EXTNAME(APHEADPD)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Front office transaction identifier (20A, from caller)
     D FrontOffID      S             20A
 
     D Ix              S              5P 0 INZ(1)
 
      ** Confirmation of validation to front office received from caller
     D CnfValFrtO      S              1A
 
      ** Position within the string
      ** (Integer variable could not be used because of compatibility
      ** problems with supporting earlier releases.  Possible reinstate at
      ** a later date.)
     D Pos             S              5P 0
 
      ** Midas module ID (2A, from caller)
     D ModuleID        S              2A
 
      ** Transaction status (1A, from caller (F=Failure, S=Success))
     D TranStatus      S              1A
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     D RespMode        S              1A
 
      ** Queue to send front office response to
     D Queue           S             20A
 
      ** Maximum length queue used in call to message sending routine
     D Queue48         S             48A
 
      ** String to send return message to MQSeries
     D MQString        S           1228A
 
      ** Detailed information for a single error message for the MQSeries
      ** mesage
     D MQDetail        S            102A
 
      ** Count of Midas error messages that have been added to the string
      ** to send to MQSeries
     D MQDetCount      S              2P 0 INZ(0)
 
      ** The length of the string being scanned
      ** (Integer variable could not be used because of compatibility
      ** problems with supporting earlier releases.  Possibly reinstate at
      ** a later date.)
     D StringLen       S              5P 0
 
      ** Complete, expanded message text
     D CompMsg         S                   LIKE(ABMSGTEXT)
 
      ** Temporary alphanumeric version for the current field number
     D FldNoAlpha      S              5A
 
      ** Level of message to return (0 = both, 1 = first level only,
      ** 2 = second level only)
     D Level           S              1A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Midas Transaction ID
     D WTRANSID        S             20A
 
      ** Dummy message ID and message file fields for use on the call to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S                   LIKE(ABMSGFILE)
 
      ** Work version of message file
     D MessageF        S                   LIKE(ABMSGFILE)
 
      ** Index to the message file array
     D MFIdx           S              3P 0 INZ(1)
 
      ** Whether or not to clear to program message queue
     D ClearPgmQ       S              1A
 
      ** Length of message header file format
     D MQHeadLen       S              5P 0
 
      ** File name for passing to UTGETRCDLN
     D FileName        S             10A   INZ('APHEADPD')
 
      ** Library name for passing to UTGETRCDLN
     D FileLib         S             10A   INZ('*LIBL')
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** Program, procedure and module names for parameters
      ** ==================================================
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Ensure the array index is reset, to prevent problems on
      ** calls after the first one.
     C                   RESET                   Ix
 
      ** Pass control to the appropriate subroutine, depending on whether
      ** the deal was valid or not (status = 'S' for success or 'F' for
      ** failure).
 
     C                   IF        TranStatus = 'S'
     C                   EXSR      ValidTran
 
     C                   ELSE
 
     C                   EXSR      FailedTran
     C                   ENDIF
 
      ** Write Log File entry
      ** (Now only done if repair location is not 'S', as we do not
      ** want a log file entry when transactions are being entered
      ** from a Midas screen)
 
     C                   IF        DealRprLoc <> 'S'
     C                   EXSR      WriteLogF
     C                   ENDIF
 
      **  If errors occurred, set return code
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidTran - Process transactions without errors               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     ValidTran     BEGSR
 
      ** Only anything to do here if notification of validity to front
      ** office is required.
 
     C                   IF        CnfValFrtO = 'Y'
 
     C                   RESET                   MQString
 
      ** Set up the transaction-specific message header fields
 
     C                   EXSR      SetupHead
 
     C                   EVAL      APTGTTYPE = ConfirmTxt
     C                   EVAL      MQString = MsgHeader + ModuleID +
     C                                        WTRANSID
 
 
      ** Place queue name into maximum length string and then call routine
      **  to pass string to MQ
 
     C                   RESET                   ReturnCode
     C                   EVAL      Queue48 = Queue
     C                   CALLB     SndFOMsg
     C                   PARM                    ReturnCode
     C                   PARM                    Queue48
     C                   PARM                    MQString
 
      ** If return code is not blank, end in error
 
     C                   IF        ReturnCode <> *blanks
     C                   EXSR      FOMsgErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FailedTran - Process transactions with errors                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: MsgToFile, MsgToFront, MsgToScrn                       *
      *                                                               *
      *****************************************************************
 
     C     FailedTran    BEGSR
 
     C                   SELECT
 
      ** If repair location = 'B', messages are to be written to file
 
     C                   WHEN      DealRprLoc = 'B'
     C                   EXSR      MsgToFile
 
      ** Send message to Front Office if confirmation flag set
 
     C                   IF        CnfValFrtO = 'Y'
     C                   EXSR      MsgToFront
     C                   ENDIF
 
      ** If repair location = 'F', messages are to be sent back to the
      ** front office
 
     C                   WHEN      DealRprLoc = 'F'
 
     C                   EXSR      MsgToFront
 
      ** If repair location = 'S', messages are to be sent to the screen
 
     C                   WHEN      DealRprLoc = 'S'
     C                   EXSR      MsgToScrn
 
      ** If repair location is anything else (which shouldn't happen)
      ** default to the back office
 
     C                   OTHER
     C                   EXSR      MsgToFile
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MsgToFile - Write error messages to file                      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: GetCompMsg                                             *
      *                                                               *
      *****************************************************************
 
     C     MsgToFile     BEGSR
 
      ** Set up common data for the error message file records
 
     C                   EVAL      ABFOTRNID = FrontOffID
     C                   EVAL      ABMIDASMOD = ModuleID
     C**********         EVAL      ABMIDTRNID = WTRANSID                                    BUG27041
     C                   EVAL      ABMIDTRID2 = WTRANSID                                    BUG27041
 
      ** CAP003: Ensure that ABMSGFILE is set up with the value returned
      ** by GetCompMsg; replace #MsgFile below with MessageF after call
      ** to GetCompMsg
 
     C                   EVAL      ABTMESTMP = TimeStamp
 
      ** Work through the field numbers array until zero is encountered
      ** or the maximum size of the array is reached
 
     C                   DOW       FldNoArray(Ix) <> 0
     C                             AND Ix <= ArrayMax3
 
      ** Set the message text level field to get both first and second
      ** level text
 
     C                   EVAL      Level = '0'
 
      ** Get the complete message text
 
     C                   EXSR      GetCompMsg
 
      ** Set up the message-specific file fields
     C
     C                   EVAL      ABMSGFILE = MessageF
     C                   EVAL      ABFIELDID = FldNoArray(Ix)
     C                   EVAL      ABFIELDNAM = FldNameAr2(Ix)
     C                   EVAL      ABMSGID = MsgIDAr2(Ix)
     C                   EVAL      ABMSGTEXT = CompMsg
 
     C                   WRITE     ZATRNERRD0
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MsgToFront - Send error messages to front office              *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: GetCompMsg                                             *
      *                                                               *
      *****************************************************************
 
     C     MsgToFront    BEGSR
 
      **  Put header information into string for MQSeries (Message type,
      **  System name, FO transaction ID and Midas transaction ID)
 
     C                   RESET                   MQString
 
      ** Set up the transaction-specific message header fields
 
     C                   EXSR      SetupHead
 
     C                   EVAL      APTGTTYPE = ErrorTxt
     C                   EVAL      MQString = MsgHeader + ModuleID +
     C                                        WTRANSID
 
      ** No need to send details of error messages if this is just a
      ** validity confirmation message. Therefore only send if message
      ** is due to be repaired in the front office
 
     C                   IF        DealRprLoc = 'F'
 
      ** Reset the count of detailed messages added to the string for MQ
     C                   RESET                   MQDetCount
 
      ** Work through the field numbers array until zero is encountered
      ** or the maximum size of the array or the maximum number of messages
      ** to send to the front office is reached.
 
     C                   DOW       FldNoArray(Ix) <> 0
     C                             AND Ix <= ArrayMax3 AND Ix <= MaxMessage
 
      ** Set the message text level field to get only the first-level text
 
     C                   EVAL      Level = '1'
 
      ** Get the complete message text
 
     C                   EXSR      GetCompMsg
 
      ** Put the current field number into an alpha field so that it can
      ** be concatenated.
 
     C                   MOVEL     FldNoArray(Ix)FldNoAlpha
 
      ** Add the error message details to the the end of the string for MQ
 
     C                   EXSR      AddToStr
 
      ** Increment the count of detailed messages added to the string
 
     C                   EVAL      MQDetCount = MQDetCount + 1
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
     C                   ENDIF
 
      ** Place queue name into maximum length string and then call routine
      ** to pass string to MQ
 
     C                   RESET                   ReturnCode
     C                   EVAL      Queue48 = Queue
     C                   CALLB     SndFOMsg
     C                   PARM                    ReturnCode
     C                   PARM                    Queue48
     C                   PARM                    MQString
 
      ** If return code is not blank, end in error
 
     C                   IF        ReturnCode <> *blanks
     C                   EXSR      FOMsgErr
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AddToStr - Add a detail error message to the MQSeries string  *
      *                                                               *
      * Called by: MsgToFront                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     AddToStr      BEGSR
 
      ** Set up a detail message for MQSeries.  It contains details of the
      ** field in error, the message ID, and the first 80 characters of
      ** the complete message text (ie the first-level text as it would
      ** appear on a conventional 5250 screen).
 
     C                   RESET                   MQDetail
     C                   EVAL      MQDetail = FldNoAlpha +
     C                                        FldNameAr2(Ix) +
     C                                        MsgIDAr2(Ix) +
     C                                        %SUBST(CompMsg : 1 : 80)
 
      ** Put the detail message into the current postion in the overall
      ** string for MQ.  This is determined by the header length plus the
      ** count of detailed entries times the number of detailed entries.
      ** The count starts at zero, so the first time through only the
      ** header length is effective.
 
     C                   EVAL      %SUBST(MQString : (MQHeadLen +
     C                                   MQDetCount * MQDetLen + 1) :
     C                                   MQDetLen) = MQDetail
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MsgToScrn - Send error messages to screen handler             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ZAMSGTOSCN                                             *
      *                                                               *
      *****************************************************************
 
     C     MsgToScrn     BEGSR
 
      ** Check whether clearing the program message queue has been
      ** requested; if the number of parameters passed is such that the
      ** array of additional message files, and hence the clear program
      ** queue flag have NOT been passed, default to clearing the
      ** queue.
 
     C                   IF        PSNoOfParm = ParmB4MsgF
     C                   CLEAR                   ClearPgmQ
     C                   ENDIF
 
     C                   IF        ClearPgmQ <> 'N'
 
      ** Before sending the messages to the program message queue,
      ** clear the program message queue
 
     C                   CALLB     ClrPgmMsg
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
     C                   ENDIF
 
      ** Work through the field numbers array until zero is encountered
      ** or the maximum size of the array is reached
      ** CAP003: change this to use the field name array until blanks
      ** are encountered.  This makes calling this function from a screen
      ** display function (*DSP) easier, as those functions don't have
      ** the field numbers.
 
     C                   DOW       FldNameAr2(Ix) <> *blanks
     C                             AND Ix <= ArrayMax3
 
     C                   EVAL      #MsgID = MsgIDAr2(Ix)
     C                   EVAL      #MsgData = MsgDtaAr2(Ix)
 
      ** Add a call to GetCompMsg here: the complete message details are
      ** not required by this subroutine, but it will have the effect
      ** of determining which message file the message is in, if more
      ** than one name is specified.  Then change the parameter on the call
      ** to SndScnMsg (ZAMSGTOSCN) to use MessageF instead of #MsgFile.
 
     C                   EXSR      GetCompMsg
 
      **  Call screen message handler
 
     C                   CALLB     SndScnMsg
     C                   PARM                    MessageF
     C                   PARM                    #MsgID
     C                   PARM                    #MsgData
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
     C                   Eval      Ix = Ix + 1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteLogF - Write Log File record                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     WriteLogF     BEGSR
 
      ** Put the appropriate data into the log file fields
 
     C                   EVAL      AAFOTRNID  = FrontOffID
     C                   EVAL      AAMIDASMOD = ModuleID
     C**********         EVAL      AAMIDTRNID = WTRANSID                                    BUG27041
     C                   EVAL      AAMIDTRID2 = WTRANSID                                    BUG27041
     C                   EVAL      AAACTNCODE = ActionCode
 
      ** Set action code to consistent value for deletions/reversals
 
     C                   IF        ActionCode = 'R'
     C                   EVAL      AAACTNCODE = 'D'
     C                   ENDIF
     C                   EVAL      AARESPMODE = RespMode
     C                   EVAL      AARPRLOC   = DealRprLoc
     C                   EVAL      AACNFVALFO = CnfValFrtO
     C                   EVAL      AASTATUS   = TranStatus
     C                   EVAL      AATMESTMP  = TimeStamp
 
     C                   WRITE     ZATRNLOGD0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      * GetCompMsg - Get complete message text from the message ID    *
      *                                                               *
      * Called by: MsgToFile, MsgToFront, MsgToScrn                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GetCompMsg    BEGSR
 
      ** Set up message file library for library list search
 
     C                   EVAL      #MsgFLib = '*LIBL'
 
      ** Set up message ID and data parameters
 
     C                   EVAL      #MsgID = MsgIDAr2(Ix)
     C                   EVAL      #MsgData = MsgDtaAr2(Ix)
 
      ** Set message file to the main one passed in to this procedure
 
     C                   EVAL      MessageF = #MsgFile
 
      ** Reset the message file array index
 
     C                   RESET                   MFIdx
 
      ** Loop until the message is retrieved or all possibilities are
      ** exhausted
 
     C                   DOU       MFIdx > MsgFArrMax
 
      ** Retrieve the complete message details
 
     C                   EXSR      RtvMsg
 
     C                   SELECT
 
      ** If the message was found, exit the loop
 
     C                   WHEN      ReturnCode = *blanks
     C                   LEAVE
 
      ** If the message was not found in the requested message file,
      ** work through any entries in the array of alternative message
      ** file names (if it was passed), trying each.
      ** Only report an error if the message ID is not found in any message
      ** file.
      ** Need to trap 'Message file not found' (CPF2407) as well as
      ** Message not found in message file' (CPF2419), as the multilanguage
      ** overrides can cause the former message to be sent when the
      ** message is not found.
 
     C                   WHEN         ReturnCode = 'CPF2419'
     C                             OR ReturnCode = 'CPF2407'
 
      ** If the message file array parameter was not passed, or
      ** the latest entry is blank, can't try any other message
      ** files, so end in error.  (ParmB4MsgF contains the number of
      ** parameters up to the one before the additional message files
      ** array, so if the actuall number of parameters passed equals
      ** this value, then the message files array has not been passed.)
 
     C                   IF        PSNoOfParm = ParmB4MsgF
     C                             OR MsgFArray(MFIdx) = *blanks
 
      ** Do not use *pssr for screen or repair messages. Instead set
      ** up default message to be displayed on the screen
 
     C                   IF        DealRprLoc = 'B'
     C                             OR DealRprLoc = 'S'
     C                   EVAL      MessageF = 'QCPFMSG'
     C                   EVAL      #MsgId = 'CPF9898'
     C                   EVAL      #MsgData = 'Unable to send message ' +
     C                                        MsgIDAr2(Ix)
     C                   EVAL      CompMsg = #MsgData
     C                   ELSE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Otherwise move on to the next array entry and increment the index
 
     C                   ELSE
 
     C                   EVAL      MessageF = MsgFArray(MFIdx)
     C                   EVAL      MFIdx = MFIdx + 1
     C                   ENDIF
 
      ** If the return code has any other value, an error has occurred
 
     C                   OTHER
 
      ** Do not use *pssr for screen or repair messages. Instead set
      ** up default message to be displayed on the screen
 
     C                   IF        DealRprLoc = 'B'
     C                             OR DealRprLoc = 'F'
     C                   EVAL      MessageF = 'QCPFMSG'
     C                   EVAL      #MsgId = 'CPF9898'
     C                   EVAL      #MsgData = 'Unable to send message +
     C                                        *BCAT &MSGID'
     C                   EVAL      CompMsg = 'Unable to send message' +
     C                                        #MSGID
     C                   ELSE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Drop out of the DO loop
 
     C                   LEAVE
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RtvMsg - Call the external procedure to retreive the complete *
      *          message details.                                     *
      *                                                               *
      * Called by: GetCompMsg                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RtvMsg        BEGSR
 
      ** Clear the complete message field to prevent debris from old
      ** messages appearing
 
     C                   CLEAR                   CompMsg
 
      ** Call system API (QMHRTVM) to get the complete message from the
      ** message file
 
     C                   RESET                   ReturnCode
     C                   CALLB     RtvCompMsg
     C                   PARM                    ReturnCode
     C                   PARM                    CompMsg
     C                   PARM                    #MsgId
     C                   PARM                    #MsgData
     C                   PARM                    MessageF
     C                   PARM                    #MsgFLib
     C                   PARM                    Level
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FOMsgErr - Send error message if there was an error sending a *
      *            message to the front office.                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     FOMsgErr      BEGSR
 
      ** If the MQ call failed, fall back on writing the errors to file.
      ** The array index is reset so that all the messages are written.
 
     C                   RESET                   Ix
     C                   EXSR      MsgToFile
 
      ** Notify the system operator that a problem has occured with
      ** MQSeries
 
     C                   EVAL      CompMsg = 'Error in MQSeries while +
     C                             processing transaction ' + FrontOffID +
     C                             ' ' + ModuleID + WTRANSID
     C                   RESET                   ReturnCode
     C                   CALLB     MsgToOper
     C                   PARM                    ReturnCode
     C                   PARM                    CompMsg
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupHead - Set up transaction-specific message header fields *
      *                                                               *
      *****************************************************************
 
     C     SetupHead     BEGSR
 
     C                   EVAL      APRESPMODE = RespMode
     C                   EVAL      APFOTRANID = FrontOffId
     C                   EVAL      APRPRLOCN = DealRprLoc
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      ** Incoming return code (10A, returned from this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    DealRprLoc
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    CnfValFrtO
      ** List of messages (Array of <ArrayMax3>x7A message ids - from caller )
     C                   PARM                    MsgIDAr2
      ** List of field numbers (Array of <ArrayMax3>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArray
      ** List of field names (Array of <ArrayMax3>x10A names - from caller)
     C                   PARM                    FldNameAr2
      ** List of message data entries (Array of <ArrayMax3>x45 - from caller)
     C                   PARM                    MsgDtaAr2
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    FrontOffID
      ** Midas module ID (2A, from caller)
     C                   PARM                    ModuleID
      ** Midas transaction ID (20A, from caller)
     C                   PARM                    WTRANSID
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    ActionCode
      ** Status of transaction (1A, from caller (F=Failure, S=Success))
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to (20A, from caller)
     C                   PARM                    Queue
      ** The transaction's timestamp (Z (26 bytes), from caller)
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClearPgmQ
 
      ** Determine the length of the message header file format
     C                   CALLB     'UTGETRCDLN'
      ** Outputs
      ** -------
      ** Return code
     C                   PARM                    ReturnCode
      ** Record length
     C                   PARM                    MQHeadLen
      ** Inputs
      ** ------
      ** File name
     C                   PARM                    FileName
      ** File library
     C                   PARM                    FileLib
 
      ** Clear the return code to ensure that its reset value is blanks
 
     C                   CLEAR                   ReturnCode
 
      ** The effective value of the MQ header length needs to be the
      ** length of the message header file plus the other data that is
      ** concatenated to it before adding the detailed messages.  This
      ** other data consists of the Midas module ID and transaction
      ** number.  Therefore MQHeadLen is increased by eight.
 
     C                   EVAL      MQHeadLen = MQHeadlen + 8
 
      ** Set up the fixed message header fields
 
     C                   CLEAR                   MsgHeader
     C                   EVAL      APSRCSYS = SystemName
     C                   EVAL      APMAPLOCN = MQMApLoc
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
