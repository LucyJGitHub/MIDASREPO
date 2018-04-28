     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Tax Take-On Position for Mature Sec.')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEETCPMAT - EU TAX Customer position Take-On for Matured     *
      *              Securities Position                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *    This program sets up the records on ETCPOSND for all       *
      *    transactions from effective date                           *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027A            Date 05May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 237063             Date 20Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 235798  *CREATE    Date 30Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  257980 - Create opening position for Securities Matured      *
      *           between effective date and RUND                     *
      *                                                               *
      *****************************************************************
 
     FSETRADL8  IF   E           K DISK
     FSECTY     IF   E           K DISK    PREFIX(SEC_)
     FPRICM     IF   E           K DISK    PREFIX(P_)
     FDPTMV     IF   E           K DISK    PREFIX(D_)
     FETCPOSL0  UF A E           K DISK    PREFIX(E_)
     FSECDEPL4  IF   E           K DISK    PREFIX(C_)
     FCPOSH     IF   E           K DISK    PREFIX(S_)
 
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
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D Security      E DS                  EXTNAME(SECTYD) PREFIX(SEC_)
     D CDArr                 183    230
     D CRArr                 231    242
     D ValidTrade    E DS                  EXTNAME(SEVTRADPD)
     D T_REC         E                     EXTFLD(RECI)
     D ValidDpmv     E DS                  EXTNAME(SEVDPMVPD) PREFIX(D_)
 
     D ETCPOS        E DS                  EXTNAME(ETCPOSND)
     D E_REC         E                     EXTFLD(RECI)
     D E_PTFR        E                     EXTFLD(PTFR)
     D E_TMST        E                     EXTFLD(TMST)
      ** customer position for EU Savings tax
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for investment types
     D SDINV         E DS                  EXTNAME(INVTPD)
     D IN_LCD        E                     EXTFLD(LCD)
     D IN_CHTP       E                     EXTFLD(CHTP)
     D IN_TNLU       E                     EXTFLD(TNLU)
 
      ** External DS for Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Location Details
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** External DS for Securities Clients
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
 
      ** External DS for Customer
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D CUST_DFAC     E                     EXTFLD(QQDFAC)                                     CGL035
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
      ** Securities clients
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Array for manipulating decimal positions
     D POWER9          S              9  4 DIM(9) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Actn_Code       S              1A
     D Tr_Type         S              1A
     D DDOPDT          S              6A
     D ZNOML           S             15P 0
     D Rec_Exist       S              1A
     D SCUMEX          S              1A
     D WRKFSPI         S             15P 9
     D WCNCD           S                   LIKE(DVCNCD)
     D WCOLC           S                   LIKE(BBCOLC)
     D WrkSesn         S                   LIKE(TDSS)
     D WrkBrca         S                   LIKE(TDBA)
     D WrkCust         S                   LIKE(TCNR)
     D WrkLAVP         S             27P 8
     D WrkCSAV         S             29P 8
     D KSesn           S                   LIKE(TDSS)
     D KBrca           S                   LIKE(TDBA)
     D KCust           S                   LIKE(TCNR)
     D KDate           S                   LIKE(TDVD)
     D KCSMK           S                   LIKE(TDMI)
     D KPTFR           S                   LIKE(PTFR)
     D KTMST           S                   LIKE(TMST)
     D KDepot          S                   LIKE(C_CDPT)
     D TDate           S                   LIKE(TDVD)
     D NomCcyDec       S              1P 0
     D @Ccy            S              3A
     D Indx            S              1  0
 
      ** Interest Accrued (1)   (ZACCR)
     D ZACCRD          S             15P 0
      ** Interest Accrued (2)   (ZACCR)
     D ZACCXD          S             15P 1
      ** Pay/Rec/Zero Indicator (ZACCR)
     D ZRP             S              1A
      ** Interest rate     (ZRATE)
     D  IRATE          S             15P 9
      ** Next Coupon Date (ZNCD)
     D  NCD            S              5P 0 INZ(0)
      ** Last Coupon Date before Control Date  (ZLCD)
     D  ZZLCD          S              5P 0
      ** Start date
     D  ZSDATE         S              5P 0
      ** End date
     D  ZEDATE         S              5P 0
      ** Principal amount
     D ZAMT            S             15P 0
     D  ZDDAYS         S              5P 0
     D  ZECD           S              5P 0
     D  ZINTDD         S              5P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     ITRADSDF       81
     IDPTWIDF       82
     IDPTWODF       83
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
 
     C     *LOVAL        SETLL     SETRADL8
 
     C                   DOW       *IN60 = '0'
 
     C                   EVAL      *IN81 = '0'
     C                   EVAL      *IN82 = '0'
     C                   EVAL      *IN83 = '0'
 
     C                   READ      SETRADL8                               60
     C                   IF        *IN60 = '0'
 
     C* Trade records
 
     C                   IF        *IN81 = '1'
     C                   MOVEL     TDBA          KBrca
     C                   MOVEL     TDSS          KSesn
     C**********         Z-ADD     TCNR          KCust                                       CSD027A
     C                   Eval      KCust = TCNR                                              CSD027A
     C                   EVAL      TDate = TDVD
     C                   MOVE      TDMI          KCSMK
     C                   MOVE      PTFR          KPTFR
     C                   IF        TDTP = 'TP'
     C                   MOVE      DELF          KDepot
     C                   ELSE
     C                   MOVE      DELT          KDepot
     C                   ENDIF
     C                   ENDIF
 
     C* Depot Movement records
 
     C                   IF        *IN82 = '1'
     C                   MOVEL     DPBA          KBrca
     C                   MOVEL     DPSS          KSesn
     C**********         Z-ADD     DPBN          KCust                                       CSD027A
     C                   Eval      KCust = DPBN                                              CSD027A
     C                   EVAL      TDate = DPMD
     C                   MOVE      DPMK          KCSMK
     C                   MOVE      PTFR          KPTFR
     C                   MOVE      DPID          KDepot
     C                   ENDIF
 
     C                   IF        *IN83 = '1'
     C                   MOVEL     DPBA          KBrca
     C                   MOVEL     DPSS          KSesn
     C**********         Z-ADD     DPBN          KCust                                       CSD027A
     C                   Eval      KCust = DPBN                                              CSD027A
     C                   EVAL      TDate = DPDO
     C                   MOVE      DPMK          KCSMK
     C                   MOVE      PTFR          KPTFR
     C                   MOVE      DPOD          KDepot
     C                   ENDIF
 
     C                   EXSR      SrRtvEff
     C                   Z-ADD     EWEDT1        KDate
     C                   IF        TDate >= EWEDT1
     C                             AND LiveCust = 'Y'
     C                             AND SEC_RECI = 'M'
     C                   EXSR      Check_OB
     C                   IF        Rec_Exist = 'N'
     C                   EXSR      Create_Rec
     C                   ENDIF
 
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   SETON                                        LR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvEff - Retrieve Effective Date                            *
      *                                                               *
      *****************************************************************
     C     SrRtvEff      BEGSR
 
     C     WrkBrca       IFNE      KBrca
     C                   MOVEL     KBrca         @BRCA             3
     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCA
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   MOVE      KBrca         WrkBrca
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = KBrca
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     A8LCCD        @LCCD             3
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LCCD
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = A8LCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C     WrkCUST       IFNE      KCust
     C                   MOVE      'Y'           LiveCust          1
     C                   MOVEL     *BLANK        @PKEY1           10
     C                   MOVEL     KCust         @PKEY1
 
      ** Customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @PKEY1
     C                   PARM                    @PKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   MOVE      KCust         WrkCUST
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'N'           LiveCust          1
     C                   CLEAR                   SDCUST
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANK
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BBCUST        @SCKY             6
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   ENDIF
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           LiveCust          1
     C                   CLEAR                   SDSECS
     C                   END
     C                   ENDIF
 
      ** Tax basket
 
     C                   EVAL      WCNCD = DVCNCD
     C                   EVAL      WCOLC = DVCNCD
 
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNCD         @PCTRT            2
     C                   PARM      WCOLC         @PCTRR            2
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
     C                   IF        @RTCD = '*NRF   '
 
     C                   EVAL      WCOLC = *BLANK
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM      WCOLC         @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DBKEY = @PCTRT + ' ' + @PCTRR
     C                   EVAL      DBFILE = 'SDCTTXPD'
     C                   EVAL      DBASE = 6
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      BFCUST        CustNum
     C                   MOVE      BFACCD        CustAccd
     C                   MOVE      BFCYCD        CustCurr
     C                   MOVE      BFACSN        CustAcsq
     C                   MOVE      BFCLAS        CustClass
     C                   MOVEL     BFNDR1        BFDRF1
     C                   MOVEL     BFNDR2        BFDRF2
     C                   MOVE      BFDRF1        CustDpRef1
     C                   MOVE      BFDRF2        CustDpRef2
     C                   MOVE      BFPNP1        CustPNP1
     C                   MOVE      BFPNP2        CustPNP2
     C                   MOVE      BFTCD         CustTAXC
     C                   MOVE      BFASIN        CustAUTS
     C                   MOVE      BFTDCG        CustTDCG
 
     C                   EXSR      SRSecty
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRSecty  - Access security details                            *
      *                                                               *
      *****************************************************************
     C     SRSecty       BEGSR
 
     C     KSesn         CHAIN     SECTY
 
     C                   IF        NOT%FOUND(SECTY)
     C                   EVAL      DBKEY = KSesn
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBASE = 7
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      KSesn         WrkSesn
 
     C     KEYPR         SETLL     PRICM
     C     KEYPR         READE     PRICM                                  33
 
     C                   IF        *IN33 = '1'
     C                   EVAL      P_PEXI = 0
     C                   ENDIF
 
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    SEC_SITP
     C                   PARM                    SEC_NMCY
     C     SDINV         PARM      SDINV         DSFDY
 
     C                   IF        @Rtcd <> *BLANKS
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     SEC_NMCY      DBKEY
     C                   MOVE      SEC_SITP      DBKEY
     C                   MOVEL     'INVTPD'      DBFILE
     C                   EVAL      DBASE = 8
     C                   EXSR      *PSSR
     C                   END
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      SEC_NMCY      @Ccy
     C     SDCURR        PARM      SDCURR        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = SEC_NMCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 10
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        NomCcyDec
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * Check_OB - Check if opening Balance already exist in file     *
      *                                                               *
      *****************************************************************
     C     Check_OB      BEGSR
 
     C     ETKEY         SETLL     ETCPOSL0
     C     ETKEY         READE     ETCPOSL0                               88
     C                   IF        *IN88 = '0'
     C                   EVAL      Rec_Exist = 'Y'
     C                   ELSE
     C                   EVAL      Rec_Exist = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * Create_Rec - Create Opening Balance record in ETCPOSND        *
      *                                                               *
      *****************************************************************
     C     Create_Rec    BEGSR
 
      ** Get CDEPPD position on transition date (prior to movements on this date)
 
     C     EWEDT1        SUB       1             PosnDate          5 0
     C     CDKEY         SETGT     SECDEPL4
     C     CDKEY         READPE    SECDEPL4                               99
     C   99              Z-ADD     0             C_CDNV
     C
     C                   IF        C_CDNV <> 0
 
     C     CPosKey       CHAIN     CPOSH                              88
 
     C                   EVAL      E_CSNV = C_CDNV
     C                   EVAL      Indx = 5 - Sec_NMDP + NomCcyDec
 
     C                   IF        S_CSNV <> 0
 
     C                   IF        S_CSNV = 0
     C                   EVAL      E_APNC = 0
     C                   ELSE
     C                   EVAL      E_APNC = S_CSPV * E_CSNV / S_CSNV
     C                   ENDIF
 
     C                   EVAL      WrkLAVP = E_APNC / E_CSNV
     C                   EVAL      WrkLAVP = WrkLAVP / POWER9(Indx)
     C                   Z-ADD     WrkLAVP       E_LAVP
     C                   ELSE
     C                   EVAL      E_LAVP = 0
     C                   ENDIF
 
     C                   IF        Sec_SPBS = 'P'
     C                   EVAL      E_LAVP = E_LAVP * 100
     C                   ENDIF
     C                   EVAL      WrkCSAV = E_CSNV * E_AVFP * POWER9(Indx)
     C                   Z-ADD     WrkCSAV       E_CSAV
     C                   IF        SEC_SPBS = 'P'
     C                   EVAL      E_CSAV = E_CSAV / 100
     C                   ENDIF
     C                   EVAL      E_SAPD = EWEDT1 * E_CSNV
 
     C                   IF        PROT <> '2' AND PROT <> '4'
     C                             AND PROT <> '7'
     C                   EXSR      CalInt
     C                   EVAL      E_CSPI = ZACCRD
 
     C                   IF        PROT = '8'
     C                   EVAL      E_CSPI = E_CSPI * SEC_CFCT
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      E_CSPI = 0
     C                   ENDIF
 
     C                   EVAL      E_CSMK = C_CDMK
     C                   EVAL      E_PTFR = C_PTFR
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    E_TMST
 
     C                   WRITE     ETCPOSNDF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CalInt  - Retrieve Effective Date                            *
      *                                                               *
      *****************************************************************
     C     CalInt        BEGSR
      *
      ***  Determine Coupon Dates prior to and after the Value Date
      *
     C                   Z-ADD     EWEDT1        ZECD
     C                   EXSR      ZLCD
 
     C                   CALLB     'ZNCD'
     C                   PARM                    SEC_ITLD
     C                   PARM                    SEC_FCPN
     C                   PARM                    SEC_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    EWEDT1
     C                   PARM                    BJDFIN
     C                   PARM                    SEC_NMCY
     C                   PARM                    SEC_SITP
     C                   PARM                    SEC_BCNV
     C                   PARM                    ZZLCD
     C                   PARM                    SEC_HCY1                                     237063
     C                   PARM                    SEC_HCY2                                     237063
     C                   PARM                    SEC_HCY3                                     237063
     C                   PARM                    SEC_HCY4                                     237063
     C                   PARM                    SEC_HCY5                                     237063
     C                   PARM                    SEC_HCY6                                     237063
     C                   PARM                    SEC_HCY7                                     237063
     C                   PARM                    SEC_HCY8                                     237063
     C                   PARM                    SEC_HCY9                                     237063
     C                   PARM                    NCD
      *
      ** Store the value of Last Change Date for comparison later.
      *
     C                   Z-ADD     ZZLCD         ZZLCD1            5 0
      *
      ***  Set up the Start and End Dates...
      ***  IF Cum-Coupon, just calculate from the Last Coupon Date to
      ***  the Event Control Date. For Ex-coupon, calculate on up to
      ***  the Next Coupon Date and subtract the Cum-Coupon portion.
      *
     C                   Z-ADD     ZZLCD         ZSDATE
     C                   Z-ADD     EWEDT1        ZEDATE
 
     C                   CALLB     'ZACCR'
     C                   PARM      E_CSNV        ZAMT
     C                   PARM      SEC_CPNR      IRATE
     C                   PARM                    ZSDATE
     C                   PARM                    ZEDATE
     C                   PARM                    Security
     C                   PARM                    DADJN             1
     C                   PARM                    NCD
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    BJDFIN
     C                   PARM                    ZACCRD
     C                   PARM                    ZACCXD
     C                   PARM                    ZRP
     C                   PARM                    ZDDAYS
     C                   PARM                    ZINTDD
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZPCINT in this module executes another standard subroutine,      *
      *   ZLCD, which has also been converted to a module.                 *
      *  This subroutine is also called ZLCD and simply does a CALLB to    *
      *   the module that contains subroutine ZLCD                         *
      *                                                                    *
     C     ZLCD          BEGSR
 
     C                   CALLB     'ZLCD'
     C                   PARM                    SEC_ISSD
     C                   PARM                    SEC_ITLD
     C                   PARM                    SEC_FCPN
     C                   PARM                    SEC_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    SEC_LCPN                                   BUG11164
     C                   PARM                    ZECD
     C                   PARM                    BJDFIN
      *
      ** Nominal Currency
      ** Security Investment Type
      ** Effect on Holidays on Coupon Dates
     C                   PARM                    SEC_NMCY
     C                   PARM                    SEC_SITP
     C                   PARM                    SEC_BCNV
     C                   PARM                    SEC_HCY1                                     237063
     C                   PARM                    SEC_HCY2                                     237063
     C                   PARM                    SEC_HCY3                                     237063
     C                   PARM                    SEC_HCY4                                     237063
     C                   PARM                    SEC_HCY5                                     237063
     C                   PARM                    SEC_HCY6                                     237063
     C                   PARM                    SEC_HCY7                                     237063
     C                   PARM                    SEC_HCY8                                     237063
     C                   PARM                    SEC_HCY9                                     237063
     C                   PARM                    ZZLCD
 
     C                   ENDSR
      **********************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   END
 
      ** Define key list for file
 
     C     KEYTD         KLIST
     C                   KFLD                    KBrca
     C                   KFLD                    KSesn
     C                   KFLD                    KCust
 
     C     KEYTDD        KLIST
     C                   KFLD                    KBrca
     C                   KFLD                    KSesn
     C                   KFLD                    KCust
     C                   KFLD                    KDate
 
     C     KEYPR         KLIST
     C                   KFLD                    KSesn
     C                   KFLD                    EWEDT1
 
     C     DptmKey       KLIST
     C                   KFLD                    DPSS
     C                   KFLD                    DPRN
 
     C     ETKey         KLIST
     C                   KFLD                    KBrca
     C                   KFLD                    KCust
     C                   KFLD                    KSesn
     C                   KFLD                    KCSMK
     C                   KFLD                    KPTFR
     C                   KFLD                    KDate
 
     C     CDKEY         KLIST
     C                   KFLD                    KBrca
     C                   KFLD                    KSesn
     C                   KFLD                    KDepot
     C                   KFLD                    KCSMK
     C                   KFLD                    KCust
     C                   KFLD                    KPTFR
     C                   KFLD                    PosnDate
 
     C     CposKey       KLIST
     C                   KFLD                    KBrca
     C                   KFLD                    KSesn
     C                   KFLD                    KCust
     C                   KFLD                    PosnDate
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
**  POWER9 - ARRAY OF POWERS FOR CURRENCY CONVERSION
000000001
000000010
000000100
000001000
000010000
000100000
001000000
010000000
100000000
