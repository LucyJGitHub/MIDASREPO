     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPSndMsg  - Send an MQSeries message                         *
      *                                                               *
      *  Function:  This module forwards a message to a               *
      *             specified queue                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. MD055679           Date 12May20               *
      *                 PMS-10473          Date 14Apr16               *
      *                 artf44103          Date 28Aug09               *
      *                 115092 Supportforce Date 25Apr06              *
      *                 CRP026             Date 18Jul05               *
      *                 093147 RoyalBlue   Date 12Apr02               *
      *                 177280             Date 03Apr00               *
      *                 CRP004             Date 05Aug99               *
      *                 CRP002             Date 13Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  MD055679 - MQ V9 issue - repmidas jobs                       *
      *           - Redeliver to update clients object. Also fix the  *
      *             copy source errors encountered during compilation.*
      *  PMS-10473 - MQ version 8 causes us problems where we're      *
      *              using OPM calls (or "compatibility mode," as     *
      *              IBM like to call it now) along with ILE calls.   *
      *              Replacing the old ones with modern ones, obvs.   *
      *                                                               *
      *  artf44103 - We were right-trimming blanks on messages being  *
      *              renamed, and using that length to send to MQ.    *
      *              That caused problems, as the receiving Meridian  *
      *              application expects fixed-format messages, and   *
      *              there can be fields at the end which are         *
      *              legitimately blank.                              *
      *                                                               *
      *              Just removing the trimming is no good, though,   *
      *              because that makes the sent message have a       *
      *              length of 6138: 6000 for the data, and 138 for   *
      *              the Meridian header.                             *
      *                                                               *
      *              So we have added a parameter to allow the caller *
      *              to tell us what the intended length of the       *
      *              target message is.                               *
      *                                                               *
      *  115092 - Make this program only disconnect if it got a new   *
      *           handle                                              *
      *  CRP026 - User specified Queue Manager added.                 *
      *  093147 - Added DUMPs when returning a non-blank return code. *
      *  177280 - Ensure a unique message ID is generated for each    *
      *           MQSeries message.                                   *
      *  CRP004 - TransData and associated fields increased in length *
      *           by 2000 bytes in /COPY STD_DCL.                     *
      *           Use of V3R7 BIFs re-introduced.                     *
      *  CRP002 - Change so that can be compiled below V3R7           *
      *                                                               *
      *****************************************************************
      *
      **  Declare MQI structures needed
      *      MQI Constants & Prototypes
     D/COPY QMQM/QRPGLESRC,CMQG

      *      Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODG

      *      Message Descriptor
     D MQMD            DS
     D/COPY QMQM/QRPGLESRC,CMQMDR

      *      Put message options
     D MQPMO           DS
     D/COPY QMQM/QRPGLESRC,CMQPMOG

      ** Other includes
      ** --------------

      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C***/COPY*RPCPYSRC,Mdn_Hd_DS                                                           MD055679
     C/COPY RPCPYSRC,MDN_HD_DS                                                              MD055679

      ** The following /COPY contains various standard declares
     C***/COPY*RPCPYSRC,Std_Dcl                                                             MD055679
     C/COPY RPCPYSRC,STD_DCL                                                                MD055679

      ** Declared variables
      ** ------------------

      ** Parameters
      **   Target queue
     D TgtQueue        S                   LIKE(MQSQueue)

      ** The length of the message that is to be sent
     D TgtMsgLen       S                   LIKE(DataLen)

      ** Parameters for the QMQM calls.
     D CID             S             10I 0
     D HCONN           S             10I 0
     D HOBJ            S             10I 0
     D BUFLEN          S             10I 0
     D CMPCOD          S             10I 0
     D REASON          S             10I 0
     D OCODE           S             10I 0
     D OPTS            S             10I 0

      ** 4-alpha and 6-alpha fields for the MQ error code
     D RCode4A         S              4A
     D RCode6A         S              6A   INZ('RC    ')

      ** Lengths of DS etc
     D MdnHeadLen      S              9P 0
     D* Make DataLen field compatible with called routine                       CRP002
     D*DataLen*********S              9P 0                                      CRP002
     D DataLen         S              5P 0                                      CRP002

      ** Data to be sent
     D*DataOut*********S           5000                                         CRP004
     D DataOut         S          +1000    LIKE(TransData)                      CRP004
                                                                                CRP002
      ***Copy*of*input*Transaction Data field                            CRP002 CRP004
      ****-*4096*long*to be compatible with called routine               CRP002 CRP004
     D*TrnDta4096******S           4096A                                 CRP002 CRP004
                                                                                CRP002
      ** Length of input Transaction Data field                                 CRP002
     D*TransDtaLn******S              5P 0 INZ(4000)                     CRP002 CRP004
     D TransDtaLn      S              5P 0                                      CRP004

      ** Queue Manager fields                                                   CRP026
     D MQMNAME         S             10A   INZ('MQMNAME   ')                    CRP026
     D ReturnedData    S             64A                                        CRP026
     D ReturnedDataLn  S              2P 0                                      CRP026
     D QueueMgrname    S             48A                                        CRP026
                                                                                115092
     D HandleObtained  S              1A                                        115092
                                                                                CRP026
      /EJECT
     C     Start         TAG                                                    CRP002
      ** Note: the above tag is only there to force the first comments in       CRP002
      ** the C-specs to appear after the D- or I-specs in compiled listings.    CRP002
                                                                                CRP002
      *  Connect to Queue Manager                                               CRP026
     C                   EXSR      QMConnect                                    CRP026
                                                                                CRP002
      ** Open MQSeries Transmission queue that is to be read                    CRP002
     C                   EXSR      OpenQueue                                    CRP002

     C***Set*the*length*of the data in the message ...                          CRP004
     C**Remove*use*of*%len as this is not supported below V3R7           CRP002 CRP004
     C*************      EVAL      DataLen = %LEN(%TRIMR(TransData))            CRP002
     C*******************EVAL      TrnDta4096 = TransData                CRP002 CRP004
     C*******************CALLB     'ZASTREND'                            CRP002 CRP004
     C*******************PARM                    ReturnCode              CRP002 CRP004
     C*******************PARM                    DataLen                 CRP002 CRP004
     C*******************PARM                    TrnDta4096              CRP002 CRP004
     C*******************PARM                    TransDtaLn              CRP002 CRP004
      **DataLen*now*contains the position of the first blank after all   CRP002 CRP004
      ***text,*reduce*this by 1 for the text length                      CRP002 CRP004
     C*******************EVAL      DataLen = DataLen -1                  CRP002 CRP004
                                                                                CRP004
      ** Set the length of the data in the message ...                          CRP004
     C*******************EVAL      DataLen = %LEN(%TRIMR(TransData))     CRP004 artf44103
      /free
       // Has the length parameter been passed?  (Note that the check         //artf44103
       // for it not being zero is to allow for the possibility that
       // the file (RPAPCIPD) contains the field, but it has not been
       // populated.
       if %parms > 5 and %addr(TgtMsgLen) <> *null and                        //artf44103
                   TgtMsgLen > 0;
                                                                              //artf44103
         // Then we use the passed value.                                     //artf44103
         DataLen = TgtMsgLen;                                                 //artf44103
                                                                              //artf44103
       else;                                                                  //artf44103
                                                                              //artf44103
         // Otherwise we just trim the data and use that length.              //artf44103
         DataLen = %len(%trimr(TransData));                                   //artf44103
                                                                              //artf44103
       endif;                                                                 //artf44103
      /end-free
                                                                                CRP002
      ** ... and add the Meridian Header length to get the buffer length
     C                   EVAL      BufLen = MdnHeadLen + DataLen
                                                                                CAP005
      ** Set up the data to be sent
     C                   EVAL      DataOut = MdnHeadDS + TransData
                                                                                CAP005
      ** Send the message
     C                   EVAL      MDFMT = FMSTR
     C*******************EVAL      CID = MQPUT

      * Clear the options field to ensure that we always start from             177280
      * zero before adding the option values to it.  Otherwise results          177280
      * can be unpredictable.                                                   177280
     C                   CLEAR                   PMOPT                          177280

      * Set the code to ensure that messages are created with a unique key      177280
      * (PMNID is a named constant defined in the CMQR /COPY member; PMOPT      177280
      *  is part of the MQPMO strucure, defined in the CMQPMOR /COPY            177280
      *  member).                                                               177280
     C                   ADD       PMNMID        PMOPT                          177280
                                                                                177280
     C                   IF        CommitCtl = 'Y'
      ** If requested, specify that syncpointing is required
     C****************** Z-ADD     PMSYP         PMOPT                          177280
     C                   ADD       PMSYP         PMOPT                          177280
     C                   ENDIF

     C*******************CALL      'QMQM'
     C*******************PARM                    CID
     C*******************PARM                    HCONN
     C*******************PARM                    HOBJ
     C*******************PARM                    MQMD
     C*******************PARM                    MQPMO
     C*******************PARM                    BUFLEN
     C*******************PARM                    DataOut
     C*******************PARM                    CCODE
     C*******************PARM                    REASON

      /free
         callp MQPUT( HConn : HObj : MQMD : MQPMO : BUFLEN :
                         %addr( DataOut ) : CmpCod : Reason);
      /end-free

      ** If an error occured, put the MQSeries return code into this
      ** module's return code.
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode

      ** If there has been a problem, provide a dump to aid debugging.          093147
     C                   DUMP                                                   093147

     C                   ENDIF

     C                   EXSR      CloseQueue

      ***Disconnect*from*Queue Manager                                   CRP026 115092
     C*******************EXSR      QMDisc                                CRP026 115092
                                                                                CRP026
      *  Disconnect from Queue Manager if and only if a Connect Handle          115092
      *   was obtained by this program                                          115092
     C                   IF        HandleObtained = 'Y'                         115092
     C                   EXSR      QMDisc                                       115092
     C                   ENDIF                                                  115092
                                                                                CRP026
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OpenQueue - Open the MQSeries queue                           *
      *                                                               *
      *****************************************************************

     C     OpenQueue     BEGSR
      *
      ** Set up MQSeries data necessary to open a queue
      ** Open the target message queue for output (and fail if
      ** MQM is quiescing)
      ** Resulting queue handle is HOBJ
      ** Options are Output and Fail-if-quiescing
      ** OOOUT and OOFIQ are MQ named constants, declared in the CMQR
      ** include member.  OPTS is a program-described field declared in the
      ** parameter list below.  MQOPEN is an MQ named constant, also
      ** defined in CMQR, and CID is the call identifier, which defines what
      ** kind of call is being made.
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C*******************EVAL      CID = MQOPEN

      ** ODON is a subfield of the MQOD data structure, which holds the
      ** name of the queue to be opened.  It is declared in the CMQODR
      ** include member.
     C                   EVAL      ODON = TgtQueue

      ** The call returns the parameter HOBJ, an object handle, which
      ** uniquely identifies the queue.  It is used later by the "Put" call.
      ** It also returns OCODE, a completion code, which tells us whether
      ** or not the call was successful, and REASON, which gives details
      ** if there was a failure.
     C*******************CALL      'QMQM'
     C*******************PARM                    CID
     C*******************PARM                    HCONN
     C*******************PARM                    MQOD
     C*******************PARM                    OPTS
     C*******************PARM                    HOBJ
     C*******************PARM                    OCODE
     C*******************PARM                    REASON

      /free
        callp MQOPEN(HConn : MQOD : Opts : HObj : CmpCod : Reason);
      /end-free

      ** Report reason, if any; stop if failed
      ** RCNONE is a named constant indicating no failure (it is zero).
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr
     C                   ENDIF

      ** CCFAIL is a named constant containing the value for OCODE
      ** indicating a failure to open the queue.
     C                   IF         OCODE = CCFAIL
     C                   EVAL      ReturnCode = 'ErrOpnOutP'
     C                   EXSR      *pssr
     C                   END

     C                   ENDSR

      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  CloseQueue - Close the MQSeries queue                       *
      *                                                              *
      ****************************************************************
     C     CloseQueue    BEGSR
      *
      ** Close options: NONE
      *
     C                   Z-ADD     CONONE        OPTS
      *
      ** Close queue
      *
     C*******************Z-ADD     MQCLOS        CID
     C*******************CALL      'QMQM'
     C*******************PARM                    CID               9 0
     C*******************PARM                    HCONN             9 0
     C*******************PARM                    HOBJ              9 0
     C*******************PARM                    OPTS              9 0
     C*******************PARM                    CCODE             9 0
     C*******************PARM                    REASON            9 0

      /free
        callp MQCLOSE(HCONN : HOBJ : OPTS : CMPCOD : REASON);
      /end-free

      ** Error processing
     C     REASON        IFNE      RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr

     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT                                                                    CRP026
      ****************************************************************          CRP026
      *                                                              *          CRP026
      *  Connect to Queue Manager                                    *          CRP026
      *                                                              *          CRP026
      ****************************************************************          CRP026
     C     QMConnect     BEGSR                                                  CRP026
                                                                                CRP026
      * Get Queue Manager name                                                  CRP026
     C                   CALLB     'RPBOIF99'                                   CRP026
     C                   PARM                    MQMNAME                        CRP026
     C                   PARM                    ReturnedData                   CRP026
     C                   PARM                    ReturnedDataLn                 CRP026
     C                   EVAL      QueueMgrname =                               CRP026
     C                               %subst(ReturnedData : 1 : ReturnedDataLn)  CRP026
     C                   IF        QueueMgrname = '*DFT'                        CRP026
     C                   EVAL      QueueMgrname = *BLANK                        CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
      * Connect to Queue Manager                                                CRP026
     C*******************Z-ADD     MQCONN        CID                            CRP026
     C*******************CALL      'QMQM'                                       CRP026
     C*******************PARM                    CID               9 0          CRP026
     C*******************PARM                    QueueMgrname                   CRP026
     C*******************PARM                    HCONN             9 0          CRP026
     C*******************PARM                    OCODE             9 0          CRP026
     C*******************PARM                    REASON            9 0          CRP026
                                                                                CRP026
      /free
        callp MQCONN( QueueMgrName : HConn : CmpCod : Reason);

        // If reason code is Already Connected then a handle has not been     //115092
        //  obtained otherwise one has been obtained.                         //115092
        if REASON = RC2002;                                                   //115092
           HandleObtained = 'N';                                              //115092
        else;                                                                 //115092
           HandleObtained = 'Y';                                              //115092
        endif;                                                                //115092
      /end-free
                                                                                115092
      ** Error if reason code not Okay and not Already connected                CRP026
     C                   IF            REASON <> RCNONE                         CRP026
     C                             AND REASON <> RC2002                         CRP026
     C                   EXSR      SetRetCode
     C                   EXSR      *PSSR                                        CRP026
     C                   RETURN                                                 CRP026
                                                                                CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
     C                   ENDSR                                                  CRP026
      ****************************************************************          CRP026
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
                                                                                CRP026
      /free
        callp MQDISC(HCONN : CMPCOD : REASON);
      /end-free

      ** Error if reason code not Okay                                          CRP026
     C                   IF        REASON <> RCNONE                             CRP026
     C                   EXSR      SetRetCode
     C                   EXSR      *PSSR                                        CRP026
     C                   RETURN                                                 CRP026
                                                                                CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
     C                   ENDSR                                                  CRP026
      ****************************************************************          CRP026
      /EJECT
      *****************************************************************
      *                                                               *
      * SetRetCode - Set the module return code                       *
      *                                                               *
      * Called by: Main, OpenQueue, CloseQueue                        *
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
     C                   EVAL      ReturnCode = 'Err' + RCode6A

     C                   ENDSR

      /EJECT
      ********************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine.
     C/COPY RPCPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *inzsr        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    TgtQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    TransData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
     C                   PARM                    TgtMsgLen                      artf44103

      ***Open*MQSeries*Transmission queue that is to be read                    CRP002
     C*******************EXSR      OpenQueue                                    CRP002

      ***Determine*length of the Meridian header                                CRP004
      **Remove*use*of*%len as this is not supported below V3R7           CRP002 CRP004
     C***************    EVAL      MdnHeadLen = %len(MdnHeadDS)
     C*******************EVAL      MdnHeadLen = 138                      CRP002 CRP004

      ** Determine length of the Meridian header                                CRP004
      * Minimum level is now V3R7 so %len is acceptable                         CRP004
     C                   EVAL      MdnHeadLen = %len(MdnHeadDS)                 CRP004
                                                                                CRP004
      ** Determine length of the Transaction Data field                         CRP004
     C                   EVAL      TransDtaLn = %len(TransData)                 CRP004

     C                   ENDSR

      ********************************************************************
      /EJECT
      ********************************************************************
