     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC PEA MQ status updater')                       *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000114 - PEA Process Status Updater                        *
      *                                                               *
      *  Function:  This program receives the current status of the   *
      *             PEA system and updates the PEA status file in     *
      *             the Live system using Websphere MQ.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD020167           Date 23Apr13               *
      *                 AR989228           Date 13Jun12               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  AR989228 - The MQ clear processing during closing of PEA     *
      *             should be called from the Live system             *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Midas SC PEA System Status File

     FSCPEASPD  UF A E             DISK    USROPN

      ** Midas GP Downloaded data from zones - unq.

     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
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

      ** First DS for access programs, short data structure

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data area for queue name

     D                 DS
     D  QIN                    1     20
     D  SysPrefix              6      7

      ** Incoming message header format

     D APHEAD        E DS                  EXTNAME(APHEADPD)

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
      *  API Error code parameter

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D WQMGR           S             48A
     D WIQueue         S             48A
     D WOQueue         S             48A
     D WPEA            S              2A
     D WLive           S              2A
     D CSC054          S              1A
     D SCPEASTS        S              1A   DTAARA(SCPEASTS)
                                                                                            AR989228
      ** Parameter variables for access object GOGETZONE                                    AR989228
     D pErMs           S             50A   INZ(*BLANKS)                                     AR989228
     D pFullCk         S              1A   INZ('Y')                                         AR989228
     D pZone           S             10A   INZ(*BLANKS)                                     AR989228
     D pSHTC           S              4A   INZ(*BLANKS)                                     AR989228
     D pRDNB           S              5  0 INZ(0)                                           AR989228
     D pDNWD           S              5  0 INZ(0)                                           AR989228
     D pBCCY           S              3A   INZ(*BLANKS)                                     AR989228
     D pNJOB           S              1  0 INZ(0)                                           AR989228

      ** Error message for sending to the operator

     D MQError         S            132A

      ** Alpha version of the MQSeries reason code

     D ReasonA         S              9A

      ** Other Depot Details for Securities Customer.
      ** This totals to 150 additional other depot details from the incoming message.

     D OthDData        S           4755A

     D PSys            S              2A
     D PrtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
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

      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************

     C     GPDWNLL0Key   KLIST
     C                   KFLD                    DLMSID
     C                   KFLD                    DLKEYD

     C                   IF        CSC054 = 'Y'

      ** If a Queue Manager is specified on system value MQManager, connect
      ** to it and retain connection handle for other QMQM calls instead
      ** of using the default Queue Manager and connection

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
     C                   EXSR      SRConnect
     C                   EVAL      HCONN  = HANDLE
     C                   ENDIF

     C                   EVAL      QIN    = WIQueue
     C                   EXSR      SROpen

      ** Loop until shutdown message received

     C                   DOW       QData <> 'SHUTDOWN'

     C                   EXSR      SRGetMsg

     C                   IF        QData <> 'SHUTDOWN'

      ** Update PEA status file

     C                   EXSR      SRPEAUpd

     C                   ENDIF

     C                   ENDDO

     C                   EXSR      SRClose

      ** If an explicit connection to a Queue Manager was made, then
      ** disconnect from it

     C                   EXSR      SRDisconnect

     C                   ENDIF

     C                   EVAL      SCPEASTS = *BLANKS
     C                   OUT       SCPEASTS

     C                   EVAL      *INLR = *ON
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Initialisation                                              *
      *                                                              *
      ****************************************************************
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

     C     *LOCK         IN        SCPEASTS
     C                   EVAL      SCPEASTS = 'S'
     C                   OUT       SCPEASTS
     C     *LOCK         IN        SCPEASTS

      ** Retrieve current zone details                                                      AR989228
     C                   CALL      'GOGETZONE'                                              AR989228
     C                   PARM      *BLANKS       pRtCd                                      AR989228
     C                   PARM      *BLANKS       pErMs                                      AR989228
     C                   PARM      'Y'           pFullCk                                    AR989228
     C                   PARM                    pZone                                      AR989228
     C                   PARM                    pSHTC                                      AR989228
     C                   PARM                    pRDNB                                      AR989228
     C                   PARM                    pDNWD                                      AR989228
     C                   PARM                    pBCCY                                      AR989228
     C                   PARM                    pNJOB                                      AR989228
                                                                                            AR989228
      ** If no zone details were retrieved then issue database error                        AR989228
     C                   IF        pZone = *BLANKS                                          AR989228
     C     *LOCK         IN        LDA                                                      AR989228
     C                   EVAL      DBFILE     =  'SDBRCHPD'                                 AR989228
     C                   EVAL      DBKEY      =  pErMs                                      AR989228
     C                   EVAL      DBASE      =  001                                        AR989228
     C                   EVAL      DBPGM      = 'SC000114'                                  AR989228
     C                   OUT       LDA                                                      AR989228
     C                   EXSR      *PSSR                                                    AR989228
     C                   ENDIF                                                              AR989228
                                                                                            AR989228
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

     C                   IF        REASON <> RCNONE
     C                             AND REASON <> RC2002

     C                   MOVE      REASON        ReasonA
     C                   EVAL      MQError = ConnFailed + ReasonA

      ** End with error

     C                   EXSR      *pssr

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Update PEA System Status File                                *
      *                                                               *
      *****************************************************************
     C     SRPEAUpd      BEGSR

      ** Update PEA Status file

     C                   OPEN      SCPEASPD
     C     1             SETLL     SCPEASPD
     C                   READ      SCPEASPD
     C                   IF        %EOF()
     C                   EVAL      PESTAT = 'O'
     C                   WRITE     SCPEASD0
     C     1             SETLL     SCPEASPD
     C                   READ      SCPEASPD
     C                   ENDIF

      ** Process data read from Queue

     C                   SELECT
     C                   WHEN      QData = 'PEA Closed'

     C                   EVAL      PESTAT = 'C'
     C                   EVAL      QData = 'CLOSED'

      ** Submit Clear PEA system files

     C                   CALL      'SCC000122'
                                                                                            AR989228
      ** Clear MQ Queue                                                                     AR989228
                                                                                            AR989228
     C                   CALL      'SC000119'                                               AR989228
     C                   PARM      *BLANKS       PRtCd                                      AR989228
     C                   PARM                    pZone                                      AR989228

     C                   WHEN      QData = 'PEA Cleared'

     C                   EVAL      PESTAT = 'C'
     C                   EVAL      QData = 'CLOSED - PEA Cleared'

     C                   WHEN      %SUBST(QData:1:9) = 'PEA Ready'

     C                   EVAL      PESTAT = 'O'
     C                   IF        %SUBST(QData:11:5) <> *BLANKS
     C                   EVAL      PERDNB = %DEC(%SUBST(QData:11:5):5:0)
     C                   ENDIF
     C                   EVAL      QData  = 'OPEN - PEA Ready'

     C                   OTHER

     C                   EVAL      PESTAT = 'O'
     C                   EVAL      QData  = 'OPEN - '
     C                                     + %TRIMR(QData)
     C                   ENDSL

     C                   UPDATE    SCPEASD0
     C                   CLOSE     SCPEASPD

      ** Update GP Downloaded data file

     C                   EVAL      DLMSID = WLive
     C                   EVAL      DLKEYD = 'PEASystemStatus'

     C                   OPEN      GPDWNLL0
     C     GPDWNLL0Key   CHAIN     GPDWNLL0
     C                   IF        %FOUND
     C                   EVAL      DLVAL  = QData
     C                   UPDATE    @DWNLL0
     C                   ELSE
     C                   EVAL      DLMSID = WLive
     C                   EVAL      DLKEYD = 'PEASystemStatus'
     C                   EVAL      DLVAL  = QData
     C                   EVAL      DLMPGM = '*NONE'
     C                   EVAL      DLMPRM = *BLANKS
     C                   EVAL      DLEPGM = '*NONE'
     C                   EVAL      DLEPRM = *BLANKS
     C                   WRITE     @DWNLL0
     C                   ENDIF
     C                   CLOSE     GPDWNLL0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Disconnect from the queue manager                            *
      *                                                               *
      *****************************************************************
     C     SRDisconnect  BEGSR

      **  Attempt to DISCONNECT from the MQ Manager

     C                   CALL      'QMQM'
     C                   PARM      MQDISC        CID
     C                   PARM                    HCONN
     C                   PARM      *ZERO         OCODE
     C                   PARM      *ZERO         REASON

      ** Error processing

     C                   IF        REASON <> RCNONE
     C                             AND REASON <> RC2018
     C                             AND REASON <> RC2019

     C                   MOVE      REASON        ReasonA
     C                   EVAL      MQError = DiscFailed + ReasonA

      ** End with error

     C                   EXSR      *pssr

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

      ** End with error

     C                   EXSR      *pssr

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

     C                   IF        REASON <> RCNONE
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
     C                   EVAL      MDCID  = WLive

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

     C                   IF        REASON  = RC2018
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
     C
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   RETURN
     C                   ENDSR
