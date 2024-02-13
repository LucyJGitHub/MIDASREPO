     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas MS Outgoing Messages for MMM/AFT Interface')     *
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      *  MSM3202 - Midas MS Outgoing Messages for MMM/AFT Interface   *
      *                                                               *
      *  Function:  This program reads all Ready-to-Send SWIFT        *
      *             messages from MQ queue and outputs them as        *
      *             individual flat files to a dedicated local        *
      *             directory in iSeries.                             *
      *                                                               *
      *  Called By: MSCM3202 - Write to IFS for AFT transmission      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 31Jan24               *
      *  Prev Amend No. CSW052 *CREATE     Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD-62261.                             *
      *  CSW052 - Send SWIFT messages to AFT via MQ queues            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Notes:                                                       *
      *  ------                                                       *
      *                                                               *
      *  1. The interface converts flat files to MQ Series messages   *
      *     which are read from MQ queues.                            *
      *                                                               *
      *  2. The individual flat files sent to the dedicated local     *
      *     directory in iSeries will not be processed nor removed    *
      *     unless AFTOutgoingFTP is set to 'Y' or some other         *
      *     application picks them up.                                *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSIFSOPD  O    E             disk    infsr(srfile)
      ** Midas MS IFS Format Output File
      *
     F                                     commit
     FMS3200AU  O    E             printer oflind(*in66) usropn
      ** Midas MS create o/g message file in DOS-PCC format
      *
      /EJECT
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details
     D dsfdy         E DS                  extname(DSFDY)
      *
     D dssdy         E DS                  extname(DSSDY)
      ** Data Structures used by access objects
      *
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

     D sdbank        E DS                  extname(SDBANKPD)
      ** Bank details ICD
      *
     D sdmgme        E DS                  extname(SDMGMEPD)
      ** Message Generation/Message Management ICD
      *
     D  msstat2      E DS                  extname(MSSTAT2)
      ** Midas/SWIFT Direct Link status data area # 2 (new for CSW009)
      *
     D  sdstat       E DS                  extname(SDSTAT)
     Dren@mode       E                     extfld(MODE)
      ** SDSTAT for system prefix
      *
     Dq@msgbuf         S          10240
     Dw@null           S              1    inz(x'00')
      *
     D                 DS
     D  w@cr                   5      5    inz(x'0d')
     D  w@lf                   6      6    inz(x'25')
     D  w@crlf                 5      6
     D  w@altlf               11     11    inz(x'15')
     D  w@altcrlf             10     11
      *
     D  w@msg          DS         10240
     D  w@msgbuf               1  10240
     D                                     dim(10240)
     D  w@msgout               1  10240
     D                                     dim(20)
      ** Buffers for outgoing message
      *
      /SPACE 2
      *
     D  w@datafil      DS
     D  w@datf1                1     10    inz('/QSYS.LIB/')
     D  w@datfpfx             11     12
     D  w@datf2               13     36    inz('DPLIB.LIB/MSOSTMFD.FILE/')
     D  w@datf3               37     48    inz('MSOSTMFD.MBR')
      ** Define Midas output file for copy to IFS
      *
     D                 DS
     D  w@seqn                 1      3  0
     D  w@seqa                 1      3
      ** Sequence numbers for Alliance file name in FTP script
      *
     D                 DS
     D  timestpn               1     14  0
     D  timetime               1      6
     D  timedd                 7      8
     D  timemm                 9     10
     D  timeyyyy              11     14
     D  timestpc               1     14
      ** Timestamp for IFS file name
      *
     D RtnCde          S              7A
     D SValK1          S             20A
     D SVal1           S            200A
     D SValK2          S             20A
     D SVal2           S            200A
     D SValK3          S             20A
     D SVal3           S            200A
     D SValK4          S             20A
     D SVal4           S            200A
     D SValK5          S             20A
     D SVal5           S            200A
     D SValK6          S             20A
     D SVal6           S            200A
     D SValK7          S             20A
     D SVal7           S            200A
     D SValK8          S             20A
     D SVal8           S            200A
     D SValK9          S             20A
     D SVal9           S            200A
     D SValK0          S             20A
     D SVal10          S            200A
      ** Parameters for AOSVALR0
      *
     D AFTMaxBatch     S              5  0
     D MQManager       S             48A
     D MQQueueName     S             48A
                                                                                            MD041126
      ** MQ Parameters                                                                      MD041126
     D HCONN           S             10I 0                                                  MD041126
     D HIN             S             10I 0                                                  MD041126
     D HANDLE          S             10I 0                                                  MD041126
     D P@MsgLen        S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D MESLEN          S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D QMNAME          S             48A                                                    MD041126
                                                                                            MD041126
      ** Other work Variables
      *
      ** Control codes and fixed texts
      /COPY MSCPYSRC,SRERRD
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_detail     : Detail processing                            *
      *  sr_format     : Format message for transmission              *
      *  sr_write      : Write to output file for IFS transfer        *
      *  sr_ifsfmt     : Format IFS name                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Output parameter: o@msgs = 'Y' if any messages found, else 'N'
      *
     C     *entry        plist
     C                   parm                    o@msgs            1
     C                   parm                    o@ifsfile       100
     C                   parm                    o@datafile       48
     C                   parm                    p@msgcount        5 0
      *
      ** Set up copyright parameter
      *
     C                   movea     cpy@          cpy2@            80
      *
      ** Initialise program
      *
     C                   exsr      sr_init
      *
      ** Access ready-to-send messages and write to file
      *
     C                   exsr      sr_detail
      *
      ** If any messages write audit
      *
     C     o@msgs        ifeq      'Y'
     C                   if        w#auopen = '0'
     C                   open      ms3200au
     C                   move      '1'           w#auopen
     C                   endif
     C                   movel     w@filnam      W@ALFIL
     C                   write     ms3200f4
     C                   endif
      *
      ** Terminate
      *
     C                   move      *on           *inlr
      /EJECT
      **********************************************************************
      * sr_detail      : Detail processing: access messages and write      *
      * ---------        to transfer file                                  *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : sr_format                                         *
      *                  sr_write                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_detail     begsr
      *
      ** Push subroutine
      *
     C                   add       1             Q
     C                   movel     'sr_detail'   @STK(Q)
      *
      ** Set a maximum batch size for messages
     C                   z-add     AFTMaxBatch   p@batchsize       5 0
      *
      ** Read queue as long as it is less than p@batchsize
      *
     C                   z-add     p@msgcount    readcount         5 0
     C                   move      *blanks       msgfound          1
     C                   movel     'N'           o@msgs
     C     readcount     iflt      p@batchsize

     C                   clear                   q@msgbuf
      *
      ** Read from queue
      *
     C                   exsr      sr_MQIn
      *
      ** If message found on queue then write it to the file
      *
     C     q@msgbuf      ifne      *blanks
     C                   move      'Y'           msgfound
     C                   movel     'Y'           o@msgs
      *
      ** Update count of messages
      *
     C                   add       1             readcount
     C                   z-add     readcount     p@msgcount
      *
      ** Get message length
      *
     C     w@null        scan      q@msgbuf      q@msglen          9 0    99
     C     *in99         ifeq      *off
     C                   z-add     0             q@msglen
     C     ' '           checkr    q@msgbuf      q@msglen
     C                   endif
      *
      **  Convert carriage return + line feed x'0d15' to x'0d25'
      *
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
      *
      ** Write to output file for IFS transfer
      *
     C                   exsr      sr_write
      *
      ** Write details to audit
      *
     C     *in66         ifeq      *on
     C                   movel     *off          *in66
     C                   if        w#auopen = '0'
     C                   open      ms3200au
     C                   move      '1'           w#auopen
     C                   endif
     C                   write     ms3200f1
     C                   endif
     C                   write     ms3200f2
      *
      ** Format IFS file name for output
      *
     C                   exsr      sr_ifsfmt
      *
      ** Set name of data file to copy from
      *
     C                   eval      o@datafile = w@datafil
      *
      ** Set name of IFS file to copy to
      *
     C                   eval      o@ifsfile  = w@ifsfil
      *
      ** Update no of messages read
      *
     C                   eval      p@msgcount = readcount
      *
      ** else if message not found on queue...
      *
     C                   else
     C                   move      'N'           msgfound
     C                   endif
      *
     C                   endif
      *
     C                   exsr      sr_close
      *
      ** Pop subroutine
      *
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_write       : Write to output file for IFS transfer             *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_detail                                         *
      *                                                                    *
      * Calls          : none                                              *
      *                                                                    *
      *  N.B. This would be one place to convert from EBCDIC to ASCII but  *
      *  instead it it is done using the CPYTOSTMF command                 *
      *                                                                    *
      *                                                                    *
      **********************************************************************
      *
     C     sr_write      begsr
      *
      ** Push subroutine
      *
     C                   add       1             Q
     C                   movel     'sr_write'    @STK(Q)
      *
      ** Write to output file
      *
     C                   clear                   SIDATA
     C                   movea     w@msgbuf      SIDATA
     C                   write     msifsod0
      *
      ** Pop subroutine
      *
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_ifsfmt      : Format IFS path name to copy file to              *
      * ---------                                                          *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_ifsfmt     begsr
      *
      ** Push subroutine
      *
     C                   add       1             Q
     C                   movel     'sr_ifsfmt'   @STK(Q)
      *
      ** Create remote filename in form <filename>.timedate.nnn where 'nnn' is the
      ** readcount from the queue.
      *
     C                   movel     readcount     w@ifsseq          5
     C                   move      *blanks       w@ifsfil        100
     C                   move      *blanks       w@filnam         30
     C     ENLPHO        cat       '/':0         w@ifsfil
     C                   z-add     timestp       timestpn
     C     ENSRFO        cat       timeyyyy:0    w@filnam
     C                   cat       timemm:0      w@filnam
     C                   cat       timedd:0      w@filnam
     C                   cat       timetime:0    w@filnam
     C                   cat       w@ifsseq:0    w@filnam
     C                   cat       w@filnam:0    w@ifsfil
      *
      ** Pop subroutine
      *
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      **********************************************************************
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
      *
     C     MQManager     ifne      *Blank
     C                   MOVEL     MQManager     ODMN             48
     C                   endif
      *
      ** Connect to the queue manager; we have to do this explicitly
      ** now, in order to support non-default queue managers.
      *
     C**********         Z-ADD     MQCONN        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    MQManager                                  MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    OCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   CALLP     MQCONN( MQManager : HCONN :                              MD041126
     C                                     OCODE : REASON )                                 MD041126
      *
      ** If connect failed, indicate abnormal end
      *
     C     REASON        IFNE      RCNONE
     C                   exsr      *PSSR
     C                   endif
      *
      ** Queue name
      *
     C                   MOVEL     MQQueueName   ODON             48
      *
      ** Open queue for OUTPUT
      ** Open options: INPUT and FAIL_IF_QUIESCING
      *
     C     OOINPQ        ADD       OOFIQ         OPTS
      *
      ** Open queue
      *
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
      *
      ** If open queue failed, indicate abnormal end
      *
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
      *
     C                   Z-ADD     CONONE        OPTS
      *
      ** Close queue
      *
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
      *
      ** If close queue failed, indicate abnormal end
      *
     C     REASON        IFNE      RCNONE
     C                   exsr      *PSSR
     C                   endif
      *
      ** Close connection
      *
     C**********         Z-ADD     MQDISC        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQDISC        CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM      *ZERO         OCODE             9 0                      MD041126
     C**********         PARM      *ZERO         REASON            9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
      *
      ** If close queue failed, indicate abnormal end
      *
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
      *
      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
      ** Note: the last of these options means that a message longer than
      ** the buffer length defined in this module (currently 1500 bytes)
      ** will be read and removed from the queue.  Any data in the message
      ** after the 1500th byte will be lost.
      *
     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT
     C                   ADD       GMATM         GMOPT
      *
      ** Set wait interval to 2 seconds
      *
     C                   Z-ADD     2000          GMWI
      *
      ** Perform get operation inside commitment control. Commitment
      ** boundary is after the message management file updates.
      *
     C                   ADD       GMSYP         GMOPT
      *
      ** MsgId should be cleared to ensure messages
      ** are processed in arrival/priority sequence
      *
     C                   MOVEL     MINONE        MDMID
      *
      ** Similarly for correlation id
      *
     C                   MOVEL     CINONE        MDCID
      *
      ** Clear message buffer
      *
     C                   clear                   q@msgbuf
      *
      ** Get message
      *
     C**********         Z-ADD     MQGET         CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HIN               9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM      10240         p@msglen          9 0                      MD041126
     C**********         PARM                    q@msgbuf                                   MD041126
     C**********         PARM                    MESLEN            9 0                      MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     10240         P@MsgLen                                   MD041126
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
     C                                    P@MsgLen : %ADDR(Q@MsgBuf) :                      MD041126
     C                                    MESLEN : CCODE : REASON )                         MD041126
      *
     C     REASON        ifne      RCNONE
     C     REASON        andne     RC2033
     C                   exsr      *PSSR
     C                   ENDIF
      *
     C                   endsr
      *****************************************************************
      /EJECT
      **********************************************************************
      * sr_init        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Push subroutine
      *
     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)
      *
      ** Initialise output parameter
      *
     C                   movel     'N'           o@msgs
      *
      ** Define all data areas
      *
     C     *dtaara       define                  sdstat
     C     *dtaara       define                  msstat2
      *
      ** Access system prefix
      *
     C                   in        sdstat
     C                   movel     LIBR          w@datfpfx
      *
      ** Access bank details
      *
     C                   call      'AOBANKR0'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdbank        parm      *blanks       dssdy
      *
      ** If the Access Object returns an error code, database error
      *
     C     p@rtcd        ifne      *blank
     C                   movel     'AOBANKR0'    w0file
     C                   movel     'Bank details'w0key
     C                   z-add     01            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   open      ms3200au
     C                   write     ms3200f1
     C                   write     ms3200f5
     C                   exsr      srerr
     C                   endif
      *
      ** Access Message Generation/Message Management ICD
      *
     C                   call      'AOMGMER1'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdmgme        parm      *blanks       dssdy
      *
      ** If the Access Object returns an error code, database error
      *
     C     p@rtcd        ifne      *blank
     C                   movel     'AOMGMER1'    w0file
     C                   movel     'MG/ME ICD'   w0key
     C                   z-add     02            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   open      ms3200au
     C                   write     ms3200f1
     C                   write     ms3200f5
     C                   exsr      srerr
     C                   endif
      *
     C                   CLEAR                   SValK1
     C                   CLEAR                   SValK2
     C                   CLEAR                   SValK3
     C                   CLEAR                   SValK4
     C                   CLEAR                   SValK5
     C                   CLEAR                   SValK6
     C                   CLEAR                   SValK7
     C                   CLEAR                   SValK8
     C                   CLEAR                   SValK9
     C                   CLEAR                   SValK0
      *
      ** Initialise the first system value key
      *
     C                   EVAL      SValK1 = 'AFTOutgoingBatchSize'
     C                   EVAL      SValK2 = 'AFTQueueManager'
     C                   EVAL      SValK3 = 'AFTOutgoingMsgQueue'
      *
      ** Retrieve the system value
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RtnCde
     C                   PARM                    SValK1
     C                   PARM                    SVal1
     C                   PARM                    SValK2
     C                   PARM                    SVal2
     C                   PARM                    SValK3
     C                   PARM                    SVal3
     C                   PARM                    SValK4
     C                   PARM                    SVal4
     C                   PARM                    SValK5
     C                   PARM                    SVal5
     C                   PARM                    SValK6
     C                   PARM                    SVal6
     C                   PARM                    SValK7
     C                   PARM                    SVal7
     C                   PARM                    SValK8
     C                   PARM                    SVal8
     C                   PARM                    SValK9
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10
      *
      ** If the system value is not found then issue a database error
      *
     C     RtnCde        IFNE      '       '
     C     SVal1         IFEQ      '*NRF'
     C                   EVAL      DBKEY  =  SValK1
     C                   ENDIF
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBFILE =  'SDSVALPD'
     C                   EVAL      DBPGM  =  'MSM3202'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     SVal1         AFTMaxBatch
     C                   MOVEL     SVal2         MQManager
     C                   MOVEL     SVal3         MQQueueName
     C                   ENDIF
      *
      ** Write audit report headings
      *
     C                   move      *on           *in66
     C                   move      '0'           w#auopen          1
      *
      ** Open MQ Series queue
      *
     C                   exsr      sr_open
      *
      ** Get Time stamp
      *
     C                   time                    timestp          14 0
      *
      ** Pop subroutine
      *
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
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
      /COPY MSCPYSRC,SRERRC
**  CPY@
(c) Finastra International Limited 2021
