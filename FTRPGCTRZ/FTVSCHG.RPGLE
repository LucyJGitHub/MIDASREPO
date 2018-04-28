     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OP senders charges')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  FTVSCHG   - Validate OP Sender's Charges                     *
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
      *  Prev Amend No. MD000091           Date 06May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24724           Date 03Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 200949             Date 05Oct06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 208219             Date 27Apr06               *
      *                 BUG8541            Date 31Oct05               *
      *                 BUG3919            Date 14Sep04               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG24724 - Senders and receivers charge error                *
      *             (already applied by 208219 and BUG8541            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  200949 - Suppress FTM3244 if payment will not produce a      *
      *           MT103.  Applied core fix 197943.                    *
      *           Same fix as 208219.                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  208219 - MT103 mandatory fields.                             *
      *  BUG8541- If senders charge is 0.00 then treat as zero        *
      *  BUG3919- Sender's charges warning msg error                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      ** Incoming Transaction (First screen level 1)
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      ** Incoming Transaction (Fourth screen level 2)
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)
 
      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** FT0010 input parameters
     D/COPY FTCPYSRC,FT0010D001
 
     D WSCHG           DS            75
     D  WSCC1                  1      3
     D  WSCH1                  4     15
     D  WSCC2                 16     18
     D  WSCH2                 19     30
     D  WSCC3                 31     33
     D  WSCH3                 34     45
     D  WSCC4                 46     48
     D  WSCH4                 47     60
     D  WSCC5                 61     63
     D  WSCH5                 64     75
     D  WSCYCH2               16     75
     D  WSCYCH3               31     75
     D  WSCYCH4               46     75
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning error message ids etc
     D WIx             S              3P 0
 
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADIG           S              2  0
     D ZADEC           S              1  0
 
     D WSCH1CHK        S             16A                                                     BUG8541
     D Pos             S              2  0                                                   BUG8541
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
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
 
      ** Initialization
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
 
      ** Sender's Charges validation
 
     C                   ExSr      SrSndChg
 
      ** If an error was found, set the return code appropriately
 
     C                   If        (OKSCH1 = 'N') Or (OKSCH2 = 'N') Or
     C                             (OKSCH3 = 'N') Or (OKSCH4 = 'N') Or
     C                             (OKSCH5 = 'N') Or (OKSCC1 = 'N') Or
     C                             (OKSCC2 = 'N') Or (OKSCC3 = 'N') Or
     C                             (OKSCC4 = 'N') Or (OKSCC5 = 'N')
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrSndChg
      *****************************************************************
      *                                                               *
      * SR/SrSndChg   - Validate Sender's Charges                     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZALIGN      - Validate and align fields.                      *
      * ZEDIT       - Converts numeric value to screen value.         *
      * SrCTotal    - Validate Total Charges.                         *
      *                                                               *
      *****************************************************************
 
     C     SrSndChg      BegSr
 
      ** Sender's Charges Remitted is optional.
      ** If entered must be valid for payment currency details
 
     C                   Eval      @SCH1 = *Zero
     C                   Eval      @SCH2 = *Zero
     C                   Eval      @SCH3 = *Zero
     C                   Eval      @SCH4 = *Zero
     C                   Eval      @SCH5 = *Zero
     C                   Eval      @SENT = *Zero
 
     C                   Eval      WSCH1 = SSCH1
     C                   Eval      WSCH2 = SSCH2
     C                   Eval      WSCH3 = SSCH3
     C                   Eval      WSCH4 = SSCH4
     C                   Eval      WSCH5 = SSCH5
     C                   Eval      WSCC1 = SSCC1
     C                   Eval      WSCC2 = SSCC2
     C                   Eval      WSCC3 = SSCC3
     C                   Eval      WSCC4 = SSCC4
     C                   Eval      WSCC5 = SSCC5
 
      ** Calculate first the Total Charges
 
     C                   ExSr      SrCalc
 
      ** If entered blanks, default 1st sender's charge to 0 with
      ** currency equal to pay currency.
 
     C                   If        (WSCHG = *Blank) And (SDTCH = 'BEN')
     C                             And (@MT103='Y')                                           208219
     C                   If        SADDC = 'A'
     C*******************Move      '0'           SSCH1                          BUG3919
     C                   Move      WTOTAL        SSCH1                          BUG3919
     C                   Move      SSMCY         SSCC1                          BUG3919
     C                   Else
 
      ** Default first sender amount field by the total charge accumu-
      ** lated.
 
     C                   Move      WTOTAL        SSCH1
     C                   Move      SPCCY         SSCC1                          BUG3919
     C                   EndIf
     C*******************Move      SPCCY         SSCC1                          BUG3919
     C                   Eval      WSCC1 = SSCC1
     C                   Eval      WSCH1 = SSCH1
     C                   EndIf
 
      ** Sender's charges entered while the Detail of Charges is 'OUR',
      ** error.
 
     C                   If        WSCHG <> *Blank
     C                   If        (SDTCH = 'BEN') Or (SDTCH = 'SHA')
 
      ** If sender's charges is entered, instructed amount must not be
      ** zero.
 
      * Cater for senders charge being something like '0.00'                                 BUG8541
     C                   If        WSCH1 <> *blanks                                          BUG8541
     C                   Eval      WSCH1CHK = WSCH1                                          BUG8541
     C                   Eval      pos = %scan ('.':WSCH1CHK)                                BUG8541
     C                   If        pos <> 0                                                  BUG8541
     C                   Eval      WSCH1CHK = %replace('0': WSCH1CHK: pos)                   BUG8541
     C                   EndIf                                                               BUG8541
     C                   Z-ADD     A6NBDP        @@IDP                                       BUG8541
     C                   Z-ADD     11            @@IINT                                      BUG8541
                                                                                             BUG8541
     C                   CALLB     'ZA0840'                                                  BUG8541
     C                   PARM      *blanks       RetCodeIn                                   BUG8541
     C                   PARM                    WSCH1CHK                                    BUG8541
     C                   PARM                    @@IDP             3 0                       BUG8541
     C                   PARM                    @@IINT            3 0                       BUG8541
     C                   PARM      'Y'           @@MTID            1                         BUG8541
     C                   PARM                    @@Ercd            1 0                       BUG8541
     C                   PARM                    @@Amt            15 0                       BUG8541
     C                   PARM                    BNDCSP            1                         BUG8541
     C                   EndIf                                                               BUG8541
                                                                                             BUG8541
     C                   If        @PDAM = *Zero And SPYTP <> 'RP'
     C                             and @@AMT <> 0                                            BUG8541
     C                   If        @MT103='Y'                                                 208219
     C                   Movel     'FTM3244'     WErrMsgId         7
     C                   ExSr      SrFldChk
     C                   Goto      ExSCHG
     C                   Endif                                                                208219
     C                   EndIf
 
     C                   Else
     C                   If        SDTCH = 'OUR'
     C                   Movel     'FTM3233'     WErrMsgId
     C                   ExSr      SrFldChk
     C                   Goto      ExSCHG
     C                   EndIf
     C                   EndIf
 
      ** Validate 1st Sender Charge field
 
     C                   If        (SSCC1 = *Blank) And (SSCH1 = *Blank)
 
      ** Other charges entered while the first sender's charge is blank
      ** - error.
 
     C                   If        WSCYCH2 <> *Blank
     C                   Move      'N'           OKSCC1
     C                   Add       1             Idx
     C                   Movel     'SSCC1'       FldNamXAr(Idx)
     C                   Movel     'FTM3235'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
     C                   Else
 
      ** Validate currency if entered
 
     C                   If        SSCC1 <> *Blank
     C                   Move      SSCC1         WCURCY            3
     C                   Move      '1'           WCYIND            1
     C                   Move      'N'           WCYERR            1
     C                   ExSr      SrACCY
 
      ** Currency not valid or not defined in the system
 
     C                   If        WCYERR = 'Y'
     C                   Goto      ExSCHG
     C                   EndIf
 
      ** 1st currency entered and the 1st charge amount is blank while
      ** currency is not equal to pay currency, error.
 
     C                   If        WCYERR = 'N'
     C                   If        (SSCH1 = *Blank)
     C                   If        (SSCC1 <> SPCCY)
     C                   Move      'N'           OKSCH1
     C                   Add       1             Idx
     C                   Movel     'SSCH1'       FldNamXAr(Idx)
     C                   Movel     'FTM3260'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   Else
     C                   If        SADDC = 'A'
     C                   Move      '0'           SSCH1
     C                   Else
     C                   Move      WTOTAL        SSCH1
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ***1st*charge*currency entered not equal to pay currency and the          BUG3919
      ***entry*is*the*last of the sender's charges entries, default             BUG3919
      ***2nd*sender's*charge to pay currency with amount equal to 0 if          BUG3919
      ***the*add/deduct*is 'A' otherwise total charges.                         BUG3919
      *******************                                                       BUG3919
     C*******************If        (SSCC1 <> SPCCY) And (WSCYCH2 = *Blank)      BUG3919
     C*******************If        SADDC = 'A'                                  BUG3919
     C*******************Move      '0'           SSCH2                          BUG3919
     C*******************Else                                                   BUG3919
      *******************                                                       BUG3919
      ***Default*2nd*sender amount field by the total charge accumu-            BUG3919
      ***lated.**********                                                       BUG3919
      *******************                                                       BUG3919
     C*******************Move      WTOTAL        SSCH2                          BUG3919
     C*******************EndIf                                                  BUG3919
     C*******************Move      SPCCY         SSCC2                          BUG3919
     C*******************EndIf                                                  BUG3919
     C                   EndIf
     C                   EndIf
 
      ** 1st charge amount is entered w/ blank charge currency and en -
      ** try is the last of the sender's charges entries, default
      ** charge currency to pay currency.
 
     C                   If        SSCH1 <> *Blank
     C                   If        SSCC1 = *Blank
     C                   If        WSCYCH2 = *Blank
     C                   Move      SPCCY         SSCC1
     C                   Else
 
      ** 1st charge amount is entered with blank charge currency and
      ** entry is not the last of the sender's charges entries,
      ** error.
 
     C                   Move      'N'           OKSCC1
     C                   Add       1             Idx
     C                   Movel     'SSCC1'       FldNamXAr(Idx)
     C                   Movel     'FTM3254'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   Eval      ZFIELD = *Blank
     C                   Eval      ZFIELD = SSCH1
     C                   Eval      ZADIG = 11 - A6NBDP
     C                   Eval      ZADEC = A6NBDP
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        ZalignOK = 'N'
     C                   Move      'N'           OKSCH1
     C                   Add       1             Idx
     C                   Movel     'SSCH1'       FldNamXAr(Idx)
     C                   Movel     'FTM3234'     MsgIdXAr(Idx)
     C*****SSCC1         Cat       SSCH1         MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCC1))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(SSCC1)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCH1))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SSCH1)                    MD000091
     C                   Goto      ExSCHG
     C                   Else
     C                   Move      ZFIELD        @SCH1
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Move      ZFIELD        SSCH1
 
      ** Check if this is the last entry.
 
     C                   If        WSCYCH2 = *Blank
     C                   Z-Add     @SCH1         WLAST            13 0
     C                   Eval      @SENT = 1
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Validate 2nd Sender Charge field
 
     C                   If        (SSCC2 = *Blank) And (SSCH2 = *Blank)
 
      ** Other charges entered while the first sender's charge is blank
      ** - error.
 
     C                   If        WSCYCH3 <> *Blank
     C                   Move      'N'           OKSCC2
     C                   Add       1             Idx
     C                   Movel     'SSCC2'       FldNamXAr(Idx)
     C                   Movel     'FTM3237'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
     C                   Else
 
      ** Validate currency if entered
 
     C                   If        SSCC2 <> *Blank
     C                   Move      SSCC2         WCURCY
     C                   Move      '2'           WCYIND
     C                   Move      'N'           WCYERR
     C                   ExSr      SrACCY
 
      ** Currency not valid or not defined in the system
 
     C                   If        WCYERR = 'Y'
     C                   Goto      ExSCHG
     C                   EndIf
 
      ** 2nd currency entered and the 2nd charge amount is blank while
      ** currency is not equal to pay currency, error.
 
     C                   If        WCYERR = 'N'
     C                   If        (SSCH2 = *Blank)
     C                   If        (SSCC2 <> SPCCY)
     C                   Move      'N'           OKSCH2
     C                   Add       1             Idx
     C                   Movel     'SSCH2'       FldNamXAr(Idx)
     C                   Movel     'FTM3260'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   Else
     C                   If        SADDC = 'A'
     C                   Move      '0'           SSCH2
     C                   Else
     C                   Move      WTOTAL        SSCH2
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ***2nd*charge*currency entered not equal to pay currency and the          BUG3919
      ***entry*is*the*last of the sender's charges entries, default             BUG3919
      ***3rd*sender's*charge to pay currency with amount equal to 0 if          BUG3919
      ***add/deduct*is*'A' otherwise total charges.                             BUG3919
      *******************                                                       BUG3919
     C*******************If        (SSCC2 <> SPCCY) And (WSCYCH3 = *Blank)      BUG3919
     C*******************If        SADDC = 'A'                                  BUG3919
     C*******************Move      '0'           SSCH3                          BUG3919
     C*******************Else                                                   BUG3919
      *******************                                                       BUG3919
      ***Default*3rd*sender amount field by the total charge accumu-            BUG3919
      ***lated.**********                                                       BUG3919
      *******************                                                       BUG3919
     C*******************Move      WTOTAL        SSCH3                          BUG3919
     C*******************EndIf                                                  BUG3919
     C*******************Move      SPCCY         SSCC3                          BUG3919
     C*******************EndIf                                                  BUG3919
     C                   EndIf
     C                   EndIf
 
      ** 2nd charge amount is entered w/ blank charge currency and en -
      ** try is the last of the sender's charges entries, default
      ** charge currency to pay currency.
 
     C                   If        SSCH2 <> *Blank
     C                   If        SSCC2 = *Blank
     C                   If        WSCYCH3 = *Blank
     C                   Move      SPCCY         SSCC2
     C                   Else
 
      ** 2nd charge amount is entered with blank charge currency and
      ** entry is not the last of the sender's charges entries,
      ** error.
 
     C                   Move      'N'           OKSCC2
     C                   Add       1             Idx
     C                   Movel     'SSCC2'       FldNamXAr(Idx)
     C                   Movel     'FTM3254'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   Eval      ZFIELD = *Blank
     C                   Eval      ZFIELD = SSCH2
     C                   Eval      ZADIG = 11 - A6NBDP
     C                   Eval      ZADEC = A6NBDP
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        ZalignOK = 'N'
     C                   Move      'N'           OKSCH2
     C                   Add       1             Idx
     C                   Movel     'SSCH2'       FldNamXAr(Idx)
     C                   Movel     'FTM3236'     MsgIdXAr(Idx)
     C*****SSCC2         Cat       SSCH2         MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCC2))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(SSCC2)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCH2))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SSCH2)                    MD000091
     C                   Goto      ExSCHG
     C                   Else
     C                   Move      ZFIELD        @SCH2
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Move      ZFIELD        SSCH2
 
      ** Check if this is the last entry.
 
     C                   If        WSCYCH3 = *Blank
     C                   Z-Add     @SCH2         WLAST            13 0
     C                   Eval      @SENT = 2
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Validate 3rd Sender Charge field
 
     C                   If        (SSCC3 = *Blank) And (SSCH3 = *Blank)
 
      ** Other charges entered while the first sender's charge is blank
      ** - error.
 
     C                   If        WSCYCH4 <> *Blank
     C                   Move      'N'           OKSCC3
     C                   Add       1             Idx
     C                   Movel     'SSCC3'       FldNamXAr(Idx)
     C                   Movel     'FTM3239'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
     C                   Else
 
      ** Validate currency if entered
 
     C                   If        SSCC3 <> *Blank
     C                   Move      SSCC3         WCURCY
     C                   Move      '3'           WCYIND
     C                   Move      'N'           WCYERR
     C                   ExSr      SrACCY
 
      ** Currency not valid or not defined in the system
 
     C                   If        WCYERR = 'Y'
     C                   Goto      ExSCHG
     C                   EndIf
 
      ** 3rd currency entered and the 3rd charge amount is blank while
      ** currency is not equal to pay currency, error.
 
     C                   If        WCYERR = 'N'
     C                   If        (SSCH3 = *Blank)
     C                   If        (SSCC3 <> SPCCY)
     C                   Move      'N'           OKSCH3
     C                   Add       1             Idx
     C                   Movel     'SSCH3'       FldNamXAr(Idx)
     C                   Movel     'FTM3260'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   Else
     C                   If        SADDC = 'A'
     C                   Move      '0'           SSCH3
     C                   Else
     C                   Move      WTOTAL        SSCH3
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ***3rd*charge*currency entered not equal to pay currency and the          BUG3919
      ***entry*is*the*last of the sender's charges entries, default             BUG3919
      ***4th*sender's*charge to pay currency with amount equal to 0 if          BUG3919
      ***add/deduct*is*'A' otherwise total charges.                             BUG3919
      *******************                                                       BUG3919
     C*******************If        (SSCC3 <> SPCCY) And (WSCYCH4 = *Blank)      BUG3919
     C*******************If        SADDC = 'A'                                  BUG3919
     C*******************Move      '0'           SSCH4                          BUG3919
     C*******************Else                                                   BUG3919
      *******************                                                       BUG3919
      ***Default*4th*sender amount field by the total charge accumu-            BUG3919
      ***lated.**********                                                       BUG3919
      *******************                                                       BUG3919
     C*******************Move      WTOTAL        SSCH4                          BUG3919
     C*******************EndIf                                                  BUG3919
     C*******************Move      SPCCY         SSCC4                          BUG3919
     C*******************EndIf                                                  BUG3919
     C                   EndIf
     C                   EndIf
 
      ** 3rd charge amount is entered w/ blank charge currency and en -
      ** try is the last of the sender's charges entries, default
      ** charge currency to pay currency.
 
     C                   If        SSCH3 <> *Blank
     C                   If        SSCC3 = *Blank
     C                   If        WSCYCH4 = *Blank
     C                   Move      SPCCY         SSCC3
     C                   Else
 
      ** 3rd charge amount is entered with blank charge currency and
      ** entry is not the last of the sender's charges entries,
      ** error.
 
     C                   Move      'N'           OKSCC3
     C                   Add       1             Idx
     C                   Movel     'SSCC3'       FldNamXAr(Idx)
     C                   Movel     'FTM3254'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   Eval      ZFIELD = *Blank
     C                   Eval      ZFIELD = SSCH3
     C                   Eval      ZADIG = 11 - A6NBDP
     C                   Eval      ZADEC = A6NBDP
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        ZalignOK = 'N'
     C                   Move      'N'           OKSCH3
     C                   Add       1             Idx
     C                   Movel     'SSCH3'       FldNamXAr(Idx)
     C                   Movel     'FTM3238'     MsgIdXAr(Idx)
     C*****SSCC3         Cat       SSCH3         MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCC3))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(SSCC3)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCH3))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SSCH3)                    MD000091
     C                   Goto      ExSCHG
     C                   Else
     C                   Move      ZFIELD        @SCH3
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Move      ZFIELD        SSCH3
 
      ** Check if this is the last entry.
 
     C                   If        WSCYCH4 = *Blank
     C                   Z-Add     @SCH3         WLAST
     C                   Eval      @SENT = 3
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Validate 4th Sender Charge field
 
     C                   If        (SSCC4 = *Blank) And (SSCH4 = *Blank)
 
      ** 5th charge entered while the first sender's charge is blank
      ** - error.
 
     C                   If        (SSCC5 <> *Blank) Or (SSCH5 <> *Blank)
     C                   Move      'N'           OKSCC4
     C                   Add       1             Idx
     C                   Movel     'SSCC4'       FldNamXAr(Idx)
     C                   Movel     'FTM3241'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
     C                   Else
 
      ** Validate currency if entered
 
     C                   If        SSCC4 <> *Blank
     C                   Move      SSCC4         WCURCY
     C                   Move      '4'           WCYIND
     C                   Move      'N'           WCYERR
     C                   ExSr      SrACCY
 
      ** Currency not valid or not defined in the system
 
     C                   If        WCYERR = 'Y'
     C                   Goto      ExSCHG
     C                   EndIf
 
      ** 4th currency entered and the 4th charge amount is blank while
      ** currency is not equal to pay currency, error.
 
     C                   If        WCYERR = 'N'
     C                   If        (SSCH4 = *Blank)
     C                   If        (SSCC4 <> SPCCY)
     C                   Move      'N'           OKSCH4
     C                   Add       1             Idx
     C                   Movel     'SSCH4'       FldNamXAr(Idx)
     C                   Movel     'FTM3260'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   Else
     C                   If        SADDC = 'A'
     C                   Move      '0'           SSCH4
     C                   Else
     C                   Move      WTOTAL        SSCH4
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ***4th*charge*currency entered not equal to pay currency and the          BUG3919
      ***entry*is*the*last of the sender's charges entries, default             BUG3919
      ***5th*sender's*charge to pay currency with amount equal to 0 if          BUG3919
      ***add/deduct*is*'A' otherwise total charges.                             BUG3919
      *******************                                                       BUG3919
     C*******************If        (SSCC4 <> SPCCY) And (SSCC5 = *Blank) And    BUG3919
     C*******************          (SSCH5 = *Blank)                             BUG3919
     C*******************If        SADDC = 'A'                                  BUG3919
     C*******************Move      '0'           SSCH5                          BUG3919
     C*******************Else                                                   BUG3919
      *******************                                                       BUG3919
      ***Default*5th*sender amount field by the total charge accumu-            BUG3919
      ***lated.**********                                                       BUG3919
      *******************                                                       BUG3919
     C*******************Move      WTOTAL        SSCH5                          BUG3919
     C*******************EndIf                                                  BUG3919
     C*******************Move      SPCCY         SSCC5                          BUG3919
     C*******************EndIf                                                  BUG3919
     C                   EndIf
     C                   EndIf
 
      ** 5th charge amount is entered w/ blank charge currency and en -
      ** try is the last of the sender's charges entries, default
      ** charge currency to pay currency.
 
     C                   If        SSCH4 <> *Blank
     C                   If        SSCC4 = *Blank
     C                   If        (SSCC5 = *Blank) And (SSCH5 = *Blank)
     C                   Move      SPCCY         SSCC4
     C                   Else
 
      ** 4th charge amount is entered with blank charge currency and
      ** entry is not the last of the sender's charges entries,
      ** error.
 
     C                   Move      'N'           OKSCC4
     C                   Add       1             Idx
     C                   Movel     'SSCC4'       FldNamXAr(Idx)
     C                   Movel     'FTM3254'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   Eval      ZFIELD = *Blank
     C                   Eval      ZFIELD = SSCH4
     C                   Eval      ZADIG = 11 - A6NBDP
     C                   Eval      ZADEC = A6NBDP
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        ZalignOK = 'N'
     C                   Move      'N'           OKSCH4
     C                   Add       1             Idx
     C                   Movel     'SSCH4'       FldNamXAr(Idx)
     C                   Movel     'FTM3240'     MsgIdXAr(Idx)
     C*****SSCC4         Cat       SSCH4         MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCC4))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(SSCC4)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCH4))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SSCH4)                    MD000091
     C                   Goto      ExSCHG
     C                   Else
     C                   Move      ZFIELD        @SCH4
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Move      ZFIELD        SSCH4
 
      ** Check if this is the last entry.
 
     C                   If        (SSCC5 = *Blank) And (SSCH5 = *Blank)
     C                   Z-Add     @SCH4         WLAST
     C                   Eval      @SENT = 4
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Validate 5th Sender Charge field
 
     C                   If        (SSCC5 <> *Blank) Or (SSCH5 <> *Blank)
 
      ** Validate currency if entered
 
     C                   If        SSCC5 <> *Blank
     C                   Move      SSCC5         WCURCY
     C                   Move      '5'           WCYIND
     C                   Move      'N'           WCYERR
     C                   ExSr      SrACCY
 
      ** Currency not valid or not defined in the system
 
     C                   If        WCYERR = 'Y'
     C                   Goto      ExSCHG
     C                   EndIf
 
      ** 5th charge currency entered not equal to pay currency,
      ** error.
 
     C                   If        WCYERR = 'N'
     C                   If        (SSCC5 <> SPCCY)
     C                   Move      'N'           OKSCC5
     C                   Add       1             Idx
     C                   Movel     'SSCC5'       FldNamXAr(Idx)
     C                   Movel     'FTM3256'     MsgIdXAr(Idx)
     C                   Goto      ExSCHG
     C                   EndIf
 
      ** 5th currency entered and the 5th charge amount is blank, de -
      ** fault charge amount to 0 if the add/deduct is 'A' otherwise
      ** total charges.
 
     C                   If        (SSCH5 = *Blank)
     C                   If        SADDC = 'A'
     C                   Move      '0'           SSCH5
     C                   Else
     C                   Move      WTOTAL        SSCH5
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** 5th charge amount is entered w/ blank charge currency,
      ** default charge currency to pay currency.
 
     C                   If        (SSCH5 <> *Blank) And (SSCC5 = *Blank)
     C                   Move      SPCCY         SSCC4
     C                   EndIf
 
     C                   Eval      ZFIELD = *Blank
     C                   Eval      ZFIELD = SSCH5
     C                   Eval      ZADIG = 11 - A6NBDP
     C                   Eval      ZADEC = A6NBDP
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        ZalignOK = 'N'
     C                   Move      'N'           OKSCH5
     C                   Add       1             Idx
     C                   Movel     'SSCH5'       FldNamXAr(Idx)
     C                   Movel     'FTM3242'     MsgIdXAr(Idx)
     C*****SSCC5         Cat       SSCH5         MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCC5))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(SSCC5)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(SSCH5))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SSCH5)                    MD000091
     C                   Goto      ExSCHG
     C                   Else
     C                   Move      ZFIELD        @SCH5
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Move      ZFIELD        SSCH5
     C                   Z-Add     @SCH5         WLAST
     C                   Eval      @SENT = 5
     C                   EndIf
     C                   EndIf
 
      ** Check charges total
 
     C                   If        (OKSCH1 = 'Y') And (OKSCH2 = 'Y') And
     C                             (OKSCH3 = 'Y') And (OKSCH4 = 'Y') And
     C                             (OKSCH5 = 'Y') And (OKSCC1 = 'Y') And
     C                             (OKSCC2 = 'Y') And (OKSCC3 = 'Y') And
     C                             (OKSCC3 = 'Y') And (OKSCC4 = 'Y')
     C                   ExSr      SrCToTal
     C                   EndIf
     C                   EndIf
 
     C     ExSCHG        EndSr
 
      *****************************************************************
      /Title Sr/SrFldChk
      *****************************************************************
      *                                                               *
      * SR/SrFldChk   - Checks Sender's Charge field in Error         *
      *                                                               *
      * Called By: SrSndChg subroutine                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrFldChk      BegSr
 
     C                   If        SSCC1 <> *Blank
     C                   Move      'N'           OKSCC1
     C                   Add       1             Idx
     C                   Movel     'SSCC1'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCH1 <> *Blank
     C                   Move      'N'           OKSCH1
     C                   Add       1             Idx
     C                   Movel     'SSCH1'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCC2 <> *Blank
     C                   Move      'N'           OKSCC2
     C                   Add       1             Idx
     C                   Movel     'SSCC2'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCH2 <> *Blank
     C                   Move      'N'           OKSCH2
     C                   Add       1             Idx
     C                   Movel     'SSCH2'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCC3 <> *Blank
     C                   Move      'N'           OKSCC3
     C                   Add       1             Idx
     C                   Movel     'SSCC3'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCH3 <> *Blank
     C                   Move      'N'           OKSCH3
     C                   Add       1             Idx
     C                   Movel     'SSCH3'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCC4 <> *Blank
     C                   Move      'N'           OKSCC4
     C                   Add       1             Idx
     C                   Movel     'SSCC4'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCH4 <> *Blank
     C                   Move      'N'           OKSCH4
     C                   Add       1             Idx
     C                   Movel     'SSCH4'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCC5 <> *Blank
     C                   Move      'N'           OKSCC5
     C                   Add       1             Idx
     C                   Movel     'SSCC5'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
     C                   If        SSCH5 <> *Blank
     C                   Move      'N'           OKSCH5
     C                   Add       1             Idx
     C                   Movel     'SSCH5'       FldNamXAr(Idx)
     C                   Movel     WErrMsgId     MsgIdXAr(Idx)
     C                   Goto      ExFldChk
     C                   EndIf
 
     C     ExFldChk      EndSr
 
      *****************************************************************
      /Title Sr/SrACCY
      *****************************************************************
      *                                                               *
      * SR/SrACCY     - Access Currency details                       *
      *                                                               *
      * Called By: SrSndChg subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * AOCURRR0   - Access Object to get currency details            *
      *                                                               *
      *****************************************************************
 
     C     SrACCY        BegSr
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blanks       WRTCD             7
     C                   Parm      '*KEY   '     WOPTN             7
     C                   Parm      WCURCY        WAJCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
      ** Invalid currency entered
 
     C                   If        WRTCD <> *Blank
     C                   Add       1             Idx
     C                   Movel     'FTM3255'     MsgIdXAr(Idx)
     C                   Select
     C                   When      WCYIND = '1'
     C                   Move      'N'           OKSCC1
     C                   Movel     'SSCC1'       FldNamXAr(Idx)
     C                   When      WCYIND = '2'
     C                   Move      'N'           OKSCC2
     C                   Movel     'SSCC2'       FldNamXAr(Idx)
     C                   When      WCYIND = '3'
     C                   Move      'N'           OKSCC3
     C                   Movel     'SSCC3'       FldNamXAr(Idx)
     C                   When      WCYIND = '4'
     C                   Move      'N'           OKSCC4
     C                   Movel     'SSCC4'       FldNamXAr(Idx)
     C                   When      WCYIND = '5'
     C                   Move      'N'           OKSCC5
     C                   Movel     'SSCC5'       FldNamXAr(Idx)
     C                   EndSl
     C                   Movel     'Y'           WCYERR
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrCTotal
      *****************************************************************
      *                                                               *
      * SR/SrCTotal   - Check Total Charges                           *
      *                                                               *
      * Called By: SrSndChg subroutine                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrCTotal      BegSr
 
      ** Send warning message if the last sender's charge field entry
      ** does not equal the actual sum of the charges levied.
 
     C                   If        WLAST <> WTOTCH
     C                   Eval      WIx = WIx + 1
     C                   Select
     C                   When      @SENT = 1
     C                   Eval      OKSCH1 = 'W'
     C                   Eval      WFldNmXAr(WIx) = 'SSCH1'
     C                   When      @SENT = 2
     C                   Eval      OKSCH2 = 'W'
     C                   Eval      WFldNmXAr(WIx) = 'SSCH2'
     C                   When      @SENT = 3
     C                   Eval      OKSCH3 = 'W'
     C                   Eval      WFldNmXAr(WIx) = 'SSCH3'
     C                   When      @SENT = 4
     C                   Eval      OKSCH4 = 'W'
     C                   Eval      WFldNmXAr(WIx) = 'SSCH4'
     C                   When      @SENT = 5
     C                   Eval      OKSCH5 = 'W'
     C                   Eval      WFldNmXAr(WIx) = 'SSCH5'
     C                   EndSl
 
     C                   Eval      WMsgIdXAr(WIx) = 'FTM3243'
      * If add/deduct indicator = Deduct - senders charges are in payment ccy   BUG3919
      * If add/deduct indicator = Add - senders charges are in settlement ccy   BUG3919
     C                   IF        SADDC <> 'A'                                 BUG3919
     C**********         Eval      WMsgDtaXAr(WIx) = SPCCY + WTOTAL                         MD000091
     C                   EVAL      BLen = %Len(%Trim(SPCCY))                                MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(SPCCY)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(WTOTAL))                               MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = %TRIM(WMsgDtaXAr(WIx))                 MD000091
     C                                            + LenStr +%TRIM(WTOTAL)                   MD000091
     C                   ELSE                                                   BUG3919
     C**********         Eval      WMsgDtaXAr(WIx) = SSMCY + WTOTAL                 BUG3919 MD000091
     C                   EVAL      BLen = %Len(%Trim(SSMCY))                                MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(SSMCY)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(WTOTAL))                               MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = %TRIM(WMsgDtaXAr(WIx))                 MD000091
     C                                            + LenStr +%TRIM(WTOTAL)                   MD000091
     C                   ENDIF                                                  BUG3919
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrCalc
      *****************************************************************
      *                                                               *
      * SR/SrCalc     - Calculate Total Charges                       *
      *                                                               *
      * Called By: SrSndChg subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * FT0010     - Validate and Calculate currencies.               *
      * ZEDIT       - Converts numeric value to screen value.         *
      *                                                               *
      *****************************************************************
 
     C     SrCalc        BegSr
 
      * If add/deduct indicator = Deduct - senders charges are in payment ccy   BUG3919
     C                   IF        SADDC <> 'A'                                 BUG3919
     C                   Select
 
      ** Pay currency is equal to other currency, set the total charges
      ** work field to the actual sum of all the charges.
 
     C                   When      SPCCY = @RCCY
     C                   Z-Add     @TOTCHG       WTOTCH           13 0
 
      ** Pay Currency is equal to the charge currency, total all the
      ** the charges.
 
     C                   When      SPCCY = @CCCY
     C                   Eval      WTOTCH = (@TRCD + @CHCD + @TXCD +
     C                             @CQCD + @CSTD + @SPCD +@MSCD +
     C                             @VATD)
 
     C                   IF        @CFT009 = 'Y'                                BUG3919
     C                   Eval      WTOTCH = WTOTCH + @SSCD + @MI1CD + @MI2CD    BUG3919
     C                             + @MI3CD + @MI4CD + @MI5CD                   BUG3919
     C                   ENDIF                                                  BUG3919
 
      ** Pay currency not equal to the two previously compared curren -
      ** cies, convert the total charge amount to pay currency.
 
     C                   When      (SPCCY <> @RCCY) And (SPCCY <> @CCCY)
     C                   Clear                   P#0010
     C                   Eval      P#FRCY = @RCCY
     C                   Eval      P#TOCY = SPCCY
     C                   Eval      P#FRAM = @TOTCHG
     C                   Call      'FT0010'
     C                   Parm                    P#0010
 
     C                   If        P#RTCD <> *Blank
     C                   Eval      DBFILE = 'FT0010'
     C                   Eval      DBKEY = P#TOCY
     C                   Eval      DBASE = 1
     C                   Eval      DBPGM = 'FTVSCHG'
     C                   ExSr      *PSSR
     C                   EndIf
 
     C                   Eval      WTOTCH = P#TOAM
     C                   EndSl
 
      ** Format total amount to be displayed in message data
                                                                                BUG3919
     C                   CallB     'AOCURRR0'                                   BUG3919
     C                   Parm      *Blanks       WRTCD                          BUG3919
     C                   Parm      '*KEY   '     WOPTN                          BUG3919
     C                   Parm      SPCCY         WAJCD                          BUG3919
     C     SDCURR        Parm      SDCURR        DSSDY                          BUG3919
 
     C                   Eval      ZFIELD = *Blank
     C                   Move      WTOTCH        ZFIELD
     C*******************Eval      ZADEC = @RCDP                                BUG3919
     C                   Eval      ZADEC = A6NBDP                               BUG3919
 
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Move      ZFIELD        WTOTAL           12
                                                                                BUG3919
      * If add/deduct indicator = Add - senders charges are in settlement ccy   BUG3919
     C                   ELSE                                                   BUG3919
     C                   Select                                                 BUG3919
                                                                                BUG3919
      ** Settle currency is equal to other currency, set the total charges      BUG3919
      ** work field to the actual sum of all the charges.                       BUG3919
                                                                                BUG3919
     C                   When      SSMCY = @RCCY                                BUG3919
     C                   Z-Add     @TOTCHG       WTOTCH           13 0          BUG3919
                                                                                BUG3919
      ** Settle Currency is equal to the charge currency, total all the         BUG3919
      ** the charges.                                                           BUG3919
                                                                                BUG3919
     C                   When      SSMCY = @CCCY                                BUG3919
     C                   Eval      WTOTCH = (@TRCD + @CHCD + @TXCD +            BUG3919
     C                             @CQCD + @CSTD + @SPCD +@MSCD +               BUG3919
     C                             @VATD)                                       BUG3919
                                                                                BUG3919
     C                   IF        @CFT009 = 'Y'                                BUG3919
     C                   Eval      WTOTCH = WTOTCH + @SSCD + @MI1CD + @MI2CD    BUG3919
     C                             + @MI3CD + @MI4CD + @MI5CD                   BUG3919
     C                   ENDIF                                                  BUG3919
                                                                                BUG3919
      ** Settle currency not equal to the two previously compared curren -      BUG3919
      ** cies, convert the total charge amount to settle currency.              BUG3919
                                                                                BUG3919
     C                   When      (SSMCY <> @RCCY) And (SSMCY <> @CCCY)        BUG3919
     C                   Clear                   P#0010                         BUG3919
     C                   Eval      P#FRCY = @RCCY                               BUG3919
     C                   Eval      P#TOCY = SSMCY                               BUG3919
     C                   Eval      P#FRAM = @TOTCHG                             BUG3919
     C                   Call      'FT0010'                                     BUG3919
     C                   Parm                    P#0010                         BUG3919
                                                                                BUG3919
     C                   If        P#RTCD <> *Blank                             BUG3919
     C                   Eval      DBFILE = 'FT0010'                            BUG3919
     C                   Eval      DBKEY = P#TOCY                               BUG3919
     C                   Eval      DBASE = 2                                    BUG3919
     C                   Eval      DBPGM = 'FTVSCHG'                            BUG3919
     C                   ExSr      *PSSR                                        BUG3919
     C                   EndIf                                                  BUG3919
                                                                                BUG3919
     C                   Eval      WTOTCH = P#TOAM                              BUG3919
     C                   EndSl                                                  BUG3919
                                                                                BUG3919
      ** Format total amount to be displayed in message data                    BUG3919
                                                                                BUG3919
     C                   CallB     'AOCURRR0'                                   BUG3919
     C                   Parm      *Blanks       WRTCD                          BUG3919
     C                   Parm      '*KEY   '     WOPTN                          BUG3919
     C                   Parm      SSMCY         WAJCD                          BUG3919
     C     SDCURR        Parm      SDCURR        DSSDY                          BUG3919
                                                                                BUG3919
     C                   Eval      ZFIELD = *Blank                              BUG3919
     C                   Move      WTOTCH        ZFIELD                         BUG3919
     C                   Eval      ZADEC = A6NBDP                               BUG3919
                                                                                BUG3919
     C                   CallB     'ZEDIT'                                      BUG3919
     C                   Parm                    ZFIELD                         BUG3919
     C                   Parm                    ZADEC                          BUG3919
     C                   Move      ZFIELD        WTOTAL           12            BUG3919
     C                   ENDIF                                                  BUG3919
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Program Initialisation Routine                *
      *                                                               *
      * Called By: Automatically executed when program starts.        *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
