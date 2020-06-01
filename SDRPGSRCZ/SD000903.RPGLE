     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Process Incoming Messages')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000903 - Process Incoming Messages                         *
      *                                                               *
      *  Function:  This program process incoming messages received   *
      *             from Meridian via MQ Message Queue.               *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 11May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSD083  *CREATE    Date 27May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055868.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SrConnect - Connect to an MQ Series Message Queue             *
      * SrSndMessage - Send a Message to MQ Message Queue             *
      * SrGetMessage - Retrieve message from MQ Message Queue         *
      * SrRcvMessage - Process received messages                      *
      * SrDisconnect - Disconnect from the Queue Manager              *
      * SrUpdateWLC - Update Watch Lists File                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSDCWHTL0  UF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D MQManager       C                   Const('WLCQueueManagerName')
     D MQName          C                   Const('WLCQueueName')
     D Const1          C                   CONST('<FUNCTIONTYPE>')
     D Const2          C                   CONST('</FUNCTIONTYPE>')
     D Const3          C                   CONST('<IDENTIFIER>')
     D Const4          C                   CONST('</IDENTIFIER>')
     D Const5          C                   CONST('<BRANCH>')
     D Const6          C                   CONST('</BRANCH>')
     D Const7          C                   CONST('<ZONE>')
     D Const8          C                   CONST('</ZONE>')
     D Const9          C                   CONST('<RELEASEFLAG>')
     D Const10         C                   CONST('</RELEASEFLAG>')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      **  Declare MQI structures needed
      **  MQI Constants
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
      *
      ** Object Descriptor
     D MQOD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
      *
      ** Message Descriptor
     D MQMD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                        MD041126
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
      *
      ** Get message options
     D MQGMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQGMOR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD041126
      *
      ** Put message options
     D MQPMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
      *
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D ReasonA         S              9A
     D Pos1            S              4S 0
     D Pos2            S              4S 0
     D Len             S              3S 0
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
     D ParmValue       S             20A   DIM(20)
     D Ix              S              3P 0
     D Kx              S              4P 0
     D PRTCD           S              7A
     D SystemValue     S             20A
     D QName           S             48A
     D ProcMode        S            190A
     D***CID****         S              9P 0                                                MD041126
     D QMNAME          S             48A
     D***HCONN**         S              9P 0                                                MD041126
     D***OCODE**         S              9P 0                                                MD041126
     D***REASON*         S              9P 0                                                MD041126
     D***OPTS***         S              9P 0                                                MD041126
     D***HIN****         S              9P 0                                                MD041126
     D***p@msglen        S              9P 0                                                MD041126
     D p@msgbuf        S          12000A
     D***CCODE**         S              9P 0                                                MD041126
     D***MESLEN*         S             10P 0                                                MD041126
     D wfQueueManager  S             50A
     D wfQueueName     S             50A
     D wfExitLoop      S              1A
     D wfFunctionType  S              8A
     D wfIdentifier    S             40A
     D wfBranch        S              3A
     D wfZone          S              2A
     D wfReleaseFlg    S              2A
     D pOperation      S             10A
     D wMQManager      S             48A
     D wMQName         S             48A
     D RetCodeOut      S             10A
     D PMsg            S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
     D @RUN            S              1
                                                                                            MD041126
      ** MQ Parameters                                                                      MD041126
     D HCONN           S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D HIN             S             10I 0                                                  MD041126
     D P@MsgLen        S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D MESLEN          S             10I 0                                                  MD041126

      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   EXSR      SrConnect
      *
     C                   IF        pOperation = 'SHUTDOWN'
     C                   EXSR      SrSndMessage
     C                   ENDIF
      *
     C                   IF        pOperation = 'RECEIVE'
     C                   EXSR      SrRcvMessage
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrConnect - Connect to an MQ Series Message Queue             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: QMQM, ZAMSGTOMSQ                                       *
      *                                                               *
      *****************************************************************
      *
     C     SrConnect     BEGSR
      *
     C                   IF        pOperation = 'RECEIVE'
     C                   EVAL      OPTS = OOINPQ + OOFIQ
     C                   ENDIF
      *
     C                   IF        pOperation = 'SHUTDOWN'
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C                   ENDIF
      *
     C**********         EVAL      CID = MQCONN                                             MD041126
     C                   EVAL      QMNAME = wMQManager
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    QMNAME                                     MD041126
     C**********         PARM      *ZERO         HCONN                                      MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         HCONN                                      MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCONN( QMNAME : HCONN :                                 MD041126
     C                                     OCODE : REASON )                                 MD041126
      *
     C                   IF        REASON <> RCNONE AND
     C                             REASON <> RC2002
     C                   MOVE      REASON        ReasonA
     C                   EVAL      PMsg  = 'MQSeries MQCONN failed: '
     C                                     + ReasonA
      *
      ** Send error message to MOPERQ
      *
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsg
     C                   PARM                    PMsgId
     C                   PARM                    PMsgF
     C                   PARM                    PMsgQ
      *
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         EVAL      CID = MQOPEN                                             MD041126
     C                   EVAL      ODON = wMQName
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS                                       MD041126
     C**********         PARM                    HIN                                        MD041126
     C**********         PARM                    OCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN ( HCONN : MQOD : OPTS :                           MD041126
     C                                      HIN : OCODE : REASON )                          MD041126
      *
     C                   IF        REASON <> RCNONE
     C                   MOVE      REASON        ReasonA
     C                   EVAL      PMsg  =  'MQSeries MQOPEN failed: '
     C                                      + ReasonA
      *
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsg
     C                   PARM                    PMsgId
     C                   PARM                    PMsgF
     C                   PARM                    PMsgQ
      *
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSndMessage - Send a Message to MQ Message Queue             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: QMQM, ZAMSGTOMSQ                                       *
      *                                                               *
      *****************************************************************
      *
     C     SrSndMessage  BEGSR
      *
     C                   EVAL      wfFunctionType = 'SHUTDOWN'
      *
      ** Build 'shutdown message'
      *
     C                   EVAL      p@msgbuf = Const1 +
     C                                        %TRIM(wfFunctionType) +
     C                                        Const2
     C                   EVAL      p@msglen = 1000
     C**********         EVAL      CID = MQPUT                                              MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    HIN                                        MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM                    p@msglen                                   MD041126
     C**********         PARM                    p@msgbuf                                   MD041126
     C**********         PARM                    CCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( HCONN : HIN : MQMD : MQPMO :                      MD041126
     C                                    P@MsgLen : %ADDR(P@MsgBuf) :                      MD041126
     C                                    CCODE : REASON )                                  MD041126
      *
     C                   IF        REASON <> RCNONE
     C                   MOVE      REASON        ReasonA
     C                   EVAL      PMsg  =  'MQSeries MQPUT failed: '
     C                                      + ReasonA
      *
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsg
     C                   PARM                    PMsgId
     C                   PARM                    PMsgF
     C                   PARM                    PMsgQ
      *
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetMessage - Retrieve message from MQ Message Queue         *
      *                                                               *
      * Called by: SrRcvMessage                                       *
      *                                                               *
      * Calls: QMQM, ZAMSGTOMSQ                                       *
      *                                                               *
      *****************************************************************
      *
     C     SrGetMessage  BEGSR
      *
     C                   EVAL      GMOPT = GMWT
     C                   ADD       GMCONV        GMOPT
     C                   ADD       GMATM         GMOPT
     C                   EVAL      GMWI = 20000
     C                   ADD       GMSYP         GMOPT
     C                   EVAL      MDMID = MINONE
     C                   EVAL      MDCID = CINONE
     C                   CLEAR                   p@msgbuf
     C                   CLEAR                   ParmValue
     C**********         EVAL      CID = MQGET                                              MD041126
     C                   EVAL      p@msglen = 1000
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    HIN                                        MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM                    p@msglen                                   MD041126
     C**********         PARM                    p@msgbuf                                   MD041126
     C**********         PARM                    MESLEN                                     MD041126
     C**********         PARM                    CCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
     C                                    P@MsgLen : %ADDR(P@MsgBuf) :                      MD041126
     C                                    MESLEN : CCODE : REASON )                         MD041126
      *
     C                   IF        REASON <> RCNONE  AND
     C                             REASON <> RC2033
     C                   MOVE      REASON        ReasonA
     C                   EVAL      PMsg  = 'MQSeries MQGET failed: '
     C                                     + ReasonA
      *
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsg
     C                   PARM                    PMsgId
     C                   PARM                    PMsgF
     C                   PARM                    PMsgQ
      *
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        p@msgbuf <> *Blanks
      *
      ** Parse XML received
      *
     C                   EVAL      Pos1 = %SCAN(Const1:p@msgbuf)
     C                   EVAL      Pos2 = %SCAN(Const2:p@msgbuf)
     C                   IF        Pos1 <> 0 AND Pos2 <> 0
     C                   EVAL      Pos1 = Pos1 + 14
     C                   EVAL      Len = Pos2 - Pos1
     C                   EVAL      wfFunctionType = %SUBST(p@msgbuf:Pos1:Len)
     C                   ENDIF
      *
     C                   EVAL      Pos1 = %SCAN(Const3:p@msgbuf)
     C                   EVAL      Pos2 = %SCAN(Const4:p@msgbuf)
     C                   IF        Pos1 <> 0 AND Pos2 <> 0
     C                   EVAL      Pos1 = Pos1 + 12
     C                   EVAL      Len = Pos2 - Pos1
     C                   EVAL      wfIdentifier = %SUBST(p@msgbuf:Pos1:Len)
     C                   ENDIF
      *
     C                   EVAL      Pos1 = %SCAN(Const5:p@msgbuf)
     C                   EVAL      Pos2 = %SCAN(Const6:p@msgbuf)
     C                   IF        Pos1 <> 0 AND Pos2 <> 0
     C                   EVAL      Pos1 = Pos1 + 8
     C                   EVAL      Len = Pos2 - Pos1
     C                   EVAL      wfBranch = %SUBST(p@msgbuf:Pos1:Len)
     C                   ENDIF
      *
     C                   EVAL      Pos1 = %SCAN(Const7:p@msgbuf)
     C                   EVAL      Pos2 = %SCAN(Const8:p@msgbuf)
     C                   IF        Pos1 <> 0 AND Pos2 <> 0
     C                   EVAL      Pos1 = Pos1 + 6
     C                   EVAL      Len = Pos2 - Pos1
     C                   EVAL      wfZone = %SUBST(p@msgbuf:Pos1:Len)
     C                   ENDIF
      *
     C                   EVAL      Pos1 = %SCAN(Const9:p@msgbuf)
     C                   EVAL      Pos2 = %SCAN(Const10:p@msgbuf)
     C                   IF        Pos1 <> 0 AND Pos2 <> 0
     C                   EVAL      Pos1 = Pos1 + 13
     C                   EVAL      Len = Pos2 - Pos1
     C                   EVAL      wfReleaseFlg = %SUBST(p@msgbuf:Pos1:Len)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRcvMessage - Process received messages                      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrGetMessage, SrUpdateWLC, SrDisconnect                *
      *                                                               *
      *****************************************************************
      *
     C     SrRcvMessage  BEGSR
      *
     C                   EVAL      wfExitLoop = 'N'
      *
     C                   DOW       wfExitLoop = 'N'
     C                   EXSR      SrGetMessage
      *
     C                   IF        wfFunctionType = 'SHUTDOWN'
     C                   EVAL      wfExitLoop = 'Y'
     C                   ELSE
      *
      ** Perform update if message buffer has data
      *
     C                   IF        p@msgbuf <> *Blanks
     C                   EXSR      SrUpdateWLC
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   EXSR      SrDisconnect
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDisconnect - Disconnect from the Queue Manager              *
      *                                                               *
      * Called by: SrRcvMessage                                       *
      *                                                               *
      * Calls: QMQM, ZAMSGTOMSQ                                       *
      *                                                               *
      *****************************************************************
      *
     C     SrDisconnect  BEGSR
      *
     C**********         EVAL      CID = MQDISC                                             MD041126
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
      *
     C                   IF        REASON <> RCNONE
     C                   MOVE      REASON        ReasonA
     C                   EVAL      Pmsg = 'MQSeries MQDISC failed: '
     C                                    + ReasonA
      *
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM                    PMsg
     C                   PARM                    PMsgId
     C                   PARM                    PMsgF
     C                   PARM                    PMsgQ
      *
     C                   EVAL      DBASE = 6
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdateWLC - Update Watch Lists File                         *
      *                                                               *
      * Called by: SrRcvMessage                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdateWLC   BEGSR
      *
     C     SDCWHT        CHAIN     SDCWHTL0
      *
     C                   IF        %FOUND (SDCWHTL0)
     C                   IF        wfReleaseFlg = 'HT'
     C                   EVAL      W3HSTS = 'INVESTIGTN'
     C                   ENDIF
      *
     C                   IF        wfReleaseFlg = 'FP'
     C                   EVAL      W3HSTS = 'FALSPOSITV'
     C                   ENDIF
      *
     C                   IF        wfReleaseFlg = 'TP'
     C                   EVAL      W3HSTS = 'TRUEPOSITV'
     C                   ENDIF
      *
      ** Update/delete SDCWHTPD file
      *
     C                   IF        wfReleaseFlg <> 'NH'
     C                   EVAL      W3UNCF = *Blanks
     C                   EVAL      W3TREL = *Blanks
     C                   UPDATE    SDCWHTD0
     C                   ELSE
     C                   IF        wfReleaseFlg = 'NH'
     C                   DELETE    SDCWHTD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    pOperation
      *
     C     SDCWHT        KLIST
     C                   KFLD                    wfFunctionType
     C                   KFLD                    wfIdentifier
     C                   KFLD                    wfBranch
      *
     C                   CALLB     'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      MQManager     PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM      MQName        PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
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
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = PSysVal01
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      wMQManager = PCurSet01
     C                   EVAL      wMQName = PCurSet02
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQDISC        CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
      *
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
