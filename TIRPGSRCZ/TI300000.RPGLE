     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas TI Update MX Files for Trade Finance')           *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI300000 - Midas TI Update MX Files for Trade Finance        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 24Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD031372           Date 21Nov14               *
      *                 MD031150           Date 29Oct14               *
      *                 MD030926           Date 08Oct14               *
      *                 CTI006  *CREATE    Date 31Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    * 
      *           - Applied for MD055945.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031372 - Changes in Account Types export. New format       *
      *             TISDACOD3 created for special delete when A5TOIN  *
      *             is changed from N to Y.                           *
      *  MD031150 - Changes to Export of Base Rates                   *
      *  MD030926 - Changes in Account Code export. New format        *
      *             TISDACOD2 created for dripfeed export.            *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** MX Export Format Details file
 
     FMXEXFDPD  UF   E             DISK    INFSR(*PSSR)
 
      ** MX Composite Message Details file
 
     FMXCOMDPD  UF   E             DISK    INFSR(*PSSR)
 
      ** MX Journal Sequence Files
 
     FMXOLEJPD  UF A E             DISK    INFSR(*PSSR)
     FMXOLTJPD  UF A E             DISK    INFSR(*PSSR)
 
      ** SM Update MX files for Bundesbank screen
 
     FTI300000DFCF   E             WORKSTN INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** For case translation
 
     D UpCase          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D LoCase          C                   'abcdefghijklmnopqrstuvwxyz'
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** Declare MQI structures needed
      ** MQI Constants
 
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
 
      ** Object Descriptor
 
     D MQOD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** External DS for Bank details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for acces programs - short data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D MQManager       C                   Const('MQQueueManagerAPI')
     D ZADATE          S              7A
     D ZDATE           S              6A
     D ZDATEN          S              6S 0
     D ZDATEP          S              6  0
     D ZDATFM          S              1A
     D ZDAYNO          S              5  0
     D ZRETURN         S              7A
     D ZFIELD          S             16A
     D ZADEC           S              1S 0
     D ZADIG           S              2S 0
     D ZAFLD           S             16A
 
     D ZAPGM           S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S             10A
     D ZAMSGF          S             10A   INZ('GBTIUSRMSG')
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
 
     D MQUEUE          S             48A
     D WEMSGQ          S                   LIKE(EXMSGQ)
     D WCMSGQ          S                   LIKE(CDMSGQ)
     D POptn           S              7A
     D PRtcd           S              7A
     D Rundate         S              6S 0
     D WConfirm        S              1A   INZ('N')
     D WQueueOk        S              1A   INZ('N')
 
      ** System Value Access pgm
     D PSysVal01       S             20A
     D PCurSet01       S            200A
     D PSysVal02       S             20A
     D PCurSet02       S            200A
     D PSysVal03       S             20A
     D PCurSet03       S            200A
     D PSysVal04       S             20A
     D PCurSet04       S            200A
     D PSysVal05       S             20A
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A
      *
     D SystemValue     S             20A
     D QName           S             48A
     D ProcMode        S            190A
     D GenError        S              1A
     D Idx             S              2P 0
     D ErrMsgId        S              7A
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
     D QManagerUC      S             48A
     D***CID****         S              9P 0                                                MD041126
     D QMNAME          S             48A
     D***HCONN**         S              9P 0                                                MD041126
     D***OCODE**         S              9P 0                                                MD041126
     D***REASON*         S              9P 0                                                MD041126
     D***OPTS***         S              9P 0                                                MD041126
     D***HIN****         S              9P 0                                                MD041126
     D HCONN           S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D HIN             S             10I 0                                                  MD041126
     D wMQManager      S             48A
     D @RUN            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   EXSR      SRInit
 
     C                   DOW       WConfirm = 'N'
     C                   DOW       *IN03 <> *ON  AND
     C                             WQueueOk = 'N'
 
      **  Display the screen
 
     C                   EXSR      SRDspSCRN
 
     C                   ENDDO
 
     C                   IF        *IN12 = *ON
     C                   EVAL      WConfirm = 'N'
     C                   EVAL      WQueueOk = 'N'
     C                   EVAL      *IN28 = *OFF
     C                   ELSE
     C                   EVAL      WConfirm = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
      **  Update the MX Files
 
     C                   IF        WQueueOk = 'Y'
     C                   EXSR      SRUpdJRN
     C                   EXSR      SRUpdEXF
     C                   EXSR      SRUpdCOM
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSCRN - Display the Main Screen                          *
      *                                                               *
      *****************************************************************
     C     SRDspSCRN     BEGSR
 
     C                   IF        *IN05 = *ON
     C                   EXSR      SRReset
     C                   ENDIF
 
     C                   EVAL      *IN90 = *OFF
 
     C                   WRITE     TI30MSGCTL
     C                   WRITE     TI30FOOT
     C                   EXFMT     TI30DETL
     C                   EXSR      SRClrMSG
 
      ** Not refresh or exit command, process input
 
     C                   IF        *IN03 <> *ON AND
     C                             *IN05 <> *ON
 
      **  Validate the fields
 
     C                   EXSR      SRValMSGQ
 
     C                   IF        WQueueOk = 'Y'
 
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN90 = *ON
     C                   WRITE     TI30MSGCTL
     C                   WRITE     TI30FOOT
     C                   EXFMT     TI30DETL
     C                   EXSR      SRClrMSG
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValMSGQ - Validate Message Queue                           *
      *                                                               *
      *****************************************************************
     C     SRValMSGQ     BEGSR
 
     C                   EVAL      *IN23  = *OFF
 
     C                   IF        SMSGQ = *BLANKS
     C                   MOVEL     'TIM0117'     ZAMSID
     C                   EXSR      SRSndMSG
     C                   EVAL      *IN23 = *ON
     C                   EVAL      WQueueOk = 'N'
 
     C                   ELSE
 
      *
      **  Attempt to CONNECT to the MQ Manager
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQCONN        CID                                        MD041126
     C**********         PARM      wMQManager    QMNAME                                     MD041126
     C**********         PARM      *ZERO         HCONN                                      MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   EVAL      QMNAME = wMQManager                                      MD041126
     C                   Z-ADD     *ZERO         HCONN                                      MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCONN( QMNAME : HCONN :                                 MD041126
     C                                     OCODE : REASON )                                 MD041126
      *
      ** Error processing
      *
     C                   IF        REASON <> RCNONE AND
     C                             REASON <> RC2002
     C                   MOVEL     'TIM0118'     ZAMSID
     C                   EXSR      SRSndMSG
     C                   EVAL      *IN23 = *ON
     C                   EVAL      WQueueOk = 'N'
     C                   ELSE
      *
     C                   EVAL      MQUEUE = SMSGQ
      *
      ** Set up MQSeries data necessary to open a queue
      *
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C     LoCase:UpCase XLATE     MQUEUE        ODON
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQOPEN        CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS                                       MD041126
     C**********         PARM                    HIN                                        MD041126
     C**********         PARM                    OCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
     C                                     HIN : OCODE : REASON )                           MD041126
      *
      ** Error processing
      *
     C                   IF        REASON <> RCNONE
     C                   MOVEL     'TIM0118'     ZAMSID
     C                   EXSR      SRSndMSG
     C                   EVAL      *IN23 = *ON
     C                   EVAL      WQueueOk = 'N'
     C                   ELSE
 
      **  Valid, move to file fields
 
     C                   MOVE      ODON          WEMSGQ
     C                   MOVE      ODON          WCMSGQ
     C                   EVAL      WQueueOk = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      **  Disconnect from the MQ Manager
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQDISC        CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdJRN - Initialize Journal Sequence Files if necessary    *
      *                                                               *
      *****************************************************************
     C     SRUpdJRN      BEGSR
 
      ** Update MXOLEJPD file
 
     C                   READ      MXOLEJPD
     C                   IF        %EOF(MXOLEJPD)
     C                   MOVEL     '0000000001'  I#LASTSEQ
     C                   WRITE     MXOLEJP0
     C                   ENDIF
 
      ** Update MXOLTJPD file
 
     C                   READ      MXOLTJPD
     C                   IF        %EOF(MXOLTJPD)
     C                   MOVEL     '0000000001'  I#LASTSEQ
     C                   WRITE     MXOLTJP0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdEXF - Update Format details                             *
      *                                                               *
      *****************************************************************
     C     SRUpdEXF      BEGSR
 
      **  Read MXEXFDPD file
 
     C                   READ      MXEXFDPD
     C                   DOW       NOT %EOF(MXEXFDPD)
 
      **  If Format Name is one of the following update Message Queue Name:
 
     C     EXFMT         IFEQ      'TISDTICS'
     C     EXFMT         OREQ      'TISDACOF'
     C     EXFMT         OREQ      'TISDACOD'
     C     EXFMT         OREQ      'TISDBSRT'
     C     EXFMT         OREQ      'TISDBSCD'
     C     EXFMT         OREQ      'TISDCTRY'
     C     EXFMT         OREQ      'TISDCURR'
     C     EXFMT         OREQ      'TISDINST'
     C     EXFMT         OREQ      'TIGROUP'
     C     EXFMT         OREQ      'TISDNOST'
     C     EXFMT         OREQ      'TISDDELR'
     C     EXFMT         OREQ      'TIGROUP2'
     C     EXFMT         OREQ      'TISDFXRT'
     C     EXFMT         OREQ      'TISDSPOT'
     C     EXFMT         OREQ      'TISDDFNO2'
     C     EXFMT         OREQ      'TISDACOD2'                                              MD030926
     C     EXFMT         OREQ      'TISDBSHS'                                               MD031150
     C     EXFMT         OREQ      'TISDACOD3'                                              MD031372
 
      **  Update the record
 
     C                   EVAL      EXMSGQ = WEMSGQ
 
     C                   UPDATE    MXEXFDP0
     C                   ENDIF
 
     C                   READ      MXEXFDPD
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdCOM - Update Composite ID details                       *
      *                                                               *
      *****************************************************************
     C     SRUpdCOM      BEGSR
 
      **  Read MXCOMDPD file
 
     C                   READ      MXCOMDPD
     C                   DOW       NOT %EOF(MXCOMDPD)
 
      **  If Composite ID is one of the following update Message Queue Name:
 
     C     CDCOMI        IFEQ      'TIABRC'
     C     CDCOMI        OREQ      'TIDFNO'
     C     CDCOMI        OREQ      'TIBRCH'
     C     CDCOMI        OREQ      'TICCAL'
     C     CDCOMI        OREQ      'TICCAL2'
     C     CDCOMI        OREQ      'TIBCAL'
     C     CDCOMI        OREQ      'TIBCAL2'
     C     CDCOMI        OREQ      'TICCYCAL'
     C     CDCOMI        OREQ      'TIDLCAL'
 
      **  Update the record
 
     C                   EVAL      CDMSGQ = WCMSGQ
 
     C                   UPDATE    MXCOMDP0
     C                   ENDIF
 
     C                   READ      MXCOMDPD
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRReset - Clears Input screen
      *
      *****************************************************************
     C     SRReset       BEGSR
 
      ** Clear Error Indicators
 
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN05 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
 
      ** Reset Input Fields
 
     C                   EVAL      SMSGQ = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRClrMSG - Routine to clear program's message queue.
      *
      *****************************************************************
     C     SRClrMSG      BEGSR
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRSndMSG - Routine to send messages to message subfile.
      *
      *****************************************************************
     C     SRSndMSG      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   EVAL      PGMNAM =  PSProcMod
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Convert Rundate to date
 
     C                   CALL      'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM                    ZDATEP
     C                   PARM      *BLANK        ZADATE
 
     C                   MOVE      ZDATEP        Rundate
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      MQManager     PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = PSysVal01
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      wMQManager = PCurSet01
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
