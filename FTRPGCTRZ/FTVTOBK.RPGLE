     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate bank to bank information')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTOBK  - Validate Bank to Bank Information                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD021318           Date 26Jul13               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR924563           Date 05Nov14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 255286             Date 07Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 215817             Date 13Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 12Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD046248 - Finastra Rebranding                               *
      *  AR924563 - '-' should not be present in 1st character of     *
      *             outgoing payments fields 50, 57D, 59, 70 and 72.  *
      *             Recompile due to change in /copy SFTADDRCLE       *
      *             (Child: AR924564)                                 *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  255286 - Allow lowercase characters on input.                *
      *           Recompile due to change in /copy SFTVALCSLE         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  215817 - DB error due in OP due to full Bank to Bank info    *
      *           Based on fix 204869.                                *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

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

      **********************************************************************
      /EJECT                                                               *
      **********************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
                                                                                CFT014
     D WCHGS           C                   CONST('/CHGS/')                      CFT014

     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144

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
                                                                                CFT014
      ** Array of Warning in error.                                             CFT014
     D WFldNmXAr       S             10A   DIM(XArrayMax)                       CFT014
                                                                                CFT014
      ** Array of Warning message IDs                                           CFT014
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)          CFT014
                                                                                CFT014
      ** Array of Warning message data.                                         CFT014
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)        CFT014

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D*TranInSecB****E*DS***               EXTNAME(FTOPY3PD)                    CFT014
     D TranInThir    E DS                  EXTNAME(FTOPY4PD)                    CFT014

      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY2PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY3PD)                   CFT014

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)

      ** Array of DDBtb?OK error indicators
     D #ERR            S                   DIM(6) LIKE(OKBbi1)

     D/COPY FTCPYSRC,SFTADDRILE

     D SBBIDS          DS           210
     D  DSBBI1                 1     35
     D  DSBBI2                36     70
     D  DSBBI3                71    105
     D  DSBBI4               106    140
     D  DSBBI5               141    175
     D  DSBBI6               176    210

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
                                                                                CFT014
      ** Index for arrays of warning message ids etc                            CFT014
     D WIx             S              3P 0                                      CFT014

      * This prog only
     D ADLINE          S              1
     D ADSLON          S              1
     D #R              S              3  0
     D #S              S              3  0
     D #T              S              1  0

     D WErrFld         S              5    INZ('SBBI ')
     D PMode           S              6A                                                    MD021318
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization
      *
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS                          CFT014
     C                   Eval      WMsgIDXAr  = *BlankS                         CFT014
     C                   Eval      WMsgDtaXAr = *BlankS                         CFT014
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0                                      CFT014

      * Validate
      *
     C                   Exsr      VBKTOBK

      ** If an error was found, set the return code appropriately
      *
     C                   If        OKBbi1 = 'N' or
     C                             OKBbi2 = 'N' or
     C                             OKBbi3 = 'N' or
     C                             OKBbi4 = 'N' or
     C                             OKBbi5 = 'N' or
     C                             OKBbi6 = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKBbi1 = 'W' or                                            CSD089
     C                             OKBbi2 = 'W' or                                            CSD089
     C                             OKBbi3 = 'W' or                                            CSD089
     C                             OKBbi4 = 'W' or                                            CSD089
     C                             OKBbi5 = 'W' or                                            CSD089
     C                             OKBbi6 = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End

      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VBKTOBK - VALIDATION BANK TO BANK INFORMATION                  *
      ******************************************************************
     C*
     C     VBKTOBK       BEGSR

     C                   Eval      DSBBI1 = SBBI1
     C                   Eval      DSBBI2 = SBBI2
     C                   Eval      DSBBI3 = SBBI3
     C                   Eval      DSBBI4 = SBBI4
     C                   Eval      DSBBI5 = SBBI5
     C                   Eval      DSBBI6 = SBBI6

      *  Validate Bank to Bank Information
      *
     C                   If        SBBIDS <> *Blanks

      * Prevent first check in ADCHK subroutine
      * Validate as an address
     C                   Eval      ADLINE = ' '
     C                   Movel(P)  SBBIDS        ADDRSS
     C                   Exsr      ADCHK

      *  Depending on the indicators, highlight the field in error
      *
     C                   If        *IN92 = *On
      * Send error to screen
     C                   Move      'N'           OKBbi1
     C                   Add       1             Idx
     C                   Movel     'SBBI1'       FldNamXAr(Idx)
     C                   Movel     'MMA1067'     MsgIdXAr(Idx)
     C                   End

     C                   If        AD#1 = 'Y'
      * Send error to screen
     C**********         Move      'N'           OKBbi1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBBI1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBbi1                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBBI1'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBbi1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBBI1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End

     C                   If        AD#2 = 'Y'
      * Send error to screen
     C**********         Move      'N'           OKBbi2                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBBI2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBbi2                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBBI2'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBbi2                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBBI2'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End

     C                   If        AD#3 = 'Y'
      * Send error to screen
     C**********         Move      'N'           OKBbi3                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBBI3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBbi3                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBBI3'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBbi3                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBBI3'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End

     C                   If        AD#4 = 'Y'
      * Send error to screen
     C**********         Move      'N'           OKBbi4                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBBI4'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBbi4                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBBI4'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBbi4                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBBI4'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End

     C                   If        AD#5 = 'Y'
      * Send error to screen
     C**********         Move      'N'           OKBbi5                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBBI5'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBbi5                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBBI5'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBbi5                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBBI5'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End

     C                   If        AD#6 = 'Y'
      * Send error to screen
     C**********         Move      'N'           OKBbi6                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBBI6'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBbi6                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBBI6'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBbi6                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBBI6'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End

     C                   End
                                                                                CFT014
      ** Warning if codeword /CHGS/ exists in bank to bank fields               CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C     WCHGS:6       Scan      SBBIDS:1      WLOCAT            3 0    60    CFT014
     C                   If        *IN60 = True                                 CFT014
     C                   Add       1             WIx                            CFT014
     C                   Movel     'FTM3217'     WMsgIdXAr(WIx)                 CFT014
     C                   If        WLOCAT <= 35                                 CFT014
     C                   Eval      OKBBI1 = 'W'                                 CFT014
     C                   Movel     'SBBI1'       WFldNmXAr(WIx)                 CFT014
     C                   EndIf                                                  CFT014
     C                   If        (WLOCAT <= 70) And (WLOCAT > 35)             CFT014
     C                   Eval      OKBBI2 = 'W'                                 CFT014
     C                   Movel     'SBBI2'       WFldNmXAr(WIx)                 CFT014
     C                   EndIf                                                  CFT014
     C                   If        (WLOCAT <= 105) And (WLOCAT > 70)            CFT014
     C                   Eval      OKBBI3 = 'W'                                 CFT014
     C                   Movel     'SBBI3'       WFldNmXAr(WIx)                 CFT014
     C                   EndIf                                                  CFT014
     C                   If        (WLOCAT <= 140) And (WLOCAT > 105)           CFT014
     C                   Eval      OKBBI4 = 'W'                                 CFT014
     C                   Movel     'SBBI4'       WFldNmXAr(WIx)                 CFT014
     C                   EndIf                                                  CFT014
     C                   If        (WLOCAT <= 175) And (WLOCAT > 140)           CFT014
     C                   Eval      OKBBI5 = 'W'                                 CFT014
     C                   Movel     'SBBI5'       WFldNmXAr(WIx)                 CFT014
     C                   EndIf                                                  CFT014
     C                   If        WLOCAT > 175                                 CFT014
     C                   Eval      OKBBI6 = 'W'                                 CFT014
     C                   Movel     'SBBI6'       WFldNmXAr(WIx)                 CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014

      *  If settlement type if "01" or "08" or Sender's Corres. then
      *  validate as SWIFT.
      *
     C                   If        OKBbi1 <> 'N' and
     C                             OKBbi2 <> 'N' and
     C                             OKBbi3 <> 'N' and
     C                             OKBbi4 <> 'N' and
     C                             OKBbi5 <> 'N' and
     C                             OKBbi6 <> 'N'

     C                   If        @STMT = 01 or
     C                             @STMT = 08 or
     C                             SSNCO <> *Blanks and
     C                             SSNMT = 'Y'
     C                   Exsr      SRSEPT
     C* If errors occurred set up flags

     C                   If        #ERR(1) = 'N'
     C                   Eval      OKBbi1 = 'N'
     C                   End

     C                   If        #ERR(2) = 'N'
     C                   Eval      OKBbi2 = 'N'
     C                   End

     C                   If        #ERR(3) = 'N'
     C                   Eval      OKBbi3 = 'N'
     C                   End

     C                   If        #ERR(4) = 'N'
     C                   Eval      OKBbi4 = 'N'
     C                   End

     C                   If        #ERR(5) = 'N'
     C                   Eval      OKBbi5 = 'N'
     C                   End

     C                   If        #ERR(6) = 'N'
     C                   Eval      OKBbi6 = 'N'
     C                   End

     C                   End
     C                   End
      *
     C                   ENDSR
     C*****************************************************************
     C* END OF BANK TO BANK INFORMATION VALIDATION                    *
     C*****************************************************************
     C/EJECT
      *****************************************************************
      *  SRSEPT   : SWIFT validation changes                          *
      *****************************************************************
     CSR   SRSEPT        BEGSR

      *  Check through each of the 6 fields in turn.
     C                   Eval      #S = 1
     C                   Eval      #ERR = *BLANKS

     C     1             Do        6             #T

      *  Set flag to show line correct and move data to work fields
     C     35            Subst     SBBIDS:#S     FLD

      *  If not equal to blanks validate
     C                   If        FLD <> *Blanks

      * If line is not blank then first position must be a "/"
     C     1             Subst     FLD:1         ##001             1

      *  First position must be a '/'
     C                   If        ##001 <> '/'
      * Send error to screen
     C                   Move      'N'           #ERR(#T)
     C                   Add       1             Idx
     C                   Move      #T            WErrFld
     C                   Movel     WErrFld       FldNamXAr(Idx)
     C                   Movel     'MMA1068'     MsgIdXAr(Idx)

     C                   Else

      *  The first special instruction line cannot have '/'
      *  in position 2
     C                   If        #S = 1
     C     1             Subst     FLD:2         ##001
     C                   If        ##001 = '/'
      * Send error to screen
     C                   Move      'N'           #ERR(#T)
     C                   Add       1             Idx
     C                   Movel     'SBBI1'       FldNamXAr(Idx)
     C                   Movel     'MMA1069'     MsgIdXAr(Idx)
     C                   End

     C                   End

      *  2nd - 6th special instruction line cannot have '/'
      *  in position 2 followed by a narrative of blanks.
     C                   If        #S <> 1
     C     1             Subst     FLD:2         POS02             1
     C     33            Subst     FLD:3         NARR             33

     C                   If        POS02 = '/' and
     C                             NARR = *Blanks
      * Send error to screen
     C                   Move      'N'           #ERR(#T)
     C                   Add       1             Idx
     C                   Move      #T            WErrFld
     C                   Movel     WErrFld       FldNamXAr(Idx)
     C                   Movel     'MMA1070'     MsgIdXAr(Idx)
     C                   End

     C                   End
      *
      *  Check the line for '8a/', where 8a represents
      *  up to eight upper case alphabetic charaters
      *
      *
     C                   Eval      #R = 2
      *                                                                                       CSW201
      ** If Swift 2001 is installed, the field may contain                                    CSW201
      ** numeric characters (aside from the upper case                                        CSW201
      ** alphabetic characters)                                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C     ALPHAN        CHECK     FLD:#R        #R                                           CSW201
     C                   ELSE                                                                 CSW201
     C     ALPHAB        Check     FLD:#R        #R
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   If        #R >= 11
     C                             or #R = 0                                                  215817
      * Send error to screen
     C                   Move      'N'           #ERR(#T)
     C                   Add       1             Idx
     C                   Move      #T            WErrFld
     C                   Movel     WErrFld       FldNamXAr(Idx)
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'MMA1209'                                  CSW201
     C                   ELSE                                                                 CSW201
     C                   Movel     'MMA1071'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW201
     C                   End
      *
      *  If #R less than eleven then this character must be "/"
      *
     C                   If        #R < 11
     C                             and #R <> 0                                                215817
     C     1             Subst     FLD:#R        ##001
     C                   If        ##001 <> '/'
      * Send error to screen
     C                   Move      'N'           #ERR(#T)
     C                   Add       1             Idx
     C                   Move      #T            WErrFld
     C                   Movel     WErrFld       FldNamXAr(Idx)
     C                   Movel     'MMA1072'     MsgIdXAr(Idx)
     C                   End

     C                   End
     C                   End
     C                   End

      * Move pointer on 35 characters
     C                   Eval      #S = #S + 35
     C                   End

      *
     CSR                 ENDSR
     C*****************************************************************
     C* END OF BANK TO BANK INFORMATION VALIDATION                    *
     C*****************************************************************
     C/EJECT

      * Subroutine ADCHK
     E/COPY FTCPYSRC,SFTADDRCLE

      * Subroutine SWSET
     E/COPY FTCPYSRC,SFTADDRSC1

      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn

      *  Screen fields
     C                   Parm                    TranInPrim
     C***********        Parm                    TranInSecB                     CFT014
     C                   Parm                    TranInThir                     CFT014

      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr                      CFT014
     C                   Parm                    WMsgIDXAr                      CFT014
     C                   Parm                    WMsgDtaXAr                     CFT014

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      ** SWIFT 2001 switchable feature                                                        CSW201
     C                   PARM                    CSW201                                       CSW201
                                                                                              CSW201
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
