     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate MQ queue name')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009626 - Validate MQ Queue Name                            *
      *                                                               *
      *  Function:  This program validates MQ queue WLCQueueName      *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 06Mar20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSD083  *CREATE    Date 27May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055270.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D MQManager       C                   Const('WLCQueueManagerName')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      **  Declare MQI structures needed
      * MQI Constants
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
      *
      ** Object Descriptor
     D MQOD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
      **
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
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
     D PRTCD           S              7A
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
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
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
     C                   ADD       1             Idx
     C                   MOVEL     'USR9838'     MsgIDXArr(Idx)
     C                   EVAL      GenError = 'Y'
     C                   ENDIF
      *
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C                   EVAL      ODON = QName
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
     C                   ADD       1             Idx
     C                   MOVEL     'USR9839'     MsgIDXArr(Idx)
     C                   EVAL      GenError = 'Y'
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
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOSVALR0                                               *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    SystemValue
     C                   PARM                    QName
     C                   PARM                    ProcMode
     C                   PARM                    GenError
     C                   PARM                    Idx
     C                   PARM                    MsgIDXArr
      *
     C                   CALLB     'AOSVALR0'
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
      *
      *****************************************************************
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
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
