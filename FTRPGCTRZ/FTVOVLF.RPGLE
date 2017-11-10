     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Incoming Validation Flag')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOMTP  - Validate OP Incoming Validation Flag              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG24396           Date 26Jun09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  BUG24396 - Error on FTVOCBN                                  *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)

      * Incoming Transaction
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPAYPD)
     D NwOPFilFmx    E DS                  EXTNAME(FTVOPY2PD)

      ** Cover message
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)

      * Flags to indicate whether transaction fields are valid
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIX             S              3P 0

     D PRTCD           S              7A
     D POPTN           S              7A
     D PMTPY           S              3A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *
      ** Initialization
      *
     C                   Eval      RetCodeIn  = *BLANKS
     C                   Eval      FldNamXAr  = *BLANKS
     C                   Eval      MsgIDXAr   = *BLANKS
     C                   Eval      MsgDtaXAr  = *BLANKS
     C                   Eval      WFldNmXAr  = *BLANKS
     C                   Eval      WMsgIDXAr  = *BLANKS
     C                   Eval      WMsgDtaXAr = *BLANKS
     C                   Eval      WIX = 0
     C                   Eval      Idx = 0

      ** Validate
     C                   Exsr      VOVLF

      ** If an error was found, set the return code appropriately
      *
     C**********         If        OKMTPY = 'N'                                             BUG24396
     C                   If        OKVALF = 'N'                                             BUG24396
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2VALF = SVALF
     C                   EndIf

      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOVLF - Validate Incoming Validation Flag
      *****************************************************************
      *
     C     VOVLF         BegSr
      *
     C                   If        SVALF <> *Blanks

     C                   If        SNWRK <> 'SWIFT'
     C                   Eval      OKVALF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SVALF'
     C                   Eval      MsgDtaXAr(IDX) = SVALF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00254'
     C                   Else
     C                   If        SMTPY <> '102'
     C                                  And SMTPY <> '103'
     C                                  And SMTPY <> '202'
     C                                  And SMTPY <> '205'
     C                   Eval      OKVALF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SVALF'
     C                   Eval      MsgDtaXAr(IDX) = SVALF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00254'
     C                   EndIf
     C                   EndIf

     C                   If        SNWRK = 'SWIFT'
     C                             And SMTPY = '102'
     C                   If        SVALF <> 'STP'
     C                   Eval      OKVALF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SVALF'
     C                   Eval      MsgDtaXAr(IDX) = SVALF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00255'
     C                   EndIf
     C                   EndIf

     C                   If        SNWRK = 'SWIFT'
     C                             And SMTPY = '103'
     C                   If        SVALF <> 'STP'
     C                             And SVALF <> 'REMIT'
     C                   Eval      OKVALF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SVALF'
     C                   Eval      MsgDtaXAr(IDX) = SVALF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00253'
     C                   EndIf
     C                   EndIf

     C                   If        SNWRK = 'SWIFT'
     C                             And (SMTPY = '202'
     C                                  Or SMTPY = '205')
     C                   If        SVALF <> 'COV'
     C                   Eval      OKVALF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SVALF'
     C                   Eval      MsgDtaXAr(IDX) = SVALF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00172'
     C                   EndIf
     C                   EndIf

     C                   If        SVALF = 'COV'
     C                   If        OTRLPR = *Blanks
     C                   Eval      OKVALF = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SVALF'
     C                   Eval      MsgDtaXAr(IDX) = SVALF
     C                   Eval      MsgIDXAr(Idx)  = 'ME00174'
     C                   EndIf
     C                   EndIf

     C                   EndIf

     C                   EndSr
     C*****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BegSr

     C     *Entry        PList

     C                   Parm                    RetCodeIn
     C                   Parm                    NwOPFilFmt
     C                   Parm                    NwOPFilFmx
     C                   Parm                    NwOPAScnFmt
     C                   Parm                    FTEOPYA
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   EndSr
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
