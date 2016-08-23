     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate VAT flags and calc charges')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVVTIN  - Validate VAT Flags                                *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT157             Date 29Aug14               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205554             Date 13May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 06Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  205554 - Vat flg error.                                      *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
 
      * Incoming Transaction
     D*TranInThir****E*DS***               EXTNAME(FTOPY4PD)                    CFT014
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)                    CFT014
 
      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY3PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)                   CFT014
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
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
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
 
      * Validate Flags
     C                   EXSR      VVATFLG
      *
      * Calculate charges
     C                   EXSR      VVATCHG
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKVat1 = 'N' or
     C                             OKVat2 = 'N' or
     C                             OKVat3 = 'N' or
     C                             OKVat4 = 'N' or
     C                             OKVat5 = 'N' or
     C                             OKVat6 = 'N' or
     C                             OKVat7 = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VVATFLG - VAT FALGS VALIDATION
      *****************************************************************
     C*
     C     VVATFLG       BEGSR
 
      *  Apply V.A.T. flag must be 'Y' or 'N' or blank.  If blank,
      *  default to value retrieved from program FT0005.
      *  If CFT010 on, flag is 'Y'                                              CFT009
 
      * VAT flag1
     C                   If        SVAT1 = *Blanks
 
     C                   IF        @CFT010 = 'Y'                                CFT009
     C                   EVAL      SVAT1 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
     C                   Eval      SVAT1 = @VATF
     C                   ENDIF                                                  CFT009
 
     C                   Else
     C                   If        SVAT1 <> 'Y' and
     C                             SVAT1 <> 'N'
      * Send error to screen
     C                   Move      'N'           OKVat1
     C                   Add       1             Idx
     C                   Movel     'SVAT1'       FldNamXAr(Idx)
     C                   Movel     'MMA1094'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
      * VAT flag2
     C                   If        SVAT2 = *Blanks
 
     C                   IF        @CFT010 = 'Y'                                CFT009
     C                   EVAL      SVAT2 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
     C                   Eval      SVAT2 = @VATF
     C                   ENDIF                                                  CFT009
 
     C                   Else
     C                   If        SVAT2 <> 'Y' and
     C                             SVAT2 <> 'N'
      * Send error to screen
     C                   Move      'N'           OKVat2
     C                   Add       1             Idx
     C                   Movel     'SVAT2'       FldNamXAr(Idx)
     C                   Movel     'MMA1094'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
      * VAT flag3
     C                   If        SVAT3 = *Blanks
 
     C                   IF        @CFT010 = 'Y'                                CFT009
     C                   EVAL      SVAT3 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
     C                   Eval      SVAT3 = @VATF
     C                   ENDIF                                                  CFT009
 
     C                   Else
     C                   If        SVAT3 <> 'Y' and
     C                             SVAT3 <> 'N'
      * Send error to screen
     C                   Move      'N'           OKVat3
     C                   Add       1             Idx
     C                   Movel     'SVAT3'       FldNamXAr(Idx)
     C                   Movel     'MMA1094'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
      * VAT flag4
     C                   If        SVAT4 = *Blanks
 
     C                   IF        @CFT010 = 'Y'                                CFT009
     C                   EVAL      SVAT4 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
     C                   Eval      SVAT4 = @VATF
     C                   ENDIF                                                  CFT009
 
     C                   Else
     C                   If        SVAT4 <> 'Y' and
     C                             SVAT4 <> 'N'
      * Send error to screen
     C                   Move      'N'           OKVat4
     C                   Add       1             Idx
     C                   Movel     'SVAT4'       FldNamXAr(Idx)
     C                   Movel     'MMA1094'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
      * VAT flag5
     C                   If        SVAT5 = *Blanks
 
     C                   IF        @CFT010 = 'Y'                                CFT009
     C                   EVAL      SVAT5 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
     C                   Eval      SVAT5 = @VATF
     C                   ENDIF                                                  CFT009
 
     C                   Else
     C                   If        SVAT5 <> 'Y' and
     C                             SVAT5 <> 'N'
      * Send error to screen
     C                   Move      'N'           OKVat5
     C                   Add       1             Idx
     C                   Movel     'SVAT5'       FldNamXAr(Idx)
     C                   Movel     'MMA1094'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
      * VAT flag6
     C                   If        SVAT6 = *Blanks
 
     C                   IF        @CFT010 = 'Y'                                CFT009
     C*******************EVAL      SVAT1 = 'Y'                                         CFT009 205554
     C                   EVAL      SVAT6 = 'Y'                                                205554
     C                   ELSE                                                   CFT009
     C                   Eval      SVAT6 = @VATF
     C                   ENDIF                                                  CFT009
 
     C                   Else
     C                   If        SVAT6 <> 'Y' and
     C                             SVAT6 <> 'N'
      * Send error to screen
     C                   Move      'N'           OKVat6
     C                   Add       1             Idx
     C                   Movel     'SVAT6'       FldNamXAr(Idx)
     C                   Movel     'MMA1094'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
      * VAT flag7
      *  - only if BLI FT enhancement feature switched on.
     C                   If        @01494 = 'Y'
 
     C                   If        SVAT7 = *Blanks
 
     C                   IF        @CFT010 = 'Y'                                CFT009
     C                   EVAL      SVAT7 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
     C                   Eval      SVAT7 = @VATF
     C                   ENDIF                                                  CFT009
 
     C                   Else
     C                   If        SVAT7 <> 'Y' and
     C                             SVAT7 <> 'N'
      * Send error to screen
     C                   Move      'N'           OKVat7
     C                   Add       1             Idx
     C                   Movel     'SVAT7'       FldNamXAr(Idx)
     C                   Movel     'MMA1094'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   End
 
      * If CFT010 is on, validate swift standard and miscellaneous              CFT009
      * charge 1 - 5 VAT flags                                                  CFT009
                                                                                CFT009
     C                   IF        @CFT010 = 'Y'                                CFT009
                                                                                CFT009
     C                   IF        VAT9 = *Blanks                               CFT009
     C                   EVAL      VAT9 = 'Y'                                   CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   IF        VAT9 <> 'Y' AND VAT9 <> 'N'                  CFT009
      * Send error to screen                                                    CFT009
     C                   MOVE      'N'           OKVAT9                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'VAT9'        FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'MMA1094'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        VAT10 = *Blanks                              CFT009
     C                   EVAL      VAT10 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   IF        VAT10 <> 'Y' AND VAT10 <> 'N'                CFT009
      * Send error to screen                                                    CFT009
     C                   MOVE      'N'           OKVAT10                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'VAT10'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'MMA1094'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        VAT11 = *Blanks                              CFT009
     C                   EVAL      VAT11 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   IF        VAT11 <> 'Y' AND VAT11 <> 'N'                CFT009
      * Send error to screen                                                    CFT009
     C                   MOVE      'N'           OKVAT11                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'VAT11'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'MMA1094'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        VAT12 = *Blanks                              CFT009
     C                   EVAL      VAT12 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   IF        VAT12 <> 'Y' AND VAT12 <> 'N'                CFT009
      * Send error to screen                                                    CFT009
     C                   MOVE      'N'           OKVAT12                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'VAT12'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'MMA1094'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        VAT13 = *Blanks                              CFT009
     C                   EVAL      VAT13 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   IF        VAT13 <> 'Y' AND VAT13 <> 'N'                CFT009
      * Send error to screen                                                    CFT009
     C                   MOVE      'N'           OKVAT13                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'VAT13'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'MMA1094'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        VAT14 = *Blanks                              CFT009
     C                   EVAL      VAT14 = 'Y'                                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   IF        VAT14 <> 'Y' AND VAT14 <> 'N'                CFT009
      * Send error to screen                                                    CFT009
     C                   MOVE      'N'           OKVAT14                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'VAT14'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'MMA1094'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDSR
      *****************************************************************
      * VVATFLG - END OF VALIDATION
      *****************************************************************
      /EJECT
      *****************************************************************
      * VVATCHG - VAT CALCULATIONS
      *****************************************************************
     C*
     C     VVATCHG       BEGSR
 
     C                   Eval      @VATD = 0
     C                   Eval      @VATT = 0
 
      * If apply V.A.T. flag is 'Y', calculate V.A.T. charge
 
     C                   IF        @CFT010 <> 'Y'                               CFT009
 
      * Transfer commission
     C                   If        OKVat1 = 'Y' and
     C                             SVAT1 = 'Y'
     C                   Eval(H)   @VATD = @VATD + (@TRCD * @VATR)
     C                   Eval(H)   @VATT = @VATT + (@TRCM * @VATR)
     C                   End
 
      * Telex
     C                   If        OKVat2 = 'Y' and
     C                             SVAT2 = 'Y'
     C                   Eval(H)   @VATD = @VATD + (@TXCD * @VATR)
     C                   Eval(H)   @VATT = @VATT + (@TXCH * @VATR)
     C                   End
 
      * Cheque
     C                   If        OKVat3 = 'Y' and
     C                             SVAT3 = 'Y'
     C                   Eval(H)   @VATD = @VATD + (@CQCD * @VATR)
     C                   Eval(H)   @VATT = @VATT + (@CQCH * @VATR)
     C                   End
 
      * Costs
     C                   If        OKVat4 = 'Y' and
     C                             SVAT4 = 'Y'
     C                   Eval(H)   @VATD = @VATD + (@CSTD * @VATR)
     C                   Eval(H)   @VATT = @VATT + (@CSTA * @VATR)
     C                   End
 
      * SWIFT
     C                   If        OKVat5 = 'Y' and
     C                             SVAT5 = 'Y'
     C                   Eval(H)   @VATD = @VATD + (@SPCD * @VATR)
     C                   Eval(H)   @VATT = @VATT + (@SPCH * @VATR)
     C                   End
 
      * Miscellaneous
     C                   If        OKVat6 = 'Y' and
     C                             SVAT6 = 'Y'
     C                   Eval(H)   @VATD = @VATD + (@MSCD * @VATR)
     C                   Eval(H)   @VATT = @VATT + (@MSCH * @VATR)
     C                   End
 
      * Fx/Change commission
     C                   If        OKVat7 = 'Y' and
     C                             SVAT7 = 'Y' and
     C                             @01494 = 'Y'
     C                   Eval(H)   @VATD = @VATD + (@CHCD * @VATR)
     C                   Eval(H)   @VATT = @VATT + (@CHCM * @VATR)
     C                   End
                                                                                CFT009
                                                                                CFT009
