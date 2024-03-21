     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD060815
/*STD *  RPGBASEMOD                                                   *                     MD060815
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas MS Midas/SWIFT MX Meridian communication')       *
      *****************************************************************
      *                                                               *
      *  Midas - Midas SWIFT                                          *
      *                                                               *
      *  MS20022B - Midas/SWIFT MX Meridian communications            *
      *                                                               *
      *  Function:  This program effects communication between Midas  *
      *             and Meridian using MQSeries Queues                *
      *                                                               *
      *  Called By: MSC200221B                                        *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060815           Date 19Mar24               *
      *  Prev Amend No. MD059755           Date 14Apr23               *
      *                 MD059677           Date 14Apr23               *
      *                 CSW122  *CREATE    Date 14Apr23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060815 - Incoming MX messages are stuck in queue           *
      *             MX.MMM2MIDR.TZ                                    *
      *           - Applied for MD061400.                             *
      *  MD059755 - Various records in MSIXISOPD and MSMXISOPD  have  *
      *             no value date                                     *
      *  MD059677 - Cleared correlation ID                            *
      *  CSW122 - SWIFT ISO 20022 Changes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Notes:                                                       *
      *  ------                                                       *
      *                                                               *
      *    o  This program uses the QMQM API to exchange messages,    *
      *       ACKs and NAKs with Meridian MQ series queues.           *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSMCIDL0  UF   E           K disk    infsr(srfile)
     FMSMXISOPD O    E           K disk    infsr(srfile)
     F                                     commit
     FMSIXISOPD O    E           K disk    infsr(srfile)
     F                                     commit
     FMS20022AU O    E             printer infsr(srfile)
     F                                     oflind(*in66)
     F                                     usropn
      /EJECT
      /COPY MSCPYSRC,SRERRD

      ** Constants to hold input parameter for AOSVALR0.

     D MQManager       C                   Const('MQQueueMgr')

      ** Array containing Copyright statement

     D cpy@            S             80    dim(1) ctdata perrcd(1)

      ** Array containing the recognized tags

     D***mxTags         S            100A   dim(8) ctdata perrcd(1)                         MD059755
     D  mxTags         S            100A   DIM(11) CTDATA PERRCD(1)                         MD059755

      ** Constant for tag array size
      ** If a new element on the mxTags array is added, this must also be updated

     D***arraySize      C                   const(8)                                        MD059755
     D  arraySize      C                   CONST(11)                                        MD059755

     D  cancelMsg      S             20A   varying

      ** Output string

     D outBytes        S          12000A   varying

      ** Field for record writing

     D buffer          S          12000A

      ** Fields for tag manipulation and position marking

     D  tagName        S          12000A   varying
     D  tagVal         S          12000A   varying
     D  tag            S          12000A   varying
     D  msgEnd         S              2A
     D  tagLen         S              5S 0
     D  tagF           S              5S 0
     D  dataLen        S              5S 0
     D  valueLen       S              5S 0
     D  pNL            S              5S 0 inz(0)
     D  pOL            S              5S 0 inz(1)
     D  pEq            S              5S 0 inz(0)

      ** MsgId field for cancellation messages

     D  msgIdCancel    S             36A

      ** Tag array index controller

     D***x              S              1S 0 inz(1)                                          MD059755
     D  x              S              2S 0 inz(1)                                           MD059755

      ** Write records buffer controller

     D  y              S              5S 0 inz(1)

      ** Escape sequence data structure

     D                 DS
     D  W@CRLF                 1      2
     D  W@CR                   1      1    INZ(x'0d')
     D  W@LF                   2      2    INZ(x'25')

      ** Message Management data area

     D medta         E DS                  extname(MEDTA)

      ** Midas/SWIFT Direct Link status data area

     D  msstat       E DS                  extname(MSSTAT)
     D  ren@zz53     E                     extfld(ZZ053)

      ** Midas Message Management status data area
     D  mestat       E DS                  extname(MESTAT) dtaara(MESTAT)

      ** SDSTAT for system prefix

     D  sdstat       E DS                  extname(SDSTAT)
     D  ren@mode     E                     extfld(MODE)

      ** Data structure for receiving message from queue

     D                 DS
     D  q@dqm                  1  12050
     D  q@sndref               1     50
     D  q@msgbuf              51  12050

      ** Data queue entry (control)

     D                 DS
     D  q@dqc                  1     50
     D  q@prompt               1     50

      ** Working field to receive data from queue

     Dp@msgbuf         S          12000A   varying

      **  Declare MQI structures needed
      ** MQI Constants

     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD060815
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD060815

      ** Object Descriptor

     D MQOD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD060815
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD060815

      ** Message Descriptor

     D MQMD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                        MD060815
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD060815

      ** Get message options

     D MQGMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQGMOR                                                       MD060815
     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD060815

      ** Put message options

     D MQPMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD060815
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD060815

      ** The include below brings in the return code structure that
      ** is used in calls to OS/400 APIs.

     D/COPY QSYSINC/QRPGLESRC,QUSEC
                                                                                            MD060815
      ** MQ Parameters                                                                      MD060815
     D HCONN           S             10I 0                                                  MD060815
     D HIN             S             10I 0                                                  MD060815
     D HANDLE          S             10I 0                                                  MD060815
     D P@MsgLen        S             10I 0                                                  MD060815
     D CCODE           S             10I 0                                                  MD060815
     D OCODE           S             10I 0                                                  MD060815
     D REASON          S             10I 0                                                  MD060815
     D MESLEN          S             10I 0                                                  MD060815
     D OPTS            S             10I 0                                                  MD060815
     D QMNAME          S             48A                                                    MD060815
                                                                                            MD060815
      /EJECT

      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_trace      : Trace                                        *
      *  sr_in         : Get incoming messages and write to database  *
      *  sr_out        : Format and transmit outgoing messages        *
      *  sr_term       : Program termination                          *
      *  sr_open       : Open MQ series queue                         *
      *  sr_close      : Close MQ series queue                        *
      *  sr_disconn    : Disconnects from MQ series queue             *
      *  sr_classify   : Classifies the value into the db columns     *
      *  sr_writerec   : Writes message to the database               *
      *  sr_datacheck  : Extracts values from the key-value pairs     *
      *  *PSSR         : Standard program exception error routine     *
      *****************************************************************
      /EJECT

      ** Set up copyright parameter

     C                   movea     cpy@          cpy2@            80
      *
     C     *entry        plist
     C                   parm                    p@mcid           26
     C                   parm                    p@dtqm           10
     C                   parm                    p@dtqc           10
     C                   parm                    p@io              1
     C                   parm                    p@eod             4

      ** Push routine

     C                   z-add     1             Q
     C                   movel     'mainline'    @STK(Q)

      ** Perform initial process

     C                   exsr      sr_init

      ** If no error on opening MQSeries queue

     C                   if         w@MQOpenErr = 'N'
     C                              AND w@MQConnErr = 'N'

      ** execute process for incoming or outgoing messages

     C     p@io          ifeq      'I'
     C                   exsr      sr_in
     C                   else
     C                   exsr      sr_out
     C                   endif
      *
     C                   endif

      ** Program termination

     C                   exsr      sr_term
      *
     C                   seton                                        LR
      /EJECT

      **********************************************************************
      * sr_trace       : Trace (if requested by user).                     *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_init, sr_in, sr_close, sr_disconn              *
      *                                                                    *
      * Calls          :                                                   *
      *                                                                    *
      **********************************************************************

     C     sr_trace      begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_trace  '  @STK(Q)

      ** Check whether trace requested. If it is, write trace information
      ** to report.

     C                   in        msstat
     C     TRACF         ifeq      'T'

      ** If spool file not already open, open it now.

     C     w@prtopn      ifne      'Y'
     C                   movel     'Y'           w@prtopn          1
     C                   OPEN      MS20022AU
     C                   WRITE     MS20022F1
     C                   endif

      ** Check for overflow and rewrite headings if necessary.

     C     *in66         ifeq      *on
     C                   movel     *off          *in66
     C                   WRITE     MS20022F1
     C                   endif

      ** Set up standard details and write to report

     C                   time                    PR@TI
     C     REASON        ifne      0
     C                   movel(p)  REASON        PR@RC
     C                   else
     C                   clear                   PR@RC
     C                   endif
     C                   WRITE     MS20022T1

      ** If data in buffer, write this too

     C     t@tdat        ifne      *blank
     C                   movel(p)  t@tdat        PR@DT
     C                   WRITE     MS20022T2
     C                   clear                   t@tdat          100
     C                   endif
      *
     C                   endif

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_out         : Format and transmit outgoing messages             *
      *                  This is added for future expansion but has no     *
      *                  use for now                                       *
      * ------                                                             *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          :                                                   *
      *                                                                    *
      **********************************************************************

     C     sr_out        begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_out'      @STK(Q)

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_in          : Get incoming messages and write to database       *
      * -----                                                              *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                : sr_trace                                          *
      *                : sr_datacheck                                      *
      *                : MEC20022A                                         *
      *                                                                    *
      **********************************************************************

     C     sr_in         begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_in'       @STK(Q)

      ** Access incoming data until termination requested by user,
      ** or API error.

     C     *in01         doueq     *on
     C     REASON        orne      RCNONE
     C     REASON        andne     RC2033

      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
      ** Note: the last of these options means that a message longer than
      ** the buffer length defined in this module (currently 1500 bytes)
      ** will be read and removed from the queue.  Any data in the message
      ** after the 1500th byte will be lost.

     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT
     C                   ADD       GMATM         GMOPT

      ** Set wait interval to 20 seconds

     C                   Z-ADD     20000         GMWI

      ** Perform get operation inside commitment control. Commitment
      ** boundary is after the message management file updates.

     C                   ADD       GMSYP         GMOPT

      ** MsgId and CorrelId are selectors cleared to ensure messages
      ** are processed in arrival/priority sequence

     C                   MOVEL     MINONE        MDMID
     C                   MOVEL     CINONE        MDCID                                      MD059677

      ** Clear message buffer

     C                   clear                   q@msgbuf

      ** Get message

     C**********         Z-ADD     MQGET         CID                                        MD060815
     C**********         CALL      'QMQM'                                                   MD060815
     C**********         PARM                    CID               9 0                      MD060815
     C**********         PARM                    HCONN             9 0                      MD060815
     C**********         PARM                    HIN               9 0                      MD060815
     C**********         PARM                    MQMD                                       MD060815
     C**********         PARM                    MQGMO                                      MD060815
     C**********         PARM      12000         p@msglen          9 0                      MD060815
     C**********         PARM                    q@msgbuf                                   MD060815
     C**********         PARM                    MESLEN            9 0                      MD060815
     C**********         PARM                    CCODE             9 0                      MD060815
     C**********         PARM                    REASON            9 0                      MD060815
                                                                                            MD060815
     C                   Z-ADD     12000         P@MsgLen                                   MD060815
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD060815
     C                                    P@MsgLen : %ADDR(Q@MsgBuf) :                      MD060815
     C                                    MESLEN : CCODE : REASON )                         MD060815

      ** Message starts after the API header block

     C                   clear                   p@msgbuf
     C                   eval      p@msgbuf = q@msgbuf

      ** Trace

     C                   movel     '*GET   '     PR@FN
     C                   exsr      sr_trace

      ** If receive message failed, indicate abnormal end

     C     REASON        ifne      RCNONE
     C     REASON        andne     RC2033
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Rcv message' w0key
     C                   movel     REASON        w0reas
     C                   z-add     102           w0ernb
     C                   else

      ** Else, if data received and no error

     C     REASON        ifne      RC2033
      *
     C                   exsr      sr_datacheck

      ** Prompt Incoming Message Management

     C                   call      'MEC20022A'                          9090
     C                   parm      *BLANKS       p@rtcd            7
      **
     C                   endif
     C                   endif

      ** Check whether termination has been requested

     C                   shtdn                                        01
      *
     C                   enddo

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_datacheck    : Extracts values from the key-value pairs         *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_in                                             *
      *                                                                    *
      * Calls          : sr_classify                                       *
      *                : sr_writerec                                       *
      *                                                                    *
      **********************************************************************

     C     sr_datacheck  begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_datacheck'@STK(Q)

      ** Initialize  fields

     C                   eval      outBytes = *BLANKS
     C                   z-add     0             pNL
     C                   z-add     1             pOL
     C                   z-add     0             pEq
     C                   z-add     0             tagLen
     C                   z-add     0             dataLen
     C                   z-add     0             valueLen
     C                   clear                   MSMXISD0
     C                   clear                   MSIXISD0

      ** Copy received data to the output field

     C                   eval      outBytes = %trim(p@msgbuf)

      ** Get the length of the data

     C                   eval      dataLen = %len(outBytes)

      ** Check for CRLF on end of message

     C                   eval      msgEnd = %subst(outBytes:dataLen-1:2)

      ** If there is no CRLF on end of message, add them

     C                   if        msgEnd <> W@CRLF
     C                   eval      outBytes = outBytes + W@CRLF

      ** Update the data length

     C                   eval      dataLen = %len(outBytes)
     C                   endif

      ** Get the position of the first new line indicator

     C                   eval      pNL = %scan(W@CRLF:outBytes)

      ** Loop through the data until the end

     C                   dow       pNL <> dataLen

      ** Extract tag data

     C                   eval      pEq = %scan('=':outBytes:pOL)
     C                   eval      valueLen = pNL - pEq - 1
     C                   eval      tagVal = %subst(outBytes:pEq+1:valueLen)

      ** Extract tag name

     C                   eval      tagLen = pEq - pOL
     C                   eval      tagName = %subst(outBytes:pOL:tagLen)

      ** Classify data in preparation for writing to the records

     C                   exsr      sr_classify

      ** Save the current position of the new line marker as reference

     C                   eval      pOL = pNL

      ** Check again for next line marker starting from the position
      ** immediately to the right of the last known marker

     C                   eval      pNL = %scan(W@CRLF:outBytes:pOL+1)

      ** If there are no new line markers anymore, exit the loop

     C                   if        pNL = 0
     C                   leave
     C                   endif
     C                   enddo

      ** Check if message is a cancellation message prior to writing

     C                   eval      cancelMsg = 'camt'+'.'+'056'+'.'+'001'+'.'
     C                              +'08'
     C                   if        MTPY = cancelMsg
     C                             or (UETR = *BLANKS and MXID = *BLANKS)
     C                   eval      MXID = %trim(msgIdCancel)
     C                   eval      IMXID = %trim(msgIdCancel)
     C                   endif

      ** Write data on the records

     C                   exsr      sr_writerec

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
     C
      /EJECT

      **********************************************************************
      * sr_writerec    : Writes message to the database                    *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_datacheck                                      *
      *                                                                    *
      * Calls          :                                                   *
      *                                                                    *
      **********************************************************************

     C     sr_writerec   begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_datacheck'@STK(Q)

      ** Initialize working fields

     C                   eval      y = 1
     C                   eval      buffer = outBytes

      ** Start writing records in 256 char increments until the buffer has been exhausted

     C                   EVAL      MXDTA = %SUBST(buffer:y:256)
     C                   DOW       MXDTA <> *BLANKS
     C                   WRITE     MSMXISD0
     C                   add       256           y
     C                   EVAL      MXDTA = %SUBST(buffer:y:256)
     C                   ENDDO

      ** Write record on index file

     C                   WRITE     MSIXISD0

      ** Commit all messages both to the database and from the queues

     C                   commit

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_classify    : Classifies the value into the db columns          *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_datacheck                                      *
      *                                                                    *
      * Calls          :                                                   *
      *                                                                    *
      **********************************************************************

     C     sr_classify   begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_classify' @STK(Q)

      ** Initialize fields

     C                   z-add     1             x
     C                   z-add     0             tagF

      ** Check if current tag has matches on tag array

     C                   eval      tag = %trim(mxTags(x))
     C                   eval      tagF = %scan(tag:tagName)
     C                   dow       tagF = 0
     C                   eval      tag = %trim(mxTags(x))
     C                   eval      tagF = %scan(tag:tagName)
     C                   if        tagF = 0
     C                   eval      x = x + 1
     C                   endif
     C                   if        x > arraySize
     C                   leave
     C                   endif
     C                   enddo

      ** If current tag is found on tag array, extract the data and store it on the db field

     C                   if        tagF > 0
     C                   eval      tagVal = %subst(outBytes:pEq+1:pNL-pEq-1)

      ** Begin data extraction

     C                   select

      ** Extract UETR

     C                   when      mxTags(x) = 'PmtId_UETR'
     C                   eval      UETR = tagVal
     C                   eval      IUETR = tagVal

      ** Extract Message Type

     C                   when      mxTags(x) = 'MsgDefIdr'
     C                   eval      MTPY = tagVal
     C                   eval      IMTPY = tagVal

      ** Extract Transaction Amount

     C                   when      mxTags(x) = 'IntrBkSttlmAmt'
     C                   eval      AMTS = tagVal

      ** Extract Transaction Currency

     C                   when      mxTags(x) = 'IntrBkSttlmAmt_Ccy'

      ** Extract Value Date

     C                   when      mxTags(x) = 'IntrBkSttlmDt'
     C                             OR mxTags(x) = 'OrgnlIntrBkSttlmDt'                      MD059755
     C                             OR mxTags(x) = 'XpctdValDt'                              MD059755
     C                             OR mxTags(x) = 'ReqdExctnDt_Dt'                          MD059755
     C                   eval      SVDT = tagVal

      ** Extract Message ID

     C                   when      mxTags(x) = 'GrpHdr_MsgId'
     C                   eval      MXID = tagVal
     C                   eval      IMXID = tagVal

      ** Extract Input Date

     C                   when      mxTags(x) = 'GrpHdr_CreDtTm'
     C                   eval      MXIDE = tagVal

      ** Extract MsgId for cancellation messages

     C                   when      mxTags(x) = 'BizMsgIdr'
     C                   eval      msgIdCancel = tagVal
     C                   endsl
     C                   endif

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_term        : Program termination                               *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : sr_close                                          *
      *                : sr_disconn                                        *
      *                                                                    *
      **********************************************************************

     C     sr_term       begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_term'     @STK(Q)

      ** Shutdown compression server for transmission jobs if not
      ** already requested

     C     p@io          ifeq      'O'
     C     w@srvr_trq    andeq     'N'
     C                   movel(p)  '*SHUTDOWN'   q@prompt
     C                   call      'QSNDDTAQ'    q@snddtaq
     C                   movel     'Y'           w@srvr_trq
     C                   endif

      ** Close MQ series queue (if it was opened)

     C     w@open        ifeq      'Y'

     C                   exsr      sr_close
     C     w@connect     ifeq      'Y'
     C                   exsr      sr_disconn
     C                   endif
     C                   endif

      ** Perform abnormal termination processing if required:

     C     w@abnormal    ifeq      'Y'

      **  - print error report

     C     w@prtopn      ifne      'Y'
     C                   open      MS20022AU
     C                   movel     'Y'           w@prtopn
     C                   endif
     C                   write     MS20022F1
     C                   write     MS20022F2
     C                   write     MS20022F3
     C                   close     MS20022AU

      **  - send error message and terminate abnormally

     C                   exsr      srerr
      *
     C                   endif

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_init        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : sr_open                                           *
      *                                                                    *
      **********************************************************************

     C     sr_init       begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)

      ** Define data areas

     C     *dtaara       define                  msstat
     C     *dtaara       define                  sdstat

      ** Define parameter lists

     C     q@rcvdtaq     plist
     C                   parm      p@dtqm        q@dtaq           10
     C                   parm      '*LIBL'       q@libl           10
     C                   parm      12050         q@length          5 0
     C                   parm                    q@dqm
     C                   parm      -1            q@wait            5 0
      *
     C     q@snddtaq     plist
     C                   parm      p@dtqc        q@dtaq
     C                   parm      '*LIBL'       q@libl
     C                   parm      50            q@length          5 0
     C                   parm                    q@dqc

      ** Access SDSTAT for system prefix

     C                   in        sdstat
     C                   movel     LIBR          q@skey            4

      ** Get communication details from file

     C     p@mcid        chain(n)  MSMCIDL0                           51
     c     *in51         ifeq      *on
     C                   movel     'MSMCIDL0'    w0file
     C                   movel     p@mcid        w0key
     C                   z-add     04            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif

      ** Initialise failure flag, termination indicator, 'open'
      ** and 'server termination requested' flags
      ** also MQ open error flag as 'open' flag was used for two reasons

     C                   movel     'N'           w@abnormal        1
     C                   movel     *off          *in01
     C                   movel     'N'           w@connect         1
     C                   movel     'N'           w@open            1
     C                   movel     'N'           w@srvr_trq        1
     C                   movel     'N'           w@MQConnErr       1
     C                   movel     'N'           w@MQOpenErr       1

      ** Use default connection handle, and implicit connection

     C                   Z-ADD     HCDEFH        HCONN

      ** Open MQ series queue

     C                   exsr      sr_open

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_open        : Open MQ series queue                              *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_init                                           *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************

     C     sr_open       begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_open'     @STK(Q)

      ** Queue manager name

     C     MCMQMN        ifne      *Blank
     C                   MOVEL     MCMQMN        ODMN             48
     C                   endif

      ** Connect to the queue manager; we have to do this explicitly
      ** now, in order to support non-default queue managers.

     C**********         Z-ADD     MQCONN        CID                                        MD060815
     C**********         CALL      'QMQM'                                                   MD060815
     C**********         PARM                    CID               9 0                      MD060815
     C**********         PARM                    MCMQMN                                     MD060815
     C**********         PARM                    HCONN             9 0                      MD060815
     C**********         PARM                    OCODE             9 0                      MD060815
     C**********         PARM                    REASON            9 0                      MD060815
                                                                                            MD060815
     C                   CALLP     MQCONN( MCMQMN : HCONN :                                 MD060815
     C                                     OCODE : REASON )                                 MD060815

      ** If connect failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Conn Mgr  '  w0key
     C                   movel     REASON        w0reas
     C                   z-add     103           w0ernb
     C                   movel     'Y'           W@MQOpenErr
     C                   exsr      sr_term
     C                   endif

      ** Queue name

     C                   MOVEL     MCMQQN        ODON             48

      ** Open queue for INPUT

     C     p@io          ifeq      'I'
      ** Open options: INPUT and FAIL_IF_QUIESCING

     C     OOINPQ        ADD       OOFIQ         OPTS

      ** Open queue for OUTPUT

     C                   else

      ** Open options: OUTPUT and FAIL_IF_QUIESCING

     C     OOOUT         ADD       OOFIQ         OPTS
     C                   endif

      ** Clear Q-Manager so it can use clustered queues / remote Q-manager as well

     C                   MOVE      *BLANKS       ODMN

      ** Open queue

     C**********         Z-ADD     MQOPEN        CID                                        MD060815
     C**********         CALL      'QMQM'                                                   MD060815
     C**********         PARM                    CID               9 0                      MD060815
     C**********         PARM                    HCONN             9 0                      MD060815
     C**********         PARM                    MQOD                                       MD060815
     C**********         PARM                    OPTS              9 0                      MD060815
     C**********         PARM                    HIN               9 0                      MD060815
     C**********         PARM                    OCODE             9 0                      MD060815
     C**********         PARM                    REASON            9 0                      MD060815
                                                                                            MD060815
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD060815
     C                                     HIN : OCODE : REASON )                           MD060815

      ** Trace

     C                   movel     '*OPEN  '     PR@FN
     C                   exsr      sr_trace

      ** If open queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Open queue'  w0key
     C                   movel     REASON        w0reas
     C                   z-add     103           w0ernb
     C                   movel     'Y'           W@MQOpenErr

      ** If no failure, identify successful open

     C                   else
     C                   movel     'Y'           w@open
     C                   endif

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_close       : Close MQ series queue                             *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_term                                           *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************

     C     sr_close      begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_close'    @STK(Q)

      ** Close options: NONE

     C                   Z-ADD     CONONE        OPTS

      ** Close queue

     C**********         Z-ADD     MQCLOS        CID                                        MD060815
     C**********         CALL      'QMQM'                                                   MD060815
     C**********         PARM                    CID               9 0                      MD060815
     C**********         PARM                    HCONN             9 0                      MD060815
     C**********         PARM                    HIN               9 0                      MD060815
     C**********         PARM                    OPTS              9 0                      MD060815
     C**********         PARM                    CCODE             9 0                      MD060815
     C**********         PARM                    REASON            9 0                      MD060815
                                                                                            MD060815
     C                   CALLP     MQCLOSE( HCONN : HIN : OPTS :                            MD060815
     C                                      CCODE : REASON )                                MD060815

      ** Trace

     C                   movel     '*CLOSE '     PR@FN
     C                   exsr      sr_trace

      ** If close queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Close queue' w0key
     C                   movel     REASON        w0reas
     C                   z-add     104           w0ernb
     C                   endif

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT

      **********************************************************************
      * sr_disconn     : Disconnect from Queue Manager                     *
      * ----------                                                         *
      *                                                                    *
      * Called by      : sr_term                                           *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************

     C     sr_disconn    begsr

      ** Push subroutine

     C                   add       1             Q
     C                   movel     'sr_disconn'  @STK(Q)

      ** Disconnect from Queue Manager

     C**********         CALL      'QMQM'                                                   MD060815
     C**********         PARM      MQDISC        CID               9 0                      MD060815
     C**********         PARM                    HCONN             9 0                      MD060815
     C**********         PARM      *ZERO         OCODE             9 0                      MD060815
     C**********         PARM      *ZERO         REASON            9 0                      MD060815
                                                                                            MD060815
     C                   Z-ADD     *ZERO         OCODE                                      MD060815
     C                   Z-ADD     *ZERO         REASON                                     MD060815
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD060815

      ** Trace

     C                   movel     '*DISC  '     PR@FN
     C                   exsr      sr_trace

      ** If connection failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   movel     'Y'           w@abnormal
     C                   movel     'QMQM     '   w0file
     C                   movel     'MEM6001'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   movel     'Disconnect'  w0key
     C                   movel     REASON        w0reas
     C                   z-add     106           w0ernb
     C                   endif

      ** Pop subroutine

     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
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

     C     *PSSR         begsr
      *
     C     @run          ifeq      *blank
     C                   move      'Y'           @run              1

      ** Shutdown compression server for transmission jobs if not
      ** already requested

     C     p@io          ifeq      'O'
     C     w@srvr_trq    andeq     'N'
     C                   movel(p)  '*SHUTDOWN'   q@prompt
     C                   call      'QSNDDTAQ'    q@snddtaq
     C                   movel     'Y'           w@srvr_trq
     C                   endif
      *
     C                   dump
      *
     C                   endif

      ** Push subroutine

     C                   add       1             Q
     C                   movel     '*PSSR'       @STK(Q)
      *
     C                   seton                                        U7U8LR
     C                   return
     C                   endsr
      *
      ********************************************************************
     C*
      /COPY MSCPYSRC,SRERRC
**CTDATA cpy@
(c) Finastra International Limited 2023
**CTDATA mxTags
PmtId_UETR
MsgDefIdr
IntrBkSttlmAmt
IntrBkSttlmAmt_Ccy
OrgnlIntrBkSttlmDt
IntrBkSttlmDt
GrpHdr_MsgId
GrpHdr_CreDtTm
BizMsgIdr
XpctdValDt
ReqdExctnDt_Dt
