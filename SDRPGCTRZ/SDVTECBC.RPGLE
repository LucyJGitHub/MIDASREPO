     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SK Customer PUMA II dtl-Economical Brch Clas')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTECBC - Economical Branch Class Field Validation          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 23Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
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

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure

     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** External DS for Internal Table

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
     D PEcbc           S              3A
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

     C                   EXSR      SrInit

     C                   IF        %SUBST(PEcbc:1:1) = '?'
     C                   EVAL      PField    = '?'
     C                   ELSE
     C                   EVAL      PField    = PEcbc
     C                   ENDIF

     C                   IF        PEcbc = *Blanks                                      LUC139
     C                   EVAL      RetCodeIn  =  'Error'                                LUC139
     C                   EVAL      Idx = Idx + 1                                        LUC139
     C                   EVAL      FldNamXAr(Idx) = 'DDTECBC'                           LUC139
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1109'                           LUC139
     C                   EVAL      DDTEcbcOk = 'N'                                      LUC139
     C                   else                                                           LUC139

      ** Call SD Value List validation module

     C                   CALL      'AOFXTBR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY'        POption
     C                   PARM      'BBJ'         PKeyFld
     C                   PARM                    PField
     C     IRFXTB        PARM      IRFXTB        DSFDY

      ** Check the Return code and process

     C                   IF        PRetCode  <> *BLANKS
     C                   EVAL      RetCodeIn  =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTECBC'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1129'
     C                   EVAL      DDTEcbcOk = 'N'                                      LUC139

     C                   ELSE
     C                   MOVEL     PField        PEcbc
     C                   ENDIF

      ** Validation
      ** Check if value is numeric

     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PZAlignOK
     C                   PARM      PEcbc         PZField
     C                   PARM      0             PZADec
     C                   PARM      3             PZADig

      ** Check the Return code and process

     C                   IF        PZAlignOk <> 'Y'
     C                   EVAL      RetCodeIn  =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTECBC'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITS1109'
     C                   EVAL      DDTEcbcOk = 'N'                                      LUC139
     C                   RETURN
     C                   ENDIF
     C                   ENDIF                                                              LUC139

      ** Return to calling program

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation routine                              *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR

     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      PZField   = *BLANKS

     C                   MOVE      *BLANKS       FldNamXAr
     C                   MOVE      *BLANKS       MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr

     C                   EVAL      Idx  = 0
     C                   EVAL      WIdx = 0

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

      ** Inputs
      ** Return Code

     C                   PARM                    RetCodeIn
     C                   PARM                    PEcbc

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTEcbcOk         1                         LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
