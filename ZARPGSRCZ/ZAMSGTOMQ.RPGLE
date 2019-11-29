     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas ZA Send a message using Websphere MQ')           *
      *****************************************************************
      *                                                               *
      *  Midas - Common subprograms                                   *
      *                                                               *
      *  ZAMSGTOMQ - Send a message Using Webspere MQ                 *
      *                                                               *
      *  Function:  This can be used to send a message to any         *
      *             MQseries queue.                                   *
      *                                                               *
      *  Possible return codes                                        *
      *  =====================                                        *
      *    ErrOpnOutP - Unable to open queue for output               *
      *    ErrRCnnnn  - An MQSeries reason code, where nnnn is a four-*
      *                 digit number; see the MQSeries documentation  *
      *                 for their meanings.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD041126           Date 27Nov19               *
      *  Prev Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD054674.                             *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
 
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
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
 
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
 
      ** Object Descriptor
 
     D MQOD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
 
      ** Message Descriptor
 
     D MQMD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                        MD041126
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
 
      ** Put message options
 
     D MQPMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
 
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
 
      ** The name of the queue and queue manager to use
 
     D PQueue          S             48A
     D PQMgr           S             48A
     D PSys            S              2A
 
      ** The name of the last queue manager and queue used.
 
     D LastQMgr        S             48A   INZ(*BLANKS)
     D LastQueue       S             48A   INZ(*BLANKS)
 
      ** The message to be sent to the front office
 
     D MQString        S           2000A
 
      ** The length of the MQString field
 
     D MQStrLen        S              5P 0 INZ(1102)
 
      ** QMQM Pameters
 
     D***CID****       S              9P 0                                                  MD041126
     D QMGR            S             48A
     D***HANDLE*       S              9P 0                                                  MD041126
     D***HCONN**       S              9P 0                                                  MD041126
     D***HOBJ***       S              9P 0                                                  MD041126
     D***OPTS***       S              9P 0                                                  MD041126
     D***OCODE**       S              9P 0                                                  MD041126
     D***CCODE**       S              9P 0                                                  MD041126
     D***REASON*       S              9P 0                                                  MD041126
     D***BUFLEN*       S              9P 0                                                  MD041126
     D HANDLE          S             10I 0                                                  MD041126
     D HCONN           S             10I 0                                                  MD041126
     D HOBJ            S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D BUFLEN          S             10I 0                                                  MD041126
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** +--- Open MQSeries queue --------------+
      ** ¦                                      ¦
      ** ¦ For each message, the queue has to   ¦
      ** ¦ be opened.  The queue is closed and  ¦
      ** ¦ opened if the queue name has changed ¦
      ** ¦ since the previous call (except the  ¦
      ** ¦ first time through, when LastQueue   ¦
      ** ¦ will be blank).                      ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
 
     C                   IF        PQMgr     <> LastQMgr
     C                   IF        LastQueue <> *BLANKS
     C                   EXSR      SRMQDisc
     C                   ENDIF
     C                   EVAL      QMGR      =  PQMgr
     C                   EXSR      SRMQConn
     C                   EVAL      HCONN     =  HANDLE
     C                   ENDIF
 
     C                   IF        PQueue    <> LastQueue
 
     C                   IF        LastQueue <> *BLANKS
     C                   EXSR      SRMQClose
     C                   ENDIF
 
     C                   EXSR      SRMQOpen
 
     C                   ENDIF
 
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
      ** ¦ 1102 bytes.                          ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
      ** Set the buffer length of the MQSeries to the length of the
      ** message field.
 
     C                   EVAL      BUFLEN = %LEN(%TRIMR(MQString))
 
      **  Set the message prority
 
     C                   RESET                   MDPRI
     C                   EVAL      MDPRI  = 5
 
      ** +--- Send the message -----------------+
      ** ¦                                      ¦
      ** ¦ Call the MQSeries program, using the ¦
      ** ¦ handle returned when opening the     ¦
      ** ¦ queue.                               ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.  FMSTR is a named
      ** constant defined in CMQR; it contains 'MQSTR   '.  MQPUT is a
      ** named constant defined in CMQR; it contains 6.
 
     C                   EVAL      MDCID = PSys
     C                   EVAL      MDFMT = FMSTR
     C**********         EVAL      CID = MQPUT                                              MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    HOBJ                                       MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM                    BUFLEN                                     MD041126
     C**********         PARM                    MQString                                   MD041126
     C**********         PARM                    CCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( HCONN : HOBJ : MQMD : MQPMO :                     MD041126
     C                                    BUFLEN : %ADDR(MQString) :                        MD041126
     C                                    CCODE : REASON )                                  MD041126
 
      ** If an error occured, put the MQSeries return code into this
      ** module's return code.
 
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Open connection to the queue manager                         *
      *                                                               *
      *****************************************************************
     C     SRMQConn      BEGSR
 
      **  Attempt to CONNECT to the MQ Manager
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQCONN        CID                                        MD041126
     C**********         PARM                    QMGR                                       MD041126
     C**********         PARM      *ZERO         HANDLE                                     MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         HANDLE                                     MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCONN( QMGR  : HANDLE :                                 MD041126
     C                                     OCODE : REASON )                                 MD041126
 
      ** Error processing
 
     C                   IF        REASON <> RCNONE
     C                             AND REASON <> RC2002
 
     C                   EXSR      SetRetCode
 
      ** Shut down the program
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   EVAL      LastQMgr = PQMgr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Disconnect from the queue manager                            *
      *                                                               *
      *****************************************************************
     C     SRMQDisc      BEGSR
 
      **  Attempt to DISCONNECT from the MQ Manager
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQDISC        CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
 
      ** Error processing
 
     C                   IF         REASON <> RCNONE
 
     C                   EXSR      SetRetCode
 
      ** Shut down the program
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   EVAL      LastQMgr  = *BLANKS
     C                   EVAL      LastQueue = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  OpenQueue - Open the MQSeries queue                          *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: PGM/QMQM                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMQOpen      BEGSR
 
      ** Set up MQSeries data necessary to open a queue
 
      ** Open the target message queue for output (and fail if
      ** MQM is quiescing)
      ** Resulting queue handle is HOBJ
 
      ** Options are Output and Fail-if-quiescing
      ** OOOUT and OOFIQ are MQ named constants, declared in the CMQR
      ** include member.  OPTS is a program-described field declared
      ** in the parameter list below.  MQOPEN is an MQ named constant,
      ** also defined in CMQR, and CID is the call identifier, which
      ** defines what kind of call is being made.
 
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C**********         EVAL      CID  = MQOPEN                                            MD041126
 
      ** ODON is a subfield of the MQOD data structure, which holds the
      ** name of the queue to be opened.  It is declared in the CMQODR
      ** include member.
 
     C                   EVAL      ODON = PQueue
 
      ** The call returns the parameter HOBJ, an object handle, which
      ** uniquely identifies the queue.  It is used later by the PUT
      ** call.  It also returns OCODE, a completion code, which tells
      ** whether or not the call was successful, and REASON, which
      ** gives details if there was a failure.
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS                                       MD041126
     C**********         PARM                    HOBJ                                       MD041126
     C**********         PARM                    OCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
     C                                     HOBJ : OCODE : REASON )                          MD041126
 
      ** Report reason, if any; stop if failed
      ** RCNONE is a named constant indicating no failure (it is zero).
 
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** CCFAIL is a named constant containing the value for OCODE
      ** indicating a failure to open the queue.
 
     C                   IF         OCODE    = CCFAIL
     C                   EVAL      RetCodeIn = 'ErrOpnOutP'
     C                   EXSR      *PSSR
     C                   END
 
      ** If all was successful, save the name of the queue for checking
      ** on subsequent calls.
 
     C                   EVAL      LastQueue = PQueue
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CloseQueue - Close the MQSeries queue                        *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: PGM/QMQM                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMQClose     BEGSR
 
      ** Set up MQSeries data necessary to close a queue
 
      ** CONONE is a named constant (equal to zero) indicating that no
      ** options are to be used.  MQCLOS is a named constant indicating
      ** that the queue is to be closed.  Both are defined in CMQR.
 
     C                   EVAL      OPTS = CONONE
     C**********         EVAL      CID = MQCLOS                                             MD041126
 
      ** The call returns CCODE, a completion code, which tells us
      ** whether or not the call was successful, and REASON, which
      ** gives details if there was a failure.
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    HOBJ                                       MD041126
     C**********         PARM                    OPTS                                       MD041126
     C**********         PARM                    CCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( HCONN : HOBJ : OPTS :                           MD041126
     C                                      CCODE : REASON)                                 MD041126
 
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
      *  SetRetCode - Set the module return code                      *
      *                                                               *
      *  Called by: Main, OpenQueue                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SetRetCode    BEGSR
 
      ** First move the (numeric) reason code into a 4-alpha field;
      ** then put it into the rightmost four bytes of a 6-alpha field
      ** which begins with 'RC'; lastly concatenate it with 'Err' for
      ** the return code.
 
     C                   MOVE      REASON        RCode4A
     C                   MOVE      RCode4A       RCode6A
     C                   EVAL      RetCodeIn = 'Err' + RCode6A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return code (10A, returned from this module to caller)
 
     C                   PARM                    RetCodeIn
 
      ** System prefix to be used as Correlation ID
 
     C                   PARM                    PSys
 
      ** Queue Manager Name to send message to.
 
     C                   PARM                    PQMgr
 
      ** Queue Name to send message to.
 
     C                   PARM                    PQueue
 
      ** String containing message to send (1102A, received from caller)
 
     C                   PARM                    MQString
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   IF        RunBefore <> 'Y'
     C
     C                   EVAL      RunBefore = 'Y'
 
      ** Load the APDUMP fields
 
     C     *LOCK         IN        APDUMP                               99
 
     C                   IF        *IN99 = *ON
 
     C                   CLEAR                   PSSRRetCde
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PSSRRetCde       10
     C     *LOCK         IN        APDUMP
     C                   ENDIF
 
     C                   EVAL      ARErrMod = PSProcMod
     C                   OUT       APDUMP
     C
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   RETURN
     C                   ENDSR
