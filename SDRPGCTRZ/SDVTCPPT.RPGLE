     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SK Cust PUMA II dtl-Counterparty Partcption')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTCPPT - Counterparty Participation Field Validation       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD058097           Date 12May21               *
      *  Prev Amend No. LUC139             Date 22Dec20               *
      *                 BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058097 - Set PCppt = Blanks if EQ to Zeros                 *
      *  LUC139 - UCI Italian Returns Upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - PUMA II Upgrade to MidasPlus                        *
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
     D PCppt           S              2A
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
      ** Check value of PCppt

     C                   IF        %Subst(PCppt:1:1) = '?'
     C                   EVAL      PField  = '?'
     C                   ELSE
     C**********         Eval      PField = PCppt                                        MD058097
      * Initialise to Blanks if equal Zeros                                              MD058097
     C                   If        PCppt = *ZEROS                                        MD058097
     C                   Eval      PCppt = *Blanks                                       MD058097
     C                   EndIf                                                           MD058097
      *                                                                                  MD058097
     C                   Movel     PCppt         PField                                  MD058097
     C                   ENDIF

      ** Call SD Value List validation module

     C                   CALL      'AOFXTBR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY'        POption
     C                   PARM      'BAG'         PKeyFld
     C                   PARM                    PField
     C     IRFXTB        PARM      IRFXTB        DSFDY

      ** Check if the Return code and process

     C                   IF        PRetCode <> *Blanks
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCPPT'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1123'
     C                   EVAL      DDTCpptOk = 'N'                                          LUC139
     C                   ELSE
     C                   MOVEL     PField        PCppt
     C                   ENDIF

      ** Check if value is numeric

     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PZAlignOK
     C                   PARM      PCppt         PZField
     C                   PARM      *ZEROS        PZADec
     C                   PARM      2             PZADig

      ** Check if the Return code and process

     C                   IF        PZAlignOk <> 'Y'
     C                   EVAL      RetCodeIn  =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCPPT'
     C                   EVAL      MsgIdXAr(Idx) =  'ITS1127'
     C                   EVAL      DDTCpptOk = 'N'                                          LUC139
     C                   ENDIF

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
     C                   PARM                    PCppt

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCpptOk         1                        LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
