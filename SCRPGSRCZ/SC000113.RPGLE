     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas SC PEA MQ message monitor')                      *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000113 - PEA MQ Message Monitor                            *
      *                                                               *
      *  Function:  This program monitors the current status of the   *
      *             PEA system and sends them to the Live System      *
      *             using Websphere MQ.                               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 15Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR993055           Date 22Jun12               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055613.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  AR993055 - Status of Period End Adjustments system does not  *
      *             change to 'Restore Started' during restore        *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
      /EJECT
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Constant to hold input parameter for AOSVALR0.
 
     D MQManager       C                   Const('PEAHandShakingQM')
     D MQIncQueue      C                   Const('PEAHandShakingIQ')
     D MQOutQueue      C                   Const('PEAHandShakingOQ')
     D PEALiveSys      C                   Const('PEALiveSystemPrefix')
     D PEASystem       C                   Const('PEASystemPrefix')
 
      ** MQSeries error message literals
 
     D OpenFailed      C                   CONST('MQSeries MQOPEN failed: ')
     D ReadFailed      C                   CONST('MQSeries MQGET  failed: ')
     D ClosFailed      C                   CONST('MQSeries MQCLOS failed: ')
     D ConnFailed      C                   CONST('MQSeries MQCONN failed: ')
     D DiscFailed      C                   CONST('MQSeries MQDISC failed: ')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for SAR Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data area for queue name
 
     D                 DS
     D  QIN                    1     20
     D  SysPrefix              6      7
 
      ** Data structure for incoming message formats
 
     D QData           S            100A
 
     D BUFFER          S            100A
 
      ** Data area fo ZMUSER
 
     D ZMUSER          DS            17
     D  USRID                  1     10
 
      ** Dummy Cmd Text
 
     D CMDTXT          DS            57
     D ALLTXT                  1     57
     D USRTXT                 46     55
     D QOTTXT                 56     57
 
      ** Declare MQI structures needed
      ** MQI Constants
 
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
 
      ** Get message options
 
     D MQGMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQGMOR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD041126
 
      ** Put message options
 
     D MQPMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
 
      ** The include below brings in the return code structure that
      ** is used in calls to OS/400 APIs.
 
     D/COPY QSYSINC/QRPGLESRC,QUSEC
 
      ** API Error code parameter
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based
      ** on the corresponding fields in the PSDS /COPY member, so that
      ** member must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      ** Connection to Queue Manager required flag
 
     D WConn           S              1A   INZ('Y')
 
     D WQMGR           S             48A
     D WIQueue         S             48A
     D WOQueue         S             48A
     D WPEA            S              2A
     D WLive           S              2A
     D CSC054          S              1A
     D SCPEAMON        S              1A   DTAARA(SCPEAMON)
 
      ** Error message for sending to the operator
 
     D MQError         S            132A
 
      ** Alpha version of the MQSeries reason code
 
     D ReasonA         S              9A
 
     D PSys            S              2A
     D PRetCd          S             10A
     D PStr            S           2000A
     D POptn           S              7A
     D PSard           S              6A
     D PRtCd           S              7A
     D PSysVal01       S             20A
     D PCurSet01       S            200A
     D PSysVal02       S             20A
     D PCurSet02       S            200A
     D PSysVal03       S             20A
     D PCurSet03       S            200A
     D PSysVal04       S             20A
     D PCurSet04       S            200A
     D PSysVal05       S             20A
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A
 
      ** QMQM Parameters
 
     D***CID****         S              9P 0                                                MD041126
     D***HANDLE*         S              9P 0                                                MD041126
     D***HCONN**         S              9P 0                                                MD041126
     D***HIN****         S              9P 0                                                MD041126
     D***OCODE**         S              9P 0                                                MD041126
     D***CCODE**         S              9P 0                                                MD041126
     D***REASON*         S              9P 0                                                MD041126
     D***OPTS***         S              9P 0                                                MD041126
     D***BUFLEN*         S              9P 0                                                MD041126
     D***MESLEN*         S              9P 0                                                MD041126
     D HANDLE          S             10I 0                                                  MD041126
     D HCONN           S             10I 0                                                  MD041126
     D HIN             S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D BUFLEN          S             10I 0                                                  MD041126
     D MESLEN          S             10I 0                                                  MD041126
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *  Main processing                                              *
      *                                                               *
      *****************************************************************
 
     C                   IF        CSC054 = 'Y'
 
      ** If a Queue Manager is specified on system value MQManager,
      ** connect to it and retain connection handle for other QMQM
      ** calls instead of using the default Queue Manager and
      ** connection.
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      MQManager     PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM      MQIncQueue    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM      MQOutQueue    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM      PEALiveSys    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM      PEASystem     PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10
 
     C                   IF        PrtCd   = *BLANKS
     C                             AND PCurSet01 <> *BLANKS
     C                   EVAL      WQMGR   = PCurSet01
     C                   EVAL      WIQueue = PCurSet02
     C                   EVAL      WOQueue = PCurSet03
     C                   EVAL      WLive   = PCurSet04
     C                   EVAL      WPEA    = PCurSet05
     C                   ELSE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EXSR      SRConnect
     C                   EVAL      HCONN   = HANDLE
 
     C                   EVAL      QIN     = WIQueue
     C                   EXSR      SROpen
 
      ** Loop until shutdown message received
 
     C                   DOW       QData <> 'SHUTDOWN'
 
     C                   EXSR      SRGetMsg
 
     C                   IF        QData <> 'SHUTDOWN'
 
      ** Process data read from Queue
 
     C                   SELECT
     C                   WHEN      QData = 'DBIC ready'
 
     C                   EVAL      SCPEAMON = 'O'
     C                   OUT       SCPEAMON
     C     *LOCK         IN        SCPEAMON
 
      ** Start Restore
 
     C                   EVAL      PSys  =  WLive
     C                   EXSR      SRRestore
 
     C                   WHEN      QData = 'Restore Failed'
     C                   EVAL      PSys  =  WLive
     C                   EVAL      PStr  = 'PEA Restore Failed'
     C                   EXSR      SRSndMsg
 
     C                   WHEN      QData = 'Restore Successful'
 
      ** Get Rundate from SDBANKPD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      PSys  =  WLive
     C                   EVAL      PStr  = 'PEA Ready '
     C                                     + %CHAR(BJRDNB)
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   WHEN      QData = 'PEA Closed'
     C                   EVAL      SCPEAMON = 'C'
     C                   OUT       SCPEAMON
     C     *LOCK         IN        SCPEAMON
 
     C                   WHEN      QData = 'PEA Transfer'
 
      ** Initiate PEA transaction transfer procedure
 
     C                   CALL      'SCC000116'
 
     C                   WHEN      QData = 'PEA Cleared'
 
     C                   EVAL      PSys  =  WLive
     C                   EVAL      PStr  = 'PEA Cleared'
     C                   EXSR      SRSndMsg
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRClose
 
      ** If an explicit connection to a Queue Manager was made, then
      ** disconnect from it
 
     C                   EXSR      SRDisconnect
 
     C                   ENDIF
 
      ** Release and clear data area
 
     C                   EVAL      SCPEAMON = *BLANKS
     C                   OUT       SCPEAMON
     C     *LOCK         IN        SCPEAMON
 
     C                   EVAL      *INLR  = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Restore data from LIVE DBIC.                                 *
      *                                                               *
      *****************************************************************
     C     SRRestore     BEGSR
 
      ** Submit DB Restore batch job
 
     C                   CALL      'SCC000112'
     C                   PARM      *BLANKS       PRtCd
 
     C**********         EVAL      PStr  =  WLive                                           AR993055
     C**********         IF        PRtCd = *BLANKS                                          AR993055
     C**********         EVAL      PStr  = 'Restore Started'                                AR993055
     C**********         ELSE                                                               AR993055
     C**********         EVAL      PStr  = 'Restore Not Started'                            AR993055
     C**********         ENDIF                                                              AR993055
     C**********         EXSR      SRSndMsg                                                 AR993055
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Send Outgoing message to LIVE MQ                             *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
     C                   CALL      'ZAMSGTOMQ'
     C                   PARM                    PRetCd
     C                   PARM                    PSys
     C                   PARM                    WQMGR
     C                   PARM                    WOQueue
     C                   PARM                    PStr
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Open connection to the queue manager                         *
      *                                                               *
      *****************************************************************
     C     SRConnect     BEGSR
 
      ** Attempt to CONNECT to the MQ Manager
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQCONN        CID                                        MD041126
     C**********         PARM                    WQMGR                                      MD041126
     C**********         PARM      *ZERO         HANDLE                                     MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         HANDLE                                     MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCONN( WQMGR : HANDLE :                                 MD041126
     C                                     OCODE : REASON )                                 MD041126
 
      ** Error processing
 
     C                   IF         REASON  <> RCNONE
     C                              AND REASON <> RC2002
 
     C                   MOVE      REASON        ReasonA
     C                   EVAL      MQError = ConnFailed + ReasonA
 
      ** Shut down the program
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Disconnect from the queue manager                            *
      *                                                               *
      *****************************************************************
     C     SRDisconnect  BEGSR
 
      ** Attempt to DISCONNECT from the MQ Manager
 
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
 
     C                   IF        REASON  <>  RCNONE
     C                             AND REASON <> RC2018
     C                             AND REASON <> RC2019
 
     C                   MOVE      REASON        ReasonA
     C                   EVAL      MQError = DiscFailed + ReasonA
 
      ** Shut down the program
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Open receiving queue for input                               *
      *                                                               *
      *****************************************************************
     C     SROpen        BEGSR
 
      ** Use input queue
 
     C                   MOVEL     QIN           ODON             48
 
      ** Open options: INPUT and FAIL_IF_QUIESCING
 
     C     OOINPQ        ADD       OOFIQ         OPTS
 
      ** Open queue
     C**********         Z-ADD     MQOPEN        CID                                        MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS                                       MD041126
     C**********         PARM                    HIN                                        MD041126
     C**********         PARM                    OCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
     C                                     HIN : OCODE : REASON )                           MD041126
 
      ** Error processing
 
     C                   IF        REASON <> RCNONE
 
      ** Send message to MOPERQ and QSYSOPR before crashing out
 
     C                   MOVE      REASON        ReasonA
     C                   EVAL      MQError = OpenFailed + ReasonA
 
      ** Shut down the program
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Close input queue                                            *
      *                                                               *
      *****************************************************************
     C     SRClose       BEGSR
 
      ** Close options: NONE
 
     C                   Z-ADD     CONONE        OPTS
 
      ** Close queue
 
     C**********         Z-ADD     MQCLOS        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    HIN                                        MD041126
     C**********         PARM                    OPTS                                       MD041126
     C**********         PARM                    CCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( HCONN : HIN : OPTS :                            MD041126
     C                                      CCODE : REASON )                                MD041126
 
      ** Error processing
 
     C                   IF        REASON  <>  RCNONE
     C                             AND REASON <> RC2018
     C                             AND REASON <> RC2019
 
      ** Send message to MOPERQ and QSYSOPR before crashing out
 
     C                   MOVE      REASON        ReasonA
     C                   EVAL      MQError = ClosFailed + ReasonA
 
      ** Shut down the program
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Wait for incoming messages                                   *
      *                                                               *
      *****************************************************************
     C     SRGetMsg      BEGSR
 
      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
      ** Note: the last of these options means that a message longer
      ** than the buffer length defined in this module (currently 1500
      ** bytes) will be read and removed from the queue.  Any data in
      ** the message after the 1500th byte will be lost.
 
     C                   EVAL      GMOPT = GMWT + GMCONV + GMATM
 
      ** Set wait interval to infinite
 
     C                   EVAL      GMWI  = WIULIM
 
      ** Perform get operation inside commitment control. Commitment
      ** boundary is at the valid/invalid deals file. Any return
      ** MQ messages are also inside this commitment cycle.
 
     C                   EVAL      GMOPT += GMSYP
 
      ** MsgId and CorrelId are selectors cleared to ensure messages
      ** are processed in arrival/priority sequence
 
     C                   EVAL      MDMID  = MINONE
     C                   EVAL      MDCID  = WPEA
 
      ** Clear message buffer
 
     C                   EVAL      BUFFER = *BLANKS
 
      ** Get message
 
     C**********         EVAL      CID    = MQGET                                           MD041126
 
      ** Max Buffer length = 100
 
     C                   EVAL      BUFLEN = 100
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    HIN                                        MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM                    BUFLEN                                     MD041126
     C**********         PARM                    BUFFER                                     MD041126
     C**********         PARM                    MESLEN                                     MD041126
     C**********         PARM                    CCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
     C                                    BUFLEN : %ADDR(BUFFER) :                          MD041126
     C                                    MESLEN : CCODE : REASON )                         MD041126
 
      ** If connection handle not valid error, reconnect and try again
 
     C                   IF        REASON    = RC2018
     C                             OR REASON = RC2019
     C                   EXSR      SRClose
     C                   EXSR      SRDisconnect
     C                   EXSR      SRConnect
     C                   Z-ADD     HANDLE        HCONN
     C                   EXSR      SROpen
     C**********         Z-ADD     MQGET         CID                                        MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    HIN                                        MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM                    BUFLEN                                     MD041126
     C**********         PARM                    BUFFER                                     MD041126
     C**********         PARM                    MESLEN                                     MD041126
     C**********         PARM                    CCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
     C                                    BUFLEN : %ADDR(BUFFER) :                          MD041126
     C                                    MESLEN : CCODE : REASON )                         MD041126
     C                   ENDIF
 
      ** Error processing
 
     C                   IF        REASON <> RCNONE
 
      ** Send message to MOPERQ and QSYSOPR before crashing out
 
     C                   MOVE      REASON        ReasonA
     C                   EVAL      MQError = ReadFailed + ReasonA
 
      ** Shut down the program
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
     C                   EVAL      QData = Buffer
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Initialisation                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC054'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   EVAL      CSC054 = 'N'
 
     C                   IF        PRtCd  = *BLANKS
     C                   EVAL      CSC054 = 'Y'
     C                   ENDIF
 
     C     *LOCK         IN        SCPEAMON
     C                   EVAL      SCPEAMON = 'S'
     C                   OUT       SCPEAMON
     C     *LOCK         IN        SCPEAMON
 
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
