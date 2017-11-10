     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Ordering Institution (Cover)')       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOCOB  - Validate OP Ordering Institution (Cover)          *
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
     D NwOPFilFmt    E DS                   EXTNAME(FTVOPAYPD)
     D NwOPFilFmx    E DS                   EXTNAME(FTVOPY2PD)

      ** Cover Message
     D NwOPAScnFmt   E DS                  EXTNAME(FTOPYAPD)

      * Flags to indicate whether transaction fields are valid
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)

      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)

      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)

      ** Ordering Institution data structure
     D ORDINS          DS           175
     D  WCOB1                  1     35
     D  WCOB2                 36     70
     D  WCOB3                 71    105
     D  WCOB4                106    140
     D  WCOB5                141    175

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

      ** Used for SWIFT validation
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
     C                   ExSr      VOCOB
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKCOB1 = 'N'
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2COB1 = SCOB1
     C                   Eval      O2COB2 = SCOB2
     C                   Eval      O2COB3 = SCOB3
     C                   Eval      O2COB4 = SCOB4
     C                   Eval      O2COB5 = SCOB5
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOCOB - Validate Ordering Institution (Cover)
      *****************************************************************
      *
     C     VOCOB         BegSr
      *
     C                   Eval      O2COBT = *Blanks
      *
     C                   Eval      WCOB1 = SCOB1
     C                   Eval      WCOB2 = SCOB2
     C                   Eval      WCOB3 = SCOB3
     C                   Eval      WCOB4 = SCOB4
     C                   Eval      WCOB5 = SCOB5
      *
     C                   If        SOMVLF = 'COV'
      *
      ** Ordering Institution (Cover) can only be entered for
      ** SWIFT 202 COV or SWIFT 205 COV
      *
     C                   ElseIf    ORDINS <> *Blanks
     C                   Eval      OKCOB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00259'
     C                   LeaveSr
     C                   EndIf
      *
     C                   If        ORDINS <> *Blanks
      *
     C                   Eval      ADDRSS = ORDINS
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
     C                   If        OKCOB1 = 'N'
     C                   LeaveSr
     C                   EndIf
     C                   EndIf
      *
      ** Validate Address
      *
     C                   ExSr      VADDR
      *
     C                   EndIf
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
     C                   Eval      CLSWTK = SCOB1
      *
     C                   If        SCOB2 <> *Blanks
     C                   Eval      CLSWTK = SCOB2
     C                   EndIf
      *
     C                   ExSr      SWIFT
      *
     C                   If        ##CSID = 'Y'
      *
      ** Invalid SWIFT characters found
      *
     C                   If        *IN31 = *ON
     C                   Eval      OKCOB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00184'
     C                   LeaveSr
     C                   EndIf
      *
      ** BIC directory is not loaded
      *
     C                   If        *IN32 = *ON
     C                             And *IN31 = *OFF
     C                   Eval      OKCOB1 = 'W'
     C                   Eval      WIX = WIX + 1
     C                   Eval      WFldNmXAr(WIX) = 'SCOB1'
     C**********         Eval      WMsgDtaXAr(WIX) = SCOB1                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOB1))                                MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(SCOB1)                   MD000091
     C                   Eval      WMsgIDXAr(WIX)  = 'ME00185'
     C                   EndIf
      *
     C                   Eval      O2COB1 = SCOB1
     C                   Eval      O2COB2 = SCOB2
     C                   Eval      O2COB3 = SCOB3
     C                   Eval      O2COB4 = SCOB4
     C                   Eval      O2COB5 = SCOB5
     C                   Eval      O2COBT = 'S'
      *
      ** Exit if Ordering Institution (Cover) is a SWIFT Address
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
     C                             And SCOB2 = *BLANKS
     C                   Eval      OKCOB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00186'
     C                   EndIf
      *
      ** Send error if 5th line entered but 1st line not starting with "/"
      *
     C                   If        *IN91 = *ON
     C                             And SCOB5 <> *Blanks
     C                   Eval      OKCOB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00182'
     C                   EndIf
      *
      ** Send error if Embedded blank lines exist
      *
     C                   If        *IN92 = *ON
     C                   Eval      OKCOB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00187'
     C                   EndIf
      *
      ** Send error if Invalid SWIFT character found
      *
     C                   If        AD#1 = 'Y' Or
     C                             AD#2 = 'Y' Or
     C                             AD#3 = 'Y' Or
     C                             AD#4 = 'Y' Or
     C                             AD#5 = 'Y'
     C                   Eval      OKCOB1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOB1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOB1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOB1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOB1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00188'
     C                   EndIf
      *
     C                   Eval      O2COBT = 'A'
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
     C*
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
