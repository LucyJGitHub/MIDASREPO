     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Beneficiary Customer (Cover)')       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVICBN  - Validate Beneficiary Customer (Cover)             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG24663           Date 29Jun09               *
      *                 BUG24496           Date 22Jun09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  BUG24663 - Second line should be entered even if input is    *
      *             valid account                                     *
      *  BUG24496 - Warning Message did not appear for IBAN with      *
      *             invalid ISO Code                                  *
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
     D NwIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)
 
      ** Valid Incoming Payments Extension File (default)
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)
 
      * Flags to indicate whether transaction fields are valid
     D FTEIPY7       E DS                  EXTNAME(FTEIPY7PD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** External data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Beneficiary Customer data structure
     D BENCUS          DS           175
     D  WCBC1                  1     35
     D  WCBC2                 36     70
     D  WCBC3                 71    105
     D  WCBC4                106    140
     D  WCBC5                141    175
 
      /COPY FTCPYSRC,SFTVALCSLE
      *
      /COPY FTCPYSRC,SFTADDRILE
 
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
 
      ** Used for SWIFT validation
     D ADLINE          S              1A
     D ADSLON          S              1A
     D ##CSID          S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
     C                   EVAL      RetCodeIn  = *BLANKS
     C                   EVAL      FldNamXAr  = *BLANKS
     C                   EVAL      MsgIDXAr   = *BLANKS
     C                   EVAL      MsgDtaXAr  = *BLANKS
     C                   EVAL      WFldNmXAr  = *BLANKS
     C                   EVAL      WMsgIDXAr  = *BLANKS
     C                   EVAL      WMsgDtaXAr = *BLANKS
     C                   EVAL      WIX = 0
     C                   EVAL      Idx = 0
 
      ** Validate
     C                   Exsr      VICBC
 
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKCBC1 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C                   EVAL      I2CBC1 = DDCBC1
     C                   EVAL      I2CBC2 = DDCBC2
     C                   EVAL      I2CBC3 = DDCBC3
     C                   EVAL      I2CBC4 = DDCBC4
     C                   EVAL      I2CBC5 = DDCBC5
     C                   ENDIF
 
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VICBC - Validate Beneficiary Customer (Cover)
      *****************************************************************
      *
     C     VICBC         BEGSR
      *
     C                   EVAL      I2CBCT = *BLANKS
      *
     C                   MOVEL     DDCBC1        WCBC1
     C                   MOVEL     DDCBC2        WCBC2
     C                   MOVEL     DDCBC3        WCBC3
     C                   MOVEL     DDCBC4        WCBC4
     C                   MOVEL     DDCBC5        WCBC5
      *
     C                   IF        DDNWRK = 'SWIFT' AND
     C                             DDVALF = 'COV'   AND
     C                             (DDMTPY = '202' OR DDMTPY = '205')
      *
      ** Beneficiary Customer (Cover) must be entered for
      ** SWIFT 202 COV or SWIFT 205 COV
      *
     C                   IF        BENCUS = *BLANKS
     C                   EVAL      OKCBC1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBC1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCBC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCBC1)                   MD000091
     C                   MOVEL     'ME00205'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
      ** Beneficiary Customer (Cover) can only be entered for
      ** SWIFT 202 COV or SWIFT 205 COV
      *
     C                   ELSEIF    BENCUS <> *BLANKS
     C                   EVAL      OKCBC1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBC1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCBC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCBC1)                   MD000091
     C                   MOVEL     'ME00206'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        BENCUS <> *BLANKS
      *
     C                   MOVEL     BENCUS        ADDRSS
      *
      ** Validate SWIFT Address
      *
     C                   IF        (ADCH26 = *BLANKS AND
     C                             ADEXSW  = *BLANKS AND
     C                             ADSLSH  <> '/')
     C                             OR
     C                             (ADCH36 = *BLANKS AND
     C                             ADEXS2  = *BLANKS AND
     C                             ADSLSH  = '/'     AND
     C                             ADCHK2 <> *BLANKS AND
     C                             ADSLS2 <> '/')
      *
     C                   EXSR      VSWFT
      *
      ** Exit if error found
      *
     C                   IF        OKCBC1 = 'N'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate IBAN number
      *
     C**********         IF        CFT004 = 'Y' AND                                         BUG24496
     C**********                   ADCH26 = *BLANKS                                         BUG24496
     C                   IF        CFT004 = 'Y'                                             BUG24496
      *
     C                   EXSR      VIBAN
     C                   ENDIF
      *
      ** Validate Address
      *
     C                   EXSR      VADDR
      *
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * VSWFT - Validate SWIFT Address
      *****************************************************************
      *
     C     VSWFT         BEGSR
      *
      ** First 11 characters should be key for CLSWT.
      *
     C                   MOVEL     DDCBC1        CLSWTK
      *
     C                   IF        DDCBC2 <> *BLANKS
     C                   MOVEL     DDCBC2        CLSWTK
     C                   ENDIF
      *
     C                   EXSR      SWIFT
      *
     C                   IF        ##CSID = 'Y'
      *
      ** Invalid SWIFT characters found
      *
     C                   IF        *IN31 = *ON
     C                   EVAL      OKCBC1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBC1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCBC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCBC1)                   MD000091
     C                   MOVEL     'ME00207'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
      ** BIC directory is not loaded
      *
     C                   IF        *IN32 = *ON  AND
     C                             *IN31 = *OFF
     C                   EVAL      OKCBC1 = 'W'
     C                   ADD       1             WIX
     C                   MOVEL     'DDCBC1'      WFldNmXAr(WIX)
     C**********         EVAL      WMsgDtaXAr(WIX) = DDCBC1                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(DDCBC1)                  MD000091
     C                   MOVEL     'ME00208'     WMsgIDXAr(WIX)
     C                   ENDIF
      *
     C                   EVAL      I2CBC1 = DDCBC1
     C                   EVAL      I2CBC2 = DDCBC2
     C                   EVAL      I2CBC3 = DDCBC3
     C                   EVAL      I2CBC4 = DDCBC4
     C                   EVAL      I2CBC5 = DDCBC5
     C                   EVAL      I2CBCT = 'S'
      *
      ** Exit if Beneficiary Customer (Cover) is a SWIFT Address
      *
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VIBAN - Validate IBAN Number
      *****************************************************************
      *
     C     VIBAN         BEGSR
      *
     C                   IF        %SUBST(DDCBC1:1:1) = '/'
     C                   EVAL      PIBAN = %SUBST(DDCBC1:2:34)
      *
     C                   CALL      'AOIBANR3'
     C                   PARM                    PRTCD
     C                   PARM                    PIBAN
     C                   PARM                    POWith
     C     P@IBAN        PARM                    PONobl
      *
      ** If first four characters are 'AANN', proceed with IBAN
      ** validation.
      *
     C                   EVAL      IBCTY1 = %SUBST(P@IBAN:1:1)
     C                   EVAL      IBCTY2 = %SUBST(P@IBAN:2:1)
     C                   EVAL      IBCHK1 = %SUBST(P@IBAN:3:1)
     C                   EVAL      IBCHK2 = %SUBST(P@IBAN:4:1)
     C     IBCTY1        LOOKUP    Alpha                                  65
     C   65IBCTY2        LOOKUP    Alpha                                  65
     C   65IBCHK1        LOOKUP    Numeric                                65
     C   65IBCHK2        LOOKUP    Numeric                                65
      *
     C                   IF        *IN65 = *ON
     C                   CALL      'AOIBANR5'                           66
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    P@IBAN
      *
      ** If no warnings, prefix IBAN with '/'
      *
     C                   IF        *IN66 = *OFF AND PRTCD = *BLANKS
     C     '/'           CAT       P@IBAN        DDCBC1
      *
     C**********         IF        ADCH26 = *BLANKS                                BUG24496 BUG24663
     C**********         EVAL      I2CBC1 = DDCBC1                                 BUG24496 BUG24663
     C**********         EVAL      I2CBC2 = DDCBC2                                 BUG24496 BUG24663
     C**********         EVAL      I2CBC3 = DDCBC3                                 BUG24496 BUG24663
     C**********         EVAL      I2CBC4 = DDCBC4                                 BUG24496 BUG24663
     C**********         EVAL      I2CBC5 = DDCBC5                                 BUG24496 BUG24663
     C**********         EVAL      I2CBCT = 'I'                                    BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
      ***Exit*if*Beneficiary*customer*(Cover)*is*in*IBAN*format                    BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
     C**********         RETURN                                                    BUG24496 BUG24663
     C**********         ENDIF                                                     BUG24496 BUG24663
      **********                                                                   BUG24496 BUG24663
     C                   ELSE
     C                   EVAL      OKCBC1 = 'W'
     C                   ADD       1             WIX
     C                   EVAL      WFldNmXAr(WIX) = 'DDCBC1'
     C**********         EVAL      WMsgDtaXAr(WIX) = DDCBC1                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(DDCBC1)                  MD000091
      *
     C                   SELECT
      *
      ** Invalid ISO country code
      *
     C                   WHEN      PRTCD = '      1'
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2400'
      *
      ** Invalid BBAN length
      *
     C                   WHEN      PRTCD = '      2'
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2401'
      *
      ** Invalid character
 
     C                   WHEN      PRTCD = '      3'
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2402'
      *
      ** Invalid IBAN length
      *
     C                   WHEN      PRTCD = '      4'
     C                   EVAL      WMsgIdXAr(WIX) = 'FTM2403'
      *
      ** Invalid check digit
      *
     C                   WHEN      PRTCD = '      5'
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2404'
      *
      ** Other/non-specific warning
      *
     C                   OTHER
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2405'
     C                   ENDSL
      *
     C                   ENDIF
      *
     C**********         EVAL      I2CBC1 = DDCBC1                                          BUG24496
     C**********         EVAL      I2CBC2 = DDCBC2                                          BUG24496
     C**********         EVAL      I2CBC3 = DDCBC3                                          BUG24496
     C**********         EVAL      I2CBC4 = DDCBC4                                          BUG24496
     C**********         EVAL      I2CBC5 = DDCBC5                                          BUG24496
     C**********         EVAL      I2CBCT = 'I'                                             BUG24496
      **********                                                                            BUG24496
      ***Exit*if*Beneficiary*customer*(Cover)*is*in*IBAN*format                             BUG24496
      **********                                                                            BUG24496
     C**********         RETURN                                                             BUG24496
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VADDR - Validate Address
      *****************************************************************
      *
     C     VADDR         BEGSR
      *
     C                   EVAL      ADLINE = 'Y'
     C                   EXSR      ADCHK
      *
      ** Send error if Address line starts with "/" but no second line entered
      *
     C                   IF        *IN91 = *ON AND
     C                             DDCBC2 = *BLANKS
     C                   EVAL      OKCBC1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBC1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCBC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCBC1)                   MD000091
     C                   MOVEL     'ME00209'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Send error if 5th line entered but 1st line not starting with "/"
      *
     C                   IF        *IN91 = *ON AND
     C                             DDCBC5 <> *BLANKS
     C                   EVAL      OKCBC1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBC1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCBC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCBC1)                   MD000091
     C                   MOVEL     'ME00182'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Send error if Embedded blank lines exist
      *
     C                   IF        *IN92 = *ON
     C                   EVAL      OKCBC1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBC1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCBC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCBC1)                   MD000091
     C                   MOVEL     'ME00210'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Send error if Invalid SWIFT character found
      *
     C                   IF        AD#1 = 'Y' OR
     C                             AD#2 = 'Y' OR
     C                             AD#3 = 'Y' OR
     C                             AD#4 = 'Y' OR
     C                             AD#5 = 'Y'
     C                   EVAL      OKCBC1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBC1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCBC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCBC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCBC1)                   MD000091
     C                   MOVEL     'ME00211'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   EVAL      I2CBCT = 'A'
      *
     C                   ENDSR
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
     C     *INZSR        BEGSR
     C*
     C     *ENTRY        PLIST
 
      * INPUTS
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Incoming Payments details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP7ScnFmt
 
      * OUTPUTS
      ** Incoming Payments (additional details) for file update
     C                   PARM                    NwIP2FilFmt
      *
      ** Incoming Payments Lvl 2 Scrn 7 error indicators
     C                   Parm                    FTEIPY7
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
      *
      ** Access SAR file to determine if CFT004 is ON
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT004'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CFT004'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
     C                   EVAL      CFT004 = 'N'
     C                   ENDIF
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
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
