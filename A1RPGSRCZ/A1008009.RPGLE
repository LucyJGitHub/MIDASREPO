000100000000     H DEBUG
000200000000      *****************************************************************
000300000000/*STD *  RPGBASEMOD                                                   *
000400000000/*EXI *  TEXT('Midas FN Repn. Send a msgs to an API MQ queue')        *
000500000000      *****************************************************************
000600000000      *                                                               *
000700000000      *  Meridian DBA Replication                                     *
000800000000      *                                                               *
000900000000      *  A1008009  - Midas FN Repn. Send a msgs to an API MQ queue    *
001000000000      *                                                               *
001100000000      *  Function:  This module:                                      *
001200000000      *             - reads messages from a Transmission queue        *
001300000000      *             - determines if additional processing is needed   *
001400000000      *             - calls the specified program if necessary        *
001500000000      *             - forwards the message to the queue if not        *
001600000000      *                                                               *
001700000000      *  Calls by:  A1008002 , A1008008                               *
001900000000      *                                                               *
002000000000      *  (c) Finastra International Limited 2021                      *
002100000000      *                                                               *
002200000000      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
002500000000      *                                                               *
002600000000      *---------------------------------------------------------------*
002700000000      *                                                               *
002701000000      *  BA1008 - Replication of Trades to consolidated branches      *
003100000000      *                                                               *
003200000000      *****************************************************************
003300000000      *
003400000000      ** MQSeries includes
003500000000      ** -----------------
003600000000      *
003700000000      ** MQI named constants
003800000000     D/COPY QMQM/QRPGLESRC,CMQR
003900000000      ** Object Descriptor
004000000000     D MQOD            DS
004100000000     D/COPY QMQM/QRPGLESRC,CMQODR
004200000000      ** Message Descriptor
004300000000     D MQMD            DS
004400000000     D/COPY QMQM/QRPGLESRC,CMQMDR
004500000000      ** Put message options
004600000000     D MQPMO           DS
004700000000     D/COPY QMQM/QRPGLESRC,CMQPMOR
004800000000      *
004900000000      ** Other includes
005000000000      ** --------------
005100000000
005200000000      ** The following /COPY contains the layout of the Meridian header as
005300000000      ** a data structure
005500000000     C/COPY RPCPYSRC,MDN_HD_DS
005600000000
005700000000      ** The following /COPY contains various standard declares
005900000000     C/COPY RPCPYSRC,STD_DCL
006000000000
006100000000      ** Declared variables
006200000000      ** ------------------
006300000000
006400000000      ** Parameters
006500000000      **   Target queue
006600000000     D*TgtQueue        S                   LIKE(MQSQueue)
006700000000
006800000000      ** Parameters for the QMQM calls.
006900000000     D CID             S              9P 0
007000000000     D HCONN           S              9P 0
007100000000     D HOBJ            S              9P 0
007200000000     D BUFLEN          S              9P 0
007300000000     D CCODE           S              9P 0
007400000000     D REASON          S              9P 0
007500000000     D OCODE           S              9P 0
007600000000     D OPTS            S              9P 0
007700000000
007800000000      ** 4-alpha and 6-alpha fields for the MQ error code
007900000000     D RCode4A         S              4A
008000000000     D RCode6A         S              6A   INZ('RC    ')
008100000000
008200000000      ** Lengths of DS etc
008300000000     D ApnHeadLen      S              9P 0
008400000000     D* Make DataLen field compatible with called routine
008500000000     D DataLen         S              5P 0
008600000000
008700000000      ** Data to be sent
008800000000     D DataOut         S           8000A
008900000000
009000000000      ** Copy of input Transaction Data field
009100000000      **  - 4096 long to be compatible with called routine
009200000000     D TrnDta          S           8000A
009300000000
009400000000      ** Length of input Transaction Data field
009500000000     D TransDtaLn      S              5P 0 INZ(8000)
009600000000
009700000000      /EJECT
009800000000     C     Start         TAG
009900000000      ** Note: the above tag is only there to force the first comments in
010000000000      ** the C-specs to appear after the D- or I-specs in compiled listings.
010100000000
010200000000
010300000000      ** Open MQSeries Transmission queue that is to be read
010400000000     C                   EXSR      OpenQueue
010500000000
010600000000      ** Set the length of the data in the message ...
010700000000      * Remove use of %len as this is not supported below V3R7
010800000000     C                   EVAL      TrnDta     = ApData
011000000000     C                   CALLB     'A1008010'
011100000000     C                   PARM                    ReturnCode
011200000000     C                   PARM                    DataLen
011300000000     C                   PARM                    TrnDta
011400000000     C                   PARM                    TransDtaLn
011500000000      * DataLen now contains the position of the first blank after all
011600000000      *  text, reduce this by 1 for the text length
011700000000     C                   EVAL      DataLen = DataLen -1
011800000000
011900000000      ** ... and add the Merdidian Header length to get the buffer length
012000000000     C                   EVAL      BufLen = ApnHeadLen + DataLen
012100000000
012200000000      ** Set up the data to be sent
012300000000     C                   EVAL      DataOut = ApnHeadDS + ApData
012400000000
012500000000      ** Send the message
012600000000     C                   EVAL      MDFMT = FMSTR
012700000000     C                   EVAL      CID = MQPUT
012800000000
012900000000     C                   IF        CommitCtl = 'Y'
013000000000      ** If requested, specify that syncpointing is required
013100000000     C                   Z-ADD     PMSYP         PMOPT
013200000000     C                   ENDIF
013300000000
013400000000     C                   CALL      'QMQM'
013500000000     C                   PARM                    CID
013600000000     C                   PARM                    HCONN
013700000000     C                   PARM                    HOBJ
013800000000     C                   PARM                    MQMD
013900000000     C                   PARM                    MQPMO
014000000000     C                   PARM                    BUFLEN
014100000000     C                   PARM                    DataOut
014200000000     C                   PARM                    CCODE
014300000000     C                   PARM                    REASON
014400000000
014500000000      ** If an error occured, put the MQSeries return code into this
014600000000      ** module's return code.
014700000000     C                   IF        REASON <> RCNONE
014800000000     C                   EXSR      SetRetCode
014900000000     C                   ENDIF
015000000000
015100000000     C                   EXSR      CloseQueue
015200000000
015300000000     C                   RETURN
015400000000
015500000000      *****************************************************************
015600000000      /EJECT
015700000000      *****************************************************************
015800000000      *                                                               *
015900000000      * OpenQueue - Open the MQSeries queue                           *
016000000000      *                                                               *
016100000000      *****************************************************************
016200000000
016300000000     C     OpenQueue     BEGSR
016400000000      *
016500000000      ** Set up MQSeries data necessary to open a queue
016600000000      ** Open the target message queue for output (and fail if
016700000000      ** MQM is quiescing)
016800000000      ** Resulting queue handle is HOBJ
016900000000      ** Options are Output and Fail-if-quiescing
017000000000      ** OOOUT and OOFIQ are MQ named constants, declared in the CMQR
017100000000      ** include member.  OPTS is a program-described field declared in the
017200000000      ** parameter list below.  MQOPEN is an MQ named constant, also
017300000000      ** defined in CMQR, and CID is the call identifier, which defines what
017400000000      ** kind of call is being made.
017500000000     C                   EVAL      OPTS = OOOUT + OOFIQ
017600000000     C                   EVAL      CID = MQOPEN
017700000000
017800000000      ** ODON is a subfield of the MQOD data structure, which holds the
017900000000      ** name of the queue to be opened.  It is declared in the CMQODR
018000000000      ** include member.
018100000000     C                   EVAL      ODON = TgtQueue
018200000000
018300000000      ** The call returns the parameter HOBJ, an object handle, which
018400000000      ** uniquely identifies the queue.  It is used later by the "Put" call.
018500000000      ** It also returns OCODE, a completion code, which tells us whether
018600000000      ** or not the call was successful, and REASON, which gives details
018700000000      ** if there was a failure.
018800000000     C                   CALL      'QMQM'
018900000000     C                   PARM                    CID
019000000000     C                   PARM                    HCONN
019100000000     C                   PARM                    MQOD
019200000000     C                   PARM                    OPTS
019300000000     C                   PARM                    HOBJ
019400000000     C                   PARM                    OCODE
019500000000     C                   PARM                    REASON
019600000000
019700000000      ** Report reason, if any; stop if failed
019800000000      ** RCNONE is a named constant indicating no failure (it is zero).
019900000000     C                   IF        REASON <> RCNONE
020000000000     C                   EXSR      SetRetCode
020100000000     C                   EXSR      *pssr
020200000000     C                   ENDIF
020300000000
020400000000      ** CCFAIL is a named constant containing the value for OCODE
020500000000      ** indicating a failure to open the queue.
020600000000     C                   IF         OCODE = CCFAIL
020700000000     C                   EVAL      ReturnCode = 'ErrOpnOutP'
020800000000     C                   EXSR      *pssr
020900000000     C                   END
021000000000
021100000000     C                   ENDSR
021200000000
021300000000      *****************************************************************
021400000000      /EJECT
021500000000      ****************************************************************
021600000000      *                                                              *
021700000000      *  CloseQueue - Close the MQSeries queue                       *
021800000000      *                                                              *
021900000000      ****************************************************************
022000000000     C     CloseQueue    BEGSR
022100000000      *
022200000000      ** Close options: NONE
022300000000      *
022400000000     C                   Z-ADD     CONONE        OPTS
022500000000      *
022600000000      ** Close queue
022700000000      *
022800000000     C                   Z-ADD     MQCLOS        CID
022900000000     C                   CALL      'QMQM'
023000000000     C                   PARM                    CID               9 0
023100000000     C                   PARM                    HCONN             9 0
023200000000     C                   PARM                    HOBJ              9 0
023300000000     C                   PARM                    OPTS              9 0
023400000000     C                   PARM                    CCODE             9 0
023500000000     C                   PARM                    REASON            9 0
023600000000
023700000000      ** Error processing
023800000000     C     REASON        IFNE      RCNONE
023900000000     C                   EXSR      SetRetCode
024000000000     C                   EXSR      *pssr
024100000000
024200000000     C                   ENDIF
024300000000      *
024400000000     C                   ENDSR
024500000000      ********************************************************************
024600000000      /EJECT
024700000000      *****************************************************************
024800000000      *                                                               *
024900000000      * SetRetCode - Set the module return code                       *
025000000000      *                                                               *
025100000000      * Called by: Main, OpenQueue, CloseQueue                        *
025200000000      *                                                               *
025300000000      * Calls: None                                                   *
025400000000      *                                                               *
025500000000      *****************************************************************
025600000000
025700000000     C     SetRetCode    BEGSR
025800000000
025900000000      ** First move the (numeric) reason code into a 4-alpha field; then
026000000000      ** put it into the rightmost four bytes of a 6-alpha field which
026100000000      ** begins with 'RC'; lastly concatenate it with 'Err' for the return
026200000000      ** code
026300000000     C                   MOVE      REASON        RCode4A
026400000000     C                   MOVE      RCode4A       RCode6A
026500000000     C                   EVAL      ReturnCode = 'Err' + RCode6A
026600000000
026700000000     C                   ENDSR
026800000000
026900000000      /EJECT
027000000000      ********************************************************************
027100000000      **--------------------------------------------------------------------------------------------
027200000000      ** The following /COPY contains the standard program status
027300000000      ** subroutine.
027400000000     C/COPY RPCPYSRC,PSSR_ILE
027500000000      **--------------------------------------------------------------------------------------------
027600000000      *****************************************************************
027700000000      /EJECT
027800000000      *****************************************************************
027900000000      *                                                               *
028000000000      * *inzsr - Program Initialisation routine                       *
028100000000      *                                                               *
028200000000      *****************************************************************
028300000000
028400000000     C     *inzsr        BEGSR
028500000000
028600000000     C     *ENTRY        PLIST
028700000000     C                   PARM                    TgtQueue         48
028800000000     C                   PARM                    ApnHeadDS       200
028900000000     C                   PARM                    ApData         8000
029000000000     C                   PARM                    CommitCtl         1
029100000000      ** ReturnCode declared as 10A in /COPY STD_DCL
029300000000     C                   PARM                    ReturnCode
029600000000
029700000000      ** Determine length of the Meridian header
029800000000      * Remove use of %len as this is not supported below V3R7
029900000000     C                   EVAL      ApnHeadLen = 200
030000000000
030100000000     C                   ENDSR
030200000000
030300000000      ********************************************************************
030400000000      /EJECT
030500000000      ********************************************************************
