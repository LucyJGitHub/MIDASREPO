     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate MQ queue manager')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009625 - Validate MQ Queue Manager for existence           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 245310  *CREATE    Date 30Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245310 - validate that the value supplied relates to a       *
      *           Websphere MQ Queue Manager that actually exists.    *
      *           Note that if this value is not set then most Midas  *
      *           programs will default to using the default MQ       *
      *           queue manager and connection. Note that if any      *
      *           module requires its own queue manager then its      *
      *           id will need to be held and used within the module  *
      *           or a new system value will need to be introduced    *
      *           to hold the details                                 *
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
 
      ** For case translation
     D UpCase          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D LoCase          C                   'abcdefghijklmnopqrstuvwxyz'
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Queue Manager
     D QManager        DS           200
     D  MQMGR                  1     48
 
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
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **  Convert the Queue Manager name to upper case
     C     LoCase:UpCase XLATE     MQMGR         QManagerUC       48
 
      **  Attempt to CONNECT to the MQ Manager
      *              ~~~~~~~
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
 
     C                   EVAL      MQMGR = QManagerUC
 
     C                   ENDIF
 
      **  DISCONNECT from the MQ Manager
      *
     C                   CALL      'QMQM'
     C                   PARM      MQDISC        CID               9 0
     C                   PARM                    HCONN
     C                   PARM      *ZERO         OCODE
     C                   PARM      *ZERO         REASON
 
 
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
     C                   PARM                    QManager
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
