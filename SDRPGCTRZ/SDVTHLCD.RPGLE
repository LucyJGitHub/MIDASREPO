     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SK Customer PUMA II dtl-CAB Code Field Val')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTHLCD - CAB Code Field Validation                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD059377           Date 28Sep22               *
      *  Prev Amend No. LUC139             Date 22Dec20               *
      *                 BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059377 - use PHlcd (CAB Code) instead of                   *
      *             PHlck (CAB Code Check digit)                      *
      *  LUC139 - UCI Italian Returns Upgrade to FM2.1                *
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

     D PHlcd           S              5A
     D PHlck           S              1A
     D PZAlignOk       S              1A
     D PZField         S             18A
     D PZADec          S              1P 0
     D PZADig          S              2P 0
     D PCAB            S              6A
     D PRtcd           S              7A
     D PBnbi           S              1A
     D PResi           S              1A

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

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr

     C                   EVAL      Idx  = 0
     C                   EVAL      WIdx = 0

      ** Validation
      ** CAB Code must not be blank if bank flag = 'Y' and
      ** residenza = 1
     C**                 IF        (PHlck = *BLANKS  OR                                     MD059377
     C**                           PHlck =  '0') AND                                        MD059377
     C                   IF        (PHlcd = *BLANKS  OR                                     MD059377
     C                             PHlcd =  '0') AND                                        MD059377
     C                             PBnbi = 'Y' AND
     C                             PResi = '1'
     C                   EVAL      RetCodeIn   =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTHLCD'
     C                   EVAL      MsgIdXAr(Idx) = 'ITS1135'
     C                   EVAL      DDTHlcdOk = 'N'                                          LUC139
     C                   RETURN
     C                   ENDIF

      ** Check if CAB Code is valid

     C                   IF        (PHlcd   =  *BLANKS  AND
     C                              PHlck  <>  *BLANKS)    OR
     C                             (PHlcd  <>  *BLANKS  AND
     C                              PHlck   =  *BLANKS)    OR
     C                             (PHlck   <  '0'      OR
     C                              PHlck   >  '9'    )
     C                   EVAL      RetCodeIn  =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTHLCD'
     C                   EVAL      MsgIdXAr(Idx) = 'ITS1133'
     C                   EVAL      DDTHlcdOk = 'N'                                          LUC139
     C                   RETURN
     C                   ELSE

      ** Check if numeric

     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PZAlignOK
     C                   PARM      PHlcd         PZField
     C                   PARM      *ZEROS        PZADec
     C                   PARM      5             PZADig

     C                   IF        PZAlignOk <> 'Y'
     C                   EVAL      RetCodeIn   =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTHLCD'
     C                   EVAL      MsgIdXAr(Idx) = 'ITS1113'
     C                   EVAL      DDTHlcdOk = 'N'                                          LUC139
     C                   RETURN
     C                   ENDIF

     C                   ENDIF

      ** Check if CAB Code check digit is correct

     C                   EVAL      PCAB       =  PHlcd + PHlck
     C                   CALL      'SD0011U'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PCAB

     C                   IF        PRtcd     <>  *BLANKS
     C                   EVAL      RetCodeIn   =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTHLCD'
     C                   EVAL      MsgIdXAr(Idx) = 'ITS1133'
     C                   EVAL      DDTHlcdOk = 'N'                                          LUC139
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
     C                   PARM                    PHlcd
     C                   PARM                    PHlck
     C                   PARM                    PBnbi
     C                   PARM                    PResi

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTHlcdOk         1                     LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
