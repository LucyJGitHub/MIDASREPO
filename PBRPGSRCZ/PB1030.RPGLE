     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PB Default PTFR for new PB customer')            *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  PB1030 - Default PTFR for New Private Banking Customer.      *
      *                                                               *
      *  Function:  This program sets up field PTFR, for new Private  *
      *             Banking Customer, with first Portfolio Definition *
      *             that is created.                                  *
      *                                                               *
      *  (phase(s) Input Cycle)                                       *
      *                                                               *
      *  Called By: PBC1030 - (program name)                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CER070             Date 24Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSW212             Date 03May12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG22529           Date 09Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 29Sep06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSE075             Date 17Nov05               *
      *                 CDL038             Date 10May05               *
      *                 233196             Date 25Apr05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009             Date 16May05               *
      *                 CAS010             Date 09Feb05               *
      *                 CAS008             Date 16Jun06               *
      *                 224860             Date 05Feb04               *
      *                 208648             Date 21Aug02               *
      *                 198688             Date 04Oct02               *
      *                 CPB004             Date 11Jul02               *
      *                 199015             Date 05Jul02               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAP074             Date 08Aug02               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198387             Date 21Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 13Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  233196 - PB1030 changes to ensure TOF receive addtl cust detl*
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  224860 - Incorrect sequence of processing. Accounts must be  *
      *           treated before other transactions ... and then sent *
      *           again for balances.                                 *
      *  208648 - Review FX rates processing                          *
      *           When PM is off, PMHSEXPD is not filled. Always use  *
      *           SDCUHSPD                                            *
      *  198688 - Correct parameters list transmit and receive.       *
      *           to be consistent with ZYLD. Pass SECTYD record fmt. *
      *  CPB004 - In addition to Retail accouts, set replication for  *
      *           GL accounts with account codes designated for       *
      *           transfer to TOF.                                    *
      *  199015 - "I/O operation was applied to closed file SECOAL11" *
      *           Ensure corporate action files used only when        *
      *           feature CSE007 is switched ON                       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes SDSECSPD.                *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *           (Recompile)                                         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  198387 - Access to the security details in case of trade.    *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
 
      **  SE Security Details, sorted by SESN.
     FSECTY     IF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  PM Customer Positions, sorted by CSCN/CSSC/CSBA/CSDA.
     FPMCPSNL0  IF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  SE Trades, sorted by TCNR/TDRF.
     FTRADCU    IF   E           K Disk
     F                                     Rename(TRADSDF:TRADCUF)
     F                                     Infsr(*Pssr)
 
      **  SE Historic Trades, sorted by TDRF.
     FHSTTTR    IF   E           K Disk
     F                                     RENAME(HSTTRDF:HSTTTRF)
     F                                     Infsr(*Pssr)
 
      ****PM*Historic*Exchange*Rate,*sorted*by*Q8CCY/Q8SDAT****************     208648
     F**PMHSEXPD  IF   E           K Disk                                       208648
     F**********                           Infsr(*Pssr)                         208648
      **********                                                                208648
      **  SD Historic Exchange Rate, sorted by G2CYCS/G2HIDT Desc               208648
     FSDCUHSL2  IF   E           K Disk                                         208648
     F                                     Infsr(*Pssr)                         208648
                                                                                208648
 
      **  SE Security Diary Events, sorted by SDSN/SDED/SDET.
     FSEDEV     IF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  SE Security Events, sorted by SNSN/SNET/SNDT.
      **                                SDSN/SDET/SDED.
     FSECEO     IF   E           K Disk
     F                                     Rename(SEDEVDF:SEDEVD0)
     F                                     Rename(SNDEVDF:SNDEVD0)
     F                                     Infsr(*Pssr)
 
      **  MM and FX Deals, sorted by CNUM/PTFR.
     FPMDEALL4  UF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  FD Deal Types/Subtypes, sorted by DTPE11/DLST11.
     FFDDTSTL0  UF A E           K Disk
     F                                     Infsr(*Pssr)
 
      **  FX Deals, sorted by FHDN38.
     FFXDEALLL  UF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  MM Deals, sorted by HKDN38.
     FMMDEALLL  UF   E           K Disk
     F                                     Ignore(MMDENSP0)
     F                                     Infsr(*Pssr)
 
      **  SE Current and historic Trades, sorted by TCNR/TDSS/TDBA/TDDT/TDRF.
     FTRADC     UF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  SE Depot Movements, sorted by DPBN/DPRN.
     FDEPMVC    UF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  LE Customer Loans, sorted by CNUM.
     FPMCLONL6  UF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  LE Matured Customer Loans, sorted by CNUM.
     FPMCLONL0  UF   E           K Disk
     F                                     Rename(CLOANCLF:PMCLONF0)
     F                                     Infsr(*Pssr)
 
      **  GL Accounts Master Details, sorted by CNUM/CCY/ACOD/ACSQ/BRCA.
     FACCNT     UF   E           K Disk
     F                                     Ignore(ACCNTAAF)
     F                                     Ignore(ACCNTACF)
     F                                     Infsr(*Pssr)
 
      **  SE Historic Customer Average Price, sorted by CSCN/CSBA/CSSC/CSDA/CSSE/CSRF.
     FCAPRH     UF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  PM Portfolio Positions Audit.
     FPMCPOSPA  UF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  PM All Portfolio Positions, sorted by QACNUM/QAPTFR/QATDSS/QATVDA/QAPDAT.
     FPMAPOSLL  UF A E           K Disk
     F                                     Infsr(*Pssr)
 
      **  FF Transactions, sorted by CUSC.
     FTRANSC    UF   E           K Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Customer Depot Positions, sorted by CDCN/CDSN/CDPA/DDTE.
     FCDEPD     UF   E           K Disk    Usropn
     F                                     Rename(CDEPPDF:CDEPDF)
     F                                     Infsr(*Pssr)
 
      **  SE Allocations, sorted by VCCNUM/VCPTFR.
     FSEERALL3  UF   E           K Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Allocations, sorted by VCCNUM/VCERRF/VCBRCD/VCDDPT.
     FSEERALL4  UF A E           K Disk    Usropn
     F                                     Rename(SEERALD0:SEERALD4)
     F                                     Infsr(*Pssr)
 
      **  SE General Blocks, sorted by VDCNUM/VDPTFR/VDBEDT.
     FSEBLKPL4  UF   E           K Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Client Depot Positions Audit.
     FCDEPPA    UF   E             Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Corporate Actions Allocations, sorted by MCCNUM.
     FSECOAL11  UF   E           K Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Corporate Actions Affected Positions, sorted by MXCNUM.
     FSECOAPL1  UF   E           K Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Corporate Actions Blocked Positions, sorted by MUCNUM.
     FSECOBKL3  UF   E           K Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Corporate Actions Correspondance Details, sorted by MVCNUM.
     FSECOCOL1  UF   E           K Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Corporate Actions Instructions, sorted by MOCNUM.
     FSECOSIL3  UF   E           K Disk    Usropn
     F                                     Infsr(*Pssr)
 
      **  SE Customer Position Profit Centre, sorted by CNUM.
     FSEPPCL0   UF   E           K Disk
     F                                     Infsr(*Pssr)
                                                                                              233196
      **  SD Additional Customer Details                                                      233196
     FSDACUSL0  UF   E           K Disk                                                       233196
     F                                     Infsr(*Pssr)                                       233196
                                                                                              233196
      **  SD Additional Customer by Country of Tax by CNUM                                    233196
     FSDACTXL4  UF   E           K Disk                                                       233196
     F                                     Infsr(*Pssr)                                       233196
 
      **  PB Default PTFR for New PB Customer Audit Report.
     FPB1030AU  O    E             Printer Infds(SpoolU)
     F                                     Infsr(*Pssr)
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * xx   xx   xx   xx   xx   xx   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * xx   xx   xx   xx   75   76   77   78   79   80 *     *
      *       * 81   82   83   84   85   86   87   88   89   90 *     *
      *       * xx   xx   xx   xx   xx   xx   xx   xx   xx      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  *Pssr   - Program exception error routine                    *
      *  *inzsr  - Program Initialization routine.                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      /Eject
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  External Data structure for Local data area (database error details).
     D LDA           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  File Information Data Structure for printer file PB1030AU.
     D Spoolu          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0
     D    DBFields           134    203
 
      **  External Data structure for Portfolio Management I.C.D. Details.
     D PMSTAT        E DS           256    Extname(PMSTAT) Dtaara(PMSTAT)
 
      **  Table for PF/DEALSDC deal types.
     D TABDealTypes    S              2    Dim(9) Ctdata Perrcd(9)
 
      **  Array containing power for currency conversion.
     D POWER8          S              8  4 Dim(8) Ctdata Perrcd(1)
 
      **  Array used to store all Portfolio Definition References
      **  for Customer.
     D POR             S              4    Dim(50)
 
      **  External data structure for Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      **  External data structure for Securities Clients Details.
     D Sdsecs        E DS                  Extname(SDSECSPD)
 
      **  External data structure for Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)
                                                                                CPB004
      **  External data structure for Account Code Details.                     CPB004
     D Sdacod        E DS                  Extname(SDACODPD)                    CPB004
      ** External DS for Customer Details                                                     CAS010
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CAS010
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  External data structure for Portfolio I.C.D. Details.
     D Sdport        E DS                  Extname(SDPORTPD)
 
      **  External data structure for Midas Modules Details.
     D Sdmmod        E DS                  Extname(SDMMODPD)
 
      **  External data structure for Securities Trading Details.
     D Sdstrd        E DS                  Extname(SDSTRDPD)
 
      **  External data structure for Switchable Features Details.
     D Scsard        E DS                  Extname(SCSARDPD)
 
      **  External data structure for Investment Type Details.
     D Invtpd        E DS                  Extname(INVTPD)
     D   INLCD       E                     Extfld(LCD)
     D   DEFPRG      E                     Extfld(PLDPCD)
 
      **  First DS for access programs, short data structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second DS for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ------------------- Start of parameters --------------------**
      **  Return Code.
     D P_ReturnCode    S             10A
      **  Customer Number.
     D P_CustNum       S              6A
      **  Portfolio Definition Reference.
     D P_PortDefn      S              4A
      ** Portfolio Currency Code.                                               CPB002
     D P_PortCcy       S              3A                                        CPB002
      ** Portfolio Currency Decimal Places.                                     CPB002
     D P_PortCdp       S              1  0                                      CPB002
      ** -------------------- End of parameters ---------------------**
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Switchable Feature Reference.
     D P_Sard          S              6A
      **  Currency.
     D P_Curr          S              3A
      **  Customer.
     D P_Cust          S             10A
      **  Key Status.
     D P_Kyst          S              7A
      **  Investment Type.
     D P_Invt          S              3A
      **  Account Code.                                                         CPB004
     D*P_Acod**********S              4A                                               CPB004 CAS011
     D P_Acod          S             10A                                                      CAS011
      ** ---------- End of fields used by access programs -----------**
 
      **  Define work fields used as keys.
     D K_CustNum       S                   Like(CNUM)                           Customer Number
     D K_TradeRef      S                   Like(TDRF)                           Trade Reference
     D K_DepotRef      S                   Like(DPRN)                           Depot Reference
     D K_CurrCode      S                   Like(CCY)                            Currency Code
     D*K_PayDate*******S                   Like(Q8SDAT)                         Payment Date  208648
     D K_PayDate       S                   Like(G2HIDT)                         Payment Date  208648
     D K_BranchCode    S                   Like(CDPA)                           Branch Code
     D K_Security      S                   Like(SDSN)                           Security Shortname
     D K_PortRef       S                   Like(PTFR)                           Portfolio Reference
     D K_PosDate       S                   Like(DDTE)                           Position Date
     D K_EventType     S                   Like(SNET)                           Event Type
     D K_EventDate     S                   Like(SNDT)                           Event Date
 
      **  Define work fields used to store values.
     D W_CSBA          S                   Like(CSBA)                           Branch Code
     D W_CSDA          S                   Like(CSDA)                           Position Date
     D W_DATG          S                   Like(CSDA)                           Greatest Posit. Date
     D W_CSNT          S                   Like(CSNT)                           Trade Date Nominal
     D W_CSNV          S                   Like(CSNV)                           Value Date Nominal
     D W_CSNS          S                   Like(CSNS)                           Settle Date Nominal
     D W_CSEX          S                   Like(CSEX)                           Ex-coupon Nominal
     D W_CSPT          S                   Like(CSPT)                           Trade Date AP Numer.
     D W_CSPV          S                   Like(CSPV)                           Value Date AP Numer.
     D W_DBAse         S                   Like(DBASE)                          Database Error Num.
     D*W_SPOT**********S                   Like(Q8SPOT)                         Spot Rate     208648
     D W_SPOT          S                   Like(G2SPRT)                         Spot Rate     208648
     D*W_MDIN**********S                   Like(Q8MDV1)                         Mutl/Div Indic208648
     D W_MDIN          S                   Like(G2MDIN)                         Mutl/Div Indic208648
     D W_CDP           S                   Like(A6NBDP)                         Decimal Places208648
     D W_VDNA          S                   Like(CSDA)                           Back Value Date
 
      **  Define work fields used to calculate totals.
     D W_TSNT          S                   Like(CSNT)                           Total Trade Date Nom
     D W_TSNV          S                   Like(CSNV)                           Total Value Date Nom
     D W_TSEX          S                   Like(CSEX)                           Total Ex-coupon Nom
     D W_TSPT          S                   Like(CSPT)                           Tot Trad Date AP Num
     D W_TSPV          S                   Like(CSPV)                           Tot Val. Date AP Num
     D W_RCIN          S              5  0                                      Nbr Inserted records
     D W_RCDL          S              5  0                                      Nbr Deleted records
     D W_DELT          S              5  0                                      Nbr Del. Cust. Pos.
     D W_WRIT          S              5  0                                      Nbr Add. Cust. Pos.
     D W_CCTL          S             15  0
     D W_CCCT          S             15  0
     D W_CCTLSC        S             15  0
     D W_CCCTSC        S             15  0
     D W_CTVLSC        S             15  0
     D W_ERNSC         S             15  8
     D W_ITRASC        S             15  0
     D W_SETAM         S             15  0
 
      **  Work fields used as flags.
     D W_PMFlag        S              1A
     D W_TradeFound    S              1A
     D W_RunBefore     S              1A
     D CGL031          S              1A                                                      233196
     D W_Set_Repi      S              1A                                        CPB004
                                                                                CPB004
      **  Work Field used to change value of field ACCNTAB/REPI.                CPB004
     D W_Repi          S              2  0                                      CPB004
 
      **  True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
     D SECTY0        E DS                  EXTNAME(SECTYD)                                    198688
     D   SERECI      E                     Extfld(RECI)                                       198688
     D   SEZZ005     E                     Extfld(ZZ005)                                      198688
     D   SELCD       E                     Extfld(LCD)                                        198688
     D   SECHTP      E                     Extfld(CHTP)                                       198688
     D   SETNLU      E                     Extfld(TNLU)                                       198688
     D   SENDEC      E                     Extfld(NDEC)                                       CAS010
     D   SEZONE1     E                     Extfld(SEZONE)                                     CAS010
 
      /Eject
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Rename Fields                        ¦
      ** ¦ =============                        ¦
      ** +--------------------------------------+
 
     I*SECTYDFF**                                                                             198688
     I**********    RECI                        SERECI                                        198688
     I**********                                                                              198688
     ITRADCUF
     I              RECI                        W_RECI
     I              ACIN                        W_ACIN
     I              ITRA                        W_ITRA
     I              CRSK                        ASCRSK                                        CAS006
     I*
     IHSTTTRF
     I              RECI                        W_RECI
     I              ACIN                        W_ACIN
     I              ITRA                        W_ITRA
     I              CRSK                        ASCRSK                                        CAS006
     I*
     ITRADSDF       08
     I              CRSK                        ASCRSK                                        CAS006
                                                                                              CAS006
     IHSTTRDF       09
     I              CRSK                        ASCRSK                                        CAS006
                                                                                              CAS006
     IDEALSDBF      01
     IDEALSDCF      02
     ICLOANCLF      06
     ICLOANCZF      07
     I*
     ICDEPPAF
     I              TNLU                        XXTNLU
     I*
      /Eject
      *****************************************************************
     C
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listing
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      *================================================================         224860
      **               Account Details file processing                *         224860
      *================================================================         224860
                                                                                224860
      **  Position to first account for customer.                               224860
     C     K_CustNum     Setll     ACCNT                                        224860
     C     K_CustNum     Reade     ACCNT                                  73    224860
                                                                                224860
      **  Do while accounts to be processed for customer.                       224860
     C     *in73         Doweq     False                                        224860
                                                                                224860
     C                   Eval      W_Set_Repi = 'N'                             224860
      **  If retail account and Portfolio Reference is blank.                   224860
     C     ATYP          Ifeq      'R'                                          224860
     C     PTFR          Andeq     *blanks                                      224860
     C                   Eval      PTFR = P_PortDefn                            224860
     C                   Eval      HLEX = *blanks                               224860
     C                   Eval      W_Set_Repi = 'Y'                             224860
     C                   EndIf                                                  224860
                                                                                224860
      **  CPB004 "Account Closing" is present                                   224860
     C     CPB004        Ifeq      'Y'                                          224860
                                                                                224860
      **  Access Account Code details                                           224860
     C                   Move      ACOD          P_Acod                         224860
     C                   CALL      'AOACODR0'                                   224860
     C                   PARM      *BLANKS       P_Rtcd                         224860
     C                   PARM      '*KEY   '     P_Optn                         224860
     C                   PARM                    P_Acod                         224860
     C     SDACOD        PARM      SDACOD        Dssdy                          224860
     C     P_Rtcd        IfEq      *Blanks                                      224860
                                                                                224860
      **  Must be transfert if it is a Retail Account                           224860
     C                   If        A5ACTY = 'R'                                 224860
     C                             Or A5ACTY = 'G'                              224860
     C                             And A5TRAN = 'Y'                             224860
     C                   Eval      W_Set_Repi = 'Y'                             224860
     C                   EndIf                                                  224860
     C                   EndIf                                                  224860
     C                   EndIf                                                  224860
                                                                                224860
     C     W_Set_Repi    Ifeq      'Y'                                          224860
                                                                                224860
      **  Update Replication Indicator field.                                   224860
     C                   Testn                   REPI                 77        224860
                                                                                224860
      **  If Replication Indicator is numeric.                                  224860
     C     *in77         Ifeq      True                                         224860
     C                   Move      REPI          W_Repi                         224860
     C                   Add       1             W_Repi                         224860
                                                                                224860
      **  If Replication Indicator is not numeric.                              224860
     C                   Else                                                   224860
     C                   Eval      W_Repi = 1                                   224860
                                                                                224860
     C                   Endif                                                  224860
     C                   Move      W_Repi        REPI                           224860
                                                                                224860
      **  Update Account record.                                                224860
     C                   EXCEPT    ACCNT_U                                      224860
                                                                                224860
     C                   Endif                                                  224860
                                                                                224860
      **  Read next account for customer.                                       224860
     C     K_CustNum     Reade     ACCNT                                  73    224860
                                                                                224860
     C                   Enddo                                                  224860
      *================================================================
      **              Deals by Customer File processing               *
      *================================================================
 
      **  Position to first deal for customer.
     C     K_CustNum     Setll     PMDEALL4
     C     K_CustNum     Reade     PMDEALL4                               73
 
      **  Do while Deals to be processed.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
     C     RECI          Ifne      '*'                                          Begin RECI
     C     RECI          Andne     'R'
 
      **  Initialize update indicator.
     C                   Eval      *in77 = False
 
      **  If record comes from PF/DEALSDB.
     C     RCDT          Ifeq      'B'                                          Begin FX Deal
     C                   Eval      *in77 = True
 
      **  If record comes from PF/DEALSDC, check deal type.
     C                   Else                                                   Else FX Deal
     C                   Z-ADD     1             X                 2 0
     C     DTYP          LOOKUP    TABDealTypes                           77
 
     C                   Endif                                                  End FX DEal
 
      **  For MM Deal, Determine cross rate nominal to Portfolio Currency.
     C     RCDT          Ifeq      'C'                                          Begin MM Deal
     C     *in77         Andeq     True
     C                   Eval      K_CurrCode = CCY
     C                   Eval      K_PayDate  = DDAT
 
     C                   Exsr      #PMRATE
 
     C**********         Eval      ZCCYF  = NMCY                                208648
     C                   Eval      ZCCYF  = CCY                                 208648
     C                   Eval      ZRATEF = W_SPOT
     C                   Eval      ZMDINF = W_MDIN
     C**********         Eval      ZCDPF  = Q8CDP                               208648
     C                   Eval      ZCDPF  = W_CDP                               208648
 
      **  Perform S/R #PMRATE for Customer Base Currency.
     C                   Eval      K_CurrCode = P_PortCcy
 
     C                   Exsr      #PMRATE
 
     C                   Eval      ZCCYT  = P_PortCcy
     C                   Eval      ZRATET = W_SPOT
     C                   Eval      ZMDINT = W_MDIN
     C                   Eval      ZCDPT  = P_PortCdp
 
      **  Get Cross FX Rate.
     C                   Exsr      #ZCCYCN
 
     C                   Eval      FXRD = ZCRSRT
 
     C                   Endif                                                  End MM Deal
 
      **  If update required.
     C     *in77         Ifeq      True                                         Begin *in77
 
      **   Define Key List used to access to FD Deal Type/Sub-type file.
     C     K_FDDtst      Klist
     C                   Kfld                    DTYP
     C                   Kfld                    DLST
 
      **  Access to Deal Type/Sub-type details.
     C     K_FDDtst      Chain     FDDTSTL0                           74
 
      **  If Type/Sub=type combination already exists.
     C     *in74         Ifeq      False                                        Begin *in74
 
      **  If record was deleted, change record id.
     C     RCID11        Ifeq      '*'                                          Begin RCID11
     C                   Eval      RCID11 = 'D'
     C                   Update    FDDTSTPD
 
     C                   Endif                                                  End RCID11
 
      **  If record was not found, create a new record.
     C                   Else                                                   Else *in74
     C                   Exsr      #FDDTST
 
     C                   Endif                                                  End *in74
 
      **  If Portfolio Definition is blank.
     C     PTFR          Ifeq      *blanks                                      Begin PTFR
     C                   Eval      PTFR = P_PortDefn
 
     C                   Endif                                                  End PTFR
 
     C                   Eval      HLEX = *blank
 
      **  Update appropriate record.
     C                   Select                                                 Begin Select
 
     C     RCDT          Wheneq    'B'                                          FX Deal
     C                   Except    DEALSB_U
 
      **  Access to FX Deal record.
     C     DLNO          Chain     FXDEALLL                           81
 
      **  If record was found and Portfolio Reference was blank.
     C     *IN81         Ifeq      False                                        Begin *in81
     C     FHPTFR        Andeq     *blanks
     C                   Eval      FHPTFR = P_PortDefn
     C                   Except    FXDEAL_U
 
     C                   Endif                                                  End *in81
 
     C     RCDT          Wheneq    'C'                                          MM Deal
     C     *in77         Andeq     True
     C                   Except    DEALSC_U
     C     DLNO          Chain     MMDELDP0                           02
 
      **  If record was found and Portfolio Definition is blank.
     C     *IN02         Ifeq      '0'
     C     HKPTFR        Andeq     *blanks
     C                   Eval      HKPTFR = P_PortDefn
 
     C                   Endif                                                  End *in02
     C                   Except    MMDELD_U
 
     C                   Endsl                                                  End Select
 
     C                   Endif                                                  End *in77
 
     C                   Endif                                                  End RECI
 
      **  Read following Deal record for customer.
     C     K_CustNum     Reade     PMDEALL4                               73
 
     C                   Enddo                                              End Do_W_N73
 
      *================================================================
      **              Trades by Customer file processing              *
      *================================================================
 
      **  Position to first SE Trade for customer.
     C     K_CustNum     Setll     TRADC
     C     K_CustNum     Reade     TRADC                                  73
 
      **  Do while Trades to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If live SE Trade and Portfolio Reference is blank.
     C     RECI          Ifne      '*'                                          Begin RECI
     C     RECI          Andne     'C'
     C     PTFR          Andeq     *blanks
     C                   Eval      PTFR = P_PortDefn
 
     C                   Endif                                                  End RECI
                                                                                              198387
      **  Access to Security Details.                                                         198387
     C                   Eval      K_Security = TDSS                                          198387
                                                                                **************198387
     C                   Eval      W_DBAse = 14                                 * Db Error 14 198387
                                                                                **************198387
     C                   Exsr      #SECDET                                                    198387
                                                                                              198387
      **  Access to Investment Type to get Processing Type.                                   198387
                                                                                **************198387
     C                   Eval      W_DBAse = 15                                 * Db Error 15 198387
                                                                                **************198387
     C                   Exsr      #INVTYP                                                    198387
 
      **  Calculate Trade Portfolio Value (more specifically, the FX rate).
 
     C                   Exsr      #P07
 
      **  Update appropriate record.
     C                   Select                                                 Begin Select
 
     C     *IN08         Wheneq    True                                         SE Trade
     C                   Except    TRADS_U
 
     C     *IN09         Wheneq    True                                         SE Historic Trade
     C                   Except    HSTTR_U
 
     C                   Endsl                                                  End Select
 
      **  Read next SE Trade for customer.
     C     K_CustNum     Reade     TRADC                                  73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **                Depot Movements file processing               *
      *================================================================
 
      **  Position to first Depot Movement for customer.
     C     K_CustNum     Setll     DEPMVC
     C     K_CustNum     Reade     DEPMVC                                 73
      *
      **  Do while Depot Movements to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If live Depot Movement.
     C     RECI          Ifne      '*'                                          Begin RECI
 
      **  If Walk In or Walk Out Depot Movement.
     C     DPMV          IFEQ      'WI'                                         Begin DPMV
     C     DPMV          OREQ      'WO'
 
      **  If Portfolio Reference is blank.
     C     PTFR          Ifeq      *blanks                                      Begin PTFR
     C                   Eval      PTFR = P_PortDefn
 
      **  Access to Security Details.
     C                   Eval      K_Security = DPSS
                                                                                ***************
     C                   Eval      W_DBAse = 12                                 * Db Error 12 *
                                                                                ***************
     C                   Exsr      #SECDET
 
      **  Access to Investment Type to get Processing Type.
                                                                                ***************
     C                   Eval      W_DBAse = 12                                 * Db Error 12 *
                                                                                ***************
     C                   Exsr      #INVTYP
 
      **  Set Movement Date                                                R10049
     C     DPMD          Ifeq      0                                            Begin DPMD
     C                   Eval      K_PayDate = DPDO
 
     C                   Else                                                   ELse DPMD
     C                   Eval      K_PayDate = DPMD
 
     C                   Endif                                                  End DPMD
 
     C                   Eval      ZAMTF = 1
 
      **  Perform S/R #PMRATE for Nominal Currency.
     C                   Eval      K_CurrCode = NMCY
 
     C                   Exsr      #PMRATE                                      Spot Rate
 
     C                   Eval      ZCCYF  = NMCY
     C                   Eval      ZRATEF = W_SPOT
     C                   Eval      ZMDINF = W_MDIN
     C*****              Eval      ZCDPF  = Q8CDP                               208648
     C                   Eval      ZCDPF  = W_CDP                               208648
 
      **  Perform S/R #PMRATE for Customer Base Currency.
     C                   Eval      K_CurrCode = P_PortCcy
 
     C                   Exsr      #PMRATE
 
     C                   Eval      ZCCYT  = P_PortCcy
     C                   Eval      ZRATET = W_SPOT
     C                   Eval      ZMDINT = W_MDIN
     C                   Eval      ZCDPT  = P_PortCdp
 
      **  Get Cross FX Rate.
     C                   Exsr      #ZCCYCN
 
     C                   Eval      SPXR = ZCRSRT
     C                   Eval      SPMD = ZCRSMD
     C                   Eval      CWDI = 'N'
     C                   Eval      CYLD = 0
 
      **  Calculate yield on Depot Movement.
     C     PROT          IFEQ      '1'                                          Begin PROT
     C     PROT          OREQ      '3'
     C     PROT          OREQ      '5'
     C     PROT          OREQ      '6'
     C     PROT          OREQ      '8'
     C     PROT          OREQ      '9'
     C*
     C     MATY          Ifne      0                                            Begin MATY
 
      **  If Security is Interest Bearing, use AIBD method, else Discoun.
 
     C     CD01          Ifne      0                                            Begin CD01
     C                   Eval      SYBS = 'A '
 
     C                   Else                                                   Else CD01
     C                   Eval      SYBS = 'DA'
 
     C                   Endif                                                  End CD01
 
     C     DYBS          Ifeq      '4'                                          Begin DYBS
     C                   Eval      DYBS = '3'
     C                   Eval      DVBS = '1'
 
     C                   Endif                                                  End DYBS
 
     C                   Eval      ZPRICE = MKTP
     C                   Eval      ZFDATE = DPVD
     C                   Eval      ECD    = ZFDATE
 
     C     SERECI        Ifeq      'D'                                          Begin SERECI
     C                   Exsr      #ZYLDO
 
     C                   Else                                                   Else SERECI
     C                   Eval      ZYLDOT = 0
 
     C                   Endif                                                  End SERECI
     C                   Eval      CYLD = ZYLDOT
 
     C                   Endif                                                  End MATY
 
     C                   Endif                                                  End PROT
 
      **  Update Depot Movement record.
     C                   Except    DPTMV_U
 
     C                   Endif                                                  End PTFR
 
     C                   Endif                                                  End DPMV
 
     C                   Endif                                                  End RECI
 
      **  Read next Depot Movement for customer.
     C     K_CustNum     Reade     DEPMVC                                 73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **               Financial Futures File processing              *
      *================================================================
 
      **  If Futures and Option Module is installed.
     C     BGFUOP        Ifeq      'Y'                                          Begin BGFUOP
 
      **  If Bank Portfolios are supported, treat as if FF off.
     C     FCPORS        ANDNE     'B'
 
      **  Position to first FF Transaction for customer.
     C     K_CustNum     Setll     TRANSC
     C     K_CustNum     Reade     TRANSC                                 73
 
      **  Do while FF transactions to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If live FF Transaction and Portfolio Reference is blank.
     C     RECI          Ifne      '*'                                          Begin RECI
     C     PTFR          Andeq     *blanks
     C                   Eval      PTFR = P_PortDefn
 
      **  Update FF Transaction record.
     C                   Except    TRANS_U
 
     C                   Endif                                                  End RECI
 
      **  Read next FF Transaction for customer.
     C     K_CustNum     Reade     TRANSC                                 73
 
     C                   Enddo                                                  End Do_W_N73
 
     C                   Endif                                                  End BGFUOP
 
      *================================================================
      **                Customer Loans file processing                *
      *================================================================
 
      **  Position to first loan for customer
     C     K_CustNum     Setll     PMCLONL6
     C     K_CUstNum     Reade     PMCLONL6                               73
 
      **  Do while Loans to be processed for customer.
     C     *IN73         Doweq     False                                        Begin Do_W_N73
 
      **  If live loan.
     C     RECI          Ifeq      'D'                                          Begin RECI
 
      **  If valid loan processing type.
     C     PTYP          Ifeq      61                                           Begin PTYP
     C     PTYP          Oreq      62
     C     PTYP          Oreq      63
     C     PTYP          Oreq      70
     C     PTYP          Oreq      80                                                         CLE028
 
      **  If Portfolio Reference is blank.
     C     PTFR          Ifeq      *blanks                                      Begin PTFR
     C                   Eval      PTFR = P_PortDefn
     C                   Eval      HLEX = *blanks
 
      **  Update Loan record.
     C                   Except    CLOAN_U
 
     C                   Endif                                                  End PTYP
 
     C                   Endif                                                  End RECI
 
     C                   Endif                                                  End PTFR
 
      **  Read next loan for customer.
     C     K_CustNum     Reade     PMCLONL6                               73
 
     C                   Enddo                                                  End Do_W_N73
 
      **  Position to first matured loan for customer.
     C     K_CustNum     Setll     PMCLONL0
     C     K_CustNum     Reade     PMCLONL0                               73
 
      **  Do while matured loans to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If valid loan processing type.
     C     PTYP          Ifeq      61                                           Begin PTYP
     C     PTYP          Oreq      62
     C     PTYP          Oreq      63
     C     PTYP          Oreq      70
     C     PTYP          Oreq      80                                                         CLE028
 
      **  If Portfolio Reference is blank.
     C     PTFR          Ifeq      *blanks                                      Begin PTFR
 
     C                   Eval      PTFR = P_PortDefn
     C                   Eval      HLEX = *blanks
 
      **  Update appropriate record.
     C                   Select                                                 Begin Select
 
     C     *in06         Wheneq    True                                         Loans
     C                   Except    CLOANP_U
 
     C     *in07         Wheneq    True                                         Matured loans
     C                   Except    CLOANZ_U
 
     C                   Endsl                                                  End Select
 
     C                   Endif                                                  End PTFR
 
     C                   Endif                                                  End PTYP
 
      **  Read next loan for customer.
     C     K_CustNum     Reade     PMCLONL0                               73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **               Account Details file processing                *
      *================================================================
      ***                                                                                     224860
      *** Position to first account for customer.                                             224860
     C***  K_CustNum     Setll     ACCNT                                                      224860
     C***  K_CustNum     Reade     ACCNT                                  73                  224860
      ***                                                                                     224860
      *** Do while accounts to be processed for customer.                                     224860
     C***  *in73         Doweq     False                                                      224860
      ***                                                                                     224860
     C***                Eval      W_Set_Repi = 'N'                                     CPB004224860
      *** If retail account and Portfolio Reference is blank.                                 224860
     C***  ATYP          Ifeq      'R'                                                        224860
     C***  PTFR          Andeq     *blanks                                                    224860
     C***                Eval      PTFR = P_PortDefn                                          224860
     C***                Eval      HLEX = *blanks                                             224860
     C***                Eval      W_Set_Repi = 'Y'                                     CPB004224860
     C***                EndIf                                                          CPB004224860
      ***                                                                               CPB004224860
      *** CPB004 "Account Closing" is present                                           CPB004224860
     C***  CPB004        Ifeq      'Y'                                                  CPB004224860
      ***                                                                               CPB004224860
      *** Access Account Code details                                                   CPB004224860
     C***                Move      ACOD          P_Acod                                 CPB004224860
     C***                CALL      'AOACODR0'                                           CPB004224860
     C***                PARM      *BLANKS       P_Rtcd                                 CPB004224860
     C***                PARM      '*KEY   '     P_Optn                                 CPB004224860
     C***                PARM                    P_Acod                                 CPB004224860
     C***  SDACOD        PARM      SDACOD        Dssdy                                  CPB004224860
     C***  P_Rtcd        IfEq      *Blanks                                              CPB004224860
      ***                                                                               CPB004224860
      *** Must be transfert if it is a Retail Account                                   CPB004224860
     C***                If        A5ACTY = 'R'                                         CPB004224860
     C***                          Or A5ACTY = 'G'                                      CPB004224860
     C***                          And A5TRAN = 'Y'                                     CPB004224860
     C***                Eval      W_Set_Repi = 'Y'                                     CPB004224860
     C***                EndIf                                                          CPB004224860
     C***                EndIf                                                          CPB004224860
     C***                EndIf                                                          CPB004224860
      ***                                                                               CPB004224860
     C***  W_Set_Repi    Ifeq      'Y'                                                  CPB004224860
      ***                                                                               CPB004224860
      *** Update Replication Indicator field.                                           CPB004224860
     C***                Testn                   REPI                 77                CPB004224860
      ***                                                                               CPB004224860
      *** If Replication Indicator is numeric.                                          CPB004224860
     C***  *in77         Ifeq      True                                                 CPB004224860
     C***                Move      REPI          W_Repi                                 CPB004224860
     C***                Add       1             W_Repi                                 CPB004224860
      ***                                                                               CPB004224860
      *** If Replication Indicator is not numeric.                                      CPB004224860
     C***                Else                                                           CPB004224860
     C***                Eval      W_Repi = 1                                           CPB004224860
      ***                                                                               CPB004224860
     C***                Endif                                                          CPB004224860
     C***                Move      W_Repi        REPI                                   CPB004224860
      ***                                                                                     224860
      *** Update Account record.                                                              224860
     C***                EXCEPT    ACCNT_U                                                    224860
      ***                                                                                     224860
     C***                Endif                                                                224860
      ***                                                                                     224860
      *** Read next account for customer.                                                     224860
     C***  K_CustNum     Reade     ACCNT                                  73                  224860
      ***                                                                                     224860
     C***                Enddo                                                                224860
 
      *================================================================
      **            Customer Average Prices file processing           *
      *================================================================
 
      **  Position to first Historic Customer Average Price for customer.
     C     K_CustNum     Setll     CAPRH
     C     K_CustNum     Reade     CAPRH                                  73
 
      **  Do while average prices to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
     C     RECI          Ifne      '*'                                          Begin RECI
     C     RECI          Andne     'C'
     C                   Exsr      #P04
 
     C                   Endif                                                  End RECI
 
      **  Read next average price for customer.
     C     K_CustNum     Reade     CAPRH                                  73
 
     C                   Enddo                                                  End Do_W_N73
 
      *---------------------------------------------------------------*
      **  Perform following only if Jyske Enhancements feature        *
      **  is installed.                                               *
      *                                                               *
     C     S01496        Ifeq      'Y'                                          Begin S01496
 
      *================================================================
      **         Customer Depot Positions by Date processing          *
      *================================================================
 
      **  Position to first Depot Position for customer.
     C     K_CustNum     Setll     CDEPD
     C     K_CustNum     Reade     CDEPD                                  73
 
      **  Do while Depot Positions to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     PTFR          Ifeq      *blanks                                      Begin PTFR
     C                   Eval      PTFR = P_PortDefn
     C                   Except    CDEP_U
 
     C                   Endif                                                  End PTFR
 
      **  Read next Depot Position for customer.
     C     K_CustNum     Reade     CDEPD                                  73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **  Allocations by customer and portfolio reference processing  *
      *================================================================
 
      **  Position to first Allocation for customer.
     C     K_CustNum     Setll     SEERALL3
     C     K_CustNum     Reade     SEERALL3                               73
 
      **  Do while Allocations to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     VCPTFR        Ifeq      *blanks                                      Begin VCPTFR
     C                   Eval      VCPTFR = P_PortDefn
 
      **  Update Allocation record.
     C                   Except    SEERAL_U
 
     C                   Endif                                                  End VCPTFR
 
      **  Read next Depot Position for customer.
     C     K_CustNum     Reade     SEERALL3                               73
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **   General Blocks by Customer processing
      *================================================================
 
      **  Position to first General Block for customer.
     C     K_CustNum     Setll     SEBLKPL4
     C     K_CustNum     Reade     SEBLKPL4                               73
 
      **  Do while General Blocks to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     VDPTFR        Ifeq      *blanks                                      Begin VDPTFR
     C                   Eval      VDPTFR = P_PortDefn
 
      **  Update General Block record.
     C                   Except    SEBLKP_U
 
     C                   Endif                                                  End VDPTFR
 
      **  Read next General Block for customer.
     C     K_CustNum     Reade     SEBLKPL4                               73
 
     C                   Enddo                                                  End Do_W_N73
 
     C                   Endif                                                  End S01496
      *                                                               *
      **  End of S01496 = 'Y'                                         *
      *---------------------------------------------------------------*
 
                                                                                199015
      *---------------------------------------------------------------*         199015
      **  Perform following only if Corporate Actions feature         *         199015
      **  is installed.                                               *         199015
      *                                                               *         199015
     C     CSE007        Ifeq      'Y'                                          199015
      *================================================================
      **  Corporate Actions Allocations processing                    *
      *================================================================
 
      **  Position to first Corporate Actions Allocation for customer.
     C     K_CustNum     Setll     SECOAL11
     C     K_CustNum     Reade     SECOAL11                               73
 
      **  Do while Allocations to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     MCPTFR        Ifeq      *blanks                                      Begin MCPTFR
     C                   Eval      MCPTFR = P_PortDefn
 
      **  Update Allocation record.
     C                   Except    SECOAL_U
 
     C                   Endif                                                  End MCPTFR
 
      **  Read next Corporate Actions Allocation for customer
     C     K_CustNum     Reade     SECOAL11                               73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **  Corporate Actions Affected Positions processing             *
      *================================================================
 
      **  Position to first Corporate Actions Affected Position for customer.
     C     K_CustNum     Setll     SECOAPL1
     C     K_CustNum     Reade     SECOAPL1                               73
 
      **  Do while Affected Positions to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     MXPTFR        Ifeq      *blanks                                      Begin MXPTFR
     C                   Eval      MXPTFR = P_PortDefn
 
      **  Update Corporate Actions Affected Positions record.
     C                   Except    SECOAP_U
 
     C                   Endif                                                  End MXPTFR
 
      **  Read next Corporate Actions Affected Position for customer.
     C     K_CustNum     Reade     SECOAPL1                               73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **  Corporate Actions Blocked Positions processing              *
      *================================================================
 
      **  Position to first Corporate Actions Blocked Position for customer.
     C     K_CustNum     Setll     SECOBKL3
     C     K_CustNum     Reade     SECOBKL3                               73
 
      **  Do while Blocked Positions to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     MUPTFR        Ifeq      *blanks                                      Begin MCPTFR
     C                   Eval      MUPTFR = P_PortDefn
 
      **  Update Corporate Actions Blocked Position record.
     C                   Except    SECOBK_U
 
     C                   Endif                                                  End MCPTFR
 
      **  Read next Corporate Actions Blocked Position for customer
     C     K_CustNum     Reade     SECOBKL3                               73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **  Corporate Actions Correspondance Details processing         *
      *================================================================
 
      **  Position to first Corporate Actions Correspondance Detail for customer.
     C     K_CustNum     Setll     SECOCOL1
     C     K_CustNum     Reade     SECOCOL1                               73
 
      **  Do while Correspondance Details to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     MVPTFR        Ifeq      *blanks                                      Begin MVPTFR
     C                   Eval      MVPTFR = P_PortDefn
 
      **  Update Corporate Actions Correspondance Details record.
     C                   Except    SECOCO_U
 
     C                   Endif                                                  End MVPTFR
 
      **  Read next Corporate Actions Correspondance Details for customer
     C     K_CustNum     Reade     SECOCOL1                               73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **  Corporate Actions Instructions processing                   *
      *================================================================
 
      **  Position to first Corporate Actions Instruction for customer.
     C     K_CustNum     Setll     SECOSIL3
     C     K_CustNum     Reade     SECOSIL3                               73
 
      **  Do while Instructions to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     MOPTFR        Ifeq      *blanks                                      Begin MOPTFR
     C                   Eval      MOPTFR = P_PortDefn
 
      **  Update Corporate Actions Instructions record.
     C                   Except    SECOSI_U
 
     C                   Endif                                                  End MOPTFR
 
      **  Read next Corporate Actions Instruction for customer
     C     K_CustNum     Reade     SECOSIL3                               73
 
     C                   Enddo                                                  End Do_W_N73
                                                                                199015
     C                   Endif                                                  199015
      *                                                               *         199015
      **  End of CSE007 = 'Y'                                         *         199015
      *---------------------------------------------------------------*         199015
 
      *================================================================
      **  Customer Position Profit Centre processing                  *
      *================================================================
 
      **  Position to first Customer Position Profit Centre.
     C     K_CustNum     Setll     SEPPCL0
     C     K_CustNum     Reade     SEPPCL0                                73
 
      **  Do while Position Profit Centre to be processed for customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73
 
      **  If Portfolio Reference is blank.
     C     PTFR          Ifeq      *blanks                                      Begin PTFR
     C                   Eval      PTFR = P_PortDefn
 
      **  Update Customer Position Profit Centre record.
     C                   Except    SEPCC_U
 
     C                   Endif                                                  End PTFR
 
      **  Read next Position Profit Centre for customer.
     C     K_CustNum     Reade     SEPPCL0                                73
 
     C                   Enddo                                                  End Do_W_N73
 
      *================================================================
      **              Customer Positions file processing              *
      *================================================================
 
      **  Calculate starting position.
     C                   Exsr      #STRPOS
 
      **   Access portfolio positions trailer
     C                   Read      PMCPOSPA                               72
 
     C     *in72         Ifeq      True                                         Begin *in72
     C     *lock         In        Lda
     C                   Eval      Dbfile = 'PMPOSPA'                           ***************
     C                   Eval      Dbase  = 04                                  * Db Error 01 *
     C                   Eval      DBKey = '*FIRST'                             ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  *in72
 
      **  Calculate number of positions.
     C                   Add       W_WRIT        QANORE
     C                   Sub       W_DELT        QANORE
 
     C                   Update    PMCPOSZ0
                                                                                              233196
      ** Taxation of Savings Income Processing                                                233196
                                                                                              233196
     C                   IF        CGL031 = 'Y'                                               233196
                                                                                              233196
     C     P_CustNum     CHAIN     SDACUSL0                                                   233196
     C                   IF        %Found(SDACUSL0)                                           233196
                                                                                              233196
     C                   IF        E5REPI = *Blank                                            233196
     C                   EVAL      E5REPI = 'Y'                                               233196
     C                   ELSE                                                                 233196
     C                   EVAL      E5REPI = *Blank                                            233196
     C                   ENDIF                                                                233196
     C                   UPDATE    @ACUSL0                                                    233196
                                                                                              233196
     C     P_CustNum     SETLL     SDACTXL4                                                   233196
     C     P_CustNum     READE     SDACTXL4                                                   233196
                                                                                              233196
     C                   DOW       Not %EOF(SDACTXL4)                                         233196
                                                                                              233196
     C                   IF        AXREPI = *Blank                                            233196
     C                   EVAL      AXREPI = 'Y'                                               233196
     C                   ELSE                                                                 233196
     C                   EVAL      AXREPI = *Blank                                            233196
     C                   ENDIF                                                                233196
     C                   UPDATE    SDACTXD0                                                   233196
                                                                                              233196
     C     P_CustNum     READE     SDACTXL4                                                   233196
     C                   ENDDO                                                                233196
                                                                                              233196
     C                   ENDIF                                                                233196
     C                   ENDIF                                                                233196
                                                                                224860
      *================================================================         224860
      **               Account Details file processing                *         224860
      *================================================================         224860
                                                                                224860
      **  Position to first account for customer.                               224860
     C     K_CustNum     Setll     ACCNT                                        224860
     C     K_CustNum     Reade     ACCNT                                  73    224860
                                                                                224860
      **  Do while accounts to be processed for customer.                       224860
     C     *in73         Doweq     False                                        224860
                                                                                224860
      **  Update Replication Indicator field.                                   224860
     C                   Testn                   REPI                 77        224860
                                                                                224860
      **  If Replication Indicator is numeric.                                  224860
     C     *in77         Ifeq      True                                         224860
     C                   Move      REPI          W_Repi                         224860
     C                   Add       1             W_Repi                         224860
     C                   Move      W_Repi        REPI                           224860
                                                                                224860
      **  Update Account record.                                                224860
     C                   EXCEPT    ACCNT_U2                                     224860
     C                   Endif                                                  224860
                                                                                224860
      **  Read next account for customer.                                       224860
     C     K_CustNum     Reade     ACCNT                                  73    224860
                                                                                224860
     C                   Enddo                                                  224860
 
      **  Output Audit Report.
     C                   Exsr      #Audit
 
      **  Exit from program.
     C                   Eval      *inlr = True
     C                   Return
 
      /Eject
      *****************************************************************
      /Title SR/#STRPOS
      *****************************************************************
      *                                                               *
      *  #STRPOS - calculate historic positions on PF/PMCPOSPD.       *
      *                                                               *
      *  Called By: #P01                                              *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     #STRPOS       Begsr                                                  ** #STRPOS SR **
 
     C                   Eval      W_TSNT = 0
     C                   Eval      W_TSNV = 0
     C                   Eval      W_TSEX = 0
     C                   Eval      W_TSPT = 0
     C                   Eval      W_TSPV = 0
 
     C                   Eval      W_CSBA = *blanks
     C                   Eval      W_CSDA = 0
     C                   Eval      W_PMFlag = 'N'
 
      **  Position to first Position for customer.
     C     K_CustNum     Setll     PMCPSNL0
     C     K_CustNum     Reade     PMCPSNL0                               73
 
      **  Do while Positions to be processed for Customer.
     C     *in73         Doweq     False                                        Begin Do_W_N73_1
                                                                                ***************
      **  Access to Security Details.
 
     C                   Eval      K_Security = CSSC
                                                                                ***************
     C                   Eval      W_DBAse = 13                                 * Db Error 13 *
                                                                                ***************
     C                   Exsr      #SECDET
 
      **  Access to Investment Type Details.
                                                                                ***************
     C                   Eval      W_DBAse = 13                                 * Db Error 13 *
                                                                                ***************
     C                   Exsr      #INVTYP
 
      **  Do while Positions to be processed for Customer and Security.
     C     *in73         Doweq     False                                        Begin Do_W_N73_2
 
      **  If branch has changed or Position Date is greater than
      **  Backvalue Date.
     C     CSBA          Ifne      W_CSBA                                       Begin CSBA
     C     CSDA          Orgt      W_VDNA
 
      **  If processing flag is on.
     C     W_PMFlag      Ifeq      'Y'                                          Begin W_PMFlag
 
      **  Calculate totals and reset flag and fields.
     C                   Exsr      #TOTPOS
 
     C                   Eval      W_PMFlag = 'N'
     C                   Eval      W_CSBA = *blanks
     C                   Eval      W_CSDA = 0
     C                   Eval      W_CSNT = 0
     C                   Eval      W_CSNV = 0
     C                   Eval      W_CSNS = 0
     C                   Eval      W_CSEX = 0
     C                   Eval      W_CSPT = 0
     C                   Eval      W_CSPV = 0
 
     C                   End                                                    End W_PMFlag
 
     C                   End                                                    End CSBA
 
      **  If Position Date is less than Back value Date, seton flag and
      **  save detail fields.
     C     CSDA          Ifle      W_VDNA                                       Begin CSDA
     C                   Eval      W_PMFlag = 'Y'
     C                   Eval      W_CSBA = CSBA
     C                   Eval      W_CSDA = CSDA
     C                   Eval      W_CSNT = CSNT
     C                   Eval      W_CSNV = CSNV
     C                   Eval      W_CSNS = CSNS
     C                   Eval      W_CSEX = CSEX
     C                   Eval      W_CSPT = CSPT
     C                   Eval      W_CSPV = CSPV
 
     C                   Endif                                                  End CSDA
 
      **  Read next Position details for Customer and Security.
     C     K_CustNum     Reade     PMCPSNL0                               73
 
     C                   End                                                    End Do_W_N73_2
 
      **  If processing flag is on.
     C     W_PMFlag      Ifeq      'Y'                                          Begin W_PMFlag
 
      **  Calculate totals and reset flag and fields.
     C                   Exsr      #TOTPOS
 
     C                   Eval      W_PMFlag = 'N'
     C                   Eval      W_CSBA = *blanks
     C                   Eval      W_CSDA = 0
     C                   Eval      W_CSNT = 0
     C                   Eval      W_CSNV = 0
     C                   Eval      W_CSNS = 0
     C                   Eval      W_CSEX = 0
     C                   Eval      W_CSPT = 0
     C                   Eval      W_CSPV = 0
 
     C                   End                                                    End W_PMFlag
 
      **  Calculate details for output to PF/PMCPOSPD.
     C                   Exsr      #P06
 
      **  Read next Position details for Customer.
     C     K_CustNum     Reade     PMCPSNL0                               73
 
     C                   Enddo                                                  End Do_W_N73_1
     C*
     C                   Endsr                                                  ** #STRPOS SR **
      /Eject
      *****************************************************************
      /Title SR/#SECDET
      *****************************************************************
      *                                                               *
      *  #SECDET - Subroutine to access to Security Details.          *
      *                                                               *
      *  Called By: #P01                                              *
      *             #P03                                              *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #SECDET       Begsr                                                  ** #SECDET SR **
 
     C     K_Security    Chain     SECTY                              74
 
      **  If Security Details were not found, handel database error.
     C     *in74         Ifeq      True                                         Begin *in74
     C     *lock         In        Lda
     C                   Eval      DBFile = 'SECTY   '
     C                   Eval      DBKey  = K_Security
     C                   Eval      DBAse  = W_DBase
     C                   Out       Lda
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End *in74
 
     C                   Endsr                                                  ** #SECDET SR **
      /Eject
      *****************************************************************
      /Title SR/#P04
      *****************************************************************
      *                                                               *
      *  #P04    - update historic customer actions on PF/CAPRHD      *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: #P07 - to calculate Trade Portfolio Value         *   *
      *         #P08 - to calculate Depot Movement Portfolio Value*   *
      *****************************************************************
 
     C     #P04          Begsr                                                  ** #P04 SR **
 
      **  For settlement action or price change, set up new PM fields
      **  to blank or zero and update file.
     C     CSSE          Ifeq      '0'                                          Begin CSSE
     C     CSSE          Oreq      '4'
     C                   Eval      PMTI = '*'
     C                   Eval      PMVI = '*'
     C                   Eval      PTFR = *blanks
     C                   Eval      ACIN = *blanks
     C                   Eval      ITRA = 0
     C                   Eval      CFAP = 0
     C                   Eval      CAVR = 0
     C                   Eval      CFXR = 0
     C                   Eval      CYLD = 0
     C                   Eval      OTHD = 0
 
     C                   Except    CAPRH_U
 
     C                   Endif                                                  End CSSE
 
      **  Process trade action or depot movement.
     C     CSSE          Ifeq      '1'                                          Begin CSSE
     C     CSSE          Oreq      '3'
 
      **  Access to Security Details to get Nominal Currency.
     C                   Eval      K_Security = CSSC
                                                                                ***************
     C                   Eval      W_DBAse = 13                                 * Db Error 13 *
                                                                                ***************
     C                   Exsr      #SECDET
 
      **  Access to Investment Type Details to get Processing Type.
                                                                                ***************
     C                   Eval      W_DBAse = 13                                 * Db Error 13 *
                                                                                ***************
     C                   Exsr      #INVTYP
 
      **  Access to Currency Details to get number of decimal places.
                                                                                ***************
     C                   Eval      W_DBAse = 12                                 * Db Error 12 *
                                                                                ***************
     C                   Eval      P_Curr = NMCY                                208648
      *                                                                         208648
     C                   Exsr      #CCYDET
 
      **---------*
      **  Trade  *
      **---------*
 
     C     CSSE          Ifeq      '1'                                          Begin Trade
     C                   Eval      W_TradeFound = 'Y'
     C                   Eval      K_TradeRef = CSRF
 
      **  Define Key List to access to SE Trade Details.
     C     K_TradCust    Klist
     C                   Kfld                    K_CustNum
     C                   Kfld                    K_TradeRef
 
      **  Access to SE Trade Details for Customer.
     C     K_TradCust    Chain     TRADCU                             74
 
      **  If SE Trade was not found.
     C     *in74         Ifeq      True                                         Begin *in74
 
      **  Access to SE Historic Trade Details.
     C     CSRF          Chain     HSTTTR                             74
 
      **  If SE Trade was not found, set up flag.
     C     *IN74         Ifeq      True                                         Begin *in74_2
     C                   Eval      W_TradeFound = 'N'
 
     C                   Endif                                                  End *in74_2
 
     C                   Endif                                                  End *in74
 
      **  Calculate Trade Portfolio value.
     C     W_TradeFound  Ifeq      'Y'                                          Begin W_TradeFound
     C                   Eval      ITRA = W_ITRA
     C                   Exsr      #P07
 
     C                   Endif                                                  End W_TradeFound
 
     C                   Endif                                                  End Trade
 
      **------------------*
      **  Depot Movement  *
      **------------------*
 
     C     CSSE          Ifeq      '3'                                          Begin Depot Movement
 
      **  Calculate Depot Movement Portfolio value.
     C                   Exsr      #P08
 
     C                   Endif                                                  End Depot Movement
 
      **  If closed or deleted SE Trade, bypass processing.
     C     CSSE          Ifeq      '1'                                          Begin Bypass
     C     W_RECI        Andeq     'C'
     C     CSSE          Oreq      '1'
     C     W_RECI        Andeq     '*'
     C                   Goto      @EndP04
 
     C                   Endif                                                  End Bypass
 
      **  If Trade was found.
     C     W_TradeFound  Ifeq      'Y'                                          Begin W_TradeFound
 
      **  Update PF/CAPRHD.
     C                   Exsr      #CAPRHD
 
     C                   Endif                                                  End W_TradeFound
 
     C                   Endif                                                  End CSSE
 
     C     @EndP04       Tag
 
     C                   Endsr                                                  ** #P04 SR **
 
      /Eject
      *****************************************************************
      /Title SR/#INVTYP
      *****************************************************************
      *                                                               *
      *  #INVTYP - Subroutine to access to Investment Types Details.  *
      *                                                               *
      *  Called By: #P03                                              *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #INVTYP       Begsr                                                  **#INVTYP SR **
 
     C                   Call      'AOINVTR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY  '      P_Optn
     C                   Parm      SITP          P_Invt
     C                   Parm      NMCY          P_Curr
     C     Invtpd        Parm      Invtpd        Dsfdy
 
      **  If Investment Type Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbfile = 'INVTPD'                            ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C     P_Curr        Cat       P_Invt:1      DBKey                          ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   Endsr                                                  ** #INVTYP SR **
      /Eject
      *****************************************************************
      /Title SR/#TOTPOS
      *****************************************************************
      *                                                               *
      *  #TOTPOS - Subroutine to maintain running total of positions  *
      *            in Security.                                       *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #TOTPOS       Begsr                                                  ** #TOTPOS SR **
 
      **  Total Trade Date Nominal.
     C                   Eval      W_TSNT = W_TSNT + W_CSNT
 
      **  Total Value Date Nominal.
     C                   Eval      W_TSNV = W_TSNV + W_CSNV
 
      **  Total Ex-coupon Nominal.
     C                   Eval      W_TSEX = W_TSEX + W_CSEX
 
      **  Total Trade Date AP Numerator.
     C                   Eval      W_TSPT = W_TSPT + W_CSPT
 
      **  Total Value Date AP Numerator.
     C                   Eval      W_TSPV = W_TSPV + W_CSPV
 
     C     W_CSDA        Ifgt      W_DATG                                       Begin W_CSDA
     C                   Eval      W_DATG = W_CSDA
 
     C                   Endif                                                  End W_CSDA
 
     C                   Endsr                                                  ** #TOTPOS SR **
