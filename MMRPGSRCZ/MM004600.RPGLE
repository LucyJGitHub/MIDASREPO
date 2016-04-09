     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Effective Interest Rate Period Split')        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM004600 - Midas MM Effective Interest Rate Period Update    *
      *                                                               *
      *  Function:  This program defines the start and end date of    *
      *             the Effective Interest Rate (EIR) period and      *
      *             writes and updates the EIR details file           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13576           Date 23Apr07               *
      *                 BUG13307           Date 13Feb07               *
      *                 BUG12989A          Date 22Jan07               *
      *                 BUG13053           Date 23Jan07               *
      *                 BUG12989           Date 18Jan07               *
      *                 BUG13048           Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12910           Date 18Dec06               *
      *                 BUG12682           Date 16Nov06               *
      *                 CSD027             Date 09Dec05               *
      *                 233601             Date 24May05               *
      *                 232928             Date 08Apr05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG13576 - Incorrect MM004620P1 report for a future-valued   *
      *             deal                                              *
      *  BUG13307 - Future-valued deal excluded in the report         *
      *  BUG12989A - Additional validation added.                     *
      *  BUG13053 - accruing fees Total recurred amount not displyed  *
      *  BUG12989 - Incorrect EIR rate and amortised F/D/P due to     *
      *             early maturity.                                   *
      *  BUG13048 - Back valued deal was not handled by 12910         *
      *  BUG12910 - Create EIR detail file for new deals only if      *
      *             value date has started                            *
      *  BUG12682 - MMC004600 00001 failed (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233601 - Generate Non Linear account keys.                   *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas DL DEALSDC/DEALSDD by Deal type/Sub Type
     F***DEALSL4   UF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FDEALSL7   UF   E           K DISK    INFSR(*PSSR)                                       CAS011
 
      ** Midas FD Deal type/subtype file FSACAI = 'Y'
     FFDDTSTL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas DL Fees by Related Purchase Deal No.
     F***DEALSL6   IF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FDEALSL9   IF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     PREFIX(NA)
 
      ** Midas DL Effective Interest Rate Details
     FMMEIRAL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas DL Effective Interest Rate Details
     FMMEIRAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMEIRAD0:MMEIRAD1)
 
      ** Midas DL Effective Interest Rate Details
     FMMEIRAL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMEIRAD0:MMEIRAD2)
 
      ** Midas LE Effective Interest Rate Details
     FMMEIRAL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMEIRAD0:MMEIRAD3)
 
      ** Midas DL Effective Interest Rate Period
     FMMEIRDL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas DL Effective Interest Rate Period
     FMMEIRDL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMEIRDD0:MMEIRDD1)
     F                                     RENAME(MMEIRHD0:MMEIRHD1)
 
      ** Midas DL Effective Interest Rate Period
     FMMEIRDL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMEIRDD0:MMEIRDD2)
     F                                     RENAME(MMEIRHD0:MMEIRHD2)
 
      ** Midas DL Effective Interest Rate Period
     FMMEIRDL4  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMEIRDD0:MMEIRDD4)
     F                                     RENAME(MMEIRHD0:MMEIRHD4)
 
      ** Midas DL Effective Interest Rate History File
     FMMEIRHPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HI:2)
 
      ** Midas DL Fees
     FDLFEEDLA  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDDA)
     F                                     PREFIX(LA:2)
 
      ** Midas DL Fees
     FDLFEEDLB  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDDB)
     F                                     PREFIX(LB:2)
 
      ** Midas DL Fees
     FDLFEEDLC  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDDC)
     F                                     PREFIX(LC:2)
 
      ** Midas DL Fees
     FDLFEEDLD  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDDD)
     F                                     PREFIX(LD:2)
 
      ** Midas DL Fees
     FDLFEEDLE  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDDE)
     F                                     PREFIX(LE:2)
 
      ** Midas MM Cashflows File
     FMMCFLAL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CF:2)
 
      ** Midas MM Effective Interest Rate Details
     FMMCFSFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMCFLFD0)
 
      ** Midas DL Fees History File                                                         BUG12989
     FDLFHSTL0  IF   E           K DISK    INFSR(*PSSR)                                     BUG12989
                                                                                            BUG12989
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Midas SD Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Midas General Ledger ICD file
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for Currency Details File
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
      ** External data structure for Currency Details File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Customer Details File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for EIR File (Current)
     D EIRCurrFmt    E DS                  EXTNAME(MMEIRDPD)
 
      ** External data structure for EIR File (New)
     D EIRNewFmt     E DS                  EXTNAME(MMEIRDPD)
     D                                     PREFIX(NW:2)
 
      ** External data structure for EIR File (History)
     D EIRHistFmt    E DS                  EXTNAME(MMEIRHPD)
     D                                     PREFIX(HI:2)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D KDlno           S              6S 0
     D KFSeq           S              2S 0
     D KDate           S              5P 0
 
     D PRetCode        S              7A
     D POption         S              7A
     D PCurrency       S              3A
     D PBaseRate       S              2A
 
     D PAmount         S             15P 0
     D POutAmount      S             15P 0
     D PSumFee         S             15P 0                                                    233601
     D PFrXRate        S             13P 8
     D PToXRate        S             13P 8
     D POutXRat        S             13P 8
     D PFrCurrency     S              3A
     D PToCurrency     S              3A
     D PFrMDIn         S              1A
     D PToMDIn         S              1A
     D POutMDIn        S              1A
     D PFrDecPlace     S              1P 0
     D PToDecPlace     S              1P 0
 
     D WEvCD           S              5P 0
     D WNextDate       S              5P 0
     D WPrevDate       S              5P 0
     D WAmortAmnt      S             15P 0
     D WAccAmount      S             15P 0
     D WRepAmount      S             15P 0
     D WRepamountfdpa  S             15P 0                                                  BUG13053
     D WTempAmount     S             15P 0
     D WCurrPrincipal  S             15P 0
     D WFeeExist       S              1P 0                                                 BUG12989A
 
     D WLoopDoneF      S              1A
     D WUpdateOnlyF    S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Read Deal Type/Sub Type combinations to index deals file
     C     *LOVAL        SETLL     FDDTSTL2
     C                   READ      FDDTSTL2
 
     C                   DOW       NOT %EOF(FDDTSTL2)
     C*****KDealType     SETLL     DEALSL4                                                    CAS011
     C*****KDealType     READE     DEALSL4                                                    CAS011
     C     KDealType     SETLL     DEALSL7                                                    CAS011
     C     KDealType     READE     DEALSL7                                                    CAS011
 
     C**********         DOW       NOT %EOF(DEALSL4)                                          CAS011
     C                   DOW       NOT %EOF(DEALSL7)                                          CAS011
 
      ** Call EIR Processing routine
     C                   EXSR      SrProcEIR
     C                   CLEAR                   DEALSDCF
     C                   CLEAR                   DEALSDDF
     C*****KDealType     READE     DEALSL4                                                    CAS011
     C     KDealType     READE     DEALSL7                                                    CAS011
 
     C                   ENDDO
     C                   READ      FDDTSTL2
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcEIR - Process EIR Periods                               *
      *                                                               *
      *****************************************************************
 
     C     SrProcEIR     BEGSR
 
     C                   CLEAR                   EIRNewFmt
 
      ** Check EIR file to obtain current (first) EIR period
 
     C     DLNO          CHAIN     MMEIRDL0
 
     C                   SELECT
 
     C                   WHEN      %FOUND(MMEIRDL0) AND
     C                             EIENDT <= WEvCD AND EIENDT >= BJRDNB
 
      ** Period might possibly have ended already. Check.
     C                   EXSR      SrEndEIR
 
 
     C                   WHEN      EIADJP = 'Y'
      *                                                                                     BUG13576
      ** Execute below subr for future-valued deals                                         BUG13576
      *                                                                                     BUG13576
     C                             Or %Found(MMEIRDL0)                                      BUG13576
     C                             And VDAT = WEvCD                                         BUG13576
     C                             And VDAT > DDAT                                          BUG13576
 
     C                   EXSR      SrAdjToEIR
 
 
      ** If no existing period is defined check if one can be setup
      ***Create*new*record*if*deal*value*date*has*started***********               BUG12910 BUG13307
                                                                                            BUG12910
     C                   WHEN      NOT %FOUND(MMEIRDL0)
     C**********                   AND VDAT <= WEvCD AND VDAT >= BJRDNB            BUG12910 BUG13048
     C**********                   AND VDAT <= WEvCD                               BUG13048 BUG13307
 
     C                   EXSR      SrNewEIR
 
     C                   ENDSL
 
     C                   IF        NWSTDT <> 0 AND NWENDT <> 0
     C**********         EXSR      SrAmortise                                                 233601
     C                   EXSR      SrAmortise2                                                233601
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNewEIR   - Defines a New EIR Period when no period is       *
      *              defined yet for the deal                         *
      *                                                               *
      *****************************************************************
 
     C     SrNewEIR      BEGSR
 
     C*                  CLEAR                   EIRNewFmt
 
      ** Default EIR Period Start and End date to Value and Maturity
      ** Date respectively
     C                   EVAL      NWSTDT = VDAT
     C                   EVAL      NWENDT = MDAT
     C                   EVAL      NWLADT = *ZEROS                                            232928
     C                   EVAL      NWAMAJ = *ZEROS                                            232928
 
     C                   IF        NWSTDT <> 0 AND NWENDT <> 0
 
      ** If a valid EIR period has been defined, Amortise
     C                   EVAL      NWRECI = 'D'
     C                   EVAL      NWTRAN = DLNO
     C                   EVAL      NWRCAL = 'Y'
     C                   EVAL      EIRCurrFmt = EIRNewFmt
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEndEIR - Verifies the end of an EIR record and updates if   *
      *            necessary                                          *
      *                                                               *
      *****************************************************************
 
     C     SrEndEIR      BEGSR
 
     C*                  CLEAR                   EIRNewFmt
 
     C                   EVAL      NWSTDT = EIENDT
     C                   EVAL      NWENDT = MDAT
 
     C                   IF        NWSTDT <> 0 AND NWENDT <> 0
 
     C                   EVAL      NWTRAN = EITRAN
 
     C                   IF        BKALDI = 'Y'
     C                   EVAL      NWRECI = 'T'
     C                   ELSE
     C                   EVAL      NWRECI = 'D'
     C                   EVAL      EIRHistFmt = EIRCurrFmt
     C                   EVAL      NWRCAL = 'Y'
     C                   EVAL      HIRECI = 'M'
 
      ** Write Period to History File
     C                   WRITE     MMEIRHD0
     C                   DELETE    MMEIRDD0
     C                   ENDIF
 
     C                   MOVE      EIRNewFmt     EIRCurrFmt
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmortise - Compute amount to amortise for the period        *
      *                                                               *
      *****************************************************************
 
     C     SrAmortise    BEGSR
 
     C                   EVAL      WTempAmount = 0
     C                   EVAL      WAmortAmnt = 0
 
      ** Discount Processing
     C                   IF        DISA <> 0
     C                   EVAL      WAmortAmnt = DISA
     C                   ENDIF
 
     C                   IF        WAmortAmnt > 0
 
      ** Get Currency details from the currencies file
     C                   EVAL      PAmount = WAmortAmnt
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrCurr
 
     C                   EVAL      EARECI = 'D'
     C                   EVAL      EATYPE = 'D'
     C                   EVAL      EATRAN = DLNO
     C                   EVAL      EAFCOD = *ZEROS
     C                   EVAL      EAFSEQ = *ZEROS
     C                   EVAL      EACCY = CCY
     C                   EVAL      EAXRAT = A6SPRT
     C                   EVAL      EAMDIN = A6MDIN
     C                   EVAL      EASTDT = EISTDT
     C                   EVAL      EAENDT = EIENDT
     C                   EVAL      EASDAM = EISTDT
     C                   EVAL      EAEDAM = EIENDT
     C*                  EVAL      EAAMNT = WAmortAmnt
     C                   MOVE      WAmortAmnt    EAAMNT
     C                   MOVE      DISA          EAOAMT
 
     C                   WRITE     MMEIRAD0
 
     C                   IF        EIRECI = 'D'
     C                   EVAL      DISA = DISA + WAmortAmnt
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WTempAmount = WAmortAmnt
     C                   EVAL      WAmortAmnt = 0
 
      ** Read through Amortising and One-off fees
     C     DLNO          SETLL     DLFEEDLB
     C     DLNO          READE     DLFEEDLB
 
     C                   EVAL      KDlNo = DLNO
 
     C                   DOW       NOT %EOF(DLFEEDLB)
 
     C                   EVAL      KFSeq = LBFSEQ
     C     KDlNoFSeq     CHAIN     MMEIRAL3
 
     C                   DOW       %FOUND(MMEIRAL3)
     C                             AND EATYPE = 'N'
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   DELETE    MMEIRAD3
     C     KDlNoFSeq     CHAIN     MMEIRAL3
     C                   ENDDO
 
     C     KDlNoFSeq     CHAIN     MMEIRAL3
     C                   IF        %FOUND(MMEIRAL3)
     C                   IF        LBPYON = EATYPE
     C                             AND LBFCCY = EACCY
     C                             AND LBFAMT = EAOAMT
     C                   EVAL      WUpdateOnlyF = 'N'
     C     DLNO          READE     DLFEEDLB
     C                   ITER
     C                   ELSE
     C                   EVAL      WUpdateOnlyF = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   ENDIF
 
     C                   EVAL      WAmortAmnt = LBFAMT
 
     C                   IF        WAmortAmnt > 0
 
     C                   EVAL      PCurrency = LBFCCY
     C                   EXSR      SrCurr
 
      ** Convert Facility Currency when it is not the Deal Currency
     C                   IF        CCY <> LBFCCY
     C                   EVAL      PFrCurrency = LBFCCY
     C                   EVAL      PToCurrency = CCY
     C                   EVAL      PAmount = WAmortAmnt
     C                   EXSR      SrConvert
     C                   ELSE
     C                   EVAL      POutXRat = A6SPRT
     C                   EVAL      POutMDIn = A6MDIN
     C                   EVAL      POutAmount = WAmortAmnt
     C                   ENDIF
 
     C                   IF        LBPYON = 'S'
     C                   EVAL      EATYPE = 'S'
     C                   EVAL      EAEDAM = LBPEND
     C                   ELSE
     C                   EVAL      EATYPE = ' '
     C                   EVAL      EAEDAM = LBPSTD
     C                   ENDIF
     C
     C                   EVAL      EARECI = 'D'
     C                   EVAL      EATRAN = LBDLNO
     C                   EVAL      EAFCOD = LBFCOD
     C                   EVAL      EAFSEQ = LBFSEQ
     C                   EVAL      EACCY = LBFCCY
     C                   EVAL      EAXRAT = POutXRat
     C                   EVAL      EAMDIN = POutMDIn
     C                   EVAL      EASTDT = EISTDT
     C                   EVAL      EAENDT = EIENDT
     C                   EVAL      EASDAM = LBPSTD
     C                   MOVE      POutAmount    EAAMNT
     C                   MOVE      WAmortAmnt    EAOAMT
 
     C                   IF        WUpdateOnlyF = 'Y'
     C                   UPDATE    MMEIRAD3
     C                   ELSE
     C                   WRITE     MMEIRAD0
     C                   ENDIF
 
      ** If EIR being updated is a current EIR, update DLFEED
     C                   IF        EIRECI = 'D'
     C                   EVAL      LBFEAM = LBFEAM + POutAmount
     C                   UPDATE    DLFEEDDB
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WTempAmount = WTempAmount + WAmortAmnt
 
     C     DLNO          READE     DLFEEDLB
     C                   ENDDO
 
     C                   IF        WTempAmount > 0
 
     C                   EVAL      EIFDPA = WTempAmount + EIFDPA
 
     C                   EVAL      KDate = EISTDT
     C     KDlNoDate     SETLL     MMCFSFL0
 
     C                   IF        %EQUAL(MMCFSFL0)
     C                   READ      MMCFSFL0
     C                   ELSE
     C                   READP     MMCFSFL0
     C                   ENDIF
 
     C                   EVAL      WCurrPrincipal = MFCPAM
 
     C                   EVAL      EIDSTD = WCurrPrincipal - EIFDPA
 
     C                   ENDIF
 
      ** Read through Repeating and Accruing Fees
 
     C                   EVAL      WTempAmount = 0
     C                   EVAL      WAccAmount = 0
 
     C     DLNO          SETLL     DLFEEDLC
     C     DLNO          READE     DLFEEDLC
 
     C                   EVAL      KDlNo = DLNO
 
     C                   DOW       NOT %EOF(DLFEEDLC)
 
     C                   EVAL      KFSeq = LCFSEQ
     C     KDlNoFSeq     CHAIN     MMEIRAL3
     C                   IF        %FOUND(MMEIRAL3)
     C                   IF        LCPYON = EATYPE
     C                             AND LCFCCY = EACCY
     C                             AND LCFAMT = EAOAMT
     C                   EVAL      WUpdateOnlyF = 'N'
     C     DLNO          READE     DLFEEDLC
     C                   ITER
     C                   ELSE
     C                   EVAL      WUpdateOnlyF = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   ENDIF
 
     C                   EVAL      EASTDT = EISTDT
     C                   EVAL      EAENDT = EIENDT
     C                   EVAL      WNextDate = EISTDT
     C                   EVAL      WLoopDoneF = 'N'
 
     C                   IF        WUpdateOnlyF = 'Y'
 
     C     KDlNoFSeq     CHAIN     MMEIRAL3
 
     C                   DOW       %FOUND(MMEIRAL3)
     C                             AND EATYPE = 'N'
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   DELETE    MMEIRAD3
     C     KDlNoFSeq     CHAIN     MMEIRAL3
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EVAL      WRepAmount = *ZERO
     C     KDlNoFSeq     CHAIN     MMCFLAL3
     C                   DOU       WLoopDoneF = 'Y'
 
     C                   IF        LCPYON = 'N'
     C                             AND %FOUND(MMCFLAL3)
 
     C                   EVAL      WPrevDate = WNextDate
     C                   EVAL      EASDAM = WPrevDate
 
     C     KDlNoFSeq     READE     MMCFLAL3
 
     C                   IF        %FOUND(MMCFLAL3)
     C     KDlNoFSeq     READPE    MMCFLAL3
     C                   EVAL      WNextDate = CFFLDT
     C                   EVAL      EAEDAM = WNextDate
     C     KDlNoFSeq     READE     MMCFLAL3
     C                   ELSE
     C                   EVAL      WNextDate = EIENDT
     C                   EVAL      EAEDAM = WNextDate
     C                   EVAL      WLoopDoneF = 'Y'
     C                   ENDIF
 
     C                   EVAL      EATYPE = 'N'
     C                   EVAL      EAEDAM = LCLDAT
     C                   EVAL      WAccAmount = CFCAMT
     C                   EVAL      WRepAmount = WAccAmount + CFCAMT
 
     C                   ELSE
     C                   EVAL      EATYPE = 'E'
     C                   EVAL      EASDAM = EISTDT
     C                   EVAL      EAEDAM = EIENDT
     C                   EVAL      WAccAmount = LCFAMT
     C                   EVAL      WLoopDoneF = 'Y'
     C                   ENDIF
 
     C                   EVAL      PCurrency = LCFCCY
     C                   EXSR      SrCurr
 
      ** Convert Fee Currency when it is not the Deal Currency
     C                   IF        CCY <> LCFCCY
     C                   EVAL      PFrCurrency = LCFCCY
     C                   EVAL      PToCurrency = CCY
     C                   EVAL      PAmount = WAccAmount
     C                   EXSR      SrConvert
     C                   ELSE
     C                   EVAL      POutXRat = A6SPRT
     C                   EVAL      POutMDIn = A6MDIN
     C                   EVAL      POutAmount = WAccAmount
     C                   ENDIF
 
     C                   EVAL      EARECI = 'D'
     C                   EVAL      EATRAN = LCDLNO
     C                   EVAL      EAFCOD = LCFCOD
     C                   EVAL      EAFSEQ = LCFSEQ
     C                   EVAL      EACCY = LCFCCY
     C                   EVAL      EAXRAT = POutXRat
     C                   EVAL      EAMDIN = POutMDIn
     C                   EVAL      EASTDT = EISTDT
     C                   EVAL      EAENDT = EIENDT
     C                   MOVE      POutAmount    EAAMNT
     C                   MOVE      WAccAmount    EAOAMT
 
     C                   IF        WUpdateOnlyF = 'Y'
     C                             AND LCPYON <> 'N'
     C                   UPDATE    MMEIRAD3
     C                   ELSE
     C                   WRITE     MMEIRAD0
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WRepAmount = 0
     C                   EVAL      WTempAmount = WTempAmount + WAccAmount
     C                   ELSE
     C                   EVAL      WTempAmount = WTempAmount + WRepAmount
     C                   EVAL      POutAmount = WRepAmount
     C                   ENDIF
 
     C                   IF        CCY <> LCFCCY AND WRepAmount <> 0
     C                   EVAL      PFrCurrency = LCFCCY
     C                   EVAL      PToCurrency = CCY
     C                   EVAL      PAmount = WRepAmount
     C                   EXSR      SrConvert
     C                   ENDIF
 
      ** If EIR being updated is a current EIR, update DLFEED
     C                   IF        EIRECI = 'D'
     C                   EVAL      LCFEAM = LCFEAM + POutAmount
     C                   UPDATE    DLFEEDDC
     C                   ENDIF
 
     C     DLNO          READE     DLFEEDLC
     C                   ENDDO
 
     C                   IF        WTempAmount > 0
     C                   EVAL      EIFDPC = WTempAmount + EIFDPC
     C                   ENDIF
 
      ** Set transaction to mature when Period End Date is less than
      ** or equal to rundate and Accrual starts on First Day
     C                   IF        EIENDT <= BJRDNB AND BKALDI <> 'N'
     C                   EVAL      EIRECI = 'M'
     C                   EVAL      EIRHistFmt = EIRCurrFmt
     C                   WRITE     MMEIRHD0
 
     C                   ELSE
     C                   EVAL      EIRECI = 'D'
     C                   WRITE     MMEIRDD0
 
     C                   IF        RCDT = 'C'
     C                   UPDATE    DEALSDCF
     C                   ELSE
     C                   UPDATE    DEALSDDF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  233601
      *****************************************************************                       233601
      *                                                               *                       233601
      * SrAmortise2 - Compute amount to amortise for the period       *                       233601
      *                                                               *                       233601
      *****************************************************************                       233601
                                                                                              233601
     C     SrAmortise2   BEGSR                                                                233601
                                                                                              233601
     C                   EVAL      WTempAmount = 0                                            233601
     C                   EVAL      WAmortAmnt = 0                                             233601
                                                                                              233601
     C                   IF        DISA <> 0                                                  233601
      ** Discount Processing                                                                  233601
                                                                                              233601
     C                   EVAL      WAmortAmnt = DISA                                          233601
                                                                                              233601
      ** Get Currency details from the currencies file                                        233601
                                                                                              233601
     C                   EVAL      PAmount = WAmortAmnt                                       233601
     C                   EVAL      PCurrency = CCY                                            233601
     C                   EXSR      SrCurr                                                     233601
                                                                                              233601
     C                   EVAL      EARECI = 'D'                                               233601
     C                   EVAL      EATYPE = 'D'                                               233601
     C                   EVAL      EATRAN = DLNO                                              233601
     C                   EVAL      EAFCOD = *ZEROS                                            233601
     C                   EVAL      EAFSEQ = *ZEROS                                            233601
     C                   EVAL      EACCY  = CCY                                               233601
     C                   EVAL      EAXRAT = A6SPRT                                            233601
     C                   EVAL      EAMDIN = A6MDIN                                            233601
     C                   EVAL      EASTDT = EISTDT                                            233601
     C                   EVAL      EAENDT = EIENDT                                            233601
     C                   EVAL      EASDAM = EISTDT                                            233601
     C                   EVAL      EAEDAM = EIENDT                                            233601
     C                   MOVE      WAmortAmnt    EAAMNT                                       233601
     C                   MOVE      DISA          EAOAMT                                       233601
                                                                                              233601
     C                   WRITE     MMEIRAD0                                                   233601
                                                                                              233601
                                                                                              233601
      ** For update of DEALS file later on.                                                   233601
                                                                                              233601
     C                   EVAL      DSAM = DISA                                                233601
                                                                                              233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C                   EVAL      WTempAmount = WAmortAmnt                                   233601
     C                   EVAL      WAmortAmnt = 0                                             233601
     C                   EVAL      WFeeExist = 0                                           BUG12989A
                                                                                              233601
     C*****DLNO*         SETLL     DLFEEDLB                                          233601 BUG12989
     C*****DLNO*         READE     DLFEEDLB                                          233601 BUG12989
     C*****DLNO*         CHAIN     DLFEEDLB                                       BUG12989 BUG12989A
     C     DLNO          SETLL     DLFEEDLB                                                BUG12989A
     C     DLNO          READE     DLFEEDLB                                                BUG12989A
                                                                                              233601
     C                   EVAL      KDlNo = DLNO                                               233601
                                                                                              233601
     C                   DOW       NOT %EOF(DLFEEDLB)                                         233601
                                                                                              233601
     C                   EVAL      WAmortAmnt = LBFAMT                                        233601
     C                   EVAL      WFeeExist = 1                                           BUG12989A
                                                                                              233601
     C                   IF        WAmortAmnt <> 0                                            233601
                                                                                              233601
     C                   EVAL      PCurrency = LBFCCY                                         233601
     C                   EXSR      SrCurr                                                     233601
                                                                                              233601
      ** Convert Fee Currency when it is not the Deal Currency                                233601
                                                                                              233601
     C                   IF        CCY <> LBFCCY                                              233601
     C                   EVAL      PFrCurrency = LBFCCY                                       233601
     C                   EVAL      PToCurrency = CCY                                          233601
     C                   EVAL      PAmount = WAmortAmnt                                       233601
     C                   EXSR      SrConvert                                                  233601
     C                   ELSE                                                                 233601
     C                   EVAL      POutXRat = A6SPRT                                          233601
     C                   EVAL      POutMDIn = A6MDIN                                          233601
     C                   EVAL      POutAmount = WAmortAmnt                                    233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C                   EVAL      EARECI = 'D'                                               233601
     C                   EVAL      EATYPE = LBPYON                                            233601
     C                   EVAL      EATRAN = LBDLNO                                            233601
     C                   EVAL      EAFCOD = LBFCOD                                            233601
     C                   EVAL      EAFSEQ = LBFSEQ                                            233601
     C                   EVAL      EACCY  = LBFCCY                                            233601
     C                   EVAL      EAXRAT = POutXRat                                          233601
     C                   EVAL      EAMDIN = POutMDIn                                          233601
     C                   EVAL      EASTDT = EISTDT                                            233601
     C                   EVAL      EAENDT = EIENDT                                            233601
     C                   EVAL      EASDAM = LBPSTD                                            233601
     C                   IF        LBPYON = ' '                                               233601
     C                   EVAL      EAEDAM = 0                                                 233601
     C                   ELSE                                                                 233601
     C                   EVAL      EAEDAM = LBPEND                                            233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C                   MOVE      POutAmount    EAAMNT                                       233601
     C                   MOVE      WAmortAmnt    EAOAMT                                       233601
     C                   EVAL      PSumFee = 0                                                233601
     C                   EVAL      WRepAmount = 0                                           BUG13053
                                                                                              233601
     C                   IF        LBPYON <> 'N'                                              233601
     C                   EVAL      PSumFee = PSumFee + POutAmount                             233601
     C                   WRITE     MMEIRAD0                                                   233601
     C                   ELSE                                                                 233601
     C                   EVAL      KDlNo = DLNO                                               233601
     C                   EVAL      KFSeq = LBFSEQ                                             233601
     C     KDlNoFSeq     CHAIN     MMCFLAL3                                                   233601
     C                   DOU       NOT %FOUND(MMCFLAL3)                                       233601
     C                             OR %EOF(MMCFLAL3)                                          233601
     C                   EVAL      EASDAM = CFFLDT                                            233601
     C     KDlNoFSeq     READE     MMCFLAL3                                                   233601
     C                   EVAL      EAEDAM = CFFLDT                                            233601
     C                   EVAL      PSumFee = PSumFee + POutAmount                             233601
     C                   IF        LBADJY = 'Y'                                             BUG13053
     C                   EVAL      WRepAmount = WRepAmount + POutAmount                     BUG13053
     C                   ENDIF                                                              BUG13053
     C                   WRITE     MMEIRAD0                                                   233601
     C                   ENDDO                                                                233601
     C                   ENDIF                                                                233601
                                                                                              233601
      ** Update Fee details                                                                   233601
                                                                                              233601
     C                   EVAL      LBFEAM = PSumFee                                           233601
     C                   UPDATE    DLFEEDDB                                                   233601
                                                                                              233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C                   EVAL      WTempAmount = WTempAmount + PSumFee                        233601
                                                                                              233601
     C     DLNO          READE     DLFEEDLB                                                   233601
     C                   ENDDO                                                                233601
                                                                                            BUG12989
     ******DLNO*         CHAIN     DLFHSTL0                                       BUG12989 BUG12989A
     C     DLNO          SETLL     DLFHSTL0                                                BUG12989A
     C     DLNO          READE     DLFHSTL0                                                BUG12989A
     C**********         IF        %FOUND(DLFHSTL0)                               BUG12989 BUG12989A
     C                   DOW       NOT %EOF(DLFHSTL0)                                      BUG12989A
     C                   EVAL      KDlNo = HIDLNO                                           BUG12989
     C                   EVAL      KFSeq = HIFSEQ                                           BUG12989
     C                   EVAL      WFeeExist = 1                                           BUG12989A
                                                                                            BUG12989
     C*****KDlNoFSeq     CHAIN     MMEIRAL3                                       BUG12989 BUG12989A
     C     KDlNoFSeq     SETLL     MMEIRAL3                                                BUG12989A
     C     KDlNoFSeq     READE     MMEIRAL3                                                BUG12989A
     C**********         IF        %FOUND(MMEIRAL3)                               BUG12989 BUG12989A
     C                   DOW       NOT %EOF(MMEIRAL3)                                      BUG12989A
     C**********         EVAL      WTempAmount = EAAMNT                           BUG12989 BUG12989A
     C                   EVAL      WTempAmount = WTempAmount + EAAMNT                      BUG12989A
     C                   EVAL      EAENDT = EIENDT                                          BUG12989
     C                   UPDATE    MMEIRAD3                                                 BUG12989
     C     KDlNoFSeq     READE     MMEIRAL3                                                BUG12989A
     C**********         ENDIF                                                    BUG12989 BUG12989A
     C                   ENDDO                                                             BUG12989A
                                                                                            BUG12989
     C*****DLNO*         READE     DLFHSTL0                                       BUG12989 BUG12989A
     C**********         DOW       NOT %EOF(DLFHSTL0) and EATYPE = 'N'            BUG12989 BUG12989A
     C**********         EVAL      WTempAmount = WTempAmount + EAAMNT             BUG12989 BUG12989A
     C     DLNO          READE     DLFHSTL0                                                 BUG12989
     C                   ENDDO                                                              BUG12989
     C**********         ENDIF                                                    BUG12989 BUG12989A
                                                                                              233601
     C**********         IF        %FOUND(DLFHSTL0) or %FOUND(DLFEEDLB)           BUG12989 BUG12989A
     C                   IF        WFeeExist = 1                                           BUG12989A
     C                   EVAL      EIFDPA = WTempAmount                                       233601
     C                   ENDIF                                                              BUG12989
                                                                                              233601
     C                   EVAL      KDate = EISTDT                                             233601
     C     KDlNoDate     SETLL     MMCFSFL0                                                   233601
                                                                                              233601
     C                   IF        %EQUAL(MMCFSFL0)                                           233601
     C                   READ      MMCFSFL0                                                   233601
     C                   ELSE                                                                 233601
     C                   READP     MMCFSFL0                                                   233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C                   EVAL      EIDSTD = MFCPAM - EIFDPA                                   233601
                                                                                              233601
      ** Set TFDP Amount if reccuring amount is processed.                                  BUG13053
     C                   IF        LBPYON   = 'N' And                                       BUG13053
     C                             PSumFee > 0                                              BUG13053
     C                   EVAL      TFDP = PsumFee + TFDP                                    BUG13053
      *                                                                                     BUG13053
     C                   EVAL      TFDPA = WRepAmount + TFDPA                               BUG13053
      *                                                                                     BUG13053
     C                   ENDIF                                                              BUG13053
      **                                                                                    BUG13053
      ** Set transaction to mature when Period End Date is less than                          233601
      ** or equal to rundate and Accrual starts on First Day                                  233601
     C                   IF        EIENDT <= BJRDNB AND BKALDI <> 'N'                         233601
     C                   EVAL      EIRECI = 'M'                                               233601
     C                   EVAL      EIRHistFmt = EIRCurrFmt                                    233601
     C                   WRITE     MMEIRHD0                                                   233601
                                                                                              233601
     C                   ELSE                                                                 233601
     C                   EVAL      EIRECI = 'D'                                               233601
     C                   WRITE     MMEIRDD0                                                   233601
                                                                                              233601
     C                   IF        RCDT = 'C'                                                 233601
     C                   UPDATE    DEALSDCF                                                   233601
     C                   ELSE                                                                 233601
     C                   UPDATE    DEALSDDF                                                   233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C                   ENDSR                                                                233601
                                                                                              233601
      *****************************************************************                       233601
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAdjToEIR - Adjust Periods and flags Old EIR Periods as      *
      *              deleted                                          *
      *                                                               *
      *****************************************************************
 
     C     SrAdjToEIR    BEGSR
 
     C                   CLEAR                   EIRNewFmt
     C                   EVAL      EIADJP = *BLANKS
     C                   EVAL      EIRECI = '*'
     C                   EVAL      EIRHistFmt = EIRCurrFmt
     C                   EVAL      EIRNewFmt = EIRCurrFmt
     C                   IF        NOT(EIENDT <= BJRDNB AND BKALDI <> 'N')
     C                   WRITE     MMEIRHD0
     C                   ENDIF
     C                   DELETE    MMEIRDD0
 
     C*****DLNO          CHAIN     DEALSL6                                                    CAS011
     C     DLNO          CHAIN     DEALSL9                                                    CAS011
     C**********         IF        %FOUND(DEALSL6)                                            CAS011
     C                   IF        %FOUND(DEALSL9)                                            CAS011
     C                   EVAL      NWENDT = NAVDAT
     C                   ELSE
     C                   EVAL      NWENDT = MDAT
     C                   ENDIF
 
     C                   EVAL      NWRECI = 'D'
     C                   EVAL      NWADJP = *BLANKS
     C                   EVAL      NWRCAL = 'Y'
     C                   CLEAR                   EIRCurrFmt
     C                   EVAL      EIRCurrFmt = EIRNewFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrConvert - Convert from one currency to another              *
      *                                                               *
      *****************************************************************
 
     C     SrConvert     BEGSR
 
      ** Save currency specifics first (Exchange Rate, M/D Indicator
      ** and decimal places) then get the other currency's specifics
      ** from the currencies file
 
     C                   EVAL      PFrXRate = A6SPRT
     C                   EVAL      PFrMDIn = A6MDIN
     C                   EVAL      PFrDecPlace = A6NBDP
 
     C                   IF        BJCYCD <> PToCurrency
 
      ** If target currency is not the base currency, do cross
      ** currency conevrt
 
     C                   EVAL      PCurrency = PToCurrency
     C                   EXSR      SrCurr
 
     C                   EVAL      PToXRate = A6SPRT
     C                   EVAL      PToMDIn = A6MDIN
     C                   EVAL      PToDecPlace = A6NBDP
 
     C                   CALL      'ZCCYCN'
     C                   PARM                    PAmount
     C                   PARM                    PFrCurrency
     C                   PARM                    PToCurrency
     C                   PARM                    PFrXRate
     C                   PARM                    PToXRate
     C                   PARM                    PFrMDIn
     C                   PARM                    PToMDIn
     C                   PARM                    PFrDecPlace
     C                   PARM                    PToDecPlace
     C                   PARM                    POutAmount
     C                   PARM                    POutXRat
     C                   PARM                    POutMDIn
 
     C                   ELSE
 
      ** In Deal Currency is the base currency, do simple convert
     C                   CALL      'ZCONVZ1'
     C                   PARM                    PAmount
     C                   PARM                    PFrXRate
     C                   PARM                    PFrMDIn
     C                   PARM                    PFrCurrency
     C                   PARM                    PToCurrency
     C                   PARM                    PFrDecPlace
     C                   PARM                    PToDecPlace
     C                   PARM                    POutAmount
 
     C                   EVAL      POutXRat = PFrXRate
     C                   EVAL      POutMDIn = PFrMDIn
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCurr - Call to AOCCURR0                                     *
      *                                                               *
      *****************************************************************
 
     C     SrCurr        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDCURRPD'
     C                   EVAL      Dbase = 3
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Subroutine                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Set up Local Data Area
 
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey = *BLANKS
     C                   EVAL      DbPGM = *BLANKS
     C                   EVAL      DbPGM = 'DL004600'
     C                   EVAL      Dbase = *ZERO
     C                   OUT       LDA
 
     C     KDealType     KLIST
     C                   KFLD                    DTPE11
     C                   KFLD                    DLST11
 
     C     KDlNoDate     KLIST
     C                   KFLD                    KDlno
     C                   KFLD                    KDate
 
     C     KDlNoFSeq     KLIST
     C                   KFLD                    KDlno
     C                   KFLD                    KFseq
 
      ** Get Bank ICD
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C**********         CALLB     'AOGELRR0'                                                 CAS011
     C                   CALLB     'AOGELRR1'                                                 CAS011
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDGELRPD'
     C                   EVAL      Dbase = 2
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Calculate Event Control Date
     C                   IF        (BJDNWD - 1) > BKAPDT
     C                   EVAL      WEvCD = BKAPDT
     C                   ELSE
     C                   EVAL      WEvCD = BJDNWD - 1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
