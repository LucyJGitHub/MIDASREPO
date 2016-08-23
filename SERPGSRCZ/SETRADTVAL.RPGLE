     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade third screen details validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADTVAL - Trade third screen details validation           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11219           Date 24Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 222373             Date 23Oct03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG11219 - Error with NTR Interest value when using          *
      *             Days Adjustment field. Force recalculation        *
      *             of NTR Interest value everytime Days Adjust-      *
      *             ment is entered on the screen.                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Security Diary Events
     FSECEO     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRDTV008
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      **
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Trade Primary Details in screen format
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D   TR1_CLTY    E                     EXTFLD(DDCLTY)
 
      ** Trade Secondary Details in screen format
     D TrSeco        E DS                  EXTNAME(SETRSEPD)
 
      ** Trade Third screen details in screen format
     D TrThir        E DS                  EXTNAME(SETRTHPD)
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)
     D SEC_FRNT      E                     EXTFLD(FRNT)
     D SEC_REPA      E                     EXTFLD(REPA)
     D SEC_TMST      E                     EXTFLD(TMST)
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
      ** Trade Third screen OK indicators
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Valid Trade layout
     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
 
      ** SE Trades Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SETDEXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
     D PRTCD           S              7
     D POPTN           S              7
     D PRespMode       S              1
     D PDefault        S              1
     D PValidate       S              1
     D PRetCode        S              7
     D PFldName        S             10
     D PZCPOVR         S              1
     D PDADJN          S              7
     D PHACR           S             11  7
     D DDHACR          S             13
     D DDPRICN         S             17
     D Wdummy1         S              1
     D Wdummy2         S              1
     D Wdummy3         S             13  0
     D WrkPRICN        S             15  8
     D WrkNTCR         S             11  7
     D I               S              3  0
     D Wx              S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRDTV009
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      /COPY WNCPYSRC,SETRDTV001
      * Call Validation Modules in Sequence
 
      ** Validate Credit Risk Spread
 
     C                   IF        PValidate = 'Y'
      /COPY WNCPYSRC,SETRDTV002
     C                   EXSR      VCdtRISK
      /COPY WNCPYSRC,SETRDTV003
     C                   ENDIF
 
      ** Validate Liquidity Premium
 
     C                   IF        PValidate = 'Y'
      /COPY WNCPYSRC,SETRDTV004
     C                   EXSR      VLiqPREM
      /COPY WNCPYSRC,SETRDTV005
     C                   ENDIF
 
      ** If interest bearing security, validate Interest Amount
      ** using Net Treasury Rate
 
     C     PROT          IFEQ      '1'
     C     PROT          OREQ      '3'
     C     PROT          OREQ      '5'
     C     PROT          OREQ      '6'
     C     PROT          OREQ      '8'
     C     PROT          OREQ      '9'
 
     C     STBS          IFEQ      'Y'
     C     STBS          OREQ      'P'
      /COPY WNCPYSRC,SETRDTV004
     C                   EXSR      VHIntAmt
      /COPY WNCPYSRC,SETRDTV005
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Net Treasury Price
 
     C                   IF        DDCRSKOk <> 'N'  AND  DDLQPROk <> 'N'
      /COPY WNCPYSRC,SETRDTV006
     C                   EXSR      VNetTPrice
      /COPY WNCPYSRC,SETRDTV007
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRDTV010
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCdtRISK - Validate Credit Risk Spread                       *
      *                                                               *
      *****************************************************************
 
     C     VCdtRISK      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
     C                   EVAL      PFldName = 'DDCRSK'
 
     C                   CALLB     'SEVPCSPDRT'
 
      ** INPUTS
      ** Return code
      ** Credit Risk Spread
 
     C                   PARM                    PRetCode
     C                   PARM                    PFldName
     C                   PARM                    DDCRSK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Validated Credit Risk Spread
      ** Credit Risk Spread OK flag
 
     C                   PARM                    CRSK
     C                   PARM                    DDCRSKOk
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VLiqPREM - Validate Liquidity Premium                        *
      *                                                               *
      *****************************************************************
 
     C     VLiqPREM      BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
     C                   EVAL      PFldName = 'DDLQPR'
 
     C                   CALLB     'SEVPCSPDRT'
 
      ** INPUTS
      ** Return code
      ** Liquidity Premium
 
     C                   PARM                    PRetCode
     C                   PARM                    PFldName
     C                   PARM                    DDLQPR
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Validated Liquidity Premium
      ** Liquidity Premium OK flag
 
     C                   PARM                    LQPR
     C                   PARM                    DDLQPROk
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNetTPrice - Validate Net Treasury Price                     *
      *                                                               *
      *****************************************************************
 
     C     VNetTPrice    BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   EVAL      Idx = 0
     C                   EVAL      DDPRICN = *BLANKS
 
      ** Net Treasury Price = Price/Discount/Yield + Credit Risk Spread +
      **                      Liquidity Premium
 
     C                   EVAL      WrkPRICN = TPDY + CRSK + LQPR
     C                   EVAL      PRICN = WrkPRICN
 
      ** Format screen field
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WrkPRICN      ZFLD15
     C                   EVAL      ZDECS = 8
     C                   EVAL      ZECODE = *BLANK
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZOUT21
     C
     C                   MOVE      ZOUT21        DDPRICN
 
      ** For yield or discount, Net Treasury Price must not be less than 0.
      ** For price, Net Treasury Price must not be less than or equal to 0.
 
     C                   IF        ((STBS = 'D' OR  STBS = 'Y') AND
     C                             WrkPRICN < 0) OR
     C                             (STBS = 'P' AND WrkPRICN <= 0)
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRSK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1311'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDCRSKOk
     C                   MOVE      'N'           DDLQPROk
 
     C                   ELSE
 
      ** If discount or yield, convert Net Treasury Price to Price Percentage
 
     C                   IF        STBS = 'D' OR  STBS = 'Y'
 
     C                   CALLB     'SEVTPRICE'
 
      ** INPUTS
      ** Return Code
      ** Default & Validate (Y or N)
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PDefault
     C                   PARM                    PValidate
 
      ** Net Treasury Price - screen format (17A)
      ** Accrued indicator (1A)
      ** Action Code                                                                          222373
      ** Price/Discount/Yield                                                                 222373
      ** Countervalue                                                                         222373
 
     C                   PARM      *BLANKS       DDPRICN
     C                   PARM                    DDACIN
     C                   PARM                    DDACTN            1                          222373
     C                   PARM                    DDTPDY           16                          222373
     C                   PARM                    DDTCTR           21                          222373
 
      ** Nominal (15P 0)
      ** Net Treasury Price (15P 8)
      ** Value date (5P 0)
      ** Interest Amount (13P 0)
 
     C                   PARM                    NOML
     C                   PARM                    WrkPRICN
     C                   PARM                    TDVD
     C                   PARM                    ITRN
 
      ** Security Details  (& nominal ccy dec places)
 
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
 
      ** Processing Type
 
     C                   PARM                    PROT
 
      ** Date Format (1A)
 
     C                   PARM                    BJDFIN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Price Ok INdicator (1A)
      ** Net Treasury Price - file format (15P 8)
 
     C                   PARM      *BLANKS       DDCRSKOK
     C                   PARM                    PRICN
     C                   ENDIF
     C                   ENDIF
 
      ** Update error info
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VHIntAmt - Validate Interest Amount using Net Treasury Rate  *
      *                                                               *
      *****************************************************************
 
     C     VHIntAmt      BEGSR
 
      ** Get Net Treasury Coupon Rate
 
     C                   EVAL      SE_SDSN = DDSESN
     C                   EVAL      SE_SDET = 'IR'
     C                   EVAL      SE_SDED = TDVD
 
     C     KSECEO        SETLL     SEDEVDF
     C                   READ      SEDEVDF                                01
 
     C                   IF        *IN01 = *OFF  AND  SE_SDSN = DDSESN  AND
     C                             SE_SDET = 'IR'
     C                   EVAL      WrkNTCR = SE_SDNN
     C                   ELSE
     C                   EVAL      WrkNTCR = CPNN
     C                   ENDIF
 
      ** Format screen field
 
     C                   IF        WrkNTCR <> 0
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WrkNTCR       ZFLD15
     C                   EVAL      ZDECS = 7
     C                   EVAL      ZECODE = *BLANK
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZOUT21
     C
     C                   MOVE      ZOUT21        DDHACR
     C                   EVAL      PHACR = WrkNTCR
     C                   ENDIF
                                                                                            BUG11219
      ** If Days adjustment is entered on the screen, always recalculate NTR                BUG11219
      ** interest amount by blanking out and zeroising DDITRN and ITRN. It will             BUG11219
      ** be defaulted to actual amount within module/SEVTINTAMT if blank (and               BUG11219
      ** PDefault flag = 'Y').                                                              BUG11219
     C                   If        DDDADJ <> *BLANKS and PDefault = 'Y'                     BUG11219
     C                   Eval      DDITRN = *BLANKS                                         BUG11219
     C                   Eval      ITRN = 0                                                 BUG11219
     C                   Endif                                                              BUG11219
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'SEVTINTAMT'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Default & Validate (Y or N)
 
     C                   PARM                    PDefault
     C                   PARM                    PValidate
 
      ** Accrued indicator  (1A)
      ** Days Adjustment  (5A)
      ** Actual/Difference Indicator (1A)
      ** Interest Amount (15A)
 
     C                   PARM                    DDACIN
     C                   PARM                    DDDADJ
     C                   PARM                    DDACTD
     C                   PARM                    DDITRN
 
      ** Nominal  (11P 0)
      ** Value Date (5P 0)
      ** Days Adjustment <actual> (3P 0)
      ** Coupon rate (for trade) (11P 7)
      ** Overide Indicator  (1A)
 
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DADJ
     C                   PARM                    PHACR
     C                   PARM      'Y'           PZCPOVR
 
      ** Securities details
 
     C                   PARM                    SECTY
 
      ** Interest days adjustment
      ** Nominal currency decimal places   (1P 0)
      ** Processing type   (1A)
 
     C                   PARM                    PDADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
 
      ** Date format  (1A)
 
     C                   PARM                    BJDFIN
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Dummy fields
      ** Interest Amount OK Indicator (1A)
 
     C                   PARM                    Wdummy1
     C                   PARM                    Wdummy2
     C                   PARM                    ddITRNok
 
      ** Interest Amount
      ** Interest Adjustment
      ** Dummy field
 
     C                   PARM                    ITRN
     C                   PARM                    TINN
     C                   PARM                    Wdummy3
 
     C                   IF        DDITRNOk <> 'Y'
     C                   EVAL      Wx = 1
     C                   DOU       MsgIDXAr(Wx) = *BLANKS
     C                   IF        MsgIDXAr(Wx) = 'MMA0519'
     C                   EVAL      MsgIDXAr(Wx) = 'MMA1312'
     C                   EVAL      FldNamXAr(Wx) = 'DDITRN'
     C                   ENDIF
     C                   IF        MsgIDXAr(Wx) = 'MMA0520'
     C                   EVAL      MsgIDXAr(Wx) = 'MMA1313'
     C                   EVAL      FldNamXAr(Wx) = 'DDITRN'
     C                   ENDIF
     C                   EVAL      Wx = Wx + 1
     C                   ENDDO
     C                   ENDIF
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
     C                   EVAL      PRetCode = *BLANKS
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
 
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Response mode
 
     C                   PARM                    PRespMode
 
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Third screen details
      ** External Date
 
     C                   PARM                    TrPrim
     C                   PARM                    TrSeco
     C                   PARM                    TrThir
     C                   PARM                    ExtData
 
      ** Default & Validate (Y or N)
 
     C                   PARM                    PDefault
     C                   PARM                    PValidate
 
      ** Security Details
      ** Investment Type Details
 
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Coupon Rate using NTR - screen format
      ** Net Treasury Price
 
     C                   PARM                    DDHACR
     C                   PARM                    DDPRICN
 
      ** Customer (Counterparty) Details
 
     C                   PARM                    CustDts
 
      ** Portfolio Details
 
     C                   PARM                    PortDts
 
      ** Nominal Currency Details
      ** Settlement Currency Details
 
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** OUTPUTS
      ** Third screen details OK inds
 
     C                   PARM                    OKTrThir
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Trade layout (DS) from/to caller
 
     C                   PARM                    ValidTrad
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key list for LF/SECEO
 
     C     KSECEO        KLIST
     C                   KFLD                    SE_SDSN
     C                   KFLD                    SE_SDET
     C                   KFLD                    SE_SDED
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRDTV011
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
