     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX MQ Series Input/Output')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXMQMIO - MQ Series Input/Output                             *
      *                                                               *
      *  Function:  This program gets messages from                   *
      *             and puts messages to an MQSeries queue.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244430             Date 07Jan05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW039             Date 15Sep05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268                                            *
      *  244430 - Parameter key should have length of 2 only.         *
      *  CSW039 - Add System/Priority to Correlation ID               *
      *  CMX001 - Meridian Export                                     *
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      **  Declare MQI structures needed
      * MQI Constants
     D/COPY QMQM/QRPGLESRC,CMQR
 
      ** Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODR
 
      ** Message Descriptor
     D MQMD            DS
     D/COPY QMQM/QRPGLESRC,CMQMDR
 
      ** Get message options
     D MQGMO           DS
     D/COPY QMQM/QRPGLESRC,CMQGMOR
 
      ** Put message options
     D MQPMO           DS
     D/COPY QMQM/QRPGLESRC,CMQPMOR
 
 
      ** The include below brings in the return code structure that
      ** is used in calls to OS/400 APIs.
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      * API Error code parameter
 
 
     C     *entry        plist
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Request
      ** Queue Manager                                                                      BUG17937
      * Queue Name
      * Message
     C                   parm                    p@request        10
     C                   parm                    p@qmnager        48                        BUG17937
     C                   parm                    p@queuenm        48
     C                   PARM                    p@msgbuf      32000
     C**********         parm                    p@key             4                   CSW039 244430
     C                   parm                    p@key             2                          244430
 
 
     C                   select
      *
      ** OPEN a queue
      *
     C     p@request     wheneq    '*OPEN_GET'
     C     p@request     oreq      '*OPEN_PUT'
     C                   exsr      sr_open
      *
      ** GET a message
      *
     C     p@request     wheneq    '*GET'
     C                   exsr      sr_get
      *
      ** PUT a message
      *
     C     p@request     wheneq    '*PUT'
     C                   exsr      sr_put
      *
      ** CLOSE a queue
      *
     C     p@request     wheneq    '*CLOSE'
     C                   exsr      sr_close
      *
     C                   endsl
      *
     C                   return
      /SPACE 5
      **********************************************************************
      * sr_put         : Put outgoing messages                             *
      * ------                                                             *
      **********************************************************************
     C     sr_put        begsr
 
      ** Get message length
 
     C     ' '           checkr    p@msgbuf      p@msglen
 
      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.
      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.
     C                   EVAL      MDFMT = FMSTR
     C                   movel     p@key         MDCID                                        CSW039
 
      ** Send message
     C                   Z-ADD     MQPUT         CID
     C                   Z-ADD     PMNMID        PMOPT
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    MQMD
     C                   PARM                    MQPMO
     C                   PARM                    p@msglen          9 0
     C                   PARM                    p@msgbuf
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
 
      ** If send message failed, indicate abnormal end
 
     C                   IF        REASON <> RCNONE
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES PUT MSG'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   endsr
      **********************************************************************
      /SPACE 5
      **********************************************************************
      * sr_get         : Get incoming messages                             *
      * ------                                                             *
      **********************************************************************
     C     sr_get        begsr
 
      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
      ** Note: the last of these options means that a message longer than
      ** the buffer length defined in this module (currently 1500 bytes)
      ** will be read and removed from the queue.  Any data in the message
      ** after the 1500th byte will be lost.
     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT
     C                   ADD       GMATM         GMOPT
 
      ** Set wait interval to 2 seconds
     C                   Z-ADD     2000          GMWI
 
      ** Perform get operation inside commitment control. Commitment
      ** boundary is after the message management file updates.
     C                   ADD       GMSYP         GMOPT
 
      ** MsgId and CorrelId are selectors cleared to ensure messages
      ** are processed in arrival/priority sequence
     C                   MOVEL     MINONE        MDMID
     C                   MOVEL     CINONE        MDCID
 
      ** Clear message buffer
     C                   clear                   p@msgbuf
 
      ** Get message
     C                   Z-ADD     MQGET         CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    MQMD
     C                   PARM                    MQGMO
     C                   PARM      32000         p@msglen          9 0
     C                   PARM                    p@msgbuf
     C                   PARM                    MESLEN            9 0
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
      *
      ** If receive message failed, indicate abnormal end
      *
     C     REASON        ifne      RCNONE
     C     REASON        andne     RC2033
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES GET MSG'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   endsr
      **********************************************************************
      /SPACE 5
      **********************************************************************
      * sr_open        : Open MQ series queue                              *
      * -------                                                            *
      **********************************************************************
     C     sr_open       begsr
 
      ** Use default connection handle, and implicit connection
     C                   Z-ADD     HCDEFH        HCONN
 
      ** Queue name
     C                   MOVEL     p@queuenm     ODON             48
 
      ** Queue Manager                                                                      BUG17937
     C                   Eval      ODMN = p@qmnager                                         BUG17937
      *                                                                                     BUG17937
      ** Connect to Queue Manager                                                           BUG17937
     C                   Eval      CID = MQCONN                                             BUG17937
      *                                                                                     BUG17937
     C                   Call      'QMQM'                                                   BUG17937
     C                   Parm                    CID               9 0                      BUG17937
     C                   Parm                    ODMN                                       BUG17937
     C                   Parm                    HCONN             9 0                      BUG17937
     C                   Parm                    OCODE             9 0                      BUG17937
     C                   Parm                    REASON            9 0                      BUG17937
      *                                                                                     BUG17937
      ** Report reason and stop if it failed                                                BUG17937
     C                   If        (REASON<>RCNONE)                                         BUG17937
     C                   Eval      I#ERMS = 'ERROR IN QUEUE MANAGER CONNECT'                BUG17937
     C                   Exsr      *PSSR                                                    BUG17937
     C                   Endif                                                              BUG17937
      *                                                                                     BUG17937
      ** Open queue for INPUT
 
     C     p@request     ifeq      '*OPEN_GET'
 
      ** Open options: INPUT and FAIL_IF_QUIESCING
     C     OOINPQ        ADD       OOFIQ         OPTS
 
      ** Open queue for OUTPUT
 
     C                   else
 
      ** Open options: OUTPUT and FAIL_IF_QUIESCING
     C     OOOUT         ADD       OOFIQ         OPTS
     C                   endif
 
      ** Open queue
     C                   Z-ADD     MQOPEN        CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    MQOD
     C                   PARM                    OPTS              9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    OCODE             9 0
     C                   PARM                    REASON            9 0
 
      ** If open queue failed, indicate abnormal end
 
     C     REASON        IFNE      RCNONE
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES OPEN Q'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   endsr
      **********************************************************************
      /SPACE 5
      **********************************************************************
      * sr_close       : Close MQ series queue                             *
      * --------                                                           *
      **********************************************************************
     C     sr_close      begsr
 
      ** Close options: NONE
     C                   Z-ADD     CONONE        OPTS
 
      ** Close queue
     C                   Z-ADD     MQCLOS        CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    OPTS              9 0
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
 
      ** If close queue failed, indicate abnormal end
 
     C     REASON        IFNE      RCNONE
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES CLOSE Q'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Disconnect
     C                   Eval      CID = MQDISC                                             BUG17937
      *                                                                                     BUG17937
     C                   Call      'QMQM'                                                   BUG17937
     C                   Parm                    CID               9 0                      BUG17937
     C                   Parm                    HCONN             9 0                      BUG17937
     C                   Parm                    OCODE             9 0                      BUG17937
     C                   Parm                    REASON            9 0                      BUG17937
      *                                                                                     BUG17937
      ** Report reason and stop if it failed                                                BUG17937
     C                   If        (REASON<>RCNONE)                                         BUG17937
     C                   Eval      I#ERMS = 'ERROR IN MQ SERIES CLOSE CONN'                 BUG17937
     C                   Exsr      *PSSR                                                    BUG17937
     C                   Endif                                                              BUG17937
      *                                                                                     BUG17937
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
