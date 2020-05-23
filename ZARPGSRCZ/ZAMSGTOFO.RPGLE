     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Send a message to the Front Office')          *
      *****************************************************************
      *                                                               *
      *  Midas - Common subprograms                                   *
      *                                                               *
      *  ZAMSGTOFO - Send a message to the Front Office               *
      *                                                               *
      *  Function:  This module was originally intended to send a     *
      *             message to the Front Office using MQSeries, where *
      *             The Front Office was expected to be the source of *
      *             the message that caused this message to be sent.  *
      *             However as the main input parameters are just the *
      *             name of an MQSeries queue and a message, this can *
      *             used to send a message to any MQSeries queue.     *
      *                                                               *
      *  Possible return codes                                        *
      *  =====================                                        *
      *    ErrOpnOutP - Unable to open queue for output               *
      *    ErrRCnnnn  - An MQSeries reason code, where nnnn is a four-*
      *                 digit number; see the MQSeries documentation  *
      *                 for their meanings.                           *
      *                                                               *
      *  Component of: ZAMESSAGE - ZA Message handling service program*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 06Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1079155          Date 23Jan12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 259935C            Date 21May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256332             Date 01Sep08               *
      *                 248095A            Date 26Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 02Nov98               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055452.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1079155 - APCENDBKJB component failed during COB run       *
      *  259935C- No need for Disconnect to prevent RC 2037. Fix is   *
      *           to partially reverse 256332.                        *
      *  256332 - Ensure that message is put on the queue and that    *
      *           connect subroutine is called. Re-arrange codes of   *
      *           fix 248095A. Applied fix 251023.                    *
      *  248095A- Account for having no default queue manager by      *
      *           using new system value to hold queue manager name.  *
      *           Applied fix 245310A.                                *
      *  CAP006 - Addition of a priority for messages                 *
      *         - Extension of queue name to maximum length           *
      *  CAP004 - Prevents the queue being opened and closed on each  *
      *           call, if the same queue is requested as last time.  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--- MQSeries includes ----------------+
      ** ¦                                      ¦
      ** ¦ The following set of includes is     ¦
      ** ¦ provided by IBM for use with         ¦
      ** ¦ MQSeries.  See the source file       ¦
      ** ¦ QMQM/QRPGLESRC for details of their  ¦
      ** ¦ values.                              ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
 
      ** MQI named constants
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
 
      ** Put message options
     D MQPMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D/COPY WNCPYSRC,ZAH00026
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** 4-alpha and 6-alpha fields for the MQ error code
     D RCode4A         S              4A
     D RCode6A         S              6A   INZ('RC    ')
 
      * Constant to hold input parameter for AOSVALR0.                                       248095A
     D MQManager       C                   Const('MQQueueManagerAPI')                        248095A
                                                                                             248095A
      ** The name of the queue to use
     D*Queue***********S             20A                                        CAP006
     D Queue           S             48A                                        CAP006
 
      ** The name of the last queue used                                        CAP004
     D*LastQueue*******S             20A                                        CAP006
     D LastQueue       S             48A                                        CAP006
                                                                                CAP004
      ** The message to be sent to the front office
     D/COPY WNCPYSRC,ZAH00054
     D MQString        S           1102A
     D/COPY WNCPYSRC,ZAH00055
 
      ** The length of the MQString field
     D/COPY WNCPYSRC,ZAH00056
     D*MQStrLen*       S              5P 0 INZ(1102)                                       AR1079155
     D/COPY WNCPYSRC,ZAH00057
     D MQStrLen        S              9P 0 INZ(1102)                                       AR1079155
 
      ** The position of the first blank position in the string after the
      ** bosy of the text.
     D FirstBlnkP      S              5P 0
      *                                                                                      248095A
     D PSysVal01       S             20A                                                     248095A
     D PCurSet01       S            200A                                                     248095A
     D PSysVal02       S             20A                                                     248095A
     D PCurSet02       S            200A                                                     248095A
     D PSysVal03       S             20A                                                     248095A
     D PCurSet03       S            200A                                                     248095A
     D PSysVal04       S             20A                                                     248095A
     D PCurSet04       S            200A                                                     248095A
     D PSysVal05       S             20A                                                     248095A
     D PCurSet05       S            200A                                                     248095A
     D PSysVal06       S             20A                                                     248095A
     D PCurSet06       S            200A                                                     248095A
     D PSysVal07       S             20A                                                     248095A
     D PCurSet07       S            200A                                                     248095A
     D PSysVal08       S             20A                                                     248095A
     D PCurSet08       S            200A                                                     248095A
     D PSysVal09       S             20A                                                     248095A
     D PCurSet09       S            200A                                                     248095A
     D PSysVal10       S             20A                                                     248095A
     D PCurSet10       S            200A                                                     248095A
 
      ** MQ Parameters                                                                      MD041126
     D HCONN           S             10I 0                                                  MD041126
     D HOBJ            S             10I 0                                                  MD041126
     D BUFLEN          S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D HANDLE          S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
                                                                                            MD041126
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     ****+---*Open*MQSeries*queue*--------------+*******************************CAP004
     ****¦**************************************¦*******************************CAP004
     ****¦*For*each*message,*the*queue*has*to***¦*******************************CAP004
     ****¦*be*opened.**The*queue*is*opened*and**¦*******************************CAP004
     ****¦*closed*each*time*to*ensure*that*each*¦*******************************CAP004
     ****¦*message*is*sent*to*the*queue*it*is***¦*******************************CAP004
     ****¦*intended*for.**If*the*queue*is*left**¦*******************************CAP004
     ****¦*open,*subsequent*calls*can*result*in*¦*******************************CAP004
     ****¦*the*message*going*to*the*wrong*******¦*******************************CAP004
     ****¦*queue.*******************************¦*******************************CAP004
     ****¦**************************************¦*******************************CAP004
     ****+--------------------------------------+*******************************CAP004
      **********                                                                      248095A 256332
      ***If*a*Queue*Manager*is*specified*on*system*value*MQManager,*connect           248095A 256332
      ***to*it*and*retain*connection*handle*for*other*QMQM*calls*instead              248095A 256332
      ***of*using*the*default*Queue*Manager*and*connection*************               248095A 256332
      **********                                                                      248095A 256332
     C**********         CALLB     'AOSVALR0'                                         248095A 256332
     C**********         PARM      *BLANKS       PRtCd             7                  248095A 256332
     C**********         PARM      MQManager     PSysVal01                            248095A 256332
     C**********         PARM                    PCurSet01                            248095A 256332
     C**********         PARM                    PSysVal02                            248095A 256332
     C**********         PARM                    PCurSet02                            248095A 256332
     C**********         PARM                    PSysVal03                            248095A 256332
     C**********         PARM                    PCurSet03                            248095A 256332
     C**********         PARM                    PSysVal04                            248095A 256332
     C**********         PARM                    PCurSet04                            248095A 256332
     C**********         PARM                    PSysVal05                            248095A 256332
     C**********         PARM                    PCurSet05                            248095A 256332
     C**********         PARM                    PSysVal06                            248095A 256332
     C**********         PARM                    PCurSet06                            248095A 256332
     C**********         PARM                    PSysVal07                            248095A 256332
     C**********         PARM                    PCurSet07                            248095A 256332
     C**********         PARM                    PSysVal08                            248095A 256332
     C**********         PARM                    PCurSet08                            248095A 256332
     C**********         PARM                    PSysVal09                            248095A 256332
     C**********         PARM                    PCurSet09                            248095A 256332
     C**********         PARM                    PSysVal10                            248095A 256332
     C**********         PARM                    PCurSet10                            248095A 256332
      **********                                                                      248095A 256332
     C*****PRtCd         IFEQ      *BLANKS                                            248095A 256332
     C*****PCurSet01     ANDNE     *BLANKS                                            248095A 256332
     C**********         MOVEL     PCurSet01     QMGR             48                  248095A 256332
     C**********         EXSR      MQCONNECT                                          248095A 256332
     C**********         Z-ADD     HANDLE        HCONN                                248095A 256332
     C**********         ENDIF                                                        248095A 256332
      **********                                                                      248095A 256332
      ** +--- Open MQSeries queue --------------+                               CAP004
      ** ¦                                      ¦                               CAP004
      ** ¦ For each message, the queue has to   ¦                               CAP004
      ** ¦ be opened.  The queue is closed and  ¦                               CAP004
      ** ¦ opened if the queue name has changed ¦                               CAP004
      ** ¦ since the previous call (except the  ¦                               CAP004
      ** ¦ first time through, when LastQueue   ¦                               CAP004
      ** ¦ will be blank).                      ¦                               CAP004
      ** ¦                                      ¦                               CAP004
      ** +--------------------------------------+                               CAP004
     C                   IF        Queue <> LastQueue                           CAP004
                                                                                CAP004
     C                   IF        LastQueue <> *blanks                         CAP004
     C                   EXSR      CloseQueue                                   CAP004
      *                                                                                       256332
     C*****QMGR*         IFNE      *BLANKS                                            256332 259935C
     C**********         EXSR      MQDISCONNECT                                       256332 259935C
     C**********         ENDIF                                                        256332 259935C
     C                   ENDIF                                                  CAP004
                                                                                CAP004
      *                                                                                       256332
      ** If a Queue Manager is specified on system value MQManager, connect                   256332
      ** to it and retain connection handle for other QMQM calls instead                      256332
      ** of using the default Queue Manager and connection                                    256332
      *                                                                                       256332
     C                   CALLB     'AOSVALR0'                                                 256332
     C                   PARM      *BLANKS       PRtCd             7                          256332
     C                   PARM      MQManager     PSysVal01                                    256332
     C                   PARM                    PCurSet01                                    256332
     C                   PARM                    PSysVal02                                    256332
     C                   PARM                    PCurSet02                                    256332
     C                   PARM                    PSysVal03                                    256332
     C                   PARM                    PCurSet03                                    256332
     C                   PARM                    PSysVal04                                    256332
     C                   PARM                    PCurSet04                                    256332
     C                   PARM                    PSysVal05                                    256332
     C                   PARM                    PCurSet05                                    256332
     C                   PARM                    PSysVal06                                    256332
     C                   PARM                    PCurSet06                                    256332
     C                   PARM                    PSysVal07                                    256332
     C                   PARM                    PCurSet07                                    256332
     C                   PARM                    PSysVal08                                    256332
     C                   PARM                    PCurSet08                                    256332
     C                   PARM                    PSysVal09                                    256332
     C                   PARM                    PCurSet09                                    256332
     C                   PARM                    PSysVal10                                    256332
     C                   PARM                    PCurSet10                                    256332
      *                                                                                       256332
     C     PRtCd         IFEQ      *BLANKS                                                    256332
     C     PCurSet01     ANDNE     *BLANKS                                                    256332
     C                   MOVEL     PCurSet01     QMGR             48                          256332
     C                   EXSR      MQCONNECT                                                  256332
     C                   Z-ADD     HANDLE        HCONN                                        256332
     C                   ENDIF                                                                256332
      *                                                                                       256332
     C                   EXSR      OpenQueue
     C                   ENDIF                                                  CAP004
 
 
      ** +--- Set the length of the message ----+
      ** ¦                                      ¦
      ** ¦ The length of the message is         ¦
      ** ¦ calculated so that unnecessary blank ¦
      ** ¦ bytes are not included.  This is     ¦
      ** ¦ only really needed for 'SHUTDOWN',   ¦
      ** ¦ or other ad hoc messages.  If        ¦
      ** ¦ the performance of messages being    ¦
      ** ¦ returned to the front office becomes ¦
      ** ¦ a problem, this section can be       ¦
      ** ¦ removed and all messages sent as     ¦
      ** ¦ 1102 bytes.                          ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
      ** Set the buffer length of the MQSeries to the length of the message
      ** field.
      ** (We can't use the %LEN function at present because it's not
      ** supported prior to V3R7M0; reinstate the following line when
      ** we can.)
     C***                EVAL      BUFLEN = %LEN(%TRIMR(MQString))
     C/COPY WNCPYSRC,ZAH00058
     C                   CALLB     'ZASTREND'
     C                   PARM                    ReturnCode
     C                   PARM                    FirstBlnkP
     C                   PARM                    MQString
     C                   PARM                    MQStrLen
 
      ** FirstBlnkP contains the position of the first blank aftter all the
      ** meaningful text.  The actual string length is one less than this.
     C                   EVAL      BUFLEN = FirstBlnkP - 1
     C/COPY WNCPYSRC,ZAH00059
                                                                                CAP006
      **  Set the message prority                                               CAP006
                                                                                CAP006
     C                   RESET                   MDPRI                          CAP006
     C                   Z-ADD     5             MDPRI                          CAP006
 
      ** +--- Send the message -----------------+
      ** ¦                                      ¦
      ** ¦ Call the MQSeries program, using the ¦
      ** ¦ handle returned when opening the     ¦
      ** ¦ queue.                               ¦
      ** ¦                                      ¦
      ** +--------------------------------------+
      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.  FMSTR is a named constant
      ** defined in CMQR; it contains 'MQSTR   '.  MQPUT is a named constant
      ** defined in CMQR; it contains 6.
     C                   EVAL      MDFMT = FMSTR
     C**********         EVAL      CID = MQPUT                                              MD041126
     C/COPY WNCPYSRC,ZAH00027
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HOBJ              9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM                    BUFLEN            9 0                      MD041126
     C**********         PARM                    MQString                                   MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( HCONN : HOBJ : MQMD : MQPMO :                     MD041126
     C                                    BUFLEN : %ADDR(MQString) :                        MD041126
     C                                    CCODE :  REASON )                                 MD041126
 
      ** If an error occured, put the MQSeries return code into this
      ** module's return code.
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   ENDIF
 
     ****+---*Close*MQSeries*queue*-------------+*******************************CAP004
     ****¦**************************************¦*******************************CAP004
     ****¦*For*each*message,*the*queue**********¦*******************************CAP004
     ****¦*has*to*be*closed.**This*ensures*that*¦*******************************CAP004
     ****¦*the*correct*queue*is*used*on*********¦*******************************CAP004
     ****¦*subsequent*calls*of*this*procedure.**¦*******************************CAP004
     ****¦**************************************¦*******************************CAP004
     ****+--------------------------------------+*******************************CAP004
     C*******************EXSR      CloseQueue                                   CAP004
      **********                                                                      248095A 256332
     C*****QMGR*         IFNE      *BLANKS                                            248095A 256332
     C**********         EXSR      MQDISCONNECT                                       248095A 256332
     C**********         ENDIF                                                        248095A 256332
 
     C                   RETURN
 
      *****************************************************************
      /EJECT                                                                                 248095A
      ****************************************************************                       248095A
      *                                                              *                       248095A
      *  Open connection to the queue manager                        *                       248095A
      *                                                              *                       248095A
      ****************************************************************                       248095A
     C     MQCONNECT     BEGSR                                                               248095A
                                                                                             248095A
      **  Attempt to CONNECT to the MQ Manager                                               248095A
      *              ~~~~~~~                                                                 248095A
     C**********         CALL      'QMQM'                                           248095A MD041126
     C**********         PARM      MQCONN        CID               9 0              248095A MD041126
     C**********         PARM                    QMGR                               248095A MD041126
     C**********         PARM      *ZERO         HANDLE            9 0              248095A MD041126
     C**********         PARM      *ZERO         OCODE             9 0              248095A MD041126
     C**********         PARM      *ZERO         REASON            9 0              248095A MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         HANDLE                                     MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCONN( QMGR  : HANDLE :                                 MD041126
     C                                     OCODE : REASON )                                 MD041126
                                                                                             248095A
      ** Error processing                                                                    248095A
     C     REASON        IFNE      RCNONE                                                    248095A
     C     REASON        ANDNE     RC2002                                                    248095A
                                                                                             248095A
     C                   EXSR      SetRetCode                                                248095A
      ** Shut down the program                                                               248095A
     C                   EXSR      *pssr                                                     248095A
                                                                                             248095A
     C                   ENDIF                                                               248095A
                                                                                             248095A
     C                   ENDSR                                                               248095A
      ****************************************************************                       248095A
      /EJECT                                                                                 248095A
      ****************************************************************                       248095A
      *                                                              *                       248095A
      *  Disconnect from the queue manager                           *                       248095A
      *                                                              *                       248095A
      ****************************************************************                       248095A
     C     MQDISCONNECT  BEGSR                                                               248095A
                                                                                             248095A
      **  Attempt to DISCONNECT from the MQ Manager                                          248095A
      *                                                                                      248095A
     C**********         CALL      'QMQM'                                           248095A MD041126
     C**********         PARM      MQDISC        CID               9 0              248095A MD041126
     C**********         PARM                    HCONN                              248095A MD041126
     C**********         PARM      *ZERO         OCODE                              248095A MD041126
     C**********         PARM      *ZERO         REASON                             248095A MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
                                                                                             248095A
      ** Error processing                                                                    248095A
     C     REASON        IFNE      RCNONE                                                    248095A
                                                                                             248095A
     C                   EXSR      SetRetCode                                                248095A
      ** Shut down the program                                                               248095A
     C                   EXSR      *pssr                                                     248095A
                                                                                             248095A
     C                   ENDIF                                                               248095A
                                                                                             248095A
     C                   ENDSR                                                               248095A
      ****************************************************************                       248095A
      /EJECT
      *****************************************************************
      *                                                               *
      * OpenQueue - Open the MQSeries queue                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: PGM/QMQM                                               *
      *                                                               *
      *****************************************************************
 
     C     OpenQueue     BEGSR
 
      ** Set up MQSeries data necessary to open a queue
 
      **  Open the target message queue for output (and fail if
      **  MQM is quiescing)
      **  Resulting queue handle is HOBJ
 
      ** Options are Output and Fail-if-quiescing
      ** OOOUT and OOFIQ are MQ named constants, declared in the CMQR
      ** include member.  OPTS is a program-described field declared in the
      ** parameter list below.  MQOPEN is an MQ named constant, also
      ** defined in CMQR, and CID is the call identifier, which defines what
      ** kind of call is being made.
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C**********         EVAL      CID = MQOPEN                                             MD041126
 
      ** ODON is a subfield of the MQOD data structure, which holds the
      ** name of the queue to be opened.  It is declared in the CMQODR
      ** include member.
     C                   EVAL      ODON = Queue
 
      ** The call returns the parameter HOBJ, an object handle, which
      ** uniquely identifies the queue.  It is used later by the "Put" call.
      ** It also returns OCODE, a completion code, which tells us whether
      ** or not the call was successful, and REASON, which gives details
      ** if there was a failure.
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS              9 0                      MD041126
     C**********         PARM                    HOBJ              9 0                      MD041126
     C**********         PARM                    OCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
     C                                     HOBJ : OCODE : REASON )                          MD041126
 
      ** Report reason, if any; stop if failed
      ** RCNONE is a named constant indicating no failure (it is zero).
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** CCFAIL is a named constant containing the value for OCODE
      ** indicating a failure to open the queue.
     C                   IF         OCODE = CCFAIL
     C                   EVAL      RetCodeIn = 'ErrOpnOutP'
     C                   EXSR      *pssr
     C                   END
                                                                                CAP004
      ** If all was successful, save the name of the queue for checking         CAP004
      ** on subsequent calls.                                                   CAP004
     C                   EVAL      LastQueue = Queue                            CAP004
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CloseQueue - Close the MQSeries queue                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: PGM/QMQM                                               *
      *                                                               *
      *****************************************************************
 
     C     CloseQueue    BEGSR
 
      ** Set up MQSeries data necessary to close a queue
 
      ** CONONE is a named constant (equal to zero) indicating that no
      ** options are to be used.  MQCLOS is a named constant indicating
      ** that the queue is to be closed.  Both are defined in CMQR.
     C                   EVAL      OPTS = CONONE
     C**********         EVAL      CID = MQCLOS                                             MD041126
 
      ** The call returns CCODE, a completion code, which tells us whether
      ** or not the call was successful, and REASON, which gives details
      ** if there was a failure.
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HOBJ              9 0                      MD041126
     C**********         PARM                    OPTS              9 0                      MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( HCONN : HOBJ : OPTS :                           MD041126
     C                                      CCODE : REASON )                                MD041126
 
      ** Report reason, if any; stop if failed
      ** RCNONE is a named constant indicating no failure (it is zero).
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetRetCode - Set the module return code                       *
      *                                                               *
      * Called by: Main, OpenQueue                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SetRetCode    BEGSR
 
      ** First move the (numeric) reason code into a 4-alpha field; then
      ** put it into the rightmost four bytes of a 6-alpha field which
      ** begins with 'RC'; lastly concatenate it with 'Err' for the return
      ** code
     C                   MOVE      REASON        RCode4A
     C                   MOVE      RCode4A       RCode6A
     C                   EVAL      RetCodeIn = 'Err' + RCode6A
 
     C                   ENDSR
 
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
 
     C     *INZSR        BEGSR
 
     C******entry********PLIST                                                  CAP006
      ***Return*code*(10A, returned from this module to caller)                 CAP006
     C*******************PARM                    RetCodeIn                      CAP006
      ***Queue*to*send*message to (20A, received from caller)                   CAP006
     C*******************PARM                    Queue                          CAP006
      ***String*containing message to send (1102A, received from caller)        CAP006
     C*******************PARM                    MQString                       CAP006
     C     *entry        PLIST                                                  CAP006
      ** Return code (10A, returned from this module to caller)                 CAP006
     C                   PARM                    RetCodeIn                      CAP006
      ** Queue to send message to (48A = maximumn, received from caller)        CAP006
     C                   PARM                    Queue                          CAP006
     C/COPY WNCPYSRC,ZAH00060
      ** String containing message to send (1102A, received from caller)        CAP006
     C                   PARM                    MQString                       CAP006
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
 
      ** Set the buffer length of the MQSeries to the length of the message
      ** field.
      ** (We can't use the %LEN function at present because it's not
      ** supported prior to V3R7M0; reinstate the following line when
      ** we can.)
     C***                EVAL      BUFLEN = %LEN(MQString)
     C/COPY WNCPYSRC,ZAH00061
     C                   EVAL      BUFLEN = 1102
 
     C/COPY WNCPYSRC,ZAH00028
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001