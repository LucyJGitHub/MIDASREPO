     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Intermediary Institution (Cover)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOCIN  - Validate OP Intermediary Institution (Cover)      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. MD000091           Date 06May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  MD000091 - Event Codes Substitution                          *
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

     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)

      ** Incoming Transaction
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPAYPD)
     D NwOPFilFmx    E DS                  EXTNAME(FTVOPY2PD)

      ** Cover Message
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)

      * Flags to indicate whether transaction fields are valid
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)

      ** Externally described DS for SAR details
     D* CSARD        E DS                  EXTNAME(SCSARDPD)

      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)

      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)

      ** Intermediary Institution data structure
     D INTINS          DS           175
     D  WCIB1                  1     35
     D  WCIB2                 36     70
     D  WCIB3                 71    105
     D  WCIB4                106    140
     D  WCIB5                141    175
      ** Account Institution data structure
     D ACTINS          DS           175
     D  WCAB1                  1     35
     D  WCAB2                 36     70
     D  WCAB3                 71    105
     D  WCAB4                106    140
     D  WCAB5                141    175

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
     D CLSWTK          S             12A

      ** Fields used for SWIFT validation
     D ADLINE          S              1A
     D ADSLON          S              1A
     D ##CSID          S              1A

      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
     C                   ExSr      VOCIN
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKCIB1 = 'N'
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2CIB1 = SCIB1
     C                   Eval      O2CIB2 = SCIB2
     C                   Eval      O2CIB3 = SCIB3
     C                   Eval      O2CIB4 = SCIB4
     C                   Eval      O2CIB5 = SCIB5
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOCIN - Validate Intermediary Institution (Cover)
      *****************************************************************
      *
     C     VOCIN         Begsr
      *
     C                   Eval      O2CIBT = *Blanks
      *
     C                   Eval      WCIB1 = SCIB1
     C                   Eval      WCIB2 = SCIB2
     C                   Eval      WCIB3 = SCIB3
     C                   Eval      WCIB4 = SCIB4
     C                   Eval      WCIB5 = SCIB5
      *
     C                   Eval      WCAB1 = SCAB1
     C                   Eval      WCAB2 = SCAB2
     C                   Eval      WCAB3 = SCAB3
     C                   Eval      WCAB4 = SCAB4
     C                   Eval      WCAB5 = SCAB5
      *
     C                   If        SOMVLF = 'COV'
      *
      ** Intermediary Institution (Cover) can only be entered for
      ** Validation Flag(Main) COV
      *
     C                   ElseIf    INTINS <> *Blanks
     C                   Eval      OKCIB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCIB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00262'
     C                   LeaveSr
     C                   EndIf
      *
     C                   If        INTINS <> *Blanks
      *
     C                   If        ACTINS = *Blanks
     C                   Eval      OKCIB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCIB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00267'
     C                   LeaveSr
     C                   EndIf
      *
     C                   Eval      ADDRSS = INTINS
      *
      ** Validate SWIFT Address
      *
     C                   If        (ADCH26 = *Blanks And
     C                             ADEXSW  = *Blanks And
     C                             ADSLSH  <> '/')
     C                             Or
     C                             (ADCH36 = *Blanks And
     C                             ADEXS2  = *Blanks And
     C                             ADSLSH  = '/'     And
     C                             ADCHK2 <> *Blanks And
     C                             ADSLS2 <> '/')
      *
     C                   ExSr      VSWFT
      *
      ** Exit if error found
      *
     C                   If        OKCIB1 = 'N'
     C                   LeaveSr
     C                   EndIf
     C                   EndIf
      *
      ** Validate Address
      *
     C                   ExSr      VADDR
      *
     C                   EndIf
      *
     C                   EndSr

     C*****************************************************************
      /EJECT
      *****************************************************************
      * VSWFT - Validate SWIFT Address
      *****************************************************************
      *
     C     VSWFT         BegSr
      *
      ** First 11 characters should be key for CLSWT.
      *
     C                   Eval      CLSWTK = SCIB1
      *
     C                   If        SCIB2 <> *Blanks
     C                   Eval      CLSWTK = SCIB2
     C                   EndIf
      *
     C                   ExSr      SWIFT
      *
     C                   If        ##CSID = 'Y'
      *
      ** Invalid SWIFT characters found
      *
     C                   If        *IN31 = *ON
     C                   Eval      OKCIB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCIB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00190'
     C                   LeaveSr
     C                   EndIf
      *
      ** BIC directory is not loaded
      *
     C                   If        *IN32 = *ON
     C                             And *IN31 = *OFF
     C                   Eval      OKCIB1 = 'W'
     C                   Eval      WIX = WIX + 1
     C                   Eval      WFldNmXAr(WIX) = 'SCIB1'
     C**********         Eval      WMsgDtaXAr(WIX) = SCIB1                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIB1))                                MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(SCIB1)                   MD000091
     C                   Eval      WMsgIDXAr(WIX)  = 'ME00191'
     C                   EndIf
      *
     C                   Eval      O2CIB1 = SCIB1
     C                   Eval      O2CIB2 = SCIB2
     C                   Eval      O2CIB3 = SCIB3
     C                   Eval      O2CIB4 = SCIB4
     C                   Eval      O2CIB5 = SCIB5
     C                   Eval      O2CIBT = 'S'
      *
      ** Exit if Intermediary Institution (Cover) is a SWIFT Address
      *
     C                   Return
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
      ** Send error if Address line starts with "/" but no second line entered
      *
     C                   If        *IN91 = *ON
     C                             And SCIB2 = *BLANKS
     C                   Eval      OKCIB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCIB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00192'
     C                   EndIf
      *
      ** Send error if 5th line entered but 1st line not starting with "/"
      *
     C                   If        *IN91 = *ON
     C                             And SCIB5 <> *Blanks
     C                   Eval      OKCIB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCIB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00182'
     C                   EndIf
      *
      ** Send error if Embedded blank lines exist
      *
     C                   If        *IN92 = *ON
     C                   Eval      OKCIB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCIB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00193'
     C                   EndIf
      *
      ** Send error if Invalid SWIFT character found
      *
     C                   If        AD#1 = 'Y' Or
     C                             AD#2 = 'Y' Or
     C                             AD#3 = 'Y' Or
     C                             AD#4 = 'Y' Or
     C                             AD#5 = 'Y'
     C                   Eval      OKCIB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCIB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCIB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCIB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCIB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00194'
     C                   EndIf
      *
     C                   Eval      O2CIBT = 'A'
      *
     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTSWFTCLE
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
      *
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
**  Alpha - Array of alphabetic characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of numeric characters
0123456789
