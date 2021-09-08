     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cust PUMA II dtl-Fin ID Fld Validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTFIID - Fin Counterparty ID Field Validation              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 23Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
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

     D PFiid           S              9A
     D PBnbi           S              1A
      ** Entry parameters

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
      ** Check if the PFiid is valid

     C                   IF        PBnbi     =  'N'  and
     C                             PFiid    <>  *Blanks
     C                   EVAL      RetCodeIn  =  'Error'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTFIID'
     C                   EVAL      MsgIDXAr(Idx)  = 'ITS1110'
     C                   EVAL      DDTFiidOk = 'N'                                         LUC139
     C                   ENDIF

      ** If blanks set to the default value

     C                   IF        PBnbi     =  'Y'  and
     C                             PFiid     =  *Blanks
     C                   If        PA004 =  '2'                                            LUC139
     C                   EVAL      PFiid     =  '7990001W0'
     C                   else                                                              LUC139
     C                   EVAL      RetCodeIn  =  'Error'                                   LUC139
     C                   EVAL      Idx = Idx + 1                                           LUC139
     C                   EVAL      FldNamXAr(Idx) = 'DDTFIID'                              LUC139
     C                   EVAL      MsgIDXAr(Idx)  = 'ITS1131'                              LUC139
     C                   EVAL      DDTFiidOk = 'N'                                         LUC139
     C                   Endif                                                             LUC139
     C                   ENDIF

     C                   movel     *Blanks       PFiid3            3                       LUC139
     C                   movel     PFiid         PFiid3                                    LUC139
     C                   IF        PBnbi = 'Y'  and                                        LUC139
     C                             PFiid3   <>  '000'   and                                LUC139
     C                             PA004 =  '1'                                            LUC139
     C                   EVAL      RetCodeIn  =  'Error'                                   LUC139
     C                   EVAL      Idx = Idx + 1                                           LUC139
     C                   EVAL      FldNamXAr(Idx) = 'DDTFIID'                              LUC139
     C                   EVAL      MsgIDXAr(Idx)  = 'ITS1130'                              LUC139
     C                   EVAL      DDTFiidOk = 'N'                                         LUC139
     C                   Endif                                                             LUC139

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
     C                   PARM                    PFiid
     C                   PARM                    PBnbi
     C                   PARM                    PA004             1                   LUC139

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTFiidOk         1                   LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
