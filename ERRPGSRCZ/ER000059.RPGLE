     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas ER Update MX Files for Bundesbank')              *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000059 - Midas ER Update MX Files for Bundesbank           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 11May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD025621A          Date 04Apr14               *
      *                 MD025621           Date 31Mar14               *
      *                 AR690511*CREATE    Date 31Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055661.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025621A - Files are updated even when inputs did not pass  *
      *              validation.                                      *
      *  MD025621 - Include an optional MQ Manager Field.             *
      *  AR690511 - Rename from SM000059 to ER000059                  *
      *             (Child: AR690512)                                 *
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
 
      ** SM Update MX files for Bundesbank screen
 
     FER000059DFCF   E             WORKSTN INFSR(*PSSR)
 
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
     D ZAMSGF          S             10A   INZ('UTMSGF')
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
 
     D MQUEUE          S             48A
     D MQMGR           S             48A                                                    MD025621
     D***CID****         S              9P 0                                                MD041126
     D***HCONN**         S              9P 0                                                MD041126
     D***OPTS***         S              9P 0                                                MD041126
     D***HOBJ***         S              9P 0                                                MD041126
     D***OCODE**         S              9P 0                                                MD041126
     D***REASON*         S              9P 0                                                MD041126
     D HCONN           S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D HOBJ            S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
 
     D WEMSGQ          S                   LIKE(EXMSGQ)
     D WCMSGQ          S                   LIKE(CDMSGQ)
     D WEEXND          S                   LIKE(EXEXND)
     D WCEXND          S                   LIKE(CDEXND)
 
     D PRtcd           S              7A
     D POptn           S              7A
     D ErrorFlag       S              1A
     D Rundate         S              6S 0
     D WConfirm        S              1A   INZ('N')
     D WQueueOk        S              1A   INZ('N')
     D WMQMgrOk        S              1A   INZ('N')                                         MD025621
     D WDateOk         S              1A   INZ('N')
 
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
     C                             (WQueueOk = 'N' OR
     C                              WMQMgrOk = 'N' OR                                       MD025621
     C                              WDateOk = 'N')
 
      **  Display the screen
 
     C                   EXSR      SRDspSCRN
 
     C                   ENDDO
 
     C                   IF        *IN12 = *ON
     C                   EVAL      WConfirm = 'N'
     C                   EVAL      WQueueOk = 'N'
     C                   EVAL      WMQMgrOk = 'N'                                           MD025621
     C                   EVAL      WDateOk  = 'N'
     C                   EVAL      *IN28 = *OFF
     C                   ELSE
     C                   EVAL      WConfirm = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
      **  Update the MX Files
      **  only when the user confirms.                                                     MD025621A
 
     C                   IF        *IN03 <> *ON                                            MD025621A
     C                             AND *IN12 <> *ON                                        MD025621A
     C                             AND WConfirm = 'Y'                                      MD025621A
     C                   EXSR      SRUpdEXF
     C                   EXSR      SRUpdCOM
     C                   ENDIF                                                             MD025621A
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
 
     C                   IF        SEXND = *BLANKS
     C                   MOVE      Rundate       SEXND
     C                   ENDIF
 
     C                   EVAL      *IN90 = *OFF
 
     C                   WRITE     SM59MSGCTL
     C                   WRITE     SM59FOOT
     C                   EXFMT     SM59DETL
     C                   EXSR      SRClrMSG
 
      ** Not refresh or exit command, process input
 
     C                   IF        *IN03 <> *ON AND
     C                             *IN05 <> *ON
 
      **  Validate the fields
 
     C                   EXSR      SRValMSGQ
     C                   EXSR      SRValEXND
 
     C                   IF        WQueueOk = 'Y' AND
     C                             WMQMgrOk = 'Y' AND                                       MD025621
     C                             WDateOk = 'Y'
 
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN90 = *ON
     C                   WRITE     SM59MSGCTL
     C                   WRITE     SM59FOOT
     C                   EXFMT     SM59DETL
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
     C                   EVAL      *IN25  = *OFF                                            MD025261
 
     C                   IF        SMSGQ = *BLANKS
     C                   MOVEL     'LEF0016'     ZAMSID
     C                   EXSR      SRSndMSG
     C                   EVAL      *IN23 = *ON
     C                   EVAL      WQueueOk = 'N'
 
     C                   ELSE
 
     C                   EVAL      HCONN = HCDEFH                                           MD025621
     C                   EVAL      MQMGR = SMQMG                                            MD025621
     C                   EVAL      WMQMgrOk = 'Y'                                           MD025621
     C                   EVAL      ODMN = *BLANKS                                           MD025621
                                                                                            MD025621
      ** Connect to the queue manager                                                       MD025621
                                                                                            MD025621
     C                   IF        MQMGR <> *BLANKS                                         MD025621
                                                                                            MD025621
     C                   EVAL      ODMN = MQMGR                                             MD025621
     C**********         EVAL      CID = MQCONN                                    MD025621 MD041126
      **********                                                                   MD025621 MD041126
     C**********         CALL      'QMQM'                                          MD025621 MD041126
     C**********         PARM                    CID                               MD025621 MD041126
     C**********         PARM                    MQMGR                             MD025621 MD041126
     C**********         PARM                    HCONN                             MD025621 MD041126
     C**********         PARM                    OCODE                             MD025621 MD041126
     C**********         PARM                    REASON                            MD025621 MD041126
                                                                                            MD041126
     C                   CALLP     MQCONN( MQMGR : HCONN :                                  MD041126
     C                                     OCODE : REASON )                                 MD041126
                                                                                            MD025621
     C                   IF        OCODE =  CCFAIL                                          MD025621
     C                   MOVEL     'LEF0018'     ZAMSID                                     MD025621
     C                   EXSR      SRSndMSG                                                 MD025621
     C                   EVAL      *IN25 = *ON                                              MD025621
     C                   EVAL      WMQMgrOk = 'N'                                           MD025621
     C                   ENDIF                                                              MD025621
                                                                                            MD025621
     C                   ENDIF                                                              MD025621
                                                                                            MD025621
     C                   EVAL      MQUEUE = SMSGQ
 
      ** Set up MQSeries data necessary to open a queue
 
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C**********         EVAL      CID = MQOPEN                                             MD041126
 
      ** ODON is a subfield of the MQOD data structure, which holds the
      ** name of the queue to be opened.  It is declared in the CMQODR
      ** include member.
 
     C     LoCase:UpCase XLATE     MQUEUE        ODON
 
      ** It returns OCODE, a completion code, which tells us whether
      ** or not the call was successful, and REASON, which gives details
      ** if there was a failure.
 
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS                                       MD041126
     C**********         PARM                    HOBJ                                       MD041126
     C**********         PARM                    OCODE                                      MD041126
     C**********         PARM                    REASON                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
     C                                     HOBJ : OCODE : REASON )                          MD041126
 
      ** CCFAIL is a named constant containing the value for OCODE
      ** indicating a failure to open the queue.
 
     C                   IF        OCODE = CCFAIL
     C                   MOVEL     'LEF0014'     ZAMSID
     C                   EXSR      SRSndMSG
     C                   EVAL      *IN23 = *ON
     C                   EVAL      WQueueOk = 'N'
 
     C                   ELSE
 
      **  Valid, move to file fields
 
     C                   MOVE      ODON          WEMSGQ
     C                   MOVE      ODON          WCMSGQ
     C                   EVAL      WQueueOk = 'Y'
 
     C                   ENDIF
 
      **  Close MQ Queue
 
     C                   EVAL      OPTS = CONONE
     C**********         EVAL      CID = MQCLOS                                             MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID                                        MD041126
     C**********         PARM                    HCONN                                      MD041126
     C**********         PARM                    HOBJ                                       MD041126
     C**********         PARM                    OPTS                                       MD041126
     C**********         PARM      *ZERO         OCODE                                      MD041126
     C**********         PARM      *ZERO         REASON                                     MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCLOSE( HCONN : HOBJ : OPTS :                           MD041126
     C                                      OCODE : REASON )                                MD041126
                                                                                            MD025621
      ** Close Connection to MQ Manager                                                     MD025621
                                                                                            MD025621
     C                   IF        MQMGR <> *BLANKS                                         MD025621
     C**********         EVAL      CID = MQDISC                                    MD025621 MD041126
     C**********         CALL      'QMQM'                                          MD025621 MD041126
     C**********         PARM                    CID                               MD025621 MD041126
     C**********         PARM                    HCONN                             MD025621 MD041126
     C**********         PARM      *ZERO         OCODE                             MD025621 MD041126
     C**********         PARM      *ZERO         REASON                            MD025621 MD041126
                                                                                            MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
     C                   ENDIF                                                              MD025621
                                                                                            MD025621
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEXND - Validate Next Export Date                        *
      *                                                               *
      *****************************************************************
     C     SRValEXND     BEGSR
 
     C                   EVAL      *IN24  = *OFF
 
     C                   IF        SEXND <> *BLANKS
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     SEXND         ZFIELD
 
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRETURN
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      6             ZADIG
     C                   PARM                    ZAFLD
 
     C                   IF        ZRETURN <> *BLANKS
     C                   MOVEL     'LEF0015'     ZAMSID
     C                   EXSR      SRSndMSG
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WDateOk = 'N'
     C                   ELSE
 
     C                   MOVE(P)   ZAFLD         ZDATEP
 
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZRETURN
     C                   PARM                    ZDATEP
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM                    ZDAYNO
 
     C                   IF        ZRETURN <> *BLANKS
     C                   MOVEL     'LEF0015'     ZAMSID
     C                   EXSR      SRSndMSG
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WDateOk = 'N'
     C                   ELSE
     C                   IF        ZDAYNO < BJRDNB
     C                   MOVEL     'LEF0017'     ZAMSID
     C                   EXSR      SRSndMSG
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WDateOk = 'N'
     C                   ELSE
 
      **  Valid, move to file fields
 
     C                   Z-ADD     ZDAYNO        WEEXND
     C                   Z-ADD     ZDAYNO        WCEXND
     C                   EVAL      WDateOk = 'Y'
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      **  If left blank, default to Rundate
 
     C                   ELSE
 
     C                   Z-ADD     BJRDNB        WEEXND
     C                   Z-ADD     BJRDNB        WCEXND
     C                   MOVE      Rundate       SEXND
     C                   EVAL      WDateOk = 'Y'
 
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
 
     C     EXFMT         IFEQ      'ERERKNEIPD'
     C     EXFMT         OREQ      'ERSDCUSTPD'
     C     EXFMT         OREQ      'ERSDACUSPD'
     C     EXFMT         OREQ      'ERSDCTRYPD'
     C     EXFMT         OREQ      'ERERWHGIPD'
     C     EXFMT         OREQ      'ERSDCURRPD'
     C     EXFMT         OREQ      'ERERGSTIPD'
     C     EXFMT         OREQ      'ERERGSTSPD'
     C     EXFMT         OREQ      'ERERBILIPD'
     C     EXFMT         OREQ      'ERERKGLIPD'
     C     EXFMT         OREQ      'ERERZUSIPD'
     C     EXFMT         OREQ      'ERFCLTYFM'
     C     EXFMT         OREQ      'ERFCLTYFN'
     C     EXFMT         OREQ      'ERACCNTAB'
     C     EXFMT         OREQ      'ERERDVTIPD'
     C     EXFMT         OREQ      'ERDEALSDB'
     C     EXFMT         OREQ      'ERERDETTPD'
     C     EXFMT         OREQ      'EREOMSPD'
 
      **  Update the record
 
     C                   EVAL      EXMSGQ = WEMSGQ
     C                   EVAL      EXEXND = WEEXND
 
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
 
     C     CDCOMI        IFEQ      'ERKNEIFF'
     C     CDCOMI        OREQ      'ERWHGIFF'
     C     CDCOMI        OREQ      'ERZUSIFF'
     C     CDCOMI        OREQ      'ERDVTIFF'
 
      **  Update the record
 
     C                   EVAL      CDMSGQ = WCMSGQ
     C                   EVAL      CDEXND = WCEXND
 
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
     C                   EVAL      *IN25 = *OFF                                             MD025261
 
      ** Reset Input Fields
 
     C                   EVAL      SMSGQ = *BLANKS
     C                   EVAL      SMQMG = *BLANKS                                         MD025621A
     C                   MOVE      Rundate       SEXND
 
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
(c) Finastra International Limited 2011
