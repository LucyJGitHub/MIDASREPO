     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Ordering Customer (Cover)')          *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOCOC  - Validate OP Ordering Customer (Cover)             *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 06May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26087           Date 22Sep09               *
      *                 BUG25973           Date 17Sep09               *
      *                 BUG25005           Date 16Jul09               *
      *                 BUG24663           Date 29Jun09               *
      *                 BUG24496           Date 22Jun09               *
      *                 BUG24934           Date 15Jul09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  BUG26087 - The word COVER is missing in the error message    *
      *  BUG25973 - When Ordering Customer L1 is equal to valid IBAN  *
      *             without slash followed by 1/, 6/, 6/ the system   *
      *             accepts the transaction                           *
      *  BUG25005 - Unexpected error message displayed                *
      *  BUG24663 - Second line should be entered even if input is    *
      *             valid account                                     *
      *  BUG24496 - Warning Message did not appear for IBAN with      *
      *             invalid ISO Code                                  *
      *  BUG24934 - Invalid Character did not accept                  *
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

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Data structure for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)

      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)

      ** Ordering Customer data structure
     D ORDCST          DS           175
     D  WCOC1                  1     35
     D  WCOC2                 36     70
     D  WCOC3                 71    105
     D  WCOC4                106    140
     D  WCOC5                141    175

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

      ** Used for SWIFT validation
     D ADLINE          S              1A
     D ADSLON          S              1A
     D ##CSID          S              1A

      ** FT001000 parameters
     D PRTCD           S              7A
     D PMsgID          S              7A
     D PErTp           S              1A
     D PVType          S              4A
     D P50FmtF1        S             35A
     D P50FmtF2        S             35A
     D P50FmtF3        S             35A
     D P50FmtF4        S             35A
     D P50FmtF5        S             35A
     D PAcType         S              1A
     D PAccount        S             34A
     D PCust           S              6A
     D PNonActH        S             10A
     D PNetwork        S              6A
     D PMsgTyp         S              3A
     D PMsgTag         S              5A
     D PCountry        S              2A
     D PBrch           S              3A
     D PCurr           S              3A
     D PNostro         S              2A
     D PModI           S              2A
     D POut1           S             35A
     D POut2           S             35A
     D POut3           S             35A
     D POut4           S             35A
     D POut5           S             35A

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
     C                   ExSr      VOCOC

      ** If an error was found, set the return code appropriately
      *
     C                   If        OKCOC1 = 'N'
     C                   Eval      RetCodeIn = 'Error'
      *
     C                   Else
     C                   Eval      O2COC1 = SCOC1
     C                   Eval      O2COC2 = SCOC2
     C                   Eval      O2COC3 = SCOC3
     C                   Eval      O2COC4 = SCOC4
     C                   Eval      O2COC5 = SCOC5
     C                   EndIf

      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * VOCOC - Validate Ordering Customer (Cover)
      *****************************************************************
      *
     C     VOCOC         Begsr
      *
     C                   Eval      O2COCT = *Blanks
      *
     C                   Eval      WCOC1 = SCOC1
     C                   Eval      WCOC2 = SCOC2
     C                   Eval      WCOC3 = SCOC3
     C                   Eval      WCOC4 = SCOC4
     C                   Eval      WCOC5 = SCOC5
      *
     C                   If        SOMVLF = 'COV'
      *
      ** Ordering Customer (Cover) must be entered
      ** for Validation Flag Main COV
      *
     C                   If        ORDCST = *Blanks
     C                   Eval      OKCOC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00257'
     C                   LeaveSr
     C                   EndIf

     C                   Else
      *
      ** Ordering Customer (Cover) can only be entered
      ** for Validation Flag Main COV
      *
     C                   If        ORDCST <> *Blanks
     C                   Eval      OKCOC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00258'
     C                   LeaveSr
     C                   EndIf

     C                   EndIf
      *
     C                   If        ORDCST <> *Blanks
      *
     C                   Eval      ADDRSS = ORDCST
      *
      ** Validate SWIFT Address
      *
     C                   If        (ADCH26 = *Blanks
     C                             And ADEXSW  = *Blanks
     C                             And ADSLSH  <> '/')
     C                             Or
     C                             (ADCH36 = *Blanks
     C                             And ADEXS2  = *Blanks
     C                             And ADSLSH  = '/'
     C                             And ADCHK2 <> *Blanks
     C                             And ADSLS2 <> '/')
      *
     C                   ExSr      VSWFT
      *
      ** Exit if error found
      *
     C                   If        OKCOC1 = 'N'
     C                   LeaveSr
     C                   EndIf
     C                   EndIf
      *
      ** Validate IBAN number
      *
     C                   If        CFT004 = 'Y'
     C**********                   And ADCH26 = *Blanks                                     BUG24496
      *
     C                   ExSr      VIBAN
     C                   EndIf
      *
      ** Validate Address
      *
     C                   ExSr      VADDR
      *
      ** Exit if error found
      *
     C                   If        OKCOC1 = 'N'
     C                   LeaveSr
     C                   EndIf
      *
      ** 50F Validation
      *
     C                   ExSr      V50F
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
     C                   Eval      CLSWTK = SCOC1
      *
     C                   If        SCOC2 <> *Blanks
     C                   Eval      CLSWTK = SCOC2
     C                   EndIf
      *
     C                   ExSr      SWIFT
      *
     C                   If        ##CSID = 'Y'
      *
      ** Invalid SWIFT characters found
      *
     C                   If        *IN31 = *ON
     C                   Eval      OKCOC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00177'
     C                   LeaveSr
     C                   EndIf
      *
      ** BIC directory is not loaded
      *
     C                   If        *IN32 = *ON
     C                             And *IN31 = *OFF
     C                   Eval      OKCOC1 = 'W'
     C                   Eval      WIX = WIX + 1
     C                   Eval      WFldNmXAr(WIX) = 'SCOC1'
     C**********         Eval      WMsgDtaXAr(WIX) = SCOC1                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(SCOC1)                   MD000091
     C                   Eval      WMsgIDXAr(WIX)  = 'ME00178'
     C                   EndIf
      *
     C                   Eval      O2COC1 = SCOC1
     C                   Eval      O2COC2 = SCOC2
     C                   Eval      O2COC3 = SCOC3
     C                   Eval      O2COC4 = SCOC4
     C                   Eval      O2COC5 = SCOC5
     C                   Eval      O2COCT = 'S'
      *
      ** Exit if Ordering customer (Cover) is a SWIFT Address
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
     C                   If        %Subst(SCOC1:1:1) = '/'
     C                   Eval      PIBAN = %Subst(SCOC1:2:34)
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
     C                   Parm      *Blanks       PRTCD
     C                   Parm                    P@IBAN
      *
      ** If no warnings, prefix IBAN with '/'
      *
     C                   If        *IN66 = *OFF And PRTCD = *Blanks
     C     '/'           Cat       P@IBAN        SCOC1
      *
     C**********         IF        ADCH26 = *BLANKS                                BUG24496 BUG24663
     C**********         EVAL      O2COC1 = SCOC1                                  BUG24496 BUG24663
     C**********         EVAL      O2COC2 = SCOC2                                  BUG24496 BUG24663
     C**********         EVAL      O2COC3 = SCOC3                                  BUG24496 BUG24663
     C**********         EVAL      O2COC4 = SCOC4                                  BUG24496 BUG24663
     C**********         EVAL      O2COC5 = SCOC5                                  BUG24496 BUG24663
     C**********         EVAL      O2COCT = 'I'                                    BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
      ***Exit*if*Ordering*customer*(Cover)*is*in*IBAN*format                       BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
     C**********         RETURN                                                    BUG24496 BUG24663
     C**********         ENDIF                                                     BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
     C                   Else
      *                                                                                     BUG24934
      ** Not applicable for incoming IBAN transactions                                      BUG24934
      ** Error message FTM2402 will be handled by ME00181                                   BUG24934
      *                                                                                     BUG24934
     C                   If        PRTCD <> '      3'                                       BUG24934
                                                                                            BUG24934
     C                   Eval      OKCOC1 = 'W'
     C                   Eval      WIX = WIX + 1
     C                   Eval      WFldNmXAr(WIX) = 'SCOC1'
     C**********         Eval      WMsgDtaXAr(WIX) = SCOC1                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(SCOC1)                   MD000091
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

     C**********         When      PRTCD = '      3'                                        BUG24934
     C**********         Eval      WMsgIdXAr(WIX) = 'FTM2402'                               BUG24934
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
     C                   EndIf                                                              BUG24934
                                                                                            BUG24934
     C                   EndIf
      *
     C**********         Eval      O2COC1 = SCOC1                                           BUG24496
     C**********         Eval      O2COC2 = SCOC2                                           BUG24496
     C**********         Eval      O2COC3 = SCOC3                                           BUG24496
     C**********         Eval      O2COC4 = SCOC4                                           BUG24496
     C**********         Eval      O2COC5 = SCOC5                                           BUG24496
     C**********         Eval      O2COCT = 'I'                                             BUG24496
      **********                                                                            BUG24496
      ** Exit if Ordering customer (Cover) is in IBAN format                                BUG24496
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
     C                   If        *IN91 = *ON And
     C                             SCOC2 = *Blanks
     C                   Eval      OKCOC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00179'
     C                   EndIf
      *
      ** Send error if Embedded blank lines exist
      *
     C                   If        *IN92 = *ON
     C                   Eval      OKCOC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00180'
     C                   EndIf
      *
      ** Send error if Invalid SWIFT character found
      *
     C                   If        AD#1 = 'Y' Or
     C                             AD#2 = 'Y' Or
     C                             AD#3 = 'Y' Or
     C                             AD#4 = 'Y' Or
     C                             AD#5 = 'Y'
     C                   Eval      OKCOC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00181'
     C                   EndIf
      *
      ** Send error if first line is not "/" and fifth line is not blanks
      ** and fifth line doesn't start with valid SWIFT tags
      *
     C                   If        %Subst(SCOC1:1:1) <> '/'
     C                             And SCOC5 <> *Blanks
      *
     C                   If        %Subst(SCOC5:1:2) <> '1/' And
     C                             %Subst(SCOC5:1:2) <> '2/' And
     C                             %Subst(SCOC5:1:2) <> '3/' And
     C                             %Subst(SCOC5:1:2) <> '4/' And
     C                             %Subst(SCOC5:1:2) <> '5/' And
     C                             %Subst(SCOC5:1:2) <> '6/' And
     C                             %Subst(SCOC5:1:2) <> '7/' And
     C                             %Subst(SCOC5:1:2) <> '7/' And
     C**********                   %Subst(SCOC5:1:2) <> '8/'                                BUG25005
     C                             %Subst(SCOC5:1:2) <> '8/' AND                            BUG25005
      *                                                                                     BUG25005
     C                             %SUBST(SCOC1:1:5) <> 'ARNU/' AND                         BUG25005
     C                             %SUBST(SCOC1:1:5) <> 'CCPT/' AND                         BUG25005
     C                             %SUBST(SCOC1:1:5) <> 'CUST/' AND                         BUG25005
     C                             %SUBST(SCOC1:1:5) <> 'DRLC/' AND                         BUG25005
     C                             %SUBST(SCOC1:1:5) <> 'EMPL/' AND                         BUG25005
     C                             %SUBST(SCOC1:1:5) <> 'NIDN/' AND                         BUG25005
     C                             %SUBST(SCOC1:1:5) <> 'SOSE/' AND                         BUG25005
     C                             %SUBST(SCOC1:1:5) <> 'TXID/'                             BUG25005
      *
     C                   Eval      OKCOC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOC1                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(SCOC1))                                MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(SCOC1)                    MD000091
     C                   Eval      MsgIDXAr(Idx)  = 'ME00182'
     C                   EndIf
     C                   EndIf
      *
     C                   Eval      O2COCT = 'A'
      *
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * V50F - 50F Validation
      *****************************************************************
      *
     C     V50F          BegSr
      *
      ** Setup FT001000 parameters
      *
     C                   Eval      PNetwork = SNWRK
     C                   Eval      PMsgTyp  = SMTPY
     C                   Eval      PMsgTag  = ':50F:'
     C                   Eval      PAcType  = O2COCT
     C                   Eval      PAccount = *Blanks
     C                   Eval      PCust    = *Blanks
     C                   Eval      PNonActH = *Blanks
     C                   Eval      PCountry = *Blanks
     C                   Eval      PBrch    = OTBRCA
     C                   Eval      PCurr    = OTSMCY
     C                   Eval      PNostro  = *BLANKS
     C**********         Eval      PModI    = 'FT'                                          BUG25973
     C                   Eval      PModI    = 'OP'                                          BUG25973
      *
     C                   Call      'FT001000'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      *Blanks       PMsgID
     C                   Parm      *Blanks       PErTp
     C                   Parm      'TRAN'        PVType
     C                   Parm      SCOC1         P50FmtF1
     C                   Parm      SCOC2         P50FmtF2
     C                   Parm      SCOC3         P50FmtF3
     C                   Parm      SCOC4         P50FmtF4
     C                   Parm      SCOC5         P50FmtF5
     C                   Parm                    PAcType
     C                   Parm                    PAccount
     C                   Parm                    PCust
     C                   Parm                    PNonActH
     C                   Parm                    PNetwork
     C                   Parm                    PMsgTyp
     C                   Parm                    PMsgTag
     C                   Parm                    PCountry
     C                   Parm                    PBrch
     C                   Parm                    PCurr
     C                   Parm                    PNostro
     C                   Parm                    PModI
     C                   Parm                    POut1
     C                   Parm                    POut2
     C                   Parm                    POut3
     C                   Parm                    POut4
     C                   Parm                    POut5
      *
     C                   If        PRTCD <> *Blanks
      *
      ** Suppress formatting errors related to OMFM table
      *
     C                   If        PMsgID= 'FTS0055' Or
     C                             PMsgID= 'FTS0052'
     C                   Eval      PErTp = ' '
     C                   Endif
      *
     C                   Select
      *
     C                   When      PErTp = 'W'
     C                   Eval      OKCOC1 = 'W'
     C                   Eval      WIX = WIX + 1
     C                   Eval      WFldNmXAr(WIX) = 'SCOC1'
     C**********         Eval      WMsgDtaXAr(WIX) = SCOC1                                  BUG26087
     C                   Eval      WMsgIDXAr(WIX)  = PMsgID
      *
     C                   When      PErTp = 'E'
     C                   Eval      OKCOC1 = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'SCOC1'
     C**********         Eval      MsgDtaXAr(IDX) = SCOC1                                   BUG26087
     C                   Eval      MsgIDXAr(Idx)  = PMsgID
      *
     C                   EndSl
      *
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
     C     *ENTRY        PList

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
(c) Finastra International Limited 2009
**  Alpha - Array of alphabetic characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of numeric characters
0123456789