1734
      /Eject
      *****************************************************************
      /Title SR/#P06
      *****************************************************************
      *                                                               *
      *  #P06    - Subroutine to update PF/PMCPOSPD.                  *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #P06          Begsr                                                  ** #P06 SR **
 
      **  If Trade Date Nominal is different from 0, write Trade Date Position.
     C     W_TSNT        Ifne      0                                            Begin W_TSNT
     C                   Eval      W_WRIT = W_WRIT + 1
     C                   Exsr      #TRDTPO
 
     C                   Endif                                                  End W_TSNT
 
      **  If Value Date Nominal is different from 0, write Value Date Position.
     C     W_TSNV        Ifne      0                                            Begin W_TSNV
     C                   Eval      W_WRIT = W_WRIT + 1
     C                   Exsr      #VLDTPO
 
     C                   Endif                                                  End W_TSNV
 
      **  Reset work fields to 0.
     C                   Eval      W_TSNT = 0
     C                   Eval      W_TSNV = 0
     C                   Eval      W_TSEX = 0
     C                   Eval      W_TSPT = 0
     C                   Eval      W_TSPV = 0
     C                   Eval      W_DATG = 0
     C*
     C                   Endsr                                                  ** #P06 SR **
      /Eject
      *****************************************************************
      /Title SR/#P07
      *****************************************************************
      *                                                               *
      *  #P07    - Subroutine to Calculate Trade Portfolio Value.     *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #P07          Begsr                                                  ** #P07 SR **
 
      **  Calculate the trade value in settlement currency.
     C                   Eval      W_CTVLSC = TVSN + TVSP + TOSV
 
      **  Calculate the exchange rate from nominal to settlement currency.
     C     TCTR          Ifne      0                                            Begin TCTR
     C                   Eval(H)   W_ERNSC = W_CTVLSC / TCTR
 
     C                   Else                                                   Else TCTR
     C                   Eval      W_ERNSC = 0
 
     C                   Endif                                                  End TCTR
 
      **  Convert Purchased Interests, Charges & Commissions
      **  to Settlement Currency.
     C                   Eval      W_CCTL = TBCA + TCCA
     C                   Eval      W_CCCT = TCA1 + TCA2 + TCA3 + TCA4 + TCA5 +
     C                                      TCA6 + TCA7 + TAXA
     C                   Eval(H)   W_ITRASC = ITRA * W_ERNSC
     C                   Eval(H)   W_CCTLSC = W_CCTL * W_ERNSC
     C                   Eval(H)   W_CCCTSC = W_CCCT * W_ERNSC
 
      **  Subtract Purchased Interests, Charges and Commissions (if required)
      **  from total value to get Customer Trade Value in Settlement Currency.
     C                   Eval      W_SETAM = W_CTVLSC - W_ITRASC                Interests
 
     C     BVCMCP        Ifeq      'N'                                          Begin BVCMCP
     C                   Eval      W_SETAM = W_SETAM - W_CCTLSC                 Charges
 
     C                   Endif                                                  End BVCMCP
 
     C     BVCCAP        Ifeq      'N'                                          Begin BVCCAP
     C                   Eval      W_SETAM = W_SETAM - W_CCCTSC                 Commissions
 
     C                   Endif                                                  End BVCCAP
 
      **  If Settlement Currency is equal to Customer Base Currency.
     C     SETC          Ifeq      P_PortCcy                                    Begin SETC
     C                   Eval      CFAP = W_SETAM
     C                   Eval      SPXR = 1
     C                   Eval      SPMD = 'M'
 
     C                   Else                                                   Else SETC
 
      **  Set ZAMTF equal to Trade Value in Settlement Currency.
     C                   Eval      ZAMTF = W_SETAM
 
      **  Set ZCCYF equal to Settlement Currency from LF/TRADS.
     C                   Eval      ZCCYF = SETC
 
      **  Set ZCCYT equal to Customer Base Currency.
     C                   Eval       ZCCYT = P_PortCcy
 
      **  Determine Exchange Rate for Settlement Currency.
     C                   Eval      K_CurrCode = SETC
     C                   Eval      K_PayDate  = TDDT
 
     C                   Exsr      #PMRATE
 
      **  Set ZRATEF and ZMDINF equal to the Spot Rate and Multiply/Divide
      **  Indicator determined by #PMRATE subroutine.
     C                   Eval      ZRATEF = W_SPOT
     C                   Eval      ZMDINF = W_MDIN
 
      **  Determine Exchange Rate for Customer Base Currency.
     C                   Eval      K_CurrCode = P_PortCcy
     C                   Eval      K_PayDate  = TDDT
 
     C                   Exsr      #PMRATE
 
      **  Set ZRATET and ZMDINT equel to the Spot Rate and Multiply/Divide
      **  Indicator determined by #PMRATE subroutine.
     C                   Eval      ZRATET = W_SPOT
     C                   Eval      ZMDINT = W_MDIN
 
      **  Access to Currency Details, by using Access Object,
      **  to get Settlement Currency Number of Decimal Places.
                                                                                ***************
     C                   Eval      W_DBAse = 12                                 * Db Error 12 *
                                                                                ***************
     C                   Eval      P_Curr = NMCY                                208648
      *                                                                         208648
     C                   Exsr      #CCYDET
 
     C                   Eval      ZCDPF = A6NBDP
 
      **  Set ZCDPT equal to the Customer Base Currency Number of
      **  Decimal Places.
     C                   Eval      ZCDPT = P_PortCdp
 
      **  Convert Countervalue from Settlement Currency to
      **  Customer Base Currency.
     C                   Exsr      #ZCCYCN
 
     C                   Eval      CFAP = ZAMTT
     C                   Eval      SPXR = ZCRSRT
     C                   Eval      SPMD = ZCRSMD
 
     C                   Endif                                                  End SETC
 
     C                   Endsr                                                  ** #P07 SR **
 
      /Eject
      *****************************************************************
      /Title SR/#P08
      *****************************************************************
      *                                                               *
      *  #P08 - Subroutine to Calculate Depot Movement Portfolio Value*
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     #P08          Begsr                                                  ** #P08 SR **
 
      **  Set ZAMTF equal to the Depot Movement Value in Nominal Currency.
     C     CSTB          Ifne      0                                            Begin CSTB
     C                   Eval      ZAMTF = CSTB
 
     C                   Else                                                   Else CSTB
     C                   Eval      ZAMTF = CSVB
 
     C                   End                                                    End CSTB
 
      **  Set ZCCYF equal to the Nominal Currency from PF/SECTYD.
     C                   Eval      ZCCYF = NMCY
 
      **  Set ZCCYT equal to the Customer Base Currency.
     C                   Eval      ZCCYT = P_PortCcy
 
      **  Determine Exchange rate for the Nominal Currency.
     C                   Eval      K_CurrCode = NMCY
 
      **  Movement Date In or Out, depending on which is different from 0.
     C                   Eval      K_PayDate = CSDA
 
     C                   Exsr      #PMRATE
 
      **  Set ZRATEF and ZMDINF equal to the Spot Rate and Multiply/Divide
      **  Indicator determined by #PMRATE subroutine.
     C                   Eval      ZRATEF = W_SPOT
     C                   Eval      ZMDINF = W_MDIN
 
      **  Determine Exchange Rate for the Customer Base Currency
      **  The Date is as above.
     C                   Eval      K_CurrCode = P_PortCcy
 
     C                   Exsr      #PMRATE
 
      **  Set ZRATET and ZMDINT equal to the Spot Rate and Multiply/Divide
      **  Indictaor determined by #PMRATE subroutine.
     C                   Eval      ZRATET = W_SPOT
     C                   Eval      ZMDINT = W_MDIN
 
      **  Set ZCDPF equal to the Nominal Currency Number
      **  of Decimal Places.
     C                   Eval      ZCDPF = A6NBDP
 
      **  Set ZCDPT equal to the Customer Base Currency Number
      **  of Decimal Places.
     C                   Eval      ZCDPT = P_PortCdp
 
     C                   Exsr      #ZCCYCN
 
     C                   Eval      CFAP = ZAMTT
 
     C                   Endsr                                                  ** #P08 SR **
      /Eject
      *****************************************************************
      /Title SR/#PMRATE
      *****************************************************************
      *                                                               *
      *  #PMRATE - Subroutine to determine Spot Rate and Multiply/Divide *
      *         Indicator.                                            *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     #PMRATE       Begsr                                                  ** #PMRATE SR **
 
      ****Define*Key*List*to*access*to*Portfolio*Historic*Exchange*Rates.**     208648
      **  Define Key List to access to SD Historic Exchange Rates.              208648
     C*****K_PMHsex      Klist                                                  208648
     C     K_SDHsex      Klist                                                  208648
     C                   Kfld                    K_CurrCode
     C                   Kfld                    K_PayDate
 
      **  Position to most recent Historic Exchange Rate.
     C*****K_PMHsex      Setgt     PMHSEXPD                                     208648
     C*****K_CurrCode    Readpe    PMHSEXPD                               75    208648
     C     K_SDHsex      Setgt     SDCUHSL2                                     208648
     C     K_CurrCode    Readpe    SDCUHSL2                               75    208648
 
      **  If an Exchange Rate was found for the currency.
     C     *in75         Ifeq      False                                        Begin greater date
 
      **  Set Spot Rate and Multiply/Divide Indicator equal to
      ****Spot*Rate*and*Multiply/Divide Indicator from PF/PMHSEXPD.             208648
     C*****              Eval      W_SPOT = Q8SPOT                              208648
     C*****              Eval      W_MDIN = Q8MDV1                              208648
      *                                                                         208648
      **  Spot Rate and Multiply/Divide Indicator from LF/SDCUHSL2.             208648
     C                   Eval      W_SPOT = G2SPRT                              208648
     C                   Eval      W_MDIN = G2MDIN                              208648
                                                                                208648
      **  Set up key to access to Currency Details.                             208648
     C                   Eval      P_Curr = K_CurrCode                          208648
                                                                                208648
      **  Set up database error.                                                208648*********
     C                   Eval      W_DBAse = 13                                 208648rror 13 *
                                                                                208648*********
     C                   Exsr      #CCYDET                                      208648
                                                                                208648
      **  Set the Number of decimal places from PF/SDCURRPD                     208648
     C                   Eval      W_CDP  = A6NBDP                              208648
 
      **  Otherwise, if record was not found, get next available Rate.
     C                   Else                                                   Else greater date
 
     C*****K_PMHsex      Setll     PMHSEXPD                                     208648
     C*****K_CurrCode    Reade     PMHSEXPD                               75    208648
     C     K_SDHsex      Setll     SDCUHSL2                                     208648
     C     K_CurrCode    Reade     SDCUHSL2                               75    208648
 
      **  If an Exchange Rate was found for the currency.
     C     *IN75         Ifeq      '0'                                          Begin lower date
 
      **  Set Spot Rate and Multiply/Divide Indicator equal to
      ****Spot*Rate*and*Multiply/Divide Indicator from PF/PMHSEXPD.             208648
      **  Spot Rate and Multiply/Divide Indicator from LF/SDCUHSL2.             208648
     C*****              Eval      W_SPOT = Q8SPOT                              208648
     C*****              Eval      W_SPOT = Q8SPOT                              208648
     C                   Eval      W_SPOT = G2SPRT                              208648
     C                   Eval      W_MDIN = G2MDIN                              208648
                                                                                208648
      **  Set up key to access to Currency Details.                             208648
     C                   Eval      P_Curr = K_CurrCode                          208648
                                                                                208648
      **  Set up database error.                                                208648*********
     C                   Eval      W_DBAse = 13                                 208648rror 13 *
                                                                                208648*********
     C                   Exsr      #CCYDET                                      208648
                                                                                208648
      **  Set the Number of decimal places from PF/SDCURRPD                     208648
     C                   Eval      W_CDP  = A6NBDP                              208648
 
      **  Otherwise, if record was not found, access to Currency Details.
     C                   Else                                                   Else lower date
 
      **  Set up key to access to Currency Details.
     C                   Eval      P_Curr = K_CurrCode
 
      **  Set up database error.                                                ***************
     C                   Eval      W_DBAse = 13                                 * Db Error 13 *
                                                                                ***************
     C                   Exsr      #CCYDET
 
      **  Set Spot Rate and Multiply/Divide Indicator equal to
      **  Spot Rate and Multiply/Divide Indicator from PF/SDCURRPD.
     C                   Eval      W_SPOT = A6SPRT
      **  Set the Number of decimal places from PF/SDCURRPD                     208648
     C                   Eval      W_CDP  = A6NBDP                              208648
     C                   Eval      W_MDIN = A6MDIN
 
     C                   Endif                                                  End lower date
 
     C                   Endif                                                  End greater date
 
     C                   Endsr                                                  ** #PMRATE SR **
      /Eject
      *****************************************************************
      /Title SR/#TRDTPO
      *****************************************************************
      *                                                               *
      *  #TRDTPO- subroutine to generate trade date position on PF/PMCPOSPD           *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     #TRDTPO       Begsr                                                  ** #TRDTPO SR **
 
     C                   MOVE      'T'           QATVDA
     C                   Z-ADD     W_TSNT        QANOML
     C                   Z-ADD     W_TSPT        QAAPNM
     C                   Z-ADD     W_TSNV        QAOTNM
     C                   MOVE      'N'           QAPFMR
 
      **  Set up common Customer Position fields.
     C                   Exsr      #SETCPO
 
      **  Write new Portfolio Position.
     C                   Write     PMCPOSP0
 
     C                   Endsr                                                  ** #TRDTPO SR **
      /Eject
      *****************************************************************
      /Title SR/#VLDTPO
      *****************************************************************
      *                                                               *
      *  #VLDTPO - generate value date position on PF/PMCPOSPD           *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     #VLDTPO       Begsr                                                  ** #VLDTPO SR **
     C*
     C                   MOVE      'V'           QATVDA
     C                   Z-ADD     W_TSNV        QANOML
     C                   Z-ADD     W_TSPV        QAAPNM
     C                   Z-ADD     W_TSNT        QAOTNM
     C                   MOVE      'Y'           QAPFMR
 
      **  Set up common Customer Position fields.
     C                   Exsr      #SETCPO
 
      **  Write new Portfolio Position.
     C                   Write     PMCPOSP0
     C*
     C                   ENDSR                                                  * #VLDTPO SR *
      /Eject
      *****************************************************************
      /Title SR/#SETCPO
      *****************************************************************
      *                                                               *
      *  #SETCPO- subroutine to set up common Customer Position fields*
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     #SETCPO       Begsr                                                  ** #SETCPO SR **
 
     C                   MOVE      'D'           QARECI
     C**********         Z-ADD     K_CustNum     QACNUM                                       CSD027
     C                   EVAL      QACNUM = K_CustNum                                         CSD027
     C                   MOVE      P_PortDefn    QAPTFR
     C                   MOVE      CSSC          QATDSS
     C                   Z-ADD     W_DATG        QAPDAT
     C                   Z-ADD     W_TSEX        QACSEX
 
      **  Calculate FX AP Numerator. To do this:
      **  1 - Determine Cross Rate Nominal To Portfolio Currency on
      **      Position Date.
      **  2 - Convert AP Numerator, using this Rate.
     C                   Z-ADD     *ZEROS        QAFXAP
     C                   MOVE      NMCY          K_CurrCode
     C                   Z-ADD     QAPDAT        K_PayDate
 
     C                   Exsr      #PMRATE
 
     C                   MOVE      NMCY          ZCCYF
     C                   Z-ADD     W_SPOT        ZRATEF
     C                   MOVEL     W_MDIN        ZMDINF
     C*****              Z-ADD     Q8CDP         ZCDPF                          208648
     C*****              Z-ADD     Q8CDP         WS8CDP            1 0          208648
     C                   Z-ADD     W_CDP         ZCDPF                          208648
     C                   Z-ADD     W_CDP         WS8CDP            1 0          208648
 
      **  Perform #PMRATE subroutine for Customer Base Currency.
     C                   MOVEL     P_PortCcy     K_CurrCode
 
     C                   Exsr      #PMRATE
 
     C                   MOVE      P_PortCcy     ZCCYT
     C                   Z-ADD     W_SPOT        ZRATET
     C                   MOVEL     W_MDIN        ZMDINT
     C                   Z-ADD     P_PortCdp     ZCDPT
 
      **  Convert AP Numerator into FX AP Numerator.
     C                   Z-ADD     QAAPNM        ZAMTF
 
     C                   Exsr      #ZCCYCN
 
     C                   Z-ADD     ZAMTT         QAFXAP
 
     C                   Z-ADD     *ZEROS        QAPILP
     C                   Z-ADD     *ZEROS        QAACDI
     C                   Z-ADD     *ZEROS        QABVLD
     C                   MOVE      NMCY          QATNMC
     C                   Z-ADD     NMDP          QATNMD
     C                   MOVE      P_PortCcy     QAPTCY
     C                   Z-ADD     P_PortCdp     QAPCDP
 
      **  Calculate yield on Position if required.
     C                   Z-ADD     *ZEROS        QAAYNM
     C     PROT          Ifeq      '1'                                          Begin PROT
     C     PROT          Oreq      '3'
     C     PROT          Oreq      '5'
     C     PROT          Oreq      '6'
     C     PROT          Oreq      '8'
     C     PROT          Oreq      '9'
 
     C     MATY          Ifne      0                                            Begin MATY
 
      **  If the Security is Interest Bearing, use AIBD method, else DISCOUNT.
     C     CD01          Ifne      0                                            Begin CD01
     C                   Eval      SYBS = 'A '
 
     C                   Else                                                   Else CD01
     C                   Eval      SYBS = 'DA'
 
     C                   Endif                                                  End CD01
 
     C     DYBS          Ifeq      '4'                                          Begin DYBS
     C                   Eval      DYBS = '3'
     C                   Eval      DVBS = '1'
 
     C                   Endif                                                  End DYBS
 
      **  Price used in calculations should be average price.
     C                   Z-ADD     QANOML        ZNOML
     C                   Z-ADD     QAAPNM        ZVALU
     C                   Z-ADD     NMDP          ZNMDP
     C                   Z-ADD     WS8CDP        ZNMCD
     C                   MOVE      SPBS          ZPRCB
 
     C                   Exsr      #ZAVPRC
 
     C                   Z-ADD     ZAVPR         ZPRICE
     C                   Z-ADD     QAPDAT        ZFDATE
     C                   Z-ADD     ZFDATE        ECD
 
      **  If live Security.
     C     SERECI        Ifeq      'D'                                          Begin SERECI
 
     C                   Exsr      #ZYLDO
 
      **  Convert yield returned from SR/#ZYLDO to the average yield
      **  Numerator to be output on PMCPOSPD.
     C                   Z-ADD     QANOML        ZNOML
     C                   Z-ADD     ZYLDOT        ZAVYD
     C                   Z-ADD     NMDP          ZNMDP
     C                   Z-ADD     WS8CDP        ZNMCD
 
      **  Calculate AY Numerator.
     C                   Exsr      ZAYNUM
 
     C                   Else                                                   Else SERECI
     C                   Z-ADD     0             ZVALU
 
     C                   Endif                                                  End SERECI
     C                   Z-ADD     ZVALU         QAAYNM
 
     C                   END                                                    End MATY
 
     C                   END                                                    End PROT
 
     C                   MOVE      P_PortCcy     QACSBY
     C                   Z-ADD     P_PortCdp     QABYDP
 
      **  Get Customer Classification from SDSECSPD.
     C                   Call      'AOSECSR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY  '      P_Optn
     C                   Parm      P_CustNum     P_Cust
     C     Sdsecs        Parm      Sdsecs        Dssdy
 
      **  If Security Client Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDSECSPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = P_CustNum                           ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   MOVE      BFCLAS        QACLAS
 
      **  Get Account Officer Code from Customer Details file.
     C                   Eval      P_Cust = P_CustNum
     C                   MOVEL     P_CustNum     P_Cust
     C                   Call      'AOCUSTR1'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY  '      P_Optn
     C                   Parm      P_CustNum     P_Cust
     C                   Parm      *blanks       P_Kyst
     C     Sdcust        Parm      Sdcust        Dsldy
 
      **  If Customer Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCUSTPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = P_Cust                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   MOVE      BBACOC        QAACOC
 
     C                   Z-ADD     W_TSEX        QAOTEX
     C                   MOVE      'Y'           QAAPBC
     C                   MOVE      *BLANKS       QAFLEX
     C                   MOVE      SCOR          QACOLC
     C                   MOVE      BBBRCD        QABRCD
     C                   Z-ADD     0             QANPDT
 
     C                   Endsr                                                  ** #TRDTPO SR **
      /Eject
      *****************************************************************
      /Title SR/#CAPRHD
      *****************************************************************
      *                                                               *
      *  #CAPRHD - Subroutine to update PM Details on PF/CAPRHD.      *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     #CAPRHD       Begsr                                                  ** #CAPRHD SR **
 
     C     CSTB          Ifne      0                                            Begin CSTB
 
     C     CSDA          Ifgt      W_VDNA                                       Begin CSDA
     C                   Eval      PMTI = 'D'
 
     C                   Else                                                   Else CSDA
     C                   Eval      PMTI = 'H'
 
     C                   Endif                                                  End
 
     C                   Else                                                   Else CSTB
     C                   Eval      PMTI = '*'
 
     C                   Endif                                                  End CSTB
 
     C     CSVB          Ifne      0                                            Begin CSVB
 
     C     CSDA          Ifgt      W_VDNA                                       Begin CSDA
     C                   Eval      PMVI = 'D'
 
     C                   Else                                                   Else CSDA
     C                   Eval      PMVI = 'H'
 
     C                   Endif                                                  End CSDA
 
     C                   Else                                                   Else CSVB
     C                   Eval      PMVI = '*'
 
     C                   Endif                                                  End CSVB
 
     C     PTFR          Ifeq      *blanks                                      Begin PTFR
     C                   Eval      PTFR = P_PortDefn
 
     C                   Endif                                                  End PTFR
 
     C     CSSE          Ifeq      '3'                                          Begin CSSE
     C                   Eval      ACIN = *blank
     C                   Eval      ITRA = 0
 
     C     CSDA          Ifgt      W_VDNA                                       Begin CSDA
     C                   Eval      PMVI = 'D'
     C                   Eval      PMTI = 'D'
 
     C                   Else                                                   Else CSDA
     C                   Eval      PMVI = 'H'
     C                   Eval      PMTI = 'H'
 
     C                   Endif                                                  End CSDA
 
     C                   Endif                                                  End CSSE
 
     C     CSSE          Ifeq      '1'                                          Begin CSSE
     C                   Eval      ACIN = W_ACIN
     C                   Eval      ITRA = W_ITRA
 
     C                   Endif                                                  End CSSE
 
      **  CFAP HAS BEEN DETERMINED WITHIN P07 OR P08
 
      **  Determine the Customer FX Rate, using standard
      **  subroutine #ZFXAVP.
     C     CSTB          Ifne      0                                            Begin CSTB
     C                   Z-add     CSTB          ZAPNM
     C                   Z-add     TDVD          OTHD
 
     C                   Else                                                   Else CSTB
     C                   Z-add     CSVB          ZAPNM
     C                   Z-add     TDDT          OTHD
 
     C                   Endif                                                  End CSTB
     C                   Z-add     CFAP          ZFXAP
     C                   Z-add     A6NBDP        ZNMCD
     C                   Z-add     P_PortCdp     ZPTCD
 
     C                   Exsr      #ZFXAVP
 
      **  Set Customer FX Rate on PF/CAPRHD equal to the average
      **  Exchange Rate ZAVFX from SR #ZFXAVP.
     C                   Z-add     ZAVFX         CFXR
 
     C                   Z-add     0             CAVR
 
      **  Calculate yield from the Trade/Depot Movement Price.
     C                   Z-add     *ZERO         CYLD
     C     PROT          Ifeq      '1'                                          Begin PROT
     C     PROT          Oreq      '3'
     C     PROT          Oreq      '5'
     C     PROT          Oreq      '6'
     C     PROT          Oreq      '8'
     C     PROT          Oreq      '9'
 
     C     MATY          Ifne      0                                            Begin MATY
 
      **  If the Security is Interest Bearing, use AIBD method,
      **  else DISCOUNT.
     C     CD01          Ifne      0                                            Begin CD01
     C                   Eval      SYBS = 'A '
 
     C                   Else                                                   Else CD01
     C                   Eval      SYBS = 'DA'
 
     C                   Endif                                                  End CD01
 
     C     DYBS          Ifeq      '4'                                          Begin DYBS
     C                   Eval      DYBS = '3'
     C                   Eval      DVBS = '1'
 
     C                   Endif                                                  End DYBS
 
      **  If a Trade, calculate using price from Trade and
      **  Value Date from CAPRHD.
     C     CSSE          Ifeq      '1'                                          Begin CSSE
     C                   Z-ADD     PRIC          ZPRICE           15 8
     C                   Z-ADD     TDVD          ZFDATE            5 0
 
      **  Otherwise, take Coupon Rate from Security Date from CAPRHD.
     C                   Else                                                   Else CSSE
     C                   Z-ADD     MKTP          ZPRICE
     C                   Z-ADD     CSDA          ZFDATE
 
     C                   Endif                                                  End CSSE
     C                   Z-ADD     ZFDATE        ECD
     C     SERECI        Ifeq      'D'                                          Begin SERECI
     C                   Exsr      #ZYLDO
 
     C                   Else                                                   Else SERECI
     C                   Eval      ZYLDOT = 0
 
     C                   Endif                                                  End SERECI
     C                   Z-ADD     ZYLDOT        CYLD
 
     C                   Endif                                                  End MATY
 
     C                   Endif                                                  End PROT
 
      **  Update Historic Customer Average Price.
     C                   Except    CAPRH_U
 
     C                   Endsr                                                  ** #CAPRHD SR *
      /Eject
      *****************************************************************
      /Title SR/#FDDTST
      *****************************************************************
      *                                                               *
      *  #FDDTST - Subroutine to write Deal Type/Sub-type record.     *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     #FDDTST       Begsr                                                  ** #FDDTST SR **
 
     C                   Eval      RCID11 = 'D'
     C                   Eval      TYLC11 = 'I'
     C                   Eval      LCD11  = BJRDNB
     C                   Eval      DTPE11 = DTYP
     C                   Eval      DLST11 = DLST
     C                   Eval      NARR11 = 'DEALING'
     C                   Eval      INNR = FCDINR
 
      **  Write Deal Type/Sub-type record.
     C                   Write     FDDTSTPD
 
     C                   Endsr                                                  * #FDDTST ENDSR *
      /Eject
      *****************************************************************
      /Title SR/ZAYNUM
      *****************************************************************
      *                                                               *
      *  ZAYNUM  - Subroutine to calculate AY Numerator               *
      *                                                               *
      *  PURPOSE:  To multiply a nominal position by the yield on the *
      *            position to give a 'Yield' value of the position   *
      *            with the correct number of decimal places for the  *
      *            nominal currency.                                  *
      *                                                               *
      *  Input Fields:                                                *
      *       ZNOML  15 0     Nominal                                 *
      *       ZAVYD  11 7     Average Yield                           *
      *       ZNMDP   1 0     Nominal Decimal Places (0-4)            *
      *       ZNMCD   1 0     Nominal Currency Decimal Places (0-3)   *
      *                                                               *
      *  Output Fields:                                               *
      *       ZVALU  15 0     Value                                   *
      *                                                               *
      *  Also Required:                                               *
      *       POWER8 Array of multiplying factors for nominal decimal *
      *                                                               *
      *  Work Fields:                                                 *
      *       ZVAL0  15 0 - Average yield with 0 decimal places       *
      *       ZVAL1  15 1 - --------------- '' ----------------       *
      *       ZVAL2  15 2 - --------------- '' ----------------       *
      *       ZVAL3  15 3 - --------------- '' ----------------       *
      *       ZI      1 0 - Power Array                               *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     ZAYNUM        Begsr                                                  ** ZAYNUM SR **
 
      **  Define all fields.
     C                   Z-ADD     ZNOML         ZNOML            15 0
     C                   Z-ADD     ZAVYD         ZAVYD            11 7
     C                   Z-ADD     ZNMDP         ZNMDP             1 0
     C                   Z-ADD     ZNMCD         ZNMCD             1 0
     C                   Z-ADD     ZVALU         ZVALU            15 0
 
     C                   Select                                                 Begin Select
 
      **  If number of currency decimal places I = 0.
     C     ZNMCD         Wheneq    0
     C     ZNOML         Mult(H)   ZAVYD         ZVAL0            15 0
     C                   Move      ZVAL0         ZVALU
 
      **  If number of currency decimal places I = 1.
     C     ZNMCD         Wheneq    1
     C     ZNOML         Mult(H)   ZAVYD         ZVAL1            15 1
     C                   Move      ZVAL1         ZVALU
 
      **  If number of currency decimal places I = 2.
     C     ZNMCD         Wheneq    2
     C     ZNOML         Mult(H)   ZAVYD         ZVAL2            15 2
     C                   Move      ZVAL2         ZVALU
 
      **  If number of currency decimal places I = 3.
     C     ZNMCD         Wheneq    3
     C     ZNOML         Mult(H)   ZAVYD         ZVAL3            15 3
     C                   Move      ZVAL3         ZVALU
 
     C                   Endsl                                                  End Select
 
      **  Set index ZI equal to 5 - (nominal decimal places).
     C     5             Sub       ZNMDP         ZI                1 0
 
      **  Multiply ZVALU by POWER8(ZI) to get amount with correct number
      **  of Decimal places.
     C                   Eval      ZVALU = ZVALU * POWER8(ZI)
 
     C                   Endsr                                                  ** ZAYNUM SR **
      /Eject
      *****************************************************************
      /Title SR/#ZCCYCN
      *****************************************************************
      *                                                               *
      *  #ZCCYCN - Subroutine to convert an amount into another       *
      *            amount in a different currency.                    *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     #ZCCYCN       Begsr                                                  ** #ZCCYCN SR **
 
     C                   Callb     'ZCCYCN'
     C                   Parm                    ZAMTF            15 0          Amount in From Curr
     C                   Parm                    ZCCYF             3            From Currency
     C                   Parm                    ZCCYT             3            To Currency
     C                   Parm                    ZRATEF           13 8          Spot Rate From Curr
     C                   Parm                    ZRATET           13 8          Spot Rate To Curr
     C                   Parm                    ZMDINF            1            From Curr M/D Ind
     C                   Parm                    ZMDINT            1            To Curr M/D Ind
     C                   Parm                    ZCDPF             1 0          From Curr Nbr Dec Pl
     C                   Parm                    ZCDPT             1 0          To Curr Nbr Dec Pl
     C                   Parm                    ZAMTT            15 0          Amount in To Curr.
     C                   Parm                    ZCRSRT           13 8          Cross Exchange Rate
     C                   Parm                    ZCRSMD            1            Cross Rate M/D Ind.
 
     C                   Endsr                                                  ** #ZCCYCN SR **
      /Eject
      *****************************************************************
      /Title SR/#ZYLDO
      *****************************************************************
      *                                                               *
      *  #ZYLDO - Subroutine to calculate yield or price.             *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     #ZYLDO        Begsr                                                  ** #ZYLDO SR **
 
     C                   Callb     'ZYLDI'
 
     C                   Parm                    ECD               5 0          Event Control Date
     C**********         Parm                    MATY              5 0          Maturity Date 198688
     C**********         Parm                    SESN             10            Security Short198688
     C                   Parm                    SECTY0                                       198688
     C**********         Parm                    DYBS                           Day basis     198688
     C**********         Parm                    DVBS                           Divisor basis 198688
     C**********         Parm                    LCPN                           Last coupon   198688
     C**********         Parm                    ITLD              5 0          Initial Date  198688
     C**********         Parm                    IADJ                           Interest Adjus198688
     C                   Parm                    ZDATFM            1            Date format (1A)
     C                   Parm                    CDArr            48            Coupon Dates Array (
     C                   Parm                    CRArr            12            Coupon Rate INdicato
     C**********         Parm                    FCPN              5 0          First Coupon  198688
     C**********         Parm                    ISSD              5 0          Issue Date (5 198688
     C**********         Parm                    CFCT             10 9          Current Facto 198688
     C**********         Parm                    CPDP             15 0          Currently par 198688
     C                   Parm                    ZPRCIN           15 3          Yield to be converte
     C**********         Parm                    PPDI                           Partly paid i 198688
     C                   Parm                    PROT                           Processing type
     C**********         Parm                    NMDP              1 0          Nominal Decim 198688
     C                   Parm                    ZCDP              1 0          Currency Decimal pos
     C**********         Parm                    CPNR             11 7          Coupon Rate   198688
     C                   Parm                    ZNOML            15 0          Nominal
     C**********         Parm                    SPBS                           Price Basis   198688
     C**********         Parm                    SYBS                           Yield Basis   198688
     C                   Parm                    ZECD              5 0          Processed Event cont
     C                   Parm                    ZFDATE            5 0          Yield Effective Date
     C**********         Parm                    CMFQ              2 0          Compounding f 198688
     C**********         Parm                    DSCB              1            Discount basi 198688
     C**********         Parm                    DSLC              1            Discount Last 198688
     C                   Parm                    NCDP              1 0          Currecy decimal plac
     C                   Parm                    SCUMEX            1            CUM/Ex-coupon indica
     C**********         Parm                    SFPP             15 0          Fully paid pr 198688
     C                   Parm                    WRKPI            15 9          Purchased interest w
     C                   Parm                    BJDFIN                                       198688
 
      **  Output parameters.
     C                   Parm                    ZYLDOk            1
     C                   Parm                    ZYLDOT           15 8
 
     C                   Endsr                                                  ** #ZYLDO SR **
      /Eject
      *****************************************************************
      /Title SR/#CCYDET
      *****************************************************************
      *                                                               *
      *  #CCYDET - Subroutine to get Currency Details.                *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     #CCYDET       Begsr                                                  ** #CCYDET SR **
 
     C                   Call      'AOCURRR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY  '      P_Optn
     C*****              Parm      NMCY          P_Curr                         208648
     C                   Parm                    P_Curr                         208648
     C     Sdcurr        Parm      Sdcurr        Dssdy
 
      **  If Currency Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCURRPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = P_Curr                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   Endsr                                                  ** #CCYDET SR **
      /Eject
      *****************************************************************
      /Title SR/#ZAVPRC
      *****************************************************************
      *                                                               *
      *  #ZAVPRC - Subroutine to calculate an average price, by       *
      *            dividing the value of a holding by the nominal.    *
      *                                                               *
      *  Input fields:                                                *
      *       ZNOML  11 0     Nominal                                 *
      *       ZVALU  15 0     Value                                   *
      *       ZNMDP   1 0     Nominal Decimal Places (0-4)            *
      *       ZNMCD   1 0     Nominal Currency Decimal Places (0-3 )  *
      *       ZPRCB   1 A     Price Basis (P/U)                       *
      *                                                               *
      *  Output fields:                                               *
      *       ZAVPR  15 8     Average Price                           *
      *                                                               *
      *  Also required                                                *
      *       POWER8 array                                            *
      *                                                               *
      *  Work fields:                                                 *
      *       ZI      1 0 - Index to Power array                      *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     #ZAVPRC       Begsr                                                  ** #ZAVPRC SR **
 
      **  Define all fields.
     C                   Z-add     ZNOML         ZNOML            15 0
     C                   Z-add     ZVALU         ZVALU            15 0
     C                   Z-add     ZNMDP         ZNMDP             1 0
     C                   Z-add     ZNMCD         ZNMCD             1 0
     C                   Move      ZPRCB         ZPRCB             1
     C                   Z-add     ZAVPR         ZAVPR            15 8
 
      **  If Nominal = 0, end process.
     C     ZNOML         Ifeq      0                                            Begin ZNOML
     C                   Eval      ZAVPR = 0
 
      **  If Nominal different from 0.
     C                   Else                                                   Else ZNOML
 
      **  Divide value by nominal.
     C     ZVALU         Div       ZNOML         WXAVPR           20 8
 
      **  If Price Basis is percentage.
     C     ZPRCB         Ifeq      'P'                                          Begin ZPRCB
     C                   Eval      WXAVPR = WXAVPR * 100
 
     C                   Endif                                                  End ZPRCB
 
      **  Set Power8 index to 5 = Nominal Number of Decimal Places +
      **  Currency Number of Decimal Places.
     C     5             Sub       ZNMDP         ZI                1 0
     C                   Eval      ZI = ZI + ZNMCD
 
      **  Divide average price by power.
     C     WXAVPR        Div(H)    POWER8(ZI)    ZAVPR
 
      **  Set average price positive.
     C     ZAVPR         Ifle      0                                            Begin ZAVPR
     C                   Z-sub     ZAVPR         ZAVPR
 
     C                   Endif                                                  End ZAVPR
 
     C                   Endif                                                  End ZNOML
 
     C                   Endsr                                                  ** #ZAVPRC SR **
      /Eject
      *****************************************************************
      /Title SR/#ZFXAVP
      *****************************************************************
      *                                                               *
      *  #ZFXAVP - Subroutine to calculate an average FX rate, by     *
      *            dividing the value of a holding in Portfolio       *
      *            Currency by value in Nominal Currency.             *
      *                                                               *
      *  Input fields:                                                *
      *       ZAPNM  15 0     Average Price Numerator                 *
      *       ZFXAP  15 0     FX Average Price Numerator              *
      *       ZNMCD   1 0     Nominal Currency Decimal Places (0-3)   *
      *       ZPTCD   1 0     Portfolio Currency Decimal Places (0-3) *
      *                                                               *
      *  Output fields:                                               *
      *       ZAVFX  13 8     Average FX Rate                         *
      *                                                               *
      *  Also required                                                *
      *       POWER8 array    Array for Currency conversions          *
      *                                                               *
      *  Work fields:                                                 *
      *       ZI      1 0 - Index to Power array                      *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     #ZFXAVP       Begsr                                                  ** #ZFXAVP SR **
 
      **  Define all fields.
     C                   Z-add     ZAPNM         ZAPNM            15 0
     C                   Z-add     ZFXAP         ZFXAP            15 0
     C                   Z-add     ZNMCD         ZNMCD             1 0
     C                   Z-add     ZPTCD         ZPTCD             1 0
     C                   Z-add     ZAVFX         ZAVFX            13 8
 
      **  If AP Numerator = 0, end process.
     C     ZAPNM         Ifeq      0                                            Begin ZAPNM
     C                   Eval      ZAVFX = 0
 
      **  If AP Numerator is different from 0.
     C                   Else
 
      **  Divide FX AP Numerator by AP Numerator.
     C     ZFXAP         Div(H)    ZAPNM         WWAVFX           21 8
 
      **  Set Power8 index to 5 = Nominal Number of Decimal Places +
      **  Portfolio Currency Number of Decimal Places.
     C     5             Sub       ZNMCD         ZI                1 0
     C                   add       ZPTCD         ZI
 
      **  Divide Average Price by POWER.
     C     WWAVFX        DIV(H)    POWER8(ZI)    ZAVFX                                         49213
 
      **  Set Average Price positive.
     C     ZAVFX         Ifle      0                                            Begin ZAVFX
     C                   Z-SUB     ZAVFX         ZAVFX
 
     C                   Endif                                                  End ZAVFX
 
     C                   Endif                                                  End ZAPNM
 
     C                   Endsr                                                  ** #ZFXAVP SR **
      /Eject
      *****************************************************************
      /Title SR/#Audit
      *****************************************************************
      *                                                               *
      *  #Audit  - Subroutine to Output Audit report.                 *
      *                                                               *
      *  Called By: #P01  - portfolio customer insertion processing   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     #Audit        Begsr                                                  ** #Audit SR **
 
      **  Ensure Audit Report Spool File Recorded by RCF.
     C                   Exsr      #Rcfau
 
     C                   Eval      AURCIN = W_RCIN
     C                   Eval      AURCDL = W_RCDL
 
      **  Output Report Header and File Controls.
     C                   Write     HEADAU
     C                   Write     CONTROL
 
      **  If there is a DB Error, output the DB Error Information.
     C     *inu7         Ifeq      *on                                          Begin *inu7
     C                   Write     DBERROR
 
     C                   Else                                                   Else *inu7
 
      **  Or, if no records read, output "No Details" message.
     C     AURCIN        Ifeq      0                                            Begin AURCIN
     C     AURCDL        Andeq     0
     C                   Write     NODTLS
 
     C                   Endif                                                  End AURCIN
 
     C                   Endif                                                  End *inu7
 
      **  If S01496 is installed, close appropriate files.
     C     S01496        Ifeq      'Y'                                          Begin S01496
     C                   Close     CDEPD
     C                   Close     CDEPPA
     C                   Close     SEERALL3
     C                   Close     SEERALL4
     C                   Close     SEBLKPL4
 
     C                   Endif                                                  End S01496
 
     C                   Endsr                                                  ** #Audit SR **
      /Eject
      *****************************************************************
      /Title SR/#Rcfau
      *****************************************************************
      *                                                               *
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by: #Audit                                            *
      *                                                               *
      *  Calls: ZSFILE                                                *
      *                                                               *
      *****************************************************************
      *
     C     #Rcfau        Begsr                                                  ** #Rcfau SR **
 
      **  Ensure Audit Spool File recorded by RCF.
     C                   Move      Sfnumu        Zsnumu
 
     C                   Call      'ZSFILE'
     C                   Parm      *Blanks       Seq               5
     C                   Parm      *Blanks       Senty             3
     C                   Parm                    Sfileu
     C                   Parm                    Zsnumu            6 0
     C                   Parm      *Blank        Zserr             1
 
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         Ifeq      'Y'                                          Begin Zserr
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
      *
     C                   Endif                                                  End Zserr
      *
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/*Pssr
      *****************************************************************
      *                                                               *
      * *Pssr  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *Pssr         Begsr                                                  ** *Pssr SR **
 
     C     W_RunBefore   Ifne      'Y'                                          Begin W_RunBefore
     C                   Eval      W_RunBefore = 'Y'
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
 
     C                   Dump
     C                   Callb     'DBERRCTL'
 
      **  Ouput Audit Report.
     C                   Exsr      #Audit
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/*Inzsr
      *****************************************************************
      *                                                               *
      *  *Inzsr  - Program Initialization routine.                    *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *Inzsr        Begsr                                                  ** *Inzsr SR **
 
     C     *Entry        Plist
      **  Return Code.
     C                   Parm                    P_ReturnCode
      **  Customer Number.
     C                   Parm                    P_CustNum
      **  Portfolio Definition Reference.
     C                   Parm                    P_PortDefn
      ** Portfolio Currency Code.                                               CPB002
     C                   Parm                    P_PortCcy                      CPB002
      ** Portfolio Currency Decimal Places.                                     CPB002
     C                   Parm                    P_PortCdp                      CPB002
 
      **  Initialize database error fields.
     C     *lock         In        Lda
     C                   Eval      DBFields = *blanks
     C                   Eval      DBPgm    = PSProcName
     C                   Out       Lda
 
      **  Access to Bank Details to get Midas Run date.
     C                   Call      'AOBANKR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_Optn
     C     Sdbank        Parm      Sdbank        Dsfdy
 
      **  If Bank Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbfile = 'SDBANKPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = P_Optn                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
      **  Check system date format, DDMMYY or MMDDYY.
     C     BJDFIN        Ifeq      'M'                                          Begin BJDFIN
     C                   Eval      *in98 = True                                 ** MMDDYY **
 
     C                   Endif                                                  End BJDFIN
 
      **  Access Portfolio Installation Control Data record.
     C                   Call      'AOPORTR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_Optn
     C     Sdport        Parm      Sdport        Dsfdy
 
      **  If Portfolio ICD Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbfile = 'SDPORTPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = P_Optn                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
      **  Access to Midas Modules.
     C                   Call      'AOMMODR0'
     C                   Parm      '*MSG   '     P_Rtcd
     C                   Parm      '*FIRST '     P_Optn
     C     Sdmmod        Parm      Sdmmod        Dsfdy
 
      **  If Midas Modules Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbfile = 'SDMMODPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = P_Optn                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
      **  If Securities Trading Module has been insatlled, access
      **  to Securities Trading Installation Control Data record.
     C     BGSECS        Ifeq      'Y'                                          Begin BGSECS
     C                   Call      'AOSTRDR0'
     C                   Parm      '*MSG   '     P_Rtcd
     C                   Parm      '*FIRST '     P_Optn
     C     Sdstrd        Parm      Sdstrd        Dssdy
 
      **  If Securities Trading ICD Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbfile = 'SDSTRDPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = P_Optn                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   Endif                                                  End  BGSECS
 
      **  If Bank Portfolios are supported, treat as if FF module was off.
     C     BGFUOP        Ifeq      'Y'                                          Begin BGFUOP
     C     FCPORS        Andne     'B'
     C                   Open      TRANSC
 
     C                   Endif                                                  End BGFUOP
 
      **  Get Event Control Date from Portfolio Management Data Area.
     C                   In        PMStat
 
      **  Calculate Back Value Date.
     C                   Move      DAECD         W_VDNA
     C                   Eval      W_VDNA =  W_VDNA - BVBVP
 
      **  Check if feature "Jyske Enhancements" is on.
     C                   Move      'N'           S01496            1
     C                   Call      'AOSARDR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*VERIFY'     P_Optn
     C                   Parm      'S01496'      P_Sard
     C     Scsard        Parm      Scsard        Dssdy
 
      **  If feature S01496 is installed, open appropriate files.
     C     P_Rtcd        Ifeq      *blanks                                      Begin P_Rtcd
     C                   Eval      S01496 = 'Y'
     C                   Open      CDEPD
     C                   Open      CDEPPA
     C                   Open      SEERALL3
     C                   Open      SEERALL4
     C                   Open      SEBLKPL4
 
     C                   Else                                                   Else P_Rtcd
 
      **  Return code other than *NRF.
     C     P_Rtcd        Ifne      '*NRF'                                       Begin P_Rtcd <> *NRF
     C     *Lock         In        Lda
     C                   Eval      DBFile = 'SCSARDPD'                          ***************
     C                   Eval      DBKey  = P_Sard                              * Db Error 15 *
     C                   Eval      DBAse  = 1                                   ***************
     C                   OUT       LDA
     C                   Exsr      *PSSR
 
     C                   Endif                                                  End P_Rtcd <> *NR
 
     C                   Endif                                                  End P_Rtcd
 
      **  Check if feature "Corporate Actions" is on.
     C                   Move      'N'           CSE007            1
     C                   Call      'AOSARDR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*VERIFY'     P_Optn
     C                   Parm      'CSE007'      P_Sard
     C     Scsard        Parm      Scsard        Dssdy
 
      **  If feature CSE007 is installed, open appropriate files.
     C     P_Rtcd        Ifeq      *blanks                                      Begin P_Rtcd
     C                   Eval      CSE007 = 'Y'
     C                   Open      SECOAL11
     C                   Open      SECOBKL3
     C                   Open      SECOSIL3
     C                   Open      SECOCOL1
     C                   Open      SECOAPL1
 
     C                   Else                                                   Else P_Rtcd
 
      **  Return code other than *NRF.
     C     P_Rtcd        Ifne      '*NRF'                                       Begin P_Rtcd <> *NRF
     C     *Lock         In        Lda
     C                   Eval      DBFile = 'SCSARDPD'                          ***************
     C                   Eval      DBKey  = P_Sard                              * Db Error 15 *
     C                   Eval      DBAse  = 1                                   ***************
     C                   OUT       LDA
     C                   Exsr      *PSSR
 
     C                   Endif                                                  End P_Rtcd <> *NR
 
     C                   Endif                                                  End P_Rtcd
                                                                                CPB004
      **  Check if feature "Account Closing" is on.                             CPB004
     C                   Move      'N'           CPB004            1            CPB004
     C                   Call      'AOSARDR0'                                   CPB004
     C                   Parm      *blanks       P_Rtcd                         CPB004
     C                   Parm      '*VERIFY'     P_Optn                         CPB004
     C                   Parm      'CPB004'      P_Sard                         CPB004
     C     Scsard        Parm      Scsard        Dssdy                          CPB004
                                                                                CPB004
     C     P_Rtcd        Ifeq      *blanks                                      CPB004
     C                   Eval      CPB004 = 'Y'                                 CPB004
     C                   Endif                                                  CPB004
                                                                                              233196
      **  Check if feature "Taxation on Savings Income" is on.                                233196
                                                                                              233196
     C                   EVAL      CGL031 = 'N'                                               233196
     C                   CALL      'AOSARDR0'                                                 233196
     C                   PARM      *Blanks       P_Rtcd                                       233196
     C                   PARM      '*VERIFY'     P_Optn                                       233196
     C                   PARM      'CGL031'      P_Sard                                       233196
     C     Scsard        PARM      Scsard        Dssdy                                        233196
                                                                                              233196
     C                   IF        P_Rtcd = *Blanks                                           233196
     C                   EVAL      CGL031 = 'Y'                                               233196
     C                   ENDIF                                                                233196
 
      **  Set up Customer Number key field used to access to files.
     C                   Move      P_CustNum     K_CustNum
 
     C                   Endsr                                                  ** *Inzsr SR **
      /Eject
      *****************************************************************
      *
      **-------
      **  Deals
      **-------
      *
     ODEALSDBF  E            DEALSB_U
     O                       PTFR
     O                       HLEX
      *
     OFXDEALP0  E            FXDEAL_U
     O                       FHPTFR
      *
     ODEALSDCF  E            DEALSC_U
     O                       PTFR
     O                       FXRD
     O                       HLEX
      *
     OMMDELDP0  E            MMDELD_U
     O                       HKPTFR
      *
      **---------
      **  Trades.
      **---------
      *
     OTRADSDF   E            TRADS_U
     O                       PTFR
     O                       SPXR
     O                       SPMD
      *
     OHSTTRDF   E            HSTTR_U
     O                       PTFR
     O                       SPXR
     O                       SPMD
      *
      **------------------
      **  Depot Movements.
      **------------------
      *
     ODPTMVDF   E            DPTMV_U
     O                       PTFR
     O                       SPXR
     O                       SPMD
     O                       CYLD
     O                       CWDI
      *
      **------------------
      **  FF Transactions.
      **------------------
      *
     OTRANSDF   E            TRANS_U
     O                       PTFR
      *
      **-----------
      **  LE Loans.
      **-----------
      *
     OCLOANCLF  E            CLOAN_U
     O                       PTFR
     O                       HLEX
      *
     OPMCLONF0  E            CLOANP_U
     O                       PTFR
     O                       HLEX
      *
     OCLOANCZF  E            CLOANZ_U
     O                       PTFR
     O                       HLEX
      *
      **-----------
      **  Accounts.
      **-----------
      *
     OACCNTABF  E            ACCNT_U
     O                       PTFR
     O                       HLEX
     O                       REPI                                               CPB004
      *                                                                         224860
     OACCNTABF  E            ACCNT_U2                                           224860
     O                       REPI                                               224860
      *
      **---------------------------------
      **  Customer Average Price Actions.
      **---------------------------------
      *
     OCAPRHDF   E            CAPRH_U
     O                       PMTI
     O                       PMVI
     O                       PTFR
     O                       ACIN
     O                       ITRA
     O                       CFAP
     O                       CAVR
     O                       CFXR
     O                       CYLD
     O                       OTHD
      *
      **-----------------------------------
      **  Customer Depot Positions by Date.
      **-----------------------------------
      *
     OCDEPDF    E            CDEP_U
     O                       PTFR
      *
      **-----------------------------
      **  General Blocks by Customer.
      **-----------------------------
      *
     OSEBLKPD0  E            SEBLKP_U
     O                       VDPTFR
      *
      **--------------------------------------------------
      **  Allocations by Customer and Portfolio Reference.
      **--------------------------------------------------
      *
     OSEERALD0  E            SEERAL_U
     O                       VCPTFR
      *
      **--------------------------------------------
      **  Corporate Actions Allocations by Customer.
      **--------------------------------------------
      *
     OSECOALD0  E            SECOAL_U
     O                       MCPTFR
      *
      **--------------------------------------
      **  Corporate Actions Blocked Positions.
      **--------------------------------------
      *
     OSECOBKD0  E            SECOBK_U
     O                       MUPTFR
      *
      **---------------------------------
      **  Corporate Actions Instructions.
      **---------------------------------
      *
     OSECOSID0  E            SECOSI_U
     O                       MOPTFR
      *
      **-------------------------------------------
      **  Corporate Actions Correspondance Details.
      **-------------------------------------------
      *
     OSECOCOD0  E            SECOCO_U
     O                       MVPTFR
      *
      **---------------------------------------
      **  Corporate Actions Affected Positions.
      **---------------------------------------
      *
     OSECOAPD0  E            SECOAP_U
     O                       MXPTFR
      *
      **----------------------------------
      **  Customer Position Profit Centre.
      **----------------------------------
      *
     OSEPCCDF   E            SEPCC_U
     O                       PTFR
      /Eject
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  TABDealTypes
LNDLTIIPCLITTDCDCI
**  POWER8 - Array of POWERS for cuurency conversion
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
