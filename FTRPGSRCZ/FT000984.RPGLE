     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Calculate default receivers charges')         *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000984  - Fees and Charges : Calculates the default        *
      *              receivers charges for a transaction.             *
      *                                                               *
      *  Function:  This module shall calculate the default receivers *
      *             charges for a particular transaction.             *
      *                                                               *
      *             The default charges are calculated for the        *
      *             destination, intermediary and account with        *
      *             institution (if these are present).               *
      *                                                               *
      *             The charge amount is then converted to payment    *
      *             currency.                                         *
      *                                                               *
      * Note that this function is only applicable for outgoing       *
      *  payments and customer credit transfers ONLY.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 241255             Date 05Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 29Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  241255 - Use the customer number for PTYID if CustType = 'C' *
      *           and use the SWIFT ID for PTYID if CustType = 'S'.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * FT Receivers Charges File. = Party Id + ccy + Transaction Type.
     FFTRICHL0  IF   E           K DISK    INFSR(*PSSR)
 
      * Transaction Type Table
     FFTTRNTL0  IF   E           K DISK    INFSR(*PSSR)
 
      * Customer Details
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *  97 : General Chain Indicator                                 *
      *                                                               *
      *****************************************************************
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Outgoing Payments file/extension file
     D OtPay         E DS                  EXTNAME(OTPAYDD)
     D OtPayEx       E DS                  EXTNAME(OTPAYXPD)
 
      ** Customer Credit Transfer files
     D FT102H        E DS                  EXTNAME(FT102HPD) Prefix(H_)
     D FT102D        E DS                  EXTNAME(FT102DPD) Prefix(D_)
 
      ** EXTERNAL DS FOR CUSTOMER DETAILS
     D Accnt         E DS                  EXTNAME(ACCNTAB)  Prefix(A_)
 
      ** LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** Long datastructures input parameters.
     D P_TransDet      S           3000A
     D P_TransExt      S           3000A
 
      * Nostro DataStructure
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      * Customer
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
     D  SCLCD        E                     EXTFLD(LCD)                                        CFT120
 
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  MBIN                  13     13
 
      ** Partial General Ledger Type
 
     D PType           DS
     D   PCnum                        6
     D***PAcod**                      4                                                       CGL029
     D   PAcod                       10                                                       CGL029
     D   PAcsq                        2
     D   PBrcd                        3
      *
      ** General Ledger Type
     D GLType          DS
     D   GLBrcd                       3
     D   GLCnum                       6
     D   GLCycd                       3
     D***GLAcod*                      4                                                       CGL029
     D   GLAcod                      10                                                       CGL029
     D   GLAcsq                       2
 
      ** Work variables for customer and customer type
     D  CustType       S                   Like(DSTT)
     D  Cust           S                   Like(DST1)
     D  SwiftCust      S                   Like(BBCSID)
 
      ** Work variable for currency conversion
     D ChgCcyDP        S                   LIKE(A6NBDP)
     D ChgCcyMD        S                   LIKE(A6MDIN)
     D ChgSpotRate     S                   LIKE(A6SPRT)
 
     D PayCcyDP        S                   LIKE(A6NBDP)
     D PayCcyMD        S                   LIKE(A6MDIN)
     D PaySpotRate     S                   LIKE(A6SPRT)
 
      ** Parameters for ZRATE
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZRATEX          S             13P 8
     D ZMDIX           S              1A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @Kyst           S                   Like(@Rtcd)
     D CNum35          S             35
 
     D P_TransType     S                   Like(PYTP)
 
     D P_RcvCharge     S                   Like(OPRCRM)
 
     D  WCustNo        S                   Like(PTYID)
 
     D TotInChgCcy     S             13P 0
     D ChgableAmt      S             13P 0
     D PTierCharge     S            143A
     D PTierAmount     S            143A
 
     D Tmp12           S             12
 
     D SetCcy          S                   Like(Pccy)
     D PayCcy          S                   Like(Pccy)
     D ChgCcy          S                   Like(Pccy)
     D ChgExch         S                   Like(OPCHRT)
     D PayAmt          S                   Like(PYAM)
     D SettAmt         S                   Like(PYAM)
     D ChargesDR       S                   Like(CDRO)
     D P_ADDC          S                   Like(ADDC)
     D P_ChgDRCcy      S              3A                                                      CFT120
     D CFT120          S              1A                                                      CFT120
 
     D STP             S              1
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Ensure transaction type a) is in transaction type table and
      *  b) that flag 'Receivers charges' = 'Y'
 
     C     P_TransType   Chain     FTTRNTL0                           97
     C                   If        *In97 or RCVINT <> 'Y'
     C                   Eval      P_RcvCharge = *Zeros
     C                   Return
     C                   Endif
 
     C                   Eval      P_RcvCharge = 0
 
      * Move parameter data to datastructure
     C                   Select
     C                   When      P_TransType=  'OP'
     C                   Eval      OtPay       =  P_TransDet
     C                   Eval      OtPayEx     =  P_TransExt
 
     C                   EVAL      PayAmt      = PYAM
     C                   EVAL      PayCcy      = PCCY
     C                   Eval      CurCcy      = PCcy
     C                   Eval      SetCcy      = SMCY
     C                   EVAL      ChgExch     = OPCHRT
     C                   EVAL      ChgCcy      = OPCHGC
     C                   EVAL      STP         = OPSTPI
     C                   EVAL      ChargesDR = CDRO
     C                   Eval      SettAmt = SMAM
     C                   Eval      P_ADDC = ADDC
 
      *
      * Calculate charges for destination
      *
     C                   If        DSTT <> *Blank
     C                   Eval      CustType = DSTT
     C                   Eval      Cust = DST1
     C                   Exsr      #OtPay
     C                   Exsr      #CustLook
     C                   Endif
 
      *
      * Calculate charges for Intermediary
      *
     C                   If        INBT <> *Blank
     C                   Eval      CustType = INBT
 
     C                   If        %Subst(INB1:1:1) <> '/'
     C                   Eval      Cust = INB1
     C                   Else
     C                   Eval      Cust = INB2
     C                   Endif
 
     C                   Exsr      #OtPay
     C                   Exsr      #CustLook
     C                   Endif
 
      *
      * Calculate charges for Account With Institution
      *
     C                   If        ACBT <> *Blank
     C                   Eval      CustType = ACBT
 
     C                   If        %Subst(ACB1:1:1) <> '/'
     C                   Eval      Cust = ACB1
     C                   Else
     C                   Eval      Cust = ACB2
     C                   Endif
 
     C                   Exsr      #OtPay
     C                   Exsr      #CustLook
     C                   Endif
 
      * ================================================================
      * Customer Credit Transfers
     C                   When      P_TransType=  'BO'
     C                   Eval      FT102H     =  P_TransDet
     C                   Eval      FT102D     =  P_TransExt
     C                   If        D_CCYCHG = 'OUR' or
     C                             H_CCTCHG = 'OUR'
 
     C                   Eval      CurCcy  = D_PAYCCY
 
     C                   EVAL      PayAmt  = D_CCTAMT
     C                   EVAL      PayCcy  = D_CCTCCY
     C                   EVAL      ChgExch = D_M2CHRT
     C                   EVAL      ChgCcy  = D_M2CHGC
     C                   IF        D_INUSER = '*STP   '
     C                   EVAL      STP = 'Y'
     C                   ELSE
     C                   EVAL      STP = *Blank
     C                   ENDIF
 
     C                   Exsr      #CCT
 
     C                   Endif
 
     C                   Other
     C                   Eval      P_RcvCharge = *Zeros
     C                   Return
 
     C                   Endsl
 
      * If charges calculated convert to payccy if necessary
     C                   If        P_RcvCharge > 0 AND
     C                             PayCcy <> ChgCcy
 
     C                   Exsr      SRConvert
 
     C                   Endif
 
 
     C                   Return
 
      /EJECT
      *****************************************************************
      * #OtPay - Calculates Receivers Charges for Outgoing Payments   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     #OtPay        Begsr
 
      * For outgoing payments calculate the default receivers charges
      *  using the customer number, the transfer currency and the
      *  transaction type (OP).  If a match is found in the default
      *  receivers charges table, use the charge code to calculate the
      *  default receivers charges.
 
     C                   Select
     C                   When      CustType = 'C'
 
      ** If it is a partial GL, convert it into a full GL for call
      ** of AOACCTV1
     C                   Exsr      FormatAcc
 
     C                   When      CustType = 'N' or CustType = 'F'
 
     C                   IF        CustType = 'N'
     C                   Movel     Cust          Tmp12
     C                   Eval      CNum35 = PCCY + %Subst(Tmp12:1:2)
     C                   Else
     C                   Eval      CNum35 = Cust
     C                   Endif
 
     C                   CallB     'AOACCTV1'
     C                   Parm      '*DBERR'      @Rtcd
     C                   Parm      '*KEY'        @Optn
     C                   Parm                    CNum35
     C     Dssdy         Parm      *Blanks       Dssdy
 
     C                   Select
     C                   When      @Optn  = '*NOSTRO'
     C                   Eval      SDNOST = Dssdy
     C                   Movel     A7CUST        WCustNo
 
     C                   Other
     C                   Eval      ReturnCode = '*ERROR'
     C                   Eval      DBKey  =  CNum35
     C                   Eval      DBPgm  =  PSProcPgm
     C                   Eval      DBase  =  2
     C                   Eval      DBMod  =  PSProcMod
     C                   Eval      DBProc =  '#OtPay'
     C                   Exsr      *PSSR
     C                   Endsl
 
     C                   When      CustType = 'G'
     C                   Move      Cust          WCustNo
 
     C                   When      CustType = 'R'
     C                   Movel     Cust          CNum35
     C                   CallB     'AOACCTV1'
     C                   Parm      '*DBERR'      @Rtcd
     C                   Parm      '*KEY'        @Optn
     C                   Parm                    CNum35
     C     Dssdy         Parm      *Blanks       Dssdy
 
     C                   Select
     C                   When      @Optn = '*RETAIL'
     C                   Eval      Accnt  = Dssdy
     C                   Movel     A_CNum        WCustNo
 
     C                   Other
     C                   Eval      ReturnCode = '*ERROR'
     C                   Eval      DBKey  =  CNum35
     C                   Eval      DBPgm  =  PSProcPgm
     C                   Eval      DBase  =  3
     C                   Eval      DBMod  =  PSProcMod
     C                   Eval      DBProc =  '#OtPay'
     C                   Exsr      *PSSR
     C                   Endsl
 
     C                   When      CustType = 'S'
      * First lookup SDCUSTl7 to obtain the customer number for the BIC entered.
      *  Use the customer number found for subsequent lookups.  If no BIC found,
      *  use the BIC code for subsequent processing.
 
     C                   Eval      SwiftCust = Cust
     C     SwiftCust     Chain     SDCUSTL7                           97
     C                   If        *In97 = *Off                                 Found
     C                   Eval      WCustNo = BBCUST
     C                   Else
     C                   Eval      WCustNo = SwiftCust
     C                   Endif
 
     C                   When      CustType = 'A'
      * No Processing / lookup Necessary
 
     C                   Endsl
 
     C     EndOtPay      Endsr
      /EJECT
      *****************************************************************
      * #CCt   - Calculates Receivers Charges Customer Credit         *
      *          Transfers (Outgoing)                                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     #CCT          Begsr
 
      * Calculate charges for destination.
     C                   If        H_DSTTYP = 'F'  or
     C                             H_DSTTYP = 'G'  or
     C                             H_DSTTYP = 'R'  or
     C                             H_DSTTYP = 'C'  or
     C                             H_DSTTYP = 'S'
 
     C                   Eval      CNum35 = H_CCTDST
 
     C                   CallB     'AOACCTV1'
     C                   Parm      '*DBERR'      @Rtcd
     C                   Parm      '*KEY'        @Optn
     C                   Parm                    CNum35
     C     Dssdy         Parm      *Blanks       Dssdy
 
     C                   Select
     C                   When      @Optn = '*NOSTRO'
     C                   Eval      SDNOST = Dssdy
     C                   Movel     A7CUST        WCustNo
 
     C                   When      @Optn = '*RETAIL'  or
     C                             @Optn = '*LEDGER'
     C                   Eval      Accnt  = Dssdy
     C                   Movel     A_CNum        WCustNo
 
     C                   When      @Optn = '*SHNAME' or
     C                             @Optn = '*CUSTNO'
     C                   Eval      SdCust = Dssdy
     C                   Movel     BBCUST        WCustNo
 
     C                   EndSl
 
     C                   EndIf
 
     C                   Exsr      #CustLook
 
      * Calculate charges for account with institution.
     C                   If        D_AWITP  = 'F'  or
     C                             D_AWITP  = 'G'  or
     C                             D_AWITP  = 'R'  or
     C                             D_AWITP  = 'C'  or
     C                             D_AWITP  = 'S'
 
     C                   Eval      CNum35 = D_ACCI35
 
     C                   CallB     'AOACCTV1'
     C                   Parm      '*DBERR'      @Rtcd
     C                   Parm      '*KEY'        @Optn
     C                   Parm                    CNum35
     C     Dssdy         Parm      *Blanks       Dssdy
 
     C                   Select
     C                   When      @Optn = '*NOSTRO'
     C                   Eval      SDNOST = Dssdy
     C                   Movel     A7CUST        WCustNo
 
     C                   When      @Optn = '*RETAIL'  or
     C                             @Optn = '*LEDGER'
     C                   Eval      Accnt  = Dssdy
     C                   Movel     A_CNum        WCustNo
 
     C                   When      @Optn = '*SHNAME' or
     C                             @Optn = '*CUSTNO'
     C                   Eval      SdCust = Dssdy
     C                   Movel     BBCUST        WCustNo
 
     C                   EndSl
 
     C                   EndIf
 
     C                   Exsr      #CustLook
 
     C                   Endsr
      /EJECT
      *****************************************************************
      * #CustLook - Lookup receivers and intermediaries charges       *
      *             table to see if customer exists.                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     #CustLook     Begsr
 
     C                   Eval      *In97 = *Off
     C                   Eval      TotInChgCcy = *Zeros
 
     C                   Eval      ChgCd = *Blanks
 
     C                   If        CustType = 'C'                                             241255
     C                   Eval      PTYID = WCustNo
     C                   Endif                                                                241255
                                                                                              241255
     C                   If        CustType = 'S'                                             241255
     C                   Eval      PTYID = SwiftCust                                          241255
     C                   Endif                                                                241255
 
     C     TPICcyTt      Chain     FtRichL0                           97
     C                   If        *In97 = *Off                                 Found
     C                   Else
     C     TPICcy        Chain     FtRichL0                           97
     C                   If        *In97 = *Off                                 Found
     C                   Else
     C     TPI           Chain     FtRichL0                           97
     C                   Endif
     C                   Endif
 
      * If currency blanked via chain to FtRich, reinstate as current pay currency.
     C                   If        CurCcy = *Blanks
     C                   Eval      CurCcy = PayCcy
     C                   Endif
      *                                                                                       CFT120
      ** Set up Charges to the DR of Currency from input values                               CFT120
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = OPCDRC                                        CFT120
     C                   ENDIF                                                                CFT120
 
     C                   If        *In97 = *Off                                 Found
     C                   CallB     'FT000981'
     C                   Parm                    RetCodeIn
     C                   Parm                    PayAmt
     C                   Parm                    CurCcy
     C                   Parm                    SetCcy
     C                   Parm                    ChgCcy
     C                   Parm                    ChgExch
     C                   Parm                    STP
     C                   Parm                    ChgCd
     C                   Parm                    SettAmt
     C                   Parm                    ChargesDR
     C                   Parm                    ADDC
     C                   PARM                    P_ChgDRCcy                                   CFT120
      *
     C                   Parm                    TotInChgCcy
     C                   Parm                    ChgableAmt
     C                   Parm                    PTierCharge
     C                   Parm                    PTierAmount
 
     C                   Eval      P_RcvCharge = P_RcvCharge + TotInChgCcy
 
     C                   Endif
 
     C                   Endsr
      /EJECT
      *****************************************************************
      * SRConvert - Convert Charges in Charge Currency to Pay Ccy     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRConvert     Begsr
 
      * Get SPOT RATE FOR CHARGES CURRENCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    ChgCcy
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
 
      *
      * Database error
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     ChgCcy        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ChgCcyDP    = A6NBDP
     C                   EVAL      ChgCcyMD    = A6MDIN
     C                   EVAL      ChgSpotRate = A6SPRT
 
      * Get SPOT RATE FOR PAY CURRENCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PayCcy
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
 
      *
      * Database error
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     PayCcy        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PayCcyDP    = A6NBDP
     C                   EVAL      PayCcyMD    = A6MDIN
     C                   EVAL      PaySpotRate = A6SPRT
 
      *
      * Calculate Cross Rate between charge and pay currency
      *
     C                   EVAL      ZAMTCI = P_RcvCharge
     C                   EVAL      ZAMTCO = *Zeros
 
     C                   EVAL      ZCCYI  = ChgCcy
     C                   EVAL      ZCDPI  = ChgCcyDP
     C                   EVAL      ZRATE1 = ChgSpotRate
     C                   EVAL      ZMDI1  = ChgCcyMD
 
     C                   EVAL      ZCCYO  = PayCcy
     C                   EVAL      ZCDPO  = PayCcyDP
     C                   EVAL      ZRATE2 = PaySpotRate
     C                   EVAL      ZMDI2  = PayCcyMD
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
 
     C                   EVAL      ZEXCH = ZRATEX
 
     C                   EVAL      ZMD   = ZMDIX
 
     C                   CALLB     'ZCONVZ1'     Convert
 
     C                   Eval      P_RcvCharge = ZAMTCO
 
 
     C                   Endsr
      /EJECT
      *****************************************************************
      * FormatAcc : Format Account for GL Accounts                    *
      *                                                               *
      * Called by: #OTPAY                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     FormatAcc     Begsr
 
     C                   Movel     Cust          CNum35
 
     C                   CallB     'AOACCTV1'
     C                   Parm      '*DBERR'      @Rtcd
     C                   Parm      '*KEY'        @Optn
     C                   Parm                    CNum35
     C     Dssdy         Parm      *Blanks       Dssdy
 
 
     C                   Select
     C                   When      @Optn = '*LEDGER'   or
     C                             @Optn = '*RETAIL'
     C                   Eval      Accnt  = Dssdy
     C                   Movel     A_CNum        WCustNo
 
 
     C                   When      @Optn = '*CUSTNO'   or
     C                             @Optn = '*SHNAME'
     C                   Eval      SdCust = Dssdy
     C                   Movel     BBCUST        WCustNo
 
 
     C                   When      @Optn = '*NOSTRO'
     C                   Eval      SdNost = Dssdy
     C                   Movel     A7CUST        WCustNo
 
     C                   Other
     C                   Eval      ReturnCode = '*ERROR'
     C                   Eval      DBKey  =  CNum35
     C                   Eval      DBPgm  =  PSProcPgm
     C                   Eval      DBase  =  5
     C                   Eval      DBMod  =  PSProcMod
     C                   Eval      DBProc =  '#OtPay'
     C                   Exsr      *PSSR
     C                   EndSl
 
     C                   Endsr
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Entry parameters:
     C     *Entry        Plist
      *
      ** Return Code (10A)
      ** Transaction - Main file
      ** Transaction - Extension file
      ** Transaction Type (2A)
      ** Recievers Charge (Calculated : Returned)
     C                   PARM                    RetCodeIn
     C                   PARM                    P_TransDet
     C                   PARM                    P_TransExt
     C                   PARM                    P_TransType
     C                   PARM                    P_RcvCharge
 
      * PLIST for ZCONVZ1
     C     Convert       PLIST
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
 
      ** Read in RUNDAT for multibranching details
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   Eval      DBKey  =  @Optn
     C                   Eval      DBPgm  =  PSProcPgm
     C                   Eval      DBase  =  3
     C                   Eval      DBMod  =  PSProcMod
     C                   Eval      DBProc =  '#OtPay'
     C                   Exsr      *PSSR
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Initialise program name
     C                   Eval      DBPGM = PsProcPgm
 
      *                                                                                       CFT120
      ** Check if CFT120 is switched on                                                       CFT120
      *                                                                                       CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD             6                          CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD <> '*NRF '                                           CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 006                                                CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      * Receivers and intermediaries key list : Full Key - Third Party + Ccy + Type
     C     TPICcyTt      Klist
     C                   Kfld                    PTYID
     C                   Kfld                    CurCcy
     C                   Kfld                    P_TransType
 
      * Receivers and intermediaries key list : Key - Third Party + Ccy
     C     TPICcy        Klist
     C                   Kfld                    PTYID
     C                   Kfld                    CurCcy
 
      * Receivers and intermediaries key list : Key - Third Part
     C     TPI           Klist
     C                   Kfld                    PTYID
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
