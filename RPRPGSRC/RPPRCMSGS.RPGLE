     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPPrcMsgs - Process messages on Transmission queue           *
      *                                                               *
      *  Function:  This module:                                      *
      *             - reads messages from a Transmission queue        *
      *             - determines if additional processing is needed   *
      *             - calls the specified program if necessary        *
      *             - forwards the message to the queue if not        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. artf44103           Date 28Aug09              *
      *                 115092 Supportforce Date 25Apr06              *
      *                 000891 Bugzilla    Date 21Apr06               *
      *                 CRP026             Date 18Jul05               *
      *                 093147 RoyalBlue   Date 12Apr02               *
      *                 CRP004             Date 05Aug99               *
      *                 CRP003             Date 12Oct99               *
      *                 CRP002             Date 13Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  artf44103 - We were right-trimming blanks on messages being  *
      *              renamed, and using that length to send to MQ.    *
      *              That caused problems, as the receiving Meridian  *
      *              application expects fixed-format messages, and   *
      *              there can be fields at the end which are         *
      *              legitimately blank.                              *
      *                                                               *
      *              RPSNDMSG now has a parameter containing the      *
      *              length of the target message.  This procedure    *
      *              gets that value from RPAPCIPD, and passes it to  *
      *              RPSNDMSG.                                        *
      *                                                               *
      *  115092 - Change MQ options from calls to QMQM to calls to    *
      *           MQxxxx so that RPTRGMON and RPPRCSMSGS have         *
      *           separate connection handles and when RPPRCMSGS      *
      *           disconnects it does not affect RPTRGMON.            *
      *           As on OS/400 the scope of the handle is the job     *
      *           issuing the call, this is not correct. Instead make *
      *           this program only disconnect if it got a new handle *
      *  000891 - Remove unconditional dumps accidentally added       *
      *           at V1R6M0.                                          *
      *           As the code should never have been there it has     *
      *           been removed but some of the debugging has been     *
      *           kept.                                               *
      *  CRP026 - User specified Queue Manager added.                 *
      *  093147 - Added DUMPs when returning a non-blank return code. *
      *  CRP004 - TransData and associated fields increased in length *
      *           by 2000 bytes in /COPY STD_DCL.                     *
      *           Use of V3R7 BIFs re-introduced.                     *
      *  CRP003 - Addition of Renaming of Message Type as well as the *
      *           Program option.                                     *
      *           Added COMMIT and ROLLBACK processing for action     *
      *           of program (if commitment control is being used).   *
      *  CRP002 - Change so that can be compiled below V3R7           *
      *                                                               *
      *****************************************************************
      /EJECT
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FRPAPCIL0  IF   E           K DISK    USROPN

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Change /COPYs to those needed by new MQ calls                          115092
      ****Declare*MQI*structures needed                                         115092
      *******MQI*Constants*****                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQR                                                 115092
      *************************                                                 115092
      *******Object*Descriptor*                                                 115092
     D*MQOD************DS******                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQODR                                               115092
      *************************                                                 115092
      *******Message*Descriptor                                                 115092
     D*MQMD************DS******                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQMDR                                               115092
      *************************                                                 115092
      *******Get*message*options                                                115092
     D*MQGMO***********DS******                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQGMOR                                              115092
      *************************                                                 115092
      *******Put*message*options                                                115092
     D*MQPMO***********DS******                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQPMOR                                              115092
                                                                                115092
      **  Declare MQI structures needed                                         115092
      *      MQI Constants & Prototypes                                         115092
     D/COPY QMQM/QRPGLESRC,CMQG                                                 115092
                                                                                115092
      *      Object Descriptor                                                  115092
     D MQOD            DS                                                       115092
     D/COPY QMQM/QRPGLESRC,CMQODG                                               115092
                                                                                115092
      *      Message Descriptor                                                 115092
     D MQMD            DS                                                       115092
     D/COPY QMQM/QRPGLESRC,CMQMDR                                               115092
                                                                                115092
      *      Get message options                                                115092
     D MQGMO           DS                                                       115092
     D/COPY QMQM/QRPGLESRC,CMQGMOG                                              115092
                                                                                115092
      *      Put message options                                                115092
     D MQPMO           DS                                                       115092
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                              115092

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
     C*COPY*RPCPYSRC,Std_Dcl
     C/COPY RPCPYSRC,STD_DCL

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C*COPY*RPCPYSRC,Mdn_Hd_DS
     C/COPY RPCPYSRC,MDN_HD_DS

      ***Data*structure*for incoming message formats - length set at 5000       CRP004
      ****as*it*is*very*unlikely ever to be longer than this                    CRP004
      ***N.B.*this*includes the MQ header and the Meridian header as well       CRP004
      ****as*the*transaction data                                               CRP004
     D*Buffer**********DS          5000                                         CRP004
                                                                                CRP004
      ** Data structure for incoming message formats - length set at 7000       CRP004
      **  as it is very unlikely ever to be longer than this                    CRP004
      ** N.B. this includes the MQ header and the Meridian header as well       CRP004
      **  as the transaction data                                               CRP004
     D Buffer          DS          7000                                         CRP004

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters
      **   Input queue name
     D InQueue         S                   LIKE(MQSQueue)
      **   Output queue name
     D OutQueue        S                   LIKE(MQSQueue)

      ** Alpha version of the MQSeries reason code
      ** Change to 4 long so as to get the RH digits from the numeric field     000891
     D*ReasonA*********S              9A                                        000891
     D ReasonA         S              4A                                        000891

      ** Meridian header length
     D MdnHeadLen      S              3S 0

      ** Data length - after MQSeries header & Meridian header
     D DataLen         S              4S 0
      ** Data start position - after MQSeries header & Meridian header
     D DataStart       S              4S 0

      ** Work fields
      ** Action to take with message read                                       CRP003
     D Action          S             10A   INZ(*BLANK)                          CRP003

     D CurrentStatus   S             50A   INZ(*BLANK)                          000891
                                                                                000891
      ** Queue Manager fields                                                   CRP026
     D MQMNAME         S             10A   INZ('MQMNAME   ')                    CRP026
     D ReturnedData    S             64A                                        CRP026
     D ReturnedDataLn  S              2P 0                                      CRP026
     D QueueMgrname    S             48A                                        CRP026
                                                                                CRP026
      ** Fields used in MQ calls                                                115092
     D HConn           S             10I 0                                      115092
     D CmpCod          S             10I 0                                      115092
     D Reason          S             10I 0                                      115092
     D HObj            S             10I 0                                      115092
     D Opts            S             10I 0                                      115092
     D BufLen          S             10I 0                                      115092
     D MesLen          S             10I 0                                      115092
                                                                                115092
     D HandleObtained  S              1A                                        115092
                                                                                115092
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

      ** Open the control file explicitly, to ensure that the correct
      **  member is accessed
     C                   OPEN      RPAPCIL0

                                                                                000891
     c                   eval      CurrentStatus =                              000891
     c                              'RPAPCIPD member opened'                    000891
                                                                                000891
      ** Loop until no messages left
     C                   DOU       Buffer = *blank

     C                   EXSR      GetMsg

     C                   IF        Buffer = *blank
     C                   LEAVE
     C                   ENDIF

      ** Extract Meridian header, which is after MQSeries header
     C                   EVAL      MdnHeadDS =
     C                                  %subst(Buffer:MQHeadLen:MdnHeadLen)

      ** Extract transaction data, which is after Meridian header
     C                   EVAL      DataStart = MQHeadLen + MdnHeadLen
     C                   EVAL      DataLen = BufLen - MQHeadLen - MdnHeadLen
     C                   EVAL      TransData =
     C                                  %subst(Buffer:DataStart:DataLen)

      ** Use Message Type from Meridian header to access control file
     C     RAMSGTYPE     CHAIN     RPAPCIL0                           7099

                                                                                000891
     c                   eval      CurrentStatus =                              000891
     c                              'RPAPCIPD record accessed'                  000891
                                                                                000891
      ** If error, set return code and exit
     C                   IF        *in99  = '1'
     C                   EVAL      ReturnCode = 'ErrRPAPIC'
     C                   RETURN
     C                   ENDIF

      ** Processing has been restructured, so for clarity all of the code       CRP003
      **  has been removed and new code, that is similar in places, has         CRP003
      **  been added.                                                           CRP003
      ***If*no*record*found or the Additional Processing Flag is not on         CRP003
      ****then*call*a*routine to write the message to the target queue          CRP003
     C*******************IF        *in70  = '1' OR RBAddProc <> 'Y'             CRP003
     C*******************CALLB     'RPSNDMSG'                                   CRP003
     C*******************PARM                    OutQueue                       CRP003
     C*******************PARM                    MdnHeadDS                      CRP003
     C*******************PARM                    TransData                      CRP003
     C*******************PARM                    CommitCtl                      CRP003
     C*******************PARM                    ReturnCode                     CRP003
      *******************                                                       CRP003
      ***If*error*then*exit, with rollback if appropriate                       CRP003
     C*******************IF        ReturnCode <> *blank                         CRP003
     C*******************IF        CommitCtl = 'Y'                              CRP003
     C*******************ROLBK                                                  CRP003
     C*******************ENDIF                                                  CRP003
     C*******************RETURN                                                 CRP003
     C*******************ENDIF                                                  CRP003
      *******************                                                       CRP003
      ***If*successful*then commit changes if appropriate                       CRP003
     C*******************IF        CommitCtl = 'Y'                              CRP003
     C*******************COMMIT                                                 CRP003
     C*******************ENDIF                                                  CRP003
      *******************                                                       CRP003
      ***This*message*has been fully processed - move on to next one            CRP003
     C*******************ITER                                                   CRP003
      *******************                                                       CRP003
     C*******************ENDIF                                                  CRP003
      *******************                                                       CRP003
      ***A*record*was*found and the Additional Processing Flag is on            CRP003
      ****so*call*the*specified program                                         CRP003
     C*******************IF        *in70  = '0' AND RBAddProc = 'Y'             CRP003
     C*******************CALL      RBPROGRAM                                    CRP003
     C*******************PARM                    OutQueue                       CRP003
     C*******************PARM                    MdnHeadDS                      CRP003
     C*******************PARM                    TransData                      CRP003
     C*******************PARM                    CommitCtl                      CRP003
     C*******************PARM                    ReturnCode                     CRP003
      *******************                                                       CRP003
      ***If*error*then*exit                                                     CRP003
     C*******************IF        ReturnCode <> *blank                         CRP003
     C*******************RETURN                                                 CRP003
     C*******************ENDIF                                                  CRP003
      *******************                                                       CRP003
     C*******************ENDIF                                                  CRP003
                                                                                CRP003
      ** The Additional Processing Flag can have one of two values              CRP003
      **  - 'P' for Call the associated program                                 CRP003
      **  - 'R' for Rename the Message Type to the associated value             CRP003
      ** Any other value (including blank) is taken to mean that no special     CRP003
      **  action is required, this might be used during testing.                CRP003
                                                                                CRP003
     C                   RESET                   Action                         CRP003
                                                                                CRP003
      ** If no record found or the Additional Processing Flag is not one        CRP003
      **  of the permitted values, the required action is to call a             CRP003
      **  routine to write the message to the target queue                      CRP003
     C                   IF            *in70  = '1'                             CRP003
     C                             OR  *in70  = '0'                             CRP003
     C                             AND RBAddProc <> 'P'                         CRP003
     C                             AND RBAddProc <> 'R'                         CRP003
     C                   Eval      Action = 'Forward'                           CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
      ** If a record was found and the Additional Processing Flag specifies     CRP003
      **  a rename of the message type has been specified, the required         CRP003
      **  action is to rename the value on the message header.                  CRP003
     C                   IF            *in70  = '0'                             CRP003
     C                             AND RBAddProc = 'R'                          CRP003
     C                             AND RBNewType <> *Blanks                     CRP003
     C                   Eval      Action = 'Rename'                            CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
      ** If a record was found and the Additional Processing Flag specifies     CRP003
      **  a program call, the required action is to call that program           CRP003
     C                   IF            *in70  = '0'                             CRP003
     C                             AND RBAddProc = 'P'                          CRP003
     C                   Eval      Action = 'Program'                           CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
      ** Forward and Rename processing are similar and are processed            CRP003
      **  together                                                              CRP003
     C                   IF        Action = 'Rename'                            CRP003
     C                   Eval      RAMsgType = RBNewType                        CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
     C                   IF           Action = 'Forward'                        CRP003
     C                             OR Action = 'Rename'                         CRP003
     C                   CALLB     'RPSNDMSG'                                   CRP003
     C                   PARM                    OutQueue                       CRP003
     C                   PARM                    MdnHeadDS                      CRP003
     C                   PARM                    TransData                      CRP003
     C                   PARM                    CommitCtl                      CRP003
     C                   PARM                    ReturnCode                     CRP003
     C                   PARM                    RBTGTMSGLN
                                                                                CRP003
      ** If error then exit, with rollback if appropriate                       CRP003
     C                   IF        ReturnCode <> *blank                         CRP003

     C                   IF        CommitCtl = 'Y'                              CRP003
     C                   ROLBK                                                  CRP003
     C                   ENDIF                                                  CRP003
                                                                                093147
      ** If there has been a problem, produce a dump to aid debugging           093147
     C                   DUMP                                                   093147
     C                   RETURN                                                 CRP003

     C                   ENDIF                                                  CRP003
                                                                                CRP003
      ** If successful then commit changes if appropriate                       CRP003
     C                   IF        CommitCtl = 'Y'                              CRP003
     C                   COMMIT                                                 CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
      ** This message has been fully processed - move on to next one            CRP003
     C                   ITER                                                   CRP003
                                                                                CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
                                                                                000891
     c                   eval      CurrentStatus =                              000891
     c                              'About to do program processing'            000891
                                                                                000891
      ** Program processing                                                     CRP003
     C                   IF        Action = 'Program'                           CRP003
     C                   CALL      RBPROGRAM                                    CRP003
     C                   PARM                    OutQueue                       CRP003
     C                   PARM                    MdnHeadDS                      CRP003
     C                   PARM                    TransData                      CRP003
     C                   PARM                    CommitCtl                      CRP003
     C                   PARM                    ReturnCode                     CRP003
                                                                                000891
     c                   eval      CurrentStatus =                              000891
     c                              'After program processing'                  000891
                                                                                CRP003
      ** If error then exit                                                     CRP003
     C                   IF        ReturnCode <> *blank                         CRP003
     C                   IF        CommitCtl = 'Y'                              CRP003
     C                   ROLBK                                                  CRP003
     C                   ENDIF                                                  CRP003
                                                                                093147
      ** If there has been a problem, produce a dump to aid debugging           093147
     C                   DUMP                                                   093147
     C                   RETURN                                                 CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
      ** If successful then commit changes if appropriate                       CRP003
     C                   IF        CommitCtl = 'Y'                              CRP003
     C                   COMMIT                                                 CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
     C                   ENDIF                                                  CRP003
                                                                                CRP003
     C                   ENDDO

      ** Close the control file to ensure that the correct member is used
      **  next time
     C                   CLOSE     RPAPCIL0


     C                   EXSR      CloseQueue

      ***Disconnect*from*Queue Manager                                   CRP026 115092
     C*******************EXSR      QMDisc                                CRP026 115092
                                                                                CRP026
      *  Disconnect from Queue Manager if and only if a Connect Handle          115092
      *   was obtained by this program                                          115092
     C                   IF        HandleObtained = 'Y'                         115092
     C                   EXSR      QMDisc                                       115092
     C                   ENDIF                                                  115092
                                                                                115092
     C                   SETON                                        LR

     C                   RETURN
      /EJECT
      ****************************************************************
      *                                                              *
      *  Open receiving queue for input                              *
      *                                                              *
      ****************************************************************
     C     OpenQueue     BEGSR

      ** Use input queue
     C                   MOVEL     InQueue       ODON             48

      ** Open options: INPUT and FAIL_IF_QUIESCING
     C     OOINPQ        ADD       OOFIQ         OPTS

      ** Open queue
     C*******************Z-ADD     MQOPEN        CID                            115092
     C*******************CALL      'QMQM'                                       115092
     C*******************PARM                    CID               9 0          115092
     C*******************PARM                    HCONN             9 0          115092
     C*******************PARM                    MQOD                           115092
     C*******************PARM                    OPTS              9 0          115092
     C*******************PARM                    HIN               9 0          115092
     C*******************PARM                    OCODE             9 0          115092
     C*******************PARM                    REASON            9 0          115092
      /free
        callp MQOPEN( HCONN : MQOD : OPTS : HOBJ : CMPCOD : REASON);          //115092
      /end-free

      ** Error processing
     C     REASON        IFNE      RCNONE

      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   RETURN                                                 138019

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Wait for incoming messages                                  *
      *                                                              *
      ****************************************************************
     C     GETMSG        BEGSR

      ** Get options: WAIT and CONVERT
     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT

      ** Allow truncation of message
     C                   ADD       GMATM         GMOPT

      ** Set wait interval to zero
     C                   Z-ADD     *zero         GMWI

     C                   IF        CommitCtl = 'Y'
      ** Perform get operation inside commitment control if requested.
     C                   ADD       GMSYP         GMOPT
     C                   ENDIF

      ** MsgId and CorrelId are selectors cleared to ensure messages
      ** are processed in arrival/priority sequence
     C                   MOVEL     MINONE        MDMID
     C                   MOVEL     CINONE        MDCID

      ** Clear message buffer
     C                   MOVEL     *BLANKS       BUFFER

      ** Get message
     C*******************Z-ADD     MQGET         CID                            115092
     C*******************CALL      'QMQM'                                       115092
     C*******************PARM                    CID               9 0          115092
     C*******************PARM                    HCONN             9 0          115092
     C*******************PARM                    HIN               9 0          115092
     C*******************PARM                    MQMD                           115092
     C*******************PARM                    MQGMO                          115092
     C*******************PARM                    BUFLEN            9 0          115092
     C*******************PARM                    BUFFER                         115092
     C*******************PARM                    MESLEN            9 0          115092
     C*******************PARM                    CCODE             9 0          115092
     C*******************PARM                    REASON            9 0          115092
      /free
        callp MQGET( HCONN : HOBJ : MQMD : MQGMO : BUFLEN :
                           %addr( Buffer) : MESLEN : CMPCOD : REASON);        //115092
      /end-free

      ** Error processing
      ** Reason code 2079 = 'Message truncated'                                 CRP004
      ** Reason code 2033 = 'No message available'                              CRP004
     C                   IF        Reason <> RCNONE AND Reason <> 2079
     C                             AND Reason <> 2033

      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   RETURN                                                 138019

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Close input queue                                           *
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
     C*******************Z-ADD     MQCLOS        CID                            115092
     C*******************CALL      'QMQM'                                       115092
     C*******************PARM                    CID               9 0          115092
     C*******************PARM                    HCONN             9 0          115092
     C*******************PARM                    HIN               9 0          115092
     C*******************PARM                    OPTS              9 0          115092
     C*******************PARM                    CCODE             9 0          115092
     C*******************PARM                    REASON            9 0          115092
      /free
        callp MQCLOSE( HCONN : HOBJ : OPTS : CMPCOD : REASON);                //115092
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
      /free
        callp MQCONN( QueueMgrName : HCONN : CMPCOD : REASON);                //115092
                                                                              //115092
        // If reason code is Already Connected then a handle has not been     //115092
        //  obtained otherwise one has been obtained.                         //115092
        if REASON = RC2002;                                                   //115092
           HandleObtained = 'N';                                              //115092
        else;                                                                 //115092
           HandleObtained = 'Y';                                              //115092
        endif;                                                                //115092
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
        callp MQDISC( HCONN : CMPCOD : REASON);                               //115092
      /end-free
                                                                                CRP026
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
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY RPCPYSRC,PSSR_ILE
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
     C                   PARM                    InQueue
     C                   PARM                    OutQueue
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode

      *  Connect to Queue Manager                                               CRP026
     C                   EXSR      QMConnect                                    CRP026
                                                                                CRP026
      ** Open MQSeries Transmission queue that is to be read
     C                   EXSR      OpenQueue

      ***Determine*length*of*the*I/P*buffer*&*Meridian*header******             CRP004
      **Remove*use*of*%len*as*this*is*not*supported*below*V3R7*****      CRP002 CRP004
     C**************     EVAL      BufLen = %len(Buffer)                        CRP002
     C**************     EVAL      MdnHeadLen = %len(MdnHeadDS)                 CRP002
     C*************      EVAL      BufLen = 5000                         CRP002 CRP004
     C*************      EVAL      MdnHeadLen = 138                      CRP002 CRP004
                                                                                CRP004
      ** Determine length of the I/P buffer & Meridian header                   CRP004
      **  Minimum level is now V3R7 so %len is okay.                            CRP004
     C                   EVAL      BufLen = %len(Buffer)                        CRP004
     C                   EVAL      MdnHeadLen = %len(MdnHeadDS)                 CRP004
                                                                                000891
     c                   eval      CurrentStatus =                              000891
     c                              'End of *inzsr'                             000891
                                                                                CRP004
     C                   ENDSR
      ********************************************************************
