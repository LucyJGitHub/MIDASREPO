     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Calc. Charge due to a single Charge Code')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000981  - FEES AND CHARGES: CALCULATE CHARGE DUE TO A      *
      *              SINGLE CHARGE CODE                               *
      *                                                               *
      *  Function:  Given the Payment Amount and the relevant         *
      *             Charge Code, this module will calculate the       *
      *             default charge.  This is achieved by summing      *
      *             the charges levied by each charge range as        *
      *             defined on PF/FTPCHGPD.                           *
      *             The final output is 2 arrays - one containing     *
      *             the chargeable amount by tier, the other holds    *
      *             the charge levied on each tier.  Both arrays      *
      *             are in Charges Currency.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249111             Date 24Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
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
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249111 - Partially applied fixes 241489/241487 and 245709.   *
      *           The fixes ensures that charge amount will be        *
      *           correctly computed based on range and when  charges *
      *           applied to the chargeable amount.                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
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
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       80  CHAIN indicator                                     *
      *                                                               *
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
 
      ** Array holding Chargeable Amount on each Tier
 
      ** Charge calculation arrays - Start amounts for each tier
      **                           - End amounts for each tier
      **                           - Rate for each tier
      **                           - Pro-Mile charge of each tier
      **                           - Minimum charge for each tier
      **                           - Maximum charge for each tier
      **                           - Charge for this tier
      **                           - Amount charged in this tier
     D StartArr        S             13P 0 DIM(11)
     D EndArr          S             13P 0 DIM(11)
     D RateArr         S             13P 8 DIM(11)
     D ProArr          S             13P 8 DIM(11)
     D MinArr          S             13P 0 DIM(11)
     D MaxArr          S             13P 0 DIM(11)
     D TierCharge      S             21P 0 DIM(11)
     D TierAmount      S             21P 0 DIM(11)
 
     D PowerArr        S              7  3 DIM(7) CTDATA
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Funds Transfer ICD
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Other entry parameters
     D ChargeCode      S                   LIKE(PYCHCD)
     D P_ChargeCode    S                   LIKE(PYCHCD)
     D STP             S              1A
     D P_STP           S                   Like(STP)
     D*P_ChargesDR     S             12                                                       CGL029
     D P_ChargesDR     S             18                                                       CGL029
     D P_ADDC          S              1
     D P_ChgDRCcy      S              3A                                                      CFT120
     D PTierCharge     S             13A   DIM(11)
     D PTierAmount     S             13A   DIM(11)
     D ADDC            S                   LIKE(P_ADDC)
     D ChargesDR       S                   LIKE(P_ChargesDR)
 
      ** Payment amount details
     D PayAmt          S             13P 0
     D P_PayAmt        S                   Like(PayAmt)
     D PayCcy          S              3A
     D P_PayCcy        S                   Like(PayCcy)
     D PayCcyDP        S                   LIKE(A6NBDP)
     D PayCcyMD        S                   LIKE(A6MDIN)
     D PaySpotRate     S                   LIKE(A6SPRT)
 
      * Settlement Currency Details
     D P_SettCcy       S                   Like(PayCcy)
     D P_SettAmt       S                   Like(PayAmt)
     D SettAmt         S                   Like(PayAmt)
     D SettCcy         S                   Like(PayCcy)
     D SettCcyDP       S                   LIKE(A6NBDP)
     D SettCcyMD       S                   LIKE(A6MDIN)
     D SettSpotRate    S                   LIKE(A6SPRT)
 
      ** Charge Currency details
     D ChgExch         S             13P 8
     D P_ChgExch       S                   Like(ChgExch)
     D ChgCcy          S              3A
     D P_ChgCcy        S                   Like(ChgCcy)
     D ChgCcyDP        S                   LIKE(A6NBDP)
     D ChgCcyMD        S                   LIKE(A6MDIN)
     D ChgSpotRate     S                   LIKE(A6SPRT)
 
      ** Other Currency details
     D OtherCcy        S              3A
     D OtherSpotRate   S                   LIKE(A6SPRT)
     D OtherCcyDP      S                   LIKE(A6NBDP)
     D OtherCcyMD      S                   LIKE(A6MDIN)
 
      ** Work fields for charge calculation
     D Thousands       S             10P 0
     D TotInChgCcy     S             13P 0
     D x               S              2S 0
 
      ** Parameters for ZRATE
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZRATEX          S             13P 8
     D ZMDIX           S              1A
 
      * Base Currency Details
     D BaseCcy         S                   LIKE(PayCcy)
     D BaseCcyDP       S                   LIKE(A6NBDP)
     D BaseCcyMD       S                   LIKE(A6MDIN)
 
     D ChgableAmt      S             13P 0
     D ChgDRCcy        S                   LIKE(P_ChgDRCcy)                                   CFT120
 
      *
     D ReferenceCcy    S                   LIKE(PayCcy)
     D ReferenceAmt    S                   LIKE(PayAmt)
     D ReferenceDP     S                   LIKE(A6NBDP)
     D ReferenceMD     S                   LIKE(A6MDIN)
     D ReferenceRate   S                   Like(ChgExch)
      *
     D OtherTransCcy   S                   LIKE(PayCcy)
     D OtherTransAmt   S                   LIKE(PayAmt)
     D OtherTransDP    S                   LIKE(A6NBDP)
     D OtherTransMD    S                   LIKE(A6MDIN)
     D OtherTransSpot  S                   Like(ChgExch)
      *
     D ReferenceRange  S              5
 
     D Conv_Rate       S                   Like(ZRATEX)
 
     D TransRate       S                   LIKE(A6SPRT)
 
     D CFT120          S              1A                                                      CFT120
                                                                                              CFT120
     D/COPY FTCPYSRC,FT0010D001
 
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
      *
      ** Initialise
     C                   EXSR      InitProc
 
     C                   CallB     'FTCALCRNG'
     C                   PARM                    RetCodeIn
     C                   PARM                    PayAmt
     C                   PARM                    PayCcy
     C                   PARM                    SettCcy
     C                   PARM                    ChgCcy
     C                   PARM                    ChgExch
     C                   PARM                    STP
     C                   PARM                    P_ChargeCode
     C                   PARM                    P_SettAmt
     C                   PARM                    P_ChargesDR
     C                   PARM                    P_ADDC
     C                   PARM                    P_ChgDRCcy                                   CFT120
     C                   PARM                    TotInChgCcy
     C                   PARM                    ChgableAmt
     C                   PARM                    StartArr
     C                   PARM                    Endarr
     C                   PARM                    RateArr
     C                   PARM                    ProArr
     C                   PARM                    MinArr
     C                   PARM                    MaxArr
 
     C                   EXSR      ChkEndArr
 
      *
      ** Decide whether charges are on a Tiered or Threshold basis and
      ** calculate charge per tier.
     C                   IF        STP = 'Y'
      *
     C                   IF        STPCMD = 'T'
     C                   EXSR      Tiered
     C                   ELSE
     C                   EXSR      Threshold
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        CALCMD = 'T'
     C                   EXSR      Tiered
     C                   ELSE
     C                   EXSR      Threshold
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Load output parameters (char) with tier charges and amounts (num)
     C                   EVAL      x = 1
      *
     C                   DOW       x < 12
     C                   If        TierCharge(x)  < 9999999999999
     C                   MOVE      TierCharge(x) PTierCharge(x)
     C                   Else
     C                   Eval      PTierCharge(x) = '9999999999999'
     C                   Endif
 
     C                   If        TierAmount(x)  < 9999999999999
     C                   MOVE      TierAmount(x) PTierAmount(x)
     C                   Else
     C                   Eval      PTierAmount(x) = '9999999999999'
     C                   Endif
 
     C                   EVAL      x = x + 1
     C                   ENDDO
      *
     C                   Eval      ChgAbleAmt = PayAmt
      *
     C                   RETURN
      *
      **********************************************************************
      /EJECT
      **********************************************************************
      * Threshold - Calculate Threshold charges                            *
      *           - Save charge for each tier to TierCharge                *
      *           - Save chargeable amount on each tier to TierAmount      *
      **********************************************************************
     C     Threshold     BEGSR
 
     C                   DO        11            x
     C                   IF        PayAmt < StartArr(x) OR
     C                             x > 1 AND StartArr(x) = 0 AND
     C                             PayAmt <= EndArr(x-1)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        X > 1
     C                   EVAL      X = X - 1
     C                   ENDIF
 
      *
      ** If not ProMile type, multiply Rate by Pay Amount
      ** If ProMile type, find number of thousands and multiply by ProMile
     C                   IF        ProArr(x) = *Zeros
     C                   EVAL (H)  TierCharge(x) = RateArr(x) * PayAmt
     C                   EVAL      TierAmount(x) = PayAmt
     C                   ELSE
     C                   Eval      Thousands = (Payamt *  +
     C                                          PowerArr(ChgCcyDP)) / 1000
     C                   EVAL (H)  TierAmount(x) = Thousands * 1000
 
     C                   EVAL (H)  TierCharge(x) = ProArr(x) * (Thousands / +
     C                                                      PowerArr(ChgCcyDP))
 
     C                   ENDIF
      *
      ** Charge for this tier cannot exceed Maximum or be less than Minimum
      *
     C                   IF        TierCharge(x) > MaxArr(x)  AND
     C                             MaxArr(x) <> *Zeros
     C                   EVAL      TierCharge(x) = MaxArr(x)
     C                   ENDIF
      *
     C                   IF        TierCharge(x) < MinArr(x)
     C                   EVAL      TierCharge(x) = MinArr(x)
     C                   ENDIF
 
      *
      * If by applying the charge the chargeable amount falls below the range start (1)
      *  use the range chargeable amount as the chargeable amount
     C                   If        X = 1 AND
     C                             Payamt - TierCharge(1) < StartArr(1)
     C                             AND P_ADDC = 'D'                                           249111
     C**********         Eval      TierCharge(1) = TierAmount(1)tArr(1)                       249111
     C                   Eval      TierCharge(1) = PayAmt - StartArr(1)                       249111
     C                   Endif
      *                                                                                       249111
      **  If range 1 and pay amount falls below range start, no charge is applicable          249111
      *                                                                                       249111
     C                   If        X = 1  And  PayAmt < StartArr(1)                           249111
     C                   EVAL      TierAmount(x) = *Zeros                                     249111
     C                   EVAL      TierCharge(x) = *Zeros                                     249111
     C                   Endif                                                                249111
      *
      ** Total Tiered charge in Charge Currency
     C                   XFOOT(H)  TierCharge    TotInChgCcy
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * Tiered - Calculate Tiered charges                                  *
      *           - Save charge for each tier to TierCharge                *
      *           - Save chargeable amount on each tier to TierAmount      *
      **********************************************************************
     C     Tiered        BEGSR
      *
     C                   DOW       x < 11
      *
      ** If blank tier, save last tier index and calc. Out of Band charge
     C                   IF        StartArr(x) = *Zeros  AND
     C                             EndArr(x) = *Zeros
     C                   LEAVE
      *
     C                   ELSE
      *
      ** If Pay Amount lies above this tier, charge on the End amount of
      ** this tier (using Rate or ProMile as appropriate).
     C                   IF        PayAmt >= EndArr(x)
 
     C                   If        StartArr(x) <>*Zeros
     C                   Eval      TierAmount(x) = (EndArr(x)-StartArr(x))+1
     C                   Else
     C                   Eval      TierAmount(x) = (EndArr(x)-StartArr(x))
     C                   Endif
      *
     C                   IF        ProArr(x) = *Zeros
     C                   EVAL (H)  TierCharge(x) = RateArr(x) * TierAmount(x)
     C                   ELSE
     C                   Eval      Thousands = (TierAmount(x) *  +
     C                                          PowerArr(ChgCcyDP)) / 1000
     C                   EVAL (H)  TierAmount(x) = Thousands * 1000
 
     C                   EVAL (H)  TierCharge(x) = ProArr(x) * (Thousands / +
     C                                              PowerArr(ChgCcyDP) )
 
     C                   ENDIF
      *
      ** ... Else Pay Amount falls in this tier - last charge is on portion
      **     in this tier.
     C                   ELSE
      **  If this is the first tier and the tier starts with zero, do
      **  not add one to the amount. Otherwise add one.
     C                   IF        x = 1 and StartArr(x) = 0
     C                   EVAL      TierAmount(x) = (PayAmt-StartArr(x))
     C                   ELSE
     C                   EVAL      TierAmount(x) = (PayAmt-StartArr(x)) + 1
     C                   ENDIF
 
     C                   IF        TierAmount(x) < *Zeros
     C                   EVAL      TierAmount(x) = *Zeros
     C                   EVAL      TierCharge(x) = *Zeros
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        ProArr(x) = *Zeros
     C                   EVAL (H)  TierCharge(x) = TierAmount(x) *
     C                                             RateArr(x)
     C                   ELSE
     C                   Eval      Thousands = (TierAmount(x) *  +
     C                                          PowerArr(ChgCcyDP)) / 1000
     C                   EVAL (H)  TierAmount(x) = Thousands * 1000
 
     C                   EVAL (H)  TierCharge(x) = ProArr(x) * (Thousands / +
     C                                              PowerArr(ChgCcyDP) )
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If PayAmt >= EndArr(x)')
      *
      ** Amount charged on this tier is limited by Max. and Min. amounts...
     C                   IF        TierCharge(x) > MaxArr(x)  AND
     C                             MaxArr(x) <> *Zeros
     C                   EVAL      TierCharge(x) = MaxArr(x)
     C                   ENDIF
      *
     C                   IF        TierCharge(x) < MinArr(x)
     C                   EVAL      TierCharge(x) = MinArr(x)
     C                   ENDIF
 
      *
      * If by applying the charge the chargeable amount falls below the range start (1)
      *  use the range chargeable amount as the chargeable amount
     C                   If        X = 1 AND
     C                             Payamt - TierCharge(1) < StartArr(1)
     C                   Eval      TierCharge(1) = TierAmount(1)
     C                   Endif
 
      *
     C                   ENDIF
      **                 (End of 'If EndArr(x) <> *Zeros')
      *
     C                   EVAL      x = x + 1
     C                   ENDDO
      *
      ** Total Tiered charge in Charge Currency
     C                   XFOOT(H)  TierCharge    TotInChgCcy
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * InitProc - Obtain charge definition details and initialise         *
      **********************************************************************
     C     InitProc      BEGSR
      *
      * If nothing to calculate, return
      *
     C                   IF        P_PayAmt <= 0
     C                   RETURN
     C                   ENDIF
      *
      * Enusre that we do not change passed parameters
      *
     C                   EVAL      PayCcy     = P_PayCcy
     C                   EVAL      PayAmt     = P_PayAmt
     C                   EVAL      ChgCcy     = P_ChgCcy
     C                   EVAL      ChgExch    = P_ChgExch
     C                   EVAL      STP        = P_STP
     C                   EVAL      ChargeCode = P_ChargeCode
     C                   EVAL      SettCcy    = P_SettCcy
     C                   EVAL      SettAmt    = P_SettAmt
     C                   EVAL      ChargesDR  = P_ChargesDR
     C                   EVAL      ADDC       = P_ADDC
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      ChgDRCcy = P_ChgDRCcy                                      CFT120
     C                   ENDIF                                                                CFT120
 
     C                   EVAL      ChgAbleAmt = 0
      * ---------------------------------------------------------------
      ** Access Charge Definition file
     C     ChargeCode    CHAIN     FTPCHGL0                           80
      *
      ** Database error
      *
     C                   IF        *IN80  = *On
     C                   EVAL      DBFile = 'FTPCHGPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKey  = ChargeCode
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * ---------------------------------------------------------------
      ** Get Funds Transfer ICD
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDFTFRPD'    DBFILE
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
      * ---------------------------------------------------------------
      ** Access Charge Currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ChgCcy        @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     ChgCcy        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Eval      ChgCcyDP    = A6NBDP
     C                   Eval      ChgCcyMD    = A6MDIN
     C                   Eval      ChgSpotRate = A6SPRT
 
     C                   If        ChgCcyDP = 0
     C                   Eval      ChgCcyDP = 4
     C                   Endif
 
      * ---------------------------------------------------------------
      ** Access Pay Currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PayCcy        @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     PayCcy        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Eval      PayCcyDP    = A6NBDP
     C                   Eval      PayCcyMD    = A6MDIN
     C                   Eval      PaySpotRate = A6SPRT
      * ---------------------------------------------------------------
      ** Reset arrays, work fields
      *
     C                   CLEAR                   StartArr
     C                   CLEAR                   EndArr
     C                   CLEAR                   RateArr
     C                   CLEAR                   ProArr
     C                   CLEAR                   MinArr
     C                   CLEAR                   MaxArr
     C                   CLEAR                   TierCharge
     C                   CLEAR                   TierAmount
      *
      * ===============================================================
      * If Charge Currency = Base currency, ensure that the exchange rate
      *  is 1.
     C                   If        ChgCcy  = BaseCcy
     C                   Eval      ChgExch = 1
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Check End Array
      *****************************************************************
     C     ChkEndArr     BEGSR
 
     C                   EVAL      x = 1
 
     C                   DO        11            X
     C                   IF        EndArr(x) = 0
     C                   EVAL      EndArr(x) = 9999999999999
     C                   ENDIF
     C                   ENDDO
 
     C                   EVAL      x = 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry parameters:
     C     *ENTRY        PLIST
      *
      * INPUTS:
      ** Return Code (10A)
      ** Payment Amount (13,0)
      ** Payment Currency (3A)
      ** Settlement Currency (3A)                                                             CFT120
      ** Charges Currency (3A)
      ** Exchange Rate from transaction (13,8)
      ** STP flag (1A)
      ** Payment Charge Code (5A)
      ** Settlement Amount                                                                    CFT120
      ** Charges to the DR of Account                                                         CFT120
      ** Add/Deduct Charges Flag                                                              CFT120
      ** Charges to the DR of Currency (3A)                                                   CFT120
      *                                                                                       CFT120
     C                   PARM                    RetCodeIn
     C                   PARM                    P_PayAmt
     C                   PARM                    P_PayCcy
     C                   PARM                    P_SettCcy
     C                   PARM                    P_ChgCcy
     C                   PARM                    P_ChgExch
     C                   PARM                    P_STP
     C                   PARM                    P_ChargeCode
     C                   PARM                    P_SettAmt
     C                   PARM                    P_ChargesDR
     C                   PARM                    P_ADDC
     C                   PARM                    P_ChgDRCcy                                   CFT120
      *
      * OUTPUTS:
      ** Total Charge (13,0)
      ** Chargeable Amount (13,0)
      ** Charge per Tier (11 x 13A)
      ** Amount being charged by Tier (11 x 13A)
     C                   PARM                    TotInChgCcy
     C                   PARM                    ChgableAmt
     C                   PARM                    PTierCharge
     C                   PARM                    PTierAmount
      *
      ** Move workstation ID to screen field, initialise program name
     C                   MOVEL     'FT000981'    DBPGM
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EVAL      DBASE  = 4
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Eval      BaseCcy = BJCYCD
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
      *                                                                                       CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 005                                                CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *
      *
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
      *
     C                   ENDSR
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
**  PowerArr
0000001
0000010
0000100
0001000
0010000
0100000
1000000
