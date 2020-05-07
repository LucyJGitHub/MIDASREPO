000001200505     H DEBUG
000002200505      *****************************************************************
000003200505/*S*D ***RPGBASE*******************************************************                     MD041126
000004200505/*STD *  RPGBASEMOD                                                   *                     MD041126
000005200505/*EXI *  TEXT('Midas API Server Monitor Program')                     *
000006200505      *****************************************************************
000007200505      *                                                               *
000008200505      *  Midas - API Interface Module                                 *
000009200505      *                                                               *
000010200505      *  APIMONITOR - Midas API Server Monitor Program                *
000011200505      *                                                               *
000012200505      *  Function:  This program controls the submission and removal  *
000013200505      *             of APIINPUT programs from the Midas subsystem.    *
000014200505      *                                                               *
000015200505      *  Called By: mmCnnnn - (program name)                          *
000016200505      *                                                               *
000017200505      *  (c) Finastra International Limited 2001                      *
000018200505      *                                                               *
000019200505      *  Last Amend No. MD041126           Date 04May20               *
000020200505      *  Prev Amend No. MD046248           Date 27Oct17               *
000021200505      * Bank Fusion Midas 1.4 Base -----------------------------------*
000022200505      * Midas Plus 1.4 Base 04 ---------------------------------------*
000023200505      * Midas Plus 1.4 Base ------------------------------------------*
000024200505      * Midas Plus 1.3 ----------- Base ------------------------------*
000025200505      *                 CPK025             Date 11May06               *
000026200505      * Midas Release 4 --------------- Base -------------------------*
000027200505      * Midas DBA 3.00 ---------------- Base -------------------------*
000028200505      *                 XNNNNN  *CREATE    Date DDMmmYY               *
000029200505      *                                                               *
000030200505      *---------------------------------------------------------------*
000031200505      *                                                               *
000032200505      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
000033200505      *           - Applied for MD055614.                             *
000034200505      *  MD046248 - Finastra Rebranding                               *
000035200505      *  CPK025 - PAckaging changes for MidasPlus 1.3.                *
000036200505      *                                                               *
000037200505      *****************************************************************
000038200505      *
000039200505      ** File to store active job details
000040200505     FAPIJOBL0  UF   E           K DISK
000041200505      *
000042200505      /EJECT
000043200505     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
000044200505      ** Array containing Copyright statement
000045200505      *
000046200505     D CMD             S             14    DIM(1) CTDATA PERRCD(1)
000047200505      ** Array containing Delay job command
000048200505      *
000049200505     D***SELS***         S              9  0 DIM(1)                                         MD041126
000050200505     D SELS            S             10I 0 DIM(1)                                           MD041126
000051200505      ** Array of selectors (properties of queue to inquire after)
000052200505      *
000053200505     D***IAV****         S              9  0 DIM(1)                                         MD041126
000054200505     D IAV             S             10I 0 DIM(1)                                           MD041126
000055200505      ** Output from queue inquiry
000056200505      *
000057200505      ** MQ Variables                                                                       MD041126
000058200505     D QMGR            S             48A                                                    MD041126
000059200505     D HANDLE          S             10I 0                                                  MD041126
000060200505     D CCODE           S             10I 0                                                  MD041126
000061200505     D REASON          S             10I 0                                                  MD041126
000062200505     D HCONN           S             10I 0                                                  MD041126
000063200505     D OPTS            S             10I 0                                                  MD041126
000064200505     D HINQ            S             10I 0                                                  MD041126
000065200505     D OCODE           S             10I 0                                                  MD041126
000066200505     D SELCNT          S             10I 0                                                  MD041126
000067200505     D IACNT           S             10I 0                                                  MD041126
000068200505     D CACNT           S             10I 0                                                  MD041126
000069200505     D CAV             S             20A                                                    MD041126
000070200505     D BUFLEN          S             10I 0                                                  MD041126
000071200505     D BUFFER          S              8A                                                    MD041126
000072200505                                                                                            MD041126
000073200505      ********************************************************************
000074200505      *
000075200505      ***MQI*named*constants*                                                                 CPK025
000076200505     D*COPY*QRPGSRC,CMQR*                                                                     CPK025
000077200505     D***/COPY*QMQM/QRPGSRC,CMQR                                                     CPK025 MD041126
000078200505     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
000079200505      *
000080200505      ** Object Descriptor
000081200505     D MQOD            DS
000082200505     D*COPY*QRPGSRC,CMQODR*                                                                   CPK025
000083200505     D***/COPY*QMQM/QRPGSRC,CMQODR                                                   CPK025 MD041126
000084200505     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
000085200505      *
000086200505      ** Message Descriptor
000087200505     D MQMD            DS
000088200505     D*COPY*QRPGSRC,CMQMDR*                                                                   CPK025
000089200505     D***/COPY*QMQM/QRPGSRC,CMQMDR                                                   CPK025 MD041126
000090200505     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
000091200505      *
000092200505      ** Get message options
000093200505     D MQGMO           DS
000094200505     D*COPY*QRPGSRC,CMQGMOR*                                                                  CPK025
000095200505     D***/COPY*QMQM/QRPGSRC,CMQGMOR                                                  CPK025 MD041126
000096200505     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD041126
000097200505      *
000098200505      ** Put message options
000099200505     D MQPMO           DS
000100200505     D*COPY*QRPGSRC,CMQPMOR*                                                                  CPK025
000101200505     D***/COPY*QMQM/QRPGSRC,CMQPMOR                                                  CPK025 MD041126
000102200505     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
000103200505      *
000104200505      ** Queue name
000105200505     D QIN             C                   CONST('MIDAS.INPUT.QUEUE')
000106200505      ********************************************************************
000107200505      *
000108200505      *   Main Processing
000109200505      *
000110200505      ********************************************************************
000111200505      *
000112200505     C                   EXSR      MQCONNECT                                                MD041126
000113200505     C                   Z-ADD     HANDLE        HCONN                                      MD041126
000114200505     C                   EXSR      OPENQ
000115200505      *
000116200505      ** Loop until job terminated
000117200505      *
000118200505     C     *IN90         DOWNE     *ON
000119200505      *
000120200505     C                   EXSR      DEPTH
000121200505     C                   EXSR      ACTIVE
000122200505     C     NOACT         DOWLT     NOREQ
000123200505     C                   EXSR      START
000124200505     C                   ENDDO
000125200505      *
000126200505      ** Shut down one job at a time to prevent overreaction
000127200505      *
000128200505     C     NOACT         IFGT      NOREQ
000129200505     C                   EXSR      STOP
000130200505     C                   ENDIF
000131200505      *
000132200505      ** Shutdown processing
000133200505      *
000134200505     C                   SHTDN                                        90
000135200505      *
000136200505      ** Delay job
000137200505      *
000138200505     C     *IN90         IFEQ      *OFF
000139200505     C                   Z-ADD     14            LEN              15 5
000140200505     C                   CALL      'QCMDEXC'
000141200505     C                   PARM                    CMD              14
000142200505     C                   PARM                    LEN
000143200505     C                   ENDIF
000144200505      *
000145200505     C                   ENDDO
000146200505      *
000147200505     C     NOACT         DOWGT     0
000148200505     C                   EXSR      STOP
000149200505     C                   ENDDO
000150200505     C                   EXSR      CLOSEQ
000151200505     C                   EXSR      MQDISCONNECT                                             MD041126
000152200505      *
000153200505     C                   SETON                                        LR
000154200505     C                   RETURN
000155200505      ********************************************************************
000156200505      *
000157200505      *   Inquire on current queue depth, and judge required number
000158200505      *   of processing programs
000159200505      *
000160200505      ********************************************************************
000161200505     C     DEPTH         BEGSR
000162200505      *
000163200505      ** Reset arguments
000164200505      *
000165200505     C                   Z-ADD     IACDEP        SELS(1)
000166200505     C                   Z-ADD     1             IACNT
000167200505     C                   Z-ADD     0             CACNT
000168200505      *
000169200505      ** Inquire about number of messages on queue
000170200505      *
000171200505     C**********         Z-ADD     MQINQ         CID                                        MD041126
000172200505     C**********         CALL      'QMQM'                                                   MD041126
000173200505     C**********         PARM                    CID               9 0                      MD041126
000174200505     C**********         PARM                    HCONN             9 0                      MD041126
000175200505     C**********         PARM                    HINQ              9 0                      MD041126
000176200505     C**********         PARM                    SELCNT                                     MD041126
000177200505     C**********         PARM                    SELS                                       MD041126
000178200505     C**********         PARM                    IACNT             9 0                      MD041126
000179200505     C**********         PARM                    IAV                                        MD041126
000180200505     C**********         PARM                    CACNT             9 0                      MD041126
000181200505     C**********         PARM                    CAV              20                        MD041126
000182200505     C**********         PARM                    CCODE             9 0                      MD041126
000183200505     C**********         PARM                    REASON            9 0                      MD041126
000184200505      *                                                                                     MD041126
000185200505     C                   CALLP     MQINQ( HCONN : HINQ : SELCNT :                           MD041126
000186200505     C                                    SELS(1) : IACNT : IAV(1) :                        MD041126
000187200505     C                                    CACNT : %ADDR(CAV) :                              MD041126
000188200505     C                                    CCODE : REASON )                                  MD041126
000189200505      *
000190200505      ** Error processing
000191200505      *
000192200505     C     REASON        IFNE      RCNONE
000193200505     C                   ENDIF
000194200505      *
000195200505      ** Judge required number of input programs
000196200505      *
000197200505     C                   Z-ADD     1             NOREQ
000198200505     C                   SELECT
000199200505     C     IAV(1)        WHENGT    1000
000200200505     C                   ADD       8             NOREQ
000201200505     C     IAV(1)        WHENGT    100
000202200505     C                   ADD       4             NOREQ             3 0
000203200505     C     IAV(1)        WHENGT    40
000204200505     C                   ADD       3             NOREQ
000205200505     C     IAV(1)        WHENGT    10
000206200505     C                   ADD       2             NOREQ
000207200505     C                   ENDSL
000208200505      *
000209200505     C                   ENDSR
000210200505      ********************************************************************
000211200505      *
000212200505      *   Check number of jobs active, remove dead entries from file
000213200505      *
000214200505      ********************************************************************
000215200505     C     ACTIVE        BEGSR
000216200505     C                   Z-ADD     0             NOACT
000217200505     C                   SETOFF                                       91
000218200505     C     *LOVAL        SETLL     JOBRCD
000219200505      *
000220200505      ** Loop to read all records in active jobs file
000221200505      *
000222200505     C     *IN91         DOWEQ     *OFF
000223200505     C                   READ      JOBRCD                                 91
000224200505     C     *IN91         IFEQ      *ON
000225200505     C                   LEAVE
000226200505     C                   ENDIF
000227200505      *
000228200505      ** Call to check if the expected program is active
000229200505      *
000230200505     C                   CALL      'APICHKSR'
000231200505     C                   PARM                    NAME             10
000232200505     C                   PARM                    USER             10
000233200505     C                   PARM                    NUMBER            6
000234200505     C                   PARM                    RETURN            1
000235200505      *
000236200505      ** If yes, count job
000237200505      ** If no, remove record from active jobs file
000238200505      *
000239200505     C     RETURN        IFEQ      '0'
000240200505     C                   ADD       1             NOACT             3 0
000241200505     C                   ENDIF
000242200505     C     RETURN        IFEQ      '1'
000243200505     C                   DELETE    JOBRCD
000244200505     C                   ENDIF
000245200505      *
000246200505     C                   ENDDO
000247200505      *
000248200505     C                   ENDSR
000249200505      ********************************************************************
000250200505      *
000251200505      *   Submit processing to batch, add details to jobs file
000252200505      *
000253200505      ********************************************************************
000254200505     C     START         BEGSR
000255200505      *
000256200505      ** Submit job
000257200505      *
000258200505     C                   CALL      'APISTART'
000259200505     C                   ADD       1             NOACT
000260200505      *
000261200505     C                   ENDSR
000262200505      ********************************************************************
000263200505      *
000264200505      *   Send single 'SHUTDOWN' message to queue
000265200505      *
000266200505      ********************************************************************
000267200505     C     STOP          BEGSR
000268200505      *
000269200505      ** Set message format to String (to enable ASCII to EBCDIC)
000270200505      *
000271200505     C                   MOVEL     FMSTR         MDFMT
000272200505      *
000273200505      ** Put message (default put message options)
000274200505      *
000275200505     C**********         Z-ADD     MQPUT         CID                                        MD041126
000276200505     C**********         CALL      'QMQM'                                                   MD041126
000277200505     C**********         PARM                    CID               9 0                      MD041126
000278200505     C**********         PARM                    HCONN             9 0                      MD041126
000279200505     C**********         PARM                    HINQ              9 0                      MD041126
000280200505     C**********         PARM                    MQMD                                       MD041126
000281200505     C**********         PARM                    MQPMO                                      MD041126
000282200505     C**********         PARM                    BUFLEN            9 0                      MD041126
000283200505     C**********         PARM                    BUFFER            8                        MD041126
000284200505     C**********         PARM                    CCODE             9 0                      MD041126
000285200505     C**********         PARM                    REASON            9 0                      MD041126
000286200505      *                                                                                     MD041126
000287200505     C                   CALLP     MQPUT( HCONN : HINQ : MQMD : MQPMO :                     MD041126
000288200505     C                                    BUFLEN : %ADDR(BUFFER) :                          MD041126
000289200505     C                                    CCODE : REASON )                                  MD041126
000290200505      *
000291200505      ** Error processing
000292200505      *
000293200505     C     REASON        IFNE      RCNONE
000294200505     C                   ELSE
000295200505     C                   SUB       1             NOACT
000296200505     C                   ENDIF
000297200505      *
000298200505     C                   ENDSR
000299200505      ********************************************************************
000300200505      *
000301200505      *   Open queue for inquiry and input
000302200505      *
000303200505      ********************************************************************
000304200505     C     OPENQ         BEGSR
000305200505      *
000306200505      ** Open options: INQUIRE and FAIL-IF-QUIESCING
000307200505      *
000308200505     C     OOINQ         ADD       OOFIQ         OPTS
000309200505     C                   ADD       OOOUT         OPTS
000310200505      *
000311200505      ** Open queue
000312200505      *
000313200505     C**********         Z-ADD     MQOPEN        CID                                        MD041126
000314200505     C**********         CALL      'QMQM'                                                   MD041126
000315200505     C**********         PARM                    CID               9 0                      MD041126
000316200505     C**********         PARM                    HCONN             9 0                      MD041126
000317200505     C**********         PARM                    MQOD                                       MD041126
000318200505     C**********         PARM                    OPTS              9 0                      MD041126
000319200505     C**********         PARM                    HINQ              9 0                      MD041126
000320200505     C**********         PARM                    OCODE             9 0                      MD041126
000321200505     C**********         PARM                    REASON            9 0                      MD041126
000322200505      *                                                                                     MD041126
000323200505     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
000324200505     C                                     HINQ : OCODE : REASON )                          MD041126
000325200505      *
000326200505      ** Error processing
000327200505      *
000328200505     C     REASON        IFNE      RCNONE
000329200505     C                   ENDIF
000330200505      *
000331200505     C                   ENDSR
000332200505      ********************************************************************
000333200505      *
000334200505      *   Close queue
000335200505      *
000336200505      ********************************************************************
000337200505     C     CLOSEQ        BEGSR
000338200505      *
000339200505      ** Close options: NONE
000340200505      *
000341200505     C                   Z-ADD     CONONE        OPTS
000342200505      *
000343200505      ** Close queue
000344200505      *
000345200505     C**********         Z-ADD     MQCLOS        CID                                        MD041126
000346200505     C**********         CALL      'QMQM'                                                   MD041126
000347200505     C**********         PARM                    CID               9 0                      MD041126
000348200505     C**********         PARM                    HCONN             9 0                      MD041126
000349200505     C**********         PARM                    HINQ              9 0                      MD041126
000350200505     C**********         PARM                    OPTS              9 0                      MD041126
000351200505     C**********         PARM                    CCODE             9 0                      MD041126
000352200505     C**********         PARM                    REASON            9 0                      MD041126
000353200505      *                                                                                     MD041126
000354200505     C                   CALLP     MQCLOSE( HCONN : HINQ : OPTS :                           MD041126
000355200505     C                                      CCODE : REASON )                                MD041126
000356200505      *
000357200505      ** Error processing
000358200505      *
000359200505     C     REASON        IFNE      RCNONE
000360200505     C                   ENDIF
000361200505      *
000362200505     C                   ENDSR
000363200505      *****************************************************************                     MD041126
000364200505      *                                                               *                     MD041126
000365200505      *  Open connection to the queue manager                         *                     MD041126
000366200505      *                                                               *                     MD041126
000367200505      *****************************************************************                     MD041126
000368200505     C     MQCONNECT     BEGSR                                                              MD041126
000369200505                                                                                            MD041126
000370200505      ** Attempt to CONNECT to the MQ Manager                                               MD041126
000371200505     C                   MOVEL     *BLANKS       QMGR                                       MD041126
000372200505     C                   Z-ADD     *ZERO         HANDLE                                     MD041126
000373200505     C                   Z-ADD     *ZERO         CCODE                                      MD041126
000374200505     C                   Z-ADD     *ZERO         REASON                                     MD041126
000375200505     C                   CALLP     MQCONN( QMGR : HANDLE :                                  MD041126
000376200505     C                                     CCODE : REASON )                                 MD041126
000377200505                                                                                            MD041126
000378200505      ** Error processing                                                                   MD041126
000379200505     C     REASON        IFNE      RCNONE                                                   MD041126
000380200505     C     REASON        ANDNE     RC2002                                                   MD041126
000381200505     C                   ENDIF                                                              MD041126
000382200505                                                                                            MD041126
000383200505     C                   ENDSR                                                              MD041126
000384200505      *****************************************************************                     MD041126
000385200505      *                                                               *                     MD041126
000386200505      *  Disconnect from the queue manager                            *                     MD041126
000387200505      *                                                               *                     MD041126
000388200505      *****************************************************************                     MD041126
000389200505     C     MQDISCONNECT  BEGSR                                                              MD041126
000390200505                                                                                            MD041126
000391200505      **  Attempt to DISCONNECT from the MQ Manager                                         MD041126
000392200505     C                   Z-ADD     *ZERO         CCODE                                      MD041126
000393200505     C                   Z-ADD     *ZERO         REASON                                     MD041126
000394200505     C                   CALLP     MQDISC( HCONN : CCODE : REASON )                         MD041126
000395200505                                                                                            MD041126
000396200505      ** Error processing                                                                   MD041126
000397200505     C     REASON        IFNE      RCNONE                                                   MD041126
000398200505     C                   ENDIF                                                              MD041126
000399200505                                                                                            MD041126
000400200505     C                   ENDSR                                                              MD041126
000401200505      ********************************************************************
000402200505      *
000403200505      *   Initialisation subroutine
000404200505      *
000405200505      ********************************************************************
000406200505     C     *INZSR        BEGSR
000407200505      *
000408200505      ** Set up copyright parameter
000409200505      *
000410200505     C                   MOVEA     CPY@          CPY2@            80
000411200505      *
000412200505      ** Apply queue name to object descriptor
000413200505      *
000414200505     C                   MOVEL     QIN           ODON             48
000415200505      *
000416200505      ** Use default connection handle (implicit connection)
000417200505      *
000418200505     C                   Z-ADD     HCDEFH        HCONN
000419200505      *
000420200505      ** Number of attributes to be returned = 1 (current depth)
000421200505      *
000422200505     C**********         Z-ADD     1             SELCNT            9 0                      MD041126
000423200505     C                   Z-ADD     1             SELCNT                                     MD041126
000424200505      *
000425200505      ** Shutdown message
000426200505      *
000427200505     C                   Z-ADD     8             BUFLEN
000428200505     C                   MOVEL     'SHUTDOWN'    BUFFER
000429200505      *
000430200505     C                   ENDSR
000431200505      ********************************************************************
000432200505**  CPY@
000433200505(c) Finastra International Limited 2001
000434200505**  CMD      - Commands for QCMDEXC
000435200505DLYJOB DLY(10)
