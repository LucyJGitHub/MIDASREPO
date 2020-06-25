     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     MD041126
/*STD *  RPGBASEMOD                                                   *                     MD041126
/*EXI *  TEXT('Midas SD Validate MQ Queue Name')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009676 - Validate MQ Queue Name for existence              *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 24Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055945.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
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
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
 
      ** Object Descriptor
     D MQOD            DS
     D****/COPY*QMQM/QRPGLESRC,CMQODR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Queue Name
     D QName           DS           200
     D  MQNAME                 1     48
 
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
 
     D***P@CID**         S              9P 0                                                MD041126
     D***P@Conn*         S              9P 0                                                MD041126
     D***P@In***         S              9P 0                                                MD041126
     D***P@Opts*         S              9P 0                                                MD041126
     D***P@Code*         S              9P 0                                                MD041126
     D***P@Resn*         S              9P 0                                                MD041126
     D P@Conn          S             10I 0                                                  MD041126
     D P@In            S             10I 0                                                  MD041126
     D P@Opts          S             10I 0                                                  MD041126
     D P@Code          S             10I 0                                                  MD041126
     D P@Resn          S             10I 0                                                  MD041126
     D P@MQMgr         S             48A
 
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200
     D PRtCd           S              7
 
     D PCommand        S            256A
     D PLength         S             15P 5
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **  Convert the Queue Name to upper case
     C     LoCase:UpCase XLATE     MQNAME        QNameUC          48
 
      ** Open MQ/Series Queue
      ** --------------------
 
     C                   EXSR      SR_OPEN
 
 
      ** Close MQ/Series Queue
      ** ---------------------
 
     C                   EXSR      SR_CLOSE
 
      ** Normal end processing
 
     C                   EVAL      *INLR      = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_OPEN - Open MQ Series Queue                               *
      *                                                               *
      *****************************************************************
     C     SR_OPEN       BEGSR
 
      ** Use default connection handle, and implicit connection
 
     C                   EVAL      P@CONN = HCDEFH
 
     C                   EVAL      ODMN = P@MQMgr
     C**********         EVAL      P@CID = MQCONN                                           MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    P@CID                                      MD041126
     C**********         PARM                    P@MQMgr                                    MD041126
     C**********         PARM                    P@CONN                                     MD041126
     C**********         PARM                    P@CODE                                     MD041126
     C**********         PARM                    P@RESN                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQCONN( P@MQMgr : P@CONN :                               MD041126
     C                                     P@CODE : P@RESN )                                MD041126
     C
     C                   IF        P@CODE =  CCFAIL
     C                   EVAL      GenError = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Queue name
 
     C                   EVAL      ODON = QNameUC
 
      ** Open options: OUTPUT and FAIL_IF_QUIESCING
 
     C                   EVAL      P@Opts = OOOUT  +
     C                                      OOFIQ
 
      ** Open queue
 
     C**********         EVAL      P@CID = MQOPEN                                           MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    P@CID                                      MD041126
     C**********         PARM                    P@Conn                                     MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    P@Opts                                     MD041126
     C**********         PARM                    P@In                                       MD041126
     C**********         PARM                    P@Code                                     MD041126
     C**********         PARM                    P@Resn                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( P@CONN : MQOD : P@OPTS :                         MD041126
     C                                     P@IN : P@CODE : P@RESN )                         MD041126
 
      ** If open queue failed, indicate abnormal end
 
     C                   IF        P@RESN <>  RCNONE
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INLR    = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_CLOSE - Close MQ Series Queue                             *
      *                                                               *
      *****************************************************************
     C     Sr_Close      BEGSR
 
      ** Close options: NONE
 
     C                   EVAL      P@OPTS = CONONE
 
      ** Close queue
 
     C**********         EVAL      P@CID = MQCLOS                                           MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    P@CID                                      MD041126
     C**********         PARM                    P@Conn                                     MD041126
     C**********         PARM                    P@In                                       MD041126
     C**********         PARM                    P@Opts                                     MD041126
     C**********         PARM                    P@Code                                     MD041126
     C**********         PARM                    P@Resn                                     MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( P@CONN : P@IN : P@OPTS :                        MD041126
     C                                      P@CODE : P@RESN )                               MD041126
 
      ** If close queue failed, indicate abnormal end
 
     C                   IF        P@RESN <>  RCNONE
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INLR    = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    QName
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
 
      ** Use queue name defined in system values.
 
     C                   EVAL      P@OP01 = 'PEAHandShakingQM'
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      *BLANKS       P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM      *BLANKS       P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      *BLANKS       P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      *BLANKS       P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM      *BLANKS       P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM      *BLANKS       P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10
 
     C                   IF        PRtCd <>  *BLANKS
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     P@OP01        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      P@MQMgr = P@VL01
     C                   EVAL      GenError = ' '
 
      ** Ensure that QMQM exist in library list.
     C                   EVAL      PCommand = 'ADDLIBLE QMQM *LAST'
     C                   EVAL      PLength = %LEN( %TRIM( PCommand ) )
 
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    PCommand
     C                   PARM                    PLength
 
     C                   ENDSR
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
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
