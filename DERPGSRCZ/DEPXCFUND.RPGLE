     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract for funds transfer')        *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXCFUND - Projected Extract for Funds Transfer             *
      *                                                               *
      *  Function:  This module will perform the extraction of FT     *
      *             transaction details for the analysis of revenue   *
      *             of revenue within CCRM. The module will base the  *
      *             extraction process on the account keys that are   *
      *             generated during close of business processing, as *
      *             these entries contain the correct amounts and are *
      *             generated on the appropriate day. Records are     *
      *             written to the projected extract files.           *
      *             These records will be used to update details on   *
      *             the Generic transaction files which will          *
      *             subsequently feed into the Historic extract for   *
      *             revenue analysis, thereby writing records to the  *
      *             historic extract files.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15146           Date 26Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 20Aug02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 199373             Date 25Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 197196             Date 22Aug01               *
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15146 - Error in DEPXCFUND due to IBAN ordering customer  *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - '/' has already been removed from Waccount, so just *
      *           set PIBAN = Waccount.                               *
      *           Also make sure event details are set up after       *
      *           array E#EVNT is cleared.                            *
      *           Enable DEWRKEDTA to get info from data area         *
      *  199373 - Remove check on end of EMU transition.              *
      *  197196 - Move Ordering Customer type instead of Ordering     *
      *           Institution Type to the corresponding variable
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
0016  * ID F  C  H  L    FUNCTION OF INDICATORS                             0255
0020  * 10               FPKEY                                              0255
0020  * 11               OTPAY                                              0255
0020  * 12               INPAY                                              0255
0020  * 13               CQPAC                                              0255
0020  * 14               CQCOD                                              0255
0020  * 15               ACNUM                                              0255
      **********************************************************************
      *
     FFPKEYL1   IF   E           K DISK
     FOTPAY     IF   E           K DISK
     FINPAY     IF   E           K DISK
     FCQPAC     IF   E           K DISK
     FCQCOD     IF   E           K DISK
     FACNUM     IF   E           K DISK
      *
      ** Request for transfer - header
     FFT101HL3  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Request for transfer - detail
     FFT101DL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Customer credit transfer - header
     FFT102HL3  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Customer credit transfer - detail
     FFT102DL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Funds transfer standing data
     FTABFP     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(TABTB20F)
     F                                     IGNORE(TABTG20F)
     F                                     IGNORE(TABLETPF)
     F                                     IGNORE(TABLET5F)
     F                                     IGNORE(TABLETHF)
      *
     FDEELOGPD  O    E             DISK
     FDEPTRANPD O    E           K DISK
     FDEPEVNTPD O    E           K DISK
     FDEPPOSNPD O    E           K DISK
     FDEPCASHPD O    E           K DISK
      *
      ** Externally described DS for account details
     D PAccntDS      E DS                  EXTNAME(ACCNTAB)
      *
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * E X T R A C T   F I L E S
     D/COPY DECPYSRC,DEXTFILS
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXTPERDD
      *
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
      *
      ** Array for transaction id.
     D TrnIDAr         S             16A   DIM(999)
      *
      ** Array for Accounts
     D*AccntArr***     S             18A   DIM(999)                                           CGL029
     D AccntArr        S             24A   DIM(999)                                           CGL029
     D TotalCr         S             15P 0 DIM(999)
     D TotalDr         S             15P 0 DIM(999)
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D                 DS
     D**W#ACID***              1     18                                                       CGL029
     D  W#ACID                 1     24                                                       CGL029
     D**W#CNUM**               1      6S 0                                                    CSD027
     D  W#CNUM                 1      6A                                                      CSD027
     D  W#CCY                  7      9A
     D**W#ACOD***             10     13S 0                                                    CGL029
     D**W#ACSQ***             14     15S 0                                                    CGL029
     D**W#BRCA***             16     18A                                                      CGL029
     D  W#ACOD                10     19S 0                                                    CGL029
     D  W#ACSQ                20     21S 0                                                    CGL029
     D  W#BRCA                22     24A                                                      CGL029
      *
     D                 DS
     D  TREF                   1     17
     D  PREF                   1     15
     D  CQSQ                  16     17  0
     D  PTYP                  12     13
      *
     D                 DS
     D  AKEY                   1     10
     D  AKEY3                  3      3
     D  AKEY9                  9     10
     D  AKEY10                10     10
      *
     D                 DS
     D**SEAC***                1     18                                                       CGL029
     D  SEAC                   1     24                                                       CGL029
     D  FPCNUM                 1      6
     D  FPCCY                  7      9
     D**FPACOD***             10     13                                                       CGL029
     D**FPASEQ***             14     15                                                       CGL029
     D**FPBRCH***             16     18                                                       CGL029
     D  FPACOD                10     19                                                       CGL029
     D  FPASEQ                20     21                                                       CGL029
     D  FPBRCH                22     24                                                       CGL029
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             16     16
     D  EndOfFile             17     17
     D  TrnsIdFnd             18     18
     D  AccntFnd              19     19
      *
      ** Work parameters
     D IAx             S              3A
     D PCcy            S              3A
     D PBrch           S              3A
     D PSard           S              6A
     D PRtCd           S              7A
     D POptn           S              7A
     D PIBAN           S             34A
      *
      ** Work variables
     D CFT004          S              1A
     D WCustType       S              1A
     D WTransProcess   S              1A
     D WNostro         S              5A
     D WRevCust        S              6A
     D WPref           S             15A
     D WTransRef       S             20A
     D WAccount        S             35A
     D WORC1           S             10A                                                      CFT032
 
     D Ix              S              3P 0
     D PayMargin       S             15P 0
     D TfrMargin       S             15P 0
     D CalcMargin      S             15P 0
     D TotAmtCR        S             15P 0
     D TotAmtDR        S             15P 0
     D PLAmount        S             15P 0
     D WOldBaseEq      S             15P 0
     D WCurBaseEq      S             15P 0
 
     D WFPTrID         S                   LIKE(FPTRID)
     D D2NBDP          S                   LIKE(A6NBDP)
     D D2MDIN          S                   LIKE(A6MDIN)
     D D2SPRT          S                   LIKE(A6SPRT)
     D D3NBDP          S                   LIKE(A6NBDP)
     D D3MDIN          S                   LIKE(A6MDIN)
     D D3SPRT          S                   LIKE(A6SPRT)
     D FeeCode         S                   LIKE(E#FEEC)
     D OrdCust         S                   LIKE(WAccount)
     D BnfCust         S                   LIKE(WAccount)
     D TmpAcc          S                   LIKE(WAccount)
     D OrdCustTp       S                   LIKE(ORCT)
     D BnfCustTp       S                   LIKE(BNCT)
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Rename request for transfer header field
     IFT101HD0
     I              SINST                       S_INST
      *
     C     CQKEY         KLIST
     C                   KFLD                    PREF
     C                   KFLD                    CQSQ
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#EOB             1
     C**********         PARM                    I#TREF           20                          CGL029
     C                   PARM                    I#TREF           26                          CGL029
     C                   PARM                    I#RSRV           10                          CDE005
      *
      **  Extract all FT account keys
     C                   READ      FPKEYL1                                10    *
     C                   MOVEL     'Y'           FSTREC            1
      *
      **  Whilst keys can be found
     C     *IN10         DOWEQ     '0'
      *
     C     RECI          IFEQ      'D'
      *
      **  Obtain event currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      ECCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     ECCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save event currency details
     C                   MOVEL     A6CYCD        EVCYCD            3
     C**********         MOVEL     A6SPAE        EVSPAE            4                          CGL029
     C**********         MOVEL     A6FTAE        EVFTAE            4                          CGL029
     C**********         MOVEL     A6SWAE        EVSWAE            4                          CGL029
     C**********         MOVEL     A6TAC4        EVTAC4            4                          CGL029
     C**********         MOVEL     A6TAC5        EVTAC5            4                          CGL029
     C                   MOVEL     A6SPAE        EVSPAE           10                          CGL029
     C                   MOVEL     A6FTAE        EVFTAE           10                          CGL029
     C                   MOVEL     A6SWAE        EVSWAE           10                          CGL029
     C                   MOVEL     A6TAC4        EVTAC4           10                          CGL029
     C                   MOVEL     A6TAC5        EVTAC5           10                          CGL029
     C                   MOVEL     A6CDFN        EVCDFN            2
     C                   MOVEL     A6ECDN        EVECDN            2
     C                   Z-ADD     A6LCD         EVLCD             5 0
     C                   MOVEL     A6TYLC        EVTYLC            1
     C                   MOVEL     A6CYNM        EVCYNM           14
     C                   Z-ADD     A6SPRT        EVSPRT           13 8
     C                   MOVEL     A6SWCY        EVSWCY            3
     C                   Z-ADD     A6NBDP        EVNBDP            1 0
     C                   Z-ADD     A6TXND        EVTXND            1 0
     C                   Z-ADD     A6PRRT        EVPRRT           13 8
     C                   Z-ADD     A6SRC1        EVSRC1            4 0
     C                   Z-ADD     A6SRC2        EVSRC2            4 0
     C                   MOVEL     A6DLCI        EVDLCI            1
     C                   Z-ADD     A6SSNB        EVSSNB            2 0
     C                   Z-ADD     A6ERLC        EVERLC           13 8
     C                   MOVEL     A6MDIN        EVMDIN            1
     C                   MOVEL     A6MDPR        EVMDPR            1
     C                   MOVEL     A6MDHB        EVMDHB            1
     C                   MOVEL     A6MDEX        EVMDEX            1
     C                   MOVEL     A6NOSN        EVNOSN           10
     C                   Z-ADD     A6SPDY        EVSPDY            3 0
     C                   Z-ADD     A6HSRT        EVHSRT           13 8
     C                   Z-ADD     A6LSPR        EVLSPR           13 8
     C                   Z-ADD     A6FXSD        EVFXSD            8 0
     C                   Z-ADD     A6MMSD        EVMMSD            8 0
     C                   Z-ADD     A6NQDP        EVNQDP            1 0
     C                   MOVEL     A6DICB        EVDICB            1
     C                   Z-ADD     A6SCEX        EVSCEX            1 0
     C                   MOVEL     A6EBDA        EVEBDA           29
     C                   Z-ADD     A6HBRT        EVHBRT           13 8
     C                   Z-ADD     A6ENC1        EVENC1            2 0
     C                   Z-ADD     A6ENC2        EVENC2            2 0
     C                   MOVEL     A6CACD        EVCACD            3
     C                   Z-ADD     A6CNMC        EVCNMC            2 0
     C                   MOVEL     A6WEDH        EVWEDH            1
     C                   MOVEL     A6MONH        EVMONH            1
     C                   MOVEL     A6TUEH        EVTUEH            1
     C                   MOVEL     A6THUH        EVTHUH            1
     C                   MOVEL     A6FRIH        EVFRIH            1
     C                   MOVEL     A6SATH        EVSATH            1
     C                   MOVEL     A6SUNH        EVSUNH            1
     C                   Z-ADD     A6DPBF        EVDPBF            1 0
     C                   Z-ADD     A6BYSR        EVBYSR           13 8
     C                   MOVEL     A6BYSS        EVBYSS            1
     C                   Z-ADD     A6SLSR        EVSLSR           13 8
     C                   MOVEL     A6SLSS        EVSLSS            1
     C                   Z-ADD     A6RMCM        EVRMCM            1 0
     C                   MOVEL     A6RECI        EVRECI            1
     C                   MOVEL     A6DPRU        EVDPRU            1
     C                   MOVEL     A6DNOR        EVDNOR            1
     C                   MOVEL     A6NDWR        EVNDWR            1
     C                   MOVEL     A6GMPY        EVGMPY            1
     C                   MOVEL     A6DLCD        EVDLCD            1
     C                   MOVEL     A6RDFC        EVRDFC            1
     C                   MOVEL     A6PMRT        EVPMRT            1
     C                   Z-ADD     A6RKSQ        EVRKSQ            3 0
     C                   MOVEL     A6DFPC        EVDFPC            4
     C                   MOVEL     A6DDPC        EVDDPC            4
     C                   Z-ADD     A6TKCC        EVTKCC            3 0
     C                   Z-ADD     A6CQCD        EVCQCD            2 0
     C                   Z-ADD     A6SMLD        EVSMLD            5 0
     C**********         MOVEL     A6CSCD        EVCSCD            4                          CGL029
     C                   MOVEL     A6CSCD        EVCSCD           10                          CGL029
     C                   Z-ADD     A6ISON        EVISON            3 0
     C                   MOVEL     A6ISFC        EVISFC           35
     C                   MOVEL     A6MACD        EVMACD           35
     C                   MOVEL     A6FRAC        EVFRAC            1
     C                   MOVEL     A6NUWD        EVNUWD            1
     C                   MOVEL     A6MICD        EVMICD           35
     C                   MOVEL     A6INCY        EVINCY            1
     C                   Z-ADD     A6EUER        EVEUER           13 8
     C                   MOVEL     A6EUMD        EVEUMD            1
     C                   Z-ADD     A6TPSD        EVTPSD            5 0
     C**********         Z-ADD     A6TPED        EVTPED            5 0                        199373
     C                   Z-ADD     99999         EVTPED            5 0                        199373
     C                   Z-ADD     A6INER        EVINER           13 8
     C                   MOVEL     A6INMD        EVINMD            1
      *
     C                   EXSR      P02
     C                   END
      *
     C                   MOVEL     PREF          SPREF            15
     C                   MOVEL     CQSQ          SCQSQ             2 0
     C                   MOVEL     FPTRID        WFPTrID
     C                   MOVEL     'N'           FSTREC
      *
      **  Read the next record
     C                   READ      FPKEYL1                                10    *
     C                   END
      *
      **  Process event generation and export
     C     GENEVT        IFEQ      'Y'
     C                   EXSR      P90
     C                   MOVEL     'N'           GENEVT
     C                   END
      *
     C                   SETON                                        LR
     C                   RETURN
     C/SPACE 5
      ********************************************************************
      * *INZSR - INITIAL PROCESSING
      * Retrieve and initialise data for subsequent processing
      ********************************************************************
     C     *INZSR        BEGSR
      *
      **  Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Obtain the base currency decimal places
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      BJCYCD        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     BJCYCD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     A6NBDP        BSNBDP            1 0
      *
      **  Obtain the GL ICD detail
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR file to determine if 'IBAN numbers enhancement'
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT004'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CFT004'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 023
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CFT004
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   ENDIF
      *                                                                                       208221
      * This is a projected extract                                                           208221
                                                                                              208221
     C                   MOVE      'P'           I#PH                                         208221
      *
      **  Get extract control information
      /COPY DECPYSRC,DEXTGTCT                                                                 208221
                                                                                              208221
     C************       CALLB     'DEGETEXCT'                                                208221
     C************       PARM                    I#RTCD            7            * RETURN CODE 208221
     C************       PARM                    I#ERMS           30            * ERROR MESSAG208221
     C************       PARM      'P'           I#PH              1                          208221
     C************       PARM                    I#EOB             1                          208221
     C************       PARM      0             I#RDNB            5 0                        208221
     C************       PARM      0             I#DNWD            5 0                        208221
     C************       PARM      0             I#HCOD            5 0                        208221
     C************       PARM      0             I#EVCD            5 0                        208221
     C************       PARM      0             I#PCOD            5 0                        208221
     C************       PARM      *BLANKS       PeriodEDT                                    208221
      *
      **  Set generate events to 'N'
     C                   MOVEL     'N'           GENEVT            1
      *
      ** Key list for Request For Transfer details
     C     KPrefTrID     KLIST
     C                   KFLD                    PREF
     C                   KFLD                    FPTRID
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * P02 - INITIAL PROCESSING
      * Read FT account keys and call corresponding transaction
      * revenue extract process.
      ********************************************************************
     C     P02           BEGSR
      *
      **  Payment reference or cheque sequence are different
     C     PREF          IFNE      SPREF
     C     CQSQ          ORNE      SCQSQ
     C     FPTRID        ORNE      WFPTrID
      *
      **  Generate events is 'Y' and not the first row read
     C     GENEVT        IFEQ      'Y'
     C     FSTREC        ANDNE     'Y'
     C                   EXSR      P90
     C                   MOVEL     'N'           GENEVT
     C                   END
      *
      ** Process Request for transfer
      *
     C                   IF        %SUBST(PREF:1:1)='A' OR %SUBST(PREF:1:1)='B'
 
     C     PREF          CHAIN     FT101HL3                           16
      *
      ** Error if header record not found.  Otherwise, process detail records.
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY  = PREF
     C                   EVAL      DBFILE = 'FT101HPD'
     C                   EVAL      DBASE  = 025
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** If Change of payment reference was found, save new payment
      ** reference.  Save transaction IDs of all detail records.
      *
     C                   IF        WPref <> PREF
 
     C                   EVAL      Ix    = 1
     C                   EVAL      WPref = PREF
     C                   EVAL      WTransProcess = *BLANK
     C     PREF          SETLL     FT101DL0
     C     PREF          READE     FT101DL0                               17
     C                   DOW       EndOfFile = False
     C                   EVAL      TrnIDAr(Ix) = TRNSID
     C                   EVAL      Ix    = Ix + 1
     C     PREF          READE     FT101DL0                               17
     C                   ENDDO
 
     C                   ENDIF
      *
      ** If transaction ID is not blank, retrieve detail record.
      *
     C                   IF        FPTRID <> *BLANKS
     C     KPrefTrID     CHAIN     FT101DL0                           16
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY  = FPTRID
     C                   EVAL      DBFILE = 'FT101DPD'
     C                   EVAL      DBASE  = 027
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Incoming request for transfer
      *
     C                   IF        %SUBST(PREF:1:1)='B'
      *
      ** Access currency detail using Transfer currency.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      TRNCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Data base error.  Otherwise, save detail temporarily.
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = TRNCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 028
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      D2NBDP = A6NBDP
     C                   EVAL      D2MDIN = A6MDIN
     C                   EVAL      D2SPRT = A6SPRT
     C                   ENDIF
      *
      ** Access currency detail using Payment currency.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      PAYCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Data base error.  Otherwise, save detail temporarily.
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = PAYCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 029
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      D3NBDP = A6NBDP
     C                   EVAL      D3MDIN = A6MDIN
     C                   EVAL      D3SPRT = A6SPRT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Outgoing customer credit transfer
      *
     C                   IF        %SUBST(PREF:1:1)='C'
 
     C     PREF          CHAIN     FT102HL3                           16
      *
      ** Error if header record not found.  Otherwise, process detail records.
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY  = PREF
     C                   EVAL      DBFILE = 'FT102HPD'
     C                   EVAL      DBASE  = 030
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** If Change of payment reference was found, save new payment
      ** reference.  Save account number.
     C                   IF        WPref <> PREF
     C                   EVAL      WPref = PREF
 
     C     PREF          SETLL     FT102DL0
     C     PREF          READE     FT102DL0                               17
 
     C                   DOW       EndOfFile = False
 
     C                   EXSR      P96
 
     C                   EVAL      Ix    = 1
     C     W#ACID        LOOKUP    AccntArr(Ix)                           19
 
     C                   IF        AccntFnd = False
     C                   EVAL      AccntArr(Ix) = W#ACID
     C                   EVAL      TotalCr(Ix)  = CCTAMT
     C                   EVAL      TotalDr(Ix)  = PAYAMT
     C                   EVAL      Ix    = Ix + 1
     C                   ELSE
     C                   EVAL      TotalCr(Ix)  = TotalCr(Ix) + CCTAMT
     C                   EVAL      TotalDr(Ix)  = TotalDr(Ix) + PAYAMT
     C                   ENDIF
 
     C     PREF          READE     FT102DL0                               17
     C                   ENDDO
 
     C                   ENDIF
      *
      ** If transaction ID is not blank, retrieve detail record.
      *
     C                   IF        FPTRID <> *BLANKS
     C     KPrefTrID     CHAIN     FT102DL0                           16
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY  = FPTRID
     C                   EVAL      DBFILE = 'FT102DPD'
     C                   EVAL      DBASE  = 031
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Access currency detail using Transfer currency.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      CCTCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error.  Otherwise, save detail temporarily.
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = CCTCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 032
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      D2NBDP = A6NBDP
     C                   EVAL      D2MDIN = A6MDIN
     C                   EVAL      D2SPRT = A6SPRT
     C                   ENDIF
      *
      ** Access currency detail using Payment currency.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      PAYCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error.  Otherwise, save detail temporarily.
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = PAYCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 033
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      D3NBDP = A6NBDP
     C                   EVAL      D3MDIN = A6MDIN
     C                   EVAL      D3SPRT = A6SPRT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Incoming customer credit transfer
      *
     C                   IF        %SUBST(PREF:1:1)='D'
 
     C     PREF          CHAIN     FT102HL3                           16
      *
      ** Error if header record not found.  Otherwise, process detail records.
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY  = PREF
     C                   EVAL      DBFILE = 'FT102HPD'
     C                   EVAL      DBASE  = 034
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** If Change of payment reference was found, save new payment
      ** reference.  Save transaction IDs of all detail records.
      *
     C                   IF        WPref <> PREF
 
     C                   EVAL      Ix    = 1
     C                   EVAL      WPref = PREF
     C     PREF          SETLL     FT102DL0
     C     PREF          READE     FT102DL0                               17
 
     C                   DOW       EndOfFile = False
     C                   EVAL      TrnIDAr(Ix) = TRNSID
     C                   EVAL      Ix    = Ix + 1
     C     PREF          READE     FT102DL0                               17
     C                   ENDDO
 
     C                   ENDIF
      *
      ** If transaction ID is not blank, retrieve detail record.
      *
     C                   IF        FPTRID <> *BLANKS
     C     KPrefTrID     CHAIN     FT102DL0                           16
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY  = FPTRID
     C                   EVAL      DBFILE = 'FT102DPD'
     C                   EVAL      DBASE  = 035
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Access currency detail using Transfer currency.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      CCTCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error.  Otherwise, save detail temporarily.
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = CCTCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 036
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      D2NBDP = A6NBDP
     C                   EVAL      D2MDIN = A6MDIN
     C                   EVAL      D2SPRT = A6SPRT
     C                   ENDIF
      *
      ** Access currency detail using Payment currency.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      PAYCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error.  Otherwise, save detail temporarily.
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = PAYCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 037
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      D3NBDP = A6NBDP
     C                   EVAL      D3MDIN = A6MDIN
     C                   EVAL      D3SPRT = A6SPRT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      **  Outgoing payment
     C     PTYP          IFEQ      'OP'
     C     PREF          CHAIN     OTPAY                              11        *
      *
      **  Data base error
     C     *IN11         IFEQ      '1'
     C                   MOVEL     PREF          DBKEY
     C                   MOVEL     'OTPAY'       DBFILE
     C                   MOVEL     '005'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Obtain settle currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      SMCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     SMCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save settle currency details
     C                   MOVEL     A6CYCD        STCYCD            3
     C**********         MOVEL     A6SPAE        STSPAE            4                          CGL029
     C**********         MOVEL     A6FTAE        STFTAE            4                          CGL029
     C**********         MOVEL     A6SWAE        STSWAE            4                          CGL029
     C**********         MOVEL     A6TAC4        STTAC4            4                          CGL029
     C**********         MOVEL     A6TAC5        STTAC5            4                          CGL029
     C                   MOVEL     A6SPAE        STSPAE           10                          CGL029
     C                   MOVEL     A6FTAE        STFTAE           10                          CGL029
     C                   MOVEL     A6SWAE        STSWAE           10                          CGL029
     C                   MOVEL     A6TAC4        STTAC4           10                          CGL029
     C                   MOVEL     A6TAC5        STTAC5           10                          CGL029
     C                   MOVEL     A6CDFN        STCDFN            2
     C                   MOVEL     A6ECDN        STECDN            2
     C                   Z-ADD     A6LCD         STLCD             5 0
     C                   MOVEL     A6TYLC        STTYLC            1
     C                   MOVEL     A6CYNM        STCYNM           14
     C                   Z-ADD     A6SPRT        STSPRT           13 8
     C                   MOVEL     A6SWCY        STSWCY            3
     C                   Z-ADD     A6NBDP        STNBDP            1 0
     C                   Z-ADD     A6TXND        STTXND            1 0
     C                   Z-ADD     A6PRRT        STPRRT           13 8
     C                   Z-ADD     A6SRC1        STSRC1            4 0
     C                   Z-ADD     A6SRC2        STSRC2            4 0
     C                   MOVEL     A6DLCI        STDLCI            1
     C                   Z-ADD     A6SSNB        STSSNB            2 0
     C                   Z-ADD     A6ERLC        STERLC           13 8
     C                   MOVEL     A6MDIN        STMDIN            1
     C                   MOVEL     A6MDPR        STMDPR            1
     C                   MOVEL     A6MDHB        STMDHB            1
     C                   MOVEL     A6MDEX        STMDEX            1
     C                   MOVEL     A6NOSN        STNOSN           10
     C                   Z-ADD     A6SPDY        STSPDY            3 0
     C                   Z-ADD     A6HSRT        STHSRT           13 8
     C                   Z-ADD     A6LSPR        STLSPR           13 8
     C                   Z-ADD     A6FXSD        STFXSD            8 0
     C                   Z-ADD     A6MMSD        STMMSD            8 0
     C                   Z-ADD     A6NQDP        STNQDP            1 0
     C                   MOVEL     A6DICB        STDICB            1
     C                   Z-ADD     A6SCEX        STSCEX            1 0
     C                   MOVEL     A6EBDA        STEBDA           29
     C                   Z-ADD     A6HBRT        STHBRT           13 8
     C                   Z-ADD     A6ENC1        STENC1            2 0
     C                   Z-ADD     A6ENC2        STENC2            2 0
     C                   MOVEL     A6CACD        STCACD            3
     C                   Z-ADD     A6CNMC        STCNMC            2 0
     C                   MOVEL     A6WEDH        STWEDH            1
     C                   MOVEL     A6MONH        STMONH            1
     C                   MOVEL     A6TUEH        STTUEH            1
     C                   MOVEL     A6THUH        STTHUH            1
     C                   MOVEL     A6FRIH        STFRIH            1
     C                   MOVEL     A6SATH        STSATH            1
     C                   MOVEL     A6SUNH        STSUNH            1
     C                   Z-ADD     A6DPBF        STDPBF            1 0
     C                   Z-ADD     A6BYSR        STBYSR           13 8
     C                   MOVEL     A6BYSS        STBYSS            1
     C                   Z-ADD     A6SLSR        STSLSR           13 8
     C                   MOVEL     A6SLSS        STSLSS            1
     C                   Z-ADD     A6RMCM        STRMCM            1 0
     C                   MOVEL     A6RECI        STRECI            1
     C                   MOVEL     A6DPRU        STDPRU            1
     C                   MOVEL     A6DNOR        STDNOR            1
     C                   MOVEL     A6NDWR        STNDWR            1
     C                   MOVEL     A6GMPY        STGMPY            1
     C                   MOVEL     A6DLCD        STDLCD            1
     C                   MOVEL     A6RDFC        STRDFC            1
     C                   MOVEL     A6PMRT        STPMRT            1
     C                   Z-ADD     A6RKSQ        STRKSQ            3 0
     C                   MOVEL     A6DFPC        STDFPC            4
     C                   MOVEL     A6DDPC        STDDPC            4
     C                   Z-ADD     A6TKCC        STTKCC            3 0
     C                   Z-ADD     A6CQCD        STCQCD            2 0
     C                   Z-ADD     A6SMLD        STSMLD            5 0
     C**********         MOVEL     A6CSCD        STCSCD            4                          CGL029
     C                   MOVEL     A6CSCD        STCSCD           10                          CGL029
     C                   Z-ADD     A6ISON        STISON            3 0
     C                   MOVEL     A6ISFC        STISFC           35
     C                   MOVEL     A6MACD        STMACD           35
     C                   MOVEL     A6FRAC        STFRAC            1
     C                   MOVEL     A6NUWD        STNUWD            1
     C                   MOVEL     A6MICD        STMICD           35
     C                   MOVEL     A6INCY        STINCY            1
     C                   Z-ADD     A6EUER        STEUER           13 8
     C                   MOVEL     A6EUMD        STEUMD            1
     C                   Z-ADD     A6TPSD        STTPSD            5 0
     C**********         Z-ADD     A6TPED        STTPED            5 0                        199373
     C                   Z-ADD     99999         STTPED            5 0                        199373
     C                   Z-ADD     A6INER        STINER           13 8
     C                   MOVEL     A6INMD        STINMD            1
      *
      **  Obtain pay currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      PCCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     PCCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save pay currency details
     C                   MOVEL     A6CYCD        PYCYCD            3
     C**********         MOVEL     A6SPAE        PYSPAE            4                          CGL029
     C**********         MOVEL     A6FTAE        PYFTAE            4                          CGL029
     C**********         MOVEL     A6SWAE        PYSWAE            4                          CGL029
     C**********         MOVEL     A6TAC4        PYTAC4            4                          CGL029
     C**********         MOVEL     A6TAC5        PYTAC5            4                          CGL029
     C                   MOVEL     A6SPAE        PYSPAE           10                          CGL029
     C                   MOVEL     A6FTAE        PYFTAE           10                          CGL029
     C                   MOVEL     A6SWAE        PYSWAE           10                          CGL029
     C                   MOVEL     A6TAC4        PYTAC4           10                          CGL029
     C                   MOVEL     A6TAC5        PYTAC5           10                          CGL029
     C                   MOVEL     A6CDFN        PYCDFN            2
     C                   MOVEL     A6ECDN        PYECDN            2
     C                   Z-ADD     A6LCD         PYLCD             5 0
     C                   MOVEL     A6TYLC        PYTYLC            1
     C                   MOVEL     A6CYNM        PYCYNM           14
     C                   Z-ADD     A6SPRT        PYSPRT           13 8
     C                   MOVEL     A6SWCY        PYSWCY            3
     C                   Z-ADD     A6NBDP        PYNBDP            1 0
     C                   Z-ADD     A6TXND        PYTXND            1 0
     C                   Z-ADD     A6PRRT        PYPRRT           13 8
     C                   Z-ADD     A6SRC1        PYSRC1            4 0
     C                   Z-ADD     A6SRC2        PYSRC2            4 0
     C                   MOVEL     A6DLCI        PYDLCI            1
     C                   Z-ADD     A6SSNB        PYSSNB            2 0
     C                   Z-ADD     A6ERLC        PYERLC           13 8
     C                   MOVEL     A6MDIN        PYMDIN            1
     C                   MOVEL     A6MDPR        PYMDPR            1
     C                   MOVEL     A6MDHB        PYMDHB            1
     C                   MOVEL     A6MDEX        PYMDEX            1
     C                   MOVEL     A6NOSN        PYNOSN           10
     C                   Z-ADD     A6SPDY        PYSPDY            3 0
     C                   Z-ADD     A6HSRT        PYHSRT           13 8
     C                   Z-ADD     A6LSPR        PYLSPR           13 8
     C                   Z-ADD     A6FXSD        PYFXSD            8 0
     C                   Z-ADD     A6MMSD        PYMMSD            8 0
     C                   Z-ADD     A6NQDP        PYNQDP            1 0
     C                   MOVEL     A6DICB        PYDICB            1
     C                   Z-ADD     A6SCEX        PYSCEX            1 0
     C                   MOVEL     A6EBDA        PYEBDA           29
     C                   Z-ADD     A6HBRT        PYHBRT           13 8
     C                   Z-ADD     A6ENC1        PYENC1            2 0
     C                   Z-ADD     A6ENC2        PYENC2            2 0
     C                   MOVEL     A6CACD        PYCACD            3
     C                   Z-ADD     A6CNMC        PYCNMC            2 0
     C                   MOVEL     A6WEDH        PYWEDH            1
     C                   MOVEL     A6MONH        PYMONH            1
     C                   MOVEL     A6TUEH        PYTUEH            1
     C                   MOVEL     A6THUH        PYTHUH            1
     C                   MOVEL     A6FRIH        PYFRIH            1
     C                   MOVEL     A6SATH        PYSATH            1
     C                   MOVEL     A6SUNH        PYSUNH            1
     C                   Z-ADD     A6DPBF        PYDPBF            1 0
     C                   Z-ADD     A6BYSR        PYBYSR           13 8
     C                   MOVEL     A6BYSS        PYBYSS            1
     C                   Z-ADD     A6SLSR        PYSLSR           13 8
     C                   MOVEL     A6SLSS        PYSLSS            1
     C                   Z-ADD     A6RMCM        PYRMCM            1 0
     C                   MOVEL     A6RECI        PYRECI            1
     C                   MOVEL     A6DPRU        PYDPRU            1
     C                   MOVEL     A6DNOR        PYDNOR            1
     C                   MOVEL     A6NDWR        PYNDWR            1
     C                   MOVEL     A6GMPY        PYGMPY            1
     C                   MOVEL     A6DLCD        PYDLCD            1
     C                   MOVEL     A6RDFC        PYRDFC            1
     C                   MOVEL     A6PMRT        PYPMRT            1
     C                   Z-ADD     A6RKSQ        PYRKSQ            3 0
     C                   MOVEL     A6DFPC        PYDFPC            4
     C                   MOVEL     A6DDPC        PYDDPC            4
     C                   Z-ADD     A6TKCC        PYTKCC            3 0
     C                   Z-ADD     A6CQCD        PYCQCD            2 0
     C                   Z-ADD     A6SMLD        PYSMLD            5 0
     C**********         MOVEL     A6CSCD        PYCSCD            4                          CGL029
     C                   MOVEL     A6CSCD        PYCSCD           10                          CGL029
     C                   Z-ADD     A6ISON        PYISON            3 0
     C                   MOVEL     A6ISFC        PYISFC           35
     C                   MOVEL     A6MACD        PYMACD           35
     C                   MOVEL     A6FRAC        PYFRAC            1
     C                   MOVEL     A6NUWD        PYNUWD            1
     C                   MOVEL     A6MICD        PYMICD           35
     C                   MOVEL     A6INCY        PYINCY            1
     C                   Z-ADD     A6EUER        PYEUER           13 8
     C                   MOVEL     A6EUMD        PYEUMD            1
     C                   Z-ADD     A6TPSD        PYTPSD            5 0
     C**********         Z-ADD     A6TPED        PYTPED            5 0                        199373
     C                   Z-ADD     99999         PYTPED            5 0                        199373
     C                   Z-ADD     A6INER        PYINER           13 8
     C                   MOVEL     A6INMD        PYINMD            1
      *END OP
     C                   END
      *
      **  Incoming payment
     C     PTYP          IFEQ      'IN'
     C     PREF          CHAIN     INPAY                              12        *
      *
      **  Data base error
     C     *IN12         IFEQ      '1'
     C                   MOVEL     PREF          DBKEY
     C                   MOVEL     'INPAY'       DBFILE
     C                   MOVEL     '008'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Obtain settle currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      SMCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     SMCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '009'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save settle currency details
     C                   MOVEL     A6CYCD        STCYCD
     C                   MOVEL     A6SPAE        STSPAE
     C                   MOVEL     A6FTAE        STFTAE
     C                   MOVEL     A6SWAE        STSWAE
     C                   MOVEL     A6TAC4        STTAC4
     C                   MOVEL     A6TAC5        STTAC5
     C                   MOVEL     A6CDFN        STCDFN
     C                   MOVEL     A6ECDN        STECDN
     C                   Z-ADD     A6LCD         STLCD
     C                   MOVEL     A6TYLC        STTYLC
     C                   MOVEL     A6CYNM        STCYNM
     C                   Z-ADD     A6SPRT        STSPRT
     C                   MOVEL     A6SWCY        STSWCY
     C                   Z-ADD     A6NBDP        STNBDP
     C                   Z-ADD     A6TXND        STTXND
     C                   Z-ADD     A6PRRT        STPRRT
     C                   Z-ADD     A6SRC1        STSRC1
     C                   Z-ADD     A6SRC2        STSRC2
     C                   MOVEL     A6DLCI        STDLCI
     C                   Z-ADD     A6SSNB        STSSNB
     C                   Z-ADD     A6ERLC        STERLC
     C                   MOVEL     A6MDIN        STMDIN
     C                   MOVEL     A6MDPR        STMDPR
     C                   MOVEL     A6MDHB        STMDHB
     C                   MOVEL     A6MDEX        STMDEX
     C                   MOVEL     A6NOSN        STNOSN
     C                   Z-ADD     A6SPDY        STSPDY
     C                   Z-ADD     A6HSRT        STHSRT
     C                   Z-ADD     A6LSPR        STLSPR
     C                   Z-ADD     A6FXSD        STFXSD
     C                   Z-ADD     A6MMSD        STMMSD
     C                   Z-ADD     A6NQDP        STNQDP
     C                   MOVEL     A6DICB        STDICB
     C                   Z-ADD     A6SCEX        STSCEX
     C                   MOVEL     A6EBDA        STEBDA
     C                   Z-ADD     A6HBRT        STHBRT
     C                   Z-ADD     A6ENC1        STENC1
     C                   Z-ADD     A6ENC2        STENC2
     C                   MOVEL     A6CACD        STCACD
     C                   Z-ADD     A6CNMC        STCNMC
     C                   MOVEL     A6WEDH        STWEDH
     C                   MOVEL     A6MONH        STMONH
     C                   MOVEL     A6TUEH        STTUEH
     C                   MOVEL     A6THUH        STTHUH
     C                   MOVEL     A6FRIH        STFRIH
     C                   MOVEL     A6SATH        STSATH
     C                   MOVEL     A6SUNH        STSUNH
     C                   Z-ADD     A6DPBF        STDPBF
     C                   Z-ADD     A6BYSR        STBYSR
     C                   MOVEL     A6BYSS        STBYSS
     C                   Z-ADD     A6SLSR        STSLSR
     C                   MOVEL     A6SLSS        STSLSS
     C                   Z-ADD     A6RMCM        STRMCM
     C                   MOVEL     A6RECI        STRECI
     C                   MOVEL     A6DPRU        STDPRU
     C                   MOVEL     A6DNOR        STDNOR
     C                   MOVEL     A6NDWR        STNDWR
     C                   MOVEL     A6GMPY        STGMPY
     C                   MOVEL     A6DLCD        STDLCD
     C                   MOVEL     A6RDFC        STRDFC
     C                   MOVEL     A6PMRT        STPMRT
     C                   Z-ADD     A6RKSQ        STRKSQ
     C                   MOVEL     A6DFPC        STDFPC
     C                   MOVEL     A6DDPC        STDDPC
     C                   Z-ADD     A6TKCC        STTKCC
     C                   Z-ADD     A6CQCD        STCQCD
     C                   Z-ADD     A6SMLD        STSMLD
     C                   MOVEL     A6CSCD        STCSCD
     C                   Z-ADD     A6ISON        STISON
     C                   MOVEL     A6ISFC        STISFC
     C                   MOVEL     A6MACD        STMACD
     C                   MOVEL     A6FRAC        STFRAC
     C                   MOVEL     A6NUWD        STNUWD
     C                   MOVEL     A6MICD        STMICD
     C                   MOVEL     A6INCY        STINCY
     C                   Z-ADD     A6EUER        STEUER
     C                   MOVEL     A6EUMD        STEUMD
     C                   Z-ADD     A6TPSD        STTPSD
     C**********         Z-ADD     A6TPED        STTPED                                       199373
     C                   Z-ADD     99999         STTPED                                       199373
     C                   Z-ADD     A6INER        STINER
     C                   MOVEL     A6INMD        STINMD
      *
      **  Obtain pay currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      PCCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     PCCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '010'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save pay currency details
     C                   MOVEL     A6CYCD        PYCYCD
     C                   MOVEL     A6SPAE        PYSPAE
     C                   MOVEL     A6FTAE        PYFTAE
     C                   MOVEL     A6SWAE        PYSWAE
     C                   MOVEL     A6TAC4        PYTAC4
     C                   MOVEL     A6TAC5        PYTAC5
     C                   MOVEL     A6CDFN        PYCDFN
     C                   MOVEL     A6ECDN        PYECDN
     C                   Z-ADD     A6LCD         PYLCD
     C                   MOVEL     A6TYLC        PYTYLC
     C                   MOVEL     A6CYNM        PYCYNM
     C                   Z-ADD     A6SPRT        PYSPRT
     C                   MOVEL     A6SWCY        PYSWCY
     C                   Z-ADD     A6NBDP        PYNBDP
     C                   Z-ADD     A6TXND        PYTXND
     C                   Z-ADD     A6PRRT        PYPRRT
     C                   Z-ADD     A6SRC1        PYSRC1
     C                   Z-ADD     A6SRC2        PYSRC2
     C                   MOVEL     A6DLCI        PYDLCI
     C                   Z-ADD     A6SSNB        PYSSNB
     C                   Z-ADD     A6ERLC        PYERLC
     C                   MOVEL     A6MDIN        PYMDIN
     C                   MOVEL     A6MDPR        PYMDPR
     C                   MOVEL     A6MDHB        PYMDHB
     C                   MOVEL     A6MDEX        PYMDEX
     C                   MOVEL     A6NOSN        PYNOSN
     C                   Z-ADD     A6SPDY        PYSPDY
     C                   Z-ADD     A6HSRT        PYHSRT
     C                   Z-ADD     A6LSPR        PYLSPR
     C                   Z-ADD     A6FXSD        PYFXSD
     C                   Z-ADD     A6MMSD        PYMMSD
     C                   Z-ADD     A6NQDP        PYNQDP
     C                   MOVEL     A6DICB        PYDICB
     C                   Z-ADD     A6SCEX        PYSCEX
     C                   MOVEL     A6EBDA        PYEBDA
     C                   Z-ADD     A6HBRT        PYHBRT
     C                   Z-ADD     A6ENC1        PYENC1
     C                   Z-ADD     A6ENC2        PYENC2
     C                   MOVEL     A6CACD        PYCACD
     C                   Z-ADD     A6CNMC        PYCNMC
     C                   MOVEL     A6WEDH        PYWEDH
     C                   MOVEL     A6MONH        PYMONH
     C                   MOVEL     A6TUEH        PYTUEH
     C                   MOVEL     A6THUH        PYTHUH
     C                   MOVEL     A6FRIH        PYFRIH
     C                   MOVEL     A6SATH        PYSATH
     C                   MOVEL     A6SUNH        PYSUNH
     C                   Z-ADD     A6DPBF        PYDPBF
     C                   Z-ADD     A6BYSR        PYBYSR
     C                   MOVEL     A6BYSS        PYBYSS
     C                   Z-ADD     A6SLSR        PYSLSR
     C                   MOVEL     A6SLSS        PYSLSS
     C                   Z-ADD     A6RMCM        PYRMCM
     C                   MOVEL     A6RECI        PYRECI
     C                   MOVEL     A6DPRU        PYDPRU
     C                   MOVEL     A6DNOR        PYDNOR
     C                   MOVEL     A6NDWR        PYNDWR
     C                   MOVEL     A6GMPY        PYGMPY
     C                   MOVEL     A6DLCD        PYDLCD
     C                   MOVEL     A6RDFC        PYRDFC
     C                   MOVEL     A6PMRT        PYPMRT
     C                   Z-ADD     A6RKSQ        PYRKSQ
     C                   MOVEL     A6DFPC        PYDFPC
     C                   MOVEL     A6DDPC        PYDDPC
     C                   Z-ADD     A6TKCC        PYTKCC
     C                   Z-ADD     A6CQCD        PYCQCD
     C                   Z-ADD     A6SMLD        PYSMLD
     C                   MOVEL     A6CSCD        PYCSCD
     C                   Z-ADD     A6ISON        PYISON
     C                   MOVEL     A6ISFC        PYISFC
     C                   MOVEL     A6MACD        PYMACD
     C                   MOVEL     A6FRAC        PYFRAC
     C                   MOVEL     A6NUWD        PYNUWD
     C                   MOVEL     A6MICD        PYMICD
     C                   MOVEL     A6INCY        PYINCY
     C                   Z-ADD     A6EUER        PYEUER
     C                   MOVEL     A6EUMD        PYEUMD
     C                   Z-ADD     A6TPSD        PYTPSD
     C**********         Z-ADD     A6TPED        PYTPED                                       199373
     C                   Z-ADD     99999         PYTPED                                       199373
     C                   Z-ADD     A6INER        PYINER
     C                   MOVEL     A6INMD        PYINMD
      *END IN
     C                   END
      *
      **  Cheques to be paid
     C     PTYP          IFEQ      'CP'
     C     CQSQ          ANDGT     0
      *
     C                   Z-ADD     CQSQ          XCQSQ             2 0
     C                   Z-ADD     0             CQSQ
     C     CQKEY         CHAIN     CQPAC                              13        *
      *
      **  Data base error
     C     *IN13         IFEQ      '1'
     C                   MOVEL     TREF          DBKEY
     C                   MOVEL     'CQPAC'       DBFILE
     C                   MOVEL     '011'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Obtain pay currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      PCCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     PCCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '012'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save pay currency details
     C                   MOVEL     A6CYCD        PYCYCD
     C                   MOVEL     A6SPAE        PYSPAE
     C                   MOVEL     A6FTAE        PYFTAE
     C                   MOVEL     A6SWAE        PYSWAE
     C                   MOVEL     A6TAC4        PYTAC4
     C                   MOVEL     A6TAC5        PYTAC5
     C                   MOVEL     A6CDFN        PYCDFN
     C                   MOVEL     A6ECDN        PYECDN
     C                   Z-ADD     A6LCD         PYLCD
     C                   MOVEL     A6TYLC        PYTYLC
     C                   MOVEL     A6CYNM        PYCYNM
     C                   Z-ADD     A6SPRT        PYSPRT
     C                   MOVEL     A6SWCY        PYSWCY
     C                   Z-ADD     A6NBDP        PYNBDP
     C                   Z-ADD     A6TXND        PYTXND
     C                   Z-ADD     A6PRRT        PYPRRT
     C                   Z-ADD     A6SRC1        PYSRC1
     C                   Z-ADD     A6SRC2        PYSRC2
     C                   MOVEL     A6DLCI        PYDLCI
     C                   Z-ADD     A6SSNB        PYSSNB
     C                   Z-ADD     A6ERLC        PYERLC
     C                   MOVEL     A6MDIN        PYMDIN
     C                   MOVEL     A6MDPR        PYMDPR
     C                   MOVEL     A6MDHB        PYMDHB
     C                   MOVEL     A6MDEX        PYMDEX
     C                   MOVEL     A6NOSN        PYNOSN
     C                   Z-ADD     A6SPDY        PYSPDY
     C                   Z-ADD     A6HSRT        PYHSRT
     C                   Z-ADD     A6LSPR        PYLSPR
     C                   Z-ADD     A6FXSD        PYFXSD
     C                   Z-ADD     A6MMSD        PYMMSD
     C                   Z-ADD     A6NQDP        PYNQDP
     C                   MOVEL     A6DICB        PYDICB
     C                   Z-ADD     A6SCEX        PYSCEX
     C                   MOVEL     A6EBDA        PYEBDA
     C                   Z-ADD     A6HBRT        PYHBRT
     C                   Z-ADD     A6ENC1        PYENC1
     C                   Z-ADD     A6ENC2        PYENC2
     C                   MOVEL     A6CACD        PYCACD
     C                   Z-ADD     A6CNMC        PYCNMC
     C                   MOVEL     A6WEDH        PYWEDH
     C                   MOVEL     A6MONH        PYMONH
     C                   MOVEL     A6TUEH        PYTUEH
     C                   MOVEL     A6THUH        PYTHUH
     C                   MOVEL     A6FRIH        PYFRIH
     C                   MOVEL     A6SATH        PYSATH
     C                   MOVEL     A6SUNH        PYSUNH
     C                   Z-ADD     A6DPBF        PYDPBF
     C                   Z-ADD     A6BYSR        PYBYSR
     C                   MOVEL     A6BYSS        PYBYSS
     C                   Z-ADD     A6SLSR        PYSLSR
     C                   MOVEL     A6SLSS        PYSLSS
     C                   Z-ADD     A6RMCM        PYRMCM
     C                   MOVEL     A6RECI        PYRECI
     C                   MOVEL     A6DPRU        PYDPRU
     C                   MOVEL     A6DNOR        PYDNOR
     C                   MOVEL     A6NDWR        PYNDWR
     C                   MOVEL     A6GMPY        PYGMPY
     C                   MOVEL     A6DLCD        PYDLCD
     C                   MOVEL     A6RDFC        PYRDFC
     C                   MOVEL     A6PMRT        PYPMRT
     C                   Z-ADD     A6RKSQ        PYRKSQ
     C                   MOVEL     A6DFPC        PYDFPC
     C                   MOVEL     A6DDPC        PYDDPC
     C                   Z-ADD     A6TKCC        PYTKCC
     C                   Z-ADD     A6CQCD        PYCQCD
     C                   Z-ADD     A6SMLD        PYSMLD
     C                   MOVEL     A6CSCD        PYCSCD
     C                   Z-ADD     A6ISON        PYISON
     C                   MOVEL     A6ISFC        PYISFC
     C                   MOVEL     A6MACD        PYMACD
     C                   MOVEL     A6FRAC        PYFRAC
     C                   MOVEL     A6NUWD        PYNUWD
     C                   MOVEL     A6MICD        PYMICD
     C                   MOVEL     A6INCY        PYINCY
     C                   Z-ADD     A6EUER        PYEUER
     C                   MOVEL     A6EUMD        PYEUMD
     C                   Z-ADD     A6TPSD        PYTPSD
     C**********         Z-ADD     A6TPED        PYTPED                                       199373
     C                   Z-ADD     99999         PYTPED                                       199373
     C                   Z-ADD     A6INER        PYINER
     C                   MOVEL     A6INMD        PYINMD
      *
     C                   Z-ADD     XCQSQ         CQSQ
     C     CQKEY         CHAIN     CQPAC                              13        *
      *
      **  Data base error
     C     *IN13         IFEQ      '1'
     C                   MOVEL     TREF          DBKEY
     C                   MOVEL     'CQPAC'       DBFILE
     C                   MOVEL     '013'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Obtain debit currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DRCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     DRCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '014'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save debit currency details
     C                   MOVEL     A6CYCD        DBCYCD            3
     C**********         MOVEL     A6SPAE        DBSPAE            4                          CGL029
     C**********         MOVEL     A6FTAE        DBFTAE            4                          CGL029
     C**********         MOVEL     A6SWAE        DBSWAE            4                          CGL029
     C**********         MOVEL     A6TAC4        DBTAC4            4                          CGL029
     C**********         MOVEL     A6TAC5        DBTAC5            4                          CGL029
     C                   MOVEL     A6SPAE        DBSPAE           10                          CGL029
     C                   MOVEL     A6FTAE        DBFTAE           10                          CGL029
     C                   MOVEL     A6SWAE        DBSWAE           10                          CGL029
     C                   MOVEL     A6TAC4        DBTAC4           10                          CGL029
     C                   MOVEL     A6TAC5        DBTAC5           10                          CGL029
     C                   MOVEL     A6CDFN        DBCDFN            2
     C                   MOVEL     A6ECDN        DBECDN            2
     C                   Z-ADD     A6LCD         DBLCD             5 0
     C                   MOVEL     A6TYLC        DBTYLC            1
     C                   MOVEL     A6CYNM        DBCYNM           14
     C                   Z-ADD     A6SPRT        DBSPRT           13 8
     C                   MOVEL     A6SWCY        DBSWCY            3
     C                   Z-ADD     A6NBDP        DBNBDP            1 0
     C                   Z-ADD     A6TXND        DBTXND            1 0
     C                   Z-ADD     A6PRRT        DBPRRT           13 8
     C                   Z-ADD     A6SRC1        DBSRC1            4 0
     C                   Z-ADD     A6SRC2        DBSRC2            4 0
     C                   MOVEL     A6DLCI        DBDLCI            1
     C                   Z-ADD     A6SSNB        DBSSNB            2 0
     C                   Z-ADD     A6ERLC        DBERLC           13 8
     C                   MOVEL     A6MDIN        DBMDIN            1
     C                   MOVEL     A6MDPR        DBMDPR            1
     C                   MOVEL     A6MDHB        DBMDHB            1
     C                   MOVEL     A6MDEX        DBMDEX            1
     C                   MOVEL     A6NOSN        DBNOSN           10
     C                   Z-ADD     A6SPDY        DBSPDY            3 0
     C                   Z-ADD     A6HSRT        DBHSRT           13 8
     C                   Z-ADD     A6LSPR        DBLSPR           13 8
     C                   Z-ADD     A6FXSD        DBFXSD            8 0
     C                   Z-ADD     A6MMSD        DBMMSD            8 0
     C                   Z-ADD     A6NQDP        DBNQDP            1 0
     C                   MOVEL     A6DICB        DBDICB            1
     C                   Z-ADD     A6SCEX        DBSCEX            1 0
     C                   MOVEL     A6EBDA        DBEBDA           29
     C                   Z-ADD     A6HBRT        DBHBRT           13 8
     C                   Z-ADD     A6ENC1        DBENC1            2 0
     C                   Z-ADD     A6ENC2        DBENC2            2 0
     C                   MOVEL     A6CACD        DBCACD            3
     C                   Z-ADD     A6CNMC        DBCNMC            2 0
     C                   MOVEL     A6WEDH        DBWEDH            1
     C                   MOVEL     A6MONH        DBMONH            1
     C                   MOVEL     A6TUEH        DBTUEH            1
     C                   MOVEL     A6THUH        DBTHUH            1
     C                   MOVEL     A6FRIH        DBFRIH            1
     C                   MOVEL     A6SATH        DBSATH            1
     C                   MOVEL     A6SUNH        DBSUNH            1
     C                   Z-ADD     A6DPBF        DBDPBF            1 0
     C                   Z-ADD     A6BYSR        DBBYSR           13 8
     C                   MOVEL     A6BYSS        DBBYSS            1
     C                   Z-ADD     A6SLSR        DBSLSR           13 8
     C                   MOVEL     A6SLSS        DBSLSS            1
     C                   Z-ADD     A6RMCM        DBRMCM            1 0
     C                   MOVEL     A6RECI        DBRECI            1
     C                   MOVEL     A6DPRU        DBDPRU            1
     C                   MOVEL     A6DNOR        DBDNOR            1
     C                   MOVEL     A6NDWR        DBNDWR            1
     C                   MOVEL     A6GMPY        DBGMPY            1
     C                   MOVEL     A6DLCD        DBDLCD            1
     C                   MOVEL     A6RDFC        DBRDFC            1
     C                   MOVEL     A6PMRT        DBPMRT            1
     C                   Z-ADD     A6RKSQ        DBRKSQ            3 0
     C                   MOVEL     A6DFPC        DBDFPC            4
     C                   MOVEL     A6DDPC        DBDDPC            4
     C                   Z-ADD     A6TKCC        DBTKCC            3 0
     C                   Z-ADD     A6CQCD        DBCQCD            2 0
     C                   Z-ADD     A6SMLD        DBSMLD            5 0
     C**********         MOVEL     A6CSCD        DBCSCD            4                          CGL029
     C                   MOVEL     A6CSCD        DBCSCD           10                          CGL029
     C                   Z-ADD     A6ISON        DBISON            3 0
     C                   MOVEL     A6ISFC        DBISFC           35
     C                   MOVEL     A6MACD        DBMACD           35
     C                   MOVEL     A6FRAC        DBFRAC            1
     C                   MOVEL     A6NUWD        DBNUWD            1
     C                   MOVEL     A6MICD        DBMICD           35
     C                   MOVEL     A6INCY        DBINCY            1
     C                   Z-ADD     A6EUER        DBEUER           13 8
     C                   MOVEL     A6EUMD        DBEUMD            1
     C                   Z-ADD     A6TPSD        DBTPSD            5 0
     C**********         Z-ADD     A6TPED        DBTPED            5 0                        199373
     C                   Z-ADD     99999         DBTPED            5 0                        199373
     C                   Z-ADD     A6INER        DBINER           13 8
     C                   MOVEL     A6INMD        DBINMD            1
      *END CP
     C                   END
      *
      **  Cheques to be collected
     C     PTYP          IFEQ      'CC'
     C     CQSQ          ANDGT     0
      *
     C                   Z-ADD     CQSQ          XCQSQ
     C                   Z-ADD     0             CQSQ
     C     CQKEY         CHAIN     CQCOD                              14        *
      *
      **  Data base error
     C     *IN14         IFEQ      '1'
     C                   MOVEL     TREF          DBKEY
     C                   MOVEL     'CQCOD'       DBFILE
     C                   MOVEL     '015'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Obtain settlement currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      SMCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     SMCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '016'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save settle currency details
     C                   MOVEL     A6CYCD        STCYCD
     C                   MOVEL     A6SPAE        STSPAE
     C                   MOVEL     A6FTAE        STFTAE
     C                   MOVEL     A6SWAE        STSWAE
     C                   MOVEL     A6TAC4        STTAC4
     C                   MOVEL     A6TAC5        STTAC5
     C                   MOVEL     A6CDFN        STCDFN
     C                   MOVEL     A6ECDN        STECDN
     C                   Z-ADD     A6LCD         STLCD
     C                   MOVEL     A6TYLC        STTYLC
     C                   MOVEL     A6CYNM        STCYNM
     C                   Z-ADD     A6SPRT        STSPRT
     C                   MOVEL     A6SWCY        STSWCY
     C                   Z-ADD     A6NBDP        STNBDP
     C                   Z-ADD     A6TXND        STTXND
     C                   Z-ADD     A6PRRT        STPRRT
     C                   Z-ADD     A6SRC1        STSRC1
     C                   Z-ADD     A6SRC2        STSRC2
     C                   MOVEL     A6DLCI        STDLCI
     C                   Z-ADD     A6SSNB        STSSNB
     C                   Z-ADD     A6ERLC        STERLC
     C                   MOVEL     A6MDIN        STMDIN
     C                   MOVEL     A6MDPR        STMDPR
     C                   MOVEL     A6MDHB        STMDHB
     C                   MOVEL     A6MDEX        STMDEX
     C                   MOVEL     A6NOSN        STNOSN
     C                   Z-ADD     A6SPDY        STSPDY
     C                   Z-ADD     A6HSRT        STHSRT
     C                   Z-ADD     A6LSPR        STLSPR
     C                   Z-ADD     A6FXSD        STFXSD
     C                   Z-ADD     A6MMSD        STMMSD
     C                   Z-ADD     A6NQDP        STNQDP
     C                   MOVEL     A6DICB        STDICB
     C                   Z-ADD     A6SCEX        STSCEX
     C                   MOVEL     A6EBDA        STEBDA
     C                   Z-ADD     A6HBRT        STHBRT
     C                   Z-ADD     A6ENC1        STENC1
     C                   Z-ADD     A6ENC2        STENC2
     C                   MOVEL     A6CACD        STCACD
     C                   Z-ADD     A6CNMC        STCNMC
     C                   MOVEL     A6WEDH        STWEDH
     C                   MOVEL     A6MONH        STMONH
     C                   MOVEL     A6TUEH        STTUEH
     C                   MOVEL     A6THUH        STTHUH
     C                   MOVEL     A6FRIH        STFRIH
     C                   MOVEL     A6SATH        STSATH
     C                   MOVEL     A6SUNH        STSUNH
     C                   Z-ADD     A6DPBF        STDPBF
     C                   Z-ADD     A6BYSR        STBYSR
     C                   MOVEL     A6BYSS        STBYSS
     C                   Z-ADD     A6SLSR        STSLSR
     C                   MOVEL     A6SLSS        STSLSS
     C                   Z-ADD     A6RMCM        STRMCM
     C                   MOVEL     A6RECI        STRECI
     C                   MOVEL     A6DPRU        STDPRU
     C                   MOVEL     A6DNOR        STDNOR
     C                   MOVEL     A6NDWR        STNDWR
     C                   MOVEL     A6GMPY        STGMPY
     C                   MOVEL     A6DLCD        STDLCD
     C                   MOVEL     A6RDFC        STRDFC
     C                   MOVEL     A6PMRT        STPMRT
     C                   Z-ADD     A6RKSQ        STRKSQ
     C                   MOVEL     A6DFPC        STDFPC
     C                   MOVEL     A6DDPC        STDDPC
     C                   Z-ADD     A6TKCC        STTKCC
     C                   Z-ADD     A6CQCD        STCQCD
     C                   Z-ADD     A6SMLD        STSMLD
     C                   MOVEL     A6CSCD        STCSCD
     C                   Z-ADD     A6ISON        STISON
     C                   MOVEL     A6ISFC        STISFC
     C                   MOVEL     A6MACD        STMACD
     C                   MOVEL     A6FRAC        STFRAC
     C                   MOVEL     A6NUWD        STNUWD
     C                   MOVEL     A6MICD        STMICD
     C                   MOVEL     A6INCY        STINCY
     C                   Z-ADD     A6EUER        STEUER
     C                   MOVEL     A6EUMD        STEUMD
     C                   Z-ADD     A6TPSD        STTPSD
     C**********         Z-ADD     A6TPED        STTPED                                       199373
     C                   Z-ADD     99999         STTPED                                       199373
     C                   Z-ADD     A6INER        STINER
     C                   MOVEL     A6INMD        STINMD
      *
     C                   Z-ADD     XCQSQ         CQSQ
     C     CQKEY         CHAIN     CQCOD                              14        *
      *
      **  Data base error
     C     *IN14         IFEQ      '1'
     C                   MOVEL     TREF          DBKEY
     C                   MOVEL     'CQCOD'       DBFILE
     C                   MOVEL     '017'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Obtain credit currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      CRCY          @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Data base error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     CRCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '018'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Save credit currency details
     C                   MOVEL     A6CYCD        CRCYCD            3
     C**********         MOVEL     A6SPAE        CRSPAE            4                          CGL029
     C**********         MOVEL     A6FTAE        CRFTAE            4                          CGL029
     C**********         MOVEL     A6SWAE        CRSWAE            4                          CGL029
     C**********         MOVEL     A6TAC4        CRTAC4            4                          CGL029
     C**********         MOVEL     A6TAC5        CRTAC5            4                          CGL029
     C                   MOVEL     A6SPAE        CRSPAE           10                          CGL029
     C                   MOVEL     A6FTAE        CRFTAE           10                          CGL029
     C                   MOVEL     A6SWAE        CRSWAE           10                          CGL029
     C                   MOVEL     A6TAC4        CRTAC4           10                          CGL029
     C                   MOVEL     A6TAC5        CRTAC5           10                          CGL029
     C                   MOVEL     A6CDFN        CRCDFN            2
     C                   MOVEL     A6ECDN        CRECDN            2
     C                   Z-ADD     A6LCD         CRLCD             5 0
     C                   MOVEL     A6TYLC        CRTYLC            1
     C                   MOVEL     A6CYNM        CRCYNM           14
     C                   Z-ADD     A6SPRT        CRSPRT           13 8
     C                   MOVEL     A6SWCY        CRSWCY            3
     C                   Z-ADD     A6NBDP        CRNBDP            1 0
     C                   Z-ADD     A6TXND        CRTXND            1 0
     C                   Z-ADD     A6PRRT        CRPRRT           13 8
     C                   Z-ADD     A6SRC1        CRSRC1            4 0
     C                   Z-ADD     A6SRC2        CRSRC2            4 0
     C                   MOVEL     A6DLCI        CRDLCI            1
     C                   Z-ADD     A6SSNB        CRSSNB            2 0
     C                   Z-ADD     A6ERLC        CRERLC           13 8
     C                   MOVEL     A6MDIN        CRMDIN            1
     C                   MOVEL     A6MDPR        CRMDPR            1
     C                   MOVEL     A6MDHB        CRMDHB            1
     C                   MOVEL     A6MDEX        CRMDEX            1
     C                   MOVEL     A6NOSN        CRNOSN           10
     C                   Z-ADD     A6SPDY        CRSPDY            3 0
     C                   Z-ADD     A6HSRT        CRHSRT           13 8
     C                   Z-ADD     A6LSPR        CRLSPR           13 8
     C                   Z-ADD     A6FXSD        CRFXSD            8 0
     C                   Z-ADD     A6MMSD        CRMMSD            8 0
     C                   Z-ADD     A6NQDP        CRNQDP            1 0
     C                   MOVEL     A6DICB        CRDICB            1
     C                   Z-ADD     A6SCEX        CRSCEX            1 0
     C                   MOVEL     A6EBDA        CREBDA           29
     C                   Z-ADD     A6HBRT        CRHBRT           13 8
     C                   Z-ADD     A6ENC1        CRENC1            2 0
     C                   Z-ADD     A6ENC2        CRENC2            2 0
     C                   MOVEL     A6CACD        CRCACD            3
     C                   Z-ADD     A6CNMC        CRCNMC            2 0
     C                   MOVEL     A6WEDH        CRWEDH            1
     C                   MOVEL     A6MONH        CRMONH            1
     C                   MOVEL     A6TUEH        CRTUEH            1
     C                   MOVEL     A6THUH        CRTHUH            1
     C                   MOVEL     A6FRIH        CRFRIH            1
     C                   MOVEL     A6SATH        CRSATH            1
     C                   MOVEL     A6SUNH        CRSUNH            1
     C                   Z-ADD     A6DPBF        CRDPBF            1 0
     C                   Z-ADD     A6BYSR        CRBYSR           13 8
     C                   MOVEL     A6BYSS        CRBYSS            1
     C                   Z-ADD     A6SLSR        CRSLSR           13 8
     C                   MOVEL     A6SLSS        CRSLSS            1
     C                   Z-ADD     A6RMCM        CRRMCM            1 0
     C                   MOVEL     A6RECI        CRRECI            1
     C                   MOVEL     A6DPRU        CRDPRU            1
     C                   MOVEL     A6DNOR        CRDNOR            1
     C                   MOVEL     A6NDWR        CRNDWR            1
     C                   MOVEL     A6GMPY        CRGMPY            1
     C                   MOVEL     A6DLCD        CRDLCD            1
     C                   MOVEL     A6RDFC        CRRDFC            1
     C                   MOVEL     A6PMRT        CRPMRT            1
     C                   Z-ADD     A6RKSQ        CRRKSQ            3 0
     C                   MOVEL     A6DFPC        CRDFPC            4
     C                   MOVEL     A6DDPC        CRDDPC            4
     C                   Z-ADD     A6TKCC        CRTKCC            3 0
     C                   Z-ADD     A6CQCD        CRCQCD            2 0
     C                   Z-ADD     A6SMLD        CRSMLD            5 0
     C**********         MOVEL     A6CSCD        CRCSCD            4                          CGL029
     C                   MOVEL     A6CSCD        CRCSCD           10                          CGL029
     C                   Z-ADD     A6ISON        CRISON            3 0
     C                   MOVEL     A6ISFC        CRISFC           35
     C                   MOVEL     A6MACD        CRMACD           35
     C                   MOVEL     A6FRAC        CRFRAC            1
     C                   MOVEL     A6NUWD        CRNUWD            1
     C                   MOVEL     A6MICD        CRMICD           35
     C                   MOVEL     A6INCY        CRINCY            1
     C                   Z-ADD     A6EUER        CREUER           13 8
     C                   MOVEL     A6EUMD        CREUMD            1
     C                   Z-ADD     A6TPSD        CRTPSD            5 0
     C**********         Z-ADD     A6TPED        CRTPED            5 0                        199373
     C                   Z-ADD     99999         CRTPED            5 0                        199373
     C                   Z-ADD     A6INER        CRINER           13 8
     C                   MOVEL     A6INMD        CRINMD            1
      *END CC
     C                   END
      *END PREF?
     C                   END
      *1&2
      **  Outgoing payment
     C     PTYP          IFEQ      'OP'
     C     OPIN          ANDNE     'Y'
      *
      **  Process transaction and opening balance
     C     PREF          IFNE      SPREF
     C     CQSQ          ORNE      SCQSQ
     C                   EXSR      TRANOP
     C                   ENDIF
      *
      **  Process outgoing payment input date
     C     AKEY3         IFEQ      'D'
     C     AKEY10        ANDEQ     'P'
     C                   EXSR      P10
     C                   END
      *
      **  Process outgoing payment settle value date
     C     AKEY3         IFEQ      'P'
     C     AKEY10        ANDEQ     'P'
     C                   EXSR      P11
     C                   END
      *3&4
      **  Process outgoing payment settlement fees
     C                   IF        AKey3 = 'P' OR AKey3 = 'R'
     C                   IF          AKey9 ='SS' OR AKey9 ='M1' OR
     C                               AKey9 ='M2' OR AKey9 ='M3' OR
     C                               AKey9 ='M4' OR AKey9 ='M5' OR
     C                               AKey9 ='ST' OR AKey9 ='N1' OR
     C                               AKey9 ='N2' OR AKey9 ='N3' OR
     C                               AKey9 ='N4' OR AKey9 ='N5' OR
     C                               AKey9 ='FM' OR AKey10 ='X' OR
     C                               AKey10 ='V' OR AKey10 ='Q' OR
     C                               AKey10 ='Y' OR AKey10 ='C' OR
     C                               AKey10 ='Z' OR AKey10 ='S' OR
     C                               AKey10 ='2' OR AKey10 ='M' OR
     C                               AKey10 ='3' OR AKey10 ='F' OR
     C                               AKey10 ='4' OR AKey10 ='J' OR
     C                               AKey10 ='5'
 
     C                   EXSR      P12
 
     C                   END
     C                   END
      *3&4
     C                   END
      *1&2
      **  Incoming payment
     C     PTYP          IFEQ      'IN'
     C     OPIN          ANDNE     'Y'
      *
      **  Process transaction and opening balance
     C     PREF          IFNE      SPREF
     C     CQSQ          ORNE      SCQSQ
     C                   EXSR      TRANIN
     C                   ENDIF
      *
      **  Process incoming payment input date
     C     AKEY3         IFEQ      'D'
     C     AKEY10        ANDEQ     'R'
     C                   EXSR      P20
     C                   END
      *
      **  Process incoming payment pay value date
     C     AKEY3         IFEQ      'P'
     C     AKEY10        ANDEQ     'R'
     C                   EXSR      P21
     C                   END
      *3&4
      **  Process incoming payment pay fees
     C                   IF        AKey3 = 'P' OR AKey3 = 'R'
     C                   IF          AKey9 ='M1' OR AKey9 ='M2' OR
     C                               AKey9 ='M3' OR AKey9 ='M4' OR
     C                               AKey9 ='M5' OR AKey9 ='N1' OR
     C                               AKey9 ='N2' OR AKey9 ='N3' OR
     C                               AKey9 ='N4' OR AKey9 ='N5' OR
     C                               AKey10 ='X' OR AKey10 ='V' OR
     C                               AKey10 ='Q' OR AKey10 ='Y' OR
     C                               AKey10 ='G' OR AKey10 ='6' OR
     C                               AKey10 ='H' OR AKey10 ='7' OR
     C                               AKey10 ='M' OR AKey10 ='3' OR
     C                               AKey10 ='F' OR AKey10 ='4' OR
     C                               AKey10 ='J' OR AKey10 ='5' OR
     C                               AKey9 ='FM'
 
     C                   EXSR      P22
 
     C                   END
     C                   END
      *3&4
     C                   END
      *1&2
      **  Cheques to be paid
     C     PTYP          IFEQ      'CP'
     C     CQSQ          ANDGT     0
      *
      **  Process transaction and opening balance
     C     PREF          IFNE      SPREF
     C     CQSQ          ORNE      SCQSQ
     C                   EXSR      TRANCP
     C                   END
      *
      **  Process cheques to be paid input date
     C     AKEY3         IFEQ      'D'
     C     AKEY10        ANDEQ     'P'
     C                   EXSR      P30
     C                   END
      *
      **  Process cheques to be paid debit value date
     C     AKEY3         IFEQ      'P'
     C     AKEY10        ANDEQ     'P'
     C                   EXSR      P31
     C                   END
      *3&4
      **  Process cheques to be paid debit fees
     C     AKEY3         IFEQ      'P'
     C     AKEY10        IFEQ      'C'
     C     AKEY10        OREQ      'Z'
     C     AKEY10        OREQ      'K'
     C     AKEY10        OREQ      '8'
     C     AKEY10        OREQ      'F'
     C     AKEY10        OREQ      '4'
     C     AKEY10        OREQ      'J'
     C     AKEY10        OREQ      '5'
     C     AKEY9         OREQ      'FM'
     C                   EXSR      P32
     C                   END
     C                   END
      *3&4
     C                   END
      *1&2
      **  Cheques to be collected
     C     PTYP          IFEQ      'CC'
     C     CQSQ          ANDGT     0
      *
      **  Process transaction and opening balance
     C     PREF          IFNE      SPREF
     C     CQSQ          ORNE      SCQSQ
     C                   EXSR      TRANCC
     C                   ENDIF
      *
      **  Process cheques to be collected input date
     C     AKEY3         IFEQ      'D'
     C     AKEY10        ANDEQ     'R'
     C                   EXSR      P40
     C                   END
      *
      **  Process cheques to be collected credit value
     C     AKEY3         IFEQ      'R'
     C     AKEY10        ANDEQ     'R'
     C                   EXSR      P41
     C                   END
      *3&4
      **  Process cheques to be collected credit fees
     C     AKEY3         IFEQ      'R'
     C     AKEY10        IFEQ      'X'
     C     AKEY10        OREQ      'V'
     C     AKEY10        OREQ      'C'
     C     AKEY10        OREQ      'Z'
     C     AKEY10        OREQ      'K'
     C     AKEY10        OREQ      '8'
     C     AKEY10        OREQ      'F'
     C     AKEY10        OREQ      '4'
     C     AKEY10        OREQ      'J'
     C     AKEY10        OREQ      '5'
     C     AKEY9         OREQ      'FM'
     C                   EXSR      P42
     C                   END
     C                   END
      *3&4
     C                   END
      *1&2
      *
      ** Outgoing request for transfer
      *
     C                   IF        %SUBST(PREF:1:1)='A'
      *
      ** Input date
     C                   IF        AKey3 = 'I'
     C                   IF          AKey10 ='H' OR AKey10 ='S' OR
     C                               AKey10 ='2' OR AKey9 ='SS' OR
     C                               AKey9 ='M1' OR AKey9 ='M2' OR
     C                               AKey9 ='M3' OR AKey9 ='M4' OR
     C                               AKey9 ='M5' OR AKey9 ='ST' OR
     C                               AKey9 ='N1' OR AKey9 ='N2' OR
     C                               AKey9 ='N3' OR AKey9 ='N4' OR
     C                               AKey9 ='N5'
     C                   EXSR      P50
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Incoming request for transfer
      *
     C                   IF        %SUBST(PREF:1:1)='B'
      *
      ** Input date
     C                   IF        AKey3 = 'I' AND AKey10 = 'T'
     C                   EXSR      P60
     C                   ENDIF
      *
      ** Debit date
     C                   IF        AKey3 = 'D' AND AKey10 = 'T'
     C                   EXSR      P61
     C                   ENDIF
      *
      ** Fees
     C                   IF        AKey3 = 'D' OR AKey3 = 'C'
     C                   IF         AKey10 = 'R' OR AKey10 = 'J' OR
     C                              AKey10 = 'F' OR AKey9 = 'M1' OR
     C                              AKey9 = 'M2' OR AKey9 = 'M3' OR
     C                              AKey9 = 'M4' OR AKey9 = 'M5' OR
     C                              AKey10 = '5' OR AKey10 = '4' OR
     C                              AKey9 = 'N1' OR AKey9 = 'N2' OR
     C                              AKey9 = 'N3' OR AKey9 = 'N4' OR
     C                              AKey9 = 'N5'
 
     C                   EXSR      P62
 
     C                   ENDIF
     C                   ENDIF
      *
      ** Credit date
     C                   IF        Akey3 = 'C' AND AKey10 = 'P'
     C                   EXSR      P63
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Outgoing customer credit transfer
      *
     C                   IF        %SUBST(PREF:1:1)='C'
      *
      ** Input date
     C                   IF        AKey3 = 'I' AND AKey10 = 'O'
     C                   EXSR      P70
     C                   ENDIF
 
     C                   IF        AKey3 = 'D'
      *
      ** Debit value date
     C                   IF         AKey10 = 'O'
     C                   EXSR      P71
     C                   ENDIF
      *
      ** Debit value date fees
     C                   IF         AKey10 = 'C' OR AKey9  ='SS' OR
     C                              AKey10 = 'S' OR AKey10 = 'J' OR
     C                              AKey10 = 'F' OR AKey9  ='M1' OR
     C                              AKey9  ='M2' OR AKey9  ='M3' OR
     C                              AKey9  ='M4' OR AKey9  ='M5' OR
     C                              AKey9  ='ST' OR AKey10 = '2' OR
     C                              AKey10 = '5' OR AKey10 = '4' OR
     C                              AKey9  ='N1' OR AKey9  ='N2' OR
     C                              AKey9  ='N3' OR AKey9  ='N4' OR
     C                              AKey9  ='N5'
 
     C                   EXSR      P72
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Incoming customer credit transfer
      *
     C                   IF        %SUBST(PREF:1:1)='D'
      *
      ** Input date
     C                   IF        AKey3 = 'I' AND AKey10 = 'J'
     C                   EXSR      P80
     C                   ENDIF
      *
      ** Credit date
     C                   IF        AKey3 = 'C' AND AKey10 = 'L'
     C                   EXSR      P81
     C                   ENDIF
 
     C                   IF        AKey3 = 'D'
      *
      ** Transfer date fees
     C                   IF         AKey10 = 'R' OR AKey10 = 'J' OR
     C                              AKey10 = 'F' OR AKey9  ='M1' OR
     C                              AKey9  ='M2' OR AKey9  ='M3' OR
     C                              AKey9  ='M4' OR AKey9  ='M5' OR
     C                              AKey10 = '5' OR AKey10 = '4' OR
     C                              AKey9  ='N1' OR AKey9  ='N2' OR
     C                              AKey9  ='N3' OR AKey9  ='N4' OR
     C                              AKey9  ='N5'
 
     C                   EXSR      P82
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * TRANOP - Outgoing payment transaction & opening balance processing.
      * Initialise the limit and revenue extraction module for the outgoing
      * payment by calculating the P/L, then creating 'transaction' and
      * 'opening position' entries.
      ********************************************************************
     C     TRANOP        BEGSR
      *
      **  Restore settle currency details
     C                   MOVEL     STCYCD        A6CYCD
     C                   MOVEL     STSPAE        A6SPAE
     C                   MOVEL     STFTAE        A6FTAE
     C                   MOVEL     STSWAE        A6SWAE
     C                   MOVEL     STTAC4        A6TAC4
     C                   MOVEL     STTAC5        A6TAC5
     C                   MOVEL     STCDFN        A6CDFN
     C                   MOVEL     STECDN        A6ECDN
     C                   Z-ADD     STLCD         A6LCD
     C                   MOVEL     STTYLC        A6TYLC
     C                   MOVEL     STCYNM        A6CYNM
     C                   Z-ADD     STSPRT        A6SPRT
     C                   MOVEL     STSWCY        A6SWCY
     C                   Z-ADD     STNBDP        A6NBDP
     C                   Z-ADD     STTXND        A6TXND
     C                   Z-ADD     STPRRT        A6PRRT
     C                   Z-ADD     STSRC1        A6SRC1
     C                   Z-ADD     STSRC2        A6SRC2
     C                   MOVEL     STDLCI        A6DLCI
     C                   Z-ADD     STSSNB        A6SSNB
     C                   Z-ADD     STERLC        A6ERLC
     C                   MOVEL     STMDIN        A6MDIN
     C                   MOVEL     STMDPR        A6MDPR
     C                   MOVEL     STMDHB        A6MDHB
     C                   MOVEL     STMDEX        A6MDEX
     C                   MOVEL     STNOSN        A6NOSN
     C                   Z-ADD     STSPDY        A6SPDY
     C                   Z-ADD     STHSRT        A6HSRT
     C                   Z-ADD     STLSPR        A6LSPR
     C                   Z-ADD     STFXSD        A6FXSD
     C                   Z-ADD     STMMSD        A6MMSD
     C                   Z-ADD     STNQDP        A6NQDP
     C                   MOVEL     STDICB        A6DICB
     C                   Z-ADD     STSCEX        A6SCEX
     C                   MOVEL     STEBDA        A6EBDA
     C                   Z-ADD     STHBRT        A6HBRT
     C                   Z-ADD     STENC1        A6ENC1
     C                   Z-ADD     STENC2        A6ENC2
     C                   MOVEL     STCACD        A6CACD
     C                   Z-ADD     STCNMC        A6CNMC
     C                   MOVEL     STWEDH        A6WEDH
     C                   MOVEL     STMONH        A6MONH
     C                   MOVEL     STTUEH        A6TUEH
     C                   MOVEL     STTHUH        A6THUH
     C                   MOVEL     STFRIH        A6FRIH
     C                   MOVEL     STSATH        A6SATH
     C                   MOVEL     STSUNH        A6SUNH
     C                   Z-ADD     STDPBF        A6DPBF
     C                   Z-ADD     STBYSR        A6BYSR
     C                   MOVEL     STBYSS        A6BYSS
     C                   Z-ADD     STSLSR        A6SLSR
     C                   MOVEL     STSLSS        A6SLSS
     C                   Z-ADD     STRMCM        A6RMCM
     C                   MOVEL     STRECI        A6RECI
     C                   MOVEL     STDPRU        A6DPRU
     C                   MOVEL     STDNOR        A6DNOR
     C                   MOVEL     STNDWR        A6NDWR
     C                   MOVEL     STGMPY        A6GMPY
     C                   MOVEL     STDLCD        A6DLCD
     C                   MOVEL     STRDFC        A6RDFC
     C                   MOVEL     STPMRT        A6PMRT
     C                   Z-ADD     STRKSQ        A6RKSQ
     C                   MOVEL     STDFPC        A6DFPC
     C                   MOVEL     STDDPC        A6DDPC
     C                   Z-ADD     STTKCC        A6TKCC
     C                   Z-ADD     STCQCD        A6CQCD
     C                   Z-ADD     STSMLD        A6SMLD
     C                   MOVEL     STCSCD        A6CSCD
     C                   Z-ADD     STISON        A6ISON
     C                   MOVEL     STISFC        A6ISFC
     C                   MOVEL     STMACD        A6MACD
     C                   MOVEL     STFRAC        A6FRAC
     C                   MOVEL     STNUWD        A6NUWD
     C                   MOVEL     STMICD        A6MICD
     C                   MOVEL     STINCY        A6INCY
     C                   Z-ADD     STEUER        A6EUER
     C                   MOVEL     STEUMD        A6EUMD
     C                   Z-ADD     STTPSD        A6TPSD
     C                   Z-ADD     STTPED        A6TPED
     C                   Z-ADD     STINER        A6INER
     C                   MOVEL     STINMD        A6INMD
      *
      **  Revalue settle amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      'B'           BUYSELL           1
     C                   PARM      SMCY          ECCY              3
     C                   PARM      SLDT          EDAT              5 0
     C                   PARM      SMAM          EAMT             13 0
     C                   PARM      SBCQ          DBCE             13 0
     C                   PARM      BJRDNB        BJRDNB            5 0
     C                   PARM      BJCYCD        BJCYCD            3
     C                   PARM      BSNBDP        BSNBDP            1 0
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     PLAM          STPLAM           13 0
      *
      **  Restore pay currency details
     C                   MOVEL     PYCYCD        A6CYCD
     C                   MOVEL     PYSPAE        A6SPAE
     C                   MOVEL     PYFTAE        A6FTAE
     C                   MOVEL     PYSWAE        A6SWAE
     C                   MOVEL     PYTAC4        A6TAC4
     C                   MOVEL     PYTAC5        A6TAC5
     C                   MOVEL     PYCDFN        A6CDFN
     C                   MOVEL     PYECDN        A6ECDN
     C                   Z-ADD     PYLCD         A6LCD
     C                   MOVEL     PYTYLC        A6TYLC
     C                   MOVEL     PYCYNM        A6CYNM
     C                   Z-ADD     PYSPRT        A6SPRT
     C                   MOVEL     PYSWCY        A6SWCY
     C                   Z-ADD     PYNBDP        A6NBDP
     C                   Z-ADD     PYTXND        A6TXND
     C                   Z-ADD     PYPRRT        A6PRRT
     C                   Z-ADD     PYSRC1        A6SRC1
     C                   Z-ADD     PYSRC2        A6SRC2
     C                   MOVEL     PYDLCI        A6DLCI
     C                   Z-ADD     PYSSNB        A6SSNB
     C                   Z-ADD     PYERLC        A6ERLC
     C                   MOVEL     PYMDIN        A6MDIN
     C                   MOVEL     PYMDPR        A6MDPR
     C                   MOVEL     PYMDHB        A6MDHB
     C                   MOVEL     PYMDEX        A6MDEX
     C                   MOVEL     PYNOSN        A6NOSN
     C                   Z-ADD     PYSPDY        A6SPDY
     C                   Z-ADD     PYHSRT        A6HSRT
     C                   Z-ADD     PYLSPR        A6LSPR
     C                   Z-ADD     PYFXSD        A6FXSD
     C                   Z-ADD     PYMMSD        A6MMSD
     C                   Z-ADD     PYNQDP        A6NQDP
     C                   MOVEL     PYDICB        A6DICB
     C                   Z-ADD     PYSCEX        A6SCEX
     C                   MOVEL     PYEBDA        A6EBDA
     C                   Z-ADD     PYHBRT        A6HBRT
     C                   Z-ADD     PYENC1        A6ENC1
     C                   Z-ADD     PYENC2        A6ENC2
     C                   MOVEL     PYCACD        A6CACD
     C                   Z-ADD     PYCNMC        A6CNMC
     C                   MOVEL     PYWEDH        A6WEDH
     C                   MOVEL     PYMONH        A6MONH
     C                   MOVEL     PYTUEH        A6TUEH
     C                   MOVEL     PYTHUH        A6THUH
     C                   MOVEL     PYFRIH        A6FRIH
     C                   MOVEL     PYSATH        A6SATH
     C                   MOVEL     PYSUNH        A6SUNH
     C                   Z-ADD     PYDPBF        A6DPBF
     C                   Z-ADD     PYBYSR        A6BYSR
     C                   MOVEL     PYBYSS        A6BYSS
     C                   Z-ADD     PYSLSR        A6SLSR
     C                   MOVEL     PYSLSS        A6SLSS
     C                   Z-ADD     PYRMCM        A6RMCM
     C                   MOVEL     PYRECI        A6RECI
     C                   MOVEL     PYDPRU        A6DPRU
     C                   MOVEL     PYDNOR        A6DNOR
     C                   MOVEL     PYNDWR        A6NDWR
     C                   MOVEL     PYGMPY        A6GMPY
     C                   MOVEL     PYDLCD        A6DLCD
     C                   MOVEL     PYRDFC        A6RDFC
     C                   MOVEL     PYPMRT        A6PMRT
     C                   Z-ADD     PYRKSQ        A6RKSQ
     C                   MOVEL     PYDFPC        A6DFPC
     C                   MOVEL     PYDDPC        A6DDPC
     C                   Z-ADD     PYTKCC        A6TKCC
     C                   Z-ADD     PYCQCD        A6CQCD
     C                   Z-ADD     PYSMLD        A6SMLD
     C                   MOVEL     PYCSCD        A6CSCD
     C                   Z-ADD     PYISON        A6ISON
     C                   MOVEL     PYISFC        A6ISFC
     C                   MOVEL     PYMACD        A6MACD
     C                   MOVEL     PYFRAC        A6FRAC
     C                   MOVEL     PYNUWD        A6NUWD
     C                   MOVEL     PYMICD        A6MICD
     C                   MOVEL     PYINCY        A6INCY
     C                   Z-ADD     PYEUER        A6EUER
     C                   MOVEL     PYEUMD        A6EUMD
     C                   Z-ADD     PYTPSD        A6TPSD
     C                   Z-ADD     PYTPED        A6TPED
     C                   Z-ADD     PYINER        A6INER
     C                   MOVEL     PYINMD        A6INMD
      *
      **  Revalue pay amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      'S'           BUYSELL           1
     C                   PARM      PCCY          ECCY              3
     C                   PARM      PVDT          EDAT              5 0
     C                   PARM      PYAM          EAMT             13 0
     C                   PARM      PBCQ          DBCE             13 0
     C                   PARM      BJRDNB        BJRDNB            5 0
     C                   PARM      BJCYCD        BJCYCD            3
     C                   PARM      BSNBDP        BSNBDP            1 0
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     PLAM          PYPLAM           13 0
      *
      **  Ordering customer contains retail account number
     C     ORCT          IFEQ      'R'
     C                   MOVEL     ORC1          WRK10            10 0
     C                   IF        %SUBST(ORC1:1:1) = '/'                                     CFT032
     C                   EVAL      WORC1 = %SUBST(ORC1:2:10)                                  CFT032
     C                   MOVEL     WORC1         WRK10                                        CFT032
     C                   ENDIF                                                                CFT032
      *
     C     WRK10         CHAIN     ACNUM                              15
      *
      **  Data base error
     C     *IN15         IFEQ      '1'
     C                   MOVEL     WRK10         DBKEY
     C                   MOVEL     'ACNUM'       DBFILE
     C                   MOVEL     '019'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     CNUM          SETCUS            6
     C                   ENDIF
      *
      **  Ordering customer contains a partial account number (no currency)
     C     ORCT          IFEQ      'P'
     C                   MOVEL     ORC1          SETCUS
     C                   IF        %SUBST(ORC1:1:1) = '/'                                     CFT032
     C                   EVAL      SETCUS = %SUBST(ORC1:2:10)                                 CFT032
     C                   ENDIF                                                                CFT032
     C                   ENDIF
      *
     C     ORCT          IFEQ      'I'                                                      BG015146
     C                   MOVEL     ORC1          SETCUS                                     BG015146
     C                   IF        %SUBST(ORC1:1:1) = '/'                                   BG015146
     C                   EVAL      SETCUS = %SUBST(ORC1:2:34)                               BG015146
     C                   ELSE                                                               BG015146
     C                   EVAL      SETCUS = %SUBST(ORC1:1:34)                               BG015146
     C                   ENDIF                                                              BG015146
     C                   ENDIF                                                              BG015146
      *                                                                                     BG015146
     C                   CLEAR                   T#TRAN
      *
      **  Set up projected transaction data structure
     C                   MOVEL     'FT'          T#MOD
     C                   MOVEL     PREF          T#TREF
     C                   MOVEL     'OP'          T#TRTP
     C                   MOVEL     PYST          T#TRST
     C                   EVAL      T#TDES = 'OUTGOING PAYMENT'
     C     SLDT          IFLT      OEDT
     C                   MOVEL     SLDT          T#DDAT
     C                   ELSE
     C                   MOVEL     OEDT          T#DDAT
     C                   ENDIF
     C                   MOVEL     SLDT          T#VDAT
     C                   MOVEL     PVDT          T#MDAT
     C                   MOVEL     BRCA          T#BRCA
     C                   MOVEL     BOKC          T#BOOK
     C                   MOVEL     PRFC          T#TPFC
     C                   MOVEL     SETCUS        T#CPTY
     C                   MOVEL     SETCUS        T#RCST
     C                   EVAL      T#MKVL = STPLAM + PYPLAM
     C                   MOVEL     BJCYCD        T#VCCY
     C                   MOVEL     BSNBDP        T#VCDP
     C                   MOVEL     'I'           T#ACTN
      *
      **  Import the details of the payment
     C                   MOVEL     '*IMPTRAN'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      **  Clear projected positions data structure
     C                   CLEAR                   P#POSN
      *
      **  Set up projected positions data structure
     C                   MOVEL     'FT'          P#MOD
     C                   MOVEL     PREF          P#TREF
     C                   MOVEL     'A'           P#ASLI
     C                   MOVEL     SLDT          P#IACD
     C                   Z-ADD     SMAM          P#NOML
     C                   MOVEL     SMCY          P#CCY
     C                   Z-ADD     STNBDP        P#NCDP
     C                   Z-ADD     STNBDP        P#NMDP
     C                   Z-ADD     STSPDY        P#SPDY
      *
      **  Import the details of the opening position
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * P10 - Outgoing payment input date processing
      * create the deal date event in the limit and revenue extraction
      * module.
      ********************************************************************
     C     P10           BEGSR
      *
      ** Set revenue ordering customer type
      ** Set revenue ordering customer in
      ** Set revenue beneficiary customer type
      ** Set revenue beneficiary customer in
     C                   EVAL      OrdCustTp = ORCT
     C                   EVAL      OrdCust   = ORC1
     C                   EVAL      BnfCustTp = BNCT
     C                   EVAL      BnfCust   = BNC1
      *
      ** Determine revenue customer.
      *
     C                   EXSR      P97
      *
      ** Set settle customer number as revenue customer number
     C                   EVAL      FPCNUM = WRevCust
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     PREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'DD'          E#EVTP
      *
      **  Import the details of the deal date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * P11 - Outgoing payment settlement date processing
      * create the value date event in the limit and revenue extraction
      * module and to create the margin event if a margin rate was not
      * entered on the transaction.
      ********************************************************************
     C     P11           BEGSR
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     PREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'VD'          E#EVTP
      *
      **  Import the details of the value date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      * If pay currency not equal to settle currency and FX margin points
      * zero. The payment transaction has a foreign exchange element which
      * may include margin but margin was not entered at time of transaction
      * In this case an account key is not generated for the margin.
      * Calculate the margin and create appropriate event.
      *
     C     PCCY          IFNE      SMCY
     C     FXMP          ANDEQ     0
      *
      **  Pay currency equals base currency.
     C     PCCY          IFEQ      BJCYCD
      *
      **  Convert the pay amount to settlement currency
     C                   Z-ADD     PYNBDP        ZCDPI
     C                   Z-ADD     STNBDP        ZCDPO
     C     STMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     STSPRT        ZEXCH
     C                   Z-ADD     PYAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        STPYAM           15 0
      *
     C                   ELSE
      *
      **  Settlement currency equals base currency
     C     SMCY          IFEQ      BJCYCD
      *
      **  Convert the pay amount to settlement currency
     C                   Z-ADD     PYNBDP        ZCDPI
     C                   Z-ADD     STNBDP        ZCDPO
     C     PYMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     PYSPRT        ZEXCH
     C                   Z-ADD     PYAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        STPYAM
      *
     C                   END
     C                   END
      *
      **  Neither settlement nor pay currency equals base currency
     C     PCCY          IFNE      BJCYCD
     C     SMCY          ANDNE     BJCYCD
      *
      **  Convert the pay amount to base currency
     C                   Z-ADD     PYNBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   MOVEL     PYMDIN        ZMD
      *
     C                   Z-ADD     PYSPRT        ZEXCH
     C                   Z-ADD     PYAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        BSPYAM           15 0
      *
      **  Convert the base amount to settlement currency
     C                   Z-ADD     BSNBDP        ZCDPI
     C                   Z-ADD     STNBDP        ZCDPO
     C     STMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     STSPRT        ZEXCH
     C                   Z-ADD     BSPYAM        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        STPYAM
      *
     C                   END
      *
      **  Calculate margin
     C     SMAM          SUB       STPYAM        MARGIN           15 0
      *
      **  If negative 'out' else 'in'
     C     MARGIN        IFLT      0
     C                   MOVEL     'O'           INOUT             1
     C                   MULT      -1            MARGIN
     C                   ELSE
     C                   MOVEL     'I'           INOUT
     C                   END
      *
      **  If calculated margin not zero
     C     MARGIN        IFNE      0
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     PREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'FE'          E#EVTP
     C                   Z-ADD     MARGIN        E#COMM
     C                   MOVEL     SMCY          E#CCY
     C                   Z-ADD     STNBDP        E#NCDP
     C                   MOVEL     *BLANKS       E#ACIN
     C                   MOVEL     'Y'           E#SSET
     C                   MOVEL     INOUT         E#IO
      *
      **  Import the details of the calculated margin event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C                   END
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * P12 - Outgoing payment settlement fees
      * create a charge event for each charge account key.
      ********************************************************************
     C     P12           BEGSR
      *
      ** Setup fee code.
      *
     C                   EXSR      P95
 
     C*************      EVAL      E#FEEC = FeeCode                                           208221
 
      *
      **  Clear projected events data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected events data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     PREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'FE'          E#EVTP
     C                   Z-ADD     EAMT          E#CHRG
     C                   MOVEL     ECCY          E#CCY
     C                   Z-ADD     EVNBDP        E#NCDP
     C                   MOVEL     *BLANKS       E#ACIN
     C                   MOVEL     'Y'           E#SSET
     C                   MOVEL     '05'          E#SETM
     C                   EVAL      E#SETA = FPCNUM + FPACOD +FPASEQ
     C                   MOVEL     FPBRCH        E#SETB
     C                   MOVEL     FPCCY         E#SETC
     C                   MOVEL     *BLANKS       E#PRCD
     C                   MOVEL     'I'           E#IO
     C                   EVAL      E#FEEC = FeeCode                                           208221
      *
      **  Import the details of the charge event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * TRANIN - Incoming payment transaction & opening balance processing.
      * Initialise the limit and revenue extraction module for the incoming
      * payment by calculating the P/L, then creating 'transaction' and
      * 'opening position' entries.
      ********************************************************************
     C     TRANIN        BEGSR
      *
      **  Restore settle currency details
     C                   MOVEL     STCYCD        A6CYCD
     C                   MOVEL     STSPAE        A6SPAE
     C                   MOVEL     STFTAE        A6FTAE
     C                   MOVEL     STSWAE        A6SWAE
     C                   MOVEL     STTAC4        A6TAC4
     C                   MOVEL     STTAC5        A6TAC5
     C                   MOVEL     STCDFN        A6CDFN
     C                   MOVEL     STECDN        A6ECDN
     C                   Z-ADD     STLCD         A6LCD
     C                   MOVEL     STTYLC        A6TYLC
     C                   MOVEL     STCYNM        A6CYNM
     C                   Z-ADD     STSPRT        A6SPRT
     C                   MOVEL     STSWCY        A6SWCY
     C                   Z-ADD     STNBDP        A6NBDP
     C                   Z-ADD     STTXND        A6TXND
     C                   Z-ADD     STPRRT        A6PRRT
     C                   Z-ADD     STSRC1        A6SRC1
     C                   Z-ADD     STSRC2        A6SRC2
     C                   MOVEL     STDLCI        A6DLCI
     C                   Z-ADD     STSSNB        A6SSNB
     C                   Z-ADD     STERLC        A6ERLC
     C                   MOVEL     STMDIN        A6MDIN
     C                   MOVEL     STMDPR        A6MDPR
     C                   MOVEL     STMDHB        A6MDHB
     C                   MOVEL     STMDEX        A6MDEX
     C                   MOVEL     STNOSN        A6NOSN
     C                   Z-ADD     STSPDY        A6SPDY
     C                   Z-ADD     STHSRT        A6HSRT
     C                   Z-ADD     STLSPR        A6LSPR
     C                   Z-ADD     STFXSD        A6FXSD
     C                   Z-ADD     STMMSD        A6MMSD
     C                   Z-ADD     STNQDP        A6NQDP
     C                   MOVEL     STDICB        A6DICB
     C                   Z-ADD     STSCEX        A6SCEX
     C                   MOVEL     STEBDA        A6EBDA
     C                   Z-ADD     STHBRT        A6HBRT
     C                   Z-ADD     STENC1        A6ENC1
     C                   Z-ADD     STENC2        A6ENC2
     C                   MOVEL     STCACD        A6CACD
     C                   Z-ADD     STCNMC        A6CNMC
     C                   MOVEL     STWEDH        A6WEDH
     C                   MOVEL     STMONH        A6MONH
     C                   MOVEL     STTUEH        A6TUEH
     C                   MOVEL     STTHUH        A6THUH
     C                   MOVEL     STFRIH        A6FRIH
     C                   MOVEL     STSATH        A6SATH
     C                   MOVEL     STSUNH        A6SUNH
     C                   Z-ADD     STDPBF        A6DPBF
     C                   Z-ADD     STBYSR        A6BYSR
     C                   MOVEL     STBYSS        A6BYSS
     C                   Z-ADD     STSLSR        A6SLSR
     C                   MOVEL     STSLSS        A6SLSS
     C                   Z-ADD     STRMCM        A6RMCM
     C                   MOVEL     STRECI        A6RECI
     C                   MOVEL     STDPRU        A6DPRU
     C                   MOVEL     STDNOR        A6DNOR
     C                   MOVEL     STNDWR        A6NDWR
     C                   MOVEL     STGMPY        A6GMPY
     C                   MOVEL     STDLCD        A6DLCD
     C                   MOVEL     STRDFC        A6RDFC
     C                   MOVEL     STPMRT        A6PMRT
     C                   Z-ADD     STRKSQ        A6RKSQ
     C                   MOVEL     STDFPC        A6DFPC
     C                   MOVEL     STDDPC        A6DDPC
     C                   Z-ADD     STTKCC        A6TKCC
     C                   Z-ADD     STCQCD        A6CQCD
     C                   Z-ADD     STSMLD        A6SMLD
     C                   MOVEL     STCSCD        A6CSCD
     C                   Z-ADD     STISON        A6ISON
     C                   MOVEL     STISFC        A6ISFC
     C                   MOVEL     STMACD        A6MACD
     C                   MOVEL     STFRAC        A6FRAC
     C                   MOVEL     STNUWD        A6NUWD
     C                   MOVEL     STMICD        A6MICD
     C                   MOVEL     STINCY        A6INCY
     C                   Z-ADD     STEUER        A6EUER
     C                   MOVEL     STEUMD        A6EUMD
     C                   Z-ADD     STTPSD        A6TPSD
     C                   Z-ADD     STTPED        A6TPED
     C                   Z-ADD     STINER        A6INER
     C                   MOVEL     STINMD        A6INMD
      *
      **  Revalue settle amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      'B'           BUYSELL           1
     C                   PARM      SMCY          ECCY              3
     C                   PARM      SLDT          EDAT              5 0
     C                   PARM      SMAM          EAMT             13 0
     C                   PARM      SBCQ          DBCE             13 0
     C                   PARM      BJRDNB        BJRDNB            5 0
     C                   PARM      BJCYCD        BJCYCD            3
     C                   PARM      BSNBDP        BSNBDP            1 0
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     PLAM          STPLAM
      *
      **  Restore pay currency details
     C                   MOVEL     PYCYCD        A6CYCD
     C                   MOVEL     PYSPAE        A6SPAE
     C                   MOVEL     PYFTAE        A6FTAE
     C                   MOVEL     PYSWAE        A6SWAE
     C                   MOVEL     PYTAC4        A6TAC4
     C                   MOVEL     PYTAC5        A6TAC5
     C                   MOVEL     PYCDFN        A6CDFN
     C                   MOVEL     PYECDN        A6ECDN
     C                   Z-ADD     PYLCD         A6LCD
     C                   MOVEL     PYTYLC        A6TYLC
     C                   MOVEL     PYCYNM        A6CYNM
     C                   Z-ADD     PYSPRT        A6SPRT
     C                   MOVEL     PYSWCY        A6SWCY
     C                   Z-ADD     PYNBDP        A6NBDP
     C                   Z-ADD     PYTXND        A6TXND
     C                   Z-ADD     PYPRRT        A6PRRT
     C                   Z-ADD     PYSRC1        A6SRC1
     C                   Z-ADD     PYSRC2        A6SRC2
     C                   MOVEL     PYDLCI        A6DLCI
     C                   Z-ADD     PYSSNB        A6SSNB
     C                   Z-ADD     PYERLC        A6ERLC
     C                   MOVEL     PYMDIN        A6MDIN
     C                   MOVEL     PYMDPR        A6MDPR
     C                   MOVEL     PYMDHB        A6MDHB
     C                   MOVEL     PYMDEX        A6MDEX
     C                   MOVEL     PYNOSN        A6NOSN
     C                   Z-ADD     PYSPDY        A6SPDY
     C                   Z-ADD     PYHSRT        A6HSRT
     C                   Z-ADD     PYLSPR        A6LSPR
     C                   Z-ADD     PYFXSD        A6FXSD
     C                   Z-ADD     PYMMSD        A6MMSD
     C                   Z-ADD     PYNQDP        A6NQDP
     C                   MOVEL     PYDICB        A6DICB
     C                   Z-ADD     PYSCEX        A6SCEX
     C                   MOVEL     PYEBDA        A6EBDA
     C                   Z-ADD     PYHBRT        A6HBRT
     C                   Z-ADD     PYENC1        A6ENC1
     C                   Z-ADD     PYENC2        A6ENC2
     C                   MOVEL     PYCACD        A6CACD
     C                   Z-ADD     PYCNMC        A6CNMC
     C                   MOVEL     PYWEDH        A6WEDH
     C                   MOVEL     PYMONH        A6MONH
     C                   MOVEL     PYTUEH        A6TUEH
     C                   MOVEL     PYTHUH        A6THUH
     C                   MOVEL     PYFRIH        A6FRIH
     C                   MOVEL     PYSATH        A6SATH
     C                   MOVEL     PYSUNH        A6SUNH
     C                   Z-ADD     PYDPBF        A6DPBF
     C                   Z-ADD     PYBYSR        A6BYSR
     C                   MOVEL     PYBYSS        A6BYSS
     C                   Z-ADD     PYSLSR        A6SLSR
     C                   MOVEL     PYSLSS        A6SLSS
     C                   Z-ADD     PYRMCM        A6RMCM
     C                   MOVEL     PYRECI        A6RECI
     C                   MOVEL     PYDPRU        A6DPRU
     C                   MOVEL     PYDNOR        A6DNOR
     C                   MOVEL     PYNDWR        A6NDWR
     C                   MOVEL     PYGMPY        A6GMPY
     C                   MOVEL     PYDLCD        A6DLCD
     C                   MOVEL     PYRDFC        A6RDFC
     C                   MOVEL     PYPMRT        A6PMRT
     C                   Z-ADD     PYRKSQ        A6RKSQ
     C                   MOVEL     PYDFPC        A6DFPC
     C                   MOVEL     PYDDPC        A6DDPC
     C                   Z-ADD     PYTKCC        A6TKCC
     C                   Z-ADD     PYCQCD        A6CQCD
     C                   Z-ADD     PYSMLD        A6SMLD
     C                   MOVEL     PYCSCD        A6CSCD
     C                   Z-ADD     PYISON        A6ISON
     C                   MOVEL     PYISFC        A6ISFC
     C                   MOVEL     PYMACD        A6MACD
     C                   MOVEL     PYFRAC        A6FRAC
     C                   MOVEL     PYNUWD        A6NUWD
     C                   MOVEL     PYMICD        A6MICD
     C                   MOVEL     PYINCY        A6INCY
     C                   Z-ADD     PYEUER        A6EUER
     C                   MOVEL     PYEUMD        A6EUMD
     C                   Z-ADD     PYTPSD        A6TPSD
     C                   Z-ADD     PYTPED        A6TPED
     C                   Z-ADD     PYINER        A6INER
     C                   MOVEL     PYINMD        A6INMD
      *
      **  Revalue pay amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      'S'           BUYSELL           1
     C                   PARM      PCCY          ECCY              3
     C                   PARM      PVDT          EDAT              5 0
     C                   PARM      PYAM          EAMT             13 0
     C                   PARM      PBCQ          DBCE             13 0
     C                   PARM      BJRDNB        BJRDNB            5 0
     C                   PARM      BJCYCD        BJCYCD            3
     C                   PARM      BSNBDP        BSNBDP            1 0
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     PLAM          PYPLAM
      *
      **  Beneficiary customer contains a retail account number
     C     BNCT          IFEQ      'R'
     C                   MOVEL     BNC1          WRK10
      *
     C     WRK10         CHAIN     ACNUM                              15
      *
      **  Data base error
     C     *IN15         IFEQ      '1'
     C                   MOVEL     WRK10         DBKEY
     C                   MOVEL     'ACNUM'       DBFILE
     C                   MOVEL     '020'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     CNUM          PAYCUS            6
     C                   ENDIF
      *
      **  Beneficiary customer contains partial account number (no currency)
     C     BNCT          IFEQ      'P'
     C                   MOVEL     BNC1          PAYCUS
     C                   ENDIF
      *
     C                   CLEAR                   T#TRAN
      *
      **  Set up projected transaction data structure
     C                   MOVEL     'FT'          T#MOD
     C                   MOVEL     PREF          T#TREF
     C                   MOVEL     'IN'          T#TRTP
     C                   MOVEL     PYST          T#TRST
     C                   EVAL      T#TDES = 'INCOMING PAYMENT'
     C     SLDT          IFLT      OEDT
     C                   MOVEL     SLDT          T#DDAT
     C                   ELSE
     C                   MOVEL     OEDT          T#DDAT
     C                   ENDIF
     C                   MOVEL     SLDT          T#VDAT
     C                   MOVEL     PVDT          T#MDAT
     C                   MOVEL     BRCA          T#BRCA
     C                   MOVEL     BOKC          T#BOOK
     C                   MOVEL     PRFC          T#TPFC
     C                   MOVEL     *BLANK        T#FPFC
     C                   MOVEL     PAYCUS        T#CPTY
     C                   MOVEL     PAYCUS        T#RCST
     C                   MOVEL     *BLANKS       T#LICD
     C                   MOVEL     *BLANKS       T#CNCD
     C                   MOVEL     *BLANKS       T#RCSI
     C                   EVAL      T#MKVL = STPLAM + PYPLAM
     C                   MOVEL     BJCYCD        T#VCCY
     C                   MOVEL     BSNBDP        T#VCDP
     C                   MOVEL     *BLANKS       T#VALR
     C                   MOVEL     *BLANKS       T#MATR
     C                   MOVEL     *BLANKS       T#RLDO
     C                   MOVEL     'I'           T#ACTN
      *
      **  Import the details of the payment
     C                   MOVEL     '*IMPTRAN'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      **  Clear projected positions data structure
     C                   CLEAR                   P#POSN
      *
      **  Set up projected positions data structure
     C                   MOVEL     'FT'          P#MOD
     C                   MOVEL     PREF          P#TREF
     C                   MOVEL     'A'           P#ASLI
     C                   MOVEL     *BLANKS       P#PSTP
     C                   MOVEL     SLDT          P#IACD
     C                   Z-ADD     SMAM          P#NOML
     C                   MOVEL     SMCY          P#CCY
     C                   Z-ADD     STNBDP        P#NCDP
     C                   Z-ADD     STNBDP        P#NMDP
     C                   Z-ADD     STSPDY        P#SPDY
      *
      **  Import the details of the opening position
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * P20 - Incoming payment input date processing
      * create the deal date event in the limit and revenue extraction
      * module
      ********************************************************************
     C     P20           BEGSR
      *
      ** Set revenue ordering customer type
      ** Set revenue ordering customer in
      ** Set revenue beneficiary customer type
      ** Set revenue beneficiary customer in
     C                   EVAL      OrdCustTp = ORCT
     C                   EVAL      OrdCust   = ORC1
     C                   EVAL      BnfCustTp = BNCT
     C                   EVAL      BnfCust   = BNC1
      *
      ** Determine revenue customer.
      *
     C                   EXSR      P97
      *
      ** Set settle customer number as revenue customer number
     C                   EVAL      FPCNUM  = WRevCust
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     PREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'DD'          E#EVTP
      *
      **  Import the details of the deal date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * P21 - Incoming payment pay date processing
      * create the maturity date event in the limit and revenue extraction
      * module and to create the margin event if a margin rate was not
      * entered on the transaction.
      ********************************************************************
     C     P21           BEGSR
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     PREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'MT'          E#EVTP
      *
      **  Import the details of the maturity date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      * If pay currency not equal to settle currency and FX margin points
      * zero. The payment transaction has a foreign exchange element which
      * may include margin but margin was not entered at time of transaction
      * In this case an account key is not generated for the margin.
      * Calculate the margin and create appropriate event.
      *
     C     PCCY          IFNE      SMCY
     C     FXMP          ANDEQ     0
      *
      **  Pay currency equals base currency.
     C     PCCY          IFEQ      BJCYCD
      *
      **  Convert the settlement amount to pay currency
     C                   Z-ADD     STNBDP        ZCDPI
     C                   Z-ADD     PYNBDP        ZCDPO
     C     STMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     STSPRT        ZEXCH
     C                   Z-ADD     SMAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        PYSTAM           15 0
      *
     C                   ELSE
      *
      **  Settlement currency equals base currency.
     C     SMCY          IFEQ      BJCYCD
      *
      **  Convert the settlement amount to pay currency
     C                   Z-ADD     STNBDP        ZCDPI
     C                   Z-ADD     PYNBDP        ZCDPO
     C     PYMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     PYSPRT        ZEXCH
     C                   Z-ADD     SMAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        PYSTAM
      *
     C                   END
     C                   END
      *
      **  Neither pay nor settlement currency equals base currency
     C     PCCY          IFNE      BJCYCD
     C     SMCY          ANDNE     BJCYCD
      *
      **  Convert the settlement amount to base currency
     C                   Z-ADD     STNBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   MOVEL     STMDIN        ZMD
      *
     C                   Z-ADD     STSPRT        ZEXCH
     C                   Z-ADD     SMAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        BSSTAM           15 0
      *
      **  Convert the base amount to pay currency
     C                   Z-ADD     BSNBDP        ZCDPI
     C                   Z-ADD     PYNBDP        ZCDPO
     C     PYMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     PYSPRT        ZEXCH
     C                   Z-ADD     BSSTAM        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        PYSTAM
      *
     C                   END
      *
      **  Calculate margin
     C     PYAM          SUB       PYSTAM        MARGIN
      *
      **  If negative 'out' else 'in'
     C     MARGIN        IFLT      0
     C                   MOVEL     'O'           INOUT
     C                   MULT      -1            MARGIN
     C                   ELSE
     C                   MOVEL     'I'           INOUT
     C                   END
      *
      **  If calculated margin is not zero
     C     MARGIN        IFNE      0
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     PREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'FE'          E#EVTP
     C                   Z-ADD     MARGIN        E#COMM
     C                   MOVEL     PCCY          E#CCY
     C                   Z-ADD     PYNBDP        E#NCDP
     C                   MOVEL     *BLANKS       E#ACIN
     C                   MOVEL     'Y'           E#SSET
     C                   MOVEL     INOUT         E#IO
      *
      **  Import the details of the calculated margin event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C                   END
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Process P22 - Incoming payment pay fees
      * create a charge event for each charge account key.
      ********************************************************************
     C     P22           BEGSR
      *
      ** Setup fee code.
      *
     C                   EXSR      P95
 
     C************       EVAL      E#FEEC = FeeCode                                           208221
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     PREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'FE'          E#EVTP
     C                   MOVEL     *BLANKS       E#EVRF
     C                   Z-ADD     EAMT          E#CHRG
     C                   MOVEL     ECCY          E#CCY
     C                   Z-ADD     EVNBDP        E#NCDP
     C                   MOVEL     *BLANKS       E#ACIN
     C                   MOVEL     'Y'           E#SSET
     C                   MOVEL     '05'          E#SETM
     C                   EVAL      E#SETA = FPCNUM + FPACOD +FPASEQ
     C                   MOVEL     FPBRCH        E#SETB
     C                   MOVEL     FPCCY         E#SETC
     C                   MOVEL     'I'           E#IO
     C                   EVAL      E#FEEC = FeeCode                                           208221
      *
      **  Import the details of the charge event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * TRANCP - Cheques to be paid transaction & opening bal processing
      * initialise the limit and revenue extraction module for the cheque
      * to be paid by calculating the P/L, then creating 'transaction' and
      * opening position' entries.
      ********************************************************************
     C     TRANCP        BEGSR
      *
      **  Restore pay currency details
     C                   MOVEL     PYCYCD        A6CYCD
     C                   MOVEL     PYSPAE        A6SPAE
     C                   MOVEL     PYFTAE        A6FTAE
     C                   MOVEL     PYSWAE        A6SWAE
     C                   MOVEL     PYTAC4        A6TAC4
     C                   MOVEL     PYTAC5        A6TAC5
     C                   MOVEL     PYCDFN        A6CDFN
     C                   MOVEL     PYECDN        A6ECDN
     C                   Z-ADD     PYLCD         A6LCD
     C                   MOVEL     PYTYLC        A6TYLC
     C                   MOVEL     PYCYNM        A6CYNM
     C                   Z-ADD     PYSPRT        A6SPRT
     C                   MOVEL     PYSWCY        A6SWCY
     C                   Z-ADD     PYNBDP        A6NBDP
     C                   Z-ADD     PYTXND        A6TXND
     C                   Z-ADD     PYPRRT        A6PRRT
     C                   Z-ADD     PYSRC1        A6SRC1
     C                   Z-ADD     PYSRC2        A6SRC2
     C                   MOVEL     PYDLCI        A6DLCI
     C                   Z-ADD     PYSSNB        A6SSNB
     C                   Z-ADD     PYERLC        A6ERLC
     C                   MOVEL     PYMDIN        A6MDIN
     C                   MOVEL     PYMDPR        A6MDPR
     C                   MOVEL     PYMDHB        A6MDHB
     C                   MOVEL     PYMDEX        A6MDEX
     C                   MOVEL     PYNOSN        A6NOSN
     C                   Z-ADD     PYSPDY        A6SPDY
     C                   Z-ADD     PYHSRT        A6HSRT
     C                   Z-ADD     PYLSPR        A6LSPR
     C                   Z-ADD     PYFXSD        A6FXSD
     C                   Z-ADD     PYMMSD        A6MMSD
     C                   Z-ADD     PYNQDP        A6NQDP
     C                   MOVEL     PYDICB        A6DICB
     C                   Z-ADD     PYSCEX        A6SCEX
     C                   MOVEL     PYEBDA        A6EBDA
     C                   Z-ADD     PYHBRT        A6HBRT
     C                   Z-ADD     PYENC1        A6ENC1
     C                   Z-ADD     PYENC2        A6ENC2
     C                   MOVEL     PYCACD        A6CACD
     C                   Z-ADD     PYCNMC        A6CNMC
     C                   MOVEL     PYWEDH        A6WEDH
     C                   MOVEL     PYMONH        A6MONH
     C                   MOVEL     PYTUEH        A6TUEH
     C                   MOVEL     PYTHUH        A6THUH
     C                   MOVEL     PYFRIH        A6FRIH
     C                   MOVEL     PYSATH        A6SATH
     C                   MOVEL     PYSUNH        A6SUNH
     C                   Z-ADD     PYDPBF        A6DPBF
     C                   Z-ADD     PYBYSR        A6BYSR
     C                   MOVEL     PYBYSS        A6BYSS
     C                   Z-ADD     PYSLSR        A6SLSR
     C                   MOVEL     PYSLSS        A6SLSS
     C                   Z-ADD     PYRMCM        A6RMCM
     C                   MOVEL     PYRECI        A6RECI
     C                   MOVEL     PYDPRU        A6DPRU
     C                   MOVEL     PYDNOR        A6DNOR
     C                   MOVEL     PYNDWR        A6NDWR
     C                   MOVEL     PYGMPY        A6GMPY
     C                   MOVEL     PYDLCD        A6DLCD
     C                   MOVEL     PYRDFC        A6RDFC
     C                   MOVEL     PYPMRT        A6PMRT
     C                   Z-ADD     PYRKSQ        A6RKSQ
     C                   MOVEL     PYDFPC        A6DFPC
     C                   MOVEL     PYDDPC        A6DDPC
     C                   Z-ADD     PYTKCC        A6TKCC
     C                   Z-ADD     PYCQCD        A6CQCD
     C                   Z-ADD     PYSMLD        A6SMLD
     C                   MOVEL     PYCSCD        A6CSCD
     C                   Z-ADD     PYISON        A6ISON
     C                   MOVEL     PYISFC        A6ISFC
     C                   MOVEL     PYMACD        A6MACD
     C                   MOVEL     PYFRAC        A6FRAC
     C                   MOVEL     PYNUWD        A6NUWD
     C                   MOVEL     PYMICD        A6MICD
     C                   MOVEL     PYINCY        A6INCY
     C                   Z-ADD     PYEUER        A6EUER
     C                   MOVEL     PYEUMD        A6EUMD
     C                   Z-ADD     PYTPSD        A6TPSD
     C                   Z-ADD     PYTPED        A6TPED
     C                   Z-ADD     PYINER        A6INER
     C                   MOVEL     PYINMD        A6INMD
      *
      **  Revalue cheque amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      'B'           BUYSELL           1
     C                   PARM      PCCY          ECCY              3
     C                   PARM      DRVD          EDAT              5 0
     C                   PARM      CQAM          EAMT             13 0
     C                   PARM      SBCQ          DBCE             13 0
     C                   PARM      BJRDNB        BJRDNB            5 0
     C                   PARM      BJCYCD        BJCYCD            3
     C                   PARM      BSNBDP        BSNBDP            1 0
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     PLAM          CQPLAM           13 0
      *
      **  Restore debit currency details
     C                   MOVEL     DBCYCD        A6CYCD
     C                   MOVEL     DBSPAE        A6SPAE
     C                   MOVEL     DBFTAE        A6FTAE
     C                   MOVEL     DBSWAE        A6SWAE
     C                   MOVEL     DBTAC4        A6TAC4
     C                   MOVEL     DBTAC5        A6TAC5
     C                   MOVEL     DBCDFN        A6CDFN
     C                   MOVEL     DBECDN        A6ECDN
     C                   Z-ADD     DBLCD         A6LCD
     C                   MOVEL     DBTYLC        A6TYLC
     C                   MOVEL     DBCYNM        A6CYNM
     C                   Z-ADD     DBSPRT        A6SPRT
     C                   MOVEL     DBSWCY        A6SWCY
     C                   Z-ADD     DBNBDP        A6NBDP
     C                   Z-ADD     DBTXND        A6TXND
     C                   Z-ADD     DBPRRT        A6PRRT
     C                   Z-ADD     DBSRC1        A6SRC1
     C                   Z-ADD     DBSRC2        A6SRC2
     C                   MOVEL     DBDLCI        A6DLCI
     C                   Z-ADD     DBSSNB        A6SSNB
     C                   Z-ADD     DBERLC        A6ERLC
     C                   MOVEL     DBMDIN        A6MDIN
     C                   MOVEL     DBMDPR        A6MDPR
     C                   MOVEL     DBMDHB        A6MDHB
     C                   MOVEL     DBMDEX        A6MDEX
     C                   MOVEL     DBNOSN        A6NOSN
     C                   Z-ADD     DBSPDY        A6SPDY
     C                   Z-ADD     DBHSRT        A6HSRT
     C                   Z-ADD     DBLSPR        A6LSPR
     C                   Z-ADD     DBFXSD        A6FXSD
     C                   Z-ADD     DBMMSD        A6MMSD
     C                   Z-ADD     DBNQDP        A6NQDP
     C                   MOVEL     DBDICB        A6DICB
     C                   Z-ADD     DBSCEX        A6SCEX
     C                   MOVEL     DBEBDA        A6EBDA
     C                   Z-ADD     DBHBRT        A6HBRT
     C                   Z-ADD     DBENC1        A6ENC1
     C                   Z-ADD     DBENC2        A6ENC2
     C                   MOVEL     DBCACD        A6CACD
     C                   Z-ADD     DBCNMC        A6CNMC
     C                   MOVEL     DBWEDH        A6WEDH
     C                   MOVEL     DBMONH        A6MONH
     C                   MOVEL     DBTUEH        A6TUEH
     C                   MOVEL     DBTHUH        A6THUH
     C                   MOVEL     DBFRIH        A6FRIH
     C                   MOVEL     DBSATH        A6SATH
     C                   MOVEL     DBSUNH        A6SUNH
     C                   Z-ADD     DBDPBF        A6DPBF
     C                   Z-ADD     DBBYSR        A6BYSR
     C                   MOVEL     DBBYSS        A6BYSS
     C                   Z-ADD     DBSLSR        A6SLSR
     C                   MOVEL     DBSLSS        A6SLSS
     C                   Z-ADD     DBRMCM        A6RMCM
     C                   MOVEL     DBRECI        A6RECI
     C                   MOVEL     DBDPRU        A6DPRU
     C                   MOVEL     DBDNOR        A6DNOR
     C                   MOVEL     DBNDWR        A6NDWR
     C                   MOVEL     DBGMPY        A6GMPY
     C                   MOVEL     DBDLCD        A6DLCD
     C                   MOVEL     DBRDFC        A6RDFC
     C                   MOVEL     DBPMRT        A6PMRT
     C                   Z-ADD     DBRKSQ        A6RKSQ
     C                   MOVEL     DBDFPC        A6DFPC
     C                   MOVEL     DBDDPC        A6DDPC
     C                   Z-ADD     DBTKCC        A6TKCC
     C                   Z-ADD     DBCQCD        A6CQCD
     C                   Z-ADD     DBSMLD        A6SMLD
     C                   MOVEL     DBCSCD        A6CSCD
     C                   Z-ADD     DBISON        A6ISON
     C                   MOVEL     DBISFC        A6ISFC
     C                   MOVEL     DBMACD        A6MACD
     C                   MOVEL     DBFRAC        A6FRAC
     C                   MOVEL     DBNUWD        A6NUWD
     C                   MOVEL     DBMICD        A6MICD
     C                   MOVEL     DBINCY        A6INCY
     C                   Z-ADD     DBEUER        A6EUER
     C                   MOVEL     DBEUMD        A6EUMD
     C                   Z-ADD     DBTPSD        A6TPSD
     C                   Z-ADD     DBTPED        A6TPED
     C                   Z-ADD     DBINER        A6INER
     C                   MOVEL     DBINMD        A6INMD
      *
      **  Revalue debit amount?
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      'S'           BUYSELL           1
     C                   PARM      DRCY          ECCY              3
     C                   PARM      DRVD          EDAT              5 0
     C                   PARM      EAMT          EAMT             13 0
     C                   PARM      SBCQ          DBCE             13 0
     C                   PARM      BJRDNB        BJRDNB            5 0
     C                   PARM      BJCYCD        BJCYCD            3
     C                   PARM      BSNBDP        BSNBDP            1 0
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     PLAM          DBPLAM           13 0
      *
      **  Debit party contains a retail account number
     C     DRPT          IFEQ      'R'
     C                   MOVEL     DRPY          WRK10
      *
     C     WRK10         CHAIN     ACNUM                              15
      *
      **  Data base error
     C     *IN15         IFEQ      '1'
     C                   MOVEL     WRK10         DBKEY
     C                   MOVEL     'ACNUM'       DBFILE
     C                   MOVEL     '021'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     CNUM          DBCUS             6
     C                   ENDIF
      *
      **  Debit party contains partial account number (no currency)
     C     DRPT          IFEQ      'P'
     C                   MOVEL     DRPY          DBCUS
     C                   ENDIF
      *
     C                   CLEAR                   T#TRAN
      *
      **  Set up projected transaction data structure
     C                   MOVEL     'FT'          T#MOD
     C                   MOVEL     TREF          T#TREF
     C                   MOVEL     'CP'          T#TRTP
     C                   MOVEL     PYST          T#TRST
     C                   EVAL      T#TDES = 'CHEQUES TO BE PAID'
     C     DRVD          IFLT      OEDT
     C                   MOVEL     DRVD          T#DDAT
     C                   ELSE
     C                   MOVEL     OEDT          T#DDAT
     C                   ENDIF
     C                   MOVEL     DRVD          T#VDAT
     C                   MOVEL     DRVD          T#MDAT
     C                   MOVEL     BRCA          T#BRCA
     C                   MOVEL     BOKC          T#BOOK
     C                   MOVEL     PRFC          T#TPFC
     C                   MOVEL     *BLANK        T#FPFC
     C                   MOVEL     DBCUS         T#CPTY
     C                   MOVEL     DBCUS         T#RCST
     C                   MOVEL     *BLANKS       T#LICD
     C                   MOVEL     *BLANKS       T#CNCD
     C                   MOVEL     *BLANKS       T#RCSI
     C                   EVAL      T#MKVL = CQPLAM + DBPLAM
     C                   MOVEL     BJCYCD        T#VCCY
     C                   MOVEL     BSNBDP        T#VCDP
     C                   MOVEL     *BLANKS       T#VALR
     C                   MOVEL     *BLANKS       T#MATR
     C                   MOVEL     *BLANKS       T#RLDO
     C                   MOVEL     'I'           T#ACTN
      *
      **  Import the details of the cheque debit
     C                   MOVEL     '*IMPTRAN'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      **  Clear projected position data structure
     C                   CLEAR                   P#POSN
      *
      **  Set up projected position data structure
     C                   MOVEL     'FT'          P#MOD
     C                   MOVEL     TREF          P#TREF
     C                   MOVEL     'A'           P#ASLI
     C                   MOVEL     *BLANKS       P#PSTP
     C                   MOVEL     DRVD          P#IACD
     C                   Z-ADD     CQAM          P#NOML
     C                   MOVEL     PCCY          P#CCY
     C                   Z-ADD     PYNBDP        P#NCDP
     C                   Z-ADD     PYNBDP        P#NMDP
     C                   Z-ADD     PYSPDY        P#SPDY
      *
      **  Import the details of the opening position
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * P30 - Cheques to be paid input date processing
      * create the deal date event in the limit and revenue
      * extraction module
      ********************************************************************
     C     P30           BEGSR
      *
      ** Set revenue ordering customer type
      ** Set revenue ordering customer in
      ** Set revenue beneficiary customer type
      ** Set revenue beneficiary customer in
     C                   EVAL      OrdCustTp = DRPT
     C                   MOVEL     DRPY          OrdCust
     C                   EVAL      BnfCustTp = *BLANK
     C                   EVAL      BnfCust   = *BLANKS
      *
      ** Determine revenue customer.
      *
     C                   EXSR      P97
      *
      ** Set settle customer number as revenue customer
     C                   EVAL      FPCNUM = WRevCust
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'DD'          E#EVTP
      *
      **  Import the details of the deal date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * P31 - Cheques to be paid debit date processing
      * create the value and maturity date events in the limit and revenue
      * extraction module and to create the margin event if a margin rate
      * was not entered on the transaction.
      ********************************************************************
     C     P31           BEGSR
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'VD'          E#EVTP
      *
      **  Import the details of the value date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'MT'          E#EVTP
      *
      **  Import the details of the maturity date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      * If pay currency not equal to debit currency and FX margin points
      * zero. The payment transaction has a foreign exchange element which
      * may include margin but margin was not entered at time of transaction
      * In this case an account key is not generated for the margin.
      * Calculate the margin and create appropriate event.
      *
     C     PCCY          IFNE      DRCY
     C     FXMP          ANDEQ     0
      *
      **  Pay currency equals base currency.
     C     PCCY          IFEQ      BJCYCD
      *
      **  Convert the cheque amount to debit currency
     C                   Z-ADD     PYNBDP        ZCDPI
     C                   Z-ADD     DBNBDP        ZCDPO
     C     STMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     DBSPRT        ZEXCH
     C                   Z-ADD     CQAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCQAM           15 0
      *
     C                   ELSE
      *
      **  Debit currency equals base currency.
     C     DRCY          IFEQ      BJCYCD
      *
      **  Convert the cheque amount to debit currency
     C                   Z-ADD     PYNBDP        ZCDPI
     C                   Z-ADD     DBNBDP        ZCDPO
     C     DBMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     PYSPRT        ZEXCH
     C                   Z-ADD     CQAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCQAM
      *
     C                   END
     C                   END
      *
      **  Neither debit nor pay currency equals base currency
     C     PCCY          IFNE      BJCYCD
     C     DRCY          ANDNE     BJCYCD
      *
      **  Convert the cheque amount to base currency
     C                   Z-ADD     PYNBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   MOVEL     PYMDIN        ZMD
      *
     C                   Z-ADD     PYSPRT        ZEXCH
     C                   Z-ADD     CQAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        BSCQAM           15 0
      *
      **  Convert the base amount to debit currency
     C                   Z-ADD     BSNBDP        ZCDPI
     C                   Z-ADD     DBNBDP        ZCDPO
     C     DBMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     DBSPRT        ZEXCH
     C                   Z-ADD     BSCQAM        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCQAM
      *
     C                   END
      *
      **  Calculate margin
     C     PDDRAM        SUB       DBCQAM        MARGIN
      *
      **  If negative 'out' else 'in'
     C     MARGIN        IFLT      0
     C                   MOVEL     'O'           INOUT
     C                   MULT      -1            MARGIN
     C                   ELSE
     C                   MOVEL     'I'           INOUT
     C                   END
      *
      **  If calculated margin not zero
     C     MARGIN        IFNE      0
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'FE'          E#EVTP
     C                   Z-ADD     MARGIN        E#COMM
     C                   MOVEL     DRCY          E#CCY
     C                   Z-ADD     DBNBDP        E#NCDP
     C                   MOVEL     *BLANKS       E#ACIN
     C                   MOVEL     'Y'           E#SSET
     C                   MOVEL     INOUT         E#IO
      *
      **  Import the details of the calculated margin event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C                   END
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Process P32 - Cheques to be paid debit fees
      * create a charge event for each charge account key.
      ********************************************************************
     C     P32           BEGSR
      *
      ** Setup fee code.
      *
     C                   EXSR      P95
 
     C************       EVAL      E#FEEC = FeeCode                                           208221
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'FE'          E#EVTP
     C                   Z-ADD     EAMT          E#CHRG
     C                   MOVEL     ECCY          E#CCY
     C                   Z-ADD     EVNBDP        E#NCDP
     C                   MOVEL     *BLANKS       E#ACIN
     C                   MOVEL     'Y'           E#SSET
     C                   MOVEL     '05'          E#SETM
     C                   EVAL      E#SETA = FPCNUM + FPACOD +FPASEQ
     C                   MOVEL     FPBRCH        E#SETB
     C                   MOVEL     FPCCY         E#SETC
     C                   MOVEL     'I'           E#IO
     C                   EVAL      E#FEEC = FeeCode                                           208221
      *
      **  Import the details of the charge event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * TRANCC - Cheques to be collected transaction and opening bal proc
      * initialise the limit and revenue extraction module for the cheques
      * be collected by calculating the P/L, then creating 'transaction'
      * and 'opening position' entries.
      ********************************************************************
     C     TRANCC        BEGSR
      *
      **  Restore settle currency details
     C                   MOVEL     STCYCD        A6CYCD
     C                   MOVEL     STSPAE        A6SPAE
     C                   MOVEL     STFTAE        A6FTAE
     C                   MOVEL     STSWAE        A6SWAE
     C                   MOVEL     STTAC4        A6TAC4
     C                   MOVEL     STTAC5        A6TAC5
     C                   MOVEL     STCDFN        A6CDFN
     C                   MOVEL     STECDN        A6ECDN
     C                   Z-ADD     STLCD         A6LCD
     C                   MOVEL     STTYLC        A6TYLC
     C                   MOVEL     STCYNM        A6CYNM
     C                   Z-ADD     STSPRT        A6SPRT
     C                   MOVEL     STSWCY        A6SWCY
     C                   Z-ADD     STNBDP        A6NBDP
     C                   Z-ADD     STTXND        A6TXND
     C                   Z-ADD     STPRRT        A6PRRT
     C                   Z-ADD     STSRC1        A6SRC1
     C                   Z-ADD     STSRC2        A6SRC2
     C                   MOVEL     STDLCI        A6DLCI
     C                   Z-ADD     STSSNB        A6SSNB
     C                   Z-ADD     STERLC        A6ERLC
     C                   MOVEL     STMDIN        A6MDIN
     C                   MOVEL     STMDPR        A6MDPR
     C                   MOVEL     STMDHB        A6MDHB
     C                   MOVEL     STMDEX        A6MDEX
     C                   MOVEL     STNOSN        A6NOSN
     C                   Z-ADD     STSPDY        A6SPDY
     C                   Z-ADD     STHSRT        A6HSRT
     C                   Z-ADD     STLSPR        A6LSPR
     C                   Z-ADD     STFXSD        A6FXSD
     C                   Z-ADD     STMMSD        A6MMSD
     C                   Z-ADD     STNQDP        A6NQDP
     C                   MOVEL     STDICB        A6DICB
     C                   Z-ADD     STSCEX        A6SCEX
     C                   MOVEL     STEBDA        A6EBDA
     C                   Z-ADD     STHBRT        A6HBRT
     C                   Z-ADD     STENC1        A6ENC1
     C                   Z-ADD     STENC2        A6ENC2
     C                   MOVEL     STCACD        A6CACD
     C                   Z-ADD     STCNMC        A6CNMC
     C                   MOVEL     STWEDH        A6WEDH
     C                   MOVEL     STMONH        A6MONH
     C                   MOVEL     STTUEH        A6TUEH
     C                   MOVEL     STTHUH        A6THUH
     C                   MOVEL     STFRIH        A6FRIH
     C                   MOVEL     STSATH        A6SATH
     C                   MOVEL     STSUNH        A6SUNH
     C                   Z-ADD     STDPBF        A6DPBF
     C                   Z-ADD     STBYSR        A6BYSR
     C                   MOVEL     STBYSS        A6BYSS
     C                   Z-ADD     STSLSR        A6SLSR
     C                   MOVEL     STSLSS        A6SLSS
     C                   Z-ADD     STRMCM        A6RMCM
     C                   MOVEL     STRECI        A6RECI
     C                   MOVEL     STDPRU        A6DPRU
     C                   MOVEL     STDNOR        A6DNOR
     C                   MOVEL     STNDWR        A6NDWR
     C                   MOVEL     STGMPY        A6GMPY
     C                   MOVEL     STDLCD        A6DLCD
     C                   MOVEL     STRDFC        A6RDFC
     C                   MOVEL     STPMRT        A6PMRT
     C                   Z-ADD     STRKSQ        A6RKSQ
     C                   MOVEL     STDFPC        A6DFPC
     C                   MOVEL     STDDPC        A6DDPC
     C                   Z-ADD     STTKCC        A6TKCC
     C                   Z-ADD     STCQCD        A6CQCD
     C                   Z-ADD     STSMLD        A6SMLD
     C                   MOVEL     STCSCD        A6CSCD
     C                   Z-ADD     STISON        A6ISON
     C                   MOVEL     STISFC        A6ISFC
     C                   MOVEL     STMACD        A6MACD
     C                   MOVEL     STFRAC        A6FRAC
     C                   MOVEL     STNUWD        A6NUWD
     C                   MOVEL     STMICD        A6MICD
     C                   MOVEL     STINCY        A6INCY
     C                   Z-ADD     STEUER        A6EUER
     C                   MOVEL     STEUMD        A6EUMD
     C                   Z-ADD     STTPSD        A6TPSD
     C                   Z-ADD     STTPED        A6TPED
     C                   Z-ADD     STINER        A6INER
     C                   MOVEL     STINMD        A6INMD
      *
      **  Revalue cheque amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      'B'           BUYSELL           1
     C                   PARM      SMCY          ECCY              3
     C                   PARM      CRVD          EDAT              5 0
     C                   PARM      CQAM          EAMT             13 0
     C                   PARM      PBCQ          DBCE             13 0
     C                   PARM      BJRDNB        BJRDNB            5 0
     C                   PARM      BJCYCD        BJCYCD            3
     C                   PARM      BSNBDP        BSNBDP            1 0
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     PLAM          CQPLAM
      *
      **  Restore credit currency details
     C                   MOVEL     CRCYCD        A6CYCD
     C                   MOVEL     CRSPAE        A6SPAE
     C                   MOVEL     CRFTAE        A6FTAE
     C                   MOVEL     CRSWAE        A6SWAE
     C                   MOVEL     CRTAC4        A6TAC4
     C                   MOVEL     CRTAC5        A6TAC5
     C                   MOVEL     CRCDFN        A6CDFN
     C                   MOVEL     CRECDN        A6ECDN
     C                   Z-ADD     CRLCD         A6LCD
     C                   MOVEL     CRTYLC        A6TYLC
     C                   MOVEL     CRCYNM        A6CYNM
     C                   Z-ADD     CRSPRT        A6SPRT
     C                   MOVEL     CRSWCY        A6SWCY
     C                   Z-ADD     CRNBDP        A6NBDP
     C                   Z-ADD     CRTXND        A6TXND
     C                   Z-ADD     CRPRRT        A6PRRT
     C                   Z-ADD     CRSRC1        A6SRC1
     C                   Z-ADD     CRSRC2        A6SRC2
     C                   MOVEL     CRDLCI        A6DLCI
     C                   Z-ADD     CRSSNB        A6SSNB
     C                   Z-ADD     CRERLC        A6ERLC
     C                   MOVEL     CRMDIN        A6MDIN
     C                   MOVEL     CRMDPR        A6MDPR
     C                   MOVEL     CRMDHB        A6MDHB
     C                   MOVEL     CRMDEX        A6MDEX
     C                   MOVEL     CRNOSN        A6NOSN
     C                   Z-ADD     CRSPDY        A6SPDY
     C                   Z-ADD     CRHSRT        A6HSRT
     C                   Z-ADD     CRLSPR        A6LSPR
     C                   Z-ADD     CRFXSD        A6FXSD
     C                   Z-ADD     CRMMSD        A6MMSD
     C                   Z-ADD     CRNQDP        A6NQDP
     C                   MOVEL     CRDICB        A6DICB
     C                   Z-ADD     CRSCEX        A6SCEX
     C                   MOVEL     CREBDA        A6EBDA
     C                   Z-ADD     CRHBRT        A6HBRT
     C                   Z-ADD     CRENC1        A6ENC1
     C                   Z-ADD     CRENC2        A6ENC2
     C                   MOVEL     CRCACD        A6CACD
     C                   Z-ADD     CRCNMC        A6CNMC
     C                   MOVEL     CRWEDH        A6WEDH
     C                   MOVEL     CRMONH        A6MONH
     C                   MOVEL     CRTUEH        A6TUEH
     C                   MOVEL     CRTHUH        A6THUH
     C                   MOVEL     CRFRIH        A6FRIH
     C                   MOVEL     CRSATH        A6SATH
     C                   MOVEL     CRSUNH        A6SUNH
     C                   Z-ADD     CRDPBF        A6DPBF
     C                   Z-ADD     CRBYSR        A6BYSR
     C                   MOVEL     CRBYSS        A6BYSS
     C                   Z-ADD     CRSLSR        A6SLSR
     C                   MOVEL     CRSLSS        A6SLSS
     C                   Z-ADD     CRRMCM        A6RMCM
     C                   MOVEL     CRRECI        A6RECI
     C                   MOVEL     CRDPRU        A6DPRU
     C                   MOVEL     CRDNOR        A6DNOR
     C                   MOVEL     CRNDWR        A6NDWR
     C                   MOVEL     CRGMPY        A6GMPY
     C                   MOVEL     CRDLCD        A6DLCD
     C                   MOVEL     CRRDFC        A6RDFC
     C                   MOVEL     CRPMRT        A6PMRT
     C                   Z-ADD     CRRKSQ        A6RKSQ
     C                   MOVEL     CRDFPC        A6DFPC
     C                   MOVEL     CRDDPC        A6DDPC
     C                   Z-ADD     CRTKCC        A6TKCC
     C                   Z-ADD     CRCQCD        A6CQCD
     C                   Z-ADD     CRSMLD        A6SMLD
     C                   MOVEL     CRCSCD        A6CSCD
     C                   Z-ADD     CRISON        A6ISON
     C                   MOVEL     CRISFC        A6ISFC
     C                   MOVEL     CRMACD        A6MACD
     C                   MOVEL     CRFRAC        A6FRAC
     C                   MOVEL     CRNUWD        A6NUWD
     C                   MOVEL     CRMICD        A6MICD
     C                   MOVEL     CRINCY        A6INCY
     C                   Z-ADD     CREUER        A6EUER
     C                   MOVEL     CREUMD        A6EUMD
     C                   Z-ADD     CRTPSD        A6TPSD
     C                   Z-ADD     CRTPED        A6TPED
     C                   Z-ADD     CRINER        A6INER
     C                   MOVEL     CRINMD        A6INMD
      *
      **  Revalue credit amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      'S'           BUYSELL           1
     C                   PARM      CRCY          ECCY              3
     C                   PARM      CRVD          EDAT              5 0
     C                   PARM      EAMT          EAMT             13 0
     C                   PARM      PBCQ          DBCE             13 0
     C                   PARM      BJRDNB        BJRDNB            5 0
     C                   PARM      BJCYCD        BJCYCD            3
     C                   PARM      BSNBDP        BSNBDP            1 0
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     PLAM          CRPLAM           13 0
      *
      **  debit party contains a retail account number
     C     CRPT          IFEQ      'R'
     C                   MOVEL     CRPY          WRK10
      *
     C     WRK10         CHAIN     ACNUM                              15
      *
      **  Data base error
     C     *IN15         IFEQ      '1'
     C                   MOVEL     WRK10         DBKEY
     C                   MOVEL     'ACNUM'       DBFILE
     C                   MOVEL     '022'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     CNUM          CRCUS             6
     C                   ENDIF
      *
      **  credit party contains partial account number (no currency)
     C     CRPT          IFEQ      'P'
     C                   MOVEL     CRPY          CRCUS
     C                   ENDIF
      *
     C                   CLEAR                   T#TRAN
      *
      **  Set up projected transaction data structure
     C                   MOVEL     'FT'          T#MOD
     C                   MOVEL     TREF          T#TREF
     C                   MOVEL     'CC'          T#TRTP
     C                   MOVEL     PYST          T#TRST
     C                   EVAL      T#TDES = 'CHEQUES TO BE COLL'
     C     CRVD          IFLT      OEDT
     C                   MOVEL     CRVD          T#DDAT
     C                   ELSE
     C                   MOVEL     OEDT          T#DDAT
     C                   ENDIF
     C                   MOVEL     CRVD          T#VDAT
     C                   MOVEL     CRVD          T#MDAT
     C                   MOVEL     BRCA          T#BRCA
     C                   MOVEL     BOKC          T#BOOK
     C                   MOVEL     PRFC          T#TPFC
     C                   MOVEL     *BLANK        T#FPFC
     C                   MOVEL     CRCUS         T#CPTY
     C                   MOVEL     CRCUS         T#RCST
     C                   MOVEL     *BLANKS       T#LICD
     C                   MOVEL     *BLANKS       T#CNCD
     C                   MOVEL     *BLANKS       T#RCSI
     C                   EVAL      T#MKVL = CQPLAM + CRPLAM
     C                   MOVEL     BJCYCD        T#VCCY
     C                   MOVEL     BSNBDP        T#VCDP
     C                   MOVEL     *BLANKS       T#VALR
     C                   MOVEL     *BLANKS       T#MATR
     C                   MOVEL     *BLANKS       T#RLDO
     C                   MOVEL     'I'           T#ACTN
      *
      **  Import the details of the cheque debit
     C                   MOVEL     '*IMPTRAN'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      **  Clear projected position data structure
     C                   CLEAR                   P#POSN
      *
      **  Set up projected position data structure
     C                   MOVEL     'FT'          P#MOD
     C                   MOVEL     TREF          P#TREF
     C                   MOVEL     'A'           P#ASLI
     C                   MOVEL     *BLANKS       P#PSTP
     C                   MOVEL     CRVD          P#IACD
     C                   Z-ADD     CQAM          P#NOML
     C                   MOVEL     SMCY          P#CCY
     C                   Z-ADD     STNBDP        P#NCDP
     C                   Z-ADD     STNBDP        P#NMDP
     C                   Z-ADD     STSPDY        P#SPDY
      *
      **  Import the details of the opening position
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Process P40 - Cheques to be collected input date processing
      * create the deal date events in the limit and revenue
      * extraction module
      ********************************************************************
     C     P40           BEGSR
      *
      ** Set revenue ordering customer type
      ** Set revenue ordering customer in
      ** Set revenue beneficiary customer type
      ** Set revenue beneficiary customer in
     C                   EVAL      OrdCustTp = CRPT
     C                   MOVEL     CRPY          OrdCust
     C                   EVAL      BnfCustTp = *BLANK
     C                   EVAL      BnfCust   = *BLANKS
      *
      ** Determine revenue customer.
      *
     C                   EXSR      P97
      *
      ** Set settle customer number as revenue customer number
     C                   EVAL      FPCNUM = WRevCust
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'DD'          E#EVTP
      *
      **  Import the details of the deal date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Process P41 - Cheques to be collected credit date processing
      * create the value and maturity date events in the limit and revenue
      * extraction module and to create the margin event if a margin rate
      * was not entered on the transaction
      ********************************************************************
     C     P41           BEGSR
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'VD'          E#EVTP
     C                   MOVEL     *BLANKS       E#EVRF
      *
      **  Import the details of the value date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'MT'          E#EVTP
      *
      **  Import the details of the maturity date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      * If settle currency not equal to credit currency and FX margin points
      * zero. The payment transaction has a foreign exchange element which
      * may include margin but margin was not entered at time of transaction
      * In this case an account key is not generated for the margin.
      * Calculate the margin and create appropriate event.
      *
     C     SMCY          IFNE      CRCY
     C     FXMP          ANDEQ     0
      *
      **  Settlement currency equals base currency.
     C     SMCY          IFEQ      BJCYCD
      *
      **  Convert the cheque amount to credit currency
     C                   Z-ADD     STNBDP        ZCDPI
     C                   Z-ADD     CRNBDP        ZCDPO
     C     CRMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     CRSPRT        ZEXCH
     C                   Z-ADD     CQAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        CRCQAM           15 0
      *
     C                   ELSE
      *
      **  Credit currency equals base currency.
     C     CRCY          IFEQ      BJCYCD
      *
      **  Convert the cheque amount to credit currency
     C                   Z-ADD     STNBDP        ZCDPI
     C                   Z-ADD     CRNBDP        ZCDPO
     C     STMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     STSPRT        ZEXCH
     C                   Z-ADD     CQAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        CRCQAM
      *
     C                   END
     C                   END
      *
      **  Neither credit nor settlement currency equals base currency
     C     CRCY          IFNE      BJCYCD
     C     SMCY          ANDNE     BJCYCD
      *
      **  Convert the cheque amount to base currency
     C                   Z-ADD     STNBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   MOVEL     PYMDIN        ZMD
      *
     C                   Z-ADD     STSPRT        ZEXCH
     C                   Z-ADD     CQAM          ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        BSCQAM
      *
      **  Convert the base amount to credit currency
     C                   Z-ADD     BSNBDP        ZCDPI
     C                   Z-ADD     CRNBDP        ZCDPO
     C     CRMDIN        IFEQ      'M'
     C                   MOVEL     'D'           ZMD
     C                   ELSE
     C                   MOVEL     'M'           ZMD
     C                   END
      *
     C                   Z-ADD     CRSPRT        ZEXCH
     C                   Z-ADD     BSCQAM        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        CRCQAM
      *
     C                   END
      *
      **  Calculate margin
     C     CCYAM         SUB       CRCQAM        MARGIN
      *
      **  If negative 'out' else 'in'
     C     MARGIN        IFLT      0
     C                   MOVEL     'O'           INOUT
     C                   MULT      -1            MARGIN
     C                   ELSE
     C                   MOVEL     'I'           INOUT
     C                   END
      *
      **  If calculated margin not zero
     C     MARGIN        IFNE      0
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'FE'          E#EVTP
     C                   Z-ADD     MARGIN        E#COMM
     C                   MOVEL     CRCY          E#CCY
     C                   Z-ADD     CRNBDP        E#NCDP
     C                   MOVEL     *BLANKS       E#ACIN
     C                   MOVEL     'Y'           E#SSET
     C                   MOVEL     INOUT         E#IO
      *
      **  Import the details of the calculated margin event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C                   END
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Process P42 - Cheques to be collected credit fees
      * create a charge event for each charge account key.
      ********************************************************************
     C     P42           BEGSR
      *
      ** Setup fee code.
      *
     C                   EXSR      P95
 
     C************       EVAL      E#FEEC = FeeCode                                           208221
      *
      **  Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *
      **  Set up projected event data structure
     C                   MOVEL     'FT'          E#MOD
     C                   MOVEL     TREF          E#TREF
     C                   MOVEL     'A'           E#ASLI
     C                   MOVEL     BJRDNB        E#PRDT
     C                   Z-ADD     0             E#PRSQ
     C                   MOVEL     'FE'          E#EVTP
     C                   Z-ADD     EAMT          E#CHRG
     C                   MOVEL     ECCY          E#CCY
     C                   Z-ADD     EVNBDP        E#NCDP
     C                   MOVEL     *BLANKS       E#ACIN
     C                   MOVEL     'Y'           E#SSET
     C                   MOVEL     '05'          E#SETM
     C                   EVAL      E#SETA = FPCNUM + FPACOD +FPASEQ
     C                   MOVEL     FPBRCH        E#SETB
     C                   MOVEL     FPCCY         E#SETC
     C                   MOVEL     'I'           E#IO
     C                   EVAL      E#FEEC = FeeCode                                           208221
      *
      **  Import the details of the charge event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Set generate events to 'Y'
     C                   MOVEL     'Y'           GENEVT
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Process P90 - Event generation and export
      * generate and export the transaction, positions, events and cashflows
      * from the limits and revenue module
      ********************************************************************
     C     P90           BEGSR
      *
      **  import the period end dates into the limits and revenue module.
     C*************      EXSR      P91                                                        208221
     C                   EXSR      IMP_PE                                                     208221
      *
      **  Process the data loaded into the limits and revenue module
     C                   MOVEL     '*PROCSIM'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
      **  Export transaction details from the limits and revenue module
     C                   MOVEL     '*EXPTRAN'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C     W#RTCD        DOWNE     '*EOD'
     C                   WRITE     DETRANP0
      *
      **  Export transaction details from the limits and revenue module
     C                   MOVEL     '*EXPTRAN'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C                   END
      *
      **  Export position details from the limits and revenue module
     C                   MOVEL     '*EXPPOSN'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C     W#RTCD        DOWNE     '*EOD'
     C                   WRITE     DEPOSNP0
      *
      **  Export position details from the limits and revenue module
     C                   MOVEL     '*EXPPOSN'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C                   END
      *
      **  Export event details from the limits and revenue module
     C                   MOVEL     '*EXPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C     W#RTCD        DOWNE     '*EOD'
     C                   WRITE     DEEVNTP0
      *
      **  Export event details from the limits and revenue module
     C                   MOVEL     '*EXPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C                   END
      *
      **  Export cashflow details from the limits and revenue module
     C                   MOVEL     '*EXPCASH'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C     W#RTCD        DOWNE     '*EOD'
     C                   WRITE     DECASHP0
      *
      **  Export cashflow details from the limits and revenue module
     C                   MOVEL     '*EXPCASH'    W#MODE
     C                   MOVEL     'P'           W#PH
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      * I M P O R T   P E R I O D   E N D   D A T E S                                         208221
      /COPY DECPYSRC,DEXTPERDI                                                                208221
      ********************************************************************                    208221
      **Process*P91*-*Period*end*date*import******************************                    208221
      **import*the*period*end*dates*into*the*limits*and*revenue*module****                    208221
      ********************************************************************                    208221
     C*****P91******     BEGSR                                                                208221
      **************                                                                          208221
      **IMPORT*PERIOD*END*DATES*******************************************                    208221
     C**************     MOVEA     PeriodEDT     PER                                          208221
      **************                                                                          208221
     C**************     Z-ADD     1             #PP               3 0                        208221
      **************                                                                          208221
     C*****PER(#PP)*     DOWNE     *BLANK                                                     208221
     C*****PER(#PP)*     ANDNE     '00000'                                                    208221
      **************                                                                          208221
      **CLEAR*EVENT*******************************************************                    208221
     C**************     CLEAR                   E#EVNT                                       208221
      **************                                                                          208221
      **Module,*Transaction*Reference,*Asset/Liability********************                    208221
     C**************     MOVEL     'FT'          E#MOD                                        208221
     C*****PTYP*****     IFEQ      'OP'                                                       208221
     C*****PTYP*****     OREQ      'IN'                                                       208221
     C**************     MOVEL     PREF          E#TREF                                       208221
     C**************     ELSE                                                                 208221
     C**************     MOVEL     TREF          E#TREF                                       208221
     C**************     END                                                                  208221
     C**************     MOVEL     'A'           E#ASLI                                       208221
      **************                                                                          208221
      **Processing*Date***************************************************                    208221
     C**************     MOVEL     PER(#PP)      E#PRDT                                       208221
      **************                                                                          208221
      **Event*Type********************************************************                    208221
     C**************     MOVEL     'PE'          E#EVTP                                       208221
      **************                                                                          208221
      **Import*period*end*event*******************************************                    208221
     C**************     MOVEL     '*IMPEVNT'    W#MODE                                       208221
     C**************     EXSR      WRKEDTA                                                    208221
      **************                                                                          208221
     C**************     ADD       1             #PP                                          208221
      **************                                                                          208221
     C**************     ENDDO                                                                208221
      **************                                                                          208221
     C**************     ENDSR                                                                208221
      *****************************************************************                       208221
      /EJECT
      *****************************************************************
      *                                                               *
      *  P50 - Initialise the limit and revenue extranction module    *
      *        for the outgoing request for transfer by creating one  *
      *        'transaction', one 'opening position' and one 'deal    *
      *        date' entry and a number of 'fee' entries.             *
      *                                                               *
      *****************************************************************
     C     P50           BEGSR
 
     C                   IF        WTransProcess = *BLANK
      *
      ** Set ordering customer type
      ** Set revenue ordering customer in
     C                   IF        DCUSTP <> *BLANKS
     C                   EVAL      OrdCustTp = DCUSTP
     C                   EVAL      OrdCust   = TOCUS1
     C                   ELSE
     C                   EVAL      OrdCustTp = CUSTTP
     C                   EVAL      OrdCust   = HOCUS1
     C                   ENDIF
      *
      ** Set beneficiary customer type
      ** Set beneficiary customer in
     C                   EVAL      BnfCustTp = BENTTP
     C                   EVAL      BnfCust   = TBNA35
      *
      ** Determine revenue customer.
     C                   EXSR      P97
      *
      ** Clear projected transaction data structure
      *
     C                   CLEAR                   T#TRAN
      *
      ** Set up projected transaction data structure
     C                   EVAL      T#MOD  = 'FT'
     C                   EVAL      T#TREF = PREF
     C                   EVAL      T#TRTP = 'RO'
     C                   EVAL      T#TDES = 'OUTGOING RFT'
     C                   EVAL      T#DDAT = BJRDNB
     C                   EVAL      T#VDAT = DBTVDT
     C                   EVAL      T#MDAT = CRDVDT
     C                   EVAL      T#BRCA = BRCA
     C                   EVAL      T#BOOK = BOKC
     C                   EVAL      T#TPFC = PRFC
     C                   MOVEL     WRevCust      T#CPTY
     C                   MOVEL     WRevCust      T#RCST
     C                   EVAL      T#ACTN = 'I'
      *
      ** Import the details of payment
     C                   EVAL      W#MODE = '*IMPTRAN'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Clear projected positions data structure
      *
     C                   CLEAR                   P#POSN
      *
      ** Set up projected positions data structure
     C                   EVAL      P#MOD  = 'FT'
     C                   EVAL      P#TREF = PREF
     C                   EVAL      P#ASLI = 'A'
     C                   EVAL      P#IACD = BJRDNB
     C                   EVAL      P#NOML = EAMT
     C                   EVAL      P#CCY  = ECCY
     C                   EVAL      P#NCDP = EVNBDP
     C                   EVAL      P#NMDP = EVNBDP
     C                   EVAL      P#SPDY = EVSPDY
      *
      ** Import the details of the opening position
     C                   EVAL      W#MODE = '*IMPOPBL'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected event data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = PREF
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'DD'
      *
      ** Import the details of the deal date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WTransProcess = 'Y'
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up fee code
      *
     C                   EXSR      P95
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = PREF
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'FE'
     C                   EVAL      E#CHRG = EAMT
     C                   EVAL      E#TAMT = EAMT
     C                   EVAL      E#CCY  = ECCY
     C                   EVAL      E#NCDP = EVNBDP
     C                   EVAL      E#SSET = 'Y'
     C                   EVAL      E#SETM = '05'
     C                   EVAL      E#SETA = FPCNUM + FPACOD +FPASEQ
     C                   EVAL      E#SETB = FPBRCH
     C                   EVAL      E#SETC = FPCCY
     C                   EVAL      E#IO   = 'I'
     C                   EVAL      E#FEEC = FeeCode
      *
      ** Import the details of the fees event
     C                   EVAL      W#MODE = '*IMPEVNT'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P60 - Initialise the limit and revenue extraction module     *
      *        for the incoming request for transfer by calculating   *
      *        the P/L, then creating 'transaction' and 'opening po-  *
      *        sition' entries.                                       *
      *                                                               *
      *****************************************************************
     C     P60           BEGSR
      *
      ** If transfer currency is not the same as the payment currency,
      ** calculate for Profit/Lost amount.  Otherwise, default to zero.
      *
     C                   IF        TRNCCY <> PAYCCY
      *
      ** Convert transfer amount to base currency equivalent
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     TFBCQS        ZEXCH
     C                   Z-ADD     TRNAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCE
      *
      ** Revalue the transfer amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANKS       W#RTCD
     C                   PARM      *BLANKS       W#ERMS
     C                   PARM      'B'           BUYSELL
     C                   PARM      TRNCCY        ECCY
     C                   PARM      DBTVDT        EDAT
     C                   PARM      TRNAMT        EAMT
     C                   PARM                    DBCE
     C                   PARM      BJRDNB        BJRDNB
     C                   PARM      BJCYCD        BJCYCD
     C                   PARM      BSNBDP        BSNBDP
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA
     C                   PARM      *ZERO         RATE
     C                   PARM      *ZERO         PLAM
 
     C                   IF        W#RTCD = '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      STPLAM = PLAM
     C                   ENDIF
      *
      ** Convert payment amount to base currency equivalent
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     PYBCQS        ZEXCH
     C                   Z-ADD     PAYAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCE
      *
      ** Revalue payment amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANKS       W#RTCD
     C                   PARM      *BLANKS       W#ERMS
     C                   PARM      'B'           BUYSELL
     C                   PARM      PAYCCY        ECCY
     C                   PARM      CRDVDT        EDAT
     C                   PARM      PAYAMT        EAMT
     C                   PARM                    DBCE
     C                   PARM      BJRDNB        BJRDNB
     C                   PARM      BJCYCD        BJCYCD
     C                   PARM      BSNBDP        BSNBDP
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA
     C                   PARM      *ZERO         RATE
     C                   PARM      *ZERO         PLAM
 
     C                   IF        W#RTCD = '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PYPLAM = PLAM
     C                   ENDIF
 
     C                   EVAL      PLAmount = STPLAM + PYPLAM
 
     C                   ELSE
 
     C                   EVAL      PLAmount = *ZEROS
 
     C                   ENDIF
      *
      ** Set ordering customer type
      ** Set revenue ordering customer in
     C                   IF        DCUSTP <> *BLANKS
     C                   EVAL      OrdCustTp = DCUSTP
     C                   EVAL      OrdCust   = TOCUS1
     C                   ELSE
     C                   EVAL      OrdCustTp = CUSTTP
     C                   EVAL      OrdCust   = HOCUS1
     C                   ENDIF
      *
      ** Set beneficiary customer type
      ** Set beneficiary customer in
     C                   EVAL      BnfCustTp = BENTTP
     C                   EVAL      BnfCust   = TBNA35
      *
      ** Determine revenue customer.
      *
     C                   EXSR      P97
      *
      ** Setup transaction reference
      *
     C                   IF        FPTRID <> *BLANKS
 
     C                   EVAL      Ix = 1
     C     FPTRID        LOOKUP    TrnIDAr(Ix)                            18
     C                   IF        TrnsIdFnd = True
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WTransRef = PREF
     C                   ENDIF
      *
      ** Clear projected transaction data structure
      *
     C                   CLEAR                   T#TRAN
      *
      ** Set up projected transaction data structure
     C                   EVAL      T#MOD  = 'FT'
     C                   EVAL      T#TREF = WTransRef
     C                   EVAL      T#TRTP = 'RI'
     C                   EVAL      T#TDES = 'INCOMING RFT'
     C                   EVAL      T#DDAT = BJRDNB
     C                   EVAL      T#VDAT = DBTVDT
     C                   EVAL      T#MDAT = CRDVDT
     C                   EVAL      T#BRCA = BRCA
     C                   EVAL      T#BOOK = BOKC
     C                   EVAL      T#TPFC = PRFC
     C                   MOVEL     WRevCust      T#CPTY
     C                   MOVEL     WRevCust      T#RCST
     C                   EVAL      T#MKVL = PLAmount
     C                   EVAL      T#VCCY = BJCYCD
     C                   EVAL      T#VCDP = BSNBDP
     C                   EVAL      T#ACTN = 'I'
      *
      ** Import the details of payment
     C                   EVAL      W#MODE = '*IMPTRAN'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Clear projected positions data structure
      *
     C                   CLEAR                   P#POSN
      *
      ** Set up projected positions data structure
     C                   EVAL      P#MOD  = 'FT'
     C                   EVAL      P#TREF = WTransRef
     C                   EVAL      P#ASLI = 'A'
     C                   EVAL      P#IACD = BJRDNB
     C                   EVAL      P#NOML = EAMT
     C                   EVAL      P#CCY  = ECCY
     C                   EVAL      P#NCDP = EVNBDP
     C                   EVAL      P#NMDP = EVNBDP
     C                   EVAL      P#SPDY = EVSPDY
      *
      ** Import the details of the opening position
     C                   EVAL      W#MODE = '*IMPOPBL'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected event data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'DD'
      *
      ** Import the details of the deal date event
     C                   EVAL      W#MODE = '*IMPEVNT'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P61 - Create value date event in the limit and revenue       *
      *        extraction module.                                     *
      *                                                               *
      *****************************************************************
     C     P61           BEGSR
      *
      ** Setup transaction reference
      *
     C                   IF        FPTRID <> *BLANKS
 
     C                   EVAL      Ix = 1
     C     FPTRID        LOOKUP    TrnIDAr(Ix)                            18
     C                   IF        TrnsIdFnd = True
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WTransRef = PREF
     C                   ENDIF
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected event data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'VD'
      *
      ** Import the details of the debit date event
     C                   EVAL      W#MODE = '*IMPEVNT'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P62 - Create a charge event for each charge account key.     *
      *                                                               *
      *****************************************************************
     C     P62           BEGSR
      *
      ** Setup transaction reference
      *
     C                   IF        FPTRID <> *BLANKS
 
     C                   EVAL      Ix = 1
     C     FPTRID        LOOKUP    TrnIDAr(Ix)                            18
     C                   IF        TrnsIdFnd = True
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WTransRef = PREF
     C                   ENDIF
      *
      ** Setup fee code
      *
     C                   EXSR      P95
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected event data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'FE'
     C                   EVAL      E#CHRG = EAMT
     C                   EVAL      E#TAMT = EAMT
     C                   EVAL      E#CCY  = ECCY
     C                   EVAL      E#NCDP = EVNBDP
     C                   EVAL      E#SSET = 'Y'
     C                   EVAL      E#SETM = '05'
     C                   EVAL      E#SETA = FPCNUM + FPACOD +FPASEQ
     C                   EVAL      E#SETB = FPBRCH
     C                   EVAL      E#SETC = FPCCY
     C                   EVAL      E#IO   = 'I'
     C                   EVAL      E#FEEC = FeeCode
      *
      ** Import the details of the fee event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P63 - Create the maturity date event in the limit and        *
      *        revenue extraction module and to create the margin     *
      *        event.                                                 *
      *                                                               *
      *****************************************************************
     C     P63           BEGSR
      *
      ** Setup transaction reference
      *
     C                   IF        FPTRID <> *BLANKS
 
     C                   EVAL      Ix = 1
     C     FPTRID        LOOKUP    TrnIDAr(Ix)                            18
     C                   IF        TrnsIdFnd = True
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WTransRef = PREF
     C                   ENDIF
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected event data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'MT'
      *
      ** Import the details of the maturity date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** If transfer currency is not the same as payment currency.
      ** Calculate total margin and generate event.
      *
     C                   IF        TRNCCY <> PAYCCY
      *
      ** If transfer currency is not local currency, calculate
      ** transfer margin.  Otherwise, set to zero.
     C                   IF        TRNCCY <> BJCYCD
      *
      ** Convert the transfer amount to base currency, using currency
      ** spot rate.
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     D2SPRT        ZEXCH
     C                   Z-ADD     TRNAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WOldBaseEq
      *
      ** Convert the transfer amount to base currency, using the current
      ** spot rate.
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     TFBCQS        ZEXCH
     C                   Z-ADD     TRNAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WCurBaseEq
 
     C                   EVAL      TfrMargin = WCurBaseEq - WOldBaseEq
 
     C                   ELSE
     C                   EVAL      TfrMargin = *ZEROS
     C                   ENDIF
      *
      ** If payment currency is not local currency, calculate
      ** payment margin.  Otherwise, set to zero.
     C                   IF        PAYCCY <> BJCYCD
      *
      ** Convert the payment amount to base currency, using currency
      ** spot rate.
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     D3SPRT        ZEXCH
     C                   Z-ADD     PAYAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WOldBaseEq
      *
      ** Convert the payment amount to base currency, using the current
      ** spot rate.
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     PYBCQS        ZEXCH
     C                   Z-ADD     PAYAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WCurBaseEq
 
     C                   EVAL      PayMargin = WCurBaseEq - WOldBaseEq
 
     C                   ELSE
     C                   EVAL      PayMargin = *ZEROS
     C                   ENDIF
      ************                                                                            208221
      ***Calculate*total*margin***************************************************************208221
      ************                                                                            208221
     C************       EVAL      CalcMargin = TfrMargin + PayMargin                         208221
     C************       IF        CalcMargin <> *ZEROS AND CalcMargin < *ZEROS               208221
     C************       EVAL      E#IO = 'I'                                                 208221
     C************       Z-SUB     CalcMargin    CalcMargin                                   208221
     C************       ELSE                                                                 208221
     C************       EVAL      E#IO = 'O'                                                 208221
     C************       ENDIF                                                                208221
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *                                                                                       208221
      ** Calculate total margin                                                               208221
      *                                                                                       208221
     C                   EVAL      CalcMargin = TfrMargin + PayMargin                         208221
     C                   IF        CalcMargin <> *ZEROS AND CalcMargin < *ZEROS               208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   Z-SUB     CalcMargin    CalcMargin                                   208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   ENDIF                                                                208221
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'XM'
     C                   EVAL      E#COMM = CalcMargin
     C                   EVAL      E#TAMT = CalcMargin
     C                   EVAL      E#CCY  = BJCYCD
     C                   EVAL      E#NCDP = BSNBDP
     C                   EVAL      E#SSET = 'Y'
     C                   EVAL      E#FEEC = 'FM'
      *
      ** Import the details of the excluding event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P70 - Initialise the limit and revenue extraction module     *
      *        for the outgoing customer credit transfer by calcula-  *
      *        ting the P/L. then creating 'transaction' and          *
      *        'opening position' entries.                            *
      *                                                               *
      *****************************************************************
     C     P70           BEGSR
      *
      ** Setup transaction reference
      *
     C                   EVAL      Ix = 1
     C     SEAC          LOOKUP    AccntArr(Ix)                           19
     C                   IF        AccntFnd = True
     C                   EVAL      TotAmtCr = TotalCr(Ix)
     C                   EVAL      TotAmtDr = TotalDr(Ix)
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
      *
      ** If transaction currency is not the same as payment currency,
      ** calculate Profit/Lost amount.  Otherwise, default to zero.
      *
     C                   IF        CCTCCY <> PAYCCY
      *
      ** Convert payment amount to base currency equivalent
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     PYBCQS        ZEXCH
     C                   Z-ADD     PAYAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCE
      *
      ** Revalue the payment amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANKS       W#RTCD
     C                   PARM      *BLANKS       W#ERMS
     C                   PARM      'B'           BUYSELL
     C                   PARM      PAYCCY        ECCY
     C                   PARM      DBTVDT        EDAT
     C                   PARM      TotAmtDr      EAMT
     C                   PARM                    DBCE
     C                   PARM      BJRDNB        BJRDNB
     C                   PARM      BJCYCD        BJCYCD
     C                   PARM      BSNBDP        BSNBDP
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA
     C                   PARM      *ZERO         RATE
     C                   PARM      *ZERO         PLAM
 
     C                   IF        W#RTCD = '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PYPLAM = PLAM
     C                   ENDIF
      *
      ** Convert credit transfer amount to base currency equivalent
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     TFBCQS        ZEXCH
     C                   Z-ADD     CCTAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCE
      *
      ** Revalue credit transfer amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANKS       W#RTCD
     C                   PARM      *BLANKS       W#ERMS
     C                   PARM      'S'           BUYSELL
     C                   PARM      CCTCCY        ECCY
     C                   PARM      CRDVDT        EDAT
     C                   PARM      TotAmtCr      EAMT
     C                   PARM                    DBCE
     C                   PARM      BJRDNB        BJRDNB
     C                   PARM      BJCYCD        BJCYCD
     C                   PARM      BSNBDP        BSNBDP
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA
     C                   PARM      *ZERO         RATE
     C                   PARM      *ZERO         PLAM
 
     C                   IF        W#RTCD = '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      STPLAM = PLAM
     C                   ENDIF
 
     C                   EVAL      PLAmount = STPLAM + PYPLAM
 
     C                   ELSE
     C                   EVAL      PLAmount = *ZEROS
     C                   ENDIF
      *
      ** Set ordering customer type
      ** Set revenue ordering customer in
      *
     C**********         IF        ORDITP <> *BLANKS                                          197196
     C**********         EVAL      OrdCustTp = ORDITP                                         197196
     C                   IF        CUSTTD <> *BLANKS                                          197196
     C                   EVAL      OrdCustTp = CUSTTD                                         197196
     C                   EVAL      OrdCust   = ORDCU1
     C                   ELSE
     C                   EVAL      OrdCustTp = CUSTTH
     C                   EVAL      OrdCust   = TOCUS1
     C                   ENDIF
      *
      ** Set beneficiary customer type
      ** Set beneficiary customer in
      *
     C                   EVAL      BnfCustTp = BENTTD
     C                   EVAL      BnfCust   = BENF1
      *
      ** Determine revenue customer.
      *
     C                   EXSR      P97
      *
      ** Clear projected transaction data structure
      *
     C                   CLEAR                   T#TRAN
      *
      ** Set up projected transaction data structure
     C                   EVAL      T#MOD  = 'FT'
     C                   EVAL      T#TREF = WTransRef
     C                   EVAL      T#TRTP = 'BO'
     C                   EVAL      T#TDES = 'OUTGOING CCT'
     C                   EVAL      T#DDAT = BJRDNB
     C                   EVAL      T#VDAT = BJRDNB
     C                   EVAL      T#MDAT = DBTVDT
     C                   EVAL      T#BRCA = BRCA
     C                   EVAL      T#BOOK = BOKC
     C                   EVAL      T#TPFC = PRFC
     C                   MOVEL     WRevCust      T#CPTY
     C                   MOVEL     WRevCust      T#RCST
     C                   EVAL      T#MKVL = PLAmount
     C                   EVAL      T#VCCY = BJCYCD
     C                   EVAL      T#VCDP = BSNBDP
     C                   EVAL      T#ACTN = 'I'
      *
      ** Import the details of input date transaction
     C                   EVAL      W#MODE = '*IMPTRAN'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Clear projected positions data structure
      *
     C                   CLEAR                   P#POSN
      *
      ** Set up projected positions data structure
     C                   EVAL      P#MOD  = 'FT'
     C                   EVAL      P#TREF = WTransRef
     C                   EVAL      P#ASLI = 'A'
     C                   EVAL      P#IACD = BJRDNB
     C                   EVAL      P#NOML = EAMT
     C                   EVAL      P#CCY  = ECCY
     C                   EVAL      P#NCDP = EVNBDP
     C                   EVAL      P#NMDP = EVNBDP
     C                   EVAL      P#SPDY = EVSPDY
      *
      ** Import the details of the opening position
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'DD'
      *
      ** Import the details of the deal date event
     C                   EVAL      W#MODE = '*IMPEVNT'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P71 - Create the maturity date event in the limit and        *
      *        revenue extraction module and to create the margin     *
      *        event.                                                 *
      *                                                               *
      *****************************************************************
     C     P71           BEGSR
      *
      ** Setup transaction reference
      *
     C                   EVAL      Ix = 1
     C     SEAC          LOOKUP    AccntArr(Ix)                           19
     C                   IF        AccntFnd = True
     C                   EVAL      TotAmtCr = TotalCr(Ix)
     C                   EVAL      TotAmtDr = TotalDr(Ix)
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'MT'
      *
      ** Import the details of the maturity date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** If transaction currency is not the same as payment currency,
      ** calculate total margin and generate event.
      *
     C                   IF        CCTCCY <> PAYCCY
      *
      ** If transfer currency is not local currency, calculate
      ** transfer margin.  Otherwise, set to zero.
     C                   IF        CCTCCY <> BJCYCD
      *
      ** Convert the total transfer amount to base currency, using
      ** currency spot rate.
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     D2SPRT        ZEXCH
     C                   Z-ADD     TotAmtCr      ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WOldBaseEq
      *
      ** Convert the total transfer amount to base currency, using the
      ** current spot rate.
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     TFBCQS        ZEXCH
     C                   Z-ADD     TotAmtCr      ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WCurBaseEq
 
     C                   EVAL      TfrMargin = WCurBaseEq - WOldBaseEq
 
     C                   ELSE
     C                   EVAL      TfrMargin = *ZEROS
     C                   ENDIF
      *
      ** If payment currency is not local currency, calculate
      ** payment margin.  Otherwise, set to zero.
     C                   IF        PAYCCY <> BJCYCD
      *
      ** Convert the total payment amount to base currency, using
      ** currency spot rate.
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     D3SPRT        ZEXCH
     C                   Z-ADD     TotAmtDr      ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WOldBaseEq
      *
      ** Convert the total payment amount to base currency, using the
      ** current spot rate.
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     PYBCQS        ZEXCH
     C                   Z-ADD     TotAmtDr      ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WCurBaseEq
 
     C                   EVAL      PayMargin = WCurBaseEq - WOldBaseEq
 
     C                   ELSE
     C                   EVAL      PayMargin = *ZEROS
     C                   ENDIF
      ************                                                                            208221
      ***Calculate*total*margin***************************************************************208221
      ************                                                                            208221
     C************       EVAL      CalcMargin = TfrMargin + PayMargin                         208221
     C************       IF        CalcMargin <> *ZEROS AND CalcMargin < *ZEROS               208221
     C************       EVAL      E#IO = 'O'                                                 208221
     C************       Z-SUB     CalcMargin    CalcMargin                                   208221
     C************       ELSE                                                                 208221
     C************       EVAL      E#IO = 'I'                                                 208221
     C************       ENDIF                                                                208221
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *                                                                                       208221
      ** Calculate total margin                                                               208221
      *                                                                                       208221
     C                   EVAL      CalcMargin = TfrMargin + PayMargin                         208221
     C                   IF        CalcMargin <> *ZEROS AND CalcMargin < *ZEROS               208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   Z-SUB     CalcMargin    CalcMargin                                   208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ENDIF                                                                208221
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'XM'
     C                   EVAL      E#COMM = CalcMargin
     C                   EVAL      E#TAMT = CalcMargin
     C                   EVAL      E#CCY  = BJCYCD
     C                   EVAL      E#NCDP = BSNBDP
     C                   EVAL      E#SSET = 'Y'
     C                   EVAL      E#FEEC = 'FM'
      *
      ** Import the details of the excluding event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P72 - Create a charge event for each charge account key.     *
      *                                                               *
      *****************************************************************
     C     P72           BEGSR
      *
      ** Setup transaction reference
      *
     C                   EVAL      Ix = 1
     C     SEAC          LOOKUP    AccntArr(Ix)                           19
     C                   IF        AccntFnd = True
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
      *
      ** Setup fee code
      *
     C                   EXSR      P95
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'FE'
     C                   EVAL      E#CHRG = EAMT
     C                   EVAL      E#TAMT = EAMT
     C                   EVAL      E#CCY  = ECCY
     C                   EVAL      E#NCDP = EVNBDP
     C                   EVAL      E#SSET = 'Y'
     C                   EVAL      E#SETM = '05'
     C                   EVAL      E#SETA = FPCNUM + FPACOD +FPASEQ
     C                   EVAL      E#SETB = FPBRCH
     C                   EVAL      E#SETC = FPCCY
     C                   EVAL      E#IO   = 'I'
     C                   EVAL      E#FEEC = FeeCode
      *
      ** Import the details of the fee event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P80 - Inilialise the limit and revenue extraction module     *
      *        for the incoming customer credit transfer by calcu-    *
      *        lating the P/L, then creating credit 'transaction'     *
      *        and 'opening position' entries.                        *
      *                                                               *
      *****************************************************************
     C     P80           BEGSR
      *
      ** If transaction currency is not the same as the payment currency,
      ** calculate Profit/Lost amount.  Otherwise, default to zero.
      *
     C                   IF        CCTCCY <> PAYCCY
      *
      ** Convert credit transfer amount to base currency equivalent
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     TFBCQS        ZEXCH
     C                   Z-ADD     CCTAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCE
      *
      ** Revalue the credit transfer amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANKS       W#RTCD
     C                   PARM      *BLANKS       W#ERMS
     C                   PARM      'B'           BUYSELL
     C                   PARM      CCTCCY        ECCY
     C                   PARM      DBTVDT        EDAT
     C                   PARM      CCTAMT        EAMT
     C                   PARM                    DBCE
     C                   PARM      BJRDNB        BJRDNB
     C                   PARM      BJCYCD        BJCYCD
     C                   PARM      BSNBDP        BSNBDP
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA
     C                   PARM      *ZERO         RATE
     C                   PARM      *ZERO         PLAM
 
     C                   IF        W#RTCD = '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      STPLAM = PLAM
     C                   ENDIF
      *
      ** Convert payment amount to base currency equivalent
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     PYBCQS        ZEXCH
     C                   Z-ADD     PAYAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        DBCE
      *
      ** Revalue the payment amount
     C                   CALLB     'DEFWDREVN'
     C                   PARM      *BLANKS       W#RTCD
     C                   PARM      *BLANKS       W#ERMS
     C                   PARM      'S'           BUYSELL
     C                   PARM      PAYCCY        ECCY
     C                   PARM      CRDVDT        EDAT
     C                   PARM      PAYAMT        EAMT
     C                   PARM                    DBCE
     C                   PARM      BJRDNB        BJRDNB
     C                   PARM      BJCYCD        BJCYCD
     C                   PARM      BSNBDP        BSNBDP
     C                   PARM      SDCURR        SDCURR
     C                   PARM      *ZERO         REVA
     C                   PARM      *ZERO         RATE
     C                   PARM      *ZERO         PLAM
 
     C                   IF        W#RTCD = '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PYPLAM = PLAM
     C                   ENDIF
 
     C                   EVAL      PLAmount = STPLAM + PYPLAM
 
     C                   ELSE
     C                   EVAL      PLAmount = *ZEROS
     C                   ENDIF
      *
      ** Set ordering customer type
      ** Set revenue ordering customer in
      *
     C                   IF        CUSTTD <> *BLANK
     C                   EVAL      OrdCustTp = CUSTTD
     C                   EVAL      OrdCust   = ORDCU1
     C                   ELSE
     C                   EVAL      OrdCustTp = CUSTTH
     C                   EVAL      OrdCust   = TOCUS1
     C                   ENDIF
      *
      ** Set beneficiary customer type
      ** Set beneficiary customer in
      *
     C                   EVAL      BnfCustTp = BENTTD
     C                   EVAL      BnfCust   = BENF1
      *
      ** Determine revenue customer.
      *
     C                   EXSR      P97
      *
      ** Setup transaction reference
      *
     C                   IF        FPTRID <> *BLANKS
 
     C                   EVAL      Ix = 1
     C     FPTRID        LOOKUP    TrnIDAr(Ix)                            18
     C                   IF        TrnsIdFnd = True
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WTransRef = PREF
     C                   ENDIF
      *
      ** Clear projected transaction data structure
      *
     C                   CLEAR                   T#TRAN
      *
      ** Set up projected transaction data structure
     C                   EVAL      T#MOD  = 'FT'
     C                   EVAL      T#TREF = WTransRef
     C                   EVAL      T#TRTP = 'BI'
     C                   EVAL      T#TDES = 'INCOMING CCT'
     C                   EVAL      T#DDAT = BJRDNB
     C                   EVAL      T#VDAT = BJRDNB
     C                   EVAL      T#MDAT = CRDVDT
     C                   EVAL      T#BRCA = BRCA
     C                   EVAL      T#BOOK = BOKC
     C                   EVAL      T#TPFC = PRFC
     C                   MOVEL     WRevCust      T#CPTY
     C                   MOVEL     WRevCust      T#RCST
     C                   EVAL      T#MKVL = PLAmount
     C                   EVAL      T#VCCY = BJCYCD
     C                   EVAL      T#VCDP = BSNBDP
     C                   EVAL      T#ACTN = 'I'
      *
      ** Import the details of input date transaction
     C                   EVAL      W#MODE = '*IMPTRAN'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Clear projected positions data structure
      *
     C                   CLEAR                   P#POSN
      *
      ** Set up projected positions data structure
     C                   EVAL      P#MOD  = 'FT'
     C                   EVAL      P#TREF = WTransRef
     C                   EVAL      P#ASLI = 'A'
     C                   EVAL      P#IACD = BJRDNB
     C                   EVAL      P#NOML = EAMT
     C                   EVAL      P#CCY  = ECCY
     C                   EVAL      P#NCDP = EVNBDP
     C                   EVAL      P#NMDP = EVNBDP
     C                   EVAL      P#SPDY = EVSPDY
      *
      ** Import the details of the opening position
     C                   EVAL      W#MODE = '*IMPOPBL'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected event data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'DD'
      *
      ** Import the details of the deal date event
     C                   EVAL      W#MODE = '*IMPEVNT'
     C                   EVAL      W#PH   = 'P'
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P81 - Create the maturity date event in the limit and        *
      *        revenue extraction module and to create the margin     *
      *        event.                                                 *
      *                                                               *
      *****************************************************************
     C     P81           BEGSR
      *
      ** Setup transaction reference
      *
     C                   IF        FPTRID <> *BLANKS
 
     C                   EVAL      Ix = 1
     C     FPTRID        LOOKUP    TrnIDAr(Ix)                            18
     C                   IF        TrnsIdFnd = True
     C                   MOVE      Ix            IAx
     C                   EVAL      WTransRef = %TRIMR(PREF) + '-' + IAx
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WTransRef = PREF
     C                   ENDIF
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'MT'
      *
      ** Import the details of the maturity date event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** If transaction currency is not the same as the payment
      ** currency, calculate total margin and generate event.
      *
     C                   IF        CCTCCY <> PAYCCY
      *
      ** If transfer currency is not local currency, calculate
      ** transfer margin.  Otherwise, set to zero.
     C                   IF        CCTCCY <> BJCYCD
      *
      ** Convert the transfer amount to base currency, using currency
      ** spot rate.
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     D2SPRT        ZEXCH
     C                   Z-ADD     CCTAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WOldBaseEq
      *
      ** Convert the transfer amount to base currency, using the current
      ** spot rate.
     C                   Z-ADD     D2NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D2MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     TFBCQS        ZEXCH
     C                   Z-ADD     CCTAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WCurBaseEq
 
     C                   EVAL      TfrMargin = WCurBaseEq - WOldBaseEq
 
     C                   ELSE
     C                   EVAL      TfrMargin = *ZEROS
     C                   ENDIF
      *
      ** If payment currency is not local currency, calculate
      ** payment margin.  Otherwise, set to zero.
     C                   IF        PAYCCY <> BJCYCD
      *
      ** Convert the payment amount to base currency, using currency
      ** spot rate.
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     D3SPRT        ZEXCH
     C                   Z-ADD     PAYAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WOldBaseEq
      *
      ** Convert the payment amount to base currency, using the current
      ** spot rate.
     C                   Z-ADD     D3NBDP        ZCDPI
     C                   Z-ADD     BSNBDP        ZCDPO
     C                   IF        D3MDIN = 'M'
     C                   EVAL      ZMD    = 'D'
     C                   ELSE
     C                   EVAL      ZMD    = 'M'
     C                   ENDIF
     C                   Z-ADD     PYBCQS        ZEXCH
     C                   Z-ADD     PAYAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        WCurBaseEq
 
     C                   EVAL      PayMargin = WCurBaseEq - WOldBaseEq
 
     C                   ELSE
     C                   EVAL      PayMargin = *ZEROS
     C                   ENDIF
      ************                                                                            208221
      ***Calculate total margin                                                               208221
      ************                                                                            208221
     C************       EVAL      CalcMargin = TfrMargin + PayMargin                         208221
     C************       IF        CalcMargin <> *ZEROS AND CalcMargin < *ZEROS               208221
     C************       EVAL      E#IO = 'O'                                                 208221
     C************       Z-SUB     CalcMargin    CalcMargin                                   208221
     C************       ELSE                                                                 208221
     C************       EVAL      E#IO = 'I'                                                 208221
     C************       ENDIF                                                                208221
      *
      ** Clear projected event data structure
     C                   CLEAR                   E#EVNT
      *                                                                                       208221
      ** Calculate total margin                                                               208221
      *                                                                                       208221
     C                   EVAL      CalcMargin = TfrMargin + PayMargin                         208221
     C                   IF        CalcMargin <> *ZEROS AND CalcMargin < *ZEROS               208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   Z-SUB     CalcMargin    CalcMargin                                   208221
     C                   ELSE                                                                 208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ENDIF                                                                208221
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = WTransRef
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'XM'
     C                   EVAL      E#COMM = CalcMargin
     C                   EVAL      E#TAMT = CalcMargin
     C                   EVAL      E#CCY  = BJCYCD
     C                   EVAL      E#NCDP = BSNBDP
     C                   EVAL      E#SSET = 'Y'
     C                   EVAL      E#FEEC = 'FM'
      *
      ** Import the details of the excluding event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P82 - Create a charge event for each charge account key.     *
      *                                                               *
      *****************************************************************
     C     P82           BEGSR
      *
      ** Setup fee code
      *
     C                   EXSR      P95
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set up projected events data structure
     C                   EVAL      E#MOD  = 'FT'
     C                   EVAL      E#TREF = PREF
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = BJRDNB
     C                   EVAL      E#EVTP = 'FE'
     C                   EVAL      E#CHRG = EAMT
     C                   EVAL      E#TAMT = EAMT
     C                   EVAL      E#CCY  = ECCY
     C                   EVAL      E#NCDP = EVNBDP
     C                   EVAL      E#SSET = 'Y'
     C                   EVAL      E#SETM = '05'
     C                   EVAL      E#SETA = FPCNUM + FPACOD +FPASEQ
     C                   EVAL      E#SETB = FPBRCH
     C                   EVAL      E#SETC = FPCCY
     C                   EVAL      E#IO   = 'I'
     C                   EVAL      E#FEEC = FeeCode
      *
      ** Import the details of the fees event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   MOVEL     'P'           W#PH
 
     C                   EXSR      WrkEDTA
      *
      ** If data error encountered, log error
     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   WRITE     DEELOGP0
     C                   ENDIF
      *
      ** Set generate events to 'Y'
     C                   EVAL      GENEVT = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P95 - Setup fee code for fee events.                         *
      *                                                               *
      *****************************************************************
     C     P95           BEGSR
 
     C                   SELECT
      *
      ** Telex charge, non-taxable
     C                   WHEN      AKey10 ='X'
     C                   EVAL         FeeCode = 'TX'
      *
      ** Telex charge, taxable
     C                   WHEN      AKey10 ='V'
     C                   EVAL         FeeCode = 'TT'
      *
      ** Cheque charge, non-taxable
     C                   WHEN      AKey10 ='Q'
     C                   EVAL         FeeCode = 'CQ'
      *
      ** Cheque charge, taxable
     C                   WHEN      AKey10 ='Y'
     C                   EVAL         FeeCode = 'QT'
      *
      ** Senders charge.  Otherwise, Cost abroad non-taxable
     C                   WHEN      AKey10 ='C'
     C                   IF         AKey3 = 'D'
     C                   EVAL         FeeCode = 'SC'
     C                   ELSE
     C                   EVAL         FeeCode = 'AB'
     C                   ENDIF
      *
      ** Cost abroad taxable
     C                   WHEN      AKey10 ='Z'
     C                   EVAL         FeeCode = 'AT'
      *
      ** SWIFT standard charge non-taxable.  Otherwise, SWIFT
      ** priority charge non-taxable.
     C                   WHEN      AKey10 ='S'
     C                   IF         %SUBST(AKey9:1:1) = 'S'
     C                   EVAL         FeeCode = 'SS'
     C                   ELSE
     C                   EVAL         FeeCode = 'PS'
     C                   ENDIF
      *
      ** SWIFT standard charge taxable
     C                   WHEN      AKey10 ='T'
     C                   EVAL         FeeCode = 'ST'
      *
      ** Miscellaneous charge 2 non-taxable.
     C                   WHEN      AKey10 ='2'
     C                   IF         %SUBST(AKey9:1:1) = 'M'
     C                   EVAL         FeeCode = 'M2'
     C                   ELSE
      *
      ** Miscellaneous charge 2 taxable.  Otherwise, SWIFT priority
      ** charge taxable.
     C                   IF          %SUBST(AKey9:1:1) = 'N'
     C                   EVAL         FeeCode = 'N2'
     C                   ELSE
     C                   EVAL         FeeCode = 'PT'
     C                   ENDIF
     C                   ENDIF
      *
      ** Margin.  Otherwise, Miscellaneous charge non-taxable.
     C                   WHEN      AKey10 ='M'
     C                   IF         %SUBST(AKey9:1:1) = 'F'
     C                   EVAL         FeeCode = 'FM'
     C                   ELSE
     C                   EVAL         FeeCode = 'MI'
     C                   ENDIF
      *
      ** Miscellaneous charge 3 non-taxable.
     C                   WHEN      AKey10 ='3'
     C                   IF         %SUBST(AKey9:1:1) = 'M'
     C                   EVAL         FeeCode = 'M3'
     C                   ELSE
      *
      ** Miscellaneous charge 3 taxable.  Otherwise, miscellaneous
      ** charge taxable.
     C                   IF          %SUBST(AKey9:1:1) = 'N'
     C                   EVAL         FeeCode = 'N3'
     C                   ELSE
     C                   EVAL         FeeCode = 'MT'
     C                   ENDIF
     C                   ENDIF
      *
      ** Transfer commission non-taxable
     C                   WHEN      AKey10 ='F'
     C                   EVAL         FeeCode = 'TC'
      *
      ** Miscellaneous charge 4, non-taxable.
     C                   WHEN      AKey10 ='4'
     C                   IF         %SUBST(AKey9:1:1) = 'M'
     C                   EVAL         FeeCode = 'M4'
     C                   ELSE
      *
      ** Miscellaneous charge 4, taxable.  Otherwise, transfer
      ** commission taxable.
     C                   IF          %SUBST(AKey9:1:1) = 'N'
     C                   EVAL         FeeCode = 'N4'
     C                   ELSE
     C                   EVAL         FeeCode = 'CT'
     C                   ENDIF
     C                   ENDIF
      *
      ** FX/Change commission non-taxable.
     C                   WHEN      AKey10 ='J'
     C                   EVAL         FeeCode = 'FC'
      *
      ** Miscellaneous charge 5 non-taxable.
     C                   WHEN      AKey10 ='5'
     C                   IF         %SUBST(AKey9:1:1) = 'M'
     C                   EVAL         FeeCode = 'M5'
     C                   ELSE
      *
      ** Miscellaneous charge 5 taxable. Otherwise, FX/Change
      ** commission taxable.
     C                   IF          %SUBST(AKey9:1:1) = 'N'
     C                   EVAL         FeeCode = 'N5'
     C                   ELSE
     C                   EVAL         FeeCode = 'FT'
     C                   ENDIF
     C                   ENDIF
      *
      ** Miscellaneous charge 1 non-taxable.  Otherwise, miscellaneous
      ** charge 1 taxable.
     C                   WHEN      AKey10 ='1'
     C                   IF         %SUBST(AKey9:1:1) = 'M'
     C                   EVAL         FeeCode = 'M1'
     C                   ELSE
     C                   EVAL         FeeCode = 'N1'
     C                   ENDIF
      *
      ** Advice charge non-taxable
     C                   WHEN      AKey10 ='G'
     C                   EVAL         FeeCode = 'AV'
      *
      ** Advice charge taxable
     C                   WHEN      AKey10 ='6'
     C                   EVAL         FeeCode = 'VT'
      *
      ** Handling charge.  Otherwise, telephone charge non-taxable
     C                   WHEN      AKey10 ='H'
     C                   IF         AKey3 = 'I'
     C                   EVAL         FeeCode = 'HC'
     C                   ELSE
     C                   EVAL         FeeCode = 'PH'
     C                   ENDIF
      *
      ** Telephone charge taxable
     C                   WHEN      AKey10 ='7'
     C                   EVAL         FeeCode = 'HT'
      *
      ** Collection charge non-taxable
     C                   WHEN      AKey10 ='K'
     C                   EVAL         FeeCode = 'CL'
      *
      ** Collection charge taxable
     C                   WHEN      AKey10 ='8'
     C                   EVAL         FeeCode = 'LT'
      *
      ** Receiver's charges
     C                   WHEN      AKey10 ='R'
     C                   EVAL         FeeCode = 'RC'
 
     C                   ENDSL
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P96 - Set up the settlement account.                         *
      *                                                               *
      *****************************************************************
     C     P96           BEGSR
      *
      ** Detail ordering customer type is not blank
     C                   IF        CUSTTD <> *BLANK
     C                   EVAL      WCustType = CUSTTD
     C                   EVAL      WAccount  = ORDCU1
     C                   ELSE
      *
      ** Detail ordering institution type is not blank
     C                   IF        ORDITP <> *BLANK
     C                   EVAL      WCustType = ORDITP
     C                   EVAL      WAccount  = ORDI35
     C                   ELSE
      *
      ** Header sending institution type is not blank
     C                   IF        SINSTT <> *BLANK
     C                   EVAL      WCustType = SINSTT
     C                   EVAL      WAccount  = SINST
     C                   ELSE
      *
      ** Header ordering institution type is not blank
     C                   IF        ORDITP <> *BLANK
     C                   EVAL      WCustType = ORDITP
     C                   EVAL      WAccount  = OINST3
     C                   ELSE
      *
      ** Header ordering customer type is not blank
     C                   IF        CUSTTH <> *BLANK
     C                   EVAL      WCustType = CUSTTH
     C                   EVAL      WAccount  = TOCUS1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Format settlement account
      *
     C                   IF        %SUBST(WAccount:1:1) = '/'
     C                   EVAL      TmpAcc = %SUBST(WAccount:2:34)
     C                   EVAL      WAccount = *BLANKS
     C                   EVAL      WAccount = TmpAcc
     C                   ENDIF
      *
      ** Retail account
      *
     C                   IF        WCustType = 'R'
     C                   MOVEL     WAccount      WRK10
     C     WRK10         CHAIN     ACNUM                              16
     C                   IF        RecNotFnd = True
     C                   MOVEL     WRK10         DBKEY
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE  = 043
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CNUM          W#CNUM
     C                   MOVEL     CCY           W#CCY
     C                   MOVEL     ACOD          W#ACOD
     C                   MOVEL     ACSQ          W#ACSQ
     C                   MOVEL     BRCA          W#BRCA
     C                   ENDIF
     C                   ENDIF
      *
      ** General ledger account
      *
     C                   IF        WCustType = 'G'
     C**********         EVAL      W#ACID = %SUBST(WAccount:1:18)                             CGL029
     C                   EVAL      W#ACID = %SUBST(WAccount:1:24)                             CGL029
     C                   ENDIF
      *
      ** Full nostro account
      *
     C                   IF        WCustType = 'F'
     C                   EVAL      KEY = *BLANKS
     C                   EVAL      KEY = '70'
     C                   EVAL      WNostro = %SUBST(WAccount:1:5)
     C                   MOVE      WNostro       KEY
     C     KEY           CHAIN     TABLETLF                           16
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY  = KEY
     C                   EVAL      DBFILE = 'TABLETL'
     C                   EVAL      DBASE  = 045
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CNUM          W#CNUM
     C                   EVAL      W#CCY = %SUBST(WNostro:1:3)
     C                   MOVEL     ACOD          W#ACOD
     C                   MOVEL     ACSQ          W#ACSQ
     C                   MOVEL     BRCA          W#BRCA
     C                   ENDIF
     C                   ENDIF
      *
      ** IBAN account
      *
     C                   IF        WCustType = 'I' AND CFT004 = 'Y'
     C************       EVAL      PIBAN = %SUBST(WAccount:2:34)                              208221
     C                   EVAL      PIBAN = WAccount                                           208221
     C                   CALLB     'AOIBANR4'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PIBAN
     C     PAccntDS      PARM      *BLANKS       DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY  = PIBAN
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE  = 044
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CNUM          W#CNUM
     C                   MOVEL     CCY           W#CCY
     C                   MOVEL     ACOD          W#ACOD
     C                   MOVEL     ACSQ          W#ACSQ
     C                   MOVEL     BRCA          W#BRCA
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P97 - Setup revenue customer.                                *
      *                                                               *
      *****************************************************************
     C     P97           BEGSR
 
     C                   EVAL      WRevCust = *BLANKS
      *
      ** Process account if customer type is not blank.
      *
     C                   IF        OrdCustTp <> *BLANK
 
     C                   EVAL      WCustType = OrdCustTp
     C                   IF        %SUBST(OrdCust:1:1) = '/'
     C                   EVAL      WAccount  = %SUBST(OrdCust:2:34)
     C                   ELSE
     C                   EVAL      WAccount  = OrdCust
     C                   ENDIF
      *
      ** Retail account
      *
     C                   IF        WCustType = 'R'
 
     C                   MOVEL     WAccount      WRK10
     C     WRK10         CHAIN     ACNUM                              16
     C                   IF        RecNotFnd = True
     C                   MOVEL     WRK10         DBKEY
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE  = 038
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CNUM          WRevCust
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Customer number or Partial customer
      *
     C                   IF        WCustType = 'P' OR WCustType = 'C'
     C                   EVAL      WRevCust = %SUBST(WAccount:1:6)
     C                   ENDIF
      *
      ** General ledger account
      *
     C                   IF        WCustType = 'G'
     C                   EVAL      WRevCust = %SUBST(WAccount:4:6)
     C                   ENDIF
      *
      ** IBAN account
      *
     C                   IF        WCustType = 'I' AND CFT004 = 'Y'
 
     C************       EVAL      PIBAN = %SUBST(WAccount:2:34)                              208221
     C                   EVAL      PIBAN = WAccount                                           208221
     C                   CALLB     'AOIBANR4'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PIBAN
     C     PAccntDS      PARM      *BLANKS       DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY  = PIBAN
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE  = 039
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CNUM          WRevCust
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         IF        WRevCust = *ZEROS AND OrdCustTp <> *BLANK                  CSD027
     C                   IF        WRevCust = *BLANKS AND OrdCustTp <> *BLANK                 CSD027
 
     C                   EVAL      WCustType = BnfCustTp
     C                   IF        %SUBST(BnfCust:1:1) = '/'
     C                   EVAL      WAccount  = %SUBST(BnfCust:2:34)
     C                   ELSE
     C                   EVAL      WAccount  = BnfCust
     C                   ENDIF
      *
      ** Retail account
      *
     C                   IF        WCustType = 'R'
 
     C                   MOVEL     WAccount      WRK10
     C     WRK10         CHAIN     ACNUM                              16
     C                   IF        RecNotFnd = True
     C                   MOVEL     WRK10         DBKEY
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE  = 040
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CNUM          WRevCust
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Customer number or Partial customer
      *
     C                   IF        WCustType = 'P' OR WCustType = 'C'
     C                   EVAL      WRevCust = %SUBST(WAccount:1:6)
     C                   ENDIF
      *
      ** General ledger account
      *
     C                   IF        WCustType = 'G'
     C                   EVAL      WRevCust = %SUBST(WAccount:4:6)
     C                   ENDIF
      *
      ** IBAN account
      *
     C                   IF        WCustType = 'I' AND CFT004 = 'Y'
 
     C************       EVAL      PIBAN = %SUBST(WAccount:2:34)                              208221
     C                   EVAL      PIBAN = WAccount                                           208221
     C                   CALLB     'AOIBANR4'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PIBAN
     C     PAccntDS      PARM      *BLANKS       DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY  = PIBAN
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE  = 041
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CNUM          WRevCust
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If revenue customer has not been setup from the previous
      ** processing,  retrieve the internal branch customer and use
      ** it as revenue customer.
     C**********         IF        WRevCust = *ZEROS                                          CSD027
     C                   IF        WRevCust = *BLANKS                                         CSD027
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRCA          PBrch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY  = BRCA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE  = 042
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WRevCust = A8BICN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A                                           208221
      *****************************************************************                       208221
      /COPY DECPYSRC,DEXTWEDTA                                                                208221
      *****************************************************************                       208221
      **WORK*WITH*EXTRACT*DATA*****************************************                       208221
      *****************************************************************                       208221
     C*****WRKEDTA*      BEGSR                                                                208221
      *************                                                                           208221
     C*************      CALLB     'DEWRKEDTA'                                                208221
     C*************      PARM      *BLANK        W#RTCD            7                          208221
     C*************      PARM      *BLANK        W#ERMS           30                          208221
     C*************      PARM                    W#MODE           10                          208221
     C*************      PARM      I#PH          W#PH              1                          208221
     C*************      PARM      I#EOB         W#EOB             1                          208221
     C*************      PARM      I#RDNB        W#RDNB            5 0                        208221
     C*************      PARM      I#DNWD        W#DNWD            5 0                        208221
     C*************      PARM      I#HCOD        W#HCOD            5 0                        208221
     C*************      PARM      I#EVCD        W#EVCD            5 0                        208221
     C*************      PARM      I#PCOD        W#PCOD            5 0                        208221
      **TRANSACTION****************************************************                       208221
     C*************      PARM                    T#TRAN                                       208221
      **POSITION*******************************************************                       208221
     C*************      PARM                    P#POSN                                       208221
      **EVENT**********************************************************                       208221
     C*************      PARM                    E#EVNT                                       208221
      **CASHFLOW*******************************************************                       208221
     C*************      PARM                    C#CASH                                       208221
      **SDBANK*********************************************************                       208221
     C*************      PARM                    SDBANK                                       208221
      **SDGELR*********************************************************                       208221
     C*************      PARM                    SDGELR                                       208221
      *************                                                                           208221
      **If*severe*error*encountered,*end*******************************                       208221
     C*****W#RTCD**      IFEQ      '*ERROR '                                                  208221
     C*************      EVAL      I#ERMS = 'ERROR IN CALL TO DEWRKEDTA'                      208221
     C*************      EXSR      *PSSR                                                      208221
     C*************      ENDIF                                                                208221
      *************                                                                           208221
     C*************      ENDSR                                                                208221
      ********************************************************************                    208221
      /SPACE 5
      ********************************************************************
      **
      **   ZCONVN - SUBROUTINE TO CONVERT AN  AMOUNT FROM ONE CURRENCY
      **               TO ANOTHER
      **
      **   INPUT  - ZAMTCI (15,0) AMOUNT INPUT
      **            ZEXCH  (13,8) EXCHANGE RATE
      **            ZMD    (1)    MULTIPLY/DIVIDE INDICATOR
      **            ZCDPI  (1,0)  CURRENCY DECIMAL PLACES INPUT
      **            ZCDPO  (1,0)  CURRENCY DECIMAL PLACES TO BE CONVERTED TO
      **            POWER   -     COMPILE TIME ARRAY MUST BE INCLUDED
      **                          IN THE PROGRAM SOURCE
      **
      **  OUTPUT -  ZAMTCO (15,0) AMOUNT OUTPUT
      **
      **********************************************************************
     C     ZCONVN        BEGSR                                                  ** ZCONVN **
      *
      * DEFINE INPUT AND OUTPUT FIELDS
      *
     C                   Z-ADD     ZAMTCI        ZAMTCI           15 0
     C                   Z-ADD     0             ZAMTCO           15 0
     C                   Z-ADD     ZCDPI         ZCDPI             1 0
     C                   Z-ADD     ZCDPO         ZCDPO             1 0
     C                   Z-ADD     ZEXCH         ZEXCH            13 8
     C                   MOVEL     ZMD           ZMD               1
      *
      * IF EXCHANGE RATE IS 0 - OUTPUT CURRENCY AMOUNT AS ZERO
      *
     C     ZEXCH         IFEQ      0
     C                   Z-ADD     0             ZAMTCO
     C                   GOTO      EZCNVN
     C                   END
      *
      * IF DECIMAL PLACES ARE THE SAME FOR BOTH CURRENCIES
      *
     C     ZCDPI         IFEQ      ZCDPO
      *
      ***  CALCULATE OUTPUT CURRENCY AMOUNT BY DIVIDING EXCHANGE RATE INTO
      *** OR MULTIPLYING EXCHANGE RATE BY CURRENCY AMOUNT INPUT DEPENDING
      *** ON INDICATOR
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE
      *
      *** IF DECIMAL PLACES DIFFER -
      ***      CALCULATE DIFFERENCE IN DECIMAL PLACES TO USE AS POWER INDEX
      *
     C     ZCDPO         SUB       ZCDPI         ZPX               1 0
     C                   ADD       4             ZPX
      *
      *** CALCULATE CURRENCY AMOUNT OUTPUT BY MULTIPLYING INPUT AMOUNT BY
      ***  POWER ARRAY ENTRY AND THEN MULTIPLYING RESULT BY EXCHANGE RATE
      ***  DEPENDING ON INDICATOR
      *
     C     POWER(ZPX)    IFLT      1                                            from d.p *LT
     C     ZAMTCI        MULT      POWER(ZPX)    Z15#3            15 3           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     Z15#3         DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     Z15#3         MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE                                                   from d.p. *GT
     C     ZAMTCI        MULT      POWER(ZPX)    ZAMTCI                           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C     EZCNVN        ENDSR                                                  ** EZCNVN **
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**   POWER - POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  CPY@
(c) Finastra International Limited 2001
