     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Exemption Threshold')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVEMPTRH - SD Additional Customer Validate Exemption        *
      *              Threshold                                        *
      *                                                               *
      *  Function:  This module validates the Exemption Threshold     *
      *             on the new Additional Customer Details screen     *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR743761           Date 16Apr11               *
      *                 AR737976           Date 14Apr11               *
      *                 AR740758           Date 04Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24489           Date 25Jun09               *
      *                 BUG24514           Date 26Jun09               *
      *                 BUG24196           Date 05Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG23923           Date 07May09               *
      *                 BUG23657           Date 13Apr09               *
      *                 BUG22912           Date 17Feb09               *
      *                 BUG22578           Date 10Feb09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *--------------------------------------------------------------**
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR743761  - The pay/rec confirmation job DLC0211 encountered *
      *              a DB Error (Child:AR743762)                      *
      *  AR737976 - Three (3) fields were not highlighted to reflect  *
      *             that these needs to be populated (Child: AR737977)*
      *  AR740758 - System does not validate customer's individual    *
      *             threshold in CUSD against Country of Tax Code     *
      *             definition (Child: AR740759)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG24489 - Threshold defined for non-resident is accepted    *
      *             and validated in Joint Account Members Maint      *
      *  BUG24514 - Correct processing of Increase/Decrease of        *
      *             Threshold                                         *
      *  BUG24196 - Correct processing of Increase/Decrease of        *
      *             Threshold                                         *
      *  BUG23732 - Joint Account Threshold                           *
      *  BUG23923 - Possible to enter a threshold if customer is Tax  *
      *             status 'E'                                        *
      *  BUG23657 - Threshold/Certificate Value date and expiry date  *
      *  BUG22912 - Threshold processing should be used if Exemption  *
      *             Certificate held                                  *
      *  BUG22578 - Exemption Certificate Threshold Validation added  *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SRValEXTH - Validate Exemption Threshold                     *
      *  *INZSR    - Program Initialisation Routine                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *                                                                                     BUG22578
      ** Midas SD Cust Details by Country of Tax : Rtv Idx                                  BUG22578
      *                                                                                     BUG22578
     F***SDACTXL1  IF   E           K DISK    INFSR(*PSSR)                         BUG22578 AR740758
      *                                                                                     BUG23732
      ** SD Joint Account Member Details by Customer                                        BUG23732
      *                                                                                     BUG23732
     FSDJACCLB  IF   E           K DISK    INFSR(*PSSR)                                     BUG23732
      *                                                                                     BUG23732
      ** Midas SD Interest Payment History File : Rtv Idx                                   BUG23732
      *                                                                                     BUG23732
     FSDINPHL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG23732
      *                                                                                     BUG24514
      ** Interest Payment History for Joint Accounts                                        BUG24514
      *                                                                                     BUG24514
     FSDINPHL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG24514
     F                                     RENAME(SDINPHD0:SDINPHD3)                        BUG24514
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
      *
     D/COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Long DS for access programs
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** External DS for accessing Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency details                                       BUG24196
      *                                                                                     BUG24196
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                BUG24196
      *                                                                                     BUG24196
      ** External DS based on Customer
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
                                                                                              CER069
      ** External DS for SAR Details                                                          CER069
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER069
      *
      ** External DS based on Country of Tax
      *
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
     D ValidCCTX     E DS                  EXTNAME(SDVCCTXPD)                               AR740758
     D                                     PREFIX(V_)                                       AR740758
     D CheckCCTX     E DS                  EXTNAME(SDVCCTXPD)                               AR740758
     D                                     PREFIX(C_)                                       AR740758
      *
      ** External DS based on Branch file
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  WQQDFAC      E                     EXTFLD(QQDFAC)
      *
      ** External DS based on Location Codes
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *                                                                                     BUG23732
      ** External DS based on Additional Customer Details                                   BUG23732
      *                                                                                     BUG23732
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                BUG23732
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
     D Idy             S              3P 0                                                  AR740758
     D DDJATP          S              1A
     D DDCUST          S              6A
     D DDCOLC          S              2A                                                    AR740758
     D DDBRCD          S              3A                                                    AR740758
     D V_CCTXArr       S                   DIM(50) LIKE(ValidCCTX)                          AR740758
     D ValidActx       S              1A                                                    AR740758
     D DDEXTH          S              6A
     D ACEXTH          S              6P 0
     D OKEXTH          S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PKySt           S              7A
     D PColc           S              2A
     D PCntry          S              2A
     D WExThVal        S              6P 0
     D WExThVlJ        S              6P 0                                                  BUG24514
     D KFCusn          S              6A                                                    BUG22578
     D KFCTax          S              2A                                                    BUG22578
     D WSumThrs        S              6P 0                                                  BUG23732
     D PCustNum        S             10A                                                    BUG23732
     D CER069          S              1A                                                      CER069
     D PSard           S              6A                                                      CER069
      *
      ** Parameters for calling ZALIGN
      *
     D  PZAlignOk      S              1A
     D  PZField        S             16A
     D  PZADec         S              1P 0
     D  PZADig         S              2P 0
     D Wtuth           S             20P 5                                                  BUG24196
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = *ZEROS
      *
      ***Set*up*key*for*Country*of*Tax*********************************                     AR740758
      *
     C**********         EVAL      PCustNum = DDCUST                                 CER059 AR740758
     C**********         CALL      'AOCUSTR0'                                               AR740758
     C**********         PARM      *BLANKS       PRtCd                                      AR740758
     C**********         PARM      '*KEY'        POptn                                      AR740758
     C**********         PARM                    DDCUST                                       CER059
     C**********         PARM                    PCustNum                            CER059 AR740758
     C**********         PARM                    PKySt                                      AR740758
     C*****SDCUST        PARM      SDCUST        DSSDY                                      AR740758
      *
     C**********         IF        PRtCd =  *BLANKS                                         AR740758
     C**********         EVAL      PColc  = BBCOLC                                          AR740758
     C**********         ENDIF                                                              AR740758
      *
      ** Accessing the Branch Details of the Customer
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C**********         PARM                    BBBRCD                                     AR740758
     C                   PARM                    DDBRCD                                     AR740758
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Accessing the Location Details from the Branch Location
      *
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    A8LCCD
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
     C                   IF        PRtCd =  *BLANKS
     C                   EVAL      PCntry = DVCNCD
     C                   ENDIF
      *
      ** Retrieve the Country of Tax Details for the Customer
      *
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCntry
     C**********         PARM                    PColc                                      AR740758
     C                   PARM                    DDCOLC                                     AR740758
     C     SDCTTX        PARM      SDCTTX        DSLDY
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      EWINTH = *ZEROS
     C                   EVAL      EWJTTH = *ZEROS
     C                   EVAL      EWECTH = *ZEROS                                          BUG22578
     C                   ENDIF
      *                                                                                     BUG23732
      ** Retrieve 'previous' value of Threshold for the                                     BUG23732
      ** Customer, if exists                                                                BUG23732
      *                                                                                     BUG23732
     C                   EVAL      PCustNum = DDCUST                                        BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOACUSR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM                    PCustNum                                   BUG23732
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C                   EVAL      E5EXTH = *ZEROS                                          BUG23732
     C                   ENDIF                                                              BUG23732
      *
      ** Validate Exemption Threshold
      *
     C                   IF        DDEXTH <> *BLANKS AND EWTHMD = 'N'                       BUG24489
     C                   EVAL      OKEXTH = 'N'                                             BUG24489
     C                   EVAL      Idx = Idx + 1                                            BUG24489
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXTH'                       BUG24489 AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EXTH'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR9942'                               BUG24489
     C                   ELSE                                                               BUG24489
     C                   EXSR      SRValExth
     C                   ENDIF                                                              BUG24489
      *
      ** Incase of an Error
      *
     C                   IF        OKEXTH = 'N'
     C                   EVAL      RetCodeIn  = '*ERROR'
     C                   ELSE
     C                   MOVE      DDEXTH        ACEXTH
     C                   ENDIF
      *
      ** Return from program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValExth: Validate Exemption Threshold                      *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRValExth     BEGSR
                                                                                            BUG23732
     C                   EVAL      WSumThrs = 0                                             BUG23732
      *
      ** Entered value must be numeric
      *
     C                   IF        DDEXTH <> *BLANKS
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM      DDEXTH        PZField
     C                   PARM      0             PZADec
     C                   PARM      6             PZADig
      *
     C                   IF        PZAlignOk = 'N'
      *
     C                   EVAL      OKEXTH = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXTH'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EXTH'                                AR737976
     C                   EVAL      MsgIDXAr(Idx) = 'USR6504'
      *
     C                   ELSE
      *
      ** Blank out leading zeros, if any
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM      0             PZADec
      *
     C                   MOVE      PZField       DDEXTH
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Store Exemption Threshold in a Numeric Field
      *
     C                   IF        PZAlignOk <> 'N'
      *
     C                   MOVE      DDEXTH        WExThVal
     C                   Z-ADD     WExThVal      WExThVlJ                                   BUG24514
      *                                                                                     BUG23732
      ** Exemption Threshold amount, if amended, cannot be less than                        BUG23732
      ** the Utilisation up to Threshold Amount                                             BUG23732
      *                                                                                     BUG23732
     C                   IF        WExThVal <> E5EXTH                                       BUG23732
      *                                                                                     BUG23732
      ** Check if record exists for the Customer in the Interest                            BUG23732
      ** Payment History File                                                               BUG23732
      *                                                                                     BUG23732
     C     DDCUST        CHAIN     SDINPHL1                                                 BUG23732
      *                                                                                     BUG23732
     C                   IF        %FOUND(SDINPHL1)                                         BUG23732
      *                                                                                     BUG23732
     C                   Z-ADD     *ZERO         Wtuth                                      BUG24514
     C                   IF        TIJOIN = *BLANKS                                         BUG24514
     C                   EVAL      Wtuth = TIUTTH                                           BUG24196
     C                   ELSE                                                               BUG24514
     C                   MOVE      TIJOIN        KJOIN             6                        BUG24514
     C     KJOIN         SETLL     SDINPHL3                                                 BUG24514
     C     KJOIN         READE     SDINPHL3                                                 BUG24514
      *                                                                                     BUG24514
     C                   DOW       NOT %EOF(SDINPHL3)                                       BUG24514
     C                   ADD       TIUTTH        Wtuth                                      BUG24514
     C                   IF        DDCUST <> TICUST                                         BUG24514
     C                   ADD       TICUTH        WExThVlJ                                   BUG24514
     C                   ENDIF                                                              BUG24514
     C     KJOIN         READE     SDINPHL3                                                 BUG24514
     C                   ENDDO                                                              BUG24514
      *                                                                                     BUG24514
     C                   ENDIF                                                              BUG24514
      *                                                                                     BUG24514
     C                   IF        A6NBDP > 0                                               BUG24196
     C**********         EVAL      Wtuth = TIUTTH / (10 ** A6NBDP)                 BUG24196 BUG24514
     C                   EVAL      Wtuth = Wtuth / (10 ** A6NBDP)                           BUG24514
     C                   ENDIF                                                              BUG24196
      *                                                                                     BUG24196
     C**********         IF        WExThVal < TIUTTH                               BUG23732 BUG24196
     C**********         IF        WExThVal < Wtuth                                BUG24196 BUG24514
     C                   IF        WExThVlJ < Wtuth                                         BUG24514
     C                   EVAL      OKEXTH = 'N'                                             BUG23732
     C                   EVAL      Idx = Idx + 1                                            BUG23732
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXTH'                       BUG23732 AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EXTH'                                AR737976
     C                   EVAL      MsgIDXAr(Idx) = 'USR8328'                                BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23923
      ** Exemption Threshold cannot be entered if EU Tax Status is 'E'                      BUG23923
      *                                                                                     BUG23923
     C**********         EVAL      KFCusn = DDCUST                                 BUG23923 AR740758
     C**********         EVAL      KFCTax = BBCOLC                                 BUG23923 AR740758
      *                                                                                     BUG23923
     C                   EVAL      Idy = 1                                                  AR740758
     C                   EVAL      ValidActx = 'N'                                          AR740758
     C                   CLEAR                   ValidCCTX                                  AR740758
     C                   DOW       Idy <= 50                                                AR740758
     C                             AND V_CCTXArr(Idy) <> *BLANKS                            AR740758
     C                   EVAL      CheckCCTX = V_CCTXArr(Idy)                               AR740758
     C                   IF        C_CTCUST = DDCUST AND C_CTCTTX = DDCOLC                  AR740758
     C                   EVAL      ValidCCTX = V_CCTXArr(Idy)                               AR740758
     C                   EVAL      ValidActx = 'Y'                                          AR740758
     C                   LEAVE                                                              AR740758
     C                   ENDIF                                                              AR740758
     C                   EVAL      Idy = Idy + 1                                            AR743761
     C                   ENDDO                                                              AR740758
                                                                                            AR740758
     C*****KLActx        CHAIN     SDACTXL1                                        BUG23923 AR740758
      *                                                                                     BUG23923
     C**********         IF        %FOUND(SDACTXL1)                                BUG23923 AR740758
     C                   IF        ValidActx = 'Y'                                          AR740758
      *                                                                                     BUG23923
     C**********         IF        AXETXS = 'E' AND                                BUG23923 AR740758
     C                   IF        V_CTETXS = 'E' AND                                       AR740758
     C                             DDEXTH <> *BLANKS                                        BUG23923
     C                   EVAL      OKEXTH = 'N'                                             BUG23923
     C                   EVAL      Idx = Idx + 1                                            BUG23923
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXTH'                       BUG23923 AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EXTH'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR9910'                               BUG23923
     C**********         ENDIF                                                     BUG23923 BUG24196
      *                                                                                     BUG23923
     C                   ELSE                                                               BUG23923
      *
      ** If Customer number refers to a single private individual
      *
     C                   IF        DDJATP = 'I'
      *                                                                                     BUG22578
      ** Retrieve European Tax Status                                                       BUG22578
      *                                                                                     BUG22578
     C**********         EVAL      KFCusn = DDCUST                                 BUG22578 AR740758
     C**********         EVAL      KFCTax = BBCOLC                                 BUG22578 AR740758
      *                                                                                     BUG22578
     C*****KLActx        CHAIN     SDACTXL1                                        BUG22578 AR740758
      *                                                                                     BUG22578
     C**********         IF        %FOUND(SDACTXL1)                                BUG22578 AR740758
     C                   IF        ValidActx = 'Y'                                          AR740758
      *                                                                                     BUG22578
     C**********         IF        AXETXS = 'S'                                    BUG22578 BUG22912
     C**********         IF        AXETXS = 'T' AND                                BUG22912 AR740758
     C**********                   AXCRTP <> *BLANKS                               BUG22912 AR740758
     C**********         IF        BJRDNB >= AXCVDT AND                            BUG23657 AR740758
     C**********                   BJRDNB <= AXCEEX                                BUG23657 AR740758
     C**********                   OR BJRDNB >= AXCVDT AND                         BUG24196 AR740758
     C**********                   AXCEEX = *ZERO                                  BUG24196 AR740758
     C                   IF        V_CTETXS = 'T' AND                                       AR740758
     C                             V_CTCRTP <> *BLANKS                                      AR740758
     C                             OR V_CTETXS = 'Y' AND                                      CER069
     C                             V_CTCRTP <> *BLANKS AND                                    CER069
     C                             CER069 = 'Y'                                               CER069
     C                   IF        BJRDNB >= V_CTCVDT AND                                   AR740758
     C                             BJRDNB <= V_CTCEEX                                       AR740758
     C                             OR BJRDNB >= V_CTCVDT AND                                AR740758
     C                             V_CTCEEX = *ZERO                                         AR740758
      *                                                                                     BUG22578
     C                   IF        WExThVal > EWECTH                                        BUG22578
     C                   EVAL      OKEXTH = 'N'                                             BUG22578
     C                   EVAL      Idx = Idx + 1                                            BUG22578
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXTH'                       BUG22578 AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EXTH'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5980'                               BUG22578
     C                   ENDIF                                                              BUG22578
     C                   ENDIF                                                              BUG23657
      *                                                                                     BUG22578
     C**********         ELSEIF    AXETXS <> 'E'                                   BUG22578 BUG22912
     C**********         ELSEIF    AXETXS = 'T' AND                                BUG22912 AR740758
     C**********                   AXCRTP = *BLANKS                                BUG22912 AR740758
     C                   ELSEIF    V_CTETXS = 'T' AND                                       AR740758
     C                             V_CTCRTP = *BLANKS                                       AR740758
     C                             OR V_CTETXS = 'Y' AND                                      CER069
     C                             V_CTCRTP = *BLANKS AND                                     CER069
     C                             CER069 = 'Y'                                               CER069
      *                                                                                     BUG22578
     C                   IF        WExThVal > EWINTH
     C                   EVAL      OKEXTH = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXTH'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EXTH'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5978'
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG22578
      *                                                                                     BUG22578
     C                   ENDIF                                                              BUG22578
      *                                                                                     BUG22578
     C                   ENDIF                                                              BUG22578
      *                                                                                     BUG22578
     C**********         ENDIF                                                              BUG22578
      *
      ** If Customer number refers to a customer liked with further
      ** customers
      *
     C                   IF        DDJATP = 'Y'
      *
      ** Retrieve European Tax Status                                                       BUG22578
      *                                                                                     BUG22578
     C**********         EVAL      KFCusn = DDCUST                                 BUG22578 AR740758
     C**********         EVAL      KFCTax = BBCOLC                                 BUG22578 AR740758
      *                                                                                     BUG22578
     C*****KLActx        CHAIN     SDACTXL1                                        BUG22578 AR740758
      *                                                                                     BUG22578
     C**********         IF        %FOUND(SDACTXL1)                                BUG22578 AR740758
     C                   IF        ValidActx = 'Y'                                          AR740758
      *                                                                                     BUG22578
     C**********         IF        AXETXS = 'S'                                    BUG22578 BUG22912
     C**********         IF        AXETXS = 'T' AND                                BUG22912 AR740758
     C**********                   AXCRTP <> *BLANKS                               BUG22912 AR740758
     C**********         IF        BJRDNB >= AXCVDT AND                            BUG23657 AR740758
     C**********                   BJRDNB <= AXCEEX                                BUG23657 AR740758
     C**********                   OR BJRDNB >= AXCVDT AND                         BUG24196 AR740758
     C**********                   AXCEEX = *ZERO                                  BUG24196 AR740758
     C                   IF        V_CTETXS = 'T' AND                                       AR740758
     C                             V_CTCRTP <> *BLANKS                                      AR740758
     C                             OR V_CTETXS = 'Y' AND                                      CER069
     C                             V_CTCRTP <> *BLANKS                                        CER069
     C                             AND CER069 = 'Y'                                           CER069
     C                   IF        BJRDNB >= V_CTCVDT AND                                   AR740758
     C                             BJRDNB <= V_CTCEEX                                       AR740758
     C                             OR BJRDNB >= V_CTCVDT AND                                AR740758
     C                             V_CTCEEX = *ZERO                                         AR740758
      *                                                                                     BUG22578
     C                   IF        WExThVal > EWECTH                                        BUG22578
     C                   EVAL      OKEXTH = 'N'                                             BUG22578
     C                   EVAL      Idx = Idx + 1                                            BUG22578
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXTH'                       BUG22578 AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EXTH'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5980'                               BUG22578
     C                   ENDIF                                                              BUG22578
     C                   ENDIF                                                              BUG23657
      *                                                                                     BUG22578
     C**********         ELSEIF    AXETXS <> 'E'                                   BUG22578 BUG22912
     C**********         ELSEIF    AXETXS = 'T' AND                                BUG22912 AR740758
     C**********                   AXCRTP = *BLANKS                                BUG22912 AR740758
     C                   ELSEIF    V_CTETXS = 'T' AND                                       AR740758
     C                             V_CTCRTP = *BLANKS                                       AR740758
     C                             OR V_CTETXS = 'Y' AND                                      CER069
     C                             V_CTCRTP = *BLANKS                                         CER069
     C                             AND CER069 = 'Y'                                           CER069
      *                                                                                     BUG22578
     C                   IF        WExThVal > EWJTTH
     C                   EVAL      OKEXTH = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDEXTH'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EXTH'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5979'
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG22578
      *                                                                                     BUG22578
     C                   ENDIF
      *                                                                                     BUG22578
     C                   ENDIF                                                              BUG23923
      *                                                                                     BUG23923
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG24196
      *                                                                                     BUG24196
     C                   ENDIF                                                              BUG22578
      *                                                                                     BUG22578
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
     C                   PARM                    DDEXTH
     C                   PARM                    DDJATP
     C                   PARM                    DDCUST
     C                   PARM                    DDCOLC                                     AR740758
     C                   PARM                    DDBRCD                                     AR740758
     C                   PARM                    V_CCTXArr                                  AR740758
      *
      ** Outputs
      *
      *
      ** Exemption Threshold
      *
     C                   PARM                    ACEXTH
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for threshold
      *
     C                   PARM                    OKEXTH
      *
      ** Key List for Cust Details by Country of Tax                                        BUG22578
      *                                                                                     BUG22578
     C*****KLActx        KLIST                                                     BUG22578 AR740758
     C**********         KFLD                    KFCusn                            BUG22578 AR740758
     C**********         KFLD                    KFCTax                            BUG22578 AR740758
      *
      ** Access Bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *                                                                                     BUG24196
     C                   CALL      'AOCURRR0'                                               BUG24196
     C                   PARM      *BLANKS       PRtCd                                      BUG24196
     C                   PARM      '*KEY  '      POptn                                      BUG24196
     C                   PARM                    BJCYCD                                     BUG24196
     C     SDCURR        PARM      SDCURR        DSSDY                                      BUG24196
      *                                                                                     BUG24196
     C                   IF        PRtcd <> *BLANKS                                         BUG24196
      *                                                                                     BUG24196
     C                   EVAL      DBFILE = 'SDCURRPD'                                      BUG24196
     C                   EVAL      DBASE = 902                                              BUG24196
     C                   EVAL      DBKEY = BJCYCD                                           BUG24196
     C                   EXSR      *PSSR                                                    BUG24196
      *                                                                                     BUG24196
     C                   ENDIF                                                              BUG24196
                                                                                              CER069
      ** Access SAR file to determine if CER069 is present.                                   CER069
                                                                                              CER069
     C                   EVAL      CER069 = 'N'                                               CER069
                                                                                              CER069
     C                   CALLB     'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtCd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
                                                                                              CER069
     C                   IF        PRtCd <> *BLANKS AND                                       CER069
     C                             PRtCd <> '*NRF'                                            CER069
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
     C                   EVAL      DBASE = 903                                                CER069
     C                   EVAL      DBKEY = 'CER069'                                           CER069
     C                   EXSR      *PSSR                                                      CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   IF        PRtCd = *BLANKS                                            CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
     C                   ENDIF                                                                CER069
      *
      ** Program, module and procedure names for database error
      ** processing.
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
