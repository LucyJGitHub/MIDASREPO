     H DEBUG
     H COPYRIGHT('(c) Finastra International Ltd. 2018')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas CF Receive Confirmation from MMM via queue')     *
      *****************************************************************
      *                                                               *
      *  Midas - CONFIRMATION MATCHING                                *
      *                                                               *
      *  CFG003 - Receive confirmation from MMM via queue             *
      *                                                               *
      *  Function:  This program receives confirmations from MMM      *
      *             from a data queue or MQ Series Queue and writes   *
      *             them to a flat file. Called by CFC0185            *
      *                                                               *
      *  Called By: CFC0185  Midas CF Midas/TRAM transfer subprogram  *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Ltd. 2018                         *
      *                                                               *
      *  Last Amend No. MD041126           Date 15Apr20               *
      *  Prev Amend No. CSW051  *CREATE    Date 15Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055613.                             *
      *  CSW051 - Send Confirmation from MMM to TRAM via MQ Series.   *
      *           Also include fix 262207 - Commit write to CFTRAMPD  *
      *           so msgs on't rollback onto queue.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    51         Chain to CFMCIDL0                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * sr_DQIn  - Receive confirmation from MMM on Data Queue        *
      * sr_MQIn  - Receive confirmation from MMM on MQ Queue          *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FCFMCIDL0  IF   E           K disk    infsr(*PSSR)
     FCFTRAMPD  O    E             disk    infsr(*PSSR)
     F                                     commit

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      /COPY ZACPYSRC,STD_D_SPEC

      /COPY ZACPYSRC,PSDS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details
     D dsfdy         E DS                  extname(DSFDY)


      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      * MQI Constants
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
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

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     Dp@msgbuf         S          12000
     Dw@null           S              1    inz(x'00')
      *
     D                 DS
     D  w@cr                   5      5    inz(x'0d')
     D  w@lf                   6      6    inz(x'25')
     D  w@crlf                 5      6
     D  w@altlf               11     11    inz(x'15')
     D  w@altcrlf             10     11


     D w@msgbuf        S              1    DIM(12000)
      ** message buffer array
                                                                                            MD041126
      ** MQ Parameters                                                                      MD041126
     D HCONN           S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D HIN             S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D P@MsgLen        S             10I 0                                                  MD041126
     D MESLEN          S             10I 0                                                  MD041126
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
      ** Set a maximum batch size for messages
     C                   z-add     MCBASZ        p@batchsize       5 0
      *
      ** Read queue p@batchsize times or until no message found
     C                   z-add     0             readcount         5 0
     C                   move      *blanks       msgfound          1
     C     readcount     dowlt     p@batchsize
     C     msgfound      andne     'N'

     C                   clear                   q@msgbuf
     C                   clear                   buffer
      ** Read from queue
     C                   if        CSW038 = 'Y'
     C                   exsr      sr_MQIn
     C                   else
     C                   exsr      sr_DQIn
     C                   endif
      *

      ** If message found on queue then write it to the file
     C     q@msgbuf      ifne      *blanks
     C                   move      'Y'           msgfound
     C                   add       1             readcount

      ** Get message length
     C     '-}'          scan      q@msgbuf      q@msglen          9 0
     C     q@msglen      iflt      1
     C                   eval      q@msglen = 12000
     C                   endif

      **  Convert carriage return + line feed x'0d15' to x'0d25'
     C                   clear                   w@msgbuf
     C                   z-add     1             x                 5 0
     C                   movea     q@msgbuf      w@msgbuf(x)
     C     x             doueq     q@msglen
     C                   movea     w@msgbuf(x)   @wk2              2
     C     @wk2          ifeq      w@altcrlf
     C                   movea     w@crlf        w@msgbuf(x)
     C                   endif
     C                   add       1             x
     C                   enddo

      ** Write to file
     C                   clear                   buffer
     C                   movea     w@msgbuf      buffer
     C                   write     cftramd0
      ** Commit so that messages don't roll back onto queue
     C                   commit

      ** else if message not found on queue...
     C                   else
     C                   move      'N'           msgfound
     C                   endif

     C                   enddo

      ** Close MQ series queue
     C                   if        CSW038 = 'Y'
     C                   exsr      sr_close
     C                   endIf

     C                   Move      *ON           *INLR
      *
      **********************************************************************
      /EJECT
      **********************************************************************
      * sr_DQIn        : Receive confirmation from data queue              *
      * --------                                                           *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QRCVDTAQ                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_DQIn       begsr
      *
      ** Message consists of
      ** - Confirmation for TRAM from MMM

      ** Receive message
      *
     C                   if         CSW034 = 'N'
     C                   call      'QRCVDTAQ'    q@rcvdtaq
     C                   else
     C                   call      'QRCVDTAQ'    q@rcvdQpl
     C                   endif
      *
     C                   endsr
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: sr_Open                                                *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR
      *
      ** Define parameter lists
      *
     C     q@rcvdtaq     plist
     C                   parm                    q@DtaqName       10
     C                   parm      '*LIBL'       q@lib            10
     C                   parm      12000         q@length          5 0
     C                   parm                    q@msgbuf      12000
     C                   parm      -1            q@wait            5 0
      *
     C     q@rcvDQpl     plist
     C                   parm                    q@DtaqName       10
     C                   parm      '*LIBL'       q@lib            10
     C                   parm      12000         q@length          5 0
     C                   parm                    q@msgbuf      12000
     C                   parm      -1            q@wait            5 0
     C                   parm      'EQ'          q@korder          2
     C                   parm      2             q@klength         3 0
     C                   parm                    q@rkey            2
     C                   parm                    q@sndlen          3 0
     C                   parm                    q@sndinfo        45

      *
      ** Get communication details from file

     C                   movel     'MMMTOTRAM'   P@MCID           26
     C     p@mcid        chain     CFMCIDL0                           51

     c     *in51         ifeq      *on
     C     *LOCK         IN        LDA
     C                   Eval      DBKey = p@mcid
     C                   Eval      DBFile = 'CFMCIDL0'
     C                   Eval      DBase = 1
     C                   Eval      DBPGM = 'CFG003'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   else
      *
     C                   Eval      q@DtaqName = MCMQQN
      *
     C                   EndIf
      *
      ** Check if the MMM Global Processing is present.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSW034'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW034            1
     C                   ELSE
     C                   MOVE      'N'           CSW034
     C                   ENDIF
      *
      ** we check for CSW038;
      ** if THAT is on we use MQSeries; but if it is off we use data
      ** queues.
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW038'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW038            1
     C                   ELSE
     C                   MOVE      'N'           CSW038
     C                   ENDIF


      ** If Data queues used and global processing is switched on
      ** and a multizone system  then use zone prefix as key
      ** on the queue. (N.B. MQ Processing is done later on)
     C     CSW038        IFEQ      'N'
     C     CSW034        ANDEQ     'Y'
     C     MCMULZ        ANDEQ     'Y'
     C                   move      MCSYTM        q@rkey
     C                   endif

      ** Open MQ series queue
     C                   if        CSW038 = 'Y'
     C                   exsr      sr_open
     C                   endIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
      * sr_open        : Open MQ series queue                              *
      * -------                                                            *
      *                                                                    *
      * Called by      : *INZSR                                            *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************
      *
     C     sr_open       begsr
      *
      ** Queue manager name
     C     MCMQMN        ifne      *Blank
     C                   MOVEL     MCMQMN        ODMN             48
     C                   endif

      ** Connect to the queue manager; we have to do this explicitly
      ** now, in order to support non-default queue managers.
     C**********         Z-ADD     MQCONN        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    MCMQMN                                     MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    OCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQCONN( MCMQMN : HCONN :                                 MD041126
     C                                     OCODE  : REASON )                                MD041126

      ** If connect failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   exsr      *PSSR
     C                   endif

      ** Queue name
     C                   MOVEL     MCMQQN        ODON             48

      ** Open queue for OUTPUT

      ** Open options: INPUT and FAIL_IF_QUIESCING
     C     OOINPQ        ADD       OOFIQ         OPTS

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
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
     C                                     HIN : OCODE : REASON )                           MD041126

      ** If open queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   exsr      *PSSR
     C                   endif
      *
     C                   endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * sr_close       : Close MQ series queue                             *
      * -------                                                            *
      *                                                                    *
      * Called by      : MAIN                                              *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************
      *
     C     sr_close      begsr
      *

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
     C                   exsr      *PSSR
     C                   endif
      *

      ** Close connection
     C**********         Z-ADD     MQDISC        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    OCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126

      ** If close queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   exsr      *PSSR
     C                   endif
      *
     C                   endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * sr_MQIn        : Receive confirmation from MQ Queue                *
      * --------                                                           *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************
      *
     C     sr_MQIn       begsr

      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
      ** Note: the last of these options means that a message longer than
      ** the buffer length defined in this module (currently 1500 bytes)
      ** will be read and removed from the queue.  Any data in the message
      ** after the 1500th byte will be lost.
     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT
     C                   ADD       GMATM         GMOPT

      ** Set wait interval to 2 seconds
     C                   Z-ADD     2000          GMWI

      ** Perform get operation inside commitment control. Commitment
      ** boundary is after the message management file updates.
     C                   ADD       GMSYP         GMOPT

      ** MsgId should be cleared to ensure messages
      ** are processed in arrival/priority sequence
     C                   MOVEL     MINONE        MDMID
      ** If messages coming in have zone prefix in correlation id, then it  MQGET should
      ** should check for prefix. Note that MMM will need to be configured to have
      ** a SetHostIdFilter to set the zone prefix on the MQ correlation ID.

     C     CSW034        IFEQ      'Y'
     C     MCMULZ        ANDEQ     'Y'
     C                   MOVEL     MCSYTM        MDCID
     C                   ELSE
     C                   MOVEL     CINONE        MDCID
     C                   ENDIF


      ** Clear message buffer
     C                   clear                   p@msgbuf

      ** Get message
     C**********         Z-ADD     MQGET         CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HIN               9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM      12000         p@msglen          9 0                      MD041126
     C**********         PARM                    q@msgbuf                                   MD041126
     C**********         PARM                    MESLEN            9 0                      MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
      *                                                                                     MD041126
     C                   Z-ADD     12000         P@MsgLen                                   MD041126
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
     C                                    P@MsgLen : %ADDR(Q@MsgBuf) :                      MD041126
     C                                    MESLEN : CCODE : REASON )                         MD041126

     C     REASON        ifne      RCNONE
     C     REASON        andne     RC2033
     C                   exsr      *PSSR
     C                   ENDIF
      *
     C                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************

**CTDATA cpy@
(c) Finastra International Ltd. 2018