     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cust PUMA II dtl - Reporting Filter')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTCURF - Reporting Filter Validation                       *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139  *Create    Date 23Dec20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns Upgrade to FM2.1                *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

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

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for SAR details

     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** Extenal DS for Internal Table

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRetCode        S              7A
     D POption         S              7A
     D PKeyFld         S              3A
     D PField          S             24A
     D DDTCURF         S              1A
     D PZAlignOk       S              1A
     D PZField         S             18A
     D PZADec          S              1P 0
     D PZADig          S              2P 0

     D Idx             S              3P 0
     D WIdx            S              3P 0
      ** Index for arrays of error message ids etc

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      PZField   = *BLANKS

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr

     C                   EVAL      Idx  = 0
     C                   EVAL      WIdx = 0

      ** Validation

     C                   If        DDTCurf = *Blanks
     C                   Eval      DDTCurf = '0'
     C                   Endif

      ** Check if value is numeric

     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PZAlignOK
     C                   PARM      DDTCurf       PZField
     C                   PARM      *ZEROS        PZADec
     C                   PARM      1             PZADig

      ** Check if the Return code and process

     C                   If        PZAlignOk <> 'Y'

     C                   Eval      RetCodeIn  =  'Error'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDTCURF'
     C                   Eval      MsgIdXAr(Idx) =  'ITS1121'
     C                   Eval      DDTCurfOk = 'N'                                       LUC139

     C                   else

      ** Call SD Value List validation module

     C                   CALL      'AOFXTBR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY'        POption
     C                   PARM      'BAF'         PKeyFld
     C                   PARM      DDTCURF       PField
     C     IRFXTB        PARM      IRFXTB        DSFDY

      ** Check if the Return code and process

     C                   If        PRetCode <> *Blanks
     C                   Eval      RetCodeIn = 'Error'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDTCURF'
     C                   Eval      MsgIdXAr(Idx)  = 'ITS1122'
     C                   Eval      DDTCurfOk = 'N'                                       LUC139
     C                   Endif

     C                   Endif
      ** Return

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Inputs
      ** Return Code

     C                   PARM                    RetCodeIn
     C                   PARM                    DDTCURF

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCURFOk         1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
