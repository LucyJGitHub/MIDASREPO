     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Send a message to the MQ Series queue')       *
      *****************************************************************
      *                                                               *
      *  Midas - Common subprograms                                   *
      *                                                               *
      *  ZA000001  - Send a message to the MQSeries Queue             *
      *                                                               *
      *  Function:  This module sends a message to the Front Office   *
      *             using MQSeries                                    *
      *                                                               *
      *  Possible return codes                                        *
      *  =====================                                        *
      *    ErrOpnOutP - Unable to open queue for output               *
      *    ErrRCnnnn  - An MQSeries reason code, where nnnn is a four-*
      *                 digit number; see the MQSeries documentation  *
      *                 for their meanings.                           *
      *                                                               *
      *  Component of: ZAMESSAGE - ZA Message handling service program*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT039             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248095A            Date 26Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CMK002  *CREATE    Date 07Sep00               *
      *                 XXXXXX             Date 00Xxx00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           Amendment done to accommodate longer data           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248095A- Connect to MQ queue manager using system value      *
      *           MQQueueManagerAPI. Use connection handle from this  *
      *           connection for other MQ API calls in the program.   *
      *           Applied fix 245310A.                                *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *  CMK002 - SNDAPIDATA added to core                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
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
 
      ** +--- MQSeries includes ----------------+
      ** ¦                                      ¦
      ** ¦ The following set of includes is     ¦
      ** ¦ provided by IBM for use with         ¦
      ** ¦ MQSeries.  See the source file       ¦
      ** ¦ QMQM/QRPGLESRC for details of their  ¦
      ** ¦ values.                              ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
 
      ** MQI named constants
     D/COPY QMQM/QRPGLESRC,CMQR
 
      ** Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODR
 
      ** Message Descriptor
     D MQMD            DS
     D/COPY QMQM/QRPGLESRC,CMQMDR
 
      ** Put message options
     D MQPMO           DS
     D/COPY QMQM/QRPGLESRC,CMQPMOR
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D/COPY WNCPYSRC,ZAH00029
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** 4-alpha and 6-alpha fields for the MQ error code
     D RCode4A         S              4A
     D RCode6A         S              6A   INZ('RC    ')
 
      * Constant to hold input parameter for AOSVALR0.                                       248095A
     D MQManager       C                   Const('MQQueueManagerAPI')                        248095A
                                                                                             248095A
      ** The name of the queue to use
     D Queue           S             20A
 
      ** The message to be sent to the front office
     D*MQString*****   S           4000A                                                      CIR003
     D*MQString*       S           6000A                                               CIR003 CFT039
     D MQString        S          12000A                                                      CFT039
 
      ** The length of the MQString field
     D*MQStrLen*****   S              5P 0 INZ(4000)                                          CIR003
     D*MQStrLen*       S              5P 0 INZ(6000)                                   CIR003 CFT039
     D MQStrLen        S              9P 0 INZ(12000)                                         CFT039
 
      ** The position of the first blank position in the string after the
      ** bosy of the text.
     D FirstBlnkP      S              5P 0
 
      ** MQSeries error message literals                                                     248095A
     D OpenFailed      C                   CONST('MQSeries MQOPEN failed: ')                 248095A
     D PutFailed       C                   CONST('MQSeries MQPUT  failed: ')                 248095A
     D ClosFailed      C                   CONST('MQSeries MQCLOS failed: ')                 248095A
     D ConnFailed      C                   CONST('MQSeries MQCONN failed: ')                 248095A
     D DiscFailed      C                   CONST('MQSeries MQDISC failed: ')                 248095A
      *                                                                                      248095A
     D PSysVal01       S             20A                                                     248095A
     D PCurSet01       S            200A                                                     248095A
     D PSysVal02       S             20A                                                     248095A
     D PCurSet02       S            200A                                                     248095A
     D PSysVal03       S             20A                                                     248095A
     D PCurSet03       S            200A                                                     248095A
     D PSysVal04       S             20A                                                     248095A
     D PCurSet04       S            200A                                                     248095A
     D PSysVal05       S             20A                                                     248095A
     D PCurSet05       S            200A                                                     248095A
     D PSysVal06       S             20A                                                     248095A
     D PCurSet06       S            200A                                                     248095A
     D PSysVal07       S             20A                                                     248095A
     D PCurSet07       S            200A                                                     248095A
     D PSysVal08       S             20A                                                     248095A
     D PCurSet08       S            200A                                                     248095A
     D PSysVal09       S             20A                                                     248095A
     D PCurSet09       S            200A                                                     248095A
     D PSysVal10       S             20A                                                     248095A
     D PCurSet10       S            200A                                                     248095A
                                                                                             248095A
      ** Dummy message ID and message file fields for use on the calls to                    248095A
      ** ZAMSGTOOPR                                                                          248095A
     D DummyMsgID      S                   LIKE(#MsgID)                                      248095A
     D DummyMsgF       S             10A                                                     248095A
                                                                                             248095A
                                                                                             248095A
      ** Error message for sending to the operator                                           248095A
     D MQError         S            132A                                                     248095A
                                                                                             248095A
      ** Alpha version of the MQSeries reason code                                           248095A
     D ReasonA         S              9A                                                     248095A
                                                                                             248095A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      *                                                                                      248095A
      ** If a Queue Manager is specified on system value MQManager, connect                  248095A
      ** to it and retain connection handle for other QMQM calls instead                     248095A
      ** of using the default Queue Manager and connection                                   248095A
      *                                                                                      248095A
     C                   CALLB     'AOSVALR0'                                                248095A
     C                   PARM      *BLANKS       PRtCd             7                         248095A
     C                   PARM      MQManager     PSysVal01                                   248095A
     C                   PARM                    PCurSet01                                   248095A
     C                   PARM                    PSysVal02                                   248095A
     C                   PARM                    PCurSet02                                   248095A
     C                   PARM                    PSysVal03                                   248095A
     C                   PARM                    PCurSet03                                   248095A
     C                   PARM                    PSysVal04                                   248095A
     C                   PARM                    PCurSet04                                   248095A
     C                   PARM                    PSysVal05                                   248095A
     C                   PARM                    PCurSet05                                   248095A
     C                   PARM                    PSysVal06                                   248095A
     C                   PARM                    PCurSet06                                   248095A
     C                   PARM                    PSysVal07                                   248095A
     C                   PARM                    PCurSet07                                   248095A
     C                   PARM                    PSysVal08                                   248095A
     C                   PARM                    PCurSet08                                   248095A
     C                   PARM                    PSysVal09                                   248095A
     C                   PARM                    PCurSet09                                   248095A
     C                   PARM                    PSysVal10                                   248095A
     C                   PARM                    PCurSet10                                   248095A
      *                                                                                      248095A
     C     PRtCd         IFEQ      *BLANKS                                                   248095A
     C     PCurSet01     ANDNE     *BLANKS                                                   248095A
     C                   MOVEL     PCurSet01     QMGR             48                         248095A
     C                   EXSR      MQCONNECT                                                 248095A
     C                   Z-ADD     HANDLE        HCONN                                       248095A
     C                   ENDIF                                                               248095A
                                                                                             248095A
      ** +--- Open MQSeries queue --------------+
      ** ¦                                      ¦
      ** ¦ For each message, the queue has to   ¦
      ** ¦ be opened.  The queue is opened and  ¦
      ** ¦ closed each time to ensure that each ¦
      ** ¦ message is sent to the queue it is   ¦
      ** ¦ intended for.  If the queue is left  ¦
      ** ¦ open, subsequent calls can result in ¦
      ** ¦ the message going to the wrong       ¦
      ** ¦ queue.                               ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
     C                   EXSR      OpenQueue
 
 
      ** +--- Set the length of the message ----+
      ** ¦                                      ¦
      ** ¦ The length of the message is         ¦
      ** ¦ calculated so that unnecessary blank ¦
      ** ¦ bytes are not included.  This is     ¦
      ** ¦ only really needed for 'SHUTDOWN',   ¦
      ** ¦ or other ad hoc messages.  If        ¦
      ** ¦ the performance of messages being    ¦
      ** ¦ returned to the front office becomes ¦
      ** ¦ a problem, this section can be       ¦
      ** ¦ removed and all messages sent as     ¦
      ** ¦ 4000 bytes.                          ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
      ** Set the buffer length of the MQSeries to the length of the message
      ** field.
      ** (We can't use the %LEN function at present because it's not
      ** supported prior to V3R7M0; reinstate the following line when
      ** we can.)
     C                   CALLB     'ZASTREND'
     C                   PARM                    ReturnCode
     C                   PARM                    FirstBlnkP
     C                   PARM                    MQString
     C                   PARM                    MQStrLen
 
      ** FirstBlnkP contains the position of the first blank aftter all the
      ** meaningful text.  The actual string length is one less than this.
     C                   EVAL      BUFLEN = FirstBlnkP - 1
 
      ** +--- Send the message -----------------+
      ** ¦                                      ¦
      ** ¦ Call the MQSeries program, using the ¦
      ** ¦ handle returned when opening the     ¦
      ** ¦ queue.                               ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.  FMSTR is a named constant
      ** defined in CMQR; it contains 'MQSTR   '.  MQPUT is a named constant
      ** defined in CMQR; it contains 6.
     C                   EVAL      MDFMT = FMSTR
     C                   EVAL      CID = MQPUT
     C/COPY WNCPYSRC,ZAH00030
 
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HOBJ              9 0
     C                   PARM                    MQMD
     C                   PARM                    MQPMO
     C                   PARM                    BUFLEN            9 0
     C                   PARM                    MQString
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
 
      ** If an error occured, put the MQSeries return code into this
      ** module's return code.
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   ENDIF
 
      *                                                                                      248095A
      ** Error processing                                                                    248095A
      *                                                                                      248095A
     C     REASON        IFNE      RCNONE                                                    248095A
      *                                                                                      248095A
     C                   MOVE      REASON        ReasonA                                     248095A
     C                   EVAL      MQError = PutFailed + ReasonA                             248095A
      *                                                                                      248095A
     C                   CALLB     'ZAMSGTOOPR'                                              248095A
     C                   PARM                    MQReturn         10                         248095A
     C                   PARM                    MQError                                     248095A
     C                   PARM                    DummyMsgID                                  248095A
     C                   PARM                    DummyMsgF                                   248095A
     C                   ENDIF                                                               248095A
      *                                                                                      248095A
      ** +--- Close MQSeries queue -------------+
      ** ¦                                      ¦
      ** ¦ For each message, the queue          ¦
      ** ¦ has to be closed.  This ensures that ¦
      ** ¦ the correct queue is used on         ¦
      ** ¦ subsequent calls of this procedure.  ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
     C                   EXSR      CloseQueue
      *                                                                                      248095A
      ** If an explicit connection to a Queue Manager was made, then                         248095A
      ** disconnect from it                                                                  248095A
      *                                                                                      248095A
     C     QMGR          IFNE      *BLANKS                                                   248095A
     C                   EXSR      MQDISCONNECT                                              248095A
     C                   ENDIF                                                               248095A
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OpenQueue - Open the MQSeries queue                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: PGM/QMQM                                               *
      *                                                               *
      *****************************************************************
 
     C     OpenQueue     BEGSR
 
      ** Set up MQSeries data necessary to open a queue
 
      **  Open the target message queue for output (and fail if
      **  MQM is quiescing)
      **  Resulting queue handle is HOBJ
 
      ** Options are Output and Fail-if-quiescing
      ** OOOUT and OOFIQ are MQ named constants, declared in the CMQR
      ** include member.  OPTS is a program-described field declared in the
      ** parameter list below.  MQOPEN is an MQ named constant, also
      ** defined in CMQR, and CID is the call identifier, which defines what
      ** kind of call is being made.
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C                   EVAL      CID = MQOPEN
 
      ** ODON is a subfield of the MQOD data structure, which holds the
      ** name of the queue to be opened.  It is declared in the CMQODR
      ** include member.
     C                   EVAL      ODON = Queue
     C/COPY WNCPYSRC,ZAH00062
 
      ** The call returns the parameter HOBJ, an object handle, which
      ** uniquely identifies the queue.  It is used later by the "Put" call.
      ** It also returns OCODE, a completion code, which tells us whether
      ** or not the call was successful, and REASON, which gives details
      ** if there was a failure.
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    MQOD
     C                   PARM                    OPTS              9 0
     C                   PARM                    HOBJ              9 0
     C                   PARM                    OCODE             9 0
     C                   PARM                    REASON            9 0
 
      *                                                                                      248095A
      ** Error processing                                                                    248095A
      *                                                                                      248095A
     C     REASON        IFNE      RCNONE                                                    248095A
      *                                                                                      248095A
     C                   MOVE      REASON        ReasonA                                     248095A
     C                   EVAL      MQError = OpenFailed + ReasonA                            248095A
      *                                                                                      248095A
     C                   CALLB     'ZAMSGTOOPR'                                              248095A
     C                   PARM                    MQReturn         10                         248095A
     C                   PARM                    MQError                                     248095A
     C                   PARM                    DummyMsgID                                  248095A
     C                   PARM                    DummyMsgF                                   248095A
     C                   ENDIF                                                               248095A
      *                                                                                      248095A
      ** Report reason, if any; stop if failed
      ** RCNONE is a named constant indicating no failure (it is zero).
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** CCFAIL is a named constant containing the value for OCODE
      ** indicating a failure to open the queue.
     C                   IF         OCODE = CCFAIL
     C                   EVAL      RetCodeIn = 'ErrOpnOutP'
     C                   EXSR      *pssr
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CloseQueue - Close the MQSeries queue                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: PGM/QMQM                                               *
      *                                                               *
      *****************************************************************
 
     C     CloseQueue    BEGSR
 
      ** Set up MQSeries data necessary to close a queue
 
      ** CONONE is a named constant (equal to zero) indicating that no
      ** options are to be used.  MQCLOS is a named constant indicating
      ** that the queue is to be closed.  Both are defined in CMQR.
     C                   EVAL      OPTS = CONONE
     C                   EVAL      CID = MQCLOS
 
      ** The call returns CCODE, a completion code, which tells us whether
      ** or not the call was successful, and REASON, which gives details
      ** if there was a failure.
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HOBJ              9 0
     C                   PARM                    OPTS              9 0
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
 
      *                                                                                      248095A
      ** Error processing                                                                    248095A
      *                                                                                      248095A
     C     REASON        IFNE      RCNONE                                                    248095A
      *                                                                                      248095A
     C                   MOVE      REASON        ReasonA                                     248095A
     C                   EVAL      MQError = ClosFailed + ReasonA                            248095A
      *                                                                                      248095A
     C                   CALLB     'ZAMSGTOOPR'                                              248095A
     C                   PARM                    MQReturn         10                         248095A
     C                   PARM                    MQError                                     248095A
     C                   PARM                    DummyMsgID                                  248095A
     C                   PARM                    DummyMsgF                                   248095A
     C                   ENDIF                                                               248095A
      *                                                                                      248095A
      ** Report reason, if any; stop if failed
      ** RCNONE is a named constant indicating no failure (it is zero).
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetRetCode - Set the module return code                       *
      *                                                               *
      * Called by: Main, OpenQueue                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SetRetCode    BEGSR
 
      ** First move the (numeric) reason code into a 4-alpha field; then
      ** put it into the rightmost four bytes of a 6-alpha field which
      ** begins with 'RC'; lastly concatenate it with 'Err' for the return
      ** code
     C                   MOVE      REASON        RCode4A
     C                   MOVE      RCode4A       RCode6A
     C                   EVAL      RetCodeIn = 'Err' + RCode6A
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ****************************************************************                       248095A
      *                                                              *                       248095A
      *  Open connection to the queue manager                        *                       248095A
      *                                                              *                       248095A
      ****************************************************************                       248095A
     C     MQCONNECT     BEGSR                                                               248095A
      *                                                                                      248095A
      ** Attempt to CONNECT to the MQ Manager                                                248095A
      *              ~~~~~~~                                                                 248095A
     C                   CALL      'QMQM'                                                    248095A
     C                   PARM      MQCONN        CID               9 0                       248095A
     C                   PARM                    QMGR                                        248095A
     C                   PARM      *ZERO         HANDLE            9 0                       248095A
     C                   PARM      *ZERO         OCODE             9 0                       248095A
     C                   PARM      *ZERO         REASON            9 0                       248095A
      *                                                                                      248095A
      ** Error processing                                                                    248095A
      *                                                                                      248095A
     C     REASON        IFNE      RCNONE                                                    248095A
     C     REASON        ANDNE     RC2002                                                    248095A
      *                                                                                      248095A
     C                   MOVE      REASON        ReasonA                                     248095A
     C                   EVAL      MQError = ConnFailed + ReasonA                            248095A
      *                                                                                      248095A
     C                   CALLB     'ZAMSGTOOPR'                                              248095A
     C                   PARM                    MQReturn         10                         248095A
     C                   PARM                    MQError                                     248095A
     C                   PARM                    DummyMsgID                                  248095A
     C                   PARM                    DummyMsgF                                   248095A
      *                                                                                      248095A
      ** Shut down the program                                                               248095A
      *                                                                                      248095A
     C                   EXSR      *pssr                                                     248095A
      *                                                                                      248095A
     C                   ENDIF                                                               248095A
      *                                                                                      248095A
     C                   ENDSR                                                               248095A
      ****************************************************************                       248095A
      /EJECT                                                                                 248095A
      ****************************************************************                       248095A
      *                                                              *                       248095A
      *  Disconnect from the queue manager                           *                       248095A
      *                                                              *                       248095A
      ****************************************************************                       248095A
     C     MQDISCONNECT  BEGSR                                                               248095A
      *                                                                                      248095A
      **  Attempt to DISCONNECT from the MQ Manager                                          248095A
      *                                                                                      248095A
     C                   CALL      'QMQM'                                                    248095A
     C                   PARM      MQDISC        CID               9 0                       248095A
     C                   PARM                    HCONN                                       248095A
     C                   PARM      *ZERO         OCODE                                       248095A
     C                   PARM      *ZERO         REASON                                      248095A
      *                                                                                      248095A
      ** Error processing                                                                    248095A
      *                                                                                      248095A
     C     REASON        IFNE      RCNONE                                                    248095A
      *                                                                                      248095A
     C                   MOVE      REASON        ReasonA                                     248095A
     C                   EVAL      MQError = DiscFailed + ReasonA                            248095A
      *                                                                                      248095A
     C                   CALLB     'ZAMSGTOOPR'                                              248095A
     C                   PARM                    MQReturn         10                         248095A
     C                   PARM                    MQError                                     248095A
     C                   PARM                    DummyMsgID                                  248095A
     C                   PARM                    DummyMsgF                                   248095A
      *                                                                                      248095A
      ** Shut down the program                                                               248095A
      *                                                                                      248095A
     C                   EXSR      *pssr                                                     248095A
      *                                                                                      248095A
     C                   ENDIF                                                               248095A
      *                                                                                      248095A
     C                   ENDSR                                                               248095A
      ****************************************************************                       248095A
      /EJECT                                                                                 248095A
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
      ** Return code (10A, returned from this module to caller)
     C                   PARM                    RetCodeIn
      ** Queue to send message to (20A, received from caller)
     C                   PARM                    Queue
      ** String containing message to send (4000A, received from caller)
     C                   PARM                    MQString
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
 
      ** Set the buffer length of the MQSeries to the length of the message
      ** field.
      ** (We can't use the %LEN function at present because it's not
      ** supported prior to V3R7M0; reinstate the following line when
      ** we can.)
     C**********         EVAL      BUFLEN = 4000
     C**********         EVAL      BUFLEN = 6000                                              CFT039
     C                   EVAL      BUFLEN = 12000                                             CFT039
 
     C/COPY WNCPYSRC,ZAH00031
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
