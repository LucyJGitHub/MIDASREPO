     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cust PUMA II dtl-Fin Counterparty Fld Val')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTABI - ABI Code Field Validation                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 22Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns upgrade to FM 2.1 (Recompile)   *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

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
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
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

     D PABI            S              5A
     D PABIK           S              1A
     D DDTabikOk       S              1A                                                  LUC139
     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZADec          S              1P 0
     D PZADig          S              2P 0
     D PCABI           S              6A
     D PRtcd           S              7A

     D Idx             S              3P 0
     D WIdx            S              3P 0
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

     C                   MOVE      *BLANK        RetCodeIn

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr

     C                   EVAL      Idx  = 0
     C                   EVAL      WIdx = 0

      ** Validation
      ** Check if ABI Code is Valid

     C                   IF        (PABI     =  *BLANK    AND
     C                              PABIK   <>  *BLANK)    OR
     C                             (PABI    <>  *BLANK    AND
     C                              PABIK    =  *BLANK)    OR
     C                             (PABIK    <  '0'        OR
     C                              PABIK    >  '9'    )
     C                   EVAL      RetCodeIn  = 'Error'
     C                   EVAL      Idx        = Idx + 1
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1134'
     C                   EVAL      FldNamXAr(Idx) = 'DDTABI'
     C                   EVAL      DDTABIKOk = 'N'                                        LUC139

     C                   ELSE

      ** Check if numeric

     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZAlignOK
     C                   PARM      PABI          PZField
     C                   PARM      *ZEROS        PZADec
     C                   PARM      5             PZADig

      ** Check if the Return code and process

     C                   IF        PZAlignOk <> 'Y'
     C                   EVAL      RetCodeIn  = 'Error'
     C                   EVAL      Idx        = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'ITS1134'
     C                   EVAL      FldNamXAr(Idx) = 'DDTABI'
     C                   EVAL      DDTABIKOk = 'N'                                        LUC139
     C                   ENDIF

     C                   ENDIF

      ** If Initial Validation Pass, Check if ABI Code is Valid

     C                   IF        RetCodeIn  =  *BLANK
     C                   EVAL      PCABI      =  PABI + PABIK

     C                   CALL      'SD0011U'
     C                   PARM                    PRtcd
     C                   PARM                    PCABI

     C                   IF        PRtcd     <> *BLANK
     C                   EVAL      RetCodeIn  =  'Error'
     C                   EVAL      Idx        =  Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'ITS1134'
     C                   EVAL      FldNamXAr(Idx) = 'DDTABI'
     C                   EVAL      DDTABIKOk = 'N'                                        LUC139
     C                   ENDIF

     C                   ENDIF

     C                   IF        (PABI     =  '00000'   and
     C                              PABIK    =  *BLANK)    or
     C                             (PABI     =  *BLANK    and
     C                              PABIK    =  *ZEROS)
     C                   EVAL      RetCodeIn  =  'Error'
     C                   EVAL      Idx        =  Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'ITS1136'
     C                   EVAL      FldNamXAr(Idx) = 'DDTABI'
     C                   EVAL      DDTABIKOk = 'N'                                        LUC139
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

      ** INPUTS
      ** Return Code

     C                   PARM                    RetCodeIn
     C                   PARM                    PABI
     C                   PARM                    PABIK

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTAbikOk                                  LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
