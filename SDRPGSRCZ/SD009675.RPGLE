     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate Message queue')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009675 - Validate Message Queue for existence              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG23329           Date 02Apr09               *
      *                 BUG21587 *CREATE   Date 07Nov08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23329 - GFMessageQueue Invalid Error Message              *
      *  BUG21587 - Validate that the value supplied relates to a     *
      *             Websphere Message Queue that actually exists.    *
      *****************************************************************
      ** D-specs
      ** =======
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Declare MQI structures needed
      * MQI Constants
     D/COPY QMQM/QRPGLESRC,CMQR
 
      ** Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODR
 
      ** Parameter section for QWCRSSTS (Retrieve System Info) API
     D  SysIRcv        DS            80
     D  SysName                       8A   Overlay(SysIRcv:17)
     D  SysILen        S             10I 0 Inz(%Len(SysIRcv))
     D  SysIFormat     S              8A   Inz('SSTS0100')
     D  SysIReset      S             10A   Inz('*YES')
 
      ** General error code structure for APIs
     D  ErrorCode      DS            16
     D  ByteIn                       10I 0 Inz(%Len(ErrorCode))
     D  ByteRet                      10I 0
     D Qwcrssts        PR                  ExtPgm('QWCRSSTS')
     D                               80A
     D                               10I 0
     D                                8A
     D                               10A
     D                               16A
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Queue Manager
     D QManager        DS           200
     D  MQMGR                  1     48
 
      ** Message Queue Name
     D MessageQueue    DS           200
     D  MQUEUE                 1     48
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D ProcMode        S            190
 
      ** General error indicator
     D GenError        S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** For case translation
     D UpCase          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D LoCase          C                   'abcdefghijklmnopqrstuvwxyz'
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
      *
      ** Parameters for AOSVALR0
      *
     D PSysValK1       S             20A
     D PCurSet1        S            200A
     D PSysValK2       S             20A
     D PCurSet2        S            200A
     D PSysValK3       S             20A
     D PCurSet3        S            200A
     D PSysValK4       S             20A
     D PCurSet4        S            200A
     D PSysValK5       S             20A
     D PCurSet5        S            200A
     D PSysValK6       S             20A
     D PCurSet6        S            200A
     D PSysValK7       S             20A
     D PCurSet7        S            200A
     D PSysValK8       S             20A
     D PCurSet8        S            200A
     D PSysValK9       S             20A
     D PCurSet9        S            200A
     D PSysValK10      S             20A
     D PCurSet10       S            200A
     D WSysVal1        C                   CONST('MQQueueManagerAPI')
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Call to AOSVALR0 to verify MQQueueManagerAPI
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    PRtcd             7
     C                   PARM      WSysVal1      PSysValK1
     C                   PARM      *Blanks       PCurset1
     C                   PARM      *Blanks       PSysValK2
     C                   PARM      *Blanks       PCurset2
     C                   PARM      *Blanks       PSysValK3
     C                   PARM      *Blanks       PCurset3
     C                   PARM      *Blanks       PSysValK4
     C                   PARM      *Blanks       PCurset4
     C                   PARM      *Blanks       PSysValK5
     C                   PARM      *Blanks       PCurset5
     C                   PARM      *Blanks       PSysValK6
     C                   PARM      *Blanks       PCurset6
     C                   PARM      *Blanks       PSysValK7
     C                   PARM      *Blanks       PCurset7
     C                   PARM      *Blanks       PSysValK8
     C                   PARM      *Blanks       PCurset8
     C                   PARM      *Blanks       PSysValK9
     C                   PARM      *Blanks       PCurset9
     C                   PARM      *Blanks       PSysValK10
     C                   PARM      *Blanks       PCurset10
      *
     C                   IF        PRtcd <> *Blanks and
     C                             PRtcd <> '*NRF'  or
     C                             PCurset1 = *Blanks
      * Retrieve System Name
     C                   CALL      'SDC009675'
     C                   PARM                    PSysNme          10
     C                   EVAL      PCurset1 = PSysNme
 
     C                   ENDIF
      *
      **  Convert the Queue Manager name to upper case
      *
     C     LoCase:UpCase XLATE     PCurset1      QManagerUC       48
 
      **  Attempt to CONNECT to the MQ Manager
      *
     C                   CALL      'QMQM'
     C                   PARM      MQCONN        CID               9 0
     C                   PARM      QManagerUC    QMNAME           48
     C                   PARM      *ZERO         HCONN             9 0
     C                   PARM      *ZERO         OCODE             9 0
     C                   PARM      *ZERO         REASON            9 0
 
      ** Error processing
     C     REASON        IFNE      RCNONE
     C     REASON        ANDNE     RC2002
 
     C                   ADD       1             Idx
     C                   MOVEL     'USR9838'     MsgIDXArr(Idx)
     C                   EVAL      GenError = 'Y'
 
     C                   ELSE
      *
      ** Set up MQSeries data necessary to open a queue
      *
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C                   EVAL      CID = MQOPEN
 
      ** ODON is a subfield of the MQOD data structure, which holds the
      ** name of the queue to be opened.  It is declared in the CMQODR
      ** include member.
     C     LoCase:UpCase XLATE     MQueue        ODON
 
      ** It returns OCODE, a completion code, which tells us whether
      ** or not the call was successful, and REASON, which gives details
      ** if there was a failure.
     C                   CALL      'QMQM'
     C                   PARM                    CID               9 0
     C                   PARM                    HCONN             9 0
     C                   PARM                    MQOD
     C                   PARM                    OPTS              9 0
     C                   PARM                    HOBJ              9 0
     C                   PARM                    OCODE             9 0
     C                   PARM                    REASON            9 0
 
 
      ** CCFAIL is a named constant containing the value for OCODE
      ** indicating a failure to open the queue.
      *
     C                   IF        OCODE = CCFAIL
     C                   Eval      Idx = Idx + 1
     C**********         EVAL      MsgIDXArr(Idx)  = 'USR8009'                              BUG23329
     C                   EVAL      MsgIDXArr(Idx)  = 'USR8011'                              BUG23329
     C                   EVAL      GenError = 'Y'
     C                   ENDIF
 
 
      **  DisConnect from the MQ Manager
      *
     C                   CALL      'QMQM'
     C                   PARM      MQDISC        CID               9 0
     C                   PARM                    HCONN
     C                   PARM      *ZERO         OCODE
     C                   PARM      *ZERO         REASON
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    MessageQueue
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
 
     C                   EVAL      GenError = ' '
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
