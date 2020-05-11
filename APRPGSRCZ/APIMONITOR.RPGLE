     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas API Server Monitor Program')                     *
      *****************************************************************
      *                                                               *
      *  Midas - API Interface Module                                 *
      *                                                               *
      *  APIMONITOR - Midas API Server Monitor Program                *
      *                                                               *
      *  Function:  This program controls the submission and removal  *
      *             of APIINPUT programs from the Midas subsystem.    *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 04May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 11May06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 XNNNNN  *CREATE    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055614.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK025 - PAckaging changes for MidasPlus 1.3.                *
      *                                                               *
      *****************************************************************
      *
      ** File to store active job details
     FAPIJOBL0  UF   E           K DISK
      *
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D CMD             S             14    DIM(1) CTDATA PERRCD(1)
      ** Array containing Delay job command
      *
     D***SELS***         S              9  0 DIM(1)                                         MD041126
     D SELS            S             10I 0 DIM(1)                                           MD041126
      ** Array of selectors (properties of queue to inquire after)
      *
     D***IAV****         S              9  0 DIM(1)                                         MD041126
     D IAV             S             10I 0 DIM(1)                                           MD041126
      ** Output from queue inquiry
      *
      ** MQ Variables                                                                       MD041126
     D QMGR            S             48A                                                    MD041126
     D HANDLE          S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D HCONN           S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D HINQ            S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D SELCNT          S             10I 0                                                  MD041126
     D IACNT           S             10I 0                                                  MD041126
     D CACNT           S             10I 0                                                  MD041126
     D CAV             S             20A                                                    MD041126
     D BUFLEN          S             10I 0                                                  MD041126
     D BUFFER          S              8A                                                    MD041126
                                                                                            MD041126
      ********************************************************************
      *
      ***MQI*named*constants*                                                                 CPK025
     D*COPY*QRPGSRC,CMQR*                                                                     CPK025
     D***/COPY*QMQM/QRPGSRC,CMQR                                                     CPK025 MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
      *
      ** Object Descriptor
     D MQOD            DS
     D*COPY*QRPGSRC,CMQODR*                                                                   CPK025
     D***/COPY*QMQM/QRPGSRC,CMQODR                                                   CPK025 MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
      *
      ** Message Descriptor
     D MQMD            DS
     D*COPY*QRPGSRC,CMQMDR*                                                                   CPK025
     D***/COPY*QMQM/QRPGSRC,CMQMDR                                                   CPK025 MD041126
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
      *
      ** Get message options
     D MQGMO           DS
     D*COPY*QRPGSRC,CMQGMOR*                                                                  CPK025
     D***/COPY*QMQM/QRPGSRC,CMQGMOR                                                  CPK025 MD041126
     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD041126
      *
      ** Put message options
     D MQPMO           DS
     D*COPY*QRPGSRC,CMQPMOR*                                                                  CPK025
     D***/COPY*QMQM/QRPGSRC,CMQPMOR                                                  CPK025 MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
      *
      ** Queue name
     D QIN             C                   CONST('MIDAS.INPUT.QUEUE')
      ********************************************************************
      *
      *   Main Processing
      *
      ********************************************************************
      *
     C                   EXSR      MQCONNECT                                                MD041126
     C                   Z-ADD     HANDLE        HCONN                                      MD041126
     C                   EXSR      OPENQ
      *
      ** Loop until job terminated
      *
     C     *IN90         DOWNE     *ON
      *
     C                   EXSR      DEPTH
     C                   EXSR      ACTIVE
     C     NOACT         DOWLT     NOREQ
     C                   EXSR      START
     C                   ENDDO
      *
      ** Shut down one job at a time to prevent overreaction
      *
     C     NOACT         IFGT      NOREQ
     C                   EXSR      STOP
     C                   ENDIF
      *
      ** Shutdown processing
      *
     C                   SHTDN                                        90
      *
      ** Delay job
      *
     C     *IN90         IFEQ      *OFF
     C                   Z-ADD     14            LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD              14
     C                   PARM                    LEN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     NOACT         DOWGT     0
     C                   EXSR      STOP
     C                   ENDDO
     C                   EXSR      CLOSEQ
     C                   EXSR      MQDISCONNECT                                             MD041126
      *
     C                   SETON                                        LR
     C                   RETURN
      ********************************************************************
      *
      *   Inquire on current queue depth, and judge required number
      *   of processing programs
      *
      ********************************************************************
     C     DEPTH         BEGSR
      *
      ** Reset arguments
      *
     C                   Z-ADD     IACDEP        SELS(1)
     C                   Z-ADD     1             IACNT
     C                   Z-ADD     0             CACNT
      *
      ** Inquire about number of messages on queue
      *
     C**********         Z-ADD     MQINQ         CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HINQ              9 0                      MD041126
     C**********         PARM                    SELCNT                                     MD041126
     C**********         PARM                    SELS                                       MD041126
     C**********         PARM                    IACNT             9 0                      MD041126
     C**********         PARM                    IAV                                        MD041126
     C**********         PARM                    CACNT             9 0                      MD041126
     C**********         PARM                    CAV              20                        MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
      *                                                                                     MD041126
     C                   CALLP     MQINQ( HCONN : HINQ : SELCNT :                           MD041126
     C                                    SELS(1) : IACNT : IAV(1) :                        MD041126
     C                                    CACNT : %ADDR(CAV) :                              MD041126
     C                                    CCODE : REASON )                                  MD041126
      *
      ** Error processing
      *
     C     REASON        IFNE      RCNONE
     C                   ENDIF
      *
      ** Judge required number of input programs
      *
     C                   Z-ADD     1             NOREQ
     C                   SELECT
     C     IAV(1)        WHENGT    1000
     C                   ADD       8             NOREQ
     C     IAV(1)        WHENGT    100
     C                   ADD       4             NOREQ             3 0
     C     IAV(1)        WHENGT    40
     C                   ADD       3             NOREQ
     C     IAV(1)        WHENGT    10
     C                   ADD       2             NOREQ
     C                   ENDSL
      *
     C                   ENDSR
      ********************************************************************
      *
      *   Check number of jobs active, remove dead entries from file
      *
      ********************************************************************
     C     ACTIVE        BEGSR
     C                   Z-ADD     0             NOACT
     C                   SETOFF                                       91
     C     *LOVAL        SETLL     JOBRCD
      *
      ** Loop to read all records in active jobs file
      *
     C     *IN91         DOWEQ     *OFF
     C                   READ      JOBRCD                                 91
     C     *IN91         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
      *
      ** Call to check if the expected program is active
      *
     C                   CALL      'APICHKSR'
     C                   PARM                    NAME             10
     C                   PARM                    USER             10
     C                   PARM                    NUMBER            6
     C                   PARM                    RETURN            1
      *
      ** If yes, count job
      ** If no, remove record from active jobs file
      *
     C     RETURN        IFEQ      '0'
     C                   ADD       1             NOACT             3 0
     C                   ENDIF
     C     RETURN        IFEQ      '1'
     C                   DELETE    JOBRCD
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      *
      *   Submit processing to batch, add details to jobs file
      *
      ********************************************************************
     C     START         BEGSR
      *
      ** Submit job
      *
     C                   CALL      'APISTART'
     C                   ADD       1             NOACT
      *
     C                   ENDSR
      ********************************************************************
      *
      *   Send single 'SHUTDOWN' message to queue
      *
      ********************************************************************
     C     STOP          BEGSR
      *
      ** Set message format to String (to enable ASCII to EBCDIC)
      *
     C                   MOVEL     FMSTR         MDFMT
      *
      ** Put message (default put message options)
      *
     C**********         Z-ADD     MQPUT         CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HINQ              9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM                    BUFLEN            9 0                      MD041126
     C**********         PARM                    BUFFER            8                        MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
      *                                                                                     MD041126
     C                   CALLP     MQPUT( HCONN : HINQ : MQMD : MQPMO :                     MD041126
     C                                    BUFLEN : %ADDR(BUFFER) :                          MD041126
     C                                    CCODE : REASON )                                  MD041126
      *
      ** Error processing
      *
     C     REASON        IFNE      RCNONE
     C                   ELSE
     C                   SUB       1             NOACT
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      *
      *   Open queue for inquiry and input
      *
      ********************************************************************
     C     OPENQ         BEGSR
      *
      ** Open options: INQUIRE and FAIL-IF-QUIESCING
      *
     C     OOINQ         ADD       OOFIQ         OPTS
     C                   ADD       OOOUT         OPTS
      *
      ** Open queue
      *
     C**********         Z-ADD     MQOPEN        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS              9 0                      MD041126
     C**********         PARM                    HINQ              9 0                      MD041126
     C**********         PARM                    OCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
      *                                                                                     MD041126
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
     C                                     HINQ : OCODE : REASON )                          MD041126
      *
      ** Error processing
      *
     C     REASON        IFNE      RCNONE
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      *
      *   Close queue
      *
      ********************************************************************
     C     CLOSEQ        BEGSR
      *
      ** Close options: NONE
      *
     C                   Z-ADD     CONONE        OPTS
      *
      ** Close queue
      *
     C**********         Z-ADD     MQCLOS        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HINQ              9 0                      MD041126
     C**********         PARM                    OPTS              9 0                      MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
      *                                                                                     MD041126
     C                   CALLP     MQCLOSE( HCONN : HINQ : OPTS :                           MD041126
     C                                      CCODE : REASON )                                MD041126
      *
      ** Error processing
      *
     C     REASON        IFNE      RCNONE
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                     MD041126
      *                                                               *                     MD041126
      *  Open connection to the queue manager                         *                     MD041126
      *                                                               *                     MD041126
      *****************************************************************                     MD041126
     C     MQCONNECT     BEGSR                                                              MD041126
                                                                                            MD041126
      ** Attempt to CONNECT to the MQ Manager                                               MD041126
     C                   MOVEL     *BLANKS       QMGR                                       MD041126
     C                   Z-ADD     *ZERO         HANDLE                                     MD041126
     C                   Z-ADD     *ZERO         CCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCONN( QMGR : HANDLE :                                  MD041126
     C                                     CCODE : REASON )                                 MD041126
                                                                                            MD041126
      ** Error processing                                                                   MD041126
     C     REASON        IFNE      RCNONE                                                   MD041126
     C     REASON        ANDNE     RC2002                                                   MD041126
     C                   ENDIF                                                              MD041126
                                                                                            MD041126
     C                   ENDSR                                                              MD041126
      *****************************************************************                     MD041126
      *                                                               *                     MD041126
      *  Disconnect from the queue manager                            *                     MD041126
      *                                                               *                     MD041126
      *****************************************************************                     MD041126
     C     MQDISCONNECT  BEGSR                                                              MD041126
                                                                                            MD041126
      **  Attempt to DISCONNECT from the MQ Manager                                         MD041126
     C                   Z-ADD     *ZERO         CCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : CCODE : REASON )                         MD041126
                                                                                            MD041126
      ** Error processing                                                                   MD041126
     C     REASON        IFNE      RCNONE                                                   MD041126
     C                   ENDIF                                                              MD041126
                                                                                            MD041126
     C                   ENDSR                                                              MD041126
      ********************************************************************
      *
      *   Initialisation subroutine
      *
      ********************************************************************
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Apply queue name to object descriptor
      *
     C                   MOVEL     QIN           ODON             48
      *
      ** Use default connection handle (implicit connection)
      *
     C                   Z-ADD     HCDEFH        HCONN
      *
      ** Number of attributes to be returned = 1 (current depth)
      *
     C**********         Z-ADD     1             SELCNT            9 0                      MD041126
     C                   Z-ADD     1             SELCNT                                     MD041126
      *
      ** Shutdown message
      *
     C                   Z-ADD     8             BUFLEN
     C                   MOVEL     'SHUTDOWN'    BUFFER
      *
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  CMD      - Commands for QCMDEXC
DLYJOB DLY(10)
