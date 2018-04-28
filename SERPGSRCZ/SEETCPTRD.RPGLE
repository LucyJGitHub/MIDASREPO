     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Saving Tax Take-On Trades & Dpt Mvts')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEETCPTRD - EU TAX Customer position Take-On Trades and      *
      *              Depot Movements                                  *
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
      *                 243028             Date 24Oct06               *
      *                 CSD027A            Date 05May06               *
      *                 CGL035             Date 01Mar05               *
      *                 235547             Date 11Aug05               *
      *                 236701             Date 02Jul05               *
      *                 234577             Date 30Jun05               *
      *                 236700             Date 28Jun05               *
      *                 236699             Date 27Jun05               *
      *                 234440  *CREATE    Date 18Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  243028 - To extract only transactions for Discretionary      *
      *           and Safe Custody customers                          *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  235547 - Defaulting incorrect first time into program        *
      *  236701 - Customer database errors not required               *
      *  234577 - Get cutover date for branch not customer            *
      *  236700 - No fiscal price on positions                        *
      *  236699 - SECTY must be accessed for each security processed  *
      *  234440 - Purchas Interest Management                         *
      *                                                               *
      *****************************************************************
 
     FSETRADL8  IF   E           K DISK
     FSECTY     IF   E           K DISK    PREFIX(SEC_)
     FPRICM     IF   E           K DISK    PREFIX(P_)
     FDPTMV     IF   E           K DISK    PREFIX(D_)
 
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
     D DDOPDT          S              6A                                                      236702
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
     C                   Eval      KCust = TCNR                                              CSD027A
     C                   EVAL      TDate = TDVD
     C                   ENDIF
 
     C* Depot Movement records
 
     C                   IF        *IN82 = '1'
     C                   MOVEL     DPBA          KBrca
     C                   MOVEL     DPSS          KSesn
     C**********         Z-ADD     DPBN          KCust                                       CSD027A
     C                   Eval      KCust = DPBN                                              CSD027A
     C                   EVAL      TDate = DPMD
     C                   ENDIF
 
     C                   IF        *IN83 = '1'
     C                   MOVEL     DPBA          KBrca
     C                   MOVEL     DPSS          KSesn
     C**********         Z-ADD     DPBN          KCust                                       CSD027A
     C                   Eval      KCust = DPBN                                              CSD027A
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
     C     FSPP          IFEQ      0                                                          236700
     C                   EXSR      SRVFPrice
     C                   ENDIF                                                                236700
     C                   ENDIF
 
     C* Depot Movement records
 
     C                   IF        *IN82 = '1' OR *IN83 = '1'
     C     DptmKey       CHAIN     DPTMV                              89
     C                   EVAL      Tr_TYPE = 'D'
     C     D_FSPP        IFEQ      0                                                          236700
     C                   EXSR      SRDpFPrice
     C                   EVAL      D_FSPR = FSPR
     C                   EVAL      D_FSPP = FSPP
     C                   ENDIF                                                                236700
     C                   ENDIF
 
     C                   EVAL      Actn_Code = 'I'
     C                   CALL      'SEETCPUPD'
     C                   PARM                    RetCodeIn
     C                   PARM                    Actn_Code
     C                   PARM                    Tr_Type
     C                   PARM                    ValidTrade
     C                   PARM                    ValidDpmv
     C                   PARM                    Security
 
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
     C                   MOVE      'Y'           LiveCust          1                          234577
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
     C*******************EVAL      DBKEY = @PKYST                                             234577
     C*******************EVAL      DBFILE = 'SDCUSTPD'                                        234577
     C*******************EVAL      DBASE = 5                                                  234577
     C*******************EXSR      *PSSR                                                      234577
     C                   MOVE      'N'           LiveCust          1                          234577
     C                   CLEAR                   SDCUST                                       234577
     C                   ENDIF                                                                234577
     C     @RTCD         IFEQ      *BLANK                                                     236701
     C                   CALL      'AOSECSR0'                                                 234577
     C*******************PARM      '*DBERR '     @RTCD                                 234577 236701
     C                   PARM      *BLANK        @RTCD                                        236701
     C                   PARM      '*KEY   '     @OPTN                                        234577
     C                   PARM      BBCUST        @SCKY             6                          234577
     C     SDSECS        PARM      SDSECS        DSSDY                                        234577
     C                   ENDIF                                                                236701
     C     @RTCD         IFNE      *BLANKS                                                    234577
     C     BFCLAS        ORNE      'D'                                                        243028
     C     BFCLAS        ANDNE     'S'                                                        243028
     C                   MOVE      'N'           LiveCust          1                          234577
     C                   CLEAR                   SDSECS                                       234577
     C                   END                                                                  234577
     C                   ENDIF
 
      ** Tax basket
 
     C                   EVAL      WCNCD = DVCNCD
     C                   EVAL      WCOLC = DVCNCD                                             234577
     C*******************EVAL      WCOLC = BBCOLC                                             234577
 
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
 
     C*******************CALL      'AOSECSR0'                                                 234577
     C*******************PARM      '*DBERR '     @RTCD                                        234577
     C*******************PARM      '*KEY   '     @OPTN                                        234577
     C*******************PARM      BBCUST        @SCKY             6                          234577
     C*****SDSECS********PARM      SDSECS        DSSDY                                        234577
      *
      ** DATABASE ERROR
      *
     C*****@RTCD*********IFNE      *BLANKS                                                    234577
     C*******************MOVEL     BBCUST        DBKEY                                        234577
     C*******************MOVEL     'SDSECSPD'    DBFILE                                       234577
     C*******************EVAL      DBASE = 10                                                 234577
     C*******************EXSR      *PSSR                                                      234577
     C*******************END                                                                  234577
 
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
 
     C*******************PARM                    DDFSPR           16                   CGL031 236700
     C                   PARM      *BLANK        DDFSPR           16                          236700
 
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
     C                   EVAL      DDOPDT = ''                                                236702
 
     C                   CALLB     'SEVSEFSPR3'
     C                   PARM                    RetCodeIn
     C*******************PARM                    DDFSPR                                CGL031 236700
     C                   PARM      *BLANK        DDFSPR                                       236700
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
     C                   PARM                    DDOPDT                                       236702
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
 
     C*****WrkSesn       IFNE      KSesn                                                      236699
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
 
     C***********        ENDIF                                                                236699
 
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
(c) Misys International Banking Systems Ltd. 2005
