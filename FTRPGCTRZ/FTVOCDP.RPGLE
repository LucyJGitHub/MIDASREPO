     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Remittance Information (Cover)')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOCDP  - Validate OP Remittannce Information (Cover)       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
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
      ** Array of DDBtb?OK error indicators
     D #ERR            S                   DIM(6) LIKE(OKOCB1)

      ** Incoming Transaction
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPAYPD)
     D NwOPFilFmx    E DS                  EXTNAME(FTVOPY2PD)

      ** Cover Message
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)
     D NwOPCScnFmt   E DS                  EXTNAME(FTOPYCPD)

      ** Flags to indicate whether transaction fields are valid
     D FTEOPYC       E DS                  EXTNAME(FTEOPYCPD)

      ** Remittance Information data structure
     D RMTINF          DS           210
     D  WCDP1                  1     35
     D  WCDP2                 36     70
     D  WCDP3                 71    105
     D  WCDP4                106    140

      *
      /COPY FTCPYSRC,SFTVALCSLE
      *
      /COPY FTCPYSRC,SFTADDRILE
      *

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

      ** Work fields
     D ADLINE          S              1A
     D ADSLON          S              1A

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
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      FldNamXAr  = *Blanks
     C                   Eval      MsgIDXAr   = *Blanks
     C                   Eval      MsgDtaXAr  = *Blanks
     C                   Eval      WFldNmXAr  = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      WIX = 0
     C                   Eval      Idx = 0

      ** Validate
     C                   ExSr      VOCDP
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKCDP1 = 'N'
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2CDP1 = SCDP1
     C                   Eval      O2CDP2 = SCDP2
     C                   Eval      O2CDP3 = SCDP3
     C                   Eval      O2CDP4 = SCDP4
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOCDP - Validate Remittance Information (Cover)
      *****************************************************************
      *
     C     VOCDP         BegSr
      *
     C                   Eval      WCDP1 = SCDP1
     C                   Eval      WCDP2 = SCDP2
     C                   Eval      WCDP3 = SCDP3
     C                   Eval      WCDP4 = SCDP4
      *
     C                   if        SOMVLF = 'COV'
      *
      ** Remittance Information (Cover) can only be entered for
      ** Validation Flag(Main) COV
      *
     C                   ElseIf    RMTINF <> *Blanks
     C                   Eval      OKCDP1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCDP1'
     C                   Eval      MsgDtaXAr(IDX) = SCDP1
     C                   Eval      MsgIDXAr(Idx)  = 'ME00266'
     C                   LeaveSr
     C                   EndIf
      *
     C                   If        RMTINF <> *Blanks
      *
     C                   Eval      ADDRSS = RMTINF
      *
      ** Validate Address
      *
     C                   ExSr      VADDR
      *
     C                   EndIf
      *
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * VADDR - Validate Address
      *****************************************************************
      *
     C     VADDR         BegSr
      *
     C                   Eval      ADLINE = 'Y'
     C                   ExSr      ADCHK
      *
      ** Send error if Embedded blank lines exist
      *
     C                   If        *IN92 = *ON
     C                   Eval      OKCDP1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCDP1'
     C                   Eval      MsgDtaXAr(IDX) = SCDP1
     C                   Eval      MsgIDXAr(Idx)  = 'ME00215'
     C                   EndIf
      *
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRCLE
      *****************************************************************
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
     C                   Parm                    NwOPCScnFmt
     C                   Parm                    FTEOPYC
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
