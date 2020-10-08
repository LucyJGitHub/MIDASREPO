     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Charge Calculation Module')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000980  - FEES AND CHARGES: CHARGE CALCULATION             *
      *                                                               *
      *  Function:  Called from incoming, outgoing payments, requests *
      *             for transfer, cheques for collection, cheques to  *
      *             be paid and customer credit transfer module to    *
      *             calculate the default charges for the requesting  *
      *             application.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT120             Date 28Sep12               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15088A          Date 29Oct07               *
      *                 BUG14880           Date 19Sep07               *
      *                 246723             Date 18Apr07               *
      *                 248174             Date 24Aug07               *
      *                 246583             Date 17Aug07               *
      *                 BUG14143           Date 11Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12705           Date 17Nov06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG6864            Date 08Dec05               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 237319             Date 13Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8305            Date 31Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221761             Date 01Apr04               *
      *                 TDA006             Date 23Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15088A - A srious Midas Error occurs if Ordering Customer *
      *              is specified with '/'.                           *
      *  BUG14880 - A serious Midas Error if Ordering Customer        *
      *             is an IBAN                                        *
      *  246723 - Settlement amount was defaulted incorrectly for     *
      *           a cross currency FT trans if a Spread Set is        *
      *           entered.                                            *
      *  248174 - Default payment charges with Customer Group Code    *
      *           as one of criteria only takes effect and defaulted  *
      *           during insert if the customer used has Retail       *
      *           Customer Group set to '1'. Apparently, this flag    *
      *           has no relation with FT payment charges so has to   *
      *           be removed.                                         *
      *  246583 - Incorrect default charges being used from wrong     *
      *           grouping code.                                      *
      *  BUG14143 - Database error in AOACCTV1 when nostro account    *
      *             is inputted in sender's correspondents            *
      *  BUG12705 - Error in ordering customer       (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG6864- Nostro number is not correctly retrieved from Tmp18 *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  237319 - Ordering Bank Customer processing causing database  *
      *           error 3. Use MOVEL instead of MOVE so that data is  *
      *           not lost.                                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8305- FX spread set should be blank if pay and settlement *
      *           currencies are the same                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  TDA006 - Use Tmp18 to make sure correct a/c with bank field  *
      *           is used.                                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * FT Payment Charge Definition
     FFTPCHGL0  IF   E           K DISK    INFSR(*PSSR)

      * FT Payment Charge Defaults
     FFTPYCGL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL0)
      * FT Payment Charge Defaults
     FFTPYCGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL1)

      * FT Payment Charge Defaults
     FFTPYCGL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL2)

      * FT Payment Charge Defaults
     FFTPYCGL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL3)

      * FT Payment Charge Defaults
     FFTPYCGL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL4)

      * FT Payment Charge Defaults
     FFTPYCGL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL5)

      * FT Payment Charge Defaults
     FFTPYCGL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL6)

      * FT Payment Charge Defaults
     FFTPYCGL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL7)

      * FT Payment Charge Defaults
     FFTPYCGL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL8)

      * FT Payment Charge Defaults
     FFTPYCGL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGL9)

      * FT Payment Charge Defaults
     FFTPYCGLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGLA)

      * FT Payment Charge Defaults
     FFTPYCGLB  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(FTPYCGD0:PYCGLB)

      * FT Payment Charge Defaults for STP
     FMEGNCRL1  IF   E           K DISK    INFSR(*PSSR)

      * SD Customer details file
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

      * Customer grouping codes
     FSDCGRPL0  IF   E           K DISK    INFSR(*PSSR)

      * Customer Marketing Groups                                                             246583
     FSDCMRKL1  IF   E           K DISK    INFSR(*PSSR)                                       246583
                                                                                              246583
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *       96  Chain                                               *                       246583
      *       97  Reade                                               *
      *       98  Chain                                               *
      *       99  Chain                                               *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------

      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

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

      **  Charge on each tier
     D TierCharge      S             13    DIM(11)

      **  Chargeable Amount on each tier
     D TierAmount      S             13    DIM(11)

      ** Array to hold customer 1 default codes
     D Cus1_dft        S              5    DIM(20)

      ** Array to hold customer 2 default codes
     D Cus2_dft        S              5    DIM(20)

      ** Array to hold STP default codes
     D CusS_dft        S              5    DIM(20)

      * Nostro DataStructure
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** External DS for Customer details
     D Accnt         E DS                  EXTNAME(ACCNTAB)  Prefix(E_)

      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Funds Transfer ICD
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for payment charge defaults
     D FTPYCG        E DS                  EXTNAME(FTPYCGPD)

      ** External data structure for STP payment charge defaults
     D MEGNCR        E DS                  EXTNAME(MEGNCRPD)

     **  Currency details from SDGELRPD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Outgoing Payments file/extension file
     D OutPay        E DS                  EXTNAME(OTPAYDD)  PREFIX(O_)
     D OtPayEx       E DS                  EXTNAME(OTPAYXPD) PREFIX(O_)

      ** Incoming Payments file/extension file
     D InPay         E DS                  EXTNAME(INPAYDD)  PREFIX(I_)
     D InPayEx       E DS                  EXTNAME(INPAYXPD) PREFIX(I_)

      ** Cheques for Collection files
     D CqCoD         E DS                  EXTNAME(CQCODDD)  PREFIX(B_)
     D CqCoC         E DS                  EXTNAME(CQCOCDD)  PREFIX(A_)

      ** Cheques to be Paid files
     D CqPaC         E DS                  EXTNAME(CQPACDD)  PREFIX(C_)
     D CqPaD         E DS                  EXTNAME(CQPADDD)  PREFIX(D_)

      ** Request for Transfer files
     D FT101H        E DS                  EXTNAME(FT101HPD) PREFIX(H1)
     D FT101D        E DS                  EXTNAME(FT101DPD) PREFIX(D1)

      ** Customer Credit Transfer files
     D FT102H        E DS                  EXTNAME(FT102HPD) PREFIX(H2)
     D FT102D        E DS                  EXTNAME(FT102DPD) PREFIX(D2)

      ** For IBAN customer number calculations
     D P@ACCN        E DS                  EXTNAME(ACCNTAB) PREFIX(IB)
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120

      ** For moving charges from file to array for Manual processing
     DCodesM           DS
     D  W_ArrayM              60    159

      ** For moving charges from file to array for STP processing
     DCodesS           DS
     D  W_ArrayS             169    268

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Tmp12           S             12
     D Tmp18           S             18                                                       TDA006
     D CNum35          S             35
     D WCustNo         S                   Like(BBCUST)

      ** Transaction being charged - Main details
      **                           - Extension/secondary details

     D P_TransDet      S           3000A
     D P_TransExt      S           3000A

      ** Entry parameters
     D P_TransType     S              2A
     D P_Procmthd      S              1A
     D P_MessType      S              3A
     D P_SetNum        S              3A
      *                                                                                       CFT120
      ** Parm list for callb to FT000981                                                      CFT120
      *                                                                                       CFT120
     D P_ChgDRCcy      S              3A                                                      CFT120

      ** Parm list for callb to FT000982
     D P_SpreadCde     S              5A
     D P_PayCcy        S                   Like(BJCYCD)
     D P_SettCcy       S                   Like(BJCYCD)
     D P_ExRate        S                   Like(A6SPRT)
     D P_STP           S              1A

      ** Parm list for callb to FT000983
     D P_OffsetCde     S              5A
     D P_SettDate      S              6A
     D P_PayDate       S                   Like(P_SettDate)

      ** Work fields used by ZEDIT
     D ZFIELD          S             16A
     D ZADEC           S              1P 0

      ** Work fields used by ZXRATE
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZRATEX          S             13P 8
     D ZMDIX           S              1A

      ** Work fields
     D Cus_12B         S              1A
     D***Cus_Grp       S S            1A1A                                                    248174
     D W_BNCT          S                   LIKE(I_BNCT)
     D W_BNC1          S                   LIKE(I_BNC1)
