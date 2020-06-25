     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Put message on MQM queue')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPUTMSG - Put Message on MQM Queue                          *
      *                                                               *
      *  Function:  This program puts messages on an MQSeries queue   *
      *             to instruct the CCRM Limits system that data      *
      *             is ready for retrieval.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 24Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1004819          Date 30Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 19Nov99               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055945.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1004819 - Only recognises default queue manager            *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
      /EJECT
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
 
      **  Declare MQI structures needed
      * MQI Constants
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
      * API Error code parameter
      *
      * System Values                                                                      AR1004819
     D PRTCD           S              7A                                                   AR1004819
     D PSysVal01       S             20A   INZ('MQQueueMgr          ')                     AR1004819
     D PCurSet01       S            200A                                                   AR1004819
     D PSysVal02       S             20A                                                   AR1004819
     D PCurSet02       S            200A                                                   AR1004819
     D PSysVal03       S             20A                                                   AR1004819
     D PCurSet03       S            200A                                                   AR1004819
     D PSysVal04       S             20A                                                   AR1004819
     D PCurSet04       S            200A                                                   AR1004819
     D PSysVal05       S             20A                                                   AR1004819
     D PCurSet05       S            200A                                                   AR1004819
     D PSysVal06       S             20A                                                   AR1004819
     D PCurSet06       S            200A                                                   AR1004819
     D PSysVal07       S             20A                                                   AR1004819
     D PCurSet07       S            200A                                                   AR1004819
     D PSysVal08       S             20A                                                   AR1004819
     D PCurSet08       S            200A                                                   AR1004819
     D PSysVal09       S             20A                                                   AR1004819
     D PCurSet09       S            200A                                                   AR1004819
     D PSysVal10       S             20A                                                   AR1004819
     D PCurSet10       S            200A                                                    MD041126
 
      ** MQ Parameters                                                                      MD041126
     D HCONN           S             10I 0                                                  MD041126
     D HIN             S             10I 0                                                  MD041126
     D P@MsgLen        S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D PQMGR           S             48A                                                    MD041126
     D LastQMGR        S             48A                                                    MD041126
                                                                                            MD041126
      /EJECT
      *
     C     *LIKE         DEFINE    Ret_Code      I#RTCD
     C     *LIKE         DEFINE    Err_Mess      I#ERMS
 
     C     *ENTRY        PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
     C                   PARM                    W@Request        10
     C                   PARM                    P@QueueNm        48
     C                   PARM                    P@MsgBuf      32000
 
     C                   MOVEL     *BLANKS       Ret_Code
     C                   MOVEL     *BLANKS       Err_Mess
 
     C                   SELECT
      *
      ** OPEN a queue
      *
     C     W@Request     WHENEQ    '*OPEN_PUT'
     C                   EXSR      SR_OPEN
      *
      ** PUT a message
      *
     C     W@Request     WHENEQ    '*PUT'
     C                   EXSR      SR_PUT
      *
      ** CLOSE a queue
      *
     C     W@Request     WHENEQ    '*CLOSE'
     C                   EXSR      SR_CLOSE
      *
     C                   ENDSL
      *
     C                   RETURN
      /EJECT
      *****************************************************************                    AR1004819
      *                                                               *                    AR1004819
      * *INZSR - Program Initialisation routine                       *                    AR1004819
      *                                                               *                    AR1004819
      * CALLed by: Implicitly on program activation                   *                    AR1004819
      *                                                               *                    AR1004819
      * CALLs: None                                                   *                    AR1004819
      *                                                               *                    AR1004819
      *****************************************************************                    AR1004819
     C     *INZSR        BEGSR                                                             AR1004819
                                                                                           AR1004819
      ** Get system values                                                                 AR1004819
     C                   CALLB     'AOSVALR0'                                              AR1004819
     C                   PARM      *BLANKS       PRtCd                                     AR1004819
     C                   PARM                    PSysVal01                                 AR1004819
     C                   PARM                    PCurSet01                                 AR1004819
     C                   PARM                    PSysVal02                                 AR1004819
     C                   PARM                    PCurSet02                                 AR1004819
     C                   PARM                    PSysVal03                                 AR1004819
     C                   PARM                    PCurSet03                                 AR1004819
     C                   PARM                    PSysVal04                                 AR1004819
     C                   PARM                    PCurSet04                                 AR1004819
     C                   PARM                    PSysVal05                                 AR1004819
     C                   PARM                    PCurSet05                                 AR1004819
     C                   PARM                    PSysVal06                                 AR1004819
     C                   PARM                    PCurSet06                                 AR1004819
     C                   PARM                    PSysVal07                                 AR1004819
     C                   PARM                    PCurSet07                                 AR1004819
     C                   PARM                    PSysVal08                                 AR1004819
     C                   PARM                    PCurSet08                                 AR1004819
     C                   PARM                    PSysVal09                                 AR1004819
     C                   PARM                    PCurSet09                                  MD041126
     C                   PARM                    PSysVal10                                  MD041126
     C                   PARM                    PCurSet10                                  MD041126
                                                                                           AR1004819
     C                   IF        PRtCd = *BLANKS                                         AR1004819
     C**********         EVAL      ODMN = PSysVal01                               AR1004819 MD041126
     C                   EVAL      PQMGR = PCurSet01                                        MD041126
     C                   ELSE                                                              AR1004819
                                                                                           AR1004819
     C                   IF        PRtCd <> '*NRF'                                         AR1004819
     C     *LOCK         IN        LDA                                                     AR1004819
     C                   EVAL      DBFile = 'SDSVALPD'                                     AR1004819
     C                   EVAL      DBase = 001                                             AR1004819
     C                   EVAL      DBKey = PSysVal01                                       AR1004819
     C                   OUT       LDA                                                     AR1004819
     C                   EXSR      *PSSR                                                   AR1004819
     C                   ENDIF                                                             AR1004819
     C                   ENDIF                                                             AR1004819
                                                                                           AR1004819
     C                   ENDSR                                                             AR1004819
      *********************************************************************                AR1004819
      /EJECT                                                                               AR1004819
      *****************************************************************
      *                                                               *
      * SR_PUT - Subroutine to put outgoing message                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SR_PUT        BEGSR
 
      ** Get message length
 
     C     ' '           CHECKR    P@MsgBuf      P@MsgLen
 
      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.
      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.
     C                   EVAL      MDFMT = FMSTR
 
      ** Send message
     C**********         Z-ADD     MQPUT         CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HIN               9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM                    P@MsgLen          9 0                      MD041126
     C**********         PARM                    P@MsgBuf                                   MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( HCONN : HIN : MQMD : MQPMO :                      MD041126
     C                                    P@MsgLen : %ADDR(P@MsgBuf) :                      MD041126
     C                                    CCODE : REASON )                                  MD041126
 
      ** If send message failed, indicate abnormal end
 
     C                   IF        REASON <> RCNONE
     C                   MOVEL     '*ERROR'      Ret_Code
     C                   MOVEL     'SEND MESSAGE'Err_Mess
     C                   MOVEL     'QMQM     '   W0File           10
     C                   MOVEL     Err_Mess      I#ERMS
     C                   MOVEL     REASON        W0Reas           10
     C                   Z-ADD     101           W0ErNb            3 0
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_OPEN - Subroutine to open MQ series queue                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SR_OPEN       BEGSR
 
      ** Connect to the queue manager                                                       MD041126
                                                                                            MD041126
     C                   IF        PQMGR <> LastQMGR                                        MD041126
                                                                                            MD041126
      ** Use default connection handle, and implicit connection
     C                   Z-ADD     HCDEFH        HCONN
 
     C                   EVAL      ODMN = PQMGR                                             MD041126
     C                   Z-ADD     *ZERO         CCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCONN( PQMGR : HCONN :                                  MD041126
     C                                     CCODE : REASON )                                 MD041126
                                                                                            MD041126
     C     REASON        IFNE      RCNONE                                                   MD041126
     C     REASON        ANDNE     RC2002                                                   MD041126
     C                   MOVEL     '*ERROR'      Ret_Code                                   MD041126
     C                   MOVEL     'CONN QUEUE'  Err_Mess                                   MD041126
     C                   MOVEL     'QMQM     '   W0File                                     MD041126
     C                   MOVEL     Err_Mess      I#ERMS                                     MD041126
     C                   MOVEL     REASON        W0Reas                                     MD041126
     C                   Z-ADD     103           W0ErNb                                     MD041126
     C                   EXSR      *PSSR                                                    MD041126
     C                   ENDIF                                                              MD041126
                                                                                            MD041126
     C                   EVAL      LastQMGR = PQMGR                                         MD041126
     C                   ENDIF                                                              MD041126
                                                                                            MD041126
      ** Queue name
     C                   MOVEL     P@QueueNm     ODON             48
 
      ** Open options: OUTPUT and FAIL_IF_QUIESCING
     C     OOOUT         ADD       OOFIQ         OPTS
 
      ** Open queue
     C**********         Z-ADD     MQOPEN        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS              9 0                      MD041126
     C**********         PARM                    HIN               9 0                      MD041126
     C**********         PARM                    OCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN ( HCONN : MQOD : OPTS :                           MD041126
     C                                      HIN : OCODE : REASON )                          MD041126
 
      ** If open queue failed, indicate abnormal end
 
     C     REASON        IFNE      RCNONE
     C                   MOVEL     '*ERROR'      Ret_Code
     C                   MOVEL     'OPEN QUEUE'  Err_Mess
     C                   MOVEL     'QMQM     '   W0File
     C                   MOVEL     Err_Mess      I#ERMS
     C                   MOVEL     REASON        W0Reas
     C                   Z-ADD     103           W0ErNb
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_CLOSE - Subroutine to close MQ series queue                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SR_CLOSE      BEGSR
 
      ** Close options: NONE
     C                   Z-ADD     CONONE        OPTS
 
      ** Close queue
     C**********         Z-ADD     MQCLOS        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HIN               9 0                      MD041126
     C**********         PARM                    OPTS              9 0                      MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( HCONN : HIN : OPTS :                            MD041126
     C                                      CCODE : REASON )                                MD041126
 
      ** If close queue failed, indicate abnormal end
 
     C     REASON        IFNE      RCNONE
     C                   MOVEL     '*ERROR'      Ret_Code
     C                   MOVEL     'CLOSE QUEUE' Err_Mess
     C                   MOVEL     'QMQM     '   W0File
     C                   MOVEL     Err_Mess      I#ERMS
     C                   MOVEL     REASON        W0Reas
     C                   Z-ADD     104           W0ErNb
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Attempt to DISCONNECT from the MQ Manager                                         MD041126
     C                   Z-ADD     *ZERO         CCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : CCODE : REASON )                         MD041126
                                                                                            MD041126
      ** Error processing                                                                   MD041126
     C     REASON        IFNE      RCNONE                                                   MD041126
     C                   MOVEL     '*ERROR'      Ret_Code                                   MD041126
     C                   MOVEL     'DISC QUEUE'  Err_Mess                                   MD041126
     C                   MOVEL     'QMQM     '   W0File                                     MD041126
     C                   MOVEL     Err_Mess      I#ERMS                                     MD041126
     C                   MOVEL     REASON        W0Reas                                     MD041126
     C                   Z-ADD     104           W0ErNb                                     MD041126
     C                   EXSR      *PSSR                                                    MD041126
     C                   ENDIF                                                              MD041126
                                                                                            MD041126
     C                   ENDSR
      *****************************************************************
      /EJECT
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
**CTDATA cpy@
(c) Finastra International Limited 2001
