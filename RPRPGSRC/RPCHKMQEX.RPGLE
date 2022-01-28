     H DEBUG
     H*COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPCHKMQEX - Check for the existence of an MQSeries object    *
      *                                                               *
      *  Function:
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. MD055494D          Date 28Jul20               *
      *                 MD055679           Date 12May20               *
      *                 PMS-10473          Date 14Apr16               *
      *                 000867 (Bugzilla)  Date 13Apr06               *
      *                 000765 Bugzilla    Date 23Jan06               *
      *                 097968 Supportforce  Date 13Dec05             *
      *                 CRP026             Date 18Jul05               *
      *                 200189             Date 15Nov01               *
      *                 CRP004             Date 05Aug99               *
      *                 CRP002  *CREATE    Date 13Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  MD055494D - Midas Replication & MQ9 compatibility            *
      *            - Re-deliver only the objects used during client   *
      *              fix testing.                                     *
      *  MD055679 - MQ V9 issue - repmidas jobs.                      *
      *           - Redeliver to update clients object, also fix the  *
      *             errors encountered during compilation.            *
      *  PMS-10473 - MQ version 8 causes us problems where we're      *
      *              using OPM calls (or "compatibility mode," as     *
      *              IBM like to call it now) along with ILE calls.   *
      *              Replacing the old ones with modern ones, obvs.   *
      *                                                               *
      *  000867 - Add in processing for MQ Channels                   *
      *  000765 - Correct error reporting so that in an MQ error is   *
      *           detected it is reported correctly.                  *
      *  097968 - Don't dump/return when MQ 2085 is received, as that *
      *           just means that the object does not exist.          *
      *  CRP026 - User specified Queue Manager added.                 *
      *  200189 - Cause a dump when an unexpected MQ return code is   *
      *           received                                            *
      *  CRP004 - Recompiled over changed STD_DCL /COPY               *
      *  CRP002 - New                                                 *
      *                                                               *
      *****************************************************************
      /EJECT

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **  Declare MQI structures needed
      *      MQI Constants & Prototypes                                         191375
     D/COPY QMQM/QRPGLESRC,CMQG                                                 191375
                                                                                191375
      *      Object Descriptor                                                  191375
     D MQOD            DS                                                       191375
     D/COPY QMQM/QRPGLESRC,CMQODG                                               191375
                                                                                191375
      *      Message Descriptor                                                 191375
     D MQMD            DS                                                       191375
     D/COPY QMQM/QRPGLESRC,CMQMDR                                               191375
                                                                                191375
      *      Put message options                                                191375
     D MQPMO           DS                                                       191375
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                              191375

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

      ** The following /COPY contains various standard declares
     C***/COPY*RPCPYSRC,Std_Dcl                                                             MD055679
     C/COPY RPCPYSRC,STD_DCL                                                                MD055679

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

      ** Parameters
      **   Object whose existence is to be checked
     D ObjToChk        S                   LIKE(MQSQueue)
      **   Object type
     D ObjectType      S              7A
      **   Does object exist
     D ObjExist        S              4A

      ** Queue Manager fields                                                   CRP026
     D MQMNAME         S             10A   INZ('MQMNAME   ')                    CRP026
     D ReturnedData    S             64A                                        CRP026
     D ReturnedDataLn  S              2P 0                                      CRP026
     D QueueMgrname    S             48A                                        CRP026

      ** Work fields
      ** Alpha version of the MQSeries reason code
     D*ReasonA*********S              9A
      ** Change this to 4 long as it is used to extract the                     000765
      ** the last 4 bytes of the MQ error code.                                 000765
     D ReasonA         S              4A                                        000765

      ** Fields used in MQ calls                                                115092
     D HConn           S             10I 0                                      115092
     D CmpCod          S             10I 0                                      115092
     D Reason          S             10I 0                                      115092
     D HObj            S             10I 0                                      115092
     D Opts            S             10I 0                                      115092
     D BufLen          S             10I 0                                      115092
     D RunBefore       S              1A                                                    MD055679

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *  Testing for a Channel is best done in a CL module, so call that        000867
      *  routine and bypass all other processing in here.                       000867
     C                   IF        ObjectType = 'CHANNEL'                       000867
                                                                                000867
      * A 20 long channel name has been passed in, in a 48 long field so        000867
      *  the extra bytes may have been filled with junk by the OS.              000867
      *  So make sure the last 28 bytes are blank                               000867
     C                   EVAL      %subst( ObjToChk : 21 : 28) = *blank         000867
                                                                                000867
     C                   CALLB     'RPCHKMQEXC'                                 000867
     C                   PARM                    QueueMgrName                   000867
     C                   PARM                    ObjToChk                       000867
     C                   PARM                    ObjExist                       000867
     C                   PARM                    ReturnCode                     000867
                                                                                000867
     C                   ELSE                                                   000867
                                                                                000867
      *  Connect to Queue Manager                                               CRP026
     C                   EXSR      QMConnect                                    CRP026
                                                                                CRP026
      *  If Object Type indicates it is an MQSeries queue, attempt to
      *   open it, set the Object Exists field appropriately and close
      *   the queue if the open was successful.

     C                   IF        ObjectType = 'QUEUE'
      ** Set MQ object type to Queue
     C                   EVAL      ODOT = OTQ
     C                   EXSR      OpenObject

     C                   IF        REASON = RC2085
     C                   EVAL      ObjExist = '*NO'
     C                   ENDIF

     C                   IF        REASON = RCNONE
     C                   EVAL      ObjExist = '*YES'
     C                   EXSR      CloseObj
     C                   ENDIF

     C                   ENDIF

      *  If Object Type indicates it is an MQSeries process, attempt to
      *   open it, set the Object Exists field appropriately and close
      *   the process if the open was successful.

     C                   IF        ObjectType = 'PROCESS'
      ** Set MQ object type to Process
     C                   EVAL      ODOT = OTPRO
     C                   EXSR      OpenObject

     C                   IF        REASON = RC2085
     C                   EVAL      ObjExist = '*NO'
     C                   ENDIF

     C                   IF        REASON = RCNONE
     C                   EVAL      ObjExist = '*YES'
     C                   EXSR      CloseObj
     C                   ENDIF

     C                   ENDIF

      *  Disconnect from Queue Manager                                          CRP026
     C                   EXSR      QMDisc                                       CRP026
                                                                                CRP026
      ** End of "IF ObjectType = 'CHANNEL'"                                     000867
     C                   ENDIF                                                  000867
                                                                                000867
     C                   SETON                                        LR

     C                   RETURN
      /EJECT                                                                    CRP026
      ****************************************************************          CRP026
      *                                                              *          CRP026
      *  Connect to Queue Manager                                    *          CRP026
      *                                                              *          CRP026
      ****************************************************************          CRP026
     C     QMConnect     BEGSR                                                  CRP026
                                                                                CRP026
      * Queue Manager name is needed by Channel processing but that does not    000867
      *  involve connecting to the Queue Manager so move getting the name from  000867
      *  here to *inzsr.                                                        000867
                                                                                000867
      **Get*Queue*Manager name                                            CRP026000867
     C*******************CALLB     'RPBOIF99'                             CRP026000867
     C*******************PARM                    MQMNAME                  CRP026000867
     C*******************PARM                    ReturnedData             CRP026000867
     C*******************PARM                    ReturnedDataLn           CRP026000867
     C*******************EVAL      QueueMgrname =                         CRP026000867
     C*******************      %subst(ReturnedData : 1 : ReturnedDataLn)  CRP026000867
     C*******************IF        QueueMgrname = '*DFT'                  CRP026000867
     C*******************EVAL      QueueMgrname = *BLANK                  CRP026000867
     C*******************ENDIF                                            CRP026000867
                                                                                CRP026
      * Connect to Queue Manager                                                CRP026
     C****************** Z-ADD     MQCONN        CID                            CRP026
     C****************** CALL      'QMQM'                                       CRP026
     C****************** PARM                    CID               9 0          CRP026
     C****************** PARM                    QueueMgrname                   CRP026
     C****************** PARM                    HCONN             9 0          CRP026
     C****************** PARM                    OCODE             9 0          CRP026
     C****************** PARM                    REASON            9 0          CRP026

      /free
        callp MQCONN( QueueMgrName : HConn : CmpCod : Reason);
      /end-free
                                                                                CRP026
      ** Error if reason code not Okay and not Already connected                CRP026
     C                   IF            REASON <> RCNONE                         CRP026
     C                             AND REASON <> RC2002                         CRP026
                                                                                CRP026
      ** Set up alpha version of messages                                       CRP026
     C                   MOVE      REASON        ReasonA                        CRP026
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA               CRP026
                                                                                CRP026
      ** Cause a dump                                                           CRP026
     C                   EXSR      *PSSR                                        CRP026
     C                   RETURN                                                 CRP026
                                                                                CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
     C                   ENDSR                                                  CRP026
      ****************************************************************          CRP026
      /EJECT
      ****************************************************************
      *                                                              *
      *  Attempt to open Object                                      *
      *                                                              *
      ****************************************************************
     C     OpenObject    BEGSR

      ** Use input object name
     C                   EVAL      ODON = ObjToChk

      ** Open options: INQUIRY and FAIL_IF_QUIESCING
     C                   EVAL      OPTS = OOINQ + OOFIQ

      ** Set function to be performed as Open
     C*******************EVAL      CID = MQOPEN

     C*******************CALL      'QMQM'
     C*******************PARM                    CID               9 0
     C*******************PARM                    HCONN             9 0
     C*******************PARM                    MQOD
     C*******************PARM                    OPTS              9 0
     C*******************PARM                    HIN               9 0
     C*******************PARM                    OCODE             9 0
     C*******************PARM                    REASON            9 0

      /free
        callp MQOPEN( HConn : MQOD : Opts : HObj : CmpCod : Reason);
      /end-free

      ** Error if reason code not Okay
     C                   IF        REASON <> RCNONE
     C                             AND REASON <> RC2085                         097968

      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA
                                                                                200189
      ** Cause a dump                                                           200189
     C                   EXSR      *PSSR                                        200189
     C                   RETURN                                                 138019

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Close Object                                                *
      *                                                              *
      ****************************************************************
     C     CloseObj      BEGSR

      ** Close options: NONE
     C                   EVAL      OPTS = CONONE

      ** Set function to be performed as Close
     C****************** EVAL      CID = MQCLOS

     C****************** CALL      'QMQM'
     C****************** PARM                    CID               9 0
     C****************** PARM                    HCONN             9 0
     C****************** PARM                    HIN               9 0
     C****************** PARM                    OPTS              9 0
     C****************** PARM                    CCODE             9 0
     C****************** PARM                    REASON            9 0

      /free
        callp MQCLOSE(HCONN : HOBJ : OPTS : CMPCOD : REASON);
      /end-free

      ** Error processing
     C     REASON        IFNE      RCNONE

      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   RETURN                                                 138019

     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT                                                                    CRP026
      ****************************************************************          CRP026
      *                                                              *          CRP026
      *  Disconnect from Queue Manager                               *          CRP026
      *                                                              *          CRP026
      ****************************************************************          CRP026
     C     QMDisc        BEGSR                                                  CRP026
                                                                                CRP026
      * Disconnect from Queue Manager                                           CRP026
     C*******************Z-ADD     MQDISC        CID                            CRP026
     C*******************CALL      'QMQM'                                       CRP026
     C*******************PARM                    CID               9 0          CRP026
     C*******************PARM                    HCONN             9 0          CRP026
     C*******************PARM                    OCODE             9 0          CRP026
     C*******************PARM                    REASON            9 0          CRP026

      /free
        callp MQDISC(HCONN : CMPCOD : REASON);
      /end-free

      ** Error if reason code not Okay                                          CRP026
     C                   IF        REASON <> RCNONE                             CRP026
                                                                                CRP026
      ** Set up alpha version of messages                                       CRP026
     C                   MOVE      REASON        ReasonA                        CRP026
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA               CRP026
                                                                                CRP026
      ** Cause a dump                                                           CRP026
     C                   EXSR      *PSSR                                        CRP026
     C                   RETURN                                                 CRP026
                                                                                CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
     C                   ENDSR                                                  CRP026
      ****************************************************************          CRP026
     C/EJECT
      ********************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the program status subroutine
      ** without a RETURN or ENDSR.
     C/COPY RPCPYSRC,PSSR_ILENE

     C                   IF        ReturnCode = *BLANK
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF

     C                   RETURN

     C                   ENDSR
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *inzsr        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ObjToChk
     C                   PARM                    ObjectType
     C                   PARM                    ObjExist
     C                   PARM                    ReturnCode

      * Queue Manager name is needed by Channel processing but that does not    000867
      *  involve connecting to the Queue Manager so get the name here.          000867
     C                   CALLB     'RPBOIF99'                                   000867
     C                   PARM                    MQMNAME                        000867
     C                   PARM                    ReturnedData                   000867
     C                   PARM                    ReturnedDataLn                 000867
     C                   EVAL      QueueMgrName =                               000867
     C                               %subst(ReturnedData : 1 : ReturnedDataLn)  000867
     C                   IF        QueueMgrName = '*DFT'                        000867
     C                   EVAL      QueueMgrName = *BLANK                        000867
     C                   ENDIF                                                  000867
                                                                                000867
     C                   ENDSR
      ********************************************************************
