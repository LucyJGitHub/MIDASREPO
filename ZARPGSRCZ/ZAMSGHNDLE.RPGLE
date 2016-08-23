     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA API Message handler')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Common routines                                      *
      *                                                               *
      *  ZAMSGHNDLE - API Message handler                             *
      *                                                               *
      *  Function:  This module sends messages to the program message *
      *             queue, or deals with them otherwise, depending    *
      *             on the source of the transaction.                 *
      *                                                               *
      *  Component of: ZAMESSAGE - ZA messages service program        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. LLN022             Date 03Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27041           Date 01Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247352             Date 26Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 203865             Date 06Jun06               *
      *                 238804             Date 06Jun06               *
      *                 212506             Date 26Nov02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 30Apr99               *
      *                 148746             Date 25Nov98               *
      *                 148739             Date 25Nov98               *
      *                 CAP004             Date 10Sep98               *
      *                 CAP003             Date 04Aug98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN022 - BOE Upgrade to Midasplus                            *
      *  BUG27041 - Incorrect mapping for MQ STCQ                     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247352 - APISERVER job dumps when a msgid is not found in    *
      *           the system, and repair location is Front.           *
      *  203865 - Look in local message file XXUSRMSG if message      *
      *           id. is not found.                                  *
      *  238804 - Look also in GBDRSMM as this is used for extended   *
      *           settlement messages.                                *
      *  212506 - Increase the length of MQHeadlen from 8 to 22 to    *
      *           take account of the change in size of the Midas     *
      *           transaction ID from 6A to 20A.                      *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *  CAP006 - Extension of queue name to maximum length           *
      *  148746 - Output consistent value of action code for          *
      *           deletions/reversals (i.e. always 'D')               *
      *  148739 - APIs phase 4: change the lengh of MQString to cope  *
      *           with the extended APHEADPD field.                   *
      *  CAP004 - APIs phase 3.                                       *
      *           Do not end in error if validation error message is  *
      *           not found.                                          *
      *           Send confirmation of error to the front office.     *
      *           Change returned message header to match the         *
      *           the standard Meridian message header.               *
      *  CAP003 - Conversion of Midas inputs to APIs phase 2.  This   *
      *           module changed to allow multiple message files to   *
      *           be used, and to allow this module to be used by     *
      *           DSP functions.  The latter requires that the array  *
      *           loops be driven by the field name array, rather     *
      *           than the field number array, as the DSP functions   *
      *           do not have the latter information.                 *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** Transaction log file
     FZATRNLOGPDO  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
      ** Note that the commit or rollback for these files will be done
      ** in the controlling component.
 
      ** Transaction error messages file
     FZATRNERRPDO  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     F/COPY WNCPYSRC,ZAH00032
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
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** The following constant has now been redefined as a variable            CAP004
      ***The*length*of*the*MQHeader*field***************************************CAP004
     D*MQHeadLen*******C*******************CONST(%LEN(MQHeader))****************CAP004
     D*MQHeadLen*******C                   CONST(82)                            CAP004
 
      ** The length of the MQDetail field
     D*MQDetLen********C                   CONST(%LEN(MQDetail))
     D MQDetLen        C                   CONST(102)
 
      ***Target*Type*for*MQ*message*header**************************************CAP004
     D*MQTargType******C                   CONST('        ')                    CAP004
 
      ***Target*System*for*MQ*message*header************************************CAP004
     D*MQTargSys*******C                   CONST('        ')                    CAP004
 
      ***Reply*queue*for*MQ*message*header**************************************CAP004
     D*MQReplyQ********C                   CONST('                    ')        CAP004
 
      ** Mapping location for MQ message header
     D MQMapLoc        C                   CONST('A')
 
      ** Number of parameters before the message file array (used               CAP003
      ** to check whether the array has been passed)                            CAP003
     D ParmB4MsgF      C                   CONST(19)                            CAP003
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Data Structures and Arrays           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** List of field numbers (Array of <ArrayMax> 5,0 packed
     D FldNoArray      S              5P 0 DIM(ArrayMax)
                                                                                CAP004
     D MsgHeader     E DS                  EXTNAME(APHEADPD)                    CAP004
 
     D/COPY WNCPYSRC,ZAH00033
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Front office transaction identifier (20A, from caller)
     D FrontOffID      S             20A
 
      ** Array index for all three arrays
     D*Ix**************S              5I 0 INZ(1)
     D Ix              S              5P 0 INZ(1)
 
      ** Confirmation of validation to front office received from caller
     D CnfValFrtO      S              1A
 
      ** Position within the string
      ** (Integer variable could not be used because of compatibility
      ** problems with supporting earlier releases.  Possible reinstate at
      ** a later date.)
     D*Pos*************S              5I 0
     D Pos             S              5P 0
 
      ** Midas module ID (2A, from caller)
     D ModuleID        S              2A
 
      ** Transaction status (1A, from caller (F=Failure, S=Success))
     D TranStatus      S              1A
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     D RespMode        S              1A
 
      ** Queue to send front office response to
     D Queue           S             20A
      ** Maximum length queue used in call to message sending routine           CAP006
     D Queue48         S             48A                                        CAP006
 
      ** String to send return message to MQSeries
     D*MQString********S           1102A                                        148739
     D MQString        S           1228A                                        148739
 
      ***Header*information*for*the*MQSeries*message****************************CAP004
     D*MQHeader********S             82A                                        CAP004
 
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
     D*StringLen*******S              5I 0
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
      *                                                                                       CAP033
      ** Midas Transaction ID                                                                 CAP033
     D WTRANSID        S             20A                                                      CAP033
 
      ** Dummy message ID and message file fields for use on the call to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S                   LIKE(ABMSGFILE)
 
      ** Work version of message file                                           CAP003
     D MessageF        S                   LIKE(ABMSGFILE)                      CAP003
                                                                                CAP003
      ** Index to the message file array                                        CAP003
     D MFIdx           S              3P 0 INZ(1)                               CAP003
                                                                                CAP003
      ** Whether or not to clear to program message queue                       CAP003
     D ClearPgmQ       S              1A                                        CAP003
                                                                                CAP004
      ** Length of message header file format                                   CAP004
     D MQHeadLen       S              5P 0                                      CAP004
                                                                                CAP004
      ** File name for passing to UTGETRCDLN                                    CAP004
     D FileName        S             10A   INZ('APHEADPD')                      CAP004
                                                                                CAP004
      ** Library name for passing to UTGETRCDLN                                 CAP004
     D FileLib         S             10A   INZ('*LIBL')                         CAP004
                                                                                CAP004
                                                                                CAP003
     D/COPY WNCPYSRC,ZAH00006
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
      ** (Now only done if repair location is not 'S', as we do not             CAP003
      ** want a log file entry when transactions are being entered              CAP003
      ** from a Midas screen)                                                   CAP003
     C                   IF        DealRprLoc <> 'S'                            CAP003
     C                   EXSR      WriteLogF
     C                   ENDIF                                                  CAP003
 
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
     C*******************EVAL      MQString = ConfirmTxt + SystemName +         CAP004
     C*******************                     MQTargType + MQTargSys +          CAP004
     C*******************                     MQReplyQ   + RespMode +           CAP004
     C*******************                     MQMapLoc   +                      CAP004
     C*******************                     FrontOffID + ModuleID +           CAP004
     C*******************                     DealNumber                        CAP004
                                                                                CAP004
      ** Set up the transaction-specific message header fields                  CAP004
     C                   EXSR      SetupHead                                    CAP004
     C/COPY WNCPYSRC,ZAH00019
                                                                                CAP004
     C                   EVAL      APTGTTYPE = ConfirmTxt                       CAP004
     C/COPY WNCPYSRC,ZAH00023
     C***********        EVAL      MQString = MsgHeader + ModuleID +                   CAP004 CAP033
     C***********                             DealNumber                               CAP004 CAP033
     C                   EVAL      MQString = MsgHeader + ModuleID +                          CAP033
     C                                        WTRANSID                                        CAP033
     C/COPY WNCPYSRC,ZAH00007
 
      ***Call*routine*to*pass string to MQ                                      CAP006
     C*******************RESET                   ReturnCode                     CAP006
     C*******************CALLB     SndFOMsg                                     CAP006
     C*******************PARM                    ReturnCode                     CAP006
     C*******************PARM                    Queue                          CAP006
     C*******************PARM                    MQString                       CAP006
                                                                                CAP006
      ** Place queue name into maximum length string and then call routine      CAP006
      **  to pass string to MQ                                                  CAP006
     C                   RESET                   ReturnCode                     CAP006
     C/COPY WNCPYSRC,ZAH00017
     C                   EVAL      Queue48 = Queue                              CAP006
     C/COPY WNCPYSRC,ZAH00020
     C                   CALLB     SndFOMsg                                     CAP006
     C                   PARM                    ReturnCode                     CAP006
     C                   PARM                    Queue48                        CAP006
     C                   PARM                    MQString                       CAP006
 
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
                                                                                CAP004
      ** Send message to Front Office if confirmation flag set                  CAP004
     C                   IF        CnfValFrtO = 'Y'                             CAP004
     C                   EXSR      MsgToFront                                   CAP004
     C                   ENDIF                                                  CAP004
 
      ** If repair location = 'F', messages are to be sent back to the
      ** front office
     C                   WHEN      DealRprLoc = 'F'
 
     C                   EXSR      MsgToFront
     C/COPY WNCPYSRC,ZAH00025
 
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
     C***********        EVAL      ABMIDTRNID = DealNumber                                    CAP033
     C**********         EVAL      ABMIDTRNID = WTRANSID                             CAP033 BUG27041
     C                   EVAL      ABMIDTRID2 = WTRANSID                                    BUG27041
      ** CAP003: Ensure that ABMSGFILE is set up with the value returned        CAP003
      ** by GetCompMsg; replace #MsgFile below with MessageF after call         CAP003
      ** to GetCompMsg                                                          CAP003
     C*******************EVAL      ABMSGFILE = #MsgFile                         CAP003
     C                   EVAL      ABTMESTMP = TimeStamp
 
      ** Work through the field numbers array until zero is encountered
      ** or the maximum size of the array is reached
     C                   DOW       FldNoArray(Ix) <> 0
     C                             AND Ix <= ArrayMax
 
      ** Set the message text level field to get both first and second
      ** level text
     C                   EVAL      Level = '0'
 
      ** Get the complete message text
     C                   EXSR      GetCompMsg
 
      ** Set up the message-specific file fields
     C                   EVAL      ABMSGFILE = MessageF                         CAP003
     C                   EVAL      ABFIELDID = FldNoArray(Ix)
     C                   EVAL      ABFIELDNAM = FldNameArr(Ix)
     C                   EVAL      ABMSGID = MsgIDArr(Ix)
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
     C*******************EVAL      MQString = ErrorTxt   + SystemName +         CAP004
     C*******************                     MQTargType + MQTargSys +          CAP004
     C*******************                     MQReplyQ   + RespMode +           CAP004
     C*******************                     MQMapLoc   +                      CAP004
     C*******************                     FrontOffID + ModuleID +           CAP004
     C*******************                     DealNumber                        CAP004
                                                                                CAP004
      ** Set up the transaction-specific message header fields                  CAP004
     C                   EXSR      SetupHead                                    CAP004
                                                                                CAP004
     C                   EVAL      APTGTTYPE = ErrorTxt                         CAP004
     C/COPY WNCPYSRC,ZAH00034
     C***********        EVAL      MQString = MsgHeader + ModuleID +                   CAP004 CAP033
     C***********                             DealNumber                               CAP004 CAP033
     C                   EVAL      MQString = MsgHeader + ModuleID +                          CAP033
     C                                        WTRANSID                                        CAP033
 
      ** No need to send details of error messages if this is just a            CAP004
      ** validity confirmation message. Therefore only send if message          CAP004
      ** is due to be repaired in the front office                              CAP004
     C                   IF        DealRprLoc = 'F'                             CAP004
                                                                                CAP004
      ** Reset the count of detailed messages added to the string for MQ
     C                   RESET                   MQDetCount
 
      ** Work through the field numbers array until zero is encountered
      ** or the maximum size of the array or the maximum number of messages
      ** to send to the front office is reached.
     C                   DOW       FldNoArray(Ix) <> 0
     C                             AND Ix <= ArrayMax AND Ix <= MaxMessage
 
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
     C                   ENDIF                                                  CAP004
 
      *********Call*routine to pass string to MQ                                CAP006
     C*******************RESET                   ReturnCode                     CAP006
     C*******************CALLB     SndFOMsg                                     CAP006
     C*******************PARM                    ReturnCode                     CAP006
     C*******************PARM                    Queue                          CAP006
     C*******************PARM                    MQString                       CAP006
                                                                                CAP006
      ** Place queue name into maximum length string and then call routine      CAP006
      **  to pass string to MQ                                                  CAP006
     C                   RESET                   ReturnCode                     CAP006
     C                   EVAL      Queue48 = Queue                              CAP006
     C                   CALLB     SndFOMsg                                     CAP006
     C                   PARM                    ReturnCode                     CAP006
     C                   PARM                    Queue48                        CAP006
     C                   PARM                    MQString                       CAP006
      *
 
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
     C                                        FldNameArr(Ix) +
     C                                        MsgIDArr(Ix) +
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
      * MsgToScrn - Send error messages to screen handler             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ZAMSGTOSCN                                             *
      *                                                               *
      *****************************************************************
 
     C     MsgToScrn     BEGSR
 
      ** Check whether clearing the program message queue has been              CAP003
      ** requested; if the number of parameters passed is such that the         CAP003
      ** array of additional message files, and hence the clear program         CAP003
      ** queue flag have NOT been passed, default to clearing the               CAP003
      ** queue.                                                                 CAP003
     C                   IF        PSNoOfParm = ParmB4MsgF                      CAP003
     C                   CLEAR                   ClearPgmQ                      CAP003
     C                   ENDIF                                                  CAP003
                                                                                CAP003
     C                   IF        ClearPgmQ <> 'N'                             CAP003
                                                                                CAP003
      ** Before sending the messages to the program message queue,
      ** clear the program message queue
     C                   CALLB     ClrPgmMsg
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
                                                                                CAP003
     C                   ENDIF                                                  CAP003
 
      ** Work through the field numbers array until zero is encountered
      ** or the maximum size of the array is reached
      ** CAP003: change this to use the field name array until blanks           CAP003
      ** are encountered.  This makes calling this function from a screen       CAP003
      ** display function (*DSP) easier, as those functions don't have          CAP003
      ** the field numbers.                                                     CAP003
     C*******************DOW       FldNoArray(Ix) <> 0                          CAP003
     C*******************          AND Ix <= ArrayMax                           CAP003
     C                   DOW       FldNameArr(Ix) <> *blanks                    CAP003
     C                             AND Ix <= ArrayMax                           CAP003
 
     C                   EVAL      #MsgID = MsgIDArr(Ix)
     C                   EVAL      #MsgData = MsgDtaArr(Ix)
                                                                                CAP003
      ** Add a call to GetCompMsg here: the complete message details are        CAP003
      ** not required by this subroutine, but it will have the effect           CAP003
      ** of determining which message file the message is in, if more           CAP003
      ** than one name is specified.  Then change the parameter on the call     CAP003
      ** to SndScnMsg (ZAMSGTOSCN) to use MessageF instead of #MsgFile.         CAP003
     C                   EXSR      GetCompMsg                                   CAP003
 
      **  Call screen message handler
     C                   CALLB     SndScnMsg
     C*******************PARM                    #MsgFile                       CAP003
     C                   PARM                    MessageF                       CAP003
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
     C***********        EVAL      AAMIDTRNID = DealNumber                                    CAP033
     C**********         EVAL      AAMIDTRNID = WTRANSID                             CAP033 BUG27041
     C                   EVAL      AAMIDTRID2 = WTRANSID                                    BUG27041
     C                   EVAL      AAACTNCODE = ActionCode
                                                                                148746
      * Set action code to consistent value for deletions/reversals             148746
                                                                                148746
     C                   IF        ActionCode = 'R'                             148746
     C                   EVAL      AAACTNCODE = 'D'                             148746
     C                   ENDIF                                                  148746
     C                   EVAL      AARESPMODE = RespMode
     C                   EVAL      AARPRLOC   = DealRprLoc
     C                   EVAL      AACNFVALFO = CnfValFrtO
     C                   EVAL      AASTATUS   = TranStatus
     C                   EVAL      AATMESTMP  = TimeStamp
 
     C                   WRITE     ZATRNLOGD0
 
     C/COPY WNCPYSRC,ZAH00035
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY WNCPYSRC,ZAH00036
 
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
     C                   EVAL      #MsgID = MsgIDArr(Ix)
     C                   EVAL      #MsgData = MsgDtaArr(Ix)
                                                                                CAP003
      ** Set message file to the main one passed in to this procedure           CAP003
     C                   EVAL      MessageF = #MsgFile                          CAP003
                                                                                CAP003
      ** Reset the message file array index                                     CAP003
     C                   RESET                   MFIdx                          CAP003
                                                                                CAP003
      ** Loop until the message is retrieved or all possibilities are           CAP003
      ** exhausted                                                              CAP003
     C                   DOU       MFIdx > MsgFArrMax                           CAP003
                                                                                CAP003
      ** Retrieve the complete message details                                  CAP003
     C                   EXSR      RtvMsg                                       CAP003
                                                                                CAP003
     C                   SELECT                                                 CAP003
      **                 ------                                                 CAP003
                                                                                CAP003
      ** If the message was found, exit the loop                                CAP003
     C                   WHEN      ReturnCode = *blanks                         CAP003
      **                 ----                                                   CAP003
     C                   LEAVE                                                  CAP003
                                                                                CAP003
      ** If the message was not found in the requested message file,            CAP003
      ** work through any entries in the array of alternative message           CAP003
      ** file names (if it was passed), trying each.                            CAP003
      ** Only report an error if the message ID is not found in any message     CAP003
      ** file.                                                                  CAP003
      ** Need to trap 'Message file not found' (CPF2407) as well as             CAP003
      ** Message not found in message file' (CPF2419), as the multilanguage     CAP003
      ** overrides can cause the former message to be sent when the             CAP003
      ** message is not found.                                                  CAP003
     C                   WHEN         ReturnCode = 'CPF2419'                    CAP003
     C                             OR ReturnCode = 'CPF2407'                    CAP003
      **                 ----                                                   CAP003
      ** If the message file array parameter was not passed, or                 CAP003
      ** the latest entry is blank, can't try any other message                 CAP003
      ** files, so end in error.  (ParmB4MsgF contains the number of            CAP003
      ** parameters up to the one before the additional message files           CAP003
      ** array, so if the actuall number of parameters passed equals            CAP003
      ** this value, then the message files array has not been passed.)         CAP003
     C                   IF        PSNoOfParm = ParmB4MsgF                      CAP003
     C                             OR MsgFArray(MFIdx) = *blanks                CAP003
      *                                                                         238804
      ** Check if message exists in DRS message file                            238804
     C                   Eval      MessageF = 'DRSMM   '                        238804
     C                   Exsr      RtvMsg                                       238804
     C                   If        ReturnCode = *blanks                         238804
     C                   Leave                                                  238804
     C                   Endif                                                  238804
      *                                                                         203865
      ** Check if message exists in local message file                          203865
     C                   Eval      MessageF = 'XXUSRMSG'                        203865
     C                   Exsr      RtvMsg                                       203865
     C                   If        ReturnCode = *blanks                         203865
     C                   Leave                                                  203865
     C                   Endif                                                  203865
      *                                                                         203865
      ** Check if message exists in BOE message file                                          LLN022
     C                   Eval      MessageF = 'GBBYUSRMSG'                                    LLN022
     C                   Exsr      RtvMsg                                                     LLN022
     C                   If        ReturnCode = *blanks                                       LLN022
     C                   Leave                                                                LLN022
     C                   Endif                                                                LLN022
      *                                                                                       LLN022
      ** Do not use *pssr for screen or repair messages. Instead set            CAP004
      ** up default message to be displayed on the screen                       CAP004
     C                   IF        DealRprLoc = 'B'                             CAP004
     C                             OR DealRprLoc = 'S'                          CAP004
     C                             OR DealRprLoc = 'F'                                        247352
     C/COPY WNCPYSRC,ZAH00024
     C                   EVAL      MessageF = 'QCPFMSG'                         CAP004
     C                   EVAL      #MsgId = 'CPF9898'                           CAP004
     C                   EVAL      #MsgData = 'Unable to send message ' +       CAP004
     C                                        MsgIDArr(Ix)                      CAP004
     C                   EVAL      CompMsg = #MsgData                           CAP004
     C                   ELSE                                                   CAP004
     C                   EXSR      *pssr                                        CAP003
     C                   ENDIF                                                  CAP004
                                                                                CAP003
      ** Otherwise move on to the next array entry and increment the index      CAP003
     C                   ELSE                                                   CAP003
                                                                                CAP003
     C                   EVAL      MessageF = MsgFArray(MFIdx)                  CAP003
     C                   EVAL      MFIdx = MFIdx + 1                            CAP003
     C                   ENDIF                                                  CAP003
                                                                                CAP003
      ** If the return code has any other value, an error has occurred          CAP003
     C                   OTHER                                                  CAP003
      **                 -----                                                  CAP003
      ** Do not use *pssr for screen or repair messages. Instead set            CAP004
      ** up default message to be displayed on the screen                       CAP004
     C                   IF        DealRprLoc = 'B'                             CAP004
     C                             OR DealRprLoc = 'F'                          CAP004
     C                   EVAL      MessageF = 'QCPFMSG'                         CAP004
     C                   EVAL      #MsgId = 'CPF9898'                           CAP004
     C                   EVAL      #MsgData = 'Unable to send message +         CAP004
     C                                        *BCAT &MSGID'                     CAP004
     C                   EVAL      CompMsg = 'Unable to send message' +         CAP004
     C                                        #MSGID                            CAP004
     C                   ELSE                                                   CAP004
     C                   EXSR      *pssr                                        CAP003
     C                   ENDIF                                                  CAP004
                                                                                CAP004
      ** Drop out of the DO loop                                                CAP004
     C                   LEAVE                                                  CAP004
                                                                                CAP003
     C                   ENDSL                                                  CAP003
      **                 -----                                                  CAP003
                                                                                CAP003
     C                   ENDDO                                                  CAP003
                                                                                CAP003
 
      ** CAP003: the section below has been moved to subroutine RtvMsg.         CAP003
                                                                                CAP003
      ***Clear*the*complete*message*field*to*prevent*debris*from*old************CAP003
      ***messages*appearing*****************************************************CAP003
     C*******************CLEAR                   CompMsg                        CAP003
                                                                                CAP003
      ***Call*system*API*(QMHRTVM)*to*get*the*complete*message*from*the*********CAP003
      ***message*file***********************************************************CAP003
     C*******************RESET                   ReturnCode                     CAP003
     C*******************CALLB     RtvCompMsg                                   CAP003
     C*******************PARM                    ReturnCode                     CAP003
     C*******************PARM                    CompMsg                        CAP003
     C*******************PARM                    #MsgId                         CAP003
     C*******************PARM                    #MsgData                       CAP003
     C*******************PARM                    #MsgFile                       CAP003
     C*******************PARM                    #MsgFLib                       CAP003
     C*******************PARM                    Level                          CAP003
                                                                                CAP003
      ***If*an*error*was*reported*by*the*called*module,*end*this*module*in******CAP003
      ***error.*****************************************************************CAP003
     C*******************IF        ReturnCode <> *blanks                        CAP003
     C*******************EXSR      *pssr                                        CAP003
     C*******************ENDIF                                                  CAP003
 
     C                   ENDSR
 
      *****************************************************************         CAP003
      /EJECT                                                                    CAP003
      *****************************************************************         CAP003
      *                                                               *         CAP003
      * RtvMsg - Call the external procedure to retreive the complete *         CAP003
      *          message details.                                     *         CAP003
      *                                                               *         CAP003
      * Called by: GetCompMsg                                         *         CAP003
      *                                                               *         CAP003
      * Calls: None                                                   *         CAP003
      *                                                               *         CAP003
      *****************************************************************         CAP003
                                                                                CAP003
     C     RtvMsg        BEGSR                                                  CAP003
                                                                                CAP003
      ** Clear the complete message field to prevent debris from old            CAP003
      ** messages appearing                                                     CAP003
     C                   CLEAR                   CompMsg                        CAP003
                                                                                CAP003
      ** Call system API (QMHRTVM) to get the complete message from the         CAP003
      ** message file                                                           CAP003
     C                   RESET                   ReturnCode                     CAP003
     C                   CALLB     RtvCompMsg                                   CAP003
     C                   PARM                    ReturnCode                     CAP003
     C                   PARM                    CompMsg                        CAP003
     C                   PARM                    #MsgId                         CAP003
     C                   PARM                    #MsgData                       CAP003
     C                   PARM                    MessageF                       CAP003
     C                   PARM                    #MsgFLib                       CAP003
     C                   PARM                    Level                          CAP003
                                                                                CAP003
     C                   ENDSR                                                  CAP003
                                                                                CAP003
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
     C***********        EVAL      CompMsg = 'Error in MQSeries while +                       CAP033
     C***********                  processing transaction ' + FrontOffID +                    CAP033
     C***********                  ' ' + ModuleID + DealNumber                                CAP033
     C                   EVAL      CompMsg = 'Error in MQSeries while +                       CAP033
     C                             processing transaction ' + FrontOffID +                    CAP033
     C                             ' ' + ModuleID + WTRANSID                                  CAP033
     C                   RESET                   ReturnCode
     C                   CALLB     MsgToOper
     C                   PARM                    ReturnCode
     C                   PARM                    CompMsg
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDSR
                                                                                CAP004
      *****************************************************************         CAP004
      /EJECT                                                                    CAP004
      *****************************************************************         CAP004
      *                                                               *         CAP004
      * SetupHead - Set up transaction-specific message header fields *         CAP004
      *                                                               *         CAP004
      *****************************************************************         CAP004
                                                                                CAP004
     C     SetupHead     BEGSR                                                  CAP004
                                                                                CAP004
     C                   EVAL      APRESPMODE = RespMode                        CAP004
     C                   EVAL      APFOTRANID = FrontOffId                      CAP004
     C                   EVAL      APRPRLOCN = DealRprLoc                       CAP004
                                                                                CAP004
     C                   ENDSR                                                  CAP004
 
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
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned from this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    DealRprLoc
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    CnfValFrtO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArray
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    FrontOffID
      ** Midas module ID (2A, from caller)
     C                   PARM                    ModuleID
      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
     C***********        PARM                    DealNumber                                   CAP033
     C                   PARM                    WTRANSID                                     CAP033
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
      ** Additional message files to check (Array of <MsgFArrMax> x 10)         CAP003
     C                   PARM                    MsgFArray                      CAP003
      ** Whether or not to clear the program message queue (1A)                 CAP003
     C                   PARM                    ClearPgmQ                      CAP003
                                                                                CAP004
                                                                                CAP004
      ** Determine the length of the message header file format                 CAP004
     C                   CALLB     'UTGETRCDLN'                                 CAP004
      ** Outputs                                                                CAP004
      ** -------                                                                CAP004
      ** Return code                                                            CAP004
     C                   PARM                    ReturnCode                     CAP004
      ** Record length                                                          CAP004
     C                   PARM                    MQHeadLen                      CAP004
      ** Inputs                                                                 CAP004
      ** ------                                                                 CAP004
      ** File name                                                              CAP004
     C                   PARM                    FileName                       CAP004
      ** File library                                                           CAP004
     C                   PARM                    FileLib                        CAP004
                                                                                CAP004
      ** Clear the return code to ensure that its reset value is blanks         CAP004
     C                   CLEAR                   ReturnCode                     CAP004
                                                                                CAP004
      ** The effective value of the MQ header length needs to be the            CAP004
      ** length of the message header file plus the other data that is          CAP004
      ** concatenated to it before adding the detailed messages.  This          CAP004
      ** other data consists of the Midas module ID and transaction             CAP004
      ** number.  Therefore MQHeadLen is increased by eight.                    CAP004
     C**********         EVAL      MQHeadLen = MQHeadlen + 8             CAP004 212506
     C                   EVAL      MQHeadLen = MQHeadlen + 22                   212506
                                                                                CAP004
      ** Set up the fixed message header fields                                 CAP004
     C                   CLEAR                   MsgHeader                      CAP004
     C                   EVAL      APSRCSYS = SystemName                        CAP004
     C                   EVAL      APMAPLOCN = MQMApLoc                         CAP004
                                                                                CAP004
     C/COPY WNCPYSRC,ZAH00008
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
     C/COPY WNCPYSRC,ZAH00009
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
