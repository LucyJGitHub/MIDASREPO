     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Beneficiary Customer (Cover)')       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOCBN  - Validate OP Beneficiary Customer (Cover)          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CSW215             Date 06Apr15               *
      *  Prev Amend No. MD000091           Date 06May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24663           Date 29Jun09               *
      *                 BUG24496           Date 22Jun09               *
      *                 BUG24396           Date 22Jun09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  MD000091 - Event Codes Substitution                          *
      *  BUG24663 - Second line should be entered even if input is    *
      *             valid account                                     *
      *  BUG24496 - Warning Message did not appear for IBAN with      *
      *             invalid ISO Code                                  *
      *  BUG24396 - Error on FTVOCBN  module                          *
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
 
      ** External data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** Beneficiary Customer data structure
     D BENCUS          DS           175
     D  WCBC1                  1     35
     D  WCBC2                 36     70
     D  WCBC3                 71    105
     D  WCBC4                106    140
     D  WCBC5                141    175
 
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
     D CFT004          S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D IBCHK1          S              1A
     D IBCHK2          S              1A
     D IBCTY1          S              1A
     D IBCTY2          S              1A
     D CLSWTK          S             12A
     D PIBAN           S             47A
     D P@IBAN          S             34A
     D POWith          S             47A
     D PONobl          S             34A
 
      ** Fields used for SWIFT validation
     D ADLINE          S              1A
     D ADSLON          S              1A
     D ##CSID          S              1A
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** SWIFT 2015 59F Parameters                                                            CSW215
     D CSW215          S              1A                                                      CSW215
     D PretCode        S              7A                                                      CSW215
     D PCallF          S              4A                                                      CSW215
     D PNetwork        S              6A                                                      CSW215
     D PMsgType        S              3A                                                      CSW215
     D PMsgTag         S              5A                                                      CSW215
     D PBranch         S              3A                                                      CSW215
     D PCountry        S              2A                                                      CSW215
     D PCurr           S              3A                                                      CSW215
     D PNostro         S              2A                                                      CSW215
     D POutP1          S             35A                                                      CSW215
     D POutP2          S             35A                                                      CSW215
     D POutP3          S             35A                                                      CSW215
     D POutP4          S             35A                                                      CSW215
     D POutP5          S             35A                                                      CSW215
     D PMsgID          S              7A                                                      CSW215
     D PErrTp          S              1A                                                      CSW215
                                                                                              CSW215
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
     C                   ExSr      VOCBC
      *                                                                                       CSW215
      ** Validate 59F format if CSW215 is installed                                           CSW215
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y' AND Idx = 0                                   CSW215
     C                   EXSR      V59F                                                       CSW215
     C                   ENDIF                                                                CSW215
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKCBC1 = 'N'
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2CBC1 = SCBC1
     C                   Eval      O2CBC2 = SCBC2
     C                   Eval      O2CBC3 = SCBC3
     C                   Eval      O2CBC4 = SCBC4
     C                   Eval      O2CBC5 = SCBC5
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOCBC - Validate Beneficiary Customer (Cover)
      *****************************************************************
      *
     C     VOCBC         BEGSR
      *
     C                   Eval      O2CBCT = *Blanks
      *
     C                   Eval      WCBC1 = SCBC1
     C                   Eval      WCBC2 = SCBC2
     C                   Eval      WCBC3 = SCBC3
     C                   Eval      WCBC4 = SCBC4
     C                   Eval      WCBC5 = SCBC5
      *
     C                   If        SOMVLF = 'COV'
      *
      ** Beneficiary Customer (Cover) must be entered for
      ** Validation Flag(Main) COV
      *
     C                   If        BENCUS = *Blanks
     C                   Eval      OKCBC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C**********         Eval      FldNamXAr(Idx) = 'SCAB1'                                 BUG24396
     C**********         Eval      MsgDtaXAr(IDX) = SCAB1                                   BUG24396
     C                   Eval      FldNamXAr(Idx) = 'SCBC1'                                 BUG24396
     C**********         Eval      MsgDtaXAr(IDX) = SCBC1                          BUG24396 MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCBC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00264'
     C                   LeaveSr
     C                   EndIf
      *
      ** Beneficiary Customer (Cover) can only be entered for
      ** SWIFT 202 COV or SWIFT 205 COV
      *
     C                   ElseIf    BENCUS <> *Blanks
     C                   Eval      OKCBC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C**********         Eval      FldNamXAr(Idx) = 'SCAB1'                                 BUG24396
     C**********         Eval      MsgDtaXAr(IDX) = SCAB1                                   BUG24396
     C                   Eval      FldNamXAr(Idx) = 'SCBC1'                                 BUG24396
     C**********         Eval      MsgDtaXAr(IDX) = SCBC1                          BUG24396 MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCBC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00265'
     C                   LeaveSr
     C                   EndIf
      *
     C                   If        BENCUS <> *Blanks
      *
     C                   Eval      ADDRSS = BENCUS
      *
      ** Validate SWIFT Address
      *
     C                   If        (ADCH26 = *BLANKS And
     C                             ADEXSW  = *BLANKS And
     C                             ADSLSH  <> '/')
     C                             Or
     C                             (ADCH36 = *Blanks And
     C                             ADEXS2  = *Blanks And
     C                             ADSLSH  = '/'     AND
     C                             ADCHK2 <> *Blanks And
     C                             ADSLS2 <> '/')
      *
     C                   ExSr      VSWFT
      *
      ** Exit if error found
      *
     C                   If        OKCBC1 = 'N'
     C                   LeaveSr
     C                   EndIf
     C                   EndIF
      *
      ** Validate IBAN number
      *
     C**********         If        CFT004 = 'Y' And                                         BUG24496
     C**********                   ADCH26 = *Blanks                                         BUG24496
     C                   IF        CFT004 = 'Y'                                             BUG24496
      *
     C                   ExSr      VIBAN
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
     C                   Eval      CLSWTK = SCBC1
      *
     C                   If        SCBC2 <> *Blanks
     C                   Eval      CLSWTK = SCBC2
     C                   EndIf
      *
     C                   ExSr      SWIFT
      *
     C                   If        ##CSID = 'Y'
      *
      ** Invalid SWIFT characters found
      *
     C                   If        *IN31 = *ON
     C                   Eval      OKCBC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCBC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCBC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCBC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00207'
     C                   LeaveSr
     C                   EndIf
      *
      ** BIC directory is not loaded
      *
     C                   If        *IN32 = *ON
     C                             And *IN31 = *OFF
     C                   Eval      OKCBC1 = 'W'
     C                   Eval      WIX = WIX + 1
     C                   Eval      WFldNmXAr(WIX) = 'SCBC1'
     C**********         Eval      WMsgDtaXAr(WIX) = SCBC1                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(SCBC1)                   MD000091
     C                   Eval      WMsgIDXAr(WIX)  = 'ME00208'
     C                   EndIf
      *
     C                   Eval      O2CBC1 = SCBC1
     C                   Eval      O2CBC2 = SCBC2
     C                   Eval      O2CBC3 = SCBC3
     C                   Eval      O2CBC4 = SCBC4
     C                   Eval      O2CBC5 = SCBC5
     C                   Eval      O2CBCT = 'S'
      *
      ** Exit if Beneficiary Customer (Cover) is a SWIFT Address
      *
     C                   Return
      *
     C                   EndIf
      *
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VIBAN - Validate IBAN Number
      *****************************************************************
      *
     C     VIBAN         BegSr
      *
     C                   If        %Subst(SCBC1:1:1) = '/'
     C                   Eval      PIBAN = %Subst(SCBC1:2:34)
      *
     C                   Call      'AOIBANR3'
     C                   Parm                    PRTCD
     C                   Parm                    PIBAN
     C                   Parm                    POWith
     C     P@IBAN        Parm                    PONobl
      *
      ** If first four characters are 'AANN', proceed with IBAN
      ** validation.
      *
     C                   Eval      IBCTY1 = %Subst(P@IBAN:1:1)
     C                   Eval      IBCTY2 = %Subst(P@IBAN:2:1)
     C                   Eval      IBCHK1 = %Subst(P@IBAN:3:1)
     C                   Eval      IBCHK2 = %Subst(P@IBAN:4:1)
     C     IBCTY1        LookUp    Alpha                                  65
     C   65IBCTY2        LookUp    Alpha                                  65
     C   65IBCHK1        LookUp    Numeric                                65
     C   65IBCHK2        LookUp    Numeric                                65
      *
     C                   If        *IN65 = *ON
     C                   Call      'AOIBANR5'                           66
     C                   Parm      *BLANKS       PRTCD
     C                   Parm                    P@IBAN
      *
      ** If no warnings, prefix IBAN with '/'
      *
     C                   If        *IN66 = *OFF And PRTCD = *Blanks
     C     '/'           Cat       P@IBAN        SCBC1
      *
     C**********         IF        ADCH26 = *BLANKS                                BUG24496 BUG24663
     C**********         EVAL      O2CBC1 = SCBC1                                  BUG24496 BUG24663
     C**********         EVAL      O2CBC2 = SCBC2                                  BUG24496 BUG24663
     C**********         EVAL      O2CBC3 = SCBC3                                  BUG24496 BUG24663
     C**********         EVAL      O2CBC4 = SCBC4                                  BUG24496 BUG24663
     C**********         EVAL      O2CBC5 = SCBC5                                  BUG24496 BUG24663
     C**********         EVAL      O2CBCT = 'I'                                    BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
      ***Exit*if*Beneficiary*customer*(Cover)*is*in*IBAN*format                    BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
     C**********         RETURN                                                    BUG24496 BUG24663
     C**********         ENDIF                                                     BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
     C                   Else
     C                   Eval      OKCBC1 = 'W'
     C                   Eval      WIX = WIX + 1
     C                   Eval      WFldNmXAr(WIX) = 'SCBC1'
     C**********         Eval      WMsgDtaXAr(WIX) = SCBC1                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(SCBC1)                   MD000091
      *
     C                   Select
      *
      ** Invalid ISO country code
      *
     C                   When      PRTCD = '      1'
     C                   Eval      WMsgIdXAr(WIX) = 'FTM2400'
      *
      ** Invalid BBAN length
      *
     C                   When      PRTCD = '      2'
     C                   Eval      WMsgIdXAr(WIX) = 'FTM2401'
      *
      ** Invalid character
 
     C                   When      PRTCD = '      3'
     C                   Eval      WMsgIdXAr(WIX) = 'FTM2402'
      *
      ** Invalid IBAN length
      *
     C                   When      PRTCD = '      4'
     C                   Eval      WMsgIdXAr(WIX) = 'FTM2403'
      *
      ** Invalid check digit
      *
     C                   When      PRTCD = '      5'
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2404'
      *
      ** Other/non-specific warning
      *
     C                   Other
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2405'
     C                   EndSl
      *
     C                   EndIf
      *
     C**********         Eval      O2CBC1 = SCBC1                                           BUG24496
     C**********         Eval      O2CBC2 = SCBC2                                           BUG24496
     C**********         Eval      O2CBC3 = SCBC3                                           BUG24496
     C**********         Eval      O2CBC4 = SCBC4                                           BUG24496
     C**********         Eval      O2CBC5 = SCBC5                                           BUG24496
     C**********         Eval      O2CBCT = 'I'                                             BUG24496
      **********                                                                            BUG24496
      ***Exit*if*Ordering*customer*(Cover)*is*in*IBAN*format                                BUG24496
      **********                                                                            BUG24496
     C**********         Return                                                             BUG24496
     C                   EndIf
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
     C                             AND SCBC2 = *BLANKS
     C                   Eval      OKCBC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCBC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCBC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCBC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00209'
     C                   EndIf
      *
      ** Send error if 5th line entered but 1st line not starting with "/"
      *
     C                   If        *IN91 = *ON
     C                             And SCBC5 <> *Blanks
     C                   Eval      OKCBC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCBC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCBC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCBC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00182'
     C                   EndIf
      *
      ** Send error if Embedded blank lines exist
      *
     C                   If        *IN92 = *ON
     C                   Eval      OKCBC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCBC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCBC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCBC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00210'
     C                   EndIf
      *
      ** Send error if Invalid SWIFT character found
      *
     C                   If        AD#1 = 'Y' Or
     C                             AD#2 = 'Y' Or
     C                             AD#3 = 'Y' Or
     C                             AD#4 = 'Y' Or
     C                             AD#5 = 'Y'
     C                   Eval      OKCBC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCBC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCBC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCBC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCBC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00211'
     C                   EndIf
      *
     C                   Eval      O2CBCT = 'A'
      *
     C                   EndSr
      *****************************************************************                       CSW215
      /EJECT                                                                                  CSW215
      *****************************************************************                       CSW215
      * V59F - Validate 59F Format                                                            CSW215
      *****************************************************************                       CSW215
     C     V59F          BEGSR                                                                CSW215
     C                   CALL      'MG001001'                                                 CSW215
     C                   PARM      *BLANKS       PRetCode                                     CSW215
     C                   PARM      'TRAN'        PCallF                                       CSW215
     C                   PARM                    SCBC1                                        CSW215
     C                   PARM                    SCBC2                                        CSW215
     C                   PARM                    SCBC3                                        CSW215
     C                   PARM                    SCBC4                                        CSW215
     C                   PARM                    SCBC5                                        CSW215
     C                   PARM      SNWRK         PNetwork                                     CSW215
     C                   PARM      SMTPY         PMsgType                                     CSW215
     C                   PARM      ':59F:'       PMsgTag                                      CSW215
     C                   PARM      OTBRCA        PBranch                                      CSW215
     C                   PARM      *BLANKS       PCountry                                     CSW215
     C                   PARM      OTSMCY        PCurr                                        CSW215
     C                   PARM      *BLANKS       PNostro                                      CSW215
     C                   PARM      *BLANKS       POutP1                                       CSW215
     C                   PARM      *BLANKS       POutP2                                       CSW215
     C                   PARM      *BLANKS       POutP3                                       CSW215
     C                   PARM      *BLANKS       POutP4                                       CSW215
     C                   PARM      *BLANKS       POutP5                                       CSW215
     C                   PARM      *BLANKS       PMsgID                                       CSW215
     C                   PARM      *BLANKS       PErrTp                                       CSW215
                                                                                              CSW215
     C                   IF        PErrTp = 'E'                                               CSW215
     C                   EVAL      OKCBC1 = 'N'                                               CSW215
     C                   EVAL      OKCBC2 = 'N'                                               CSW215
     C                   EVAL      OKCBC3 = 'N'                                               CSW215
     C                   EVAL      OKCBC4 = 'N'                                               CSW215
     C                   EVAL      OKCBC5 = 'N'                                               CSW215
     C                   EVAL      Idx = Idx + 1                                              CSW215
     C                   EVAL      FldNamXAr(Idx) = 'SCBC1'                                   CSW215
     C                   EVAL      MsgIDXAr(Idx)  = PMsgID                                    CSW215
     C                   ELSEIF    PErrTp = 'W'                                               CSW215
     C                   EVAL      OKCBC1 = 'W'                                               CSW215
     C                   EVAL      OKCBC2 = 'W'                                               CSW215
     C                   EVAL      OKCBC3 = 'W'                                               CSW215
     C                   EVAL      OKCBC4 = 'W'                                               CSW215
     C                   EVAL      OKCBC5 = 'W'                                               CSW215
     C                   EVAL      WIx = WIx + 1                                              CSW215
     C                   EVAL      WFldNmXAr(WIx) = 'SCBC1'                                   CSW215
     C                   EVAL      WMsgIdXAr(WIx) = PMsgId                                    CSW215
                                                                                              CSW215
     C                   IF        PMsgID = 'ME00329'                                         CSW215
     C                   EVAL      WMsgDtaXAr(WIx) = PNetwork                                 CSW215
     C                   ELSEIF    PMsgID = 'ME00330'                                         CSW215
     C                   EVAL      WMsgDtaXAr(WIx) = PMsgTag                                  CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDSR                                                                CSW215
      *****************************************************************                       CSW215
 
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
      ** Access SAR file to determine if CFT004 is ON
      *
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      '*VERIFY'     POPTN
     C                   Parm      'CFT004'      PSARD
     C     SCSARD        Parm      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   If        PRTCD <> *Blanks And
     C                             PRTCD <> '*NRF   '
     C                   Eval      DBKEY = 'CFT004'
     C                   Eval      DBFILE = 'SCSARDPD'
     C                   Eval      DBASE = 1
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   If        PRTCD = *Blanks
     C                   Eval      CFT004 = 'Y'
     C                   Else
     C                   Eval      CFT004 = 'N'
     C                   EndIf
      *                                                                                       CSW215
      ** Check if CSW215 is installed                                                         CSW215
      *                                                                                       CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM                    PRTCD                                        CSW215
                                                                                              CSW215
     C                   IF        PRTCD = 'CSW2015'                                          CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ENDIF                                                                CSW215
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
