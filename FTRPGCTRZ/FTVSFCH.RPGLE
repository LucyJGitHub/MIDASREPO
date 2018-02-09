     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate SWIFT priority charge')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSFCH  - Validate Swift Priority Charge                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
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
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 13Jan04               *
      *                 210873             Date 05Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205554             Date 14May02               *
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
      *  MD046248 - Finastra Rebranding                               *
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
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API wrapper project                                 *
      *         - In java input, need to blank out a zero chg amount  *
      *         - Recompile due to change in FTVOPY2PD.               *
      *  210873 - Default SWIFT priority charges was blanked out      *
      *           after input.  Do not blank out SWIFT priority charge*
      *           if SWIFT priority code is 'U' (Urgent).             *
      *  205554 - Need to validate charge even if CFT009 is off.      *
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
                                                                                CFT009
      ** External data structure for currency codes                             CFT009
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CFT009
                                                                                CFT009
      * External DS for Funds Transfer details                                  CFT009
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    CFT009
                                                                                CFT009
      ** External data structure for access programs (short)                    CFT009
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CFT009
                                                                                CFT009
      ** External data structure for access programs                            CFT009
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CFT009
                                                                                CFT009
      *  Transaction details file parameter for FT000652                        CFT009
     D TRNDET          DS          3000                                         CFT009
                                                                                CFT009
      *  Transaction details extension file parameter for FT000652              CFT009
     D TRNEXT          DS          3000                                         CFT009
                                                                                CFT009
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
 
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
 
      * Parameters for AOCURRR0                                                 CFT009
     D C#CURR          S              3                                         CFT009
     D C#OPTN          S              7                                         CFT009
     D C#RTCD          S              7                                         CFT009
      *                                                                                       CFT120
      ** Charges to the DR of Currency                                                        CFT120
      *                                                                                       CFT120
     D P_ChgDRCcy      S              3A                                                      CFT120
 
      *                                                                                       CFT120
      ** For switchable feature CFT120                                                        CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
     D PRTCD           S              7                                                       CFT120
     D POPTN           S              7                                                       CFT120
     D PSard           S              6                                                       CFT120
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
 
      * If CFT009 is on, validate Swift Priority charge code                    CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   IF        @CFT009 = 'Y' AND SPCDE <> *BLANKS           CFT009
     C                   EXSR      VSPCODE                                      CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * If charge code is not the same as default, warning                      CFT009
                                                                                CFT009
     C                   IF        SACTION = 'I' OR SACTION = 'A'               CFT009
     C                   IF        SPCDE <> D#O2SPCD                            CFT009
     C                             AND OKSPCDE <> 'N' AND @CFT009 = 'Y'         CFT009
     C                   MOVE      'W'           OKSPCDE                        CFT009
     C                   ADD       1             WIX                            CFT009
     C                   MOVEL     'SPCDE'       WFLDNMXAR(WIX)                 CFT009
     C                   MOVEL     'FTF3181'     WMSGIDXAR(WIX)                 CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Validate
     C                   Exsr      VSPRCHG
                                                                                CFT009
      * If charge amount is not the same as default, warning                    CFT009
                                                                                CFT009
     C                   IF        SACTION = 'I' OR SACTION = 'A'               CFT009
     C                   IF        @SPCD <> D#OTDUMA5                           CFT009
     C                             AND OKSPCD <> 'N' AND @CFT009 = 'Y'          CFT009
     C                   MOVE      'W'           OKSPCD                         CFT009
     C                   ADD       1             WIX                            CFT009
     C                   MOVEL     'SSPCD'       WFLDNMXAR(WIX)                 CFT009
     C                   MOVEL     'FTF3163'     WMSGIDXAR(WIX)                 CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ELSE                                                                 205554
      * Validate even if CFT009 is not on                                                     205554
     C                   Exsr      VSPRCHG                                                    205554
                                                                                              205554
     C                   ENDIF                                                  CFT009
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKSpcd = 'N'
     C                             OR @CFT009 = 'Y' AND OKSPCDE = 'N'           CFT009
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT                                                                    CFT009
      ************************************************************              CFT009
      * VSPCODE - VALIDATION OF SWIFT PRIORITY CHARGE CODE                      CFT009
      ************************************************************              CFT009
      *                                                                         CFT009
     C     VSPCODE       BEGSR                                                  CFT009
                                                                                CFT009
      * Swift Priority charge code may only be entered if Swift                 CFT009
      * Priority is 'U'                                                         CFT009
                                                                                CFT009
     C                   IF        SSWPC = 'U'                                  CFT009
                                                                                CFT009
      * ? processing                                                            CFT009
                                                                                CFT009
     C     '?'           SCAN      SPCDE                                        CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
                                                                                CFT009
     C                   CALLB     'FT000940'                                   CFT009
     C                   PARM      *BLANKS       P#PYCD                         CFT009
                                                                                CFT009
     C                   IF        P#PYCD <> *BLANKS                            CFT009
     C                   EVAL      SPCDE = P#PYCD                               CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Check if charge code exists in payment charge definition file           CFT009
                                                                                CFT009
     C     SPCDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        NOT %FOUND                                   CFT009
     C                   MOVE      'N'           OKSPCDE                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'SPCDE'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3255'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   MOVE      'N'           OKSPCDE                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'SPCDE'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3166'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /EJECT
      ************************************************************
      * VSPRCHG - VALIDATION OF Swift Priority Charges
      ************************************************************
      *
     C     VSPRCHG       BEGSR
 
      * On insert only if Swift Priority Charge not entered set to 'N'.
      *
     C                   If        SACTION = 'I' and
     C                             SSWPC   = *Blanks
     C                   Move      'N'           SSWPC
     C                   End
      *
     C**********         If        SSWPC = 'U'                                                210873
     C**********                   AND @CFT009 <> 'Y'                                  CFT009 210873
     C**********         Eval      SSPCD = *Blanks                                            210873
     C**********         Eval      @SPCD = 0                                                  210873
     C**********         Eval      @SPCH = 0                                                  210873
     C**********         End                                                                  210873
 
      *  SWIFT Priority charge is optional.
      *  If entered must be valid for charge currency details
      *
      ** Change to IF conditioning to re-default if SSPCD = *blanks or          CFT009
      ** charges to the DR of had changed.                                      CFT009
                                                                                CFT009
     C                   If        SSPCD = *BLANKS or PCDROCHG = 'Y'            CFT009
     C***********        If        SSPCD <> *Blanks                             CFT009
                                                                                CFT009
                                                                                CFT009
     C***********        Move(P)   SSPCD         ZFIELD                         CFT009
     C***********        Eval      ZADIG = 11 - @NBDP                           CFT009
     C***********        Eval      ZADEC = @NBDP                                CFT009
      ***********                                                               CFT009
      **Validate*amount as numeric with correct d.p.                            CFT009
     C***********        CALLB     'ZALIGN'                                     CFT009
     C***********        Parm                    ZalignOK                       CFT009
     C***********        Parm                    ZFIELD                         CFT009
     C***********        Parm                    ZADEC                          CFT009
     C***********        Parm                    ZADIG                          CFT009
      ***********                                                               CFT009
     C***********        If        ZalignOK = 'N'                               CFT009
      **Send*error to screen                                                    CFT009
     C***********        Move      'N'           OKSpcd                         CFT009
     C***********        Add       1             Idx                            CFT009
     C***********        Movel     'SSPCD'       FldNamXAr(Idx)                 CFT009
     C***********        Movel     'MMA1089'     MsgIdXAr(Idx)                  CFT009
      ***********                                                               CFT009
     C***********        Else                                                   CFT009
     C***********        Move      ZFIELD        @SPCD                          CFT009
      **Format*amount for screen                                                CFT009
     C***********        Z-ADD     @SPCD         @@AMTW                         CFT009
     C***********        Z-ADD     @NBDP         @@QECN                         CFT009
     C***********        EXSR      FMTAMT                                       CFT009
     C***********        MOVE      @@AMTD        SSPCD                          CFT009
     C***********        End                                                    CFT009
     C***********        ENDIF                                                  CFT009
      ***********                                                               CFT009
     C***********        ELSE                                                   CFT009
      *                                                                         CFT009
      * If charge code <> blank and charge amount = blank, recalculate          CFT009
      * charge amount                                                           CFT009
     C                   IF        @CFT009 = 'Y' AND SPCDE <> *BLANKS           CFT009
     C                             AND OKSPCDE <> 'N'                           CFT009
      *                                                                         CFT009
      ** Also call FT000981 if charges to the DR of field has changed and       CFT009
      ** charge code is not blank.                                              CFT009
     C                             or PCDROCHG = 'Y' and SPCDE <> *BLANKS       CFT009
     C                             AND OKSPCDE <> 'N'                                         244227
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
                                                                                CFT009
     C     CFT120        IFEQ      'Y'                                                        CFT120
     C                   MOVEL     @CDRO         CHARGEDR                                     CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     SCDRO         CHARGEDR                                     CFT120
     C                   ENDIF                                                                CFT120
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
      *                                                                                       CFT120
     C                   PARM      *BLANKS       WRTCD                          CFT009
     C                   PARM      OTPYAM        PAYAMT                         CFT009
     C                   PARM      OTPCCY        PAYCCY                         CFT009
     C                   PARM      OTSMCY        SMCCY                          CFT009
     C                   PARM      O2CCDE        CHGCCY                         CFT009
     C                   PARM                    CHGEXC                         CFT009
     C                   PARM      'M'           STP                            CFT009
     C                   PARM      SPCDE         CHGCDE                         CFT009
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
     C                   EVAL      @SPCD = TOTCHG                               CFT009
                                                                                CFT009
     C                   Z-ADD     TOTCHG        @@AMTW                         CFT009
     C                   Z-ADD     A6NBDP        @@QECN                         CFT009
     C                   EXSR      FMTAMT                                       CFT009
     C                   MOVE      @@AMTD        SSPCD                          CFT009
                                                                                CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
      * If SSPCD blank or zero initialise output fields
     C                   MOVE      *BLANKS       SSPCD
     C                   Z-ADD     *ZERO         @SPCD
     C                   Z-ADD     *ZERO         @SPCH
     C                   ENDIF                                                  CFT009
 
     C                   ELSE                                                   CFT009
                                                                                CFT009
      * SWIFT priority charge may only be entered if SWIFT priority             CFT009
      * code is 'U' (FOR CFT009 ONLY)                                           CFT009
     C                   Move(P)   SSPCD         @SPCD                          CAP084
     C                   IF        @CFT009 = 'Y' AND SSWPC <> 'U'               CFT009
     C                             AND @SPCD <> *ZERO                           CAP084
      *                                                                         CFT009
      * Send error to screen                                                    CFT009
     C                   MOVE      'N'           OKSPCD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'SSPCD'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3198'     MSGIDXAR(IDX)                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
      * ? processing - Charge enquiry                                           CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C     '?'           SCAN      SSPCD                                        CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
                                                                                CFT009
     C                   IF        OKSPCDE = 'N' OR SPCDE = *BLANKS             CFT009
     C                   MOVE      'N'           OKSPCD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'SSPCD'       FLDNAMXAR(IDX)                 CFT009
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
     C                   PARM      SPCDE         CHGCDE                         CFT009
     C                   PARM                    INKC                           CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                              CFT009
     C                   Move(P)   SSPCD         ZFIELD                                       CFT009
     C                   Eval      ZADIG = 11 - @NBDP                                         CFT009
     C                   Eval      ZADEC = @NBDP                                              CFT009
                                                                                              CFT009
      * Validate amount as numeric with correct d.p.                                          CFT009
     C                   CALLB     'ZALIGN'                                                   CFT009
     C                   Parm                    ZalignOK                                     CFT009
     C                   Parm                    ZFIELD                                       CFT009
     C                   Parm                    ZADEC                                        CFT009
     C                   Parm                    ZADIG                                        CFT009
      *                                                                                       CFT009
     C                   If        ZalignOK = 'N'                                             CFT009
      * Send error to screen                                                                  CFT009
     C                   Move      'N'           OKSpcd                                       CFT009
     C                   Add       1             Idx                                          CFT009
     C                   Movel     'SSPCD'       FldNamXAr(Idx)                               CFT009
     C                   Movel     'MMA1089'     MsgIdXAr(Idx)                                CFT009
      *                                                                                       CFT009
     C                   Else                                                                 CFT009
     C                   Move      ZFIELD        @SPCD                                        CFT009
      * Format amount for screen                                                              CFT009
     C                   Z-ADD     @SPCD         @@AMTW                                       CFT009
     C                   Z-ADD     @NBDP         @@QECN                                       CFT009
     C                   EXSR      FMTAMT                                                     CFT009
     C                   MOVE      @@AMTD        SSPCD                                        CFT009
     C                   End                                                                  CFT009
     C                   ENDIF                                                                CFT009
 
     C                   End
 
     C                   ENDSR
     C************************************************************
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
                                                                                CFT009
      * Access Funds Transfer details via access program                        CFT009
                                                                                CFT009
     C                   CALL      'AOFTFRR0'                                   CFT009
     C                   PARM      '*DBERR'      C#RTCD                         CFT009
     C                   PARM      '*FIRST'      C#OPTN                         CFT009
     C     SDFTFR        PARM      SDFTFR        DSFDY                          CFT009
      *                                                                                       CFT120
      ** Check if CFT120 is switched on                                                       CFT120
      *                                                                                       CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD <> '*NRF '                                           CFT120
      *                                                                                       CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 1                                                  CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
 
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