L011 D P               S              3P 0
     D X               S              2P 0
     D Y               S              2P 0
     D Z               S              2P 0
     D CusKey1         S                   LIKE(CUSTOM)
     D CusKey2         S                   LIKE(CUSTOM)

      ** Klist fields
     D K_Branch        S                   LIKE(BRANCH)
     D K_Custom        S                   LIKE(CUSTOM)
     D K_CustNum       S                   LIKE(BBCUST)
     D K_Currcy        S                   LIKE(CURRCY)
     D K_Trntyp        S                   LIKE(TRNTYP)
     D K_Trsbty        S                   LIKE(TRSBTY)
     D K_Csgrcd        S                   LIKE(CSGRCD)

     D K_D6snbr        S                   LIKE(D6SNBR)

     D K_Gnmtpy        S                   LIKE(GNMTPY)
     D K_Gnmset        S                   LIKE(GNMSET)
     D K_Gnpytp        S                   LIKE(GNPYTP)

      ** Fields from transaction
     D PayAmt          S             13P 0
     D PayCcy          S              3A
     D ChgCcy          S              3A
     D ChgExch         S             13P 8
     D STP             S              1A
     D Levied          S                   Like(ChgCcy)

     D BaseCcyDP       S                   LIKE(A6NBDP)
     D  BaseCcy        S                   Like(BJCYCD)

     D RetCode982      S                   Like(RetCodeIn)
     D RetCode980      S                   Like(RetCodeIn)

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

      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  MBIN                  13     13

      * Work currency
     D Acc_Ccy         S                   Like(O_PCCY)
     D Acc_Ccy1        S                   Like(O_PCCY)
     D Acc_Ccy2        S                   Like(O_PCCY)
     D Acc_Cus         S              1  0

      * Location Fields
     D SettDateLoc     S              3
     D PayDateLoc      S              3


     D P_SettAmt       S                   Like(O_SMAM)
     D P_ChargesDR     S                   Like(O_CDRO)
     D P_ADDC          S                   Like(O_ADDC)

     D Euro            S                   Like(BkEuro)
     D SettIn          S                   Like(A6INCY)
     D PayIn           S                   Like(A6INCY)
                                                                                              246583
     D ChkGrp          S                   Like(D7GPC1)                                       246583
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

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Move entry records to correct data structure for transaction and
      ** work out if customer is 1,2 or(B)oth for default charges.

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EXSR      In_Pay

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EXSR      Out_Pay

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EXSR      In_CCT

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EXSR      Out_CCT

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EXSR      In_ReT

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EXSR      Out_ReT

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EXSR      Ch_Paid

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EXSR      Ch_Collect

     C                   ENDSL

      ** Calculate the exchange rate between charges ccy and
      **  settlement currency (OP), pay ccy (IN).
     C                   Exsr      CalChgXRate


      ** Get customer part of key for access to default charges file.

     C                   EXSR      Key_Cust

      ** Get rest of key fields for access to default charges file.

     C                   EXSR      Key_Rest

      ** Get default charges for Manual.

     C                   EXSR      Dft_Manual

      ** Get default charges for STP.

     C                   IF        P_ProcMthd = 'S'
     C                   EXSR      Dft_STP
     C                   ENDIF

      ** Work out charges to use from customer 1 2 or STP

     C                   EXSR      Dft_Charges

      ** Calculate charges

     C                   EXSR      Charges

      ** Reset Entry parms with data structure data

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      P_TransDet = InPay
     C                   EVAL      P_TransExt = InPayEx

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      P_TransDet = OutPay
     C                   EVAL      P_TransExt = OtPayEx

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      P_TransDet = FT102H
     C                   EVAL      P_TransExt = FT102D

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      P_TransDet = FT102H
     C                   EVAL      P_TransExt = FT102D

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      P_TransDet = FT101H
     C                   EVAL      P_TransExt = FT101D

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      P_TransDet = FT101H
     C                   EVAL      P_TransExt = FT101D

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      P_TransDet = CqPaC
     C                   EVAL      P_TransExt = CqPaD

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      P_TransDet = CqCoD
     C                   EVAL      P_TransExt = CqCoC

     C                   ENDSL
      ** End Program
     C                   EVAL      *Inlr = *On

     C                   RETURN

      *****************************************************************
      *                                                               *
      * In_Pay - Incoming payments                                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    ******
     C     In_Pay        BEGSR
      *    ******

      ** Move input data to data structures
     C                   EVAL      InPay = P_TransDet
     C                   EVAL      InPayEx = P_TransExt

     C                   Eval      P_ChargesDR = I_CDRO
     C                   Eval      P_ADDC = I_ADDC
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = I_INCDRC                                      CFT120
     C                   ENDIF                                                                CFT120

      ** Work out if customer 1,2 or (B)oth

     C                   SELECT

     C                   WHEN      Intrcd = '1'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and I_ADDC = 'A'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and I_ADDC = 'D'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '3' and I_ADDC = 'A'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '3' and I_ADDC = 'D'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '4' and I_ADDC = 'A'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '4' and I_ADDC = 'D'
     C                   EVAL      Cus_12B = '1'

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Out_Pay - Outgoing payments                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    *******
     C     Out_Pay       BEGSR
      *    *******

      ** Move input data to data structures
     C                   EVAL      OutPay = P_TransDet
     C                   EVAL      OtPayEx = P_TransExt

     C                   Eval      P_ChargesDR = O_CDRO
     C                   Eval      P_ADDC = O_ADDC
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = O_OPCDRC                                      CFT120
     C                   ENDIF                                                                CFT120

      ** Work out if customer 1,2 or B)oth

     C                   SELECT

     C                   WHEN      Ottrcd = '1'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Ottrcd = '2' and O_ADDC = 'A'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Ottrcd = '2' and O_ADDC = 'D'
     C                   EVAL      Cus_12B = '1'

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * In_CCT - Incoming customer credit transfer                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    ******
     C     In_CCT        BEGSR
      *    ******

      ** Move input data to data structures
     C                   EVAL      FT102H = P_TransDet
     C                   EVAL      FT102D = P_TransExt

      ** Work out if customer 1,2 or(B)oth

     C                   SELECT

     C                   WHEN      Intrcd = '1'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and H2CCTCHG = 'OUR'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and D2CCYCHG = 'OUR'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and H2CCTCHG = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and D2CCYCHG = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and H2CCTCHG = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and D2CCYCHG = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '3' and H2CCTCHG = 'OUR'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '3' and D2CCYCHG = 'OUR'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '3' and H2CCTCHG = 'BEN'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '3' and D2CCYCHG = 'BEN'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '3' and H2CCTCHG = 'SHA'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '3' and D2CCYCHG = 'SHA'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '4' and H2CCTCHG = 'OUR'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '4' and D2CCYCHG = 'OUR'
     C                   EVAL      Cus_12B = 'B'

     C                   WHEN      Intrcd = '4' and H2CCTCHG = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '4' and D2CCYCHG = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '4' and H2CCTCHG = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '4' and D2CCYCHG = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Out_CCT - Outgoing customer credit transfer                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    *******
     C     Out_CCT       BEGSR
      *    *******

      ** Move input data to data structures
     C                   EVAL      FT102H = P_TransDet
     C                   EVAL      FT102D = P_TransExt

      ** Work out if customer 1,2 or(B)oth

     C                   SELECT

     C                   WHEN      Ottrcd = '1'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Ottrcd = '2' and H2CCTCHG = 'OUR'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Ottrcd = '2' and D2CCYCHG = 'OUR'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Ottrcd = '2' and H2CCTCHG = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Ottrcd = '2' and D2CCYCHG = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Ottrcd = '2' and H2CCTCHG = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Ottrcd = '2' and D2CCYCHG = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * In_Ret - Incoming request for transfer                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    ******
     C     In_Ret        BEGSR
      *    ******

      ** Move input data to data structures
     C                   EVAL      FT101H = P_TransDet
     C                   EVAL      FT101D = P_TransExt

      ** Work out if customer 1,2 or (B)oth

     C                   SELECT

     C                   WHEN      Intrcd = '1'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and D1TDCHGS = 'OUR'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and D1TDCHGS = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '2' and D1TDCHGS = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '3' and D1TDCHGS = 'OUR'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '3' and D1TDCHGS = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '3' and D1TDCHGS = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '4' and D1TDCHGS = 'OUR'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '4' and D1TDCHGS = 'SHA'
     C                   EVAL      Cus_12B = '1'

     C                   WHEN      Intrcd = '4' and D1TDCHGS = 'BEN'
     C                   EVAL      Cus_12B = '1'

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Out_Ret - Outgoing request for transfer                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    *******
     C     Out_Ret       BEGSR
      *    *******

      ** Move input data to data structures

     C                   EVAL      FT101H = P_TransDet
     C                   EVAL      FT101D = P_TransExt

      ** Work out if customer 1,2 or (B)oth

     C                   EVAL      Cus_12B = '1'

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Ch_Paid - Cheques to be paid                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    *******
     C     Ch_Paid       BEGSR
      *    *******

      ** Move input data to data structures

     C                   EVAL      CqPaC = P_TransDet
     C                   EVAL      CqPaD = P_TransExt

     C                   EVAL      Cus_12B = '1'

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Ch_Collect - Cheques to be collected                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    **********
     C     Ch_Collect    BEGSR
      *    **********

      ** Move input data to data structures

     C                   EVAL      CqCoD = P_TransDet
     C                   EVAL      CqCoC = P_TransExt

     C                   EVAL      Cus_12B = '1'

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Key_Cust - Work out customer for getting default charge codes *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: INcust OPcust BIcust BOcust RIcust ROcust CPcust       *
      *        CCcust                                                 *
      *                                                               *
      *****************************************************************

      *    ********
     C     Key_Cust      BEGSR
      *    ********

     C                   EVAL      CusKey1 = *blanks
     C                   EVAL      CusKey2 = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EXSR      INcust

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EXSR      OPcust

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EXSR      BIcust

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EXSR      BOcust

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EXSR      RIcust

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EXSR      ROcust

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EXSR      CPcust

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EXSR      CCcust

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * INcust - Work out customer for incoming payments              *
      *                                                               *
      * Called by: Key_Cust                                           *
      *                                                               *
      * Calls: Customer                                               *
      *                                                               *
      *****************************************************************

      *    ******
     C     INcust        BEGSR
      *    ******

     C                   SELECT

     C                   WHEN      Intrcd = '1'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = I_ACBT

     C                   If        W_BNCT = 'N'
     C**********         Move      I_ACBK        W_BNC1                                       237319
     C                   Movel     I_ACBK        W_BNC1                                       237319
     C                   Else
     C                   EVAL      W_BNC1 = I_ACBK
     C                   Endif

      ** Account with bank requires pay ccy
     C                   Eval      Acc_Ccy1 = I_PCCY
      ** A/C with bank
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_BNCT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_BNC1        @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_BNC1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ENDIF

      ** Beneficiary requires pay ccy
     C                   Eval      Acc_Ccy1 = I_PCCY
      ** Benificiary
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '2' and I_ADDC = 'A'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = I_INTRIT
     C                   EVAL      W_BNC1 = I_INTRIB
     C                   Eval      Acc_Ccy1 = I_SMCY
      ** Third reimbursement
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_INRCRT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_INRCO1      @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_INRCO1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_INRCO1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_INRCO1
     C                   ENDIF

      ** Receivers correspondent requires settle ccy
     C                   Eval      Acc_Ccy1 = I_SMCY
      ** Receivers correspondent
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_SNTP
     C                   EVAL      W_BNC1 = I_SND1
      ** Sender requires settle ccy
     C                   Eval      Acc_Ccy1 = I_SMCY
      ** Sender
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '2' and I_ADDC = 'D'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = I_ACBT

     C                   If        W_BNCT = 'N'
     C**********         Move      I_ACBK        W_BNC1                                       237319
     C                   Movel     I_ACBK        W_BNC1                                       237319
     C                   Else
     C                   EVAL      W_BNC1 = I_ACBK
     C                   Endif

      ** Account with bank requires pay ccy
     C                   Eval      Acc_Ccy1 = I_PCCY
      ** A/C with bank
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_BNCT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_BNC1        @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_BNC1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ENDIF

      ** Beneficiary requires pay ccy
     C                   Eval      Acc_Ccy1 = I_PCCY
      ** Beneficiary
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '3' and I_ADDC = 'A'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = I_INTRIT
     C                   EVAL      W_BNC1 = I_INTRIB
     C                   Eval      Acc_Ccy1 = I_SMCY
      ** Third reimbursement institution
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_INRCRT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_INRCO1      @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_INRCO1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_INRCO1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_INRCO1
     C                   ENDIF

     C                   Eval      Acc_Ccy1 = I_SMCY
      ** Receivers correspondents
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_SNTP
     C                   EVAL      W_BNC1 = I_SND1
     C                   Eval      Acc_Ccy1 = I_SMCY
      ** Sender
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno
      *

      ** Customer key 2
     C                   EVAL      Acc_Cus = 2
     C                   EVAL      W_BNCT = I_ACBT

     C                   If        W_BNCT = 'N'
     C**********         Move      I_ACBK        W_BNC1                                       237319
     C                   Movel     I_ACBK        W_BNC1                                       237319
     C                   Else
     C                   EVAL      W_BNC1 = I_ACBK
     C                   Endif

     C                   Eval      Acc_Ccy2 = I_PCCY
      ** A/C with bank
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_BNCT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_BNC1        @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_BNC1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ENDIF

     C                   Eval      Acc_Ccy2 = I_PCCY
      ** Beneficiary
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey2 = Wcustno
      *

     C                   WHEN      Intrcd = '3' and I_ADDC = 'D'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = I_ACBT

     C                   If        W_BNCT = 'N'
     C**********         Move      I_ACBK        W_BNC1                                       237319
     C                   Movel     I_ACBK        W_BNC1                                       237319
     C                   Else
     C                   EVAL      W_BNC1 = I_ACBK
     C                   Endif

     C                   Eval      Acc_Ccy1 = I_PCCY
      ** A/C with bank
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_BNCT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_BNC1        @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_BNC1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ENDIF

     C                   Eval      Acc_Ccy1 = I_PCCY
      ** Beneficiary
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '4' and I_ADDC = 'A'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = I_ACBT

     C                   If        W_BNCT = 'N'
     C**********         Move      I_ACBK        W_BNC1                                       237319
     C                   Movel     I_ACBK        W_BNC1                                       237319
     C                   Else
     C                   EVAL      W_BNC1 = I_ACBK
     C                   Endif

     C                   Eval      Acc_Ccy1 = I_PCCY
      ** A/C with bank
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_BNCT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_BNC1        @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_BNC1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ENDIF

     C                   Eval      Acc_Ccy1 = I_PCCY
      ** Beneficiary
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno
      *

      ** Customer key 2
     C                   EVAL      Acc_Cus = 2
     C                   EVAL      W_BNCT = I_INTRIT
     C                   EVAL      W_BNC1 = I_INTRIB
     C                   Eval      Acc_Ccy2 = I_SMCY
      ** Third reimbursement institution
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_INRCRT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_INRCO1      @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_INRCO1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_INRCO1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_INRCO1
     C                   ENDIF

     C                   Eval      Acc_Ccy2 = I_SMCY
      ** Receivers correspondents
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_SNTP
     C                   EVAL      W_BNC1 = I_SND1
     C                   Eval      Acc_Ccy2 = I_SMCY
      ** Sender
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey2 = Wcustno

     C                   WHEN      Intrcd = '4' and I_ADDC = 'D'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = I_ACBT

     C                   If        W_BNCT = 'N'
     C**********         Move      I_ACBK        W_BNC1                                       237319
     C                   MoveL     I_ACBK        W_BNC1                                       237319
     C                   Else
     C                   EVAL      W_BNC1 = I_ACBK
     C                   Endif

     C                   Eval      Acc_Ccy1 = I_PCCY
      ** A/C with bank
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = I_BNCT

      ** IBAN
     C                   IF        W_BNCT = 'I'
     C     '/'           SCAN      I_BNC1        @P                3 0

     C     @P            IFNE      1
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ELSE
     C                   EVAL      W_BNC1 = %SUBST(I_BNC1:2:34)
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W_BNC1 = I_BNC1
     C                   ENDIF

     C                   Eval      Acc_Ccy1 = I_PCCY
      ** Beneficiary
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * OPcust - Work out customer for outgoing payments              *
      *                                                               *
      * Called by: Key_Cust                                           *
      *                                                               *
      * Calls: Customer                                               *
      *                                                               *
      *****************************************************************

      *    ******
     C     OPcust        BEGSR
      *    ******

     C                   SELECT

     C                   WHEN      Ottrcd = '1'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = O_ORBT

     C                   If        W_BNCT = 'N'
     C**********         Move      O_ORBK        W_BNC1                                       237319
     C                   Movel     O_ORBK        W_BNC1                                       237319
     C                   Else
     C                   If        W_BNCT = 'R'
     C                   MOVEL     O_ORBK        TMP10            10
     C                   MOVEL     TMP10         W_BNC1
     C                   Else
     C                   Movel     O_ORBK        W_BNC1
     C                   Endif
     C                   Endif

      ** Ordering bank requires settle ccy
     C                   Eval      Acc_Ccy1 = O_SMCY
      ** Ordering bank
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
      ** Ordering customer requires settle ccy
     C                   Eval      Acc_Ccy1 = O_SMCY
     C                   EVAL      W_BNCT = O_ORCT

     C                   If        W_BNCT = 'N'
     C**********         Move      O_ORC1        W_BNC1                                       237319
     C                   Movel     O_ORC1        W_BNC1                                       237319
     C                   Else
     C                   EVAL      W_BNC1 = O_ORC1
     C                   Endif
      ** Ordering customer
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Ottrcd = '2' and O_ADDC = 'A'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = O_ORBT

     C                   If        W_BNCT = 'N'
     C**********         Move      O_ORBK        W_BNC1                                       237319
     C                   Movel     O_ORBK        W_BNC1                                       237319
     C                   Else
     C                   If        W_BNCT = 'R'
     C                   MOVEL     O_ORBK        TMP10            10
     C                   MOVEL     TMP10         W_BNC1
     C                   Else
     C                   Movel     O_ORBK        W_BNC1
     C                   Endif
     C                   Endif
      ** Ordering bank requires settle ccy
     C                   Eval      Acc_Ccy1 = O_SMCY
      ** Ordering bank
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = O_ORCT

     C                   If        W_BNCT = 'N'
     C**********         Move      O_ORC1        W_BNC1                                       237319
     C                   Movel     O_ORC1        W_BNC1                                       237319
     C                   Else
     C                   EVAL      W_BNC1 = O_ORC1
     C                   Endif
      ** Ordering customer requires settle ccy
     C                   Eval      Acc_Ccy1 = O_SMCY
      ** Ordering customer
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Ottrcd = '2' and O_ADDC = 'D'
      ** Customer key 1
     C                   EVAL      Acc_Cus = 1
     C                   EVAL      W_BNCT = O_SNCT
     C                   MOVEL     O_SNCO        Tmp12
     C**********         Move      Tmp12         W_BNC1                                       237319
     C                   Movel     Tmp12         W_BNC1                                       237319
      ** Senders correspondent requires pay ccy
     C                   Eval      Acc_Ccy1 = O_PCCY
      ** Senders correspondent
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = O_DSTT
     C                   EVAL      W_BNC1 = O_DST1
      ** Destination requires pay ccy
     C                   Eval      Acc_Ccy1 = O_PCCY
      ** Destination
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * BIcust - Work out customer for incoming customer credit       *
      *          transfer                                             *
      *                                                               *
      * Called by: Key_Cust                                           *
      *                                                               *
      * Calls: Customer                                               *
      *                                                               *
      *****************************************************************

      *    ******
     C     BIcust        BEGSR
      *    ******

     C                   SELECT

     C                   WHEN      Intrcd = '1'
     C                   EVAL      W_BNCT = D2AWITP
     C                   EVAL      W_BNC1 = D2ACCI35
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D2BENTTD
     C                   EVAL      W_BNC1 = D2BENF1
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '2'
     C                   IF        H2CCTCHG = 'OUR' or
     C                             D2CCYCHG = 'OUR'
     C                   EVAL      W_BNCT = H2RCVTYP
     C                   EVAL      W_BNC1 = H2RCVCOR
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2SNDTYP
     C                   EVAL      W_BNC1 = H2SNDCOR
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2SINSTT
     C                   EVAL      W_BNC1 = H2SINST
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey1 = Wcustno
     C                   ENDIF

     C                   WHEN      Intrcd = '2'
     C                   IF        H2CCTCHG = 'BEN' or
     C                             D2CCYCHG = 'BEN' or
     C                             H2CCTCHG = 'SHA' or
     C                             D2CCYCHG = 'SHA'
     C                   EVAL      W_BNCT = D2AWITP
     C                   EVAL      W_BNC1 = D2ACCI35
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D2BENTTD
     C                   EVAL      W_BNC1 = D2BENF1
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey1 = Wcustno
     C                   ENDIF

     C                   WHEN      Intrcd = '3'
     C                   IF        H2CCTCHG = 'OUR' or
     C                             D2CCYCHG = 'OUR'
     C                   EVAL      W_BNCT = D2AWITP
     C                   EVAL      W_BNC1 = D2ACCI35
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D2BENTTD
     C                   EVAL      W_BNC1 = D2BENF1
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey1 = Wcustno

     C                   EVAL      W_BNCT = H2RCVTYP
     C                   EVAL      W_BNC1 = H2RCVCOR
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2SNDTYP
     C                   EVAL      W_BNC1 = H2SNDCOR
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2SINSTT
     C                   EVAL      W_BNC1 = H2SINST
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey2 = Wcustno
     C                   ENDIF

     C                   WHEN      Intrcd = '3'
     C                   IF        H2CCTCHG = 'BEN' or
     C                             D2CCYCHG = 'BEN' or
     C                             H2CCTCHG = 'SHA' or
     C                             D2CCYCHG = 'SHA'
     C                   EVAL      W_BNCT = D2AWITP
     C                   EVAL      W_BNC1 = D2ACCI35
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D2BENTTD
     C                   EVAL      W_BNC1 = D2BENF1
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey1 = Wcustno
     C                   EVAL      CusKey2 = Wcustno
     C                   ENDIF

     C                   WHEN      Intrcd = '4'
     C                   IF        H2CCTCHG = 'OUR' or
     C                             D2CCYCHG = 'OUR'
     C                   EVAL      W_BNCT = H2RCVTYP
     C                   EVAL      W_BNC1 = H2RCVCOR
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2SNDTYP
     C                   EVAL      W_BNC1 = H2SNDCOR
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2SINSTT
     C                   EVAL      W_BNC1 = H2SINST
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey1 = Wcustno

     C                   EVAL      W_BNCT = D2AWITP
     C                   EVAL      W_BNC1 = D2ACCI35
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D2BENTTD
     C                   EVAL      W_BNC1 = D2BENF1
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey2 = Wcustno
     C                   ENDIF

     C                   WHEN      Intrcd = '4'
     C                   IF        H2CCTCHG = 'BEN' or
     C                             D2CCYCHG = 'BEN' or
     C                             H2CCTCHG = 'SHA' or
     C                             D2CCYCHG = 'SHA'
     C                   EVAL      W_BNCT = D2AWITP
     C                   EVAL      W_BNC1 = D2ACCI35
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D2BENTTD
     C                   EVAL      W_BNC1 = D2BENF1
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey1 = Wcustno
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * BOcust - Work out customer for outgoing customer credit       *
      *          transfer                                             *
      *                                                               *
      * Called by: Key_Cust                                           *
      *                                                               *
      * Calls: Customer                                               *
      *                                                               *
      *****************************************************************

      *    ******
     C     BOcust        BEGSR
      *    ******

     C                   SELECT

     C                   WHEN      Ottrcd = '1'
     C                   EVAL      W_BNCT = H2ORDITP
     C                   EVAL      W_BNC1 = H2OINST3
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2CUSTTH
     C                   EVAL      W_BNC1 = H2TOCUS1
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Ottrcd = '2'
     C                   IF        H2CCTCHG = 'OUR' or
     C                             D2CCYCHG = 'OUR' or
     C                             H2CCTCHG = 'SHA' or
     C                             D2CCYCHG = 'SHA'
     C                   EVAL      W_BNCT = H2ORDITP
     C                   EVAL      W_BNC1 = H2OINST3
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2CUSTTH
     C                   EVAL      W_BNC1 = H2TOCUS1
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey1 = Wcustno
     C                   ENDIF

     C                   WHEN      Ottrcd = '2'
     C                   IF        H2CCTCHG = 'BEN' or
     C                             D2CCYCHG = 'BEN'
     C                   EVAL      W_BNCT = H2RCVTYP
     C                   EVAL      W_BNC1 = H2RCVCOR
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2SNDTYP
     C                   EVAL      W_BNC1 = H2SNDCOR
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = H2DSTTYP
     C                   EVAL      W_BNC1 = H2CCTDST
     C                   EXSR      Customer
     C                   ENDIF
     C                   EVAL      CusKey1 = Wcustno
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * RIcust - Work out customer for incoming request for transfer  *
      *                                                               *
      * Called by: Key_Cust                                           *
      *                                                               *
      * Calls: Customer                                               *
      *                                                               *
      *****************************************************************

      *    ******
     C     RIcust        BEGSR
      *    ******

     C                   SELECT

     C                   WHEN      Intrcd = '1'
     C                   EVAL      W_BNCT = D1INTTTP
     C                   EVAL      W_BNC1 = D1TINST1
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D1AWITTP
     C                   EVAL      W_BNC1 = D1TACA35
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D1BENTTP
     C                   EVAL      W_BNC1 = D1TBNA35
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '2'
     C                   IF        D1TDCHGS = 'OUR' or
     C                             D1TDCHGS = 'SHA'
     C                   EVAL      W_BNCT = H1CUSTTP
     C                   EVAL      W_BNC1 = H1HOCUS1
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        Wcustno = *blanks
     C                   EVAL      W_BNCT = D1DCUSTP
     C                   EVAL      W_BNC1 = D1TOCUS1
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '2'
     C                   IF        D1TDCHGS = 'BEN'
     C                   EVAL      W_BNCT = D1INTTTP
     C                   EVAL      W_BNC1 = D1TINST1
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D1AWITTP
     C                   EVAL      W_BNC1 = D1TACA35
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D1BENTTP
     C                   EVAL      W_BNC1 = D1TBNA35
     C                   EXSR      Customer
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '3'
     C                   IF        D1TDCHGS = 'OUR' or
     C                             D1TDCHGS = 'SHA'
     C                   EVAL      W_BNCT = H1CUSTTP
     C                   EVAL      W_BNC1 = H1HOCUS1
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        Wcustno = *blanks
     C                   EVAL      W_BNCT = D1DCUSTP
     C                   EVAL      W_BNC1 = D1TOCUS1
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '3'
     C                   IF        D1TDCHGS = 'BEN'
     C                   EVAL      W_BNCT = D1INTTTP
     C                   EVAL      W_BNC1 = D1TINST1
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D1AWITTP
     C                   EVAL      W_BNC1 = D1TACA35
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D1BENTTP
     C                   EVAL      W_BNC1 = D1TBNA35
     C                   EXSR      Customer
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '4'
     C                   IF        D1TDCHGS = 'OUR' or
     C                             D1TDCHGS = 'SHA'
     C                   EVAL      W_BNCT = H1CUSTTP
     C                   EVAL      W_BNC1 = H1HOCUS1
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        Wcustno = *blanks
     C                   EVAL      W_BNCT = D1DCUSTP
     C                   EVAL      W_BNC1 = D1TOCUS1
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   WHEN      Intrcd = '4'
     C                   IF        D1TDCHGS = 'BEN'
     C                   EVAL      W_BNCT = D1INTTTP
     C                   EVAL      W_BNC1 = D1TINST1
     C                   EXSR      Customer
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D1AWITTP
     C                   EVAL      W_BNC1 = D1TACA35
     C                   EXSR      Customer
     C                   ENDIF
     C                   IF        WCustno = *blanks
     C                   EVAL      W_BNCT = D1BENTTP
     C                   EVAL      W_BNC1 = D1TBNA35
     C                   EXSR      Customer
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * ROcust - Work out customer for outgoing request for transfer  *
      *                                                               *
      * Called by: Key_Cust                                           *
      *                                                               *
      * Calls: Customer                                               *
      *                                                               *
      *****************************************************************

      *    ******
     C     ROcust        BEGSR
      *    ******

     C                   EVAL      W_BNCT = 'G'
     C                   EVAL      W_BNC1 = H1HANDAC
     C                   EXSR      Customer
     C                   IF        Wcustno = *blanks
     C                   EVAL      W_BNCT = 'R'
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * CPcust - Work out customer for cheques to be paid             *
      *                                                               *
      * Called by: Key_Cust                                           *
      *                                                               *
      * Calls: Customer                                               *
      *                                                               *
      *****************************************************************

      *    ******
     C     CPcust        BEGSR
      *    ******

     C                   EVAL      W_BNCT = D_CDRT
     C                   MOVE      D_CDRO        W_BNC1
     C                   EXSR      Customer
     C                   IF        Wcustno = *blanks
     C                   EVAL      W_BNCT = D_DRPT
     C                   MOVE      D_DRPY        W_BNC1
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * CCcust - Work out customer for cheques to be collected        *
      *                                                               *
      * Called by: Key_Cust                                           *
      *                                                               *
      * Calls: Customer                                               *
      *                                                               *
      *****************************************************************

      *    ******
     C     CCcust        BEGSR
      *    ******

     C                   Eval      Acc_Ccy1 = B_Smcy

     C                   EVAL      W_BNCT = A_CDRT
     C                   MOVE      A_CDRO        W_BNC1
     C                   EXSR      Customer
     C                   IF        Wcustno = *blanks
     C                   EVAL      W_BNCT = A_CRPT
     C                   MOVE      A_CRPY        W_BNC1
     C                   EXSR      Customer
     C                   ENDIF

     C                   EVAL      CusKey1 = Wcustno

     C                   ENDSR

      *****************************************************************
      * CalChgXRate  - Calcualtes charges exchange rate               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     CalChgXRate   Begsr

     C                   Select

     C                   When      P_TransType = 'IN'
     C                   Eval      ChgCcy = I_INCHGC
     C                   Eval      FRMCCY = ChgCcy
     C                   Eval      ToCcy = I_PCCY

     C                   Select

     C***********        When      I_CDRO <> *Zeros                                           CSD027
     C                   When      I_CDRO <> *BLANKS                                          CSD027
     C                   Eval      ToCcy = BaseCcy
     C                   IF        I_INCDRC <> *BLANKS                                        CFT120
     C                             AND CFT120 = 'Y'                                           CFT120
     C                   EVAL      ToCcy = I_INCDRC                                           CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   When      I_ADDC = 'A'
     C                   Eval      ToCcy = I_SMCY
     C                   If        I_SND1 = 'CASHIER' AND
     C                             I_PCCY =BaseCcy
     C                   Eval      ToCcy = I_PCCY
     C                   EndIf
     C                   Other
     C                   Eval      ToCcy = I_PCCY
     C                   Endsl

     C                   When      P_TransType = 'OP'
     C                   Eval      ChgCcy = O_OPCHGC
     C                   Eval      FRMCCY = ChgCcy

     C                   Select
     C***********        When      O_CDRO <> *Zeros                                           CSD027
     C                   When      O_CDRO <> *BLANKS                                          CSD027
     C                   Eval      ToCcy = BaseCcy
     C                   IF        O_OPCDRC <> *BLANKS                                        CFT120
     C                             AND CFT120 = 'Y'                                           CFT120
     C                   EVAL      ToCcy = O_OPCDRC                                           CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   When      O_ADDC = 'A'
     C                   Eval      ToCcy = O_SMCY
     C                   Other
     C                   Eval      ToCcy = O_PCCY
     C                   Endsl

     C                   When      P_TransType = 'RI'
     C                   Eval      ChgCcy = D1M1CHGC
     C                   Eval      FRMCCY = ChgCcy
     C                   Eval      ToCcy = D1RCHCCY

     C                   When      P_TransType = 'RO'
     C                   Eval      ChgCcy = D1M1CHGC
     C                   Eval      FRMCCY = D1RCHCCY
     C                   Eval      ToCcy = H1HANDCY

      **  Put other Transaction types here.
     C                   Endsl

     C                   Exsr      Convert1

     C                   Eval      ChgExch  = CVTRAT

     C                   Eval      O_OpChRt = CVTRAT
     C                   Eval      I_INCHRT = CVTRAT
     C                   Eval      D1M1CHRT = CVTRAT



     C                   Endsr

      *****************************************************************
      * Customer - Works out customer key field                       *
      *                                                               *
      * Called by: INcust OPcust BIcust BOcust RIcust ROcust CPcust   *
      *            CCcust                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    ********
     C     Customer      BEGSR
      *    ********

     C                   EVAL      WCustNo = *blanks

      ** Set correct account currency depending on customer 1 or 2

     C                   SELECT

     C                   WHEN      Acc_Cus = 1
     C                   EVAL      Acc_Ccy = Acc_Ccy1

     C                   WHEN      Acc_Cus = 2
     C                   EVAL      Acc_Ccy = Acc_Ccy2

     C                   ENDSL

     C                   SELECT

     C                   WHEN      W_BNCT = 'C'  Or
     C                             W_BNCT = 'S'  Or
     C                             W_BNCT = 'R'  Or
     C                             W_BNCT = 'P'

      ** If it is a partial GL, convert it into a full GL for call
      ** of AOACCTV1
     C                   If        W_BNCT = 'P'
     C                   If        %SUBST(W_BNC1:1:1) = '/'                                BUG15088A
     C                   Eval      PType = %SUBST(W_BNC1:2:21)                             BUG15088A
     C                   Else                                                              BUG15088A
     C                   Movel     W_BNC1        PType
     C                   Endif                                                             BUG15088A

      ** If incoming or outgoing payment we need to set branch code
      ** if it is blank.
     C                   Select
     C                   When      P_TransType = 'IN'
     C                   If        PBrcd = *blanks
     C                   Eval      PBrcd = I_ACBB
     C                   Endif
     C                   When      P_TransType = 'OP'
     C                   If        PBrcd = *blanks
     C                   Eval      PBrcd = O_ORBB
     C                   Endif
     C                   Endsl

      ** If not multibranching, use single branch code form SDBANKPD

     C                   If        MBIN <> 'Y'
     C                   Movel     BJSBRC        GLBrcd
     C                   Else
     C                   Movel     PBrcd         GLBrcd
     C                   Endif

     C                   Movel     PCnum         GLCnum
     C                   Movel     PAcod         GLAcod
     C                   Movel     PAcsq         GLAcsq

      ** Outgoing Payments
      ** Set GLCycd depending on whether account is in debit
      ** or credit currency.

     C                   If        P_TRANSTYPE = 'OP'

     C                   SELECT

     C                   WHEN      Acc_Cus = 1
     C                   EVAL      GLCycd = Acc_Ccy1
     C                   WHEN      Acc_Cus = 2
     C                   EVAL      GLCycd = Acc_Ccy2
     C                   ENDSL

     C                   Endif

      ** Incoming Payments
      ** Set GLCycd depending on whether account is in debit
      ** or credit currency.

     C                   If        P_TRANSTYPE = 'IN'

     C                   SELECT

     C                   WHEN      Acc_Cus = 1
     C                   EVAL      GLCycd = Acc_Ccy1
     C                   WHEN      Acc_Cus = 2
     C                   EVAL      GLCycd = Acc_Ccy2
     C                   ENDSL

     C                   Endif

     C                   Movel     GLType        CNum35

     C                   Else

     C                   MOVEL     W_BNC1        CNum35
     C                   Endif

     C                   CALLB     'AOACCTV1'
     C                   PARM      '*DBERR'      @Rtcd
     C                   PARM      '*KEY'        @Optn
     C                   PARM                    CNum35
     C     Dssdy         PARM      *Blanks       Dssdy

     C                   SELECT
     C                   WHEN      @Optn = '*LEDGER'   or
     C                             @Optn = '*RETAIL'
     C                   EVAL      Accnt  = Dssdy
     C                   MOVEL     E_CNum        WCustNo


     C                   WHEN      @Optn = '*CUSTNO'   or
     C                             @Optn = '*SHNAME'
     C                   EVAL      SdCust = Dssdy
     C                   MOVEL     BBCUST        WCustNo


     C                   WHEN      @Optn = '*NOSTRO'
     C                   EVAL      SdNost = Dssdy
     C                   MOVEL     A7CUST        WCustNo

     C                   OTHER
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBKey  =  CNum35
     C                   EVAL      DBPgm  =  PSProcPgm
     C                   EVAL      DBase  =  1
     C                   EVAL      DBMod  =  PSProcMod
     C                   EVAL      DBProc =  'CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDSL

      ** Nostro
     C                   WHEN      W_BNCT = 'N' or W_BNCT = 'F'

     C                   SELECT
      ** Incoming payments
     C                   WHEN      P_TransType = 'IN' and W_BNCT = 'N'
     C**********         MOVE      W_BNC1        Tmp12                                        TDA006
     C**********         MOVE      W_BNC1        Tmp18                                 TDA006 237319
     C                   MOVEL     W_BNC1        Tmp18                                        237319
     C**********         EVAL      CNum35 = Acc_Ccy + %Subst(Tmp12:1:2)                       TDA006
     C                   EVAL      CNum35 = Acc_Ccy + %Subst(Tmp18:1:2)                       TDA006

     C                   WHEN      P_TransType = 'IN' and W_BNCT = 'F'
     C                   EVAL      CNum35 = W_BNC1

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP' and W_BNCT = 'N'
     C**********         MOVE      W_BNC1        Tmp12                                        TDA006
     C**********         MOVE      W_BNC1        Tmp18                                 TDA006 237319
     C                   MOVEL     W_BNC1        Tmp18                                        237319
     C                   If        Ottrcd = '2' and O_ADDC = 'D'                             BUG6864
     C                   If        %Subst(Tmp18:7:2) <> *blanks                             BUG14143
     C                   EVAL      CNum35 = Acc_Ccy + %Subst(Tmp18:7:2)                      BUG6864
     C                   Else                                                               BUG14143
     C                   EVAL      CNum35 = Acc_Ccy + %Subst(Tmp18:1:2)                     BUG14143
     C                   ENDIF                                                              BUG14143
     C                   Else                                                                BUG6864
     C**********         EVAL      CNum35 = Acc_Ccy + %Subst(Tmp12:1:2)                       TDA006
     C                   EVAL      CNum35 = Acc_Ccy + %Subst(Tmp18:1:2)                       TDA006
     C                   EndIf                                                               BUG6864

     C                   WHEN      P_TransType = 'OP' and W_BNCT = 'F'
     C                   EVAL      CNum35 = W_BNC1

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      CNum35 = W_BNC1

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      CNum35 = W_BNC1

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      CNum35 = W_BNC1

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      CNum35 = W_BNC1

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      CNum35 = W_BNC1

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C**********         MOVE      W_BNC1        Tmp12                                        TDA006
     C**********         MOVE      W_BNC1        Tmp18                                 TDA006 237319
     C                   MOVEL     W_BNC1        Tmp18                                        237319
     C**********         EVAL      CNum35 = Acc_Ccy + %Subst(Tmp12:1:2)                       TDA006
     C                   EVAL      CNum35 = Acc_Ccy + %Subst(Tmp18:1:2)                       TDA006

     C                   ENDSL


     C                   CALLB     'AOACCTV1'
     C                   PARM      '*DBERR'      @Rtcd
     C                   PARM      '*KEY'        @Optn
     C                   PARM                    CNum35
     C     Dssdy         PARM      *Blanks       Dssdy

     C                   SELECT
     C                   WHEN      @Optn  = '*NOSTRO'
     C                   EVAL      SDNOST = Dssdy
     C                   MOVEL     A7CUST        WCustNo

     C                   OTHER
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBKey  =  CNum35
     C                   EVAL      DBPgm  =  PSProcPgm
     C                   EVAL      DBase  =  2
     C                   EVAL      DBMod  =  PSProcMod
     C                   EVAL      DBProc =  'CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDSL

      ** IBAN
     C                   WHEN      W_BNCT = 'I'
      *
      ** Determine corresponding Midas account of IBAN account
      ** for Third Reimbursement Institution.
      *
     C                   MOVEL     W_BNC1        P@IBAN
     C                   MOVE      *BLANKS       DSSDY
                                                                                            BUG14880
     C                   IF        %SUBST(P@IBAN:1:1) = '/'                                 BUG14880
     C                   EVAL      P@IBAN = %SUBST(P@IBAN:2)                                BUG14880
     C                   ENDIF                                                              BUG14880

     C                   CALL      'AOIBANR4'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    P@IBAN           34
     C     P@ACCN        PARM                    DSSDY
      *
      ** Database error

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'AOIBANR4'    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     IBCNUM        WCustNo


      ** GL
     C                   WHEN      W_BNCT = 'G'
     C                   EVAL      WCustNo = %subst(W_BNC1:1:6)

     C                   WHEN      O_ORBT = 'P'
     C                   MOVE      O_ORBK        WCustNo

     C                   WHEN      O_ORBT = 'R'
     C**********         MOVEL     O_ORBK        CNum35                                       237319
     C                   MOVEL     O_ORBK        ##0010A          10                          237319
     C                   MOVEL(p)  ##0010A       CNum35                                       237319
     C                   CALLB     'AOACCTV1'
     C                   PARM      '*DBERR'      @Rtcd
     C                   PARM      '*KEY'        @Optn
     C                   PARM                    CNum35
     C     Dssdy         PARM      *Blanks       Dssdy

     C                   SELECT
     C                   WHEN      @Optn = '*RETAIL'
     C                   EVAL      Accnt  = Dssdy
     C                   MOVEL     E_CNum        WCustNo

     C                   OTHER
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBKey  =  CNum35
     C                   EVAL      DBPgm  =  PSProcPgm
     C                   EVAL      DBase  =  3
     C                   EVAL      DBMod  =  PSProcMod
     C                   EVAL      DBProc =  'CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDSL

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      * Key_Rest - Get rest of key fields for default charge access   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    ********
     C     Key_Rest      BEGSR
      *    ********


      ** Set correct account currency depending on customer 1 or 2

     C                   SELECT

     C                   WHEN      Acc_Cus = 1
     C                   EVAL      Acc_Ccy = Acc_Ccy1

     C                   WHEN      Acc_Cus = 2
     C                   EVAL      Acc_Ccy = Acc_Ccy2

     C                   ENDSL
      ** Get rest of possible key fields for access to default charges file

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      K_Branch = I_BRCA
     C                   EVAL      K_Currcy = I_SMCY
     C                   EVAL      K_Trntyp = P_TransType
     C                   EVAL      K_Trsbty = I_PYST

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      K_Branch = O_BRCA
     C                   EVAL      K_Currcy = O_PCCY
     C                   EVAL      K_Trntyp = P_TransType
     C                   EVAL      K_Trsbty = O_PYST

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      K_Branch = H2BRCA
     C                   EVAL      K_Currcy = D2PAYCCY
     C                   EVAL      K_Trntyp = P_TransType
     C                   EVAL      K_Trsbty = H2CCTTST

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      K_Branch = H2BRCA
     C                   EVAL      K_Currcy = D2PAYCCY
     C                   EVAL      K_Trntyp = P_TransType
     C                   EVAL      K_Trsbty = H2CCTTST

      ** Incoming request for transfer

     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      K_Branch = H1BRCA
     C                   EVAL      K_Currcy = D1PAYCCY
     C                   EVAL      K_Trntyp = P_TransType
     C                   EVAL      K_Trsbty = H1PYST

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      K_Branch = H1BRCA
     C                   EVAL      K_Currcy = D1PAYCCY
     C                   EVAL      K_Trntyp = P_TransType
     C                   EVAL      K_Trsbty = H1PYST

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      K_Branch = C_BRCA
     C                   EVAL      K_Currcy = C_PCCY
     C                   EVAL      K_Trntyp = P_TransType
     C                   EVAL      K_Trsbty = C_PYST

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      K_Branch = A_BRCA
     C                   EVAL      K_Currcy = A_CRCY
     C                   EVAL      K_Trntyp = P_TransType
     C                   EVAL      K_Trsbty = B_PYST

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      * Dft_Manual - Get default charge codes for Manual processing.  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    **********
     C     Dft_Manual    BEGSR
      *    **********

     C                   CLEAR                   Cus1_Dft
     C                   CLEAR                   Cus2_Dft

     C                   SELECT

      ** Customer 1
     C                   WHEN      Cus_12B = '1'
     C                   EVAL      X = 1
     C                   EVAL      Y = 1

      ** Customer 2
     C                   WHEN      Cus_12B = '2'
     C                   EVAL      X = 2
     C                   EVAL      Y = 2

      ** Both
     C                   WHEN      Cus_12B = 'B'
     C                   EVAL      X = 1
     C                   EVAL      Y = 2

     C                   ENDSL

     C     X             DO        Y             Z

     C                   SELECT
     C                   WHEN      Z = 1
     C                   EVAL      K_CustNum = Cuskey1
     C                   WHEN      Z = 2
     C                   EVAL      K_CustNum = Cuskey2
     C                   ENDSL

     C                   Eval      K_Custom = K_CustNum

     C     Kftpycgl0     CHAIN     PYCGL0                             99

     C                   IF        *In99 = *On
     C     Kftpycgl1     CHAIN     PYCGL1                             99
     C                   ENDIF

     C                   IF        *In99 = *On
     C     Kftpycgl6     CHAIN     PYCGL6                             99
     C                   ENDIF

     C                   IF        *In99 = *On
     C     Kftpycgl7     CHAIN     PYCGL7                             99
     C                   ENDIF

      ***Access*customer*file*and*if*retail*customer*group*=*1*then*****                      248174
      ** access customer grouping codes file and chain using codes
      ** with set number = 1.

     C***********        EVAL      Cus_Grp = *blanks                                          248174
     C                   EVAL      K_D6snbr = '1'

     C***********        IF        *In99 = *On                                                248174
     C*****K_CustNum     CHAIN     SDCUSTL1                           98                      248174
     C***********        IF        *In98 = *Off and BBCGRP = '1'                              248174
     C***********        EVAL      Cus_Grp = 'Y'                                              248174
     C***********        ENDIF                                                                248174
     C***********        ENDIF                                                                248174

      ** Get correct grouping code for checking.                                              246583
                                                                                              246583
     C                   EVAL      ChkGrp    = *blanks                                        246583
     C     K_CustNum     CHAIN     SDCMRKL1                           96                      246583
     C                   IF        *In96 = *off                                               246583
     C                   EVAL      ChkGrp = D7GPC1                                            246583
     C                   ENDIF                                                                246583
                                                                                              246583
     C***********        IF        *In99 = *On and Cus_Grp = 'Y'                              248174
     C                   IF        *In99 = *On and ChkGrp <> *Blanks                          248174
      ** Read all set number 1 group codes from file

     C     K_D6snbr      SETLL     SDCGRPL0
     C     K_D6snbr      READE     SDCGRPL0                               97

      ** Use group code as part of key to access charge defaults file
     C     *In97         DOWEQ     *Off
     C                   EVAL      K_Csgrcd = D6GPCD
     C     Kftpycgl2     CHAIN     PYCGL2                             99
      ** Got one - leave loop
      ** Only if correct Grouping Code                                                        246583
     C**********         IF        *In99 = *Off                                               246583
     C                   IF        *In99 = *Off AND CSGRCD = ChkGrp                           246583
     C                   LEAVE
     C                   ENDIF

     C     K_D6snbr      READE     SDCGRPL0                               97
     C                   ENDDO

     C                   ENDIF

     C***********        IF        *In99 = *On and Cus_Grp = 'Y'                              248174
     C                   IF        *In99 = *On and ChkGrp <> *Blanks                          248174
      ** Read all set number 1 group codes from file

     C     K_D6snbr      SETLL     SDCGRPL0
     C     K_D6snbr      READE     SDCGRPL0                               97

      ** Use group code as part of key to access charge defaults file
     C     *In97         DOWEQ     *Off
     C                   EVAL      K_Csgrcd = D6GPCD
     C     Kftpycgl3     CHAIN     PYCGL3                             99
      ** Got one - leave loop
      ** Only if correct Grouping Code                                                        246583
     C*******************IF        *In99 = *Off                                               246583
     C                   IF        *In99 = *Off AND CSGRCD = ChkGrp                           246583
     C                   LEAVE
     C                   ENDIF

     C     K_D6snbr      READE     SDCGRPL0                               97
     C                   ENDDO

     C                   ENDIF

     C***********        IF        *In99 = *On and Cus_Grp = 'Y'                              248174
     C                   IF        *In99 = *On and ChkGrp <> *Blanks                          248174
      ** Read all set number 1 group codes from file

     C     K_D6snbr      SETLL     SDCGRPL0
     C     K_D6snbr      READE     SDCGRPL0                               97

      ** Use group code as part of key to access charge defaults file
     C     *In97         DOWEQ     *Off
     C                   EVAL      K_Csgrcd = D6GPCD
     C     Kftpycgl8     CHAIN     PYCGL8                             99
      ** Got one - leave loop
      ** Only if correct Grouping Code                                                        246583
     C*******************IF        *In99 = *Off                                               246583
     C                   IF        *In99 = *Off AND CSGRCD = ChkGrp                           246583
     C                   LEAVE
     C                   ENDIF

     C     K_D6snbr      READE     SDCGRPL0                               97
     C                   ENDDO

     C                   ENDIF

     C***********        IF        *In99 = *On and Cus_Grp = 'Y'                              248174
     C                   IF        *In99 = *On and ChkGrp <> *Blanks                          248174
      ** Read all set number 1 group codes from file

     C     K_D6snbr      SETLL     SDCGRPL0
     C     K_D6snbr      READE     SDCGRPL0                               97

      ** Use group code as part of key to access charge defaults file
     C     *In97         DOWEQ     *Off
     C                   EVAL      K_Csgrcd = D6GPCD
     C     Kftpycgl9     CHAIN     PYCGL9                             99
      ** Got one - leave loop
      ** Only if correct Grouping Code                                                        246583
     C*******************IF        *In99 = *Off                                               246583
     C                   IF        *In99 = *Off AND CSGRCD = ChkGrp                           246583
     C                   LEAVE
     C                   ENDIF

     C     K_D6snbr      READE     SDCGRPL0                               97
     C                   ENDDO

     C                   ENDIF

     C                   IF        *In99 = *On
     C     Kftpycgl4     CHAIN     PYCGL4                             99
     C                   ENDIF

     C                   IF        *In99 = *On
     C     Kftpycgla     CHAIN     PYCGLA                             99
     C                   ENDIF

     C                   IF        *In99 = *On
     C     Kftpycgl5     CHAIN     PYCGL5                             99
     C                   ENDIF

     C                   IF        *In99 = *On
     C     Kftpycglb     CHAIN     PYCGLB                             99
     C                   ENDIF

      ** If charge code default record found move file data structure
      ** to work data structure to extract codes array
     C                   IF        *In99 = *Off
     C                   EVAL      CodesM = FTPYCG

      ** Now move work array to customer 1 or customer 2 array
     C                   SELECT

     C                   WHEN      Z = 1
     C                   MOVEA     W_ArrayM      Cus1_Dft

     C                   WHEN      Z = 2
     C                   MOVEA     W_ArrayM      Cus2_Dft

     C                   ENDSL

     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      * Dft_STP - Get default charge codes for STP processing.        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    *******
     C     Dft_STP       BEGSR
      *    *******

     C                   CLEAR                   CusS_Dft

      ** Set key for access to STP charge code file

     C                   EVAL      K_Gnmtpy = P_MessType
     C                   MOVE      P_SetNum      K_Gnmset
     C                   EVAL      K_Gnpytp = P_TransType

     C     Kmegncrl1     CHAIN     MEGNCRL1                           99

      ** If charge code default record found move file data structure
      ** to work data structure to extract codes array

     C                   IF        *In99 = *Off
     C                   EVAL      CodesS = MEGNCR

      ** Now move work array to STP array

     C                   MOVEA     W_ArrayS      CusS_Dft
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      * Dft_Charges - Work out charge codes to use - customer 1 or 2  *
      *               or STP                                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    ***********
     C     Dft_Charges   BEGSR
      *    ***********

      ** 20 possible charge codes in arrays.
      ** If customer 2 present override customer 1.
      ** If STP present overwrite customer 1 (after customer 2 overwrite).
      ** Codes in customer 1 are used for calcs.

     C                   EVAL      X = 1
     C                   EVAL      Y = 20

     C     X             DO        Y             Z

     C                   IF        Cus2_dft(Z) <> *blanks
     C                   EVAL      Cus1_dft(Z) = Cus2_dft(Z)
     C                   ENDIF

     C                   SELECT

     C                   WHEN      CusS_dft(Z) = '*****' and P_ProcMthd = 'S'
     C                   EVAL      Cus1_dft(Z) = *blanks

     C                   WHEN      CusS_dft(Z) <> *blanks and P_ProcMthd = 'S'
     C                   EVAL      Cus1_dft(Z) = CusS_dft(Z)

     C                   ENDSL

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Charges - Call correct charge programs                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SR981 SR982 SR983 SR984                                *
      *                                                               *
      *****************************************************************

      *    *******
     C     Charges       BEGSR
      *    *******

     C                   EVAL      X = 1
     C                   EVAL      Y = 20

     C     X             DO        Y             Z

     C                   EVAL      P_ChargeCde = *blanks

     C                   SELECT

      ** Fx spread set
     C                   WHEN      Z = 1

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'

     C                   If        I_FXSPSC <> *Blanks
     C                   EVAL      Cus1_dft(Z) = I_FXSPSC
     C                   Else
     C                   Eval      I_FXSPSC = Cus1_dft(Z)
     C                   Endif

     C                   EVAL      P_SpreadCde = Cus1_dft(Z)

     C                   IF        I_PCCY <> I_SMCY
     C                   EVAL      I_FXSPSC    = Cus1_dft(Z)
     C                   ELSE                                                                BUG8305
     C                   EVAL      P_SpreadCde = *blanks                                     BUG8305
     C                   EVAL      I_FXSPSC = *blanks                                        BUG8305
     C                   ENDIF

     C                   EVAL      P_Payccy = I_PCCY
     C                   EVAL      P_SettCcy = I_SMCY
     C                   EVAL      P_ExRate = 0
     C                   EVAL      P_STP = P_ProcMthd

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'

     C                   If        O_FXSRSC <> *Blanks
     C                   EVAL      Cus1_dft(Z) = O_FXSRSC
     C                   ELSE
     C                   Eval      O_FXSRSC = Cus1_dft(Z)
     C                   Endif

     C                   EVAL      P_SpreadCde = Cus1_dft(Z)

     C                   IF        O_PCCY <> O_SMCY
     C                   EVAL      O_FXSRSC    = Cus1_dft(Z)
     C                   ELSE                                                                BUG8305
     C                   EVAL      P_SpreadCde = *blanks                                     BUG8305
     C                   EVAL      O_FXSRSC = *blanks                                        BUG8305
     C                   ENDIF

     C                   EVAL      P_Payccy = O_PCCY
     C                   EVAL      P_SettCcy = O_SMCY
     C                   EVAL      P_ExRate = 0
     C                   EVAL      P_STP = P_ProcMthd

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'

     C                   If        P_SpreadCde <> *Blanks
     C                   EVAL      P_SpreadCde = Cus1_dft(Z)
     C                   ELSE
     C                   Eval      H2FXSSCD = Cus1_dft(Z)
     C                   Endif

     C                   EVAL      P_Payccy = D2PAYCCY
     C                   EVAL      P_SettCcy = D2CCTCCY
     C                   EVAL      P_ExRate = 0
     C                   EVAL      P_STP = P_ProcMthd

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'

     C                   If        P_SpreadCde <> *Blanks
     C                   EVAL      P_SpreadCde = Cus1_dft(Z)
     C                   ELSE
     C                   Eval      H2FXSSCD = Cus1_dft(Z)
     C                   Endif

     C                   EVAL      P_Payccy = D2PAYCCY
     C                   EVAL      P_SettCcy = D2CCTCCY
     C                   EVAL      P_ExRate = 0
     C                   EVAL      P_STP = P_ProcMthd

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'

     C                   If        P_SpreadCde <> *Blanks
     C                   EVAL      P_SpreadCde = Cus1_dft(Z)
     C                   ELSE
     C                   Eval      H1FXSRST = Cus1_dft(Z)
     C                   Endif

     C                   EVAL      P_Payccy = D1PAYCCY
     C                   EVAL      P_SettCcy = D1TRNCCY
     C                   EVAL      P_ExRate = 0
     C                   EVAL      P_STP = P_ProcMthd

     C                   IF        P_Payccy <> P_Settccy
     C                   EVAL      H1FXSRST    = Cus1_dft(Z)
     C                   ENDIF

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'

     C                   If        P_SpreadCde <> *Blanks
     C                   EVAL      P_SpreadCde = Cus1_dft(Z)
     C                   ELSE
     C                   Eval      H1FXSRST = Cus1_dft(Z)
     C                   Endif

     C                   EVAL      P_Payccy = D1PAYCCY
     C                   EVAL      P_SettCcy = D1TRNCCY
     C                   EVAL      P_ExRate = 0
     C                   EVAL      P_STP = P_ProcMthd

     C                   IF        P_Payccy <> P_Settccy
     C                   EVAL      H1FXSRST    = Cus1_dft(Z)
     C                   ENDIF

      ** Cheques to be paid
      ** If settle currency is blank set as pay ccy
     C                   WHEN      P_TransType = 'CP'

     C                   If        P_SpreadCde <> *Blanks
     C                   EVAL      P_SpreadCde = Cus1_dft(Z)
     C                   ELSE
     C                   Eval      C_FXSSET = Cus1_dft(Z)
     C                   Endif

     C                   EVAL      P_Payccy = C_PCCY
     C                   If        D_DRCY <> *blanks
     C                   EVAL      P_SettCcy = D_DRCY
     C                   ELSE
     C                   EVAL      P_SettCcy = C_PCCY
     C                   ENDIF
     C                   EVAL      P_ExRate = 0
     C                   EVAL      P_STP = P_ProcMthd

      ** Cheques to be collected
      ** If pay currency is blank set as settle ccy
     C                   WHEN      P_TransType = 'CC'

     C                   If        A_FXSPDS <> *Blanks
     C                   EVAL      Cus1_dft(Z) = A_FXSPDS
     C                   ELSE
     C                   Eval      A_FXSPDS = Cus1_dft(Z)
     C                   Endif

     C                   EVAL      P_SpreadCde = Cus1_dft(Z)

     C                   EVAL      P_SettCcy = B_SMCY
     C                   EVAL      P_ExRate = 0
     C                   EVAL      P_STP = P_ProcMthd

     C                   EVAL      P_Payccy = A_CRCY

     C                   ENDSL

     C                   EXSR      SR982

      ** Payment date offset
     C                   WHEN      Z = 2

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   If        I_INPDOF <> *Blanks
     C                   EVAL      P_OffsetCde = I_INPDOF
     C                   Else
     C                   EVAL      P_OffsetCde = Cus1_dft(Z)
     C                   EndIf
     C                   EVAL      I_INPDOF    = Cus1_dft(Z)
     C                   MOVE      I_SLDTD1      P_SettDate
     C                   MOVE      I_PVDTD1      P_PayDate

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   If        O_OTPDOF <> *Blanks
     C                   EVAL      P_OffsetCde = O_OTPDOF
     C                   Else
     C                   EVAL      P_OffsetCde = Cus1_dft(Z)
     C                   EndIf
     C                   EVAL      O_OTPDOF    = Cus1_dft(Z)
     C                   MOVE      O_SLDTD1      P_SettDate
     C                   MOVE      O_PVDTD1      P_PayDate

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      P_OffsetCde = Cus1_dft(Z)
     C                   MOVE      H2DBTVDT      P_SettDate
     C                   MOVE      D2CRDVDT      P_PayDate

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      P_OffsetCde = Cus1_dft(Z)
     C                   MOVE      H2DBTVDT      P_SettDate
     C                   MOVE      D2CRDVDT      P_PayDate

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      P_OffsetCde = Cus1_dft(Z)
     C                   MOVE      H1DBTVDT      P_SettDate
     C                   MOVE      D1CRDVDT      P_PayDate

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      P_OffsetCde = Cus1_dft(Z)
     C                   MOVE      H1DBTVDT      P_SettDate
     C                   MOVE      D1CRDVDT      P_PayDate

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      P_OffsetCde = Cus1_dft(Z)
     C                   MOVE      D_DRVDD1      P_SettDate
     C                   MOVE      C_PVDTD1      P_PayDate

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      P_OffsetCde = Cus1_dft(Z)
     C                   MOVE      B_SLDTD1      P_SettDate
     C                   MOVE      A_CRVDD1      P_PayDate

     C                   ENDSL

     C                   EXSR      SR983

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   MOVE      P_SettDate    I_SLDTD1
     C                   MOVE      P_PayDate     I_PVDTD1

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   MOVE      P_SettDate    O_SLDTD1
     C                   MOVE      P_PayDate     O_PVDTD1

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   MOVE      P_SettDate    H2DBTVDT
     C                   MOVE      P_PayDate     D2CRDVDT

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   MOVE      P_SettDate    H2DBTVDT
     C                   MOVE      P_PayDate     D2CRDVDT

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   MOVE      P_SettDate    H1DBTVDT
     C                   MOVE      P_PayDate     D1CRDVDT

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   MOVE      P_SettDate    H1DBTVDT
     C                   MOVE      P_PayDate     D1CRDVDT

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   MOVE      P_SettDate    D_DRVDD1
     C                   MOVE      P_PayDate     C_PVDTD1

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   MOVE      P_SettDate    B_SLDTD1
     C                   MOVE      P_PayDate     A_CRVDD1

     C                   ENDSL

     C                   ENDIF


      ** Telex charge
     C                   WHEN      Z = 3 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_TLCODE    = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_TLXCDE    = Cus1_dft(Z)

      ** Incoming customer credit transfer
      ** Currently no telex charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no telex charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no telex charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no telex charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      ** Currently no telex charge for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      PayAmt = A_CQAM
     C                   EVAL      PayCcy = A_CRCY
     C                   EVAL      ChgCcy = A_CCCHGC
     C                   EVAL      ChgExch = A_CCCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      A_TLXCHD    = Cus1_dft(Z)

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_TXCH = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_TXCH   = TotInChgCcy

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      A_TXCH = TotInChgCcy

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Cheque charge
     C                   WHEN      Z = 4 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_CHCHCD    = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_CHQCHC    = Cus1_dft(Z)

      * If Statement type <> 12 or 13, do not default this charge
     C                   If        O_STMT <> 12 AND
     C                             O_STMT <> 13
     C                   Eval      P_ChargeCde = *Blanks
     C                   Eval      O_CHQCHC    = *Blanks
     C                   Endif

      ** Incoming customer credit transfer
      ** Currently no cheque charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no cheque charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no cheque charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no cheque charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      ** Currently no cheque charge for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no cheque charge for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_CQCH = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_CQCH   = TotInChgCcy

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Costs abroad charge
     C                   WHEN      Z = 5 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
      ** Currently no costs abroad charge for this transaction type
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_CACHCD    = Cus1_dft(Z)

      ** Incoming customer credit transfer
      ** Currently no costs abroad charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no costs abroad charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no costs abroad charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no costs abroad charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      PayAmt = C_PDAM
     C                   EVAL      PayCcy = C_PDCY
     C                   EVAL      ChgCcy = D_CPCHGC
     C                   EVAL      ChgExch = D_CPCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      PayAmt = A_CQAM
     C                   EVAL      PayCcy = A_CRCY
     C                   EVAL      ChgCcy = A_CCCHGC
     C                   EVAL      ChgExch = A_CCCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      A_CABCCD    = Cus1_dft(Z)

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_CSTA   = TotInChgCcy

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      D_CSTA = TotInChgCcy

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      A_CSTA = TotInChgCcy

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Swift standard charge
     C                   WHEN      Z = 6 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
      ** Currently no Swift standard charge for this transaction type
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_SSTCCD    = Cus1_dft(Z)

      * If Settlement type <> '08', do not allow Swift Standard Charge
     C                   If        O_STMT <> 08
     C                   Eval      P_ChargeCde = *Blanks
     C                   Eval      O_SSTCCD    = *Blanks
     C                   Endif

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
      ** Currently no Swift standard charge for this transaction type
     C                   WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      H1SWSTCC    = Cus1_dft(Z)

      ** Cheques to be paid
      ** Currently no Swift standard charge for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no Swift standard charge for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_SWSCCC = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      H2SWSTAC = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      H2SWSTAC = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      H1SWSTDC = TotInChgCcy

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Swift priority charge
     C                   WHEN      Z = 7 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
      ** Currently no Swift priority charge for this transaction type
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_SPRCCD    = Cus1_dft(Z)

      * If Swift Priority <> 'U', do not allow Swift Priority Charge
     C                   If        O_SWPC <> 01
     C                   Eval      P_ChargeCde = *Blanks
     C                   Eval      O_SPRCCD    = *Blanks
     C                   Endif

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
      ** Currently no Swift priority charge for this transaction type
     C                   WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      H1SWPRCC    = Cus1_dft(Z)

      ** Cheques to be paid
      ** Currently no Swift priority charge for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no Swift priority charge for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_SPCH = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      H2SWPRIR = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      H2SWPRIR = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      H1SWPRIC = TotInChgCcy

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Misc. Charge
     C                   WHEN      Z = 8 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_MISCH     = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_MSCHC     = Cus1_dft(Z)

      ** Incoming customer credit transfer
      ** Currently no Misc. charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no Misc. charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no Misc. charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no Misc. charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      ** Currently no Misc. charge for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no Misc. charge for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_MSCH = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_MSCH = TotInChgCcy

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Misc. charge 1
     C                   WHEN      Z = 9 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_MSCH1     = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_MSCHC1    = Cus1_dft(Z)

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      D1IMICC1    = Cus1_dft(Z)

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      H1OMICC1    = Cus1_dft(Z)

      ** Cheques to be paid
      ** Currently no Misc. charge1 for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no Misc. charge1 for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_CMSC01 = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_MISCC1 = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      D2MICH1 = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      D2MICH1 = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      D1IMICH1 = TotInChgCcy

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      H1OMIC1 = TotInChgCcy

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Misc. charge 2
     C                   WHEN      Z = 10 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_MSCH2     = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_MSCHC2    = Cus1_dft(Z)

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      D1IMICC2    = Cus1_dft(Z)

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      H1OMICC2    = Cus1_dft(Z)

      ** Cheques to be paid
      ** Currently no Misc. charge2 for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no Misc. charge2 for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_CMSC02 = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_MISCC2 = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      D2MICH2 = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      D2MICH2 = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      D1IMICH2 = TotInChgCcy

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      H1OMIC2 = TotInChgCcy

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Misc. charge 3
     C                   WHEN      Z = 11 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_MSCH3     = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_MSCHC3    = Cus1_dft(Z)

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      D1IMICC3    = Cus1_dft(Z)

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      H1OMICC3    = Cus1_dft(Z)

      ** Cheques to be paid
      ** Currently no Misc. charge3 for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no Misc. charge3 for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_CMSC03 = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_MISCC3 = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      D2MICH3 = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      D2MICH3 = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      D1IMICH3 = TotInChgCcy

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      H1OMIC3 = TotInChgCcy

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Misc. charge 4
     C                   WHEN      Z = 12 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_MSCH4     = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_MSCHC4    = Cus1_dft(Z)

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      D1IMICC4    = Cus1_dft(Z)

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      H1OMICC4    = Cus1_dft(Z)

      ** Cheques to be paid
      ** Currently no Misc. charge4 for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no Misc. charge4 for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_CMSC04 = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_MISCC4 = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      D2MICH4 = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      D2MICH4 = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      D1IMICH4 = TotInChgCcy

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      H1OMIC4 = TotInChgCcy

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Misc. charge 5
     C                   WHEN      Z = 13 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_MSCH5     = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_MSCHC5    = Cus1_dft(Z)

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      D1IMICC5    = Cus1_dft(Z)

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      H1OMICC5    = Cus1_dft(Z)

      ** Cheques to be paid
      ** Currently no Misc. charge5 for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no Misc. charge5 for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_CMSC05 = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_MISCC5 = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      D2MICH5 = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      D2MICH5 = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      D1IMICH5 = TotInChgCcy

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   EVAL      H1OMIC5 = TotInChgCcy

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Transfer commission charge
     C                   WHEN      Z = 14 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_TFCCCO    = Cus1_dft(Z)

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_TFCCCD    = Cus1_dft(Z)

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      D1TFCOCC    = Cus1_dft(Z)

      ** Outgoing request for transfer
      ** Currently transfer commission charge for this transaction type
     C                   WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      PayAmt = C_PDAM
     C                   EVAL      PayCcy = C_PDCY
     C                   EVAL      ChgCcy = D_CPCHGC
     C                   EVAL      ChgExch = D_CPCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      PayAmt = A_CQAM
     C                   EVAL      PayCcy = A_CRCY
     C                   EVAL      ChgCcy = A_CCCHGC
     C                   EVAL      ChgExch = A_CCCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      A_TRCMCC    = Cus1_dft(Z)

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_TRCM = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_TRCM   = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      D2TRCOCH = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      D2TRCOCH = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      D1TRCHCC = TotInChgCcy

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      D_TRCM = TotInChgCcy

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      A_TRCM = TotInChgCcy

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** FX/Change commission charge
     C                   WHEN      Z = 15 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   Exsr      ChkEuro
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_FXCHEC    = Cus1_dft(Z)

      * Not allowed if Pay Ccy = Sett Ccy
     C                   IF        I_PCCY = I_SMCY
     C                   Eval      P_ChargeCde = *Blanks
     C                   Eval      I_FXCHEC    = *Blanks
     C                   Endif

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   Eval      P_SettAmt = O_SMAM
     C                   EVAL      PayAmt = O_PYAM
     C                   EVAL      PayCcy = O_PCCY
     C                   EVAL      ChgCcy = O_OPCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   Exsr      ChkEuro
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      O_FXCACC    = Cus1_dft(Z)

      * Not allowed if Pay Ccy = Sett Ccy
     C                   IF        O_PCCY = O_SMCY
     C                   Eval      P_ChargeCde = *Blanks
     C                   Eval      O_FXCACC    = *Blanks
     C                   Endif

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      PayAmt = D2PAYAMT
     C                   EVAL      PayCcy = D2PAYCCY
     C                   EVAL      ChgCcy = D2M2CHGC
     C                   EVAL      ChgExch = D2M2CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      PayAmt = D1PAYAMT
     C                   EVAL      PayCcy = D1PAYCCY
     C                   EVAL      ChgCcy = D1M1CHGC
     C                   EVAL      ChgExch = D1M1CHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

     C                   EVAL      D1FXCCCD    = Cus1_dft(Z)

      ** Outgoing request for transfer
      ** Currently no FX/Change commission charge for this transaction type
     C                   WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      PayAmt = C_PDAM
     C                   EVAL      PayCcy = C_PDCY
     C                   EVAL      ChgCcy = D_CPCHGC
     C                   EVAL      ChgExch = D_CPCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      PayAmt = A_CQAM
     C                   EVAL      PayCcy = A_CRCY
     C                   EVAL      ChgCcy = A_CCCHGC
     C                   EVAL      ChgExch = A_CCCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      A_FXCCCC    = Cus1_dft(Z)

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_INCHCM = TotInChgCcy

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      O_OPCHCM = TotInChgCcy

      ** Incoming customer credit transfer
     C                   WHEN      P_TransType = 'BI'
     C                   EVAL      D2FXCHAC = TotInChgCcy

      ** Outgoing customer credit transfer
     C                   WHEN      P_TransType = 'BO'
     C                   EVAL      D2FXCHAC = TotInChgCcy

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   EVAL      D1FXCHGC = TotInChgCcy

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      D_PDCHCM = TotInChgCcy

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      A_CCCHCM = TotInChgCcy

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Advice charge
     C                   WHEN      Z = 16 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_ADCHCD    = Cus1_dft(Z)

      ** Outgoing payments
      ** Currently no advice charge for this transaction type
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      ** Currently no advice charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no advice charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no advice charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no advice charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      ** Currently no advice charge for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no advice charge for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_ADCH = TotInChgCcy

      ** Outgoing payments
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Telephone charge
     C                   WHEN      Z = 17 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   Eval      P_SettAmt = I_SMAM
     C                   EVAL      PayAmt = I_PYAM
     C                   EVAL      PayCcy = I_PCCY
     C                   EVAL      ChgCcy = I_INCHGC
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      I_TLCHCD    = Cus1_dft(Z)

      ** Outgoing payments
      ** Currently no telephone charge for this transaction type
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      ** Currently no telephone charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no telephone charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no telephone charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no telephone charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      ** Currently no telephone charge for this transaction type
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      ** Currently no telephone charge for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      I_TLCH = TotInChgCcy

      ** Outgoing payments
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
      **                 WHEN      P_TransType = 'CP'

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Collection charge
     C                   WHEN      Z = 18 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
      ** Currently no collection charge for this transaction type
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
      ** Currently no collection charge for this transaction type
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      ** Currently no collection charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no collection charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no collection charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no collection charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      PayAmt = C_PDAM
     C                   EVAL      PayCcy = C_PDCY
     C                   EVAL      ChgCcy = D_CPCHGC
     C                   EVAL      ChgExch = D_CPCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      PayAmt = A_CQAM
     C                   EVAL      PayCcy = A_CRCY
     C                   EVAL      ChgCcy = A_CCCHGC
     C                   EVAL      ChgExch = A_CCCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)
     C                   EVAL      A_COCHCD    = Cus1_dft(Z)

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      D_COLL = TotInChgCcy

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      A_COLL = TotInChgCcy

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Correspondents charge
     C                   WHEN      Z = 19 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
      ** Currently no correspondents charge for this transaction type
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
      ** Currently no correspondents charge for this transaction type
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      ** Currently no correspondents charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no correspondents charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no correspondents charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no correspondents charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      PayAmt = C_PDAM
     C                   EVAL      PayCcy = C_PDCY
     C                   EVAL      ChgCcy = D_CPCHGC
     C                   EVAL      ChgExch = D_CPCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Cheques to be collected
      ** Currently no correspondents charge for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      C_COCH = TotInChgCcy

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

      ** Deductions charge
     C                   WHEN      Z = 20 and Cus1_dft(Z) <> *blanks

     C                   SELECT

      ** Incoming payments
      ** Currently no deductions charge for this transaction type
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
      ** Currently no deductions charge for this transaction type
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      ** Currently no deductions charge for this transaction type
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      ** Currently no deductions charge for this transaction type
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      ** Currently no deductions charge for this transaction type
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      ** Currently no deductions charge for this transaction type
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      PayAmt = C_PDAM
     C                   EVAL      PayCcy = C_PDCY
     C                   EVAL      ChgCcy = D_CPCHGC
     C                   EVAL      ChgExch = D_CPCHRT
     C                   EVAL      STP = P_ProcMthd
     C                   EVAL      P_ChargeCde = Cus1_dft(Z)

      ** Cheques to be collected
      ** Currently no deductions charge for this transaction type
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   IF        P_ChargeCde <> *blanks
     C                   EXSR      SR981

      ** If no error in return code then move data to correct file for
      ** pass back to calling program.

     C                   IF        RetCodeIn = *blanks

     C                   SELECT

      ** Incoming payments
      **                 WHEN      P_TransType = 'IN'

      ** Outgoing payments
      **                 WHEN      P_TransType = 'OP'

      ** Incoming customer credit transfer
      **                 WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer
      **                 WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
      **                 WHEN      P_TransType = 'RI'

      ** Outgoing request for transfer
      **                 WHEN      P_TransType = 'RO'

      ** Cheques to be paid
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      C_DEDS = TotInChgCcy

      ** Cheques to be collected
      **                 WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF
     C                   ENDIF

     C                   ENDSL

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * SR981 - Calculate charges for the following using call to     *
      *         FT000981.                                             *
      *                                                               *
      *         Telex charge                                          *
      *         Cheque charge                                         *
      *         Costs abroad charge                                   *
      *         S.W.I.F.T. std charge                                 *
      *         S.W.I.F.T. priority charge                            *
      *         Miscellaneous charge                                  *
      *         Miscellaneous charge 1                                *
      *         Miscellaneous charge 2                                *
      *         Miscellaneous charge 3                                *
      *         Miscellaneous charge 4                                *
      *         Miscellaneous charge 5                                *
      *         Transfer commission charge                            *
      *         FX/Change commission charge                           *
      *         Advice charge                                         *
      *         Telephone charge                                      *
      *         Collection charge                                     *
      *         Correspondents charge                                 *
      *         Deductions charge                                     *
      *                                                               *
      *         Charges returned from this routine are in charge ccy  *
      *         and need to be converted.                             *
      *                                                               *
      *         IN - Incoming payments - Pay ccy.                     *
      *         OP - Outgoing payments - Settle ccy.                  *
      *         BI - Incoming customer credit transfer - T.B.A.       *
      *         BO - Outgoing customer credit transfer - T.B.A.       *
      *         RI - Incoming request for transfer - T.B.A.           *
      *         RO - Outgoing request for transfer - T.B.A.           *
      *         CP - Cheques to be paid - T.B.A.                      *
      *         CC - Cheques to be collected - T.B.A.                 *
      *                                                               *
      * Called by: Charges                                            *
      *                                                               *
      * Calls: Convert1 Convert2                                      *
      *                                                               *
      *****************************************************************

      *    *****
     C     SR981         BEGSR
      *    *****

      * Always send transaction rate to charge calculation.
     C                   If        CHTRCY = 'Y'

     C                   Select

     C                   When      P_TransType = 'IN'
     C                   Eval      ChgExch   =  I_Rate

     C                   When      P_TransType = 'OP'
     C                   Eval      ChgExch   =  O_Rate

     C                   EndSl

     C                   Endif

      * If charges in transaction currency flag = 'Y'

     C                   CALLB     'FT000981'
     C                   PARM                    RetCodeOut
     C                   PARM                    PayAmt
     C                   PARM                    PayCcy
     C                   PARM                    P_SettCcy
     C                   PARM                    ChgCcy
     C                   PARM                    ChgExch
     C                   PARM                    STP
     C                   PARM                    P_ChargeCde       5
     C                   PARM                    P_SettAmt
     C                   PARM                    P_ChargesDR
     C                   PARM                    P_ADDC
     C                   PARM                    P_ChgDRCcy                                   CFT120
     C                   PARM                    TotInChgCcy      13 0
     C                   PARM                    ChgableAmt       13 0
     C                   PARM                    TierCharge
     C                   PARM                    TierAmount

     C                   IF        RetCodeOut = *blanks

     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      FRMCCY = ChgCcy

     C                   Select
     C***********        When      I_CDRO <> *Zeros                                           CSD027
     C                   When      I_CDRO <> *BLANKS                                          CSD027
     C                   Eval      ToCcy = BaseCcy
     C                   When      I_ADDC = 'A'
     C                   Eval      ToCcy = I_SMCY
     C                   If        I_SND1 = 'CASHIER' AND
     C                             I_PCCY =BaseCcy
     C                   Eval      ToCcy = I_PCCY
     C                   EndIf
     C                   Other
     C                   Eval      ToCcy = I_PCCY
     C                   Endsl

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      FRMCCY = Chgccy

     C                   Select
     C***********        When      O_CDRO <> *Zeros                                           CSD027
     C                   When      O_CDRO <> *BLANKS                                          CSD027
     C                   Eval      ToCcy = BaseCcy
     C                   When      O_ADDC = 'A'
     C                   Eval      ToCcy = O_SMCY
     C                   Other
     C                   Eval      ToCcy = O_PCCY
     C                   Endsl

      ** Incoming customer credit transfer (T.B.A.)
     C                   WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer (T.B.A.)
     C                   WHEN      P_TransType = 'BO'

      ** Incoming request for transfer
     C                   WHEN      P_TransType = 'RI'
     C                   Eval      FRMCCY = ChgCcy
     C                   Eval      ToCcy = D1RCHCCY

     C                   Eval      INPAMT = TotInChgCcy
     C                   ExSr      Convert1
     C                   ExSr      Convert2
     C                   Eval      TotInChgCcy = OUTAMT

      ** Outgoing request for transfer
     C                   WHEN      P_TransType = 'RO'
     C                   Eval      FRMCCY = ChgCcy
     C                   Eval      ToCcy = H1HANDCY

     C                   Eval      INPAMT = TotInChgCcy
     C                   ExSr      Convert1
     C                   ExSr      Convert2
     C                   Eval      TotInChgCcy = OUTAMT

      ** Cheques to be paid (T.B.A.)
     C                   WHEN      P_TransType = 'CP'

      ** Cheques to be collected (T.B.A.)
     C                   WHEN      P_TransType = 'CC'

     C                   ENDSL

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * SR982 - Calculate FX spread using call to FT000982.           *
      *                                                               *
      * Called by: Charges                                            *
      *                                                               *
      * Calls: Convert1 Convert2                                      *
      *                                                               *
      *****************************************************************

      *    *****
     C     SR982         BEGSR
      *    *****

      ** If the spread code is blank, do not call FT000982

     C                   If        P_SpreadCde <> *Blanks

     C                   CALLB     'FT000982'
     C                   PARM                    RetCode982
     C                   PARM                    P_SpreadCde
     C                   PARM                    P_PayCcy
     C                   PARM                    P_SettCcy
     C                   PARM                    P_ExRate
     C                   PARM                    P_STP

     C                   EndIf

      ** Now calculate pay amount from settle amount using rate
      ** from FT000982.


     C                   SELECT

      ** Incoming payments
     C                   WHEN      P_TransType = 'IN' And
     C                                           RetCode980 <> '*NONE     '
     C                   IF        RetCode980 = *Blanks OR
     C                             RetCode980 = '*CALCPAY  '
     C                   EVAL      FRMCCY = I_SMCY
     C                   EVAL      TOCCY = I_PCCY
     C                   Else
     C                   EVAL      FRMCCY = I_PCCY
     C                   EVAL      TOCCY = I_SMCY
     C                   Endif

     C                   EXSR      Convert1

     C                   If        RetCode982 = '*CALC     '
     C                   EVAL      I_RATE = P_ExRate
     C                   Eval      CVTRAT = I_RATE

     C                   IF        RetCode980 = *Blanks OR
     C                             RetCode980 = '*CALCPAY  '
     C                   EVAL      INPAMT = I_SMAM
     C                   Else
     C                   EVAL      INPAMT = I_PYAM
     C                   Endif

     C                   EXSR      Convert2

     C                   IF        RetCode980 = *Blanks OR
     C                             RetCode980 = '*CALCPAY  '
     C                   EVAL      I_PYAM = OUTAMT
     C                   Else
     C                   EVAL      I_SMAM = OUTAMT
     C                   Endif
     C                   Endif

      ** Outgoing payments
     C                   WHEN      P_TransType = 'OP' And
     C                                           RetCode980 <> '*NONE     '
     C                   IF        RetCode980 = *Blanks OR
     C                             RetCode980 = '*CALCPAY  '
     C                   EVAL      FRMCCY = O_SMCY
     C                   EVAL      TOCCY = O_PCCY
     C                   Else
     C                   EVAL      FRMCCY = O_PCCY
     C                   EVAL      TOCCY = O_SMCY
     C                   Endif

     C                   EXSR      Convert1

     C                   If        RetCode982 = '*CALC     '
     C                   EVAL      O_RATE = P_ExRate
     C                   EVAL      CVTRAT = O_RATE

     C                   IF        RetCode980 = *Blanks OR
     C                             RetCode980 = '*CALCPAY  '
     C                   EVAL      INPAMT = O_SMAM
     C                   Else
     C                   EVAL      INPAMT = O_PYAM
     C                   Endif

     C                   EXSR      Convert2

     C                   IF        RetCode980 = *Blanks OR
     C                             RetCode980 = '*CALCPAY  '
     C                   EVAL      O_PYAM = OUTAMT
     C                   Else
     C                   EVAL      O_SMAM = OUTAMT
     C                   Endif
     C                   Endif

      ** Incoming customer credit transfer (T.B.A.)
     C                   WHEN      P_TransType = 'BI'

      ** Outgoing customer credit transfer (T.B.A.)
     C                   WHEN      P_TransType = 'BO'

      ** Incoming request for transfer (T.B.A.)
     C                   WHEN      P_TransType = 'RI'

     C                   EVAL      FRMCCY = D1PAYCCY
     C                   EVAL      TOCCY = D1TRNCCY

     C                   EXSR      Convert1

      ** Override default exchange rate only if amended in 982
     C                   If        RetCode982 = '*CALC     '
     C                   EVAL      D1XRATE = P_ExRate
     C                   Endif

     C                   EXSR      Convert2

      ** Outgoing request for transfer (T.B.A.)
     C                   WHEN      P_TransType = 'RO'

      ** Cheques to be paid (T.B.A.)
     C                   WHEN      P_TransType = 'CP'

      ** Cheques to be collected
     C                   WHEN      P_TransType = 'CC'
     C                   If        RetCode982 = '*CALC     '
     C                   EVAL      A_RATE = P_ExRate
     C                   Endif

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * SR983 - Calculate default payment and settlement dates using  *
      *         call to FT000983.                                     *
      *                                                               *
      * Called by: Charges                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      *    *****
     C     SR983         BEGSR
      *    *****

      * Get Location Codes
     C                   CallB     'FTRTVLOC'
     C                   Parm                    RetCodeOut
     C                   Parm                    P_TransType
     C                   Parm                    P_TransDet
     C                   Parm                    P_TransExt
     C                   Parm      *Blanks       SettDateLoc
     C                   Parm      *Blanks       PayDateLoc


     C                   CALLB     'FT000983'
     C                   PARM                    RetCodeOut
     C                   PARM                    P_OffsetCde
     C                   PARM                    P_SettDate
     C                   PARM                    P_PayDate
     C                   Parm                    P_SettCcy
     C                   Parm                    P_PayCcy
     C                   Parm                    SettDateLoc
     C                   Parm                    PayDateLoc

     C                   ENDSR
      *****************************************************************
      *                                                               *
      * Convert1 - 1st part of conversion from one currency to        *
      *            another. This part gets xrate and mult/divide      *
      *            indicator.                                         *
      *                                                               *
      * Called by: SR981 SR982                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     Convert1      BEGSR

      ** From currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      FRMCCY        @CCY
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004

     C                   MOVEL     A6NBDP        FRMDEC
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1  = A6MDIN

      ** To currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      TOCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004

     C                   MOVEL     A6NBDP        TODEC
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZMDI2  = A6MDIN

     C                   EVAL      OUTAMT = 0

      ** Work out xrate between to and from currencies
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX

     C                   EVAL      CVTRAT = ZRATEX
     C                   EVAL      BASMD = ZMDIX

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Convert2 - 2nd part of conversion from one currency to        *
      *            another. This part calcs new amount from parms     *
      *            supplied via Convert1.                             *
      *                                                               *
      * Called by: SR981 SR982                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     Convert2      BEGSR

      * If base currency
     C                   If        (BaseCcy = FRMCCY    And
     C                             ZMDI1    = 'M'       And
     C                             ZMDI2    = 'M'       And
     C                             ZRATEX   < 1   )     Or
     C                             (BaseCcy = TOCCY     And
     C                             ZMDI1    = 'M'       And
     C                             ZMDI2    = 'M'       And
     C                             ZRATEX   < 1   )

     C                   Eval      BASMD = 'D'

     C                   Endif

      ** Work out Multiply/Divide Indicator for a cross-ccy transaction.                      246723
     C                   If        FRMCCY <> BaseCcy                                          246723
     C                             and TOCCY <> BaseCcy                                       246723
     C                             and ZMDI1 = ZMDI2                                          246723
     C                             and ZRATEX < 1                                             246723
     C                   Eval      BASMD = 'D'                                                246723
     C                   Endif                                                                246723

     C                   CALLB     'ZCONVZ1'
     C                   PARM                    INPAMT           15 0
     C                   PARM                    CVTRAT           13 8
     C                   PARM                    BASMD             1
     C                   PARM                    FRMCCY            3
     C                   PARM                    TOCCY             3
     C                   PARM                    FRMDEC            1 0
     C                   PARM                    TODEC             1 0
     C                   PARM                    OUTAMT           15 0

     C                   ENDSR

      *****************************************************************
      * ChkEuro - Check If Euro currencies
      *****************************************************************
     C     ChkEuro       Begsr

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      P_PayCcy      @CCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   Eval      PayIn   = A6INCY

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      P_SettCcy     @CCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   Eval      SettIn      = A6INCY

     C                   If        BaseCcy     = Euro  Or
     C                             P_PayCcy    = Euro  AND
     C                             SettIn      = 'Y'   OR
     C                             P_SettCcy   = Euro  And
     C                             PayIn       = 'Y'   OR
     C                             PayIn       = 'Y'   AND
     C                             SettIn      = 'Y'
     C                   Eval      Cus1_dft(Z) = *Blanks
     C                   Endif

     C                   Endsr
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************

     C     *INZSR        BEGSR

      ** Entry paramaters

      ** Return Code (10A)
      ** Transaction - Main file
      ** Transaction - Extension file
      ** Transaction Type (2A)
      ** Process method (6A) - 'STP' or 'MANUAL'
      ** Process method (6A) - Message type for STP
      ** Process method (6A) - Set number for STP
      ** Process method (6A) - Payment type for STP

     C     *ENTRY        PLIST
     C                   PARM                    RetCode980
     C                   PARM                    P_TransDet
     C                   PARM                    P_TransExt
     C                   PARM                    P_TransType
     C                   PARM                    P_ProcMthd
     C                   PARM                    P_MessType
     C                   PARM                    P_SetNum

      ** Paramater list for ZEDIT

     C     P@ZEDIT       PLIST
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

      ** Key list for FTPYCGL0

     C     Kftpycgl0     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Custom
     C                   KFLD                    K_Currcy
     C                   KFLD                    K_Trntyp
     C                   KFLD                    K_Trsbty

      ** Key list for FTPYCGL1

     C     Kftpycgl1     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Custom
     C                   KFLD                    K_Trntyp
     C                   KFLD                    K_Trsbty

      ** Key list for FTPYCGL2

     C     Kftpycgl2     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Csgrcd
     C                   KFLD                    K_Currcy
     C                   KFLD                    K_Trntyp
     C                   KFLD                    K_Trsbty

      ** Key list for FTPYCGL3

     C     Kftpycgl3     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Csgrcd
     C                   KFLD                    K_Trntyp
     C                   KFLD                    K_Trsbty

      ** Key list for FTPYCGL4

     C     Kftpycgl4     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Trntyp
     C                   KFLD                    K_Trsbty

      ** Key list for FTPYCGL5

     C     Kftpycgl5     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Currcy

      ** Key list for FTPYCGL6

     C     Kftpycgl6     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Custom
     C                   KFLD                    K_Currcy

      ** Key list for FTPYCGL7

     C     Kftpycgl7     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Custom

      ** Key list for FTPYCGL8

     C     Kftpycgl8     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Csgrcd
     C                   KFLD                    K_Currcy

      ** Key list for FTPYCGL9

     C     Kftpycgl9     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Csgrcd

      ** Key list for FTPYCGLA

     C     Kftpycgla     KLIST
     C                   KFLD                    K_Branch
     C                   KFLD                    K_Trntyp

      ** Key list for FTPYCGLB

     C     Kftpycglb     KLIST
     C                   KFLD                    K_Branch

      ** Partial Key list for SDCGRPL0

     C     Ksdcgrpl0     KLIST
     C                   KFLD                    K_D6snbr

      ** Key list for MEGNCRL1

     C     Kmegncrl1     KLIST
     C                   KFLD                    K_Gnmtpy
     C                   KFLD                    K_Gnmset
     C                   KFLD                    K_Gnpytp

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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get details for Base Currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BJCYCD        @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004

      ** Database error

     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     BJCYCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save no. of decimal places of Base Currency

     C                   Eval      BaseCcy = BJCYCD
     C                   EVAL      BaseCcyDP = A6NBDP

      ** Get Funds Transfer ICD

     C                   CALL      'AOFTFRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY

      ** Database error

     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDFTFRPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get Euro currency details

     C**********         CallB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDGELR        Parm      SDGELR        DSSDY

      ** Database error

     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Eval      Euro = BkEuro

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
     C                   EVAL      DBASE = 008                                                CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *********************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2001
