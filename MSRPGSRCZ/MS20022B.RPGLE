000100220214     H DEBUG
000200220214     H COPYRIGHT('(c) Finastra International Limited 2021')
000300220214      *****************************************************************
000400220214/*STD *  RPGBASEBND                                                   *
000500220214/*EXI *  ALWNULL(*USRCTL)                                             *
000600220214/*EXI *  TEXT('Midas MS Midas/SWIFT MX Meridian communication')       *
000700220214      *****************************************************************
000800220214      *                                                               *
000900220214      *  Midas - Midas SWIFT                                          *
001000220214      *                                                               *
001100220214      *  MS20022B - Midas/SWIFT MX Meridian communications            *
001200220214      *                                                               *
001300220214      *  Function:  This program effects communication between Midas  *
001400220214      *             and Meridian using MQSeries Queues                *
001500220214      *                                                               *
001600220214      *  Called By: MSC200221B                                        *
001700220214      *                                                               *
001800220214      *  (c) Finastra International Limited 2021                      *
001900220214      *                                                               *
002000220214      *  Last Amend No. CSW122  *CREATE    Date 04Oct21               *
002100220214      *                                                               *
002200220214      *---------------------------------------------------------------*
002300220214      *                                                               *
002400220214      *  CSW122 - SWIFT ISO 20022 Changes                             *
002500220214      *                                                               *
002600220214      *****************************************************************
002700220214      *                                                               *
002800220214      *  Notes:                                                       *
002900220214      *  ------                                                       *
003000220214      *                                                               *
003100220214      *    o  This program uses the QMQM API to exchange messages,    *
003200220214      *       ACKs and NAKs with Meridian MQ series queues.           *
003300220214      *                                                               *
003400220214      *****************************************************************
003500220214      /EJECT
003600220214     FMSMCIDL0  UF   E           K disk    infsr(srfile)
003700220214     FMSMXISOPD O    E           K disk    infsr(srfile)
003800220214     F                                     commit
003900220214     FMSIXISOPD O    E           K disk    infsr(srfile)
004000220214     F                                     commit
004100220214     FMS20022AU O    E             printer infsr(srfile)
004200220214     F                                     oflind(*in66)
004300220214     F                                     usropn
004400220214      /EJECT
004500220214      /COPY MSCPYSRC,SRERRD
004600220214
004700220214      ** Constants to hold input parameter for AOSVALR0.
004800220214
004900220214     D MQManager       C                   Const('MQQueueMgr')
005000220214
005100220214      ** Array containing Copyright statement
005200220214
005300220214     D cpy@            S             80    dim(1) ctdata perrcd(1)
005400220214
005500220214      ** Array containing the recognized tags
005600220214
005700220214     D  mxTags         S            100A   dim(8) ctdata perrcd(1)
005800220214
005900220214      ** Constant for tag array size
006000220214      ** If a new element on the mxTags array is added, this must also be updated
006100220214
006200220214     D  arraySize      C                   const(8)
006300220214
006400220214     D  cancelMsg      S             20A   varying
006500220214
006600220214      ** Output string
006700220214
006800220214     D outBytes        S          12000A   varying
006900220214
007000220214      ** Field for record writing
007100220214
007200220214     D buffer          S          12000A
007300220214
007400220214      ** Fields for tag manipulation and position marking
007500220214
007600220214     D  tagName        S          12000A   varying
007700220214     D  tagVal         S          12000A   varying
007800220214     D  tag            S          12000A   varying
007900220214     D  msgEnd         S              2A
008000220214     D  tagLen         S              5S 0
008100220214     D  tagF           S              5S 0
008200220214     D  dataLen        S              5S 0
008300220214     D  valueLen       S              5S 0
008400220214     D  pNL            S              5S 0 inz(0)
008500220214     D  pOL            S              5S 0 inz(1)
008600220214     D  pEq            S              5S 0 inz(0)
008700220214
008800220214      ** MsgId field for cancellation messages
008900220214
009000220214     D  msgIdCancel    S             36A
009100220214
009200220214      ** Tag array index controller
009300220214
009400220214     D  x              S              1S 0 inz(1)
009500220214
009600220214      ** Write records buffer controller
009700220214
009800220214     D  y              S              5S 0 inz(1)
009900220214
010000220214      ** Escape sequence data structure
010100220214
010200220214     D                 DS
010300220214     D  W@CRLF                 1      2
010400220214     D  W@CR                   1      1    INZ(x'0d')
010500220214     D  W@LF                   2      2    INZ(x'25')
010600220214
010700220214      ** Message Management data area
010800220214
010900220214     D medta         E DS                  extname(MEDTA)
011000220214
011100220214      ** Midas/SWIFT Direct Link status data area
011200220214
011300220214     D  msstat       E DS                  extname(MSSTAT)
011400220214     D  ren@zz53     E                     extfld(ZZ053)
011500220214
011600220214      ** Midas Message Management status data area
011700220214     D  mestat       E DS                  extname(MESTAT) dtaara(MESTAT)
011800220214
011900220214      ** SDSTAT for system prefix
012000220214
012100220214     D  sdstat       E DS                  extname(SDSTAT)
012200220214     D  ren@mode     E                     extfld(MODE)
012300220214
012400220214      ** Data structure for receiving message from queue
012500220214
012600220214     D                 DS
012700220214     D  q@dqm                  1  12050
012800220214     D  q@sndref               1     50
012900220214     D  q@msgbuf              51  12050
013000220214
013100220214      ** Data queue entry (control)
013200220214
013300220214     D                 DS
013400220214     D  q@dqc                  1     50
013500220214     D  q@prompt               1     50
013600220214
013700220214      ** Working field to receive data from queue
013800220214
013900220214     Dp@msgbuf         S          12000A   varying
014000220214
014100220214      **  Declare MQI structures needed
014200220214      ** MQI Constants
014300220214
014400220214     D/COPY QMQM/QRPGLESRC,CMQR
014500220214
014600220214      ** Object Descriptor
014700220214
014800220214     D MQOD            DS
014900220214     D/COPY QMQM/QRPGLESRC,CMQODR
015000220214
015100220214      ** Message Descriptor
015200220214
015300220214     D MQMD            DS
015400220214     D/COPY QMQM/QRPGLESRC,CMQMDR
015500220214
015600220214      ** Get message options
015700220214
015800220214     D MQGMO           DS
015900220214     D/COPY QMQM/QRPGLESRC,CMQGMOR
016000220214
016100220214      ** Put message options
016200220214
016300220214     D MQPMO           DS
016400220214     D/COPY QMQM/QRPGLESRC,CMQPMOR
016500220214
016600220214      ** The include below brings in the return code structure that
016700220214      ** is used in calls to OS/400 APIs.
016800220214
016900220214     D/COPY QSYSINC/QRPGLESRC,QUSEC
017000220214      /EJECT
017100220214
017200220214      *****************************************************************
017300220214      *  Index to Subroutines                                         *
017400220214      *                                                               *
017500220214      *  sr_init       : Initialise program                           *
017600220214      *  sr_trace      : Trace                                        *
017700220214      *  sr_in         : Get incoming messages and write to database  *
017800220214      *  sr_out        : Format and transmit outgoing messages        *
017900220214      *  sr_term       : Program termination                          *
018000220214      *  sr_open       : Open MQ series queue                         *
018100220214      *  sr_close      : Close MQ series queue                        *
018200220214      *  sr_disconn    : Disconnects from MQ series queue             *
018300220214      *  sr_classify   : Classifies the value into the db columns     *
018400220214      *  sr_writerec   : Writes message to the database               *
018500220214      *  sr_datacheck  : Extracts values from the key-value pairs     *
018600220214      *  *PSSR         : Standard program exception error routine     *
018700220214      *****************************************************************
018800220214      /EJECT
018900220214
019000220214      ** Set up copyright parameter
019100220214
019200220214     C                   movea     cpy@          cpy2@            80
019300220214      *
019400220214     C     *entry        plist
019500220214     C                   parm                    p@mcid           26
019600220214     C                   parm                    p@dtqm           10
019700220214     C                   parm                    p@dtqc           10
019800220214     C                   parm                    p@io              1
019900220214     C                   parm                    p@eod             4
020000220214
020100220214      ** Push routine
020200220214
020300220214     C                   z-add     1             Q
020400220214     C                   movel     'mainline'    @STK(Q)
020500220214
020600220214      ** Perform initial process
020700220214
020800220214     C                   exsr      sr_init
020900220214
021000220214      ** If no error on opening MQSeries queue
021100220214
021200220214     C                   if         w@MQOpenErr = 'N'
021300220214     C                              AND w@MQConnErr = 'N'
021400220214
021500220214      ** execute process for incoming or outgoing messages
021600220214
021700220214     C     p@io          ifeq      'I'
021800220214     C                   exsr      sr_in
021900220214     C                   else
022000220214     C                   exsr      sr_out
022100220214     C                   endif
022200220214      *
022300220214     C                   endif
022400220214
022500220214      ** Program termination
022600220214
022700220214     C                   exsr      sr_term
022800220214      *
022900220214     C                   seton                                        LR
023000220214      /EJECT
023100220214
023200220214      **********************************************************************
023300220214      * sr_trace       : Trace (if requested by user).                     *
023400220214      * --------                                                           *
023500220214      *                                                                    *
023600220214      * Called by      : sr_init, sr_in, sr_close, sr_disconn              *
023700220214      *                                                                    *
023800220214      * Calls          :                                                   *
023900220214      *                                                                    *
024000220214      **********************************************************************
024100220214
024200220214     C     sr_trace      begsr
024300220214
024400220214      ** Push subroutine
024500220214
024600220214     C                   add       1             Q
024700220214     C                   movel     'sr_trace  '  @STK(Q)
024800220214
024900220214      ** Check whether trace requested. If it is, write trace information
025000220214      ** to report.
025100220214
025200220214     C                   in        msstat
025300220214     C     TRACF         ifeq      'T'
025400220214
025500220214      ** If spool file not already open, open it now.
025600220214
025700220214     C     w@prtopn      ifne      'Y'
025800220214     C                   movel     'Y'           w@prtopn          1
025900220214     C                   OPEN      MS20022AU
026000220214     C                   WRITE     MS20022F1
026100220214     C                   endif
026200220214
026300220214      ** Check for overflow and rewrite headings if necessary.
026400220214
026500220214     C     *in66         ifeq      *on
026600220214     C                   movel     *off          *in66
026700220214     C                   WRITE     MS20022F1
026800220214     C                   endif
026900220214
027000220214      ** Set up standard details and write to report
027100220214
027200220214     C                   time                    PR@TI
027300220214     C     REASON        ifne      0
027400220214     C                   movel(p)  REASON        PR@RC
027500220214     C                   else
027600220214     C                   clear                   PR@RC
027700220214     C                   endif
027800220214     C                   WRITE     MS20022T1
027900220214
028000220214      ** If data in buffer, write this too
028100220214
028200220214     C     t@tdat        ifne      *blank
028300220214     C                   movel(p)  t@tdat        PR@DT
028400220214     C                   WRITE     MS20022T2
028500220214     C                   clear                   t@tdat          100
028600220214     C                   endif
028700220214      *
028800220214     C                   endif
028900220214
029000220214      ** Pop subroutine
029100220214
029200220214     C                   clear                   @STK(Q)
029300220214     C                   sub       1             Q
029400220214     C                   endsr
029500220214      /EJECT
029600220214
029700220214      **********************************************************************
029800220214      * sr_out         : Format and transmit outgoing messages             *
029900220214      *                  This is added for future expansion but has no     *
030000220214      *                  use for now                                       *
030100220214      * ------                                                             *
030200220214      *                                                                    *
030300220214      * Called by      : Mainline                                          *
030400220214      *                                                                    *
030500220214      * Calls          :                                                   *
030600220214      *                                                                    *
030700220214      **********************************************************************
030800220214
030900220214     C     sr_out        begsr
031000220214
031100220214      ** Push subroutine
031200220214
031300220214     C                   add       1             Q
031400220214     C                   movel     'sr_out'      @STK(Q)
031500220214
031600220214      ** Pop subroutine
031700220214
031800220214     C                   clear                   @STK(Q)
031900220214     C                   sub       1             Q
032000220214     C                   endsr
032100220214      /EJECT
032200220214
032300220214      **********************************************************************
032400220214      * sr_in          : Get incoming messages and write to database       *
032500220214      * -----                                                              *
032600220214      *                                                                    *
032700220214      * Called by      : Mainline                                          *
032800220214      *                                                                    *
032900220214      * Calls          : QMQM                                              *
033000220214      *                : sr_trace                                          *
033100220214      *                : sr_datacheck                                      *
033200220214      *                : MEC20022A                                         *
033300220214      *                                                                    *
033400220214      **********************************************************************
033500220214
033600220214     C     sr_in         begsr
033700220214
033800220214      ** Push subroutine
033900220214
034000220214     C                   add       1             Q
034100220214     C                   movel     'sr_in'       @STK(Q)
034200220214
034300220214      ** Access incoming data until termination requested by user,
034400220214      ** or API error.
034500220214
034600220214     C     *in01         doueq     *on
034700220214     C     REASON        orne      RCNONE
034800220214     C     REASON        andne     RC2033
034900220214
035000220214      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
035100220214      ** Note: the last of these options means that a message longer than
035200220214      ** the buffer length defined in this module (currently 1500 bytes)
035300220214      ** will be read and removed from the queue.  Any data in the message
035400220214      ** after the 1500th byte will be lost.
035500220214
035600220214     C                   Z-ADD     GMWT          GMOPT
035700220214     C                   ADD       GMCONV        GMOPT
035800220214     C                   ADD       GMATM         GMOPT
035900220214
036000220214      ** Set wait interval to 20 seconds
036100220214
036200220214     C                   Z-ADD     20000         GMWI
036300220214
036400220214      ** Perform get operation inside commitment control. Commitment
036500220214      ** boundary is after the message management file updates.
036600220214
036700220214     C                   ADD       GMSYP         GMOPT
036800220214
036900220214      ** MsgId and CorrelId are selectors cleared to ensure messages
037000220214      ** are processed in arrival/priority sequence
037100220214
037200220214     C                   MOVEL     MINONE        MDMID
037300220214
037400220214      ** Clear message buffer
037500220214
037600220214     C                   clear                   q@msgbuf
037700220214
037800220214      ** Get message
037900220214
038000220214     C                   Z-ADD     MQGET         CID
038100220214     C                   CALL      'QMQM'
038200220214     C                   PARM                    CID               9 0
038300220214     C                   PARM                    HCONN             9 0
038400220214     C                   PARM                    HIN               9 0
038500220214     C                   PARM                    MQMD
038600220214     C                   PARM                    MQGMO
038700220214     C                   PARM      12000         p@msglen          9 0
038800220214     C                   PARM                    q@msgbuf
038900220214     C                   PARM                    MESLEN            9 0
039000220214     C                   PARM                    CCODE             9 0
039100220214     C                   PARM                    REASON            9 0
039200220214
039300220214      ** Message starts after the API header block
039400220214
039500220214     C                   clear                   p@msgbuf
039600220214     C                   eval      p@msgbuf = q@msgbuf
039700220214
039800220214      ** Trace
039900220214
040000220214     C                   movel     '*GET   '     PR@FN
040100220214     C                   exsr      sr_trace
040200220214
040300220214      ** If receive message failed, indicate abnormal end
040400220214
040500220214     C     REASON        ifne      RCNONE
040600220214     C     REASON        andne     RC2033
040700220214     C                   movel     'Y'           w@abnormal
040800220214     C                   movel     'QMQM     '   w0file
040900220214     C                   movel     'MEM6001'     w0msgd
041000220214     C                   movel     'MIDAS  '     w0msgf
041100220214     C                   movel     'Rcv message' w0key
041200220214     C                   movel     REASON        w0reas
041300220214     C                   z-add     102           w0ernb
041400220214     C                   else
041500220214
041600220214      ** Else, if data received and no error
041700220214
041800220214     C     REASON        ifne      RC2033
041900220214      *
042000220214     C                   exsr      sr_datacheck
042100220214
042200220214      ** Prompt Incoming Message Management
042300220214
042400220214     C                   call      'MEC20022A'                          9090
042500220214     C                   parm      *BLANKS       p@rtcd            7
042600220214      **
042700220214     C                   endif
042800220214     C                   endif
042900220214
043000220214      ** Check whether termination has been requested
043100220214
043200220214     C                   shtdn                                        01
043300220214      *
043400220214     C                   enddo
043500220214
043600220214      ** Pop subroutine
043700220214
043800220214     C                   clear                   @STK(Q)
043900220214     C                   sub       1             Q
044000220214     C                   endsr
044100220214      /EJECT
044200220214
044300220214      **********************************************************************
044400220214      * sr_datacheck    : Extracts values from the key-value pairs         *
044500220214      * -------                                                            *
044600220214      *                                                                    *
044700220214      * Called by      : sr_in                                             *
044800220214      *                                                                    *
044900220214      * Calls          : sr_classify                                       *
045000220214      *                : sr_writerec                                       *
045100220214      *                                                                    *
045200220214      **********************************************************************
045300220214
045400220214     C     sr_datacheck  begsr
045500220214
045600220214      ** Push subroutine
045700220214
045800220214     C                   add       1             Q
045900220214     C                   movel     'sr_datacheck'@STK(Q)
046000220214
046100220214      ** Initialize  fields
046200220214
046300220214     C                   eval      outBytes = *BLANKS
046400220214     C                   z-add     0             pNL
046500220214     C                   z-add     1             pOL
046600220214     C                   z-add     0             pEq
046700220214     C                   z-add     0             tagLen
046800220214     C                   z-add     0             dataLen
046900220214     C                   z-add     0             valueLen
047000220214     C                   clear                   MSMXISD0
047100220214     C                   clear                   MSIXISD0
047200220214
047300220214      ** Copy received data to the output field
047400220214
047500220214     C                   eval      outBytes = %trim(p@msgbuf)
047600220214
047700220214      ** Get the length of the data
047800220214
047900220214     C                   eval      dataLen = %len(outBytes)
048000220214
048100220214      ** Check for CRLF on end of message
048200220214
048300220214     C                   eval      msgEnd = %subst(outBytes:dataLen-1:2)
048400220214
048500220214      ** If there is no CRLF on end of message, add them
048600220214
048700220214     C                   if        msgEnd <> W@CRLF
048800220214     C                   eval      outBytes = outBytes + W@CRLF
048900220214
049000220214      ** Update the data length
049100220214
049200220214     C                   eval      dataLen = %len(outBytes)
049300220214     C                   endif
049400220214
049500220214      ** Get the position of the first new line indicator
049600220214
049700220214     C                   eval      pNL = %scan(W@CRLF:outBytes)
049800220214
049900220214      ** Loop through the data until the end
050000220214
050100220214     C                   dow       pNL <> dataLen
050200220214
050300220214      ** Extract tag data
050400220214
050500220214     C                   eval      pEq = %scan('=':outBytes:pOL)
050600220214     C                   eval      valueLen = pNL - pEq - 1
050700220214     C                   eval      tagVal = %subst(outBytes:pEq+1:valueLen)
050800220214
050900220214      ** Extract tag name
051000220214
051100220214     C                   eval      tagLen = pEq - pOL
051200220214     C                   eval      tagName = %subst(outBytes:pOL:tagLen)
051300220214
051400220214      ** Classify data in preparation for writing to the records
051500220214
051600220214     C                   exsr      sr_classify
051700220214
051800220214      ** Save the current position of the new line marker as reference
051900220214
052000220214     C                   eval      pOL = pNL
052100220214
052200220214      ** Check again for next line marker starting from the position
052300220214      ** immediately to the right of the last known marker
052400220214
052500220214     C                   eval      pNL = %scan(W@CRLF:outBytes:pOL+1)
052600220214
052700220214      ** If there are no new line markers anymore, exit the loop
052800220214
052900220214     C                   if        pNL = 0
053000220214     C                   leave
053100220214     C                   endif
053200220214     C                   enddo
053300220214
053400220214      ** Check if message is a cancellation message prior to writing
053500220214
053600220214     C                   eval      cancelMsg = 'camt'+'.'+'056'+'.'+'001'+'.'
053700220214     C                              +'08'
053800220214     C                   if        MTPY = cancelMsg
053900220214     C                             or (UETR = *BLANKS and MXID = *BLANKS)
054000220214     C                   eval      MXID = %trim(msgIdCancel)
054100220214     C                   eval      IMXID = %trim(msgIdCancel)
054200220214     C                   endif
054300220214
054400220214      ** Write data on the records
054500220214
054600220214     C                   exsr      sr_writerec
054700220214
054800220214      ** Pop subroutine
054900220214
055000220214     C                   clear                   @STK(Q)
055100220214     C                   sub       1             Q
055200220214     C                   endsr
055300220214     C
055400220214      /EJECT
055500220214
055600220214      **********************************************************************
055700220214      * sr_writerec    : Writes message to the database                    *
055800220214      * -------                                                            *
055900220214      *                                                                    *
056000220214      * Called by      : sr_datacheck                                      *
056100220214      *                                                                    *
056200220214      * Calls          :                                                   *
056300220214      *                                                                    *
056400220214      **********************************************************************
056500220214
056600220214     C     sr_writerec   begsr
056700220214
056800220214      ** Push subroutine
056900220214
057000220214     C                   add       1             Q
057100220214     C                   movel     'sr_datacheck'@STK(Q)
057200220214
057300220214      ** Initialize working fields
057400220214
057500220214     C                   eval      y = 1
057600220214     C                   eval      buffer = outBytes
057700220214
057800220214      ** Start writing records in 256 char increments until the buffer has been exhausted
057900220214
058000220214     C                   EVAL      MXDTA = %SUBST(buffer:y:256)
058100220214     C                   DOW       MXDTA <> *BLANKS
058200220214     C                   WRITE     MSMXISD0
058300220214     C                   add       256           y
058400220214     C                   EVAL      MXDTA = %SUBST(buffer:y:256)
058500220214     C                   ENDDO
058600220214
058700220214      ** Write record on index file
058800220214
058900220214     C                   WRITE     MSIXISD0
059000220214
059100220214      ** Commit all messages both to the database and from the queues
059200220214
059300220214     C                   commit
059400220214
059500220214      ** Pop subroutine
059600220214
059700220214     C                   clear                   @STK(Q)
059800220214     C                   sub       1             Q
059900220214     C                   endsr
060000220214      /EJECT
060100220214
060200220214      **********************************************************************
060300220214      * sr_classify    : Classifies the value into the db columns          *
060400220214      * -------                                                            *
060500220214      *                                                                    *
060600220214      * Called by      : sr_datacheck                                      *
060700220214      *                                                                    *
060800220214      * Calls          :                                                   *
060900220214      *                                                                    *
061000220214      **********************************************************************
061100220214
061200220214     C     sr_classify   begsr
061300220214
061400220214      ** Push subroutine
061500220214
061600220214     C                   add       1             Q
061700220214     C                   movel     'sr_classify' @STK(Q)
061800220214
061900220214      ** Initialize fields
062000220214
062100220214     C                   z-add     1             x
062200220214     C                   z-add     0             tagF
062300220214
062400220214      ** Check if current tag has matches on tag array
062500220214
062600220214     C                   eval      tag = %trim(mxTags(x))
062700220214     C                   eval      tagF = %scan(tag:tagName)
062800220214     C                   dow       tagF = 0
062900220214     C                   eval      tag = %trim(mxTags(x))
063000220214     C                   eval      tagF = %scan(tag:tagName)
063100220214     C                   if        tagF = 0
063200220214     C                   eval      x = x + 1
063300220214     C                   endif
063400220214     C                   if        x > arraySize
063500220214     C                   leave
063600220214     C                   endif
063700220214     C                   enddo
063800220214
063900220214      ** If current tag is found on tag array, extract the data and store it on the db field
064000220214
064100220214     C                   if        tagF > 0
064200220214     C                   eval      tagVal = %subst(outBytes:pEq+1:pNL-pEq-1)
064300220214
064400220214      ** Begin data extraction
064500220214
064600220214     C                   select
064700220214
064800220214      ** Extract UETR
064900220214
065000220214     C                   when      mxTags(x) = 'PmtId_UETR'
065100220214     C                   eval      UETR = tagVal
065200220214     C                   eval      IUETR = tagVal
065300220214
065400220214      ** Extract Message Type
065500220214
065600220214     C                   when      mxTags(x) = 'MsgDefIdr'
065700220214     C                   eval      MTPY = tagVal
065800220214     C                   eval      IMTPY = tagVal
065900220214
066000220214      ** Extract Transaction Amount
066100220214
066200220214     C                   when      mxTags(x) = 'IntrBkSttlmAmt'
066300220214     C                   eval      AMTS = tagVal
066400220214
066500220214      ** Extract Transaction Currency
066600220214
066700220214     C                   when      mxTags(x) = 'IntrBkSttlmAmt_Ccy'
066800220214
066900220214      ** Extract Value Date
067000220214
067100220214     C                   when      mxTags(x) = 'IntrBkSttlmDt'
067200220214     C                   eval      SVDT = tagVal
067300220214
067400220214      ** Extract Message ID
067500220214
067600220214     C                   when      mxTags(x) = 'GrpHdr_MsgId'
067700220214     C                   eval      MXID = tagVal
067800220214     C                   eval      IMXID = tagVal
067900220214
068000220214      ** Extract Input Date
068100220214
068200220214     C                   when      mxTags(x) = 'GrpHdr_CreDtTm'
068300220214     C                   eval      MXIDE = tagVal
068400220214
068500220214      ** Extract MsgId for cancellation messages
068600220214
068700220214     C                   when      mxTags(x) = 'BizMsgIdr'
068800220214     C                   eval      msgIdCancel = tagVal
068900220214     C                   endsl
069000220214     C                   endif
069100220214
069200220214      ** Pop subroutine
069300220214
069400220214     C                   clear                   @STK(Q)
069500220214     C                   sub       1             Q
069600220214     C                   endsr
069700220214      /EJECT
069800220214
069900220214      **********************************************************************
070000220214      * sr_term        : Program termination                               *
070100220214      * -------                                                            *
070200220214      *                                                                    *
070300220214      * Called by      : Mainline                                          *
070400220214      *                                                                    *
070500220214      * Calls          : sr_close                                          *
070600220214      *                : sr_disconn                                        *
070700220214      *                                                                    *
070800220214      **********************************************************************
070900220214
071000220214     C     sr_term       begsr
071100220214
071200220214      ** Push subroutine
071300220214
071400220214     C                   add       1             Q
071500220214     C                   movel     'sr_term'     @STK(Q)
071600220214
071700220214      ** Shutdown compression server for transmission jobs if not
071800220214      ** already requested
071900220214
072000220214     C     p@io          ifeq      'O'
072100220214     C     w@srvr_trq    andeq     'N'
072200220214     C                   movel(p)  '*SHUTDOWN'   q@prompt
072300220214     C                   call      'QSNDDTAQ'    q@snddtaq
072400220214     C                   movel     'Y'           w@srvr_trq
072500220214     C                   endif
072600220214
072700220214      ** Close MQ series queue (if it was opened)
072800220214
072900220214     C     w@open        ifeq      'Y'
073000220214
073100220214     C                   exsr      sr_close
073200220214     C     w@connect     ifeq      'Y'
073300220214     C                   exsr      sr_disconn
073400220214     C                   endif
073500220214     C                   endif
073600220214
073700220214      ** Perform abnormal termination processing if required:
073800220214
073900220214     C     w@abnormal    ifeq      'Y'
074000220214
074100220214      **  - print error report
074200220214
074300220214     C     w@prtopn      ifne      'Y'
074400220214     C                   open      MS20022AU
074500220214     C                   movel     'Y'           w@prtopn
074600220214     C                   endif
074700220214     C                   write     MS20022F1
074800220214     C                   write     MS20022F2
074900220214     C                   write     MS20022F3
075000220214     C                   close     MS20022AU
075100220214
075200220214      **  - send error message and terminate abnormally
075300220214
075400220214     C                   exsr      srerr
075500220214      *
075600220214     C                   endif
075700220214
075800220214      ** Pop subroutine
075900220214
076000220214     C                   clear                   @STK(Q)
076100220214     C                   sub       1             Q
076200220214     C                   endsr
076300220214      /EJECT
076400220214
076500220214      **********************************************************************
076600220214      * sr_init        : Initialise program                                *
076700220214      * -------                                                            *
076800220214      *                                                                    *
076900220214      * Called by      : Mainline                                          *
077000220214      *                                                                    *
077100220214      * Calls          : sr_open                                           *
077200220214      *                                                                    *
077300220214      **********************************************************************
077400220214
077500220214     C     sr_init       begsr
077600220214
077700220214      ** Push subroutine
077800220214
077900220214     C                   add       1             Q
078000220214     C                   movel     'sr_init'     @STK(Q)
078100220214
078200220214      ** Define data areas
078300220214
078400220214     C     *dtaara       define                  msstat
078500220214     C     *dtaara       define                  sdstat
078600220214
078700220214      ** Define parameter lists
078800220214
078900220214     C     q@rcvdtaq     plist
079000220214     C                   parm      p@dtqm        q@dtaq           10
079100220214     C                   parm      '*LIBL'       q@libl           10
079200220214     C                   parm      12050         q@length          5 0
079300220214     C                   parm                    q@dqm
079400220214     C                   parm      -1            q@wait            5 0
079500220214      *
079600220214     C     q@snddtaq     plist
079700220214     C                   parm      p@dtqc        q@dtaq
079800220214     C                   parm      '*LIBL'       q@libl
079900220214     C                   parm      50            q@length          5 0
080000220214     C                   parm                    q@dqc
080100220214
080200220214      ** Access SDSTAT for system prefix
080300220214
080400220214     C                   in        sdstat
080500220214     C                   movel     LIBR          q@skey            4
080600220214
080700220214      ** Get communication details from file
080800220214
080900220214     C     p@mcid        chain(n)  MSMCIDL0                           51
081000220214     c     *in51         ifeq      *on
081100220214     C                   movel     'MSMCIDL0'    w0file
081200220214     C                   movel     p@mcid        w0key
081300220214     C                   z-add     04            w0ernb
081400220214     C                   movel     'MEM5003'     w0msgd
081500220214     C                   movel     'MIDAS  '     w0msgf
081600220214     C                   exsr      srerr
081700220214     C                   endif
081800220214
081900220214      ** Initialise failure flag, termination indicator, 'open'
082000220214      ** and 'server termination requested' flags
082100220214      ** also MQ open error flag as 'open' flag was used for two reasons
082200220214
082300220214     C                   movel     'N'           w@abnormal        1
082400220214     C                   movel     *off          *in01
082500220214     C                   movel     'N'           w@connect         1
082600220214     C                   movel     'N'           w@open            1
082700220214     C                   movel     'N'           w@srvr_trq        1
082800220214     C                   movel     'N'           w@MQConnErr       1
082900220214     C                   movel     'N'           w@MQOpenErr       1
083000220214
083100220214      ** Use default connection handle, and implicit connection
083200220214
083300220214     C                   Z-ADD     HCDEFH        HCONN
083400220214
083500220214      ** Open MQ series queue
083600220214
083700220214     C                   exsr      sr_open
083800220214
083900220214      ** Pop subroutine
084000220214
084100220214     C                   clear                   @STK(Q)
084200220214     C                   sub       1             Q
084300220214     C                   endsr
084400220214      /EJECT
084500220214
084600220214      **********************************************************************
084700220214      * sr_open        : Open MQ series queue                              *
084800220214      * -------                                                            *
084900220214      *                                                                    *
085000220214      * Called by      : sr_init                                           *
085100220214      *                                                                    *
085200220214      * Calls          : QMQM                                              *
085300220214      *                                                                    *
085400220214      **********************************************************************
085500220214
085600220214     C     sr_open       begsr
085700220214
085800220214      ** Push subroutine
085900220214
086000220214     C                   add       1             Q
086100220214     C                   movel     'sr_open'     @STK(Q)
086200220214
086300220214      ** Queue manager name
086400220214
086500220214     C     MCMQMN        ifne      *Blank
086600220214     C                   MOVEL     MCMQMN        ODMN             48
086700220214     C                   endif
086800220214
086900220214      ** Connect to the queue manager; we have to do this explicitly
087000220214      ** now, in order to support non-default queue managers.
087100220214
087200220214     C                   Z-ADD     MQCONN        CID
087300220214     C                   CALL      'QMQM'
087400220214     C                   PARM                    CID               9 0
087500220214     C                   PARM                    MCMQMN
087600220214     C                   PARM                    HCONN             9 0
087700220214     C                   PARM                    OCODE             9 0
087800220214     C                   PARM                    REASON            9 0
087900220214
088000220214      ** If connect failed, indicate abnormal end
088100220214
088200220214     C     REASON        IFNE      RCNONE
088300220214     C                   movel     'Y'           w@abnormal
088400220214     C                   movel     'QMQM     '   w0file
088500220214     C                   movel     'MEM6001'     w0msgd
088600220214     C                   movel     'MIDAS  '     w0msgf
088700220214     C                   movel     'Conn Mgr  '  w0key
088800220214     C                   movel     REASON        w0reas
088900220214     C                   z-add     103           w0ernb
089000220214     C                   movel     'Y'           W@MQOpenErr
089100220214     C                   exsr      sr_term
089200220214     C                   endif
089300220214
089400220214      ** Queue name
089500220214
089600220214     C                   MOVEL     MCMQQN        ODON             48
089700220214
089800220214      ** Open queue for INPUT
089900220214
090000220214     C     p@io          ifeq      'I'
090100220214      ** Open options: INPUT and FAIL_IF_QUIESCING
090200220214
090300220214     C     OOINPQ        ADD       OOFIQ         OPTS
090400220214
090500220214      ** Open queue for OUTPUT
090600220214
090700220214     C                   else
090800220214
090900220214      ** Open options: OUTPUT and FAIL_IF_QUIESCING
091000220214
091100220214     C     OOOUT         ADD       OOFIQ         OPTS
091200220214     C                   endif
091300220214
091400220214      ** Clear Q-Manager so it can use clustered queues / remote Q-manager as well
091500220214
091600220214     C                   MOVE      *BLANKS       ODMN
091700220214
091800220214      ** Open queue
091900220214
092000220214     C                   Z-ADD     MQOPEN        CID
092100220214     C                   CALL      'QMQM'
092200220214     C                   PARM                    CID               9 0
092300220214     C                   PARM                    HCONN             9 0
092400220214     C                   PARM                    MQOD
092500220214     C                   PARM                    OPTS              9 0
092600220214     C                   PARM                    HIN               9 0
092700220214     C                   PARM                    OCODE             9 0
092800220214     C                   PARM                    REASON            9 0
092900220214
093000220214      ** Trace
093100220214
093200220214     C                   movel     '*OPEN  '     PR@FN
093300220214     C                   exsr      sr_trace
093400220214
093500220214      ** If open queue failed, indicate abnormal end
093600220214
093700220214     C     REASON        IFNE      RCNONE
093800220214     C                   movel     'Y'           w@abnormal
093900220214     C                   movel     'QMQM     '   w0file
094000220214     C                   movel     'MEM6001'     w0msgd
094100220214     C                   movel     'MIDAS  '     w0msgf
094200220214     C                   movel     'Open queue'  w0key
094300220214     C                   movel     REASON        w0reas
094400220214     C                   z-add     103           w0ernb
094500220214     C                   movel     'Y'           W@MQOpenErr
094600220214
094700220214      ** If no failure, identify successful open
094800220214
094900220214     C                   else
095000220214     C                   movel     'Y'           w@open
095100220214     C                   endif
095200220214
095300220214      ** Pop subroutine
095400220214
095500220214     C                   clear                   @STK(Q)
095600220214     C                   sub       1             Q
095700220214     C                   endsr
095800220214      /EJECT
095900220214
096000220214      **********************************************************************
096100220214      * sr_close       : Close MQ series queue                             *
096200220214      * --------                                                           *
096300220214      *                                                                    *
096400220214      * Called by      : sr_term                                           *
096500220214      *                                                                    *
096600220214      * Calls          : QMQM                                              *
096700220214      *                                                                    *
096800220214      **********************************************************************
096900220214
097000220214     C     sr_close      begsr
097100220214
097200220214      ** Push subroutine
097300220214
097400220214     C                   add       1             Q
097500220214     C                   movel     'sr_close'    @STK(Q)
097600220214
097700220214      ** Close options: NONE
097800220214
097900220214     C                   Z-ADD     CONONE        OPTS
098000220214
098100220214      ** Close queue
098200220214
098300220214     C                   Z-ADD     MQCLOS        CID
098400220214     C                   CALL      'QMQM'
098500220214     C                   PARM                    CID               9 0
098600220214     C                   PARM                    HCONN             9 0
098700220214     C                   PARM                    HIN               9 0
098800220214     C                   PARM                    OPTS              9 0
098900220214     C                   PARM                    CCODE             9 0
099000220214     C                   PARM                    REASON            9 0
099100220214
099200220214      ** Trace
099300220214
099400220214     C                   movel     '*CLOSE '     PR@FN
099500220214     C                   exsr      sr_trace
099600220214
099700220214      ** If close queue failed, indicate abnormal end
099800220214
099900220214     C     REASON        IFNE      RCNONE
100000220214     C                   movel     'Y'           w@abnormal
100100220214     C                   movel     'QMQM     '   w0file
100200220214     C                   movel     'MEM6001'     w0msgd
100300220214     C                   movel     'MIDAS  '     w0msgf
100400220214     C                   movel     'Close queue' w0key
100500220214     C                   movel     REASON        w0reas
100600220214     C                   z-add     104           w0ernb
100700220214     C                   endif
100800220214
100900220214      ** Pop subroutine
101000220214
101100220214     C                   clear                   @STK(Q)
101200220214     C                   sub       1             Q
101300220214     C                   endsr
101400220214      /EJECT
101500220214
101600220214      **********************************************************************
101700220214      * sr_disconn     : Disconnect from Queue Manager                     *
101800220214      * ----------                                                         *
101900220214      *                                                                    *
102000220214      * Called by      : sr_term                                           *
102100220214      *                                                                    *
102200220214      * Calls          : QMQM                                              *
102300220214      *                                                                    *
102400220214      **********************************************************************
102500220214
102600220214     C     sr_disconn    begsr
102700220214
102800220214      ** Push subroutine
102900220214
103000220214     C                   add       1             Q
103100220214     C                   movel     'sr_disconn'  @STK(Q)
103200220214
103300220214      ** Disconnect from Queue Manager
103400220214
103500220214     C                   CALL      'QMQM'
103600220214     C                   PARM      MQDISC        CID               9 0
103700220214     C                   PARM                    HCONN             9 0
103800220214     C                   PARM      *ZERO         OCODE             9 0
103900220214     C                   PARM      *ZERO         REASON            9 0
104000220214
104100220214      ** Trace
104200220214
104300220214     C                   movel     '*DISC  '     PR@FN
104400220214     C                   exsr      sr_trace
104500220214
104600220214      ** If connection failed, indicate abnormal end
104700220214
104800220214     C     REASON        IFNE      RCNONE
104900220214     C                   movel     'Y'           w@abnormal
105000220214     C                   movel     'QMQM     '   w0file
105100220214     C                   movel     'MEM6001'     w0msgd
105200220214     C                   movel     'MIDAS  '     w0msgf
105300220214     C                   movel     'Disconnect'  w0key
105400220214     C                   movel     REASON        w0reas
105500220214     C                   z-add     106           w0ernb
105600220214     C                   endif
105700220214
105800220214      ** Pop subroutine
105900220214
106000220214     C                   clear                   @STK(Q)
106100220214     C                   sub       1             Q
106200220214     C                   endsr
106300220214      /EJECT
106400220214
106500220214      *****************************************************************
106600220214      *                                                               *
106700220214      * *PSSR  - Program exception error routine                      *
106800220214      *          Called automatically if a program error occurs,      *
106900220214      *          or directly by the program code using EXSR.          *
107000220214      *          This subroutine DUMPs the program just once.         *
107100220214      *                                                               *
107200220214      * Called by: (**calling routines**)                             *
107300220214      *                                                               *
107400220214      * Calls: None                                                   *
107500220214      *                                                               *
107600220214      *****************************************************************
107700220214
107800220214     C     *PSSR         begsr
107900220214      *
108000220214     C     @run          ifeq      *blank
108100220214     C                   move      'Y'           @run              1
108200220214
108300220214      ** Shutdown compression server for transmission jobs if not
108400220214      ** already requested
108500220214
108600220214     C     p@io          ifeq      'O'
108700220214     C     w@srvr_trq    andeq     'N'
108800220214     C                   movel(p)  '*SHUTDOWN'   q@prompt
108900220214     C                   call      'QSNDDTAQ'    q@snddtaq
109000220214     C                   movel     'Y'           w@srvr_trq
109100220214     C                   endif
109200220214      *
109300220214     C                   dump
109400220214      *
109500220214     C                   endif
109600220214
109700220214      ** Push subroutine
109800220214
109900220214     C                   add       1             Q
110000220214     C                   movel     '*PSSR'       @STK(Q)
110100220214      *
110200220214     C                   seton                                        U7U8LR
110300220214     C                   return
110400220214     C                   endsr
110500220214      *
110600220214      ********************************************************************
110700220214     C*
110800220214      /COPY MSCPYSRC,SRERRC
110900220214**CTDATA cpy@
111000220214(c) Finastra International Limited 2021
111100220214**CTDATA mxTags
111200220214PmtId_UETR
111300220214MsgDefIdr
111400220214IntrBkSttlmAmt
111500220214IntrBkSttlmAmt_Ccy
111600220214IntrBkSttlmDt
111700220214GrpHdr_MsgId
111800220214GrpHdr_CreDtTm
111900220214BizMsgIdr
