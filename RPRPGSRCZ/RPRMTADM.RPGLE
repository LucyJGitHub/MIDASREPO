     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Process Remote Administration Messages')
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RPPrcMsgs - Process messages on Transmission queue           *
      *                                                               *
      *  Function:  This module:                                      *
      *             - reads messages from a Transmission queue        *
      *             - determines if additional processing is needed   *
      *             - calls the specified program if necessary        *
      *             - forwards the message to the queue if not        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CPB002  *CREATE    Date 01Jun99               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *           Midas/TOF interface.                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **  Declare MQI structures needed
 
      **  MQI Constants
     D/COPY QMQM/QRPGLESRC,CMQR
      *      Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODR
      *      Message Descriptor
     D MQMD            DS
     D/COPY QMQM/QRPGLESRC,CMQMDR
      *      Get message options
     D MQGMO           DS
     D/COPY QMQM/QRPGLESRC,CMQGMOR
      *      Put message options
     D MQPMO           DS
     D/COPY QMQM/QRPGLESRC,CMQPMOR
 
      **  Trigger message structure (character format)
     D MQTMCR          DS
     D/COPY QMQM/QRPGLESRC,CMQTMCR
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **  The following /COPY contains various standard declarations.
     C/COPY RPCPYSRC,Std_Dcl
      *
      ** The following /COPY contains the layout of the Meridian
      ** a data structure
     D/COPY RPCPYSRC,Mdn_Hd_DS
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Data structure for compilation  - Copyright insertion.
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
 
      **  Array for error messages.
     D ArrErrorMsg     S             80    DIM(1) PERRCD(1)
     D                                     CTDATA
 
      **  Data structure for incoming message formats - length set at 5000
      **  as it is very unlikely ever to be longer than this.
     D Buffer          DS          5000
     D Length          S             15S 0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of parameters --------------------**
 
      **  Output queue name.
     D OutQueue        S                   Like(MQSQueue)
 
      ** Work fields
 
      ** Alpha version of the MQSeries reason code
     D ReasonA         S              9A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *                 M a i n   p r o c e s s i n g                 *
      *                                                               *
      *****************************************************************
 
     C     Start         TAG
      **  Note: the above tag is only there to force the first commments in the
      **        C-specs to appear after the D- or I-specs in compiled listings.
 
      ** Loop until no messages left
     C                   DOU       Buffer = *blank
 
     C                   EXSR      GetMsg
 
     C                   If        Buffer = *blank
     C                   LEAVE
 
     C                   Endif
 
      ** A record was found and the Additional Processing Flag is on
      **  so call the specified program
     C                   Eval      Length = %Len(%Trim(Buffer))
     C                   Move      Length        P_Length
     C                   Call      'RPC1312'
     C                   Parm      *blanks       P_ReturnCode      2
     C                   Parm      Buffer        P_Command       256
     C                   Parm                    P_Length         15
     C                   Parm      *blanks       P_Msgid           7
     C                   Parm      *blanks       P_Msgdta        256
     C                   Parm      *blanks       P_Msgf           10
     C                   Parm      *blanks       P_Msgflib        10
 
      **  If Run Command program ended abnormally.
     C     P_ReturnCode  Ifne      *blanks                                      Begin P_ReturnCode
      **  or if any message was sent while running command.
     C     P_Msgid       Orne      *blanks
     C                   Rolbk
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End P_Msgid
     C                   ENDDO
 
     C                   EXSR      CloseQueue
 
     C                   SETON                                        LR
 
     C                   RETURN
      ****************************************************************
      *                                                              *
      *  OpenQueue - Open receiving queue for input.                 *
      *                                                              *
      *  Called by : *Inzsr                                          *
      *                                                              *
      *  Calls     : None                                            *
      *                                                              *
      ****************************************************************
     C     OpenQueue     BEGSR
 
      ** Use input queue.
     C                   MOVEL     TCQN          ODON             48
 
      ** Open options: INPUT and FAIL_IF_QUIESCING.
     C     OOINPQ        ADD       OOFIQ         OPTS
 
      ** Open queue.
     C                   Z-ADD     MQOPEN        CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    MQOD
     C                   PARM                    OPTS              9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    OCODE             9 0
     C                   PARM                    REASON            9 0
 
      ** Error processing
     C     REASON        IFNE      RCNONE
 
      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA
     C*                  EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   SETON                                        LR
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      *                                                              *
      *  Getmsg    - Wait for incoming messages.                     *
      *                                                              *
      *  Called by : Main processing.                                *
      *                                                              *
      *  Calls     : None                                            *
      *                                                              *
      *                                                              *
      ****************************************************************
     C     GETMSG        BEGSR
 
      ** Get options: WAIT and CONVERT
     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT
 
      **  Allow truncation of message
     C                   ADD       GMATM         GMOPT
 
      **  Set wait interval to zero
     C                   Z-ADD     *zero         GMWI
 
      **  Perform get operation inside commitment control if requested.
     C                   IF        CommitCtl = 'Y'
     C                   ADD       GMSYP         GMOPT
 
     C                   ENDIF
 
      **  MsgId and CorrelId are selectors cleared to ensure messages
      **  are processed in arrival/priority sequence
     C                   MOVEL     MINONE        MDMID
     C                   MOVEL     CINONE        MDCID
 
      **  Clear message buffer.
     C                   MOVEL     *BLANKS       BUFFER
 
      **  Get message.
     C                   Z-ADD     MQGET         CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    MQMD
     C                   PARM                    MQGMO
     C                   PARM                    BUFLEN            9 0
     C                   PARM                    BUFFER
     C                   PARM                    MESLEN            9 0
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
 
      **  Error processing.
     C                   If        Reason <> RCNONE AND Reason <> 2079
     C                             AND Reason <> 2033
 
      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA
     C*                  EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   RETURN
 
     C                   Endif
 
     C                   ENDSR
      ****************************************************************
      *                                                              *
      *  CloseQueue - Close input queue.                             *
      *                                                              *
      *  Called by : Main processing.                                *
      *                                                              *
      *  Calls     : None                                            *
      *                                                              *
      ****************************************************************
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
     C                   Z-ADD     MQCLOS        CID
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    HIN               9 0
     C                   PARM                    OPTS              9 0
     C                   PARM                    CCODE             9 0
     C                   PARM                    REASON            9 0
 
      ** Error processing
     C     REASON        IFNE      RCNONE
 
      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA
     C*                  EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   RETURN
 
     C                   ENDIF
      *
     C                   ENDSR
      /Eject
      *****************************************************************
      /Title SR/#Sndms
      *****************************************************************
      *  #Sndms - Subroutine to send message to Program's Message     *
      *              Queue.                                           *
      *                                                               *
      *  Called by: Main processing                                   *
      *             #Vlsfl                                            *
      *                                                               *
      *  Calls:     None                                              *
      *****************************************************************
     C     #Sndms        Begsr                                                  ** #Sndms SR **
 
     C                   Call      'SNDERMSG'
     C                   Parm                    P@PgmQueue       10            Program queue
     C                   Parm                    P@CallMsgQueue    5            Rel queue
     C                   Parm                    P@MsgId           7            Message Id.
     C                   Parm                    P@MsgFile        10            Message file.
     C                   Parm                    P@MsgDta        132            Message data.
     C                   Parm                    P@MsgType         7            Message type.
 
     C                   Endsr
      /Eject
      ********************************************************************
      ********************************************************************
      **-------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C*COPY RPCPYSRC,PSSR_ILE        *MBR INCLUDED BELOW*
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  PSSR_ILE - ILE RPG Program status subroutine                 *
      *                                                               *
      *  Last Amend No. Xnnnnn  *CREATE    Date ddmmmyy               *
      *  Prev Amend No. nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  nnnnnn - (fix details)                                       *
      *                                                               *
      *****************************************************************
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *pssr         BEGSR
 
     C                   EVAL      *inu7 = *on
     C                   EVAL      *inu8 = *on
     C                   EVAL      *inlr = *on
 
     C                   IF        RunBefore <> 'Y'
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
      * End of /COPY PSSR_ILE                                         *
      *****************************************************************
      **-------------------------------------------------------------------
      *****************************************************************
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    STRING         2000
     C                   MOVEL     STRING        MQTMCR
 
 
      ** Open MQSeries Transmission queue that is to be read
     C                   EXSR      OpenQueue
 
      ** Determine length of the I/P buffer & Meridian header
      * Remove use of %len as this is not supported below V3R7
     C                   EVAL      BufLen = %len(Buffer)
 
     C                   ENDSR
     *********************************************************************
     C/EJECT
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA ArrErrorMsg
No record found in RPAPCIPD or Additional Processing Flag was not set to 'Y'.
