     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
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
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR993055           Date 22Jun12               *
      *  Prev Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
     D CID             S              9P 0
     D HANDLE          S              9P 0
     D HCONN           S              9P 0
     D HIN             S              9P 0
     D OCODE           S              9P 0
     D CCODE           S              9P 0
     D REASON          S              9P 0
     D OPTS            S              9P 0
     D BUFLEN          S              9P 0
     D MESLEN          S              9P 0
 
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
 
     C                   CALL      'QMQM'
     C                   PARM      MQCONN        CID
     C                   PARM                    WQMGR
     C                   PARM      *ZERO         HANDLE
     C                   PARM      *ZERO         OCODE
     C                   PARM      *ZERO         REASON
 
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
 
     C                   CALL      'QMQM'
     C                   PARM      MQDISC        CID
     C                   PARM                    HCONN
     C                   PARM      *ZERO         OCODE
     C                   PARM      *ZERO         REASON
 
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
     C                   Z-ADD     MQOPEN        CID
 
     C                   CALL      'QMQM'
     C                   PARM                    CID
     C                   PARM                    HCONN
     C                   PARM                    MQOD
     C                   PARM                    OPTS
     C                   PARM                    HIN
     C                   PARM                    OCODE
     C                   PARM                    REASON
 
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
 
     C                   Z-ADD     MQCLOS        CID
     C                   CALL      'QMQM'
     C                   PARM                    CID
     C                   PARM                    HCONN
     C                   PARM                    HIN
     C                   PARM                    OPTS
     C                   PARM                    CCODE
     C                   PARM                    REASON
 
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
 
     C                   EVAL      CID    = MQGET
 
      ** Max Buffer length = 100
 
     C                   EVAL      BUFLEN = 100
 
     C                   CALL      'QMQM'
     C                   PARM                    CID
     C                   PARM                    HCONN
     C                   PARM                    HIN
     C                   PARM                    MQMD
     C                   PARM                    MQGMO
     C                   PARM                    BUFLEN
     C                   PARM                    BUFFER
     C                   PARM                    MESLEN
     C                   PARM                    CCODE
     C                   PARM                    REASON
 
      ** If connection handle not valid error, reconnect and try again
 
     C                   IF        REASON    = RC2018
     C                             OR REASON = RC2019
     C                   EXSR      SRClose
     C                   EXSR      SRDisconnect
     C                   EXSR      SRConnect
     C                   Z-ADD     HANDLE        HCONN
     C                   EXSR      SROpen
     C                   Z-ADD     MQGET         CID
 
     C                   CALL      'QMQM'
     C                   PARM                    CID
     C                   PARM                    HCONN
     C                   PARM                    HIN
     C                   PARM                    MQMD
     C                   PARM                    MQGMO
     C                   PARM                    BUFLEN
     C                   PARM                    BUFFER
     C                   PARM                    MESLEN
     C                   PARM                    CCODE
     C                   PARM                    REASON
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
