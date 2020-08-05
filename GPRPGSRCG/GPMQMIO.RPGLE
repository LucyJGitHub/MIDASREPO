     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas GP MQ Series Input/Output')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPMQMIO - GP MQ Series Input/Output                          *
      *                                                               *
      *  Function:  This program gets messages from                   *
      *             and puts messages to an MQSeries queue.           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 27Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1020531          Date 09Jan13               *
      *                 BUG27831B          Date 09Aug10               *
      *                 BUG27831A *CREATE  Date 03Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055451.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1020531 - Component GLC004604 is failed during COB due to  *
      *              ADDLIBLE QMQM command. Did not follow original   *
      *              fix as it may pose problem if QMQM is not in the *
      *              library list. Instead of omitting, redirect the  *
      *              program step to *PSSR subroutine when ADDLIBLE   *
      *              encountered an error. (Child: AR1020532)         *
      *  BUG27831B - Define Messge Queue Manager                      *
      *  BUG27831A - Forward Account Transfer Processing              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SR_PUT   - Put Outgoing Messages                             *
      *  SR_GET   - Get Incoming Messages                             *
      *  SR_OPEN  - Open MQ Series Queue                              *
      *  SR_CLOSE - Close MQ Series Queue                             *
      *  *INZSR   - Initialization                                    *
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY GPCPYSRCG,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY GPCPYSRCG,PSDS
 
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
 
     D I#RTCD          S              7A
     D I#ERMS          S             30A
     D P@REQUEST       S             10A
     D P@QUEUENM       S             48A
     D P@MSGBUF        S          32000A
     D P@KEY           S              4A
     D P@MQMgr         S             48A                                                   BUG27831B
     D***P@CID**         S              9P 0                                                MD041126
     D***P@CONN*         S              9P 0                                                MD041126
     D***P@IN***         S              9P 0                                                MD041126
     D***P@OPTS*         S              9P 0                                                MD041126
     D***P@CODE*         S              9P 0                                                MD041126
     D***P@RESN*         S              9P 0                                                MD041126
     D***P@MSGLEN        S              9P 0                                                MD041126
     D***P@SLEN*         S              9P 0                                                MD041126
     D P@CONN          S             10I 0                                                  MD041126
     D P@IN            S             10I 0                                                  MD041126
     D P@OPTS          S             10I 0                                                  MD041126
     D P@CODE          S             10I 0                                                  MD041126
     D P@RESN          S             10I 0                                                  MD041126
     D P@MSGLEN        S             10I 0                                                  MD041126
     D P@SLEN          S             10I 0                                                  MD041126
 
      ** Parameters for QCMDEXEC
 
     D PCommand        S            256A
     D PLength         S             15P 5
                                                                                           AR1020531
     D PSExcpErr       S              7A                                                   AR1020531
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Main Procedure                                               *
      *****************************************************************
 
     C                   SELECT
 
      ** OPEN a queue
 
     C                   WHEN      P@REQUEST = '*OPEN_GET' OR
     C                             P@REQUEST = '*OPEN_PUT'
     C                   EXSR      SR_OPEN
 
      ** GET a message
 
     C                   WHEN      P@REQUEST = '*GET'
     C                   EXSR      SR_GET
 
      ** PUT a message
 
     C                   WHEN      P@REQUEST = '*PUT'
     C                   EXSR      SR_PUT
 
      ** CLOSE a queue
 
     C                   WHEN      P@REQUEST = '*CLOSE'
     C                   EXSR      SR_CLOSE
 
     C                   ENDSL
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_PUT - Put Outgoing Messages                               *
      *                                                               *
      *****************************************************************
 
     C     SR_PUT        BEGSR
 
      ** Get message length
 
     C     ' '           CHECKR    P@MSGBUF      P@MSGLEN
 
      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.
      ** FMSTR is a named constant defined in CMQR;
      ** it contains 'MQSTR   '.
 
     C                   EVAL      MDFMT = FMSTR
     C                   MOVEL     P@KEY         MDCID
 
      ** Send message
 
     C**********         EVAL      P@CID = MQPUT                                            MD041126
     C                   EVAL      PMOPT = PMNMID
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    P@CID                                      MD041126
     C**********         PARM                    P@CONN                                     MD041126
     C**********         PARM                    P@IN                                       MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM                    P@MSGLEN                                   MD041126
     C**********         PARM                    P@MSGBUF                                   MD041126
     C**********         PARM                    P@CODE                                     MD041126
     C**********         PARM                    P@RESN                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( P@CONN : P@IN : MQMD :                            MD041126
     C                                    MQPMO : P@MSGLEN :                                MD041126
     C                                    %ADDR(P@MSGBUF) : P@CODE :                        MD041126
     C                                    P@RESN )                                          MD041126
 
      ** If send message failed, indicate abnormal end
 
     C                   IF        P@RESN <> RCNONE
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES PUT MSG'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_GET - Get Incoming Messages                               *
      *                                                               *
      *****************************************************************
 
     C     SR_GET        BEGSR
 
      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
      ** Note: the last of these options means that a message longer
      ** than the buffer length defined in this module
      ** (currently 1500 bytes) will be read and removed from the
      ** queue.  Any data in the message after the 1500th byte will be
      ** lost.
 
     C                   EVAL      GMOPT = GMWT +
     C                                     GMCONV +
     C                                     GMATM
 
      ** Set wait interval to 2 seconds
 
     C                   EVAL      GMWI = 2000
 
      ** Perform get operation inside commitment control. Commitment
      ** boundary is after the message management file updates.
 
     C                   EVAL      GMOPT = GMOPT +
     C                                     GMSYP
 
      ** MsgId and CorrelId are selectors cleared to ensure messages
      ** are processed in arrival/priority sequence
 
     C                   MOVEL     MINONE        MDMID
     C                   MOVEL     CINONE        MDCID
 
      ** Clear message buffer
 
     C                   CLEAR                   P@MSGBUF
 
      ** Get message
 
     C**********         EVAL      P@CID = MQGET                                            MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    P@CID                                      MD041126
     C**********         PARM                    P@CONN                                     MD041126
     C**********         PARM                    P@IN                                       MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM      32000         P@MSGLEN                                   MD041126
     C**********         PARM                    P@MSGBUF                                   MD041126
     C**********         PARM                    P@SLEN                                     MD041126
     C**********         PARM                    P@CODE                                     MD041126
     C**********         PARM                    P@RESN                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     32000         P@MSGLEN                                   MD041126
     C                   CALLP     MQGET( P@CONN : P@IN :                                   MD041126
     C                                    MQMD : MQGMO : P@MSGLEN :                         MD041126
     C                                    %ADDR(P@MSGBUF) : P@SLEN :                        MD041126
     C                                    P@CODE : P@RESN )                                 MD041126
 
      ** If receive message failed, indicate abnormal end
 
     C                   IF        P@RESN <> RCNONE AND
     C                             P@RESN <> RC2033
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES GET MSG'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_OPEN - Open MQ Series Queue                               *
      *                                                               *
      *****************************************************************
 
     C     SR_OPEN       BEGSR
 
      ** Use default connection handle, and implicit connection
 
     C                   EVAL      P@CONN = HCDEFH
                                                                                           BUG27831B
      ** Connect to the queue manager                                                      BUG27831B
                                                                                           BUG27831B
     C                   IF        P@MQMgr <> *BLANKS                                      BUG27831B
     C                   EVAL      ODMN = P@MQMgr                                          BUG27831B
     C**********         EVAL      P@CID = MQCONN                                 BUG27831B MD041126
     C**********         CALL      'QMQM'                                         BUG27831B MD041126
     C**********         PARM                    P@CID                            BUG27831B MD041126
     C**********         PARM                    P@MQMgr                          BUG27831B MD041126
     C**********         PARM                    P@CONN                           BUG27831B MD041126
     C**********         PARM                    P@CODE                           BUG27831B MD041126
     C**********         PARM                    P@RESN                           BUG27831B MD041126
                                                                                            MD041126
     C                   CALLP     MQCONN( P@MQMgr : P@CONN :                               MD041126
     C                                     P@CODE  : P@RESN )                               MD041126
     C                                                                                     BUG27831B
     C                   IF        P@CODE =  CCFAIL                                        BUG27831B
     C                   EVAL      I#ERMS = 'Unable to connect to MQM '                    BUG27831B
     C                   EXSR      *PSSR                                                   BUG27831B
     C                   ENDIF                                                             BUG27831B
     C                                                                                     BUG27831B
     C                   ENDIF                                                             BUG27831B
 
      ** Queue name
 
     C                   EVAL      ODON = P@QUEUENM
 
      ** Open queue for INPUT
 
     C                   IF        P@REQUEST = '*OPEN_GET'
 
      ** Open options: INPUT and FAIL_IF_QUIESCING
 
     C                   EVAL      P@OPTS = OOINPQ +
     C                                      OOFIQ
 
      ** Open queue for OUTPUT
 
     C                   ELSE
 
      ** Open options: OUTPUT and FAIL_IF_QUIESCING
 
     C                   EVAL      P@OPTS = OOOUT +
     C                                      OOFIQ
     C                   ENDIF
 
      ** Open queue
 
     C**********         EVAL      P@CID = MQOPEN                                           MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    P@CID                                      MD041126
     C**********         PARM                    P@CONN                                     MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    P@OPTS                                     MD041126
     C**********         PARM                    P@IN                                       MD041126
     C**********         PARM                    P@CODE                                     MD041126
     C**********         PARM                    P@RESN                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( P@CONN : MQOD :                                  MD041126
     C                                     P@OPTS : P@IN :                                  MD041126
     C                                     P@CODE : P@RESN )                                MD041126
 
      ** If open queue failed, indicate abnormal end
 
     C                   IF        P@RESN <>  RCNONE
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES OPEN Q'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_CLOSE - Close MQ Series Queue                             *
      *                                                               *
      *****************************************************************
 
     C     SR_CLOSE      BEGSR
 
      ** Close options: NONE
 
     C                   EVAL      P@OPTS = CONONE
 
      ** Close queue
 
     C**********         EVAL      P@CID = MQCLOS                                           MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    P@CID                                      MD041126
     C**********         PARM                    P@CONN                                     MD041126
     C**********         PARM                    P@IN                                       MD041126
     C**********         PARM                    P@OPTS                                     MD041126
     C**********         PARM                    P@CODE                                     MD041126
     C**********         PARM                    P@RESN                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( P@CONN : P@IN :                                 MD041126
     C                                      P@OPTS : P@CODE : P@RESN )                      MD041126
 
      ** If close queue failed, indicate abnormal end
 
     C                   IF        P@RESN <> RCNONE
     C                   EVAL      I#ERMS = 'ERROR IN MQ SERIES CLOSE Q'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialization                                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** API Error code parameter
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
     C                   PARM                    P@REQUEST
     C                   PARM                    P@QUEUENM
     C                   PARM                    P@MSGBUF
     C                   PARM                    P@KEY
     C                   PARM                    P@MQMgr                                   BUG27831B
 
     C                   EVAL      PCommand = 'ADDLIBLE QMQM *LAST'
     C                   EVAL      PLength = %LEN( %TRIM( PCommand ) )
 
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    PCommand
     C                   PARM                    PLength
 
     C                   EVAL      PSExcpErr = %TRIM(PSExcpType) +                         AR1020531
     C                                         %TRIM(PSExcpNo)                             AR1020531
      *                                                                                    AR1020531
     C                   IF        %ERROR                                                  AR1020531
     C                   IF        PSExcpErr <> 'CPF2103'                                  AR1020531
     C                   EXSR      *PSSR                                                   AR1020531
     C                   ENDIF                                                             AR1020531
     C                   ENDIF                                                             AR1020531
                                                                                           AR1020531
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
