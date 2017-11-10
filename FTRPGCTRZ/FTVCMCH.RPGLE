     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate commission charges')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCMCH  - Validate Commission Charges                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244227             Date 12Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 BUG8914            Date 07Oct05               *
      *                 BUG8689            Date 03Oct05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 07Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  244227 - Don't call FT000981 if charge code not found on file*
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG8914- Don't do code for BUG8689 is SCHCD is blanks        *
      *  BUG8689- Do not validate if amount is zero.                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompiled due to change in FTVOPY2PD.              *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

     FFTPCHGL0  IF   E           K DISK                                         CFT009

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
                                                                                CFT009
      ** Array of Warning in error.                                             CFT009
     D WFLDNMXAR       S             10A   DIM(XARRAYMAX)                       CFT009
                                                                                CFT009
      ** Array of Warning message IDs                                           CFT009
     D WMSGIDXAR       S                   DIM(XARRAYMAX) LIKE(#MSGID)          CFT009
                                                                                CFT009
      ** Array of Warning message data.                                         CFT009
     D WMSGDTAXAR      S                   DIM(XARRAYMAX) LIKE(#MSGDATA)        CFT009

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D*TranInThir****E*DS***               EXTNAME(FTOPY4PD)                    CFT014
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)                    CFT014

      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY3PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)                   CFT014

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
                                                                                CFT009
      ** Valid Payments layout                                                  CFT009
     D VALIDPMNT     E DS                  EXTNAME(FTVOPAYPD)                   CFT009
     D  QQCDRO1      E                     EXTFLD(QQCDRO)                                     CGL029
                                                                                CFT009
      ** Valid Outgoing Payments Extension File                                 CFT009
     D VALIDPMTX     E DS                  EXTNAME(FTVOPY2PD)                   CFT009
                                                                                CFT009
      ** Valid Outgoing Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009

      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      * External DS for Funds Transfer details                                  CFT009
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    CFT009
                                                                                CFT009
      ** External data structure for currency codes                             CFT009
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CFT009
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
                                                                                CFT009
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                CFT009
      ** External data structure for access programs                            CFT009
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CFT009
                                                                                CFT009
      *  Transaction details file parameter for FT000652                        CFT009
     D TRNDET          DS          3000                                         CFT009
                                                                                CFT009
      *  Transaction details extension file parameter for FT000652              CFT009
     D TRNEXT          DS          3000                                         CFT009

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
                                                                                CFT009
      ** Index for arrays of warning message ids etc                            CFT009
     D WIX             S              3P 0                                      CFT009

     D WDATE           S              5  0

     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
                                                                                CFT009
      * Parameter for FT000940                                                  CFT009
     D P#PYCD          S                   LIKE(PYCHCD)                         CFT009
                                                                                CFT009
      ** Parameters for FT000652                                                CFT009
     D MRTCD           S             10                                         CFT009
     D TRNTYP          S              2                                         CFT009
     D CHGCDE          S              5                                         CFT009
     D INKC            S              1                                         CFT009
                                                                                CFT009
      ** Parameters for FT000981                                                CFT009
     D WRTCD           S             10A                                        CFT009
     D PAYAMT          S             13P 0                                      CFT009
     D PAYCCY          S              3A                                        CFT009
     D SMCCY           S              3A                                        CFT009
     D CHGCCY          S              3A                                        CFT009
     D CHGEXC          S             13P 8                                      CFT009
     D STP             S              1A                                        CFT009
     D TOTCHG          S             13P 0                                      CFT009
     D CHGAMT          S             13P 0                                      CFT009
     D PTIERC          S             13A   DIM(11)                              CFT009
     D PTIERA          S             13A   DIM(11)                              CFT009
     D SETTAMT         S             13P 0                                      CFT009
     D*CHARGEDR*       S             12A                                               CFT009 CGL029
     D CHARGEDR        S             18A                                                      CGL029
     D ADDDEDUCT       S              1A                                        CFT009
     D P_ChgDRCcy      S              3A                                                      CFT120
     D CFT120          S              1A                                                      CFT120
                                                                                CFT009
      * Parameters for AOCURRR0                                                 CFT009
     D C#CURR          S              3                                         CFT009
     D C#OPTN          S              7                                         CFT009
     D C#RTCD          S              7                                         CFT009
                                                                                CFT009
                                                                                             BUG8689
     D SCHCDCHK        S             16A                                                     BUG8689
     D Pos             S              2  0                                                   BUG8689
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

      ** Initialization
      *
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   EVAL      WFLDNMXAR = *BLANKS                          CFT009
     C                   EVAL      WMSGIDXAR  = *BLANKS                         CFT009
     C                   EVAL      WMSGDTAXAR = *BLANKS                         CFT009
     C                   EVAL      WIX = 0                                      CFT009
     C                   Eval      Idx = 0

      * If CFT009 is on, validate FX/Change charge code                         CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   IF        @CFT009 = 'Y' AND FXCDE <> *BLANKS           CFT009
     C                   EXSR      VFXCODE                                      CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * If charge code is not the same as default, warning                      CFT009
                                                                                CFT009
     C                   IF        SACTION = 'I' OR SACTION = 'A'               CFT009
     C                   IF        FXCDE <> D#O2FXCD                            CFT009
     C                             AND OKFXCDE <> 'N' AND @CFT009 = 'Y'         CFT009
     C                   MOVE      'W'           OKFXCDE                        CFT009
     C                   ADD       1             WIX                            CFT009
     C                   MOVEL     'FXCDE'       WFLDNMXAR(WIX)                 CFT009
     C                   MOVEL     'FTF3177'     WMSGIDXAR(WIX)                 CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009

      * Validate
     C                   Exsr      VCOMCHG
                                                                                CFT009
      * If charge amount is not the same as default, warning                    CFT009
                                                                                CFT009
     C                   IF        SACTION = 'I' OR SACTION = 'A'               CFT009
     C                   IF        @CHCD <> D#OTOPDUM7                          CFT009
     C                             AND OKCHCD <> 'N' AND @CFT009 = 'Y'          CFT009
     C                   MOVE      'W'           OKCHCD                         CFT009
     C                   ADD       1             WIX                            CFT009
     C                   MOVEL     'SCHCD'       WFLDNMXAR(WIX)                 CFT009
     C                   MOVEL     'FTF3159'     WMSGIDXAR(WIX)                 CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009

      ** If an error was found, set the return code appropriately
      *
     C                   If        OKChcd = 'N'
     C                             OR @CFT009 = 'Y' AND OKFXCDE = 'N'           CFT009
     C                   Eval      RetCodeIn = 'Error'
     C                   End

      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      ************************************************************
      * VCOMCHG - VALIDATION OF COMMISSION CHARGES
      ************************************************************
      *
     C     VCOMCHG       BEGSR

      * FX/Change commission only allowed if Pay and Settle currencies
      * are different.  If entered must be valid for charge currency
      * details.

      * If EMU FT Enhancement is switched on then set work date.
     C                   If        @CEU006 = 'Y'

     C                   If        SADDC = 'A'
     C                   Eval      WDATE = @SLDT
     C                   Else
     C                   Eval      WDATE = @PVDT
     C                   End

     C                   End

     C                   If        SCHCD <> *blanks                                          BUG8914
     C                   Eval      SCHCDCHK = SCHCD                                          BUG8689
     C                   Eval      pos = %scan ('.':SCHCDCHK)                                BUG8689
     C                   If        pos <> 0                                                  BUG8914
     C                   Eval      SCHCDCHK = %replace('0': SCHCDCHK: pos)                   BUG8689
     C                   EndIf                                                               BUG8914
     C                   Z-ADD     @NBDP         @@IDP                                       BUG8689
     C                   Z-ADD     13            @@IINT                                      BUG8689
                                                                                             BUG8689
     C                   CALLB     'ZA0840'                                                  BUG8689
     C                   PARM      *blanks       RetCodeIn                                   BUG8689
     C                   PARM                    SCHCDCHK                                    BUG8689
     C                   PARM                    @@IDP             3 0                       BUG8689
     C                   PARM                    @@IINT            3 0                       BUG8689
     C                   PARM      'Y'           @@MTID            1                         BUG8689
     C                   PARM                    @@Ercd            1 0                       BUG8689
     C                   PARM                    @@Amt            15 0                       BUG8689
     C                   PARM                    BNDCSP            1                         BUG8689
     C                   EndIf                                                               BUG8914
                                                                                             BUG8689
     C                   If        SCHCD <> *Blanks
     C                             and @@Amt <> 0                                            BUG8689

     C                   If        SSMCY <> SPCCY

      * If EMU FT  Enhancement is switched on
      *  and both Settle Ccy and Pay Ccy are either 'In' or Euros,
      *  then FX/Change Commission must be zero.
     C                   If        @CEU006 = 'Y' and
     C                             @INCYS = 'Y' and
     C                             @TPSDS <= WDATE and
     C                             SPCCY = BKEURO or

     C                             @CEU006 = 'Y' and
     C                             @INCYP = 'Y' and
     C                             @TPSDP <= WDATE and
     C                             SSMCY = BKEURO or

     C                             @CEU006 = 'Y' and
     C                             @INCYS = 'Y' and
     C                             @TPSDS <= WDATE and
     C                             @INCYP = 'Y' and
     C                             @TPSDP <= WDATE
      * Send error to screen
     C                   Move      'N'           OKChcd
     C                   Add       1             Idx
     C                   Movel     'SCHCD'       FldNamXAr(Idx)
     C                   Movel     'MMA1091'     MsgIdXAr(Idx)

     C                   Else
                                                                                CFT009
      * ? processing - Charge enquiry                                           CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C     '?'           SCAN      SCHCD                                        CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
                                                                                CFT009
     C                   IF        OKFXCDE = 'N' OR FXCDE = *BLANKS             CFT009
     C                   MOVE      'N'           OKCHCD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'SCHCD'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3206'     MSGIDXAR(IDX)                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   EVAL      TRNDET = VALIDPMNT                           CFT009
     C                   EVAL      TRNEXT = VALIDPMTX                           CFT009
                                                                                CFT009
     C                   CALLB     'FT000652'                                   CFT009
     C                   PARM      *BLANKS       MRTCD                          CFT009
     C                   PARM                    TRNDET                         CFT009
     C                   PARM                    TRNEXT                         CFT009
     C                   PARM      'OP'          TRNTYP                         CFT009
     C                   PARM      FXCDE         CHGCDE                         CFT009
     C                   PARM                    INKC                           CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   Move(P)   SCHCD         ZFIELD
     C                   Eval      ZADIG = 11 - @NBDP
     C                   Eval      ZADEC = @NBDP

      * Validate amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG

     C                   If        ZalignOK = 'N'
      * Send error to screen
     C                   Move      'N'           OKChcd
     C                   Add       1             Idx
     C                   Movel     'SCHCD'       FldNamXAr(Idx)
     C                   Movel     'MMA1092'     MsgIdXAr(Idx)

     C                   Else
     C                   Move      ZFIELD        @CHCD
      * Format amount for screen
     C                   Z-ADD     @CHCD         @@AMTW
     C                   Z-ADD     @NBDP         @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SCHCD
     C                   End

     C                   End

     C                   Else
      * Send error to screen
     C                   Move      'N'           OKChcd
     C                   Add       1             Idx
     C                   Movel     'SCHCD'       FldNamXAr(Idx)
     C                   Movel     'MMA1093'     MsgIdXAr(Idx)
     C                   End

     C                   End

      * If SCHCD blank or zero initialise output fields
     C***********        IF        SCHCD = *BLANKS                              CFT009
      ** Change to IF conditioning to re-default if SCHCD = *blanks or          CFT009
      ** charges to the DR of had changed.                                      CFT009
                                                                                CFT009
     C                   If        SCHCD = *BLANKS or PCDROCHG = 'Y'            CFT009
      *                                                                         CFT009
      * If charge code <> blank and charge amount = blank, recalculate          CFT009
      * charge amount                                                           CFT009
     C                   IF        @CFT009 = 'Y' AND FXCDE <> *BLANKS           CFT009
     C                             AND OKFXCDE <> 'N'                           CFT009
      *                                                                         CFT009
      ** Also call FT000981 if charges to the DR of field has changed and       CFT009
      ** charge code is not blank.                                              CFT009
     C                             or PCDROCHG = 'Y' and FXCDE <> *BLANKS       CFT009
     C                             AND OKFXCDE <> 'N'                                         244227
                                                                                CFT009
     C                   CALLB     'AOCURRR0'                                   CFT009
     C                   PARM      *Blanks       C#RTCD                         CFT009
     C                   PARM      '*KEY   '     C#OPTN                         CFT009
     C                   PARM      O2CCDE        C#CURR                         CFT009
     C     SDCURR        PARM      *BLANKS       DSSDY                          CFT009
                                                                                CFT009
      * If use transaction exchange rate, add it in                             CFT009
     C                   IF        CHTRCY = 'Y'                                 CFT009
     C                   EVAL      CHGEXC = O2XRTE                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      CHGEXC = A6SPRT                              CFT009
     C                   ENDIF                                                  CFT009
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     @CDRO         CHARGEDR                                     CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     SCDRO         CHARGEDR                                     CFT120
     C                   ENDIF                                                                CFT120
                                                                                CFT009
     C                   CALLB     'FT000981'                                   CFT009
      * OUTPUTS:                                                                CFT009
      *                                                                         CFT009
      ** Return Code (10A)                                                      CFT009
      ** Payment Amount (13,0)                                                  CFT009
      ** Payment Currency (3A)                                                  CFT009
      ** Charges Currency (3A)                                                  CFT009
      ** Exchange Rate from transaction (13,8)                                  CFT009
      ** STP flag (1A)                                                          CFT009
      ** Payment Charge Code (5A)                                               CFT009
      ** Settle Amount (13,0)                                                                 CFT120
      ** Charges to debit of account (18A)                                                    CFT120
      ** Add deduct indicator (1A)                                                            CFT120
      ** Charges to the DR of Currency (3A)                                                   CFT120
     C                   PARM      *BLANKS       WRTCD                          CFT009
     C                   PARM      OTPYAM        PAYAMT                         CFT009
     C                   PARM      OTPCCY        PAYCCY                         CFT009
     C                   PARM      OTSMCY        SMCCY                          CFT009
     C                   PARM      O2CCDE        CHGCCY                         CFT009
     C                   PARM                    CHGEXC                         CFT009
     C                   PARM      'M'           STP                            CFT009
     C                   PARM      FXCDE         CHGCDE                         CFT009
     C                   PARM      OTSMAM        SETTAMT                        CFT009
     C**********         PARM      SCDRO         CHARGEDR                              CFT009 CFT120
     C                   PARM                    CHARGEDR                                     CFT120
     C                   PARM      OTADDC        ADDDEDUCT                      CFT009
     C                   PARM      OTCDRC        P_ChgDRCcy                                   CFT120
      *                                                                         CFT009
      * RETURNS:                                                                CFT009
      ** Total Charge (13,0)                                                    CFT009
      ** Chargeable Amount (13,0)                                               CFT009
      ** Charge per Tier (11 x 13A)                                             CFT009
      ** Amount being charged by Tier (11 x 13A)                                CFT009
     C                   PARM                    TOTCHG                         CFT009
     C                   PARM                    CHGAMT                         CFT009
     C                   PARM                    PTIERC                         CFT009
     C                   PARM                    PTIERA                         CFT009
                                                                                CFT009
     C                   EVAL      @CHCD = TOTCHG                               CFT009
                                                                                CFT009
     C                   Z-ADD     TOTCHG        @@AMTW                         CFT009
     C                   Z-ADD     A6NBDP        @@QECN                         CFT009
     C                   EXSR      FMTAMT                                       CFT009
     C                   MOVE      @@AMTD        SCHCD                          CFT009
                                                                                CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   MOVE      *BLANKS       SCHCD
     C                   Z-ADD     *ZERO         @CHCD
     C                   Z-ADD     *ZERO         @CHCM
     C                   ENDIF                                                  CFT009
     C                   END

     C                   ENDSR
     C************************************************************
      /EJECT                                                                    CFT009
      ************************************************************              CFT009
      * VFXCODE - VALIDATION OF FX/CHANGE CHARGE CODE                           CFT009
      ************************************************************              CFT009
      *                                                                         CFT009
     C     VFXCODE       BEGSR                                                  CFT009
                                                                                CFT009
      * FX/Change commission only allowed if Pay and Settle currencies          CFT009
      * are different.  If entered must be valid for charge currency            CFT009
      * details.                                                                CFT009
                                                                                CFT009
      * If EMU FT Enhancement is switched on then set work date.                CFT009
     C                   IF        @CEU006 = 'Y'                                CFT009
                                                                                CFT009
     C                   IF        SADDC = 'A'                                  CFT009
     C                   EVAL      WDATE = @SLDT                                CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      WDATE = @PVDT                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        SSMCY <> SPCCY                               CFT009
                                                                                CFT009
      * If EMU FT  Enhancement is switched on                                   CFT009
      *  and both Settle Ccy and Pay Ccy are either 'In' or Euros,              CFT009
      *  then FX/Change Commission must be zero.                                CFT009
     C                   IF        @CEU006 = 'Y' AND                            CFT009
     C                             @INCYS = 'Y' AND                             CFT009
     C                             @TPSDS <= WDATE AND                          CFT009
     C                             SPCCY = BKEURO OR                            CFT009
                                                                                CFT009
     C                             @CEU006 = 'Y' AND                            CFT009
     C                             @INCYP = 'Y' AND                             CFT009
     C                             @TPSDP <= WDATE AND                          CFT009
     C                             SSMCY = BKEURO OR                            CFT009
                                                                                CFT009
     C                             @CEU006 = 'Y' AND                            CFT009
     C                             @INCYS = 'Y' AND                             CFT009
     C                             @TPSDS <= WDATE AND                          CFT009
     C                             @INCYP = 'Y' AND                             CFT009
     C                             @TPSDP <= WDATE                              CFT009
      * Send error to screen                                                    CFT009
                                                                                CFT009
     C                   MOVE      'N'           OKFXCDE                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'FXCDE'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3251'     MSGIDXAR(IDX)                  CFT009
                                                                                CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
      * ? processing                                                            CFT009
                                                                                CFT009
     C     '?'           SCAN      FXCDE                                        CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
                                                                                CFT009
     C                   CALLB     'FT000940'                                   CFT009
     C                   PARM      *BLANKS       P#PYCD                         CFT009
                                                                                CFT009
     C                   IF        P#PYCD <> *BLANKS                            CFT009
     C                   EVAL      FXCDE = P#PYCD                               CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Check if charge code exists in payment charge definition file           CFT009
                                                                                CFT009
     C     FXCDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        NOT %FOUND                                   CFT009
     C                   MOVE      'N'           OKFXCDE                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'FXCDE'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3252'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   MOVE      'N'           OKFXCDE                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'FXCDE'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3200'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
     C* END VALIDATION
     C************************************************************
     C/EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C*
     C     *ENTRY        PLIST

      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn

      *  Screen fields
     C                   Parm                    TranInPrim
     C***********        Parm                    TranInThir                     CFT014
     C                   Parm                    TranInFour                     CFT014

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTAXAR                     CFT009
      *
      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009

      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                CFT009
      * Access Funds Transfer details via access program                        CFT009
                                                                                CFT009
     C                   CALL      'AOFTFRR0'                                   CFT009
     C                   PARM      '*DBERR'      C#RTCD                         CFT009
     C                   PARM      '*FIRST'      C#OPTN                         CFT009
     C     SDFTFR        PARM      SDFTFR        DSFDY                          CFT009
      *                                                                         CFT009
      ** Access SAR details file to determine if CFT120 enhancement is                        CFT120
      ** switched on.                                                                         CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      '*BLANKS'     @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')                CFT120
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT120
     C                   Z-ADD     1             DBASE                                        CFT120
     C                   MOVEL     'CFT120'      DBKEY                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'N'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      *
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
(c) Misys International Banking Systems Ltd. 2001
