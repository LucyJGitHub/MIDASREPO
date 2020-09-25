     H DEBUG
     H COPYRIGHT('(c) Finastra International Ltd. 2020')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD056776
/*STD *  RPGBASEMOD                                                   *                     MD056776
      *****************************************************************
      *                                                               *
      *  Midas - CONFIRMATION MATCHING                                *
      *                                                               *
      *  CFG002 - Send Confirmation Feedback to MMM                   *
      *                                                               *
      *  Function:  This program sends TRAM feedback status to MMM    *
      *             using Data Queues                                 *
      *                                                               *
      *  Called By: CF0140 - Midas CF Collect Latest Feedback from    *
      *                      TRAM                                     *
      *                                                               *
      *  (c) Finastra International Ltd. 2020                         *
      *                                                               *
      *  Last Amend No. MD056776           Date 24Sep20               *
      *  Prev Amend No. CSW041  *CREATE    Date 16Nov08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056776 - Apply MD-41126 changes for WebSphere MQ9          *
      *  CSW041 - Send TRAM Confirmation Status to MMM                *
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
      * sr_DQout - Format and transmit TRAM feedback to Data Queue    *
      * sr_MQout - Format and transmit TRAM feedback to MQ Queue      *
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

     D APMH17        E DS                  EXTNAME(APMH17PD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      * MQI Constants
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD056776
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD056776

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Object Descriptor
     D MQOD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD056776
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD056776

      ** Message Descriptor
     D MQMD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                        MD056776
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD056776

      ** Put message options
     D MQPMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD056776
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD056776

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     Dp@msgbuf         S          12000
     Dw@null           S              1    inz(x'00')
                                                                                            MD056776
      ** MQ Parameters                                                                      MD056776
     D HCONN           S             10I 0                                                  MD056776
     D OCODE           S             10I 0                                                  MD056776
     D REASON          S             10I 0                                                  MD056776
     D OPTS            S             10I 0                                                  MD056776
     D HIN             S             10I 0                                                  MD056776
     D CCODE           S             10I 0                                                  MD056776
     D P@MsgLen        S             10I 0                                                  MD056776
     D MESLEN          S             10I 0                                                  MD056776
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
     C     *entry        PLIST
     C                   parm                    p@buff           23
      *
     C                   if        CSW038 = 'Y'
     C                   exsr      sr_MQOut
     C                   else
     C                   exsr      sr_DQout
     C                   endif
      *
     C                   exsr      sr_close
     C                   Move      *ON           *INLR
      *
      **********************************************************************
      /EJECT
      **********************************************************************
      * sr_DQout       : Format and transmit TRAM feedback to Data Queue   *
      * --------                                                           *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QSNDDTAQ                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_DQout      begsr
      *
      ** Message consists of
      ** - Meridian 1.7 header
      ** - TRAM feedback status

      ** Set the Meridian 1.7 header fields
     C                   eval      RAMSGTYPE = 'TRAM_Feedback'
     C                   eval      RATGTSYS  = 'Midas'

     C                   EVAL      p@msgbuf = APMH17 + p@buff

      ** Remove null byte
     C     w@null:' '    xlate     p@msgbuf      p@msgbuf

      ** Send message
     C                   eval      q@DQData = p@msgbuf
      *
     C                   if         CSW034 = 'N'
     C                   call      'QSNDDTAQ'    q@snddtaq
     C                   else
     C                   call      'QSNDDTAQ'    q@sndDQpl
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
     C     q@snddtaq     plist
     C                   parm                    q@DtaqName       10
     C                   parm      '*LIBL'       q@libl           10
     C                   parm      1200          q@length          5 0
     C                   parm                    q@DQData       1200

      * parameter lists for put/get to final Data Queues
     C     q@sndDQpl     plist
     C                   parm                    q@DtaqName
     C                   parm      '*LIBL'       q@libl
     C                   parm      1200          q@length
     C                   parm                    q@DQData
     C                   parm      4             q@klength         3 0
     C                   parm                    q@skey            4
      *
      ** Get communication details from file

     C                   movel     'TRAMTOMMM'   P@MCID           26
     C     p@mcid        chain     CFMCIDL0                           51

     c     *in51         ifeq      *on
     C     *LOCK         IN        LDA
     C                   Eval      DBKey = p@mcid
     C                   Eval      DBFile = 'CFMCIDL0'
     C                   Eval      DBase = 1
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

     C     CSW038        IFEQ      'Y'
     C     CSW034        ANDEQ     'N'
     C                   Call      'RTVNODEREF'
     C                   Parm      MCSYTM        HostID            2
     C                   Parm                    noderef           2 0
      *
     C                   movel     noderef       q@skey
     C                   move      '20'          q@skey
     C                   endif
      *
      ** If CSW038 is on (we are sending message to MMM via MQSeries)
      ** then we need the length of the Meridian 1.7 header instead
     C                   if        CSW038 = 'Y'

     C                   CALL      'UTGETRCDLN'
      ** Return code
     C                   PARM                    ReturnCode       10
      ** Record length
     C                   PARM      *ZERO         HLEN              5 0
      ** File name
     C                   PARM      'APMH17PD  '  FileName         10
      ** File library
     C                   PARM      '*LIBL     '  FileLib          10

     C                   ADD       1             HLEN
     C                   endif
      *
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
     C**********         Z-ADD     MQCONN        CID                                        MD056776
     C**********         CALL      'QMQM'                                                   MD056776
     C**********         PARM                    CID               9 0                      MD056776
     C**********         PARM                    MCMQMN                                     MD056776
     C**********         PARM                    HCONN             9 0                      MD056776
     C**********         PARM                    OCODE             9 0                      MD056776
     C**********         PARM                    REASON            9 0                      MD056776
                                                                                            MD056776
     C                   CALLP     MQCONN( MCMQMN : HCONN :                                 MD056776
     C                                     OCODE  : REASON )                                MD056776

      ** If connect failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   exsr      *PSSR
     C                   endif

      ** Queue name
     C                   MOVEL     MCMQQN        ODON             48

      ** Open queue for OUTPUT

      ** Open options: OUTPUT and FAIL_IF_QUIESCING
     C     OOOUT         ADD       OOFIQ         OPTS

      ** Open queue
     C**********         Z-ADD     MQOPEN        CID                                        MD056776
     C**********         CALL      'QMQM'                                                   MD056776
     C**********         PARM                    CID               9 0                      MD056776
     C**********         PARM                    HCONN             9 0                      MD056776
     C**********         PARM                    MQOD                                       MD056776
     C**********         PARM                    OPTS              9 0                      MD056776
     C**********         PARM                    HIN               9 0                      MD056776
     C**********         PARM                    OCODE             9 0                      MD056776
     C**********         PARM                    REASON            9 0                      MD056776
                                                                                            MD056776
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD056776
     C                                     HIN : OCODE : REASON )                           MD056776

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
     C**********         Z-ADD     MQCLOS        CID                                        MD056776
     C**********         CALL      'QMQM'                                                   MD056776
     C**********         PARM                    CID               9 0                      MD056776
     C**********         PARM                    HCONN             9 0                      MD056776
     C**********         PARM                    HIN               9 0                      MD056776
     C**********         PARM                    OPTS              9 0                      MD056776
     C**********         PARM                    CCODE             9 0                      MD056776
     C**********         PARM                    REASON            9 0                      MD056776
                                                                                            MD056776
     C                   CALLP     MQCLOSE( HCONN : HIN : OPTS :                            MD056776
     C                                      CCODE : REASON )                                MD056776

      ** If close queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   exsr      *PSSR
     C                   endif
      *

      ** Close connection
     C**********         Z-ADD     MQDISC        CID                                        MD056776
     C**********         CALL      'QMQM'                                                   MD056776
     C**********         PARM                    CID               9 0                      MD056776
     C**********         PARM                    HCONN             9 0                      MD056776
     C**********         PARM                    OCODE             9 0                      MD056776
     C**********         PARM                    REASON            9 0                      MD056776
                                                                                            MD056776
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD056776

      ** If close queue failed, indicate abnormal end

     C     REASON        IFNE      RCNONE
     C                   exsr      *PSSR
     C                   endif
      *
     C                   endsr
      **********************************************************************
      **********************************************************************
      /EJECT
      **********************************************************************
      * sr_MQout       : Format and transmit TRAM Feedback to MQ Queue     *
      * --------                                                           *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QMQM                                              *
      *                                                                    *
      **********************************************************************
      *
     C     sr_MQout      begsr

      ** Set the Meridian 1.7 header fields

     C                   eval      RAMSGTYPE = 'TRAM_Feedback'
     C                   eval      RATGTSYS  = 'Midas'
     C                   EVAL      p@msgbuf = APMH17 + p@buff

      ** Get message length

     C     w@null        scan      p@msgbuf      p@msglen                 99    *
     C     *in99         ifeq      *off
     C                   z-add     12000         p@msglen
     c                   endif

      ** Remove null byte
     C     w@null:' '    xlate     p@msgbuf      p@msgbuf

      ** MDFMT (Format Name) is a subfield of the MQMD data structure,
      ** defined in the include member CMQMDR.
      ** FMSTR is a named constant defined in CMQR; it contains 'MQSTR   '.
     C                   EVAL      MDFMT = FMSTR

      ** Send message
     C**********         Z-ADD     MQPUT         CID                                        MD056776
     C**********         CALL      'QMQM'                                                   MD056776
     C**********         PARM                    CID               9 0                      MD056776
     C**********         PARM                    HCONN             9 0                      MD056776
     C**********         PARM                    HIN               9 0                      MD056776
     C**********         PARM                    MQMD                                       MD056776
     C**********         PARM                    MQPMO                                      MD056776
     C**********         PARM                    p@msglen          9 0                      MD056776
     C**********         PARM                    p@msgbuf                                   MD056776
     C**********         PARM                    CCODE             9 0                      MD056776
     C**********         PARM                    REASON            9 0                      MD056776
                                                                                            MD056776
     C                   CALLP     MQPUT( HCONN : HIN : MQMD : MQPMO :                      MD056776
     C                                    P@MsgLen : %ADDR(P@MsgBuf) :                      MD056776
     C                                    CCODE : REASON )                                  MD056776

      *
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
(c) Finastra International Ltd. 2020
