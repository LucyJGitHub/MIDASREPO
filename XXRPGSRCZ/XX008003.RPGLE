     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Extract MQ Series Input/Output')     *
      *****************************************************************
      *                                                               *
      *  Midas - Midas-Kondor Interface Customer Details              *
      *                                                               *
      *  XX008003 - Customer Extract MQ Series Input/Output           *
      *                                                               *
      *  Function:  This program gets messages from XX008002          *
      *             and puts messages to an MQSeries queue.           *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. DRI008  *Create    Date 28Jun23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DRI008 - Midas-Kondor Interface Customer Details             *
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
     D/COPY QMQM/QRPGLESRC,CMQG

      ** Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODG

      ** Message Descriptor
     D MQMD            DS
     D/COPY QMQM/QRPGLESRC,CMQMDG

      ** Get message options
     D MQGMO           DS
     D/COPY QMQM/QRPGLESRC,CMQGMOG

      ** Put message options
     D MQPMO           DS
     D/COPY QMQM/QRPGLESRC,CMQPMOG


      ** The include below brings in the return code structure that
      ** is used in calls to OS/400 APIs.
     D/COPY QSYSINC/QRPGLESRC,QUSEC

      ** MQ Parameters
     D HCONN           S             10I 0
     D HIN             S             10I 0
     D P@MsgLen        S             10I 0
     D CCODE           S             10I 0
     D OCODE           S             10I 0
     D REASON          S             10I 0
     D MESLEN          S             10I 0
     D OPTS            S             10I 0

      * API Error code parameter


     C     *entry        plist
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Request
      * Queue Manager
      * Queue Name
      * Message
     C                   parm                    p@request        10
     C                   parm                    p@qmnager        48
     C                   parm                    p@queuenm        48
     C                   PARM                    p@msgbuf      32000
     C                   parm                    p@key             2
     C                   parm                    p@msglen


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

     C                   if        p@msglen = 0
     C     ' '           checkr    p@msgbuf      p@msglen
     C                   EndIf

      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.
      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.
     C                   EVAL      MDFMT = FMSTR
     C                   movel     p@key         MDCID

      ** Send message
     C                   Z-ADD     PMNMID        PMOPT

     C                   CALLP     MQPUT( HCONN : HIN : MQMD : MQPMO :
     C                                    P@MsgLen : %ADDR(P@MsgBuf) :
     C                                    CCODE : REASON )

      ** If send message failed, indicate abnormal end

     C                   IF        REASON <> RCNONE
     C                   Eval      DBASE = 5
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

     C                   Z-ADD     32000         P@MsgLen
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :
     C                                    P@MsgLen : %ADDR(P@MsgBuf) :
     C                                    MESLEN : CCODE : REASON )
      *
      ** If receive message failed, indicate abnormal end
      *
     C     REASON        ifne      RCNONE
     C     REASON        andne     RC2033
     C                   Eval      DBASE = 6
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

      ** Queue Manager
     C                   Eval      ODMN = p@qmnager
      *
      ** Connect to Queue Manager

     C                   CALLP     MQCONN( ODMN : HCONN :
     C                                     OCODE : REASON )
      *
      ** Report reason and stop if it failed
     C                   If        (REASON<>RCNONE)
     C                   Eval      DBASE = 1
     C                   Eval      I#ERMS = 'ERROR IN QUEUE MANAGER CONNECT'
     C                   Exsr      *PSSR
     C                   Endif
      *
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

     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :
     C                                     HIN : OCODE: REASON )

      ** If open queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   EVAL      DBASE = 2
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

     C                   CALLP     MQCLOSE( HCONN : HIN : OPTS :
     C                                      CCODE : REASON )

      ** If close queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   EVAL      DBASE  = 3
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES CLOSE Q'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Disconnect

     C                   CALLP     MQDISC( HCONN : OCODE : REASON )
      *
      ** Report reason and stop if it failed
     C                   If        (REASON<>RCNONE)
     C                   EVAL      DBASE = 4
     C                   Eval      I#ERMS = 'ERROR IN MQ SERIES CLOSE CONN'
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  *PSSR    : PSSR subroutine                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
      *
      *
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2023
