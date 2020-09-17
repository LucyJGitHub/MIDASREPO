     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU S Tax Customer Position Take-on')          *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE006660 - EU TAX Customer position Take-On Trades and       *
      *             Depot Movements                                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This program sets up the records on ETCPOSND for all       *
      *    transactions from effective date                           *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CGL035             Date 01Mar05               *
      *                 235547             Date 11Aug05               *
      *                 235045             Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  235547 - Defaulting incorrect first time into program        *
      *  235045 - New EU Tax take-on                                  *
      *                                                               *
      *****************************************************************
 
     FSETRADL8  IF   E           K DISK
     FSECTY     IF   E           K DISK    PREFIX(SEC_)
     FPRICM     IF   E           K DISK    PREFIX(P_)
     FDPTMV     IF   E           K DISK    PREFIX(D_)
     FWKETCPTMVDO    E           K DISK    RENAME(TRADSDF:TRADF)
     FWKETCPDMVDO    E           K DISK    RENAME(DPTMVDF:DPTMF) PREFIX(D_)
 
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
     D ValidTrade    E DS                  EXTNAME(SEVTRADPD)
     D T_REC         E                     EXTFLD(RECI)
     D ValidDpmv     E DS                  EXTNAME(SEVDPMVPD) PREFIX(D_)
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Actn_Code       S              1A
     D Tr_Type         S              1A
     D DDOPDT          S              6A
     D ZNOML           S             15P 0
     D SCUMEX          S              1A
     D WRKFSPI         S             15P 9
     D WCNCD           S                   LIKE(DVCNCD)
     D WCOLC           S                   LIKE(BBCOLC)
     D WrkSesn         S                   LIKE(TDSS)
     D WrkBrca         S                   LIKE(TDBA)
     D WrkCust         S                   LIKE(TCNR)
     D KSesn           S                   LIKE(TDSS)
     D KBrca           S                   LIKE(TDBA)
     D KCust           S                   LIKE(TCNR)
     D KDate           S                   LIKE(TDVD)
     D TDate           S                   LIKE(TDVD)
     D NomCcyDec       S              1P 0
     D @Ccy            S              3A
     D C_TDVD          S                   LIKE(TDVD)                                         235547
 
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
     C                   EVAL      KCust = TCNR                                              CSD027A
     C                   EVAL      TDate = TDVD
     C                   ENDIF
 
     C* Depot Movement records
 
     C                   IF        *IN82 = '1'
     C                   MOVEL     DPBA          KBrca
     C                   MOVEL     DPSS          KSesn
     C**********         Z-ADD     DPBN          KCust                                       CSD027A
     C                   EVAL      KCust = DPBN                                              CSD027A
     C                   EVAL      TDate = DPMD
     C                   ENDIF
 
     C                   IF        *IN83 = '1'
     C                   MOVEL     DPBA          KBrca
     C                   MOVEL     DPSS          KSesn
     C**********         Z-ADD     DPBN          KCust                                       CSD027A
     C                   EVAL      KCust = DPBN                                              CSD027A
     C                   EVAL      TDate = DPDO
     C                   ENDIF
 
     C                   EXSR      SrRtvEff
     C                   Z-ADD     EWEDT1        KDate
     C                   IF        TDate >= EWEDT1
     C                             AND LiveCust = 'Y'
 
     C* Trade records
 
     C                   IF        *IN81 = '1'
     C                   EVAL      Tr_TYPE = 'T'
     C                   EVAL      Default = 'Y'
     C                   EXSR      SRVFPrice
     C                   MOVE      T_REC         RECI
     C                   EXSR      CALTAX
     C                   WRITE     TRADF
     C                   ENDIF
 
     C* Depot Movement records
 
     C                   IF        *IN82 = '1' OR *IN83 = '1'
     C     DptmKey       CHAIN     DPTMV                              89
     C                   EVAL      Tr_TYPE = 'D'
     C                   EXSR      SRDpFPrice
     C                   EVAL      D_FSPR = FSPR
     C                   EVAL      D_FSPP = FSPP
     C                   Z-ADD     0             D_DPVD
     C     D_DPMV        IFEQ      'WI'
     C                   Z-ADD     D_DPMD        D_DPVD
     C                   ELSE
     C                   Z-ADD     D_DPDO        D_DPVD
     C                   ENDIF
     C     D_DPVD        IFNE      0
     C                   WRITE     DPTMF
     C                   ENDIF
     C                   ENDIF
 
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
      /EJECT
      *****************************************************************
      ** Validate Fiscal Price
      *****************************************************************
     C     SRVFPrice     BEGSR
 
      ** Validate Fiscal Price
 
     C                   CALLB     'SEVSEFSPR2'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Default & Validate (Y or N)
 
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Fiscal Price  (16A)
 
     C                   PARM      *BLANK        DDFSPR           16
 
      ** Trade Date (5P 0)
 
     C                   PARM                    TDVD
 
      ** Security Details
 
     C                   PARM                    Security
 
      ** Investment Type Details
 
     C                   PARM                    SDINV
 
      ** Customer (Counterparty) Details
 
     C                   PARM                    CustDts
     C                   PARM                    BJDFIN
     C                   PARM                    TDBA
      ** Current File Trade Date                                                              235547
     C                   PARM      TDVD          C_TDVD                                       235547
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Price Ok INdicator (1A)
      ** Price (15P 8)
 
     C                   PARM                    DDFsprOk          1
     C                   PARM                    FSPR
     C                   PARM                    FSPP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDpFPrice - Validation routine for Fiscal Price              *
      *                                                               *
      *****************************************************************
 
     C     SRDpFPrice    BEGSR
 
     C                   Z-ADD     0             WRKFSPI
     C                   MOVE      'C'           SCUMEX
     C                   Z-ADD     D_DPNA        ZNOML
     C                   EVAL      DDOPDT = ''
 
     C                   CALLB     'SEVSEFSPR3'
     C                   PARM                    RetCodeIn
     C                   PARM      *BLANK        DDFSPR
     C                   PARM                    Security
     C                   PARM                    EWEDT1
     C                   PARM                    BJDFIN
     C                   PARM                    WRKFSPI
     C                   PARM                    SCUMEX
     C                   PARM                    ZNOML
     C                   PARM                    NomCcyDec
     C                   PARM                    D_DPMV
     C                   PARM                    D_DPBN
     C                   PARM                    D_DPBA
     C                   PARM                    DDOPDT
     C                   PARM                    PTFR
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDFSPROk
     C                   PARM                    FSPR
     C                   PARM                    FSPP
 
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
      * CALTAX - Calculate Tax                                        *
      *****************************************************************
     C     CALTAX        BEGSR
     C                   Z-ADD     0             EUTX
     C                   Z-ADD     0             EUTS
     C                   CALLB     'SEVTRADTAX'
 
      * INPUTS
 
      * Response Mode
     C                   PARM                    RetCodeIn        10
      * Valid Trade Details
     C                   PARM                    ValidTrade
      * Security Details
     C                   PARM                    Security
      * Process Flag
     C                   PARM      'I'           ProcFlag          1
 
      * OUTPUTS
 
      * EU Tax Screen Format
      * EU Tax in Nominal Currency File Format
      * EU Tax in Settlement Currency File Format
     C                   PARM                    DDEUTX           16
     C                   PARM                    EUTX
     C                   PARM                    EUTS
     C                   ENDSR
      *****************************************************************
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
(c) Finastra International Limited 2005