U001 C                   ELSE                                                   CFT009
                                                                                CFT009
      * Transfer commission                                                     CFT009
                                                                                CFT009
     C                   IF        SVAT1 = 'Y' AND OKVAT1 = 'Y'                 CFT009
     C                   EVAL      @VATD = @VATD + @TRCD                        CFT009
     C                   EVAL      @VATT = @VATT + @TRCM                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Telex                                                                   CFT009
                                                                                CFT009
     C                   IF        SVAT2 = 'Y' AND OKVAT2 = 'Y'                 CFT009
     C                   EVAL      @VATD = @VATD + @TXCD                        CFT009
     C                   EVAL      @VATT = @VATT + @TXCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Cheque                                                                  CFT009
                                                                                CFT009
     C                   IF        SVAT3 = 'Y' AND OKVAT3 = 'Y'                 CFT009
     C                   EVAL      @VATD = @VATD + @CQCD                        CFT009
     C                   EVAL      @VATT = @VATT + @CQCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Costs                                                                   CFT009
                                                                                CFT009
     C                   IF        SVAT4 = 'Y' AND OKVAT4 = 'Y'                 CFT009
     C                   EVAL      @VATD = @VATD + @CSTD                        CFT009
     C                   EVAL      @VATT = @VATT + @CSTA                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * SWIFT priority                                                          CFT009
                                                                                CFT009
     C                   IF        SVAT5 = 'Y' AND OKVAT5 = 'Y'                 CFT009
     C                   EVAL      @VATD = @VATD + @SPCD                        CFT009
     C                   EVAL      @VATT = @VATT + @SPCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Miscellaneous                                                           CFT009
                                                                                CFT009
     C                   IF        SVAT6 = 'Y' AND OKVAT6 = 'Y'                 CFT009
     C                   EVAL      @VATD = @VATD + @MSCD                        CFT009
     C                   EVAL      @VATT = @VATT + @MSCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Fx/Change commission                                                    CFT009
                                                                                CFT009
     C                   IF        SVAT7 = 'Y' AND OKVAT7 = 'Y'                 CFT009
     C                             AND @01494 = 'Y'                             CFT009
     C                   EVAL      @VATD = @VATD + @CHCD                        CFT009
     C                   EVAL      @VATT = @VATT + @CHCM                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * If CFT010 is on, calculate swift standard and miscellaneous             CFT009
      * charge 1 - 5 VAT                                                        CFT009
                                                                                CFT009
     C                   IF        OKVAT9 = 'Y' AND VAT9 = 'Y'                  CFT009
     C                   EVAL      @VATD = @VATD + @MI1CD                       CFT009
     C                   EVAL      @VATT = @VATT + @M1CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        OKVAT10 = 'Y' AND VAT10 = 'Y'                CFT009
     C                   EVAL      @VATD = @VATD + @MI2CD                       CFT009
     C                   EVAL      @VATT = @VATT + @M2CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        OKVAT11 = 'Y' AND VAT11 = 'Y'                CFT009
     C                   EVAL      @VATD = @VATD + @MI3CD                       CFT009
     C                   EVAL      @VATT = @VATT + @M3CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        OKVAT12 = 'Y' AND VAT12 = 'Y'                CFT009
     C                   EVAL      @VATD = @VATD + @MI4CD                       CFT009
     C                   EVAL      @VATT = @VATT + @M4CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        OKVAT13 = 'Y' AND VAT13 = 'Y'                CFT009
     C                   EVAL      @VATD = @VATD + @MI5CD                       CFT009
     C                   EVAL      @VATT = @VATT + @M5CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        OKVAT14 = 'Y' AND VAT14 = 'Y'                CFT009
     C                   EVAL      @VATD = @VATD + @SSCD                        CFT009
     C                   EVAL      @VATT = @VATT + @SSCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * V.A.T. amount = total x V.A.T. rate.                                    CFT009
                                                                                CFT009
     C                   EVAL(H)   @VATD = @VATD * @VATR                        CFT009
     C                   EVAL(H)   @VATT = @VATT * @VATR                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
 
     C                   ENDSR
      *****************************************************************
      * VVATCHG - END OF CALCULATIONS
      *****************************************************************
      /EJECT
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
     C***********        Parm                    TranInThir                     CFT014
     C                   Parm                    TranInFour                     CFT014
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
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
