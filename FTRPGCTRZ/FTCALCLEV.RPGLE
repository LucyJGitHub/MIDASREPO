     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Calculate levied charge')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  CalcLevied  FEES AND CHARGES: CALCULATE LEVIED CHARGE        *
      *                                                               *
      *  Function:  Given the Payment Amount and the relevant         *
      *             currencies, this module will calculate the        *
      *             levied charge.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 255710             Date 04Aug08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CER001             Date 25Apr05               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 29Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255710 - Incorrect calculation of commission. Applied 248177 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
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
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Funds Transfer ICD details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure                                          220004
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     220004
                                                                                              220004
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Currency definitions
     D P_ChgCcy        S              3
     D P_PayCcy        S                   Like(P_ChgCcy)
     D P_SettCcy       S                   Like(P_ChgCcy)
     D P_LevCcy        S                   Like(P_ChgCcy)
     D P_OtherCcy      S                   Like(P_ChgCcy)
     D FromCcy         S                   Like(P_ChgCcy)
     D ToCcy           S                   Like(P_ChgCcy)
 
      * Currency attribures
     D PayCcyDP        S                   LIKE(A6NBDP)
     D PayCcyMD        S                   LIKE(A6MDIN)
     D PaySpotRate     S                   LIKE(A6SPRT)
 
     D ChgCcyDP        S                   LIKE(PayCcyDP)
     D ChgCcyMD        S                   LIKE(PayCcyMD)
     D ChgSpotRate     S                   LIKE(PaySpotRate)
 
     D SettCcyDP       S                   LIKE(PayCcyDP)
     D SettCcyMD       S                   LIKE(PayCcyMD)
     D SettSpotRate    S                   LIKE(PaySpotRate)
 
     D LeviedCcyDP     S                   LIKE(PayCcyDP)
     D LeviedCcyMD     S                   LIKE(PayCcyMD)
     D LeviedSpotRate  S                   LIKE(PaySpotRate)
 
     D FromCcyDP       S                   LIKE(PayCcyDP)
     D FromCcyMD       S                   LIKE(PayCcyMD)
     D FromSpotRate    S                   LIKE(PaySpotRate)
 
     D ToCcyDP         S                   LIKE(PayCcyDP)
     D ToCcyMD         S                   LIKE(PayCcyMD)
     D ToSpotRate      S                   LIKE(PaySpotRate)
 
     D @Ccy            S                   Like(P_PayCcy)
 
      * Charge definitions
     D P_ChgAmt        S             13  0
     D LevCharge       S                   Like(P_ChgAmt)
 
      * Exchange Rate Definitions
     D P_TransR        S             13  8
     D ExchRate        S                   Like(P_TransR)
 
      * Levied charge returned in formatted form
     D LevChargeF      S             16
 
      * Work Variables
     D ZField          S                   Like(LevChargeF)
 
      ** Work fields used by ZXRATE
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZRATEX          S             13P 8
     D ZMDIX           S              1A
 
      * Work Fields for ZEdit
     D ZADEC           S              1  0
 
      * FT0010 parameter data structure
     D P#0010          DS           256
     D  P#NDCY                 1      3
     D  P#NDAM                 4     10P 0
     D  P#DBCY                11     13
     D  P#DBAM                14     20P 0
     D  P#DBDT                21     23P 0
     D  P#CRCY                24     26
     D  P#CRAM                27     33P 0
     D  P#PDCY                34     36
     D  P#PDAM                37     43P 0
     D  P#CRDT                44     46P 0
     D  P#RATE                47     53P 8
     D  P#MDIN                54     54  0
     D  P#OVRT                55     55
     D  P#SDIN                56     56
     D  P#RTDS                57     59P 4
      *
     D  P#FRCY                11     13
     D  P#FRAM                14     20P 0
     D  P#FRDT                21     23P 0
     D  P#TOCY                24     26
     D  P#TOAM                27     33P 0
     D  P#TODT                44     46P 0
      *
     D  P#PMSQ                60     69
     D  P#INDC                70     74
     D  P#RTCD                75     81
     D  P#INTC                82     99  3
     D  P#INTD               100    117  3
 
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
 
 
     C                   Exsr      GetCurr
 
     C                   Select
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      * 1.  Charge Currency and Levied currency are the same
     C                   When      P_ChgCcy      = P_LevCcy
     C                   Eval      LevCharge     = P_ChgAmt
     C                   Exsr      FormatLevied
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      **2.*Transaction*rates*are*used.**Charge*and*Levied*currencies*are                      255710
      *****the*same*as*pay*and*settlement*currencies.**Convert*from*charge ccy                255710
      *****to*levied*ccy*using*TRANSACTION*rate************************                       255710
      *****************************************************************                       255710
     C**********         When      P_SettCcy     = P_ChgCcy      AND                          255710
     C**********                   P_PayCcy      = P_LevCcy      OR                           255710
     C**********                   P_SettCcy     = P_LevCcy      AND                          255710
     C**********                   P_PayCcy      = P_ChgCcy                                   255710
      *****************************************************************                       255710
     C**********         Eval      FromCcy       = P_ChgCcy                                   255710
     C**********         Eval      FromCcyMD     = ChgCcyMD                                   255710
     C**********         Eval      FromCcyDP     = ChgCcyDP                                   255710
     C**********         Eval      FromSpotRate  = ChgSpotRate                                255710
      *****************************************************************                       255710
     C**********         Eval      ToCcy         = P_LevCcy                                   255710
     C**********         Eval      ToCcyMD       = LeviedCcyMD                                255710
     C**********         Eval      ToCcyDP       = LeviedCcyDP                                255710
     C**********         Eval      ToSpotRate    = LeviedSpotRate                             255710
      *****************************************************************                       255710
      **Call*Get_Rate*for*mult*/*div*indicator*************************                       255710
     C**********         Exsr      Get_Rate                                                   255710
      *****************************************************************                       255710
      **Override*rate*with*transaction*rate*if*required.***************                       255710
     C**********         If        CHTRCY        = 'Y'                                        255710
     C**********         If        P_TransR < 1                                               255710
     C**********         Eval      ExchRate = 1 / P_TransR                                    255710
     C**********         Else                                                                 255710
     C**********         Eval      ExchRate      = P_TransR                                   255710
     C**********         Endif                                                                255710
     C**********         Endif                                                                255710
      *****************************************************************                       255710
     C**********         Eval      INPAMT        = P_ChgAmt                                   255710
      *****************************************************************                       255710
     C**********         Exsr      Convert                                                    255710
     C**********         Exsr      FormatLevied                                               255710
      *****************************************************************                       255710
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      **3.*Charge*currency*is*one*of*settlement*OR*pay*currencies*but*the levied              255710
      *****currency*is*not.**Convert*first*to*the*other*currency*(pay or settle)              255710
      *****using*transaction*rate*and*then*to*levied*ccy*using*spot*rate                      255710
      *****************************************************************                       255710
     C**********         When      P_SettCcy     = P_ChgCcy       AND                         255710
     C**********                   P_PayCcy      <> P_LevCcy      OR                          255710
     C**********                   P_SettCcy     <> P_LevCcy      AND                         255710
     C**********                   P_PayCcy      = P_ChgCcy                                   255710
      *****************************************************************                       255710
     C**********         Eval      INPAMT        = P_ChgAmt                                   255710
      *****************************************************************                       255710
     C**********         If        P_ChgCcy      = P_SettCcy                                  255710
     C**********         Eval      ToCcy         = P_PayCcy                                   255710
     C**********         Eval      ToSpotRate    = PaySpotRate                                255710
     C**********         Eval      ToCcyMD       = PayCcyMD                                   255710
     C**********         Eval      ToCcyDP       = PayCcyDP                                   255710
      *****************************************************************                       255710
     C**********         Eval      FromCcy       = P_ChgCcy                                   255710
     C**********         Eval      FromSpotRate  = ChgSpotRate                                255710
     C**********         Eval      FromCcyMD     = ChgCcyMD                                   255710
     C**********         Eval      FromCcyDP     = ChgCcyDP                                   255710
     C**********         Eval      ZMDIX         = ChgCcyMD                                   255710
     C**********         Else                                                                 255710
     C**********         Eval      ToCcy         = P_SettCcy                                  255710
     C**********         Eval      ToSpotRate    = SettSpotRate                               255710
     C**********         Eval      ToCcyMD       = SettCcyMD                                  255710
     C**********         Eval      ToCcyDP       = SettCcyDP                                  255710
     C**********         Eval      FromCcy       = P_ChgCcy                                   255710
     C**********         Eval      FromSpotRate  = ChgSpotRate                                255710
     C**********         Eval      FromCcyMD     = ChgCcyMD                                   255710
     C**********         Eval      FromCcyDP     = ChgCcyDP                                   255710
     C**********         Eval      ZMDIX         = ChgCcyMD                                   255710
     C**********         Endif                                                                255710
      *****************************************************************                       255710
      **Get*multiply*/*divide*indicator*and*rate***********************                       255710
     C**********         Exsr      Get_Rate                                                   255710
      *****************************************************************                       255710
      **Override*rate*with*transaction*rate*if*required****************                       255710
     C**********         If        CHTRCY        = 'Y'                                        255710
     C**********         If        P_TransR < 1                                               255710
     C**********         Eval      ExchRate = 1 / P_TransR                                    255710
     C**********         Else                                                                 255710
     C**********         Eval      ExchRate      = P_TransR                                   255710
     C**********         Endif                                                                255710
     C**********         Endif                                                                255710
      *****************************************************************                       255710
      **Convert*from*OTHER*(pay*or*Settle)*ccy*to*Charge*Ccy***********                       255710
     C**********         Exsr      Convert                                                    255710
      *****************************************************************                       255710
     C**********         Eval      INPAMT        = LevCharge                                  255710
      *****************************************************************                       255710
      **Now*convert*from*OtherCcy*(TO)*to*Levied*ccy*using*spot*rate***                       255710
     C**********         Eval      FromCcy       = ToCcy                                      255710
     C**********         Eval      FromCcyDP     = ToCcyDP                                    255710
     C**********         Eval      FromSpotRate  = ToSpotRate                                 255710
     C**********         Eval      FromCcyMD     = ToCcyMD                                    255710
      *****************************************************************                       255710
     C**********         Eval      ToCcy         = P_LevCcy                                   255710
     C**********         Eval      ToSpotRate    = LeviedSpotRate                             255710
     C**********         Eval      ToCcyMD       = LeviedCcyMD                                255710
     C**********         Eval      ToCcyDP       = LeviedCcyDP                                255710
      *****************************************************************                       255710
     C**********         Exsr      Get_Rate                                                   255710
      *****************************************************************                       255710
     C**********         Exsr      Convert                                                    255710
      *****************************************************************                       255710
     C**********         Exsr      FormatLevied                                               255710
      *****************************************************************                       255710
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      **4.**Transaction*rates*are*used.**Levied*ccy*is*one*of*settlement pay ccy              255710
      ***but*charge*ccy*is*not,*convert*to*Other*ccy*using*spot*rate*then                     255710
      ***to*levied*using*transaction*rate.*****************************                       255710
     C**********         When      P_SettCcy     =  P_LevCcy       AND                        255710
     C**********                   P_PayCcy      <> P_ChgCcy       OR                         255710
     C**********                   P_SettCcy     <> P_ChgCcy       AND                        255710
     C**********                   P_PayCcy      =  P_LevCcy                                  255710
      *****************************************************************                       255710
     C**********         If        P_LevCcy      = P_PayCcy                                   255710
     C**********         Eval      ToCcy         = P_SettCcy                                  255710
     C**********         Eval      ToSpotRate    = SettSpotRate                               255710
     C**********         Eval      ToCcyMD       = SettCcyMD                                  255710
     C**********         Eval      ToCcyDP       = SettCcyDP                                  255710
      *****************************************************************                       255710
     C**********         Eval      FromCcy       = P_ChgCcy                                   255710
     C**********         Eval      FromSpotRate  = ChgSpotRate                                255710
     C**********         Eval      FromCcyMD     = ChgCcyMD                                   255710
     C**********         Eval      FromCcyDP     = ChgCcyDP                                   255710
      *****************************************************************                       255710
     C**********         Else                                                                 255710
     C**********         Eval      ToCcy         = P_PayCcy                                   255710
     C**********         Eval      ToSpotRate    = PaySpotRate                                255710
     C**********         Eval      ToCcyMD       = PayCcyMD                                   255710
     C**********         Eval      ToCcyDP       = PayCcyDP                                   255710
      *****************************************************************                       255710
     C**********         Eval      FromCcy       = P_ChgCcy                                   255710
     C**********         Eval      FromSpotRate  = ChgSpotRate                                255710
     C**********         Eval      FromCcyMD     = ChgCcyMD                                   255710
     C**********         Eval      FromCcyDP     = ChgCcyDP                                   255710
     C**********         Endif                                                                255710
      *****************************************************************                       255710
      **Get*cross*rate*(spot)*for*these*currencies.********************                       255710
     C**********         Exsr      Get_Rate                                                   255710
      *****************************************************************                       255710
     C**********         Eval      INPAMT        = P_ChgAmt                                   255710
      *****************************************************************                       255710
      **Convert*amount*************************************************                       255710
     C**********         Exsr      Convert                                                    255710
      *****************************************************************                       255710
      **Use*calculated*amount*as*input*into*second*conversion**********                       255710
     C**********         Eval      INPAMT        = LevCharge                                  255710
      *****************************************************************                       255710
      **Now*convert*to*levied*currency*if*other*currency*is*<>*levied*ccy                     255710
      *****************************************************************                       255710
     C**********         Eval      FromSpotRate  = ToSpotRate                                 255710
     C**********         Eval      FromCcyDP     = ToCcyDP                                    255710
     C**********         Eval      FromCcy       = ToCcy                                      255710
     C**********         Eval      FromCcyMD     = ToCcyMD                                    255710
      *****************************************************************                       255710
     C**********         Eval      ToSpotRate    = LeviedSpotRate                             255710
     C**********         Eval      ToCcyDP       = LeviedCcyDP                                255710
     C**********         Eval      ToCcyMD       = LeviedCcyMD                                255710
     C**********         Eval      ToCcy         = P_LevCcy                                   255710
      *****************************************************************                       255710
      **Get*multiply*and*divide*indicators*****************************                       255710
     C**********         Exsr      Get_Rate                                                   255710
      *****************************************************************                       255710
      **Override*rate*if*required**************************************                       255710
     C**********         If        CHTRCY        = 'Y'                                        255710
     C**********         If        P_TransR < 1                                               255710
     C**********         Eval      ExchRate = 1 / P_TransR                                    255710
     C**********         Else                                                                 255710
     C**********         Eval      ExchRate      = P_TransR                                   255710
     C**********         Endif                                                                255710
     C**********         Endif                                                                255710
      *****************************************************************                       255710
     C**********         Exsr      Convert                                                    255710
      *****************************************************************                       255710
     C**********         Exsr      FormatLevied                                               255710
      *****************************************************************                       255710
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      * Otherwise just convert from charge ccy to levied using spot rates.
     C                   Other
 
     C                   Eval      FromCcy = P_ChgCcy                                         255710
     C                   Eval      FromSpotRate  = ChgSpotRate
     C                   Eval      FromCcyMD     = ChgCcyMD
     C                   Eval      FromCcyDP     = ChgCcyDP
     C                   Eval      ToCcy = P_LevCcy                                           255710
     C                   Eval      ToSpotRate    = LeviedSpotRate
     C                   Eval      ToCcyDP       = LeviedCcyDP
     C                   Eval      ToCcyMD       = LeviedCcyMD
 
     C                   Eval      INPAMT        = P_ChgAmt                                   255710
     C                   Exsr      Get_rate
 
     C                   Exsr      Convert
 
     C                   Exsr      FormatLevied
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
     C                   Endsl
 
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * GetCurr - Get Currency Definitions
      *****************************************************************
     C     GetCurr       BEGSR
 
      **Pay*Currency***************************************************                       255710
     C**********         CALL      'AOCURRR0'                                                 255710
     C**********         PARM      *Blanks       @RTCD                                        255710
     C**********         PARM      '*KEY   '     @OPTN                                        255710
     C**********         PARM      P_PayCcy      @CCY                                         255710
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C*****SDCURR        PARM      SDCURR        DSSDY                                 220004 255710
      *****************************************************************                       255710
      **Database*error*************************************************                       255710
     C**********         IF        @RTCD <> *Blanks                                           255710
     C**********         MOVEL     'SDCURRPD'    DBFILE                                       255710
     C**********         EVAL      DBASE  = 1                                                 255710
     C**********         MOVEL     P_PayCcy      DBKEY                                        255710
     C**********         EXSR      *PSSR                                                      255710
     C**********         ENDIF                                                                255710
      *****************************************************************                       255710
     C**********         EVAL      PayCcyDP      = A6NBDP                                     255710
     C**********         EVAL      PayCcyMD      = A6MDIN                                     255710
     C**********         EVAL      PaySpotRate   = A6SPRT                                     255710
      *****************************************************************                       255710
      * =========================================================
      **Settlement*Currency********************************************                       255710
     C**********         CALL      'AOCURRR0'                                                 255710
     C**********         PARM      *Blanks       @RTCD                                        255710
     C**********         PARM      '*KEY   '     @OPTN                                        255710
     C**********         PARM      P_SettCcy     @CCY                                         255710
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C*****SDCURR        PARM      SDCURR        DSSDY                                 220004 255710
      *****************************************************************                       255710
      **Database error*************************************************                       255710
     C**********         IF        @RTCD <> *Blanks                                           255710
     C**********         MOVEL     'SDCURRPD'    DBFILE                                       255710
     C**********         EVAL      DBASE  = 2                                                 255710
     C**********         MOVEL     P_SettCcy     DBKEY                                        255710
     C**********         EXSR      *PSSR                                                      255710
     C**********         ENDIF                                                                255710
      *****************************************************************                       255710
     C**********         EVAL      SettCcyDP     = A6NBDP                                     255710
     C**********         EVAL      SettCcyMD     = A6MDIN                                     255710
     C**********         EVAL      SettSpotRate  = A6SPRT                                     255710
      *****************************************************************                       255710
      * =========================================================
      * Charge Currency
      *                                                                                       CER001
      ** Default with Settlement currency if blank                                            CER001
      *                                                                                       CER001
     C                   If        P_ChgCcy = *blanks                                         CER001
     C                   EVAL      P_ChgCcy = P_SettCcy                                       CER001
     C                   Endif                                                                CER001
      *                                                                                       CER001
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      P_ChgCcy      @CCY
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EVAL      DBASE  = 3
     C                   MOVEL     P_ChgCcy      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ChgCcyDP      = A6NBDP
     C                   EVAL      ChgCcyMD      = A6MDIN
     C                   EVAL      ChgSpotRate   = A6SPRT
 
      * =========================================================
      * Levied Currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      P_LevCcy      @CCY
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EVAL      DBASE         = 4
     C                   MOVEL     P_LevCcy      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      LeviedCcyDP    = A6NBDP
     C                   EVAL      LeviedCcyMD    = A6MDIN
     C                   EVAL      LeviedSpotRate = A6SPRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FormatLevied - Formats levied charge to 14 character field
      *****************************************************************
     C     FormatLevied  BEGSR
 
     C                   Move      LevCharge     ZField
     C                   Eval      ZADEC         = LeviedCcyDP
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        LevChargeF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GetRate - Get cross rate between two currencies
      *****************************************************************
     C     Get_Rate      Begsr
 
     C                   Clear                   P#0010
 
     C                   Eval      P#FRCY = FromCcy
     C                   Eval      P#TOCY = ToCcy
     C                   Eval      P#FRAM = P_ChgAmt
     C                   Eval      P#FRDT = BJRDNB
     C                   Eval      P#TODT = BJRDNB
     C                   Eval      P#TOAM = 0
     C                   Eval      P#Rate = 0
 
     C                   Call      'FT0010'
     C                   Parm                    P#0010
 
     C                   Eval      ExchRate      = P#RATE
 
     C                   If        P#MDIN = 1
     C                   Eval      ZMDIX = 'M'
     C                   Else
     C                   Eval      ZMDIX = 'D'
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Convert - Convert currencies
      *****************************************************************
     C     Convert       BEGSR
 
     C                   Eval      CVTRAT        = ExchRate
     C                   Eval      BASMD         = ZMDIX
     C                   Eval      FrmCcy        = FromCcy
     C                   Eval      FRMDEC        = FromCcyDP
     C                   Eval      TODEC         = ToCcyDP
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    INPAMT           15 0
     C                   PARM                    CVTRAT           13 8
     C                   PARM                    BASMD             1
     C                   PARM                    FRMCCY            3
     C                   PARM                    TOCCY
     C                   PARM                    FRMDEC            1 0
     C                   PARM                    TODEC             1 0
     C                   PARM                    OUTAMT           15 0
 
     C                   Eval      LevCharge    = OUTAMT
 
     C                   Endsr
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
      ** Charge Amount (13,0) (In charge currency)
      ** Payment Currency (3A)
      ** Settlement Currency (3A)
      ** Charges Currency (3A)
      ** Levied Currency (3A)
      ** Exchange Rate from transaction (13,8)
     C                   PARM                    RetCodeIn
     C                   PARM                    P_ChgAmt
     C                   PARM                    P_PayCcy
     C                   PARM                    P_SettCcy
     C                   PARM                    P_ChgCcy
     C                   PARM                    P_LevCcy
     C                   PARM                    P_TransR
      *
      * OUTPUTS:
      ** Levied Charge in UNEDITED FORMAT
     C                   PARM                    LevCharge
      ** Levied Charge in EDITED FORMAT
     C                   PARM                    LevChargeF
      *
      ** Move workstation ID to screen field, initialise program name
     C                   MOVEL     'CALCLEVIED'  DBPGM
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
     C                   EVAL      DBASE         = 1
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Funds Transfer ICD details.
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      ** Database error.
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDFTFRPD'    DBFILE
     C                   EVAL      DBASE         = 2
     C                   EXSR      *PSSR
     C                   ENDIF
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
(c) Misys International Banking Systems Ltd. 2001
