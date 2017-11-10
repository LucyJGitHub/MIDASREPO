     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas SD Case management maintenance input')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDMCMGSIN - Case Management Maintenance Input                *
      *                                                               *
      *  Function: This module will be the entry module for the       *
      *            screen-input function for Midas Case Management    *
      *            Maintenance                                        *
      *                                                               *
      *  Component of: SDMCMGSIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CFT162             Date 11Sep17               *
      *  Prev Amend No. CAP212             Date 15Sep14               *
      *                 CGL165             Date 15Feb17               *
      *                 CER070             Date 24Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15105A          Date 25Oct07               *
      *                 CRE026             Date 24May06               *
      *                 CSW207             Date 03Jul07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11May06               *
      *                 CPK024             Date 13Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6198            Date 04Apr05               *
      *                 BUG5671            Date 01Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CDL031             Date 05dec04               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4684            Date 29Oct04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CSD019             Date 02Jun03               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CAP212 - FT Nostro Transfer API (Recompile)                  *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15105A - Missing Process for SWIFT 2007 (Reopen)          *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CPK024 - Rename field OPIN for INPAY/OUTPAY                  *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  BUG5671- Add Sequence number to detail record (Recompile)    *
      *  CSD025 - Customer De-Activation                              *
      *  CDL031 - Effective Date on Extended SSI (Recompile)          *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4684 - Rename WCOA to COLA same as ACCNTAB. (Recompile)   *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking                                            *
      *  CSD015 - Midas Compliance Watch                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *    01 - 11    Use for Read/Chain                              *
      *    99         Use for LOOKUP command                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrUpdate       - Process file update                         *
      *  SrBldBrw       - Build browse subfile record                 *
      *  SRRdNBrw       - Read next browse subfile record             *
      *  SRRtvCWHT      - Retrieve Item's details.                    *
      *  SREndP         - Set program to end                          *
      *  SRSndM         - Send error message to screen                *
      *  SRResetErr     - Reset error fields                          *
      *  SrWatch        - Run Watch List Checker                      *
      *  SrSetKey       - Setup the Key to be used to access Main     *
      *                   Database File                               *
      *  SrInitKeys     - Initialize the Keys                         *
      *  SrSetParm      - Access the details from the main database   *
      *                   File Set-up Parameters 1 and 2              *
      *  SrParmCloancl  - Setup the Parameters 1 and 2 for CLOANCL    *
      *  SrParmLefeed   - Setup the Parameters 1 and 2 for LEFEED     *
      *  SrParmLefeead  - Setup the Parameters 1 and 2 for LEFEEAD    *
      *  SrParmCloanck  - Setup the Parameters 1 and 2 for CLOANCK    *
      *  SrParmLoamsdk  - Setup the Parameters 1 and 2 for LOAMSDK    *
      *  SrParmSdcustpd - Setup the Parameters 1 and 2 for SDCUSTPD   *
      *  SrParmXSDCust  - Setup the Parameters 1 and 2 for SDCUSTPD   *
      *                   for Standing Data Authorisation             *
      *  SrParmSdacuspd - Setup the Parameters 1 and 2 for SDACUSPD   *
      *  SrParmSdaltnpd - Setup the Parameters 1 and 2 for SDALTNPD   *
      *  SrParmXSDAltn  - Setup the Parameters 1 and 2 for SDALTNPD   *
      *                   for Standing Data Authorisation             *
      *  SrParmCgcorrpd - Setup the Parameters 1 and 2 for CGCORRPD   *
      *  SrParmAccntab  - Setup the Parameters 1 and 2 for ACCNTAB    *
      *  SrParmXAccnt   - Setup the Parameters 1 and 2 for ACCNTAB    *
      *                   for Standing Data Authorisation             *
      *  SrParmSdexstpd - Setup the Parameters 1 and 2 for SDEXSTPD   *
      *  SrParmStandsb  - Setup the Parameters 1 and 2 for STANDSB    *
      *  SrParmTransd   - Setup the Parameters 1 and 2 for TRANSD     *
      *  SrParmTradsd   - Setup the Parameters 1 and 2 for TRADSD     *
      *  SrParmDptmvd   - Setup the Parameters 1 and 2 for DPTMVD     *
      *  SrParmPosetd   - Setup the Parameters 1 and 2 for POSETD     *
      *  SrParmInpaydd  - Setup the Parameters 1 and 2 for INPAYDD    *
      *  SrParmOtpaydd  - Setup the Parameters 1 and 2 for OTPAYDD    *
      *  SrParmFt101hpd - Setup the Parameters 1 and 2 for FT101HPD   *
      *  SrRFTHProcess  - Calling of Engine Program for RFT           *
      *  Sr1stRFTParm   - Setup first parm for Compliance Engine Prgm *
      *  SrParmFt102hpd - Setup the Parameters 1 and 2 for FT102HPD   *
      *  SrCCTHProcess  - Calling of Engine Program for CCT           *
      *  Sr1stCctParm   - Setup first parm for Compliance Engine Prgm *
      *  SrParmCqcocdd  - Setup the Parameters 1 and 2 for CQCOCDD    *
      *  SrCQHProcess   - Calling of Engine Program for CheqColl      *
      *  Sr1stCQParm    - Setup first parm for Compliance Engine      *
      *                   Program                                     *
      *  SrParmCqpacdd  - Setup the Parameters 1 and 2 for CQPACDD    *
      *  SrCPHProcess   - Calling of Engine Program for CheqPaid      *
      *  Sr1stCPParm    - Setup first parm for Compliance Engine      *
      *                   Program                                     *
      *  SrParmNtrandd  - Setup the Parameters 1 and 2 for NTRANDD    *
      *  SrParmDealsdb  - Setup the Parameters 1 and 2 for DEALSDB    *
      *  SrParmDealsdg  - Setup the Parameters 1 and 2 for DEALSDG    *
      *  SrParmFxclspsh - Setup the Parameters 1 and 2 for FXCLSPSH   *
      *  SRGetNstDet    - Gets the Nostro details given a currency    *
      *                   and Nostro Code pair.                       *
      *  SrParmMmdeampp - Setup the Parameters 1 and 2 for MMDEAMPP   *
      *  SrParmFxnetmpd - Setup the Parameters 1 and 2 for FXNETMPD   *
      *  SrParmFxdealpp - Setup the Parameters 1 and 2 for FXDEALPP   *
      *  SrParmMmdeldpp - Setup the Parameters 1 and 2 for MMDELDPP   *
      *  SrParmMmdenbpp - Setup the Parameters 1 and 2 for MMDENBPP   *
      *  SrParmMmdenspp - Setup the Parameters 1 and 2 for MMDENSPP   *
      *  SrEngine       - Calling of Watch List Check Engine          *
      *  SrFormat       - Convert Settlement Details to Customer Name *
      *                   and Address                                 *
      *  SrCurrDet      - Retrieve Currency Details                   *
      *  SrCustDet      - Retrieve Customer Details                   *
      *  SrCvtDate      - Convert dates to be used for Watch Engine   *
      *                   Program                                     *
      *  SrCvtAmt       - Convert amounts for Watch Engine Program    *
      *  SrInitParm     - Initialize 1st and 2nd Parameters of Watch  *
      *                   List Engine                                 *
      *  *PSSR          - Error processing                            *
      *  *INZSR         - Initialise                                  *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FLELOANL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Live loan details

     FLEFEEDL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Fee details - active

     FLEFEEDL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDF2)
      ** Midas LE Fee details - active

     FLEFEEAL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Fee adjustment details - active

     FLEFEEAL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEADF:LEFEEADF2)
      ** Midas LE Fee adjustment details - active

     FLELOANL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Live rollover details

     FLELOAML0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Live loan amendment details

     FSDCUSTL5  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Live customers

     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Additional customer details retrieval

     FSDALTNL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas Alternate Names & Address Live Cust's

     FCGCORRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas CG Correspondent details retrieval index

     FACCBR     IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Accounts by branch

     FSDEXSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Extended settlements retrieval

     FSTAND     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Extended settlements retrieval

     FTRANS2    IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Transaction details

     FTRSET1    IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Transaction Settlement details

     FMKCTL     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Market Control details

     FINTYP     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Instrument Types

     FTRADS     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Trade Details File

     FTRADSDY2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Trade Extension File

     FDPTMVDL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Depot movements by reference number

     FDPTMVDY3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Depot Movements Extension File

     FPOSET2    IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Position Settlement (Live)

     FPOSETDY2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Position Settlement Extension File

     FINPAY     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Inc. Payments

     FINPAYXL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Incoming Payments Details Extension File

     FOTPAY     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Out. Payments

     FOTPAYXL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Outgoing Payments Details Extension File

     FFT101HL3  IF A E           K DISK    INFSR(*PSSR)
      ** Midas FT RFT header key = RFTID

     FFT101DL0  IF A E           K DISK    INFSR(*PSSR)
      ** Midas FT RFT detail key = RFTID / TRNSID

     FFT102HL3  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H2_)
      ** Midas FT CCT header key = CCTID

     FFT102DL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT CCT detail key = CCTID / TRNSID

     FCQMAT     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Chq Headers for Base Equiv Update

     FCQCOCDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CQCOCDDF:CQCOCDD2)
     F                                     PREFIX(C1_)
      ** Midas FT Cheques to be Collected by PaymentRef

     FCQPADDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CQPADDDF:CQPADDD2)
     F                                     PREFIX(P1_)
      ** Midas FT Cheques to be Paid Debit Dtls

     FNTRAN     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Nostro Transfers

     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL All deals

     FDLGXSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL Extra sett inst for x-ccy (deal + event)

     FFXCLSPSDL0IF   E           K DISK    INFSR(*PSSR)
      ** CLS Pay Schedule Detail file

     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MM deals amendments file.

     FFXNETML3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FX Nets by net reference

     FFXDEALLL  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FX deals file

     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MM Deals file

     FSDANSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
      ** Midas SD Customer Details Update Shadow File

     FSDCDSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(T_)
      ** Midas SD Customer Details Update Shadow File

     FGLACSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(U_)
     F                                     RENAME(ACCNTABF:GLACSHD0)
      ** Midas SD Customer Details Update Shadow File

      ** Hook to enable non-core files to be included
      *
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.

      /COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes the definitions of data
      ** structure used to pass data to window program

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

      ** Watch List Fields's Open and Close Tags
     D*Opentag**       S             25    CTDATA DIM(124) PERRCD(1)                          CSW210
     D*Clostag**       S             25    CTDATA DIM(124) PERRCD(1)                          CSW210
     D Opentag         S             25    CTDATA DIM(126) PERRCD(1)                          CSW210
     D Clostag         S             25    CTDATA DIM(126) PERRCD(1)                          CSW210

      ** SD Compliance Watch Hit List File - file format
     D NwCWFilFmt    E DS                  EXTNAME(SDCWHTPD)

      ** SD Compliance Watch Hit List File - file format
     D CrCWFilFmt    E DS                  EXTNAME(SDCWHTPD)
     D                                     PREFIX(CR:2)

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Midas SD Watch List Configuration Data File
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)

      ** Midas SD General ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Nostro Details Data Structure
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D SDNOSTACCD    E                     EXTFLD(QQACCD)                                     CGL029

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)

      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  DBRN                  11     13A

      ** ZDATE Data Structure

     D ZDATE           DS
     D  PZDate                 1      6  0
     D  PZDay                  1      2  0
     D  PZMonth                3      4  0
     D  PZYear                 5      6  0

      ** Working Date Data Structure

     D WDATE           DS
     D  WLongYr                1      4  0
     D  WShortYr               3      4  0
     D  WMonth                 5      6  0
     D  WDay                   7      8  0

      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure used as parameters for the Compliance Engine
     D PDSWLTD       E DS                  EXTNAME(SDWLTDPD)
     D P_XML           DS         30000


      ** Temporary Data Structure for Midas Compliance Watch
     D WTEMPDS         DS          3000

      ** Work variables used to Set Up the Key based from the Identifier
      ** LEFEED and LEFEEAD
     D W_Lef_1         DS            30
     D**K_Loan1*               1      6S 0                                                    CLE148
     D  K_Loan1                1      6A                                                      CLE148
     D  W_Fseq_1               7      8S 0

     D W_Lef_2         DS            30
     D**K_Cnum**               1      6S 0                                                    CSD027
     D  K_Cnum                 1      6                                                       CSD027
     D  K_Facl                 7     11S 0
     D  W_Fseq_2              12     13S 0

      ** LOAMSDK, CLOANCL and CLOANCK
     D W_Loam          DS            30
     D**K_Lnrf**               1      6S 0                                                    CLE148
     D  K_Lnrf                 1      6A                                                      CLE148
     D  K_Vdat                 7     11S 0
     D  K_Lasn                12     14S 0

      ** ACCNTAB
     D***W_Accntab       DS            30                                                     CGL029
     D W_Accntab       DS            36                                                       CGL029
     D  K_Brca                 1      3A
     D**K_CnumX*               4      9S 0                                                    CSD027
     D  K_CnumX                4      9                                                       CSD027
     D  K_Ccy                 10     12A
     D***K_Acod*               13     16S 0                                                   CGL029
     D***K_Acsq*               17     18S 0                                                   CGL029
     D  K_Acod                13     22S 0                                                    CGL029
     D  K_Acsq                23     24S 0                                                    CGL029

      ** SDEXSTPD
     D W_Sdexstpd      DS            30
     D  K_Bycycd               1      3A
     D  K_Bycust               4      9A
     D  K_Bytrty              10     11A

      ** POSETD
     D W_Posetd        DS            30
     D  K_Pbca                 1      3A
     D  K_Pssh                 4     13A
     D**K_Pcpy**              14     19S 0                                                    CSD027
     D  K_Pcpy                14     19                                                       CSD027
     D  K_Pdud                20     24S 0
     D  K_Pevt                25     26A

      ** FXCLSPSH
     D W_Fxclspsh      DS            30
     D  K_Pyccy                1      3A
     D  K_Pynost               4      5A
     D  K_Pyvald               6     10S 0
     D  K_Pyseqn              11     12S 0

      ** MMDEAMPP
     D W_Mmdeampp      DS            30
     D  K_Hnda38               1      6S 0
     D  K_Hnvdyy               7     10S 0
     D  K_Hnvdmm              11     12S 0
     D  K_Hnvddd              13     14S 0
     D  K_Hnds38              15     17S 0

     D                 DS
      **  OrderingBank
     D  OrderingBank           1     12
     D  ORBKNostro             1      2
     D  ORBKRetail             1     10

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Response mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for synchronous.
     D PRespMode       S              1A   INZ('S')

      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     D PMode           S              6A   INZ('*SIN  ')

      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)

      ** Index for arrays of error message ids, etc.
     D Ex              S              3P 0
     D IDx             S              3P 0

      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0

      ** Function keys to activate
     D PEINKE          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A

      ** Function keys activated
     D PINKC           S              1A
     D PINKE           S              1A

      ** Work variables
     D WReDisplay      S              1A
     D WOACTN          S              1A
     D WScrn           S              1A
     D WPrevScrn       S              1A
     D WRdNBrw         S              1A
     D WProcOnce       S              1A
     D WiX             S              3P 0
     D WRCCO           S             10A
     D***WORBK**         S             12A                                                    CGL029
     D WORBK           S             18A                                                      CGL029
     D WSNCO           S             10A
     D***WCRPY**         S             12A                                                    CGL029
     D WCRPY           S             18A                                                      CGL029
     D***WDRPY**         S             12A                                                    CGL029
     D WDRPY           S             18A                                                      CGL029
     D WACBN           S              2A
     D WDEST           S              2A
     D WDA38           S              6
     D WDS38           S              3
     D WVDYY           S              4
     D WVDMM           S              2
     D WVDDD           S              2

      ** Error Indicators
     D OKOPTN          S              1A
     D OKITEM          S              1A

      ** Work parameters

     D POpSel          S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrMS          S              7A
     D PFuntSel        S              8A
     D PIdenSel        S             40A
     D PBrchSel        S              3A
     D PFrnt           S             20A

     D PFuntPtr        S              8A
     D PIdenPtr        S             40A
     D PBrchPtr        S              3A
     D POption         S              1A
     D PRetCde         S              7A                                                      CSD019

      ** Concord Interface Development
     D CCF001          S              1A

      ** Standing Data Authorisation
     D CSD012          S              1A
                                                                                              CSD019
      ** Midas Compliance Watch - Entry Level Watch List Checking                             CSD019
     D CSD019          S              1A                                                      CSD019

      ** Parameter for 'SDCWLFMT'
     D  PInput1        S             35A
     D  PInput2        S             35A
     D  PInput3        S             35A
     D  PInput4        S             35A
     D  PInput5        S             35A
     D  PInput6        S             35A
     D  PCurrency      S              3A
     D  POutput1       S            216A
     D  POutput2       S              6A

      ** Parameter for ZACVTDATE
     D PInDate         S              5A
     D POutDate        S               D
     D PCvtdDate       S             10A

      ** Parameter for ZACVTAMT
     D PCcyV           S              3
     D PInAmt          S             15
     D POutAmtNum      S             18  3
     D PCvtdAmt        S             16

      ** Parameter for ZA0140M
     D PRetcode        S              1
     D PDateFormat     S              1
     D PDate6          S              6  0
     D PDate7          S              7
     D PDate8          S              8  0
     D PDummy8         S              8  0

      ** ZDATE1 Parameters
     D PZDateIn        S              6
     D PZDayNo         S              5  0
     D PZDateFmt       S              1
     D PZRtCd          S              1

     D WDateY          S              8A
     D WDOB            S              9A
     D WDOBTMP         S              4A

      ** Parameter for AOBANKR0/AOSARDR0/AOCUSTR0/AOCURRR0/AOCWCDR0/AOGELRR0
     D PReturnCode     S              7
     D POptn           S              7
     D PSard           S              6
     D PKey1           S             10A
     D PKyst           S              7A
     D PmCcy           S              3
      *
      ** AONOSTR0 Parameters
      *
     D PCUST           S              6
     D***PACCD**         S              4                                                     CGL029
     D PACCD           S             10                                                       CGL029
     D PACSN           S              2
     D PBRCD           S              3
     D PCSSN           S             10
     D PPNOI           S              1
     D PCcy            S              3
     D PNostCode       S              2

      ** Work Variables - LEFEED Identifier
     D WCNUM           S              6
     D WFACL           S              5
     D WFSEQ           S              2
     D WLOAN           S              6

      ** Work Variables - LOAMSDK and FXCLSPSH Identifier
     D WLNRF           S              6
     D WVDAT           S              5
     D WLASN           S              3
     D WSEQN           S              2

      ** Work Variables - ACCNTAB Identifier
     D***WACOD**         S              4                                                     CGL029
     D WACOD           S             10                                                       CGL029
     D WACSQ           S              2

      ** Work Variables - Processing Type
     D WWPTYP          S              2

      ** Work Variables - Due Date and Counter Party
     D PDUDA           S              5
     D PCPYA           S              6

      ** Work Variables - chain record from MKCTL
     D K_Mrkt          S              2

      ** Work variables used to Set Up the Key based from the Identifier
      ** LEFEED and LEFEEAD
     D K_Fseq1         S              2S 0
     D K_Fseq2         S              2S 0

      ** SDCUSTPD
     D K_Bbcust        S              6A

      ** SDACUSPD
     D K_E5cust        S              6A

      ** SDALTNPD
     D K_Bccust        S              6A

      ** CGCORRPD
     D K_Cdcorr        S             10A

      ** STANDSB
     D K_Stor          S              5S 0

      ** TRANSD
     D K_Tnbr          S              6S 0

      ** TRADSD
     D K_Tdrf          S              6A

      ** DPTMVD
     D K_Dprn          S              6A

      ** INPAYDD
     D K_Pref          S             15A

      ** FT101HPD
     D K_RftId         S             15A

      ** FT102HPD
     D K_H2Cctid       S             15A

      ** NTRANDD
     D K_Tfrf          S             15A

      ** DEALSDB , DEALSDG and DLGXSTPD
     D K_Dlno          S              6  0
     D K_Rxedcd        S              3A

      ** FXNETMPD
     D K_Amnetr        S             19A

      ** FXDEALPP
     D K_Fhdn38        S              6S 0

      ** MMDELDPP
     D K_Hkdn38        S              6S 0

      ** MMDENBPP
     D K_Hldn38        S              6S 0

      ** MMDENSPP
     D K_Hmdn38        S              6S 0

      ** LEFEEDL0
     D*K_Loan2**       S              6S 0                                                    CLE148
     D K_Loan2         S              6A                                                      CLE148
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+


     IINPAYDDF                                                                  CPK024
     I              OPIN                        IOPIN                           CPK024
                                                                                CPK024
     IOTPAYDDF                                                                  CPK024
     I              OPIN                        OOPIN                           CPK024
                                                                                CPK024
     ILOAMSDKF
     I              PNAM                        W_PNAM

     IPOSETDF
     I              PREF                        W_PREF

     IDEALSDFF
     I              FLSZ                        W_FLSZ
     I              NLRA                        W_NLRA

     ITRADSDF                                                                                 CAS006
     I              CRSK                        W_CRSK                                        CAS006

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Build Browse

     C                   IF        WScrn = 'B'
     C                   EXSR      SrBldBrw
     C                   ENDIF

      ** Read next browse subfile record.

     C                   IF        WScrn = 'R'
     C                   EXSR      SrRdnBrw
     C                   ENDIF

      ** Run Watch List Checker.

     C                   IF        WScrn = 'W'
     C                   EXSR      SRWatch
     C                   ENDIF
                                                                                              CSD019
      ** Run Watch List Match Enquiry.                                                        CSD019
                                                                                              CSD019
     C                   IF        WScrn = 'M'                                                CSD019
     C                   EXSR      SRMatch                                                    CSD019
     C                   ENDIF                                                                CSD019

      ** Process file update.

     C                   IF        WScrn = 'U'
     C                   EXSR      SrUpdate
     C                   ENDIF

      ** Terminate program.

     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdate - Process file update                               *
      *                                                               *
      *****************************************************************
     C     SrUpdate      BEGSR

     C                   SELECT

      ** For Items that are released temporarily, it may be possible to
      ** unreleased them.

     C                   WHEN      POpsel = 'R'
     C                   EVAL      W3TREL = *BLANKS

      ** For Items that have a status of 'INVESTIGTN' or 'TRUEPOSITV' or a
      ** 'Hit Unconfirmed Flag of 'Y', it will be possible to release them.

     C                   WHEN      POpsel = 'X'
     C                   EVAL      W3TREL = 'Y'

      ** An item of any state may be declared as 'False Positive'.

     C                   WHEN      POpsel = 'Y'
     C                   EVAL      W3HSTS = 'FALSPOSITV'
     C                   EVAL      W3TREL = *BLANKS
     C                   EVAL      W3UNCF = *BLANKS

      ** An item of any state may be declared as 'True Positive'.

     C                   WHEN      POpsel = 'Z'
     C                   EVAL      W3HSTS = 'TRUEPOSITV'

     C                   ENDSL

      ** Update file.

     C                   CALLB     'SDMCMGUPD'

      ** INPUT
      ** =====

      ** Return code
     C                   PARM      *BLANKS       RetCodeOut

      ** SD Compliance Watch Hit List File for file update  - file format

     C                   PARM                    NwCWFilFmt

      ** If errors occurred on update, rollback uncommitted file
      ** changes.

     C                   IF        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'

     C                   ROLBK
     C                   EXSR      *PSSR

     C                   ELSE

     C                   IF        RetCodeOut = '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF

     C                   ENDIF

      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.

     C                   IF        RetCodeOut = '*RECUPD'
     C                   Z-ADD     1             IDx
     C                   Eval      FldNameArr(IDx) = '*ANY'
     C                   Eval      MsgIdArr(IDx) = 'APM1000'
     C                   ENDIF

     C                   IF        WScrn = 'E'
     C                   GOTO      ESRUpdate
     C                   ENDIF

      ** Read next browse subfile record.

     C                   IF        WRdNBrw = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   GOTO      ESRUpdate
     C                   ENDIF

     C                   EVAL      WScrn = 'B'

     C     ESRUpdate     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldBrw - Build browse subfile record                       *
      *                                                               *
      *****************************************************************
     C     SrBldBrw      BEGSR

      ** Reset Read Next Browse Subfile Record indicator.

     C                   EVAL      WRdNBrw = *BLANK

      ** Display browse screen.

     C                   CALLB     'SDMCMGBRW'

      ** INPUT
      ** =====

      ** Return code

     C                   PARM      *BLANKS       RetCodeOut

      ** Action Code

     C                   PARM                    POption

      ** Key fields (file pointer)

     C                   PARM                    PFuntPtr
     C                   PARM                    PIdenPtr
     C                   PARM                    PBrchPtr

      ** Build subfile

     C                   PARM      'Y'           PBdSfl

      ** Read subfile record

     C                   PARM      *BLANK        PRdSfl

      ** OK Option Code

     C                   PARM                    OKOPTN

      ** OK Function Type

     C                   PARM                    OKITEM

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    IDx

      ** Standing Data:

      ** Midas Rundate from SDBANKPD

     C                   PARM                    BJMRDT

      ** Single Branch Code from SDBANKPD

     C                   PARM                    BJSBRC
      *
      ** SWITCHABLE FEATURES                                                                  CSD019
      ** ===================                                                                  CSD019
                                                                                              CSD019
     C                   PARM                    CSD019                                       CSD019
                                                                                              CSD019
      ** OUTPUT
      ** ======

      ** Error message

     C                   PARM                    PErrMs

      ** Option selected

     C                   PARM                    POpSel

      ** Key field selected
      **  Function Type
      **  Identifier
      **  Branch

     C                   PARM                    PFuntSel
     C                   PARM                    PIdenSel
     C                   PARM                    PBrchSel

      ** Function keys enabled
      ** KC = Command key 03 = Exit
     C                   PARM      *OFF          PINKC

      ** KE = Command key 05 = Refresh
     C                   PARM      *OFF          PINKE

      ** Reset error fields.

     C                   EXSR      SRResetErr

     C                   SELECT

      ** F3 - End program.

     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP

      ** F5 - Refresh

     C                   WHEN      PINKE = *ON

     C                   EVAL       PFuntPtr = *BLANKS
     C                   EVAL       PIdenPtr = *BLANKS
     C                   EVAL       PBrchPtr = *BLANKS

      ** Error message returned from browse.

     C                   WHEN      PErrMs <> *BLANKS
     C                   EXSR      SRSndM

      ** Enter - read selected subfile records.

     C                   OTHER

     C                   EVAL      WRdNBrw = 'Y'
     C                   EVAL      WScrn   = 'R'

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *****************************************************************
     C     SRRdNBrw      BEGSR

      ** Display browse screen.

     C                   CALLB     'SDMCMGBRW'

      ** Input
      ** =====

      ** Return code

     C                   PARM      *BLANKS       RetCodeOut

      ** Action Code

     C                   PARM                    POption

      ** Key fields (file pointer)

     C                   PARM                    PFuntPtr
     C                   PARM                    PIdenPtr
     C                   PARM                    PBrchPtr
      *
      ** Build subfile
     C                   PARM      *BLANK        PBdSfl
      *
      ** Read subfile record
     C                   PARM      'Y'           PRdSfl

      ** OK Option Code

     C                   PARM                    OKOPTN

      ** OK Function Type

     C                   PARM                    OKITEM

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    IDx

      ** Standing Data:

      ** Midas Rundate from SDBANKPD

     C                   PARM                    BJMRDT

      ** Single Branch Code from SDBANKPD

     C                   PARM                    BJSBRC

      ** SWITCHABLE FEATURES                                                                  CSD019
      ** ===================                                                                  CSD019
                                                                                              CSD019
     C                   PARM                    CSD019                                       CSD019
                                                                                              CSD019
      ** Output
      ** ======

      ** Error message

     C                   PARM                    PErrMs

      ** Option selected

     C                   PARM                    POpSel

      ** Key field selected
      **  Function Type
      **  Identifier
      **  Branch

     C                   PARM                    PFuntSel
     C                   PARM                    PIdenSel
     C                   PARM                    PBrchSel

      ** Function keys enabled
      ** KC = Command key 03 = Exit

     C                   PARM      *OFF          PINKC

      ** KE = Command key 05 = Refresh

     C                   PARM      *OFF          PINKE

      ** If no Item in the Case Management is selected,
      ** reset read next browse subfile record indicator and then
      ** display browse screen.

     C                   IF        POpSel = *BLANK
     C                   EVAL      PFuntPtr = PFuntSel
     C                   EVAL      PIdenPtr = PIdenSel
     C                   EVAL      PBrchPtr = PBrchSel
     C                   EVAL      WRdNBrw = *BLANK
     C                   EVAL      WScrn   = 'B'
     C                   GOTO      ESRRdNBrw
     C                   ENDIF

      ** Update action code with option selected.

     C                   EVAL      POption = POpSel

      ** Retrieve Item Selected

     C                   EXSR      SRRtvCWHT

      ** If warning or error occurred, display messages.

     C                   IF        WIDx <> *ZERO OR IDx = 1 OR IDx > 1 AND
     C                             MsgIdArr(1) <> 'APM1000'
     C                   EVAL      WScrn = 'B'
     C                   EVAL      PFuntPtr = PFuntSel
     C                   EVAL      PIdenPtr = PIdenSel
     C                   EVAL      PBrchPtr = PBrchSel
     C                   GOTO      ESRRdNBrw
     C                   ENDIF

      ** Move the Item details from the master database file
      ** into the update file record.

     C                   EVAL      NwCWFilFmt = CrCWFilFmt
                                                                                              CSD019
     C                   IF        CSD019 = 'Y' AND POpSel = 'E'                              CSD019
     C                   EVAL      WScrn = 'M'                                                CSD019
     C                   LEAVESR                                                              CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   IF        POpSel = 'W'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   EVAL      WScrn = 'U'
     C                   ENDIF

     C     ESRRdNBrw     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCWHT - Retrieve Item's details.                         *
      *                                                               *
      *****************************************************************
     C     SRRtvCWHT     BEGSR

     C                   CALLB     'SDMCMGRTV'

      ** INPUT
      ** =====

      ** Retun code
     C                   PARM      *BLANKS       RetCodeOut

      ** Response mode

     C                   PARM                    PRespMode

      ** Action code

     C                   PARM                    POption

      ** Function Type

     C                   PARM                    PFuntSel

      ** Identifier

     C                   PARM                    PIdenSel

      ** Identifier

     C                   PARM                    PBrchSel

      ** STANDING DATA
      ** =============

      ** Single Branch Code from SDBANKPD

     C                   PARM                    BJSBRC

      ** Default Branch ZMUSER

     C                   PARM                    DBRN

      ** SWITCHABLE FEATURES                                                                  CSD019
      ** ===================                                                                  CSD019
                                                                                              CSD019
     C                   PARM                    CSD019                                       CSD019
                                                                                              CSD019
      ** OUTPUT
      ** ======

      ** Current HELD ITEM IN THE CASE MANAGEMENT retrieved from file - file format

     C                   PARM                    CrCWFilFmt

      ** OK Option Code

     C                   PARM                    OKOPTN

      ** OK Function Type

     C                   PARM                    OKITEM

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    IDx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - Set program to end   OK                             *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR

      ** Issue rollback to clear any possible updates in lower
      ** level programs.

     C                   ROLBK

      ** Set processing to end program.

     C                   EVAL      WScrn = 'E'

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR

      ** If single branching, user cannot browse file.

     C                   IF        PErrMs = 'FXM0292'
     C                   EVAL      OKOPTN = 'N'
     C                   ENDIF

      ** Add error message to array passed to screen.

     C                   Z-ADD     1             Ex
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   EVAL      FldNameArr(Ex) = '*ANY'
     C                   EVAL      MsgIdArr(Ex) = PErrMs

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset error fields  OK                          *
      *                                                               *
      *****************************************************************
     C     SRResetErr    BEGSR

      ** Reset error fields.

     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IDx

     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIDx

      ** Initialise screen fields error indicators.

     C                   EVAL      OKOPTN = 'Y'
     C                   EVAL      OKITEM = 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWatch - Run Watch List Checker                            *
      *                                                               *
      *****************************************************************
     C     SrWatch       BEGSR

      ** Setup the Key to be used to access the Main Database file.

     C                   EXSR      SrSetKey

      ** Access the details from the main database file.
      ** Set-up Parameters 1 and 2

     C                   EXSR      SrSetParm


      ** If the 2nd Parameter is non-blank, send Transaction Details to
      ** Compliance Watch by Calling the Engine Program.

     C                   EXSR      SrEngine

      ** If no error occured,

     C                   IF        OKITEM <> 'N' AND OKOPTN <> 'N'

      ** Read next browse subfile record.

     C                   IF        WRdNBrw = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF

     C                   ELSE

     C                   EVAL      PFuntPtr = PFuntSel
     C                   EVAL      PIdenPtr = PIdenSel
     C                   EVAL      PBrchPtr = PBrchSel

     C                   ENDIF

     C                   ENDSR
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SrMatch - Run Watch List Match Enquiry                       *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
     C     SRMatch       BEGSR                                                                CSD019
                                                                                              CSD019
     C                   CALL      'SDCWLMENQ'                                                CSD019
                                                                                              CSD019
      ** Return Code                                                                          CSD019
     C                   PARM      *BLANKS       PRetCde                                      CSD019
                                                                                              CSD019
      ** Function Type                                                                        CSD019
     C                   PARM                    PFuntSel                                     CSD019
                                                                                              CSD019
      ** Identifier                                                                           CSD019
     C                   PARM                    PIdenSel                                     CSD019
                                                                                              CSD019
      ** Branch                                                                               CSD019
     C                   PARM                    PBrchSel                                     CSD019
                                                                                              CSD019
     C                   IF        PRetCde = '*EXIT'                                          CSD019
     C                   EVAL      WScrn = 'E'                                                CSD019
     C                   ELSE                                                                 CSD019
     C                   EVAL      WScrn = 'B'                                                CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetKey  - Setup the Key to be used to access Main          *
      *              Database File                                    *
      *                                                               *
      *****************************************************************
     C     SrSetKey      BEGSR

     C                   EXSR      SrInitKeys

     C                   SELECT

      ** Lending

     C                   WHEN      PFuntSel = 'CLOANCL '
     C                             OR PFuntSel = 'CLOANCK '
     C                   MOVEL     PIdenSel      K_Lnrf

     C                   WHEN      PFuntSel = 'LEFEED  '
     C                             OR PFuntSel = 'LEFEEAD '
     C                   IF        %SUBST(PIdenSel:9:22) = *BLANKS
     C                   MOVEL     PIdenSel      W_Lef_1
     C                   EVAL      K_Fseq1 = W_Fseq_1
     C                   ELSE
     C                   MOVEL     PIdenSel      W_Lef_2
     C                   EVAL      K_Fseq2 = W_Fseq_2
     C                   ENDIF

     C                   WHEN      PFuntSel = 'LOAMSDK '
     C                   MOVEL     PIdenSel      W_Loam

      ** Standing Data

     C                   WHEN      PFuntSel = 'SDCUSTPD'
     C                   EVAL      K_Bbcust = PIdenSel

     C                   WHEN      PFuntSel = 'SDACUSPD'
     C                   EVAL      K_E5cust = PIdenSel

     C                   WHEN      PFuntSel = 'SDALTNPD'
     C                   EVAL      K_Bccust = PIdenSel

     C                   WHEN      PFuntSel = 'CGCORRPD'
     C                   EVAL      K_Cdcorr = PIdenSel

     C                   WHEN      PFuntSel = 'ACCNTAB '
     C                   MOVEL     PIdenSel      W_Accntab

     C                   WHEN      PFuntSel = 'SDEXSTPD'
     C                   MOVEL     PIdenSel      W_Sdexstpd

      ** Retail

     C                   WHEN      PFuntSel = 'STANDSB '
     C                   MOVEL     PIdenSel      K_Stor

      ** Futures and Options

     C                   WHEN      PFuntSel = 'TRANSD  '
     C                   MOVEL     PIdenSel      K_Tnbr

      ** Securities

     C                   WHEN      PFuntSel = 'TRADSD  '
     C                   MOVEL     PIdenSel      K_Tdrf

     C                   WHEN      PFuntSel = 'DPTMVD  '
     C                   MOVEL     PIdenSel      K_Dprn

     C                   WHEN      PFuntSel = 'POSETD  '
     C                   MOVEL     PIdenSel      W_Posetd

      ** Funds Transfer

     C                   WHEN      PFuntSel = 'INPAYDD '
     C                   MOVEL     PIdenSel      K_Pref

     C                   WHEN      PFuntSel = 'OTPAYDD '
     C                   MOVEL     PIdenSel      K_Pref

     C                   WHEN      PFuntSel = 'FT101HPD'
     C                   MOVEL     PIdenSel      K_RftId

     C                   WHEN      PFuntSel = 'FT102HPD'
     C                   MOVEL     PIdenSel      K_H2Cctid

     C                   WHEN      PFuntSel = 'CQCOCDD '
     C                   MOVEL     PIdenSel      K_Pref

     C                   WHEN      PFuntSel = 'CQPACDD '
     C                   MOVEL     PIdenSel      K_Pref

     C                   WHEN      PFuntSel = 'NTRANDD '
     C                   MOVEL     PIdenSel      K_Tfrf

      ** Dealing

     C                   WHEN      PFuntSel = 'DEALSDB '
     C                   MOVEL     PIdenSel      K_Dlno

     C                   WHEN      PFuntSel = 'DEALSDG '
     C                   MOVEL     PIdenSel      K_Dlno

     C                   WHEN      PFuntSel = 'FXCLSPSH'
     C                   MOVEL     PIdenSel      W_FXCLSPSH

     C                   WHEN      PFuntSel = 'MMDEAMPP'
     C                   MOVEL     PIdenSel      W_Mmdeampp

     C                   WHEN      PFuntSel = 'FXNETMPD'
     C                   MOVEL     PIdenSel      K_Amnetr

     C                   WHEN      PFuntSel = 'FXDEALPP'
     C                   MOVEL     PIdenSel      K_Fhdn38

     C                   WHEN      PFuntSel = 'MMDELDPP'
     C                   MOVEL     PIdenSel      K_Hkdn38

     C                   WHEN      PFuntSel = 'MMDENBPP'
     C                   MOVEL     PIdenSel      K_Hldn38

     C                   WHEN      PFuntSel = 'MMDENSPP'
     C                   MOVEL     PIdenSel      K_Hmdn38

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitKeys - Initialize the Keys                             *
      *                                                               *
      *****************************************************************
     C     SrInitKeys    BEGSR

      ** Lending

     C**********         EVAL      K_Lnrf  = *ZERO                                            CLE148
     C                   EVAL      K_Lnrf  = *BLANKS                                          CLE148
     C**********         EVAL      K_Cnum = *ZERO                                             CSD027
     C                   EVAL      K_Cnum = *BLANKS                                           CSD027
     C                   EVAL      K_Facl = *ZERO
     C**********         EVAL      K_Loan1 = *ZERO                                            CLE148
     C**********         EVAL      K_Loan2 = *ZERO                                            CLE148
     C                   EVAL      K_Loan1 = *BLANKS                                          CLE148
     C                   EVAL      K_Loan2 = *BLANKS                                          CLE148
     C                   EVAL      W_Fseq_1 = *ZERO
     C                   EVAL      W_Fseq_2 = *ZERO
     C                   EVAL      K_Fseq1  = *ZERO
     C                   EVAL      K_Fseq2  = *ZERO
     C                   EVAL      K_Vdat = *ZERO
     C                   EVAL      K_Lasn = *ZERO

      ** Standing Data

     C                   EVAL      K_Bbcust = *BLANKS
     C                   EVAL      K_E5cust = *BLANKS
     C                   EVAL      K_Bccust = *BLANKS
     C                   EVAL      K_Cdcorr = *BLANKS
     C                   EVAL      K_Brca = *BLANKS
     C**********         EVAL      K_CnumX = *ZERO                                            CSD027
     C                   EVAL      K_CnumX = *BLANKS                                          CSD027
     C                   EVAL      K_Ccy = *BLANKS
     C                   EVAL      K_Acod = *ZERO
     C                   EVAL      K_Acsq = *ZERO
     C                   EVAL      K_Bycycd = *BLANKS
     C                   EVAL      K_Bycust = *BLANKS
     C                   EVAL      K_Bytrty = *BLANKS

      ** Retail

     C                   EVAL      K_Stor = *ZERO

      ** Futures and Options

     C                   EVAL      K_Tnbr = *ZERO

      ** Securities

     C                   EVAL      K_Tdrf = *BLANKS
     C                   EVAL      K_Dprn = *BLANKS
     C                   EVAL      K_Pbca = *BLANKS
     C                   EVAL      K_Pssh = *BLANKS
     C**********         EVAL      K_Pcpy = *ZERO                                             CSD027
     C                   EVAL      K_Pcpy = *BLANKS                                           CSD027
     C                   EVAL      K_Pdud = *ZERO
     C                   EVAL      K_Pevt = *BLANKS

      ** Funds Transfer

     C                   EVAL      K_Pref = *BLANKS
     C                   EVAL      K_RftId = *BLANKS
     C                   EVAL      K_H2Cctid = *BLANKS
     C                   EVAL      K_Tfrf = *BLANKS

      ** Dealing

     C                   EVAL      K_Dlno = *ZERO
     C                   EVAL      K_Pyccy = *BLANKS
     C                   EVAL      K_Pynost = *BLANKS
     C                   EVAL      K_Pyvald = *ZERO
     C                   EVAL      K_Pyseqn = *ZERO
     C                   EVAL      K_Hnda38 = *ZERO
     C                   EVAL      K_Hnvdyy = *ZERO
     C                   EVAL      K_Hnvdmm = *ZERO
     C                   EVAL      K_Hnvddd = *ZERO
     C                   EVAL      K_Hnds38 = *ZERO
     C                   EVAL      K_Amnetr = *BLANKS
     C                   EVAL      K_Fhdn38 = *ZERO
     C                   EVAL      K_Hkdn38 = *ZERO
     C                   EVAL      K_Hldn38 = *ZERO
     C                   EVAL      K_Hmdn38 = *ZERO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetParm- Access the details from the main database file.   *
      *             Set-up Parameters 1 and 2                         *
      *                                                               *
      *****************************************************************
     C     SrSetParm     BEGSR

     C                   SELECT

      ** Lending

     C                   WHEN      PFuntSel = 'CLOANCL '
     C                   EXSR      SrParmCloancl

     C                   WHEN      PFuntSel = 'LEFEED  '
     C                   EXSR      SrParmLefeed

     C                   WHEN      PFuntSel = 'LEFEEAD '
     C                   EXSR      SrParmLefeead

     C                   WHEN      PFuntSel = 'CLOANCK '
     C                   EXSR      SrParmCloanck

     C                   WHEN      PFuntSel = 'LOAMSDK '
     C                   EXSR      SrParmLoamsdk

      ** Standing Data

     C                   WHEN      PFuntSel = 'SDCUSTPD'
     C                   IF        CSD012 = 'Y'
     C                   EXSR      SrParmXSDCust
     C                   ELSE
     C                   EXSR      SrParmSdcustpd
     C                   ENDIF

     C                   WHEN      PFuntSel = 'SDACUSPD'
     C                   EXSR      SrParmSdacuspd

     C                   WHEN      PFuntSel = 'SDALTNPD'
     C                   IF        CSD012 = 'Y'
     C                   EXSR      SrParmXSDAltn
     C                   ELSE
     C                   EXSR      SrParmSdaltnpd
     C                   ENDIF

     C                   WHEN      PFuntSel = 'CGCORRPD'
     C                   EXSR      SrParmCgcorrpd

     C                   WHEN      PFuntSel = 'ACCNTAB '
     C                   IF        CSD012 = 'Y'
     C                   EXSR      SrParmXAccnt
     C                   ELSE
     C                   EXSR      SrParmAccntab
     C                   ENDIF

     C                   WHEN      PFuntSel = 'SDEXSTPD'
     C                   EXSR      SrParmSdexstpd

      ** Retail

     C                   WHEN      PFuntSel = 'STANDSB '
     C                   EXSR      SrParmStandsb

      ** Futures and Options

     C                   WHEN      PFuntSel = 'TRANSD  '
     C                   EXSR      SrParmTransd

      ** Securities

     C                   WHEN      PFuntSel = 'TRADSD  '
     C                   EXSR      SrParmTradsd

     C                   WHEN      PFuntSel = 'DPTMVD  '
     C                   EXSR      SrParmDptmvd

     C                   WHEN      PFuntSel = 'POSETD  '
     C                   EXSR      SrParmPosetd

      ** Funds Transfer

     C                   WHEN      PFuntSel = 'INPAYDD '
     C                   EXSR      SrParmInpaydd

     C                   WHEN      PFuntSel = 'OTPAYDD '
     C                   EXSR      SrParmOtpaydd

     C                   WHEN      PFuntSel = 'FT101HPD'
     C                   EXSR      SrParmFt101hpd

     C                   WHEN      PFuntSel = 'FT102HPD'
     C                   EXSR      SrParmFt102hpd

     C                   WHEN      PFuntSel = 'CQCOCDD '
     C                   EXSR      SrParmCqcocdd

     C                   WHEN      PFuntSel = 'CQPACDD '
     C                   EXSR      SrParmCqpacdd

     C                   WHEN      PFuntSel = 'NTRANDD '
     C                   EXSR      SrParmNtrandd

      ** Dealing

     C                   WHEN      PFuntSel = 'DEALSDB '
     C                   EXSR      SrParmDealsdb

     C                   WHEN      PFuntSel = 'DEALSDG '
     C                   EXSR      SrParmDealsdg

     C                   WHEN      PFuntSel = 'FXCLSPSH'
     C                   EXSR      SrParmFxclspsh

     C                   WHEN      PFuntSel = 'MMDEAMPP'
     C                   EXSR      SrParmMmdeampp

     C                   WHEN      PFuntSel = 'FXNETMPD'
     C                   EXSR      SrParmFxnetmpd

     C                   WHEN      PFuntSel = 'FXDEALPP'
     C                   EXSR      SrParmFxdealpp

     C                   WHEN      PFuntSel = 'MMDELDPP'
     C                   EXSR      SrParmMmdeldpp

     C                   WHEN      PFuntSel = 'MMDENBPP'
     C                   EXSR      SrParmMmdenbpp

     C                   WHEN      PFuntSel = 'MMDENSPP'
     C                   EXSR      SrParmMmdenspp

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmCloancl - Setup the Parameters 1 and 2 for CLOANCL     *
      *                                                               *
      *****************************************************************
     C     SrParmCloancl BEGSR

     C     K_Lnrf        CHAIN     LELOANL0
     C                   IF        NOT %FOUND(LELOANL0)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   EVAL      PCurrency= CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     LNRF          W4IDEN

      ** If generated by Principal Transfer, Item Type Code is 'LEPTFR'.
      ** Otherwise, LE + PTYP.

     C                   IF        GPRT = 'Y'
     C                   EVAL      W4ITEM = 'LEPTFR'
     C                   ELSE
     C                   MOVEL     PTYP          WWPTYP
     C     'LE'          CAT       WWPTYP:0      W4ITEM
     C                   ENDIF

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'CLOANCL '

      ** Counter Party Number

     C                   MOVEL     CNUM          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     CNUM          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     DDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     VDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     MDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate


      ** Denomination Side 1

     C                   EVAL      W4DEN1 = CCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      CPAM          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  008
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmLefeed  - Setup the Parameters 1 and 2 for LEFEED      *
      *                                                               *
      *****************************************************************
     C     SrParmLefeed  BEGSR

     C**********         IF        K_Loan1 <> *ZERO                                           CLE148
     C                   IF        K_Loan1 <> *BLANKS                                         CLE148
     C     K_Lef1        CHAIN     LEFEEDL5

     C                   IF        NOT %FOUND(LEFEEDL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ENDIF

     C                   ELSE

     C     K_Lef2        CHAIN     LEFEEDL0

     C                   IF        NOT %FOUND(LEFEEDL0)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ENDIF

     C                   ENDIF

     C                   IF        OKITEM <> 'N' AND OKOPTN <> 'N'

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   EVAL      PCurrency = FEFCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   EVAL      PCurrency = FEFCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier
      **

     C                   MOVEL     FECNUM        WCNUM
     C                   MOVEL     FEFACL        WFACL
     C                   MOVEL     FEFSEQ        WFSEQ
     C                   MOVEL     FELOAN        WLOAN

     C**********         IF        FELOAN = *ZERO                                             CLE148
     C                   IF        FELOAN = *BLANKS                                           CLE148
     C                   EVAL      W4IDEN = WCNUM + WFACL + WFSEQ
     C                   ELSE
     C                   EVAL      W4IDEN = WLOAN + WFSEQ
     C                   ENDIF

      ** Item Type Code

     C                   EVAL      W4ITEM = 'LEFEE'

      ** Branch

     C                   EVAL      W4BRCH = FEBRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'LEFEED  '

      ** Counter Party Number

     C                   MOVEL     FECNUM        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     FECNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  009
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  010
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     FEPSTD        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  011
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     FEPEND        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  012
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = FEFCCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      FEFAMT        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  013
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmLefeead - Setup the Parameters 1 and 2 for LEFEEAD     *
      *                                                               *
      *****************************************************************
     C     SrParmLefeead BEGSR

     C**********         IF        K_Loan1 <> *ZERO                                           CLE148
     C                   IF        K_Loan1 <> *BLANKS                                         CLE148
     C     K_Lef1        CHAIN     LEFEEAL5

     C                   IF        NOT %FOUND(LEFEEAL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ENDIF

     C                   ELSE

     C     K_Lef2        CHAIN     LEFEEAL0

     C                   IF        NOT %FOUND(LEFEEAL0)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ENDIF

     C                   ENDIF

     C                   IF        OKITEM <> 'N' AND OKOPTN <> 'N'

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   EVAL      PCurrency = FAFCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   EVAL      PCurrency = FAFCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     FACNUM        WCNUM
     C                   MOVEL     FAFACL        WFACL
     C                   MOVEL     FAFSEQ        WFSEQ
     C                   MOVEL     FALOAN        WLOAN

     C**********         IF        FALOAN = *ZERO                                             CLE148
     C                   IF        FALOAN = *BLANKS                                           CLE148
     C                   EVAL      W4IDEN = WCNUM + WFACL + WFSEQ
     C                   ELSE
     C                   EVAL      W4IDEN = WLOAN + WFSEQ
     C                   ENDIF

      ** Item Type Code

     C                   EVAL      W4ITEM = 'LEFESA'

      ** Branch

     C                   EVAL      W4BRCH = FABRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'LEFEEAD '

      ** Counter Party Number

     C                   MOVEL     FACNUM        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     FACNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  014
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  015
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     FASADD        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  016
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  017
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = FAFCCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      FASADJ        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  018
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmCloanck - Setup the Parameters 1 and 2 for CLOANCK     *
      *                                                               *
      *****************************************************************
     C     SrParmCloanck BEGSR

     C     K_Lnrf        CHAIN     LELOANL2
     C     K_Lnrf        CHAIN     LELOANL0
     C                   IF        NOT %FOUND(LELOANL2)
     C                             OR NOT %FOUND(LELOANL0)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        RRON <> *BLANKS
     C                   EVAL      PInput1 = RRON
     C                   EVAL      PCurrency = CCY
     C                   IF        NCCY <> *BLANKS
     C                   IF        PTYP = 66 OR PTYP = 67 OR PTYP = 69
     C                   EVAL      PCurrency = NCCY
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RRIB <> *BLANKS OR RRBA <> *BLANKS
     C                   EVAL      PInput1 = RRIB
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RRBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        RROB <> *ZERO                                              CSD027
     C                   IF        RROB <> *BLANKS                                            CSD027
     C                   MOVEL     RROB          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        RROC <> *ZERO                                              CSD027
     C                   IF        RROC <> *BLANKS                                            CSD027
     C                   MOVEL     RROC          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        RPON <> *BLANKS
     C                   EVAL      PInput1 = RPON
     C                   EVAL      PCurrency = CCY
     C                   IF        NCCY <> *BLANKS
     C                             AND PTYP <> 66 AND PTYP <> 67 AND PTYP <> 69
     C                   EVAL      PCurrency = NCCY
     C                   ENDIF

     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        RPIB <> *BLANKS OR RPBA <> *BLANKS
     C                   EVAL      PInput1 = RPIB
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RPBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        RPOB <> *ZERO                                              CSD027
     C                   IF        RPOB <> *BLANKS                                            CSD027
     C                   MOVEL     RPOB          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        RPOC <> *ZERO                                              CSD027
     C                   IF        RPOC <> *BLANKS                                            CSD027
     C                   MOVEL     RPOC          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RRCR <> *BLANKS OR RRCA <> *BLANKS
     C                   EVAL      PInput1 = RRCR
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RRCA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RRVN <> *BLANKS
     C                   EVAL      PInput1 = RRVN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        RAWB <> *BLANKS OR RAWA <> *BLANKS
     C                   EVAL      PInput1 = RAWB
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RAWA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        RBEN <> *BLANKS OR RBNA <> *BLANKS
     C                   EVAL      PInput1 = RBEN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RBNA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        RDP1 <> *BLANKS OR RDP2 <> *BLANKS
     C                             OR RDP3 <> *BLANKS OR RDP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       RDP1:0        P_XML
     C     P_XML         CAT       RDP2:0        P_XML
     C     P_XML         CAT       RDP3:0        P_XML
     C     P_XML         CAT       RDP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     LNRF          W4IDEN

      ** Item Type Code

     C                   EVAL      W4ITEM = 'LEROLL'

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'CLOANCK '

      ** Counter Party Number

     C                   MOVEL     CNUM          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     CNUM          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  019
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  020
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     RLDT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  021
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   IF        NMDT <> *ZERO
     C                   MOVEL     NMDT          PInDate
     C                   ELSE
     C                   MOVEL     MDAT          PInDate
     C                   ENDIF

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  022
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   IF        NCCY <> *BLANKS
     C                   EVAL      W4DEN1 = NCCY
     C                   ELSE
     C                   EVAL      W4DEN1 = CCY
     C                   ENDIF

      ** Denomination Side 2 (W4DEN2)

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   IF        (PTYP = 63 OR PTYP = 65 OR PTYP = 67)
     C                             AND NCCY = *BLANKS
     C                   MOVE      NPRAM         PInAmt
     C                   ELSE
     C                   IF        NCCY <> *BLANKS
     C                   MOVE      NCPA          PInAmt
     C                   ENDIF
     C                   ENDIF

     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  023
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmLoamsdk - Setup the Parameters 1 and 2 for LOAMSDK     *
      *                                                               *
      *****************************************************************
     C     SrParmLoamsdk BEGSR

     C     K_Loamsdk     CHAIN     LELOAML0
     C                   IF        NOT %FOUND(LELOAML0)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF


      ** Pay Ordering Bank

     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     LNRF          WLNRF
     C                   MOVEL     VDAT          WVDAT
     C                   MOVEL     LASN          WLASN

     C                   EVAL      W4Iden = WLNRF + WVDAT + WLASN

      ** Item Type Code

     C                   SELECT
     C                   WHEN      AMTP = 'PI'
     C                   EVAL      W4ITEM = 'LEAMD '
     C                   WHEN      AMTP = 'MR'
     C                   EVAL      W4ITEM = 'LERPAY'
     C                   WHEN      AMTP = 'RE'
     C                   EVAL      W4ITEM = 'LESCHD'
     C                   WHEN      AMTP = 'PT' or AMTP = 'PF'
     C                   EVAL      W4ITEM = 'LEPTFR'
     C                   ENDSL

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'LOAMSDK '

      ** Counter Party Number

     C                   MOVEL     CNUM          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     CNUM          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  024
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST


      ** Deal Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  025
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     VDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  026
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  027
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = CCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      TAMT          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  028
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmSdcustpd - Setup the Parameters 1 and 2 for SDCUSTPD   *
      *                                                               *
      *****************************************************************
     C     SrParmSdcustpdBEGSR

     C     K_Bbcust      CHAIN     SDCUSTL5
     C                   IF        NOT %FOUND(SDCUSTL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        BBCNA1 <> *BLANKS
     C     P_XML         CAT       OpenTag(14):0 P_XML
     C     P_XML         CAT       BBCNA1:0      P_XML
     C     P_XML         CAT       ClosTag(14):0 P_XML
     C                   EndIf

     C                   If        BBCNA2 <> *BLANKS
     C                             OR BBCNA3 <> *BLANKS
     C                             OR BBCNA4 <> *BLANKS
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       BBCNA2:0      P_XML
     C     P_XML         CAT       BBCNA3:1      P_XML
     C     P_XML         CAT       BBCNA4:1      P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   EndIf

     C                   If        BBCSID <> *BLANKS
     C     P_XML         CAT       OpenTag(16):0 P_XML
     C     P_XML         CAT       BBCSID:0      P_XML
     C     P_XML         CAT       ClosTag(16):0 P_XML
     C                   EndIf

     C                   If        BBCNCZ <> *BLANKS
     C     P_XML         CAT       OpenTag(17):0 P_XML
     C     P_XML         CAT       BBCNCZ:0      P_XML
     C     P_XML         CAT       ClosTag(17):0 P_XML
     C                   EndIf

     C                   If        BBCOLC <> *BLANKS
     C     P_XML         CAT       OpenTag(18):0 P_XML
     C     P_XML         CAT       BBCOLC:0      P_XML
     C     P_XML         CAT       ClosTag(18):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     BBCUST        W4IDEN

      ** Item Type Code

     C                   EVAL      W4ITEM = 'SDCUSD'

      ** Branch

     C                   MOVEL     BBBRCD        W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'SDCUSTPD'

      ** Counter Party Number

     C                   MOVE      BBCUST        W4CNUM

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = BBCRNM + BBCRTN

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmXSDCust - Setup the Parameters 1 and 2 for SDCUSTPD    *
      *                  for Standing Data Authorisation              *
      *                                                               *
      *****************************************************************
     C     SrParmXSDCust BEGSR

     C     K_Bbcust      CHAIN     SDCDSHL0
     C                   IF        NOT %FOUND(SDCDSHL0)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        T_BBCNA1 <> *BLANKS
     C     P_XML         CAT       OpenTag(14):0 P_XML
     C     P_XML         CAT       T_BBCNA1:0    P_XML
     C     P_XML         CAT       ClosTag(14):0 P_XML
     C                   EndIf

     C                   If        T_BBCNA2 <> *BLANKS
     C                             OR T_BBCNA3 <> *BLANKS
     C                             OR T_BBCNA4 <> *BLANKS
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       T_BBCNA2:0    P_XML
     C     P_XML         CAT       T_BBCNA3:1    P_XML
     C     P_XML         CAT       T_BBCNA4:1    P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   EndIf

     C                   If        T_BBCSID <> *BLANKS
     C     P_XML         CAT       OpenTag(16):0 P_XML
     C     P_XML         CAT       T_BBCSID:0    P_XML
     C     P_XML         CAT       ClosTag(16):0 P_XML
     C                   EndIf

     C                   If        T_BBCNCZ <> *BLANKS
     C     P_XML         CAT       OpenTag(17):0 P_XML
     C     P_XML         CAT       T_BBCNCZ:0    P_XML
     C     P_XML         CAT       ClosTag(17):0 P_XML
     C                   EndIf

     C                   If        T_BBCOLC <> *BLANKS
     C     P_XML         CAT       OpenTag(18):0 P_XML
     C     P_XML         CAT       T_BBCOLC:0    P_XML
     C     P_XML         CAT       ClosTag(18):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     T_BBCUST      W4IDEN

      ** Item Type Code

     C                   EVAL      W4ITEM = 'SDCUSD'

      ** Branch

     C                   MOVEL     T_BBBRCD      W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'SDCUSTPD'

      ** Counter Party Number

     C                   MOVE      T_BBCUST      W4CNUM

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        T_BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        T_BBLICD <> *BLANKS
     C                             AND T_BBLICD <> W1IND1
     C                             AND T_BBLICD <> W1IND2
     C                             AND T_BBLICD <> W1IND3
     C                             AND T_BBLICD <> W1IND4
     C                             AND T_BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = T_BBCRNM + T_BBCRTN

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmSdacuspd - Setup the Parameters 1 and 2 for SDACUSPD   *
      *                                                               *
      *****************************************************************
     C     SrParmSdacuspdBEGSR

     C     K_E5cust      CHAIN     SDACUSL1

     C                   IF        NOT %FOUND(SDACUSL1) OR E5TYLC = 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE
     C     E5CUST        CHAIN     SDCUSTL5

     C                   IF        NOT %FOUND(SDCUSTL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        E5CNA1 <> *BLANKS
     C     P_XML         CAT       OpenTag(14):0 P_XML
     C     P_XML         CAT       E5CNA1:0      P_XML
     C     P_XML         CAT       ClosTag(14):0 P_XML
     C                   EndIf

     C                   If        E5CNA2 <> *BLANKS
     C                             OR E5CNA3 <> *BLANKS
     C                             OR E5CNA4 <> *BLANKS
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       E5CNA2:0      P_XML
     C     P_XML         CAT       E5CNA3:1      P_XML
     C     P_XML         CAT       E5CNA4:1      P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   EndIf

     C                   If        E5IDNO <> *BLANKS
     C     P_XML         CAT       OpenTag(19):0 P_XML
     C     P_XML         CAT       E5IDNO:0      P_XML
     C     P_XML         CAT       ClosTag(19):0 P_XML
     C                   EndIf

     C                   If        E5BRTH <> *ZERO

     C                   CALLB     'ZA0140M'
     C                   PARM                    PRetCode
     C                   PARM                    E5BRTH
     C                   PARM                    PDateFormat
     C                   PARM                    PDate6
     C                   PARM                    PDate7
     C                   PARM                    PDate8
     C                   PARM                    PDummy8

     C                   Move      PDate8        WDateY
     C                   Eval      WDOB = %SUBST(PDate7:1:5)
     C                   EVAL      WDOBTMP = %SUBST(WDateY:1:4)
     C     WDOB          CAT       WDOBTMP:0     WDOB

     C     P_XML         CAT       OpenTag(20):0 P_XML
     C     P_XML         CAT       WDOB:0        P_XML
     C     P_XML         CAT       ClosTag(20):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     E5CUST        W4IDEN

      ** Item Type Code

     C                   EVAL      W4ITEM = 'SDCUSA'

      ** Branch

     C                   MOVEL     BBBRCD        W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'SDACUSPD'

      ** Counter Party Number

     C                   MOVE      BBCUST        W4CNUM

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE
      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = BBCRNM + BBCRTN

      ** Amount Side 1

     C                   EVAL      W4AMT1 = *ZERO

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmSdaltnpd - Setup the Parameters 1 and 2 for SDALTNPD   *
      *                                                               *
      *****************************************************************
     C     SrParmSdaltnpdBEGSR

     C     K_Bccust      CHAIN     SDALTNL3

     C                   IF        NOT %FOUND(SDALTNL3)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE
     C     BCCUST        CHAIN     SDCUSTL5

     C                   IF        NOT %FOUND(SDCUSTL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        BCCNA1 <> *BLANKS
     C     P_XML         CAT       OpenTag(21):0 P_XML
     C     P_XML         CAT       BCCNA1:0      P_XML
     C     P_XML         CAT       ClosTag(21):0 P_XML
     C                   EndIf

     C                   If        BCCNA2 <> *BLANKS
     C                             OR BCCNA3 <> *BLANKS
     C                             OR BCCNA4 <> *BLANKS
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       BCCNA2:0      P_XML
     C     P_XML         CAT       BCCNA3:1      P_XML
     C     P_XML         CAT       BCCNA4:1      P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   EndIf

     C                   If        BCCNCD <> *BLANKS
     C     P_XML         CAT       OpenTag(18):0 P_XML
     C     P_XML         CAT       BCCNCD:0      P_XML
     C     P_XML         CAT       ClosTag(18):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     BCCUST        W4IDEN

      ** Item Type Code

     C                   EVAL      W4ITEM = 'SDCALT'

      ** Branch

     C                   MOVEL     BBBRCD        W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'SDALTNPD'

      ** Counter Party Number

     C                   MOVE      BBCUST        W4CNUM

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = BBCRNM + BBCRTN

      ** Amount Side 1

     C                   EVAL      W4AMT1 = *ZERO

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmXSDAltn - Setup the Parameters 1 and 2 for SDALTNPD    *
      *                  for Standing Data Authorisation              *
      *                                                               *
      *****************************************************************
     C     SrParmXSDAltn BEGSR

     C     K_Bccust      CHAIN     SDANSHL0

     C                   IF        NOT %FOUND(SDANSHL0)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE
     C     S_BCCUST      CHAIN     SDCUSTL5

     C                   IF        NOT %FOUND(SDCUSTL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        S_BCCNA1 <> *BLANKS
     C     P_XML         CAT       OpenTag(21):0 P_XML
     C     P_XML         CAT       S_BCCNA1:0    P_XML
     C     P_XML         CAT       ClosTag(21):0 P_XML
     C                   EndIf

     C                   If        S_BCCNA2 <> *BLANKS
     C                             OR S_BCCNA3 <> *BLANKS
     C                             OR S_BCCNA4 <> *BLANKS
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       S_BCCNA2:0    P_XML
     C     P_XML         CAT       S_BCCNA3:1    P_XML
     C     P_XML         CAT       S_BCCNA4:1    P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   EndIf

     C                   If        S_BCCNCD <> *BLANKS
     C     P_XML         CAT       OpenTag(18):0 P_XML
     C     P_XML         CAT       S_BCCNCD:0    P_XML
     C     P_XML         CAT       ClosTag(18):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   EVAL      W4IDEN = S_BCCUST + S_BCADCD

      ** Item Type Code

     C                   EVAL      W4ITEM = 'SDCALT'

      ** Branch

     C                   MOVEL     BBBRCD        W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'SDALTNPD'

      ** Counter Party Number

     C                   MOVE      BBCUST        W4CNUM

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = BBCRNM + BBCRTN

      ** Amount Side 1

     C                   EVAL      W4AMT1 = *ZERO

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmCgcorrpd - Setup the Parameters 1 and 2 for CGCORRPD   *
      *                                                               *
      *****************************************************************
     C     SrParmCgcorrpdBEGSR

     C     K_Cdcorr      CHAIN     CGCORRL1

     C                   IF        NOT %FOUND(CGCORRL1)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE
     C     CDCUST        CHAIN     SDCUSTL5

     C                   IF        NOT %FOUND(SDCUSTL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

     ** Access SDGELRPD for alternate branch

     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*FIRST'      POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029

     C                   If        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 029
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        CDCORN <> *BLANKS
     C     P_XML         CAT       OpenTag(22):0 P_XML
     C     P_XML         CAT       CDCORN:0      P_XML
     C     P_XML         CAT       ClosTag(22):0 P_XML
     C                   EndIf

     C                   If        CDADD1 <> *BLANKS
     C                             OR CDADD2 <> *BLANKS
     C                             OR CDADD3 <> *BLANKS
     C                             OR CDADD4 <> *BLANKS
     C                             OR CDADD5 <> *BLANKS
     C                             OR CDADD6 <> *BLANKS
     C                             OR CDADD7 <> *BLANKS
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       CDADD1:0      P_XML
     C     P_XML         CAT       CDADD2:1      P_XML
     C     P_XML         CAT       CDADD3:1      P_XML
     C     P_XML         CAT       CDADD4:1      P_XML
     C     P_XML         CAT       CDADD5:1      P_XML
     C     P_XML         CAT       CDADD6:1      P_XML
     C     P_XML         CAT       CDADD7:1      P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   EndIf

     C                   If        CDZIP <> *BLANKS
     C     P_XML         CAT       OpenTag(23):0 P_XML
     C     P_XML         CAT       CDZIP:0       P_XML
     C     P_XML         CAT       ClosTag(23):0 P_XML
     C                   EndIf

     C                   If        CDFATT <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVE      CDFATT        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(24):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(24):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     CDCORR        W4IDEN

      ** Item Type Code

     C                   EVAL      W4ITEM = 'CGRECP'

      ** Branch

     C                   MOVEL     BKMABR        W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'CGCORRPD'

      ** Counter Party Number

     C                   If        CDCUST <> *Blanks
     C                   MOVE      CDCUST        W4CNUM
     C                   EndIf

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = BBCRNM + BBCRTN

      ** Amount Side 1

     C                   EVAL      W4AMT1 = *ZERO

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmAccntab - Setup the Parameters 1 and 2 for ACCNTAB     *
      *                                                               *
      *****************************************************************
     C     SrParmAccntab BEGSR

     C     K_Accntab     CHAIN     ACCBR

     C                   IF        NOT %FOUND(ACCBR) OR RECI = '*'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE
     C                   MOVEL     CNUM          K_Bbcust
     C     K_Bbcust      CHAIN     SDCUSTL5

     C                   IF        NOT %FOUND(SDCUSTL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        ANAM <> *BLANKS
     C     P_XML         CAT       OpenTag(25):0 P_XML
     C     P_XML         CAT       ANAM:0        P_XML
     C     P_XML         CAT       ClosTag(25):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVE      CNUM          WCNUM
     C                   MOVE      ACOD          WACOD
     C                   MOVE      ACSQ          WACSQ
     C                   EVAL      W4IDEN = BRCA + WCNUM + CCY + WACOD
     C                                   + WACSQ

      ** Item Type Code

     C                   EVAL      W4ITEM = 'GLACCT'

      ** Branch

     C                   MOVEL     BRCA          W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'ACCNTAB '

      ** Counter Party Number

     C                   MOVE      CNUM          W4CNUM

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = BBCRNM + BBCRTN

      ** Value Date

     C                   MOVE      DACO          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  030
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      DACC          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  031
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = CCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      LDBL          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  032
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmXAccnt - Setup the Parameters 1 and 2 for ACCNTAB      *
      *                 for Standing Data Authorisation               *
      *                                                               *
      *****************************************************************
     C     SrParmXAccnt  BEGSR

     C     K_Accntab     CHAIN     GLACSHL0

     C                   IF        NOT %FOUND(GLACSHL0) OR RECI = '*'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE
     C                   MOVEL     U_CNUM        K_Bbcust
     C     K_Bbcust      CHAIN     SDCUSTL5

     C                   IF        NOT %FOUND(SDCUSTL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        U_ANAM <> *BLANKS
     C     P_XML         CAT       OpenTag(25):0 P_XML
     C     P_XML         CAT       U_ANAM:0      P_XML
     C     P_XML         CAT       ClosTag(25):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVE      U_CNUM        WCNUM
     C                   MOVE      U_ACOD        WACOD
     C                   MOVE      U_ACSQ        WACSQ
     C                   EVAL      W4IDEN = U_BRCA + WCNUM + U_CCY + WACOD
     C                                   + WACSQ

      ** Item Type Code

     C                   EVAL      W4ITEM = 'GLACCT'

      ** Branch

     C                   MOVEL     U_BRCA        W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'ACCNTAB'

      ** Counter Party Number

     C                   MOVE      U_CNUM        W4CNUM

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = BBCRNM + BBCRTN

      ** Value Date

     C                   MOVE      U_DACO        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  030
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      U_DACC        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  031
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = U_CCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      U_LDBL        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  032
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmSdexstpd - Setup the Parameters 1 and 2 for SDEXSTPD   *
      *                                                               *
      *****************************************************************
     C     SrParmSdexstpdBEGSR

     C     K_Sdexstpd    CHAIN     SDEXSTL1

     C                   IF        NOT %FOUND(SDEXSTL1) OR RECI = 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE
     C     BYCUST        CHAIN     SDCUSTL5

     C                   IF        NOT %FOUND(SDCUSTL5)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   If        BYRONO <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYRONO        PInput1
     C                   EVAL      PCurrency= BYCYCD
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(26):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(26):0 P_XML
     C                   EndIf

     C                   If        BYROCS <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYROCS        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(27):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(27):0 P_XML
     C                   EndIf

     C                   If        BYRIBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYRIBN        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(28):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BYRIBL:1      P_XML
     C     P_XML         CAT       ClosTag(28):0 P_XML
     C                   EndIf

     C                   If        BYROBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYROBN        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(29):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(29):0 P_XML
     C                   EndIf

     C                   If        BYPONO <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYPONO        PInput1
     C                   EVAL      PCurrency= BYCYCD
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(30):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(30):0 P_XML
     C                   EndIf

     C                   If        BYPOCS <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYPOCS        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(31):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(31):0 P_XML
     C                   EndIf

     C                   If        BYRCNB <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYRCNB        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(32):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(32):0 P_XML
     C                   EndIf

     C                   If        BYRCNO <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYRCNO        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(33):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BYRCAL:1      P_XML
     C     P_XML         CAT       ClosTag(33):0 P_XML
     C                   EndIf

     C                   If        BYPIBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYPIBN        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(34):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BYPIBA:1      P_XML
     C     P_XML         CAT       ClosTag(34):0 P_XML
     C                   EndIf

     C                   If        BYPOBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYPOBN        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(35):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(35):0 P_XML
     C                   EndIf

     C                   If        BYACBN <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYACBN        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(36):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BYACBL:1      P_XML
     C     P_XML         CAT       ClosTag(36):0 P_XML
     C                   EndIf

     C                   If        BYBYNB <> *BLANKS
     C                   MOVE      *BLANKS       PInput1
     C                   MOVEL     BYBYNB        PInput1
     C                   Exsr      SrFormat
     C     P_XML         CAT       OpenTag(37):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BYBACL:1      P_XML
     C     P_XML         CAT       ClosTag(37):0 P_XML
     C                   EndIf

     C                   If        BYDPY1 <> *BLANKS OR BYDPY2 <> *BLANKS
     C                             OR BYDPY3 <> *BLANKS OR BYDPY4 <> *BLANKS
     C     P_XML         CAT       OpenTag(38):0 P_XML
     C     P_XML         CAT       BYDPY1:0      P_XML
     C     P_XML         CAT       BYDPY2:1      P_XML
     C     P_XML         CAT       BYDPY3:1      P_XML
     C     P_XML         CAT       BYDPY4:1      P_XML
     C     P_XML         CAT       ClosTag(38):0 P_XML
     C                   EndIf

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   EVAL      W4IDEN = BYCYCD + BYCUST + BYTRTY

      ** Item Type Code

     C                   EVAL      W4ITEM = 'SDXSET'

      ** Branch

     C                   MOVEL     BBBRCD        W4BRCH

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'SDEXSTPD'

      ** Counter Party Number

     C                   MOVE      BYCUST        W4CNUM

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS
     C                             AND BBLICD <> W1IND1
     C                             AND BBLICD <> W1IND2
     C                             AND BBLICD <> W1IND3
     C                             AND BBLICD <> W1IND4
     C                             AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C                   EVAL      W4CUST = BBCRNM + BBCRTN

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = BYCYCD

      ** Amount Side 1

     C                   EVAL      W4AMT1 = *ZERO

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmStandsb - Setup the Parameters 1 and 2 for STANDSB     *
      *                                                               *
      *****************************************************************
     C     SrParmStandsb BEGSR

     C     K_Stor        CHAIN     STAND
     C                   IF        NOT %FOUND(STAND) OR RECI = '*'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** DR Account

     C                   IF        DACS <> *Zeros
     C                   MOVEL     DACS          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(39):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(39):0 P_XML
     C                   ENDIF

      ** DR Retail Account

     C                   IF        DRAN <> *Zeros
     C                   MOVEL     DRAN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(40):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(40):0 P_XML
     C                   ENDIF

      ** CR Account

     C                   IF        CACD <> *Zeros
     C                   MOVEL     CACD          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(41):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(41):0 P_XML
     C                   ENDIF

      ** CR Retail Account

     C                   IF        CRAN <> *Zeros
     C                   MOVEL     CRAN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(42):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(42):0 P_XML
     C                   ENDIF

      ** Payee

     C                   IF        PNAM <> *Blanks
     C                   EVAL      PInput1 = PNAM
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(43):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(43):0 P_XML
     C                   ENDIF

      ** Reference

     C                   IF        PAYR <> *Blanks
     C                   EVAL      PInput1 = PAYR
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(44):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(44):0 P_XML
     C                   ENDIF

      ** Payee Bank

     C                   IF        PAYB <> *Blanks
     C                   EVAL      PInput1 = PAYB
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(45):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(45):0 P_XML
     C                   ENDIF

      ** Payee Account

     C                   IF        PAYA <> *Blanks
     C                   EVAL      PInput1 = PAYA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(46):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(46):0 P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     STOR          W4IDEN
      ** Item Type Code

     C                   EVAL      W4ITEM = 'RESORD'

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'STANDSB'

      ** Counter Party Number

     C**********         MOVEL     *Zeros        W4CNUM                                       CSD027
     C                   EVAL      W4CNUM = *BLANKS                                           CSD027

      ** Get Customer Detail

     C                   MOVEL     CCUS          PKey1

     C                   EXSR      SrCustDet

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  033
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     BBCUST        W4CNUM

      ** Counterparty Type

      ** If Concord Interface Development is installed
      ** If Corporate Customer is 'Y', set Counterparty Type to 'C'
      ** Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *Blanks AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVE      '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  034
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      DFPY          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  035
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  036
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = CCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *Blanks

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      AFPY          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  037
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmTransd - Setup the Parameters 1 and 2 for TRANSD       *
      *                                                               *
      *****************************************************************
     C     SrParmTransd  BEGSR

     C     K_Tnbr        CHAIN     TRANS2
     C                   IF        NOT %FOUND(TRANS2) OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter
     C     TNBR          CHAIN     TRSET1

     C                   IF        %FOUND(TRSET1)

      ** Broker Settlement Account

     C                   IF        BSLA <> *Blanks
     C                   EVAL      PInput1 = BSLA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(47):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(47):0 P_XML
     C                   ENDIF

      ** Broker for Account Of

     C                   IF        BFAO <> *Blanks
     C                   EVAL      PInput1 = BFAO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(48):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(48):0 P_XML
     C                   ENDIF

      ** Broker Counterparty Nostro

     C                   IF        BCPN <> *Blanks
     C                   EVAL      PInput1 = BCPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(49):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(49):0 P_XML
     C                   ENDIF

      ** Customer Settlement Account

     C                   IF        CSLA <> *Blanks
     C                   EVAL      PInput1 = CSLA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(50):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(50):0 P_XML
     C                   ENDIF

      ** Customer for Account Of

     C                   IF        CFAO <> *Blanks
     C                   EVAL      PInput1 = CFAO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(51):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(51):0 P_XML
     C                   ENDIF

      ** Customer Counterparty Nostro

     C                   IF        CCPN <> *Blanks
     C                   EVAL      PInput1 = CCPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(52):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(52):0 P_XML
     C                   ENDIF

     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     TNBR          W4IDEN

      ** Select Item Type Code

     C                   SELECT

      ** For item types - Exercised Trades
     C                   WHEN      TRTY = 'E'
     C                   EVAL      W4ITEM = 'FFXER'

     C                   OTHER

      ** For item types - Exchange Traded
     C                   MOVEL     ISTT          K_Mrkt
     C     K_Mrkt        CHAIN     MKCTL

     C                   IF        %FOUND(MKCTL)
     C                   EVAL      W4ITEM = 'FFEFO'
     C                   ELSE

      ** For item types - Non-ccy OTC
     C     ISTT          CHAIN     INTYP

     C                   IF        %FOUND(INTYP)
     C                   IF        ISPT = 4 OR ISPT = 6
     C                   EVAL      W4ITEM = 'FFOTCO'
     C                   ENDIF

      ** For item types - Currency OTC
     C                   IF        ISPT = 5
     C                   EVAL      W4ITEM = 'FFOTC'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSL

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'TRANSD '

      ** Counter Party Number

     C**********         IF        CUSC <> 0                                                  CSD027
     C                   IF        CUSC <> *BLANKS                                            CSD027

     C                   MOVEL     CUSC          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     CUSC          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  038
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      ** If Corporate Customer is 'Y', set Counterparty Type to 'C'
      ** Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'

     C                   IF        BBLICD <> *BlANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

     C                   ENDIF

      ** Deal Date

     C                   MOVEL     TRSD          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  039
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      VALD          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  040
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  041
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = ISTT

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      NUCO          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  042
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmTradsd - Setup the Parameters 1 and 2 for TRADSD       *
      *                                                               *
      *****************************************************************
     C     SrParmTradsd  BEGSR

     C     K_Tdrf        CHAIN     TRADS
     C                   IF        NOT %FOUND(TRADS) OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Pay From

     C                   IF        PYFM <> *BLANKS
     C                   EVAL      PInput1 = PYFM
     C                   EVAL      PCurrency = SETC
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(53):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(53):0 P_XML
     C                   ENDIF

      ** Pay To

     C                   IF        PAYT <> *BLANKS
     C                   EVAL      PInput1 = PAYT
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(54):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(54):0 P_XML
     C                   ENDIF

      ** For Account of - Pay To

     C                   IF        TDFA <> *BLANKS
     C                   EVAL      PInput1 = TDFA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(55):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(55):0 P_XML
     C                   ENDIF

      ** Deliver To

     C                   IF        DELT <> *Zeros
     C                   MOVEL     DELT          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(56):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(56):0 P_XML
     C                   ENDIF

      ** or Account of - Deliver To

     C                   IF        DTFA <> *Blanks
     C                   EVAL      PInput1 = DTFA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(57):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(57):0 P_XML
     C                   ENDIF

      ** Deliver From

     C                   IF        DELF <> *Zeros
     C                   MOVEL     DELF          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(58):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(58):0 P_XML
     C                   ENDIF

      ** For Account of - Deliver From>

     C                   IF        DFFA <> *Blanks
     C                   EVAL      PInput1 = DFFA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(59):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(59):0 P_XML
     C                   ENDIF

      ** Chain Extention File for other details

     C     TDRF          CHAIN     TRADSDY2

     C                   IF        %FOUND(TRADSDY2)
      ** MT510 A/C for Payment

     C                   IF        T2AP1N <> *Blanks
     C                   EVAL      PInput1 = T2AP1N
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(60):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(60):0 P_XML
     C                   ENDIF

      ** Account for Payment

     C                   IF        T2AFPN <> *Blanks
     C                   EVAL      PInput1 = T2AFPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(61):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(61):0 P_XML
     C                   ENDIF

      ** A/C with Institution

     C                   IF        T2AWIN <> *Blanks
     C                   EVAL      PInput1 = T2AWIN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(62):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(62):0 P_XML
     C                   ENDIF

      ** Beneficiary

     C                   IF        T2BOFN <> *Blanks
     C                   EVAL      PInput1 = T2BOFN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(63):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(63):0 P_XML
     C                   ENDIF

      ** Instructing Party

     C                   IF        T2IPYN <> *Blanks
     C                   EVAL      PInput1 = T2IPYN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(64):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(64):0 P_XML
     C                   ENDIF

      ** Counterparty

     C                   IF        T2CTYN <> *Blanks
     C                   EVAL      PInput1 = T2CTYN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(65):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(65):0 P_XML
     C                   ENDIF

      ** MT510 Safekeeping A/C

     C                   IF        T2SA1N <> *Blanks
     C                   EVAL      PInput1 = T2SA1N
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(66):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(66):0 P_XML
     C                   ENDIF

      ** Safekeeping Account

     C                   IF        T2SKAN <> *Blanks
     C                   EVAL      PInput1 = T2SKAN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(67):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(67):0 P_XML
     C                   ENDIF

      ** Deliverer Instructing Party

     C                   IF        T2DCTL <> *Blanks
     C                   EVAL      PInput1 = T2DCTL
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(68):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(68):0 P_XML
     C                   ENDIF

      ** Receivers of Securties

     C                   IF        T2RSSN <> *Blanks
     C                   EVAL      PInput1 = T2RSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(69):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(69):0 P_XML
     C                   ENDIF

      ** Deliverers of Securities

     C                   IF        T2DSSN <> *Blanks
     C                   EVAL      PInput1 = T2DSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(70):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(70):0 P_XML
     C                   ENDIF

      ** Beneficiary of Securities

     C                   IF        T2BSSN <> *Blanks
     C                   EVAL      PInput1 = T2BSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(71):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(71):0 P_XML
     C                   ENDIF

      ** Investor

     C                   IF        T2INVE <> *Blanks
     C                   EVAL      PInput1 = T2INVE
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(72):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(72):0 P_XML
     C                   ENDIF

      ** Settlement Party Intermediary

     C                   EVAL      WTempDS = *Blanks

     C                   IF        T2IMD1 <> *Blanks
     C                   EVAL      PInput1 = T2IMD1
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMD2 <> *Blanks
     C                   EVAL      PInput1 = T2IMD2
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMD3 <> *Blanks
     C                   EVAL      PInput1 = T2IMD3
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMD4 <> *Blanks
     C                   EVAL      PInput1 = T2IMD4
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMD5 <> *Blanks
     C                   EVAL      PInput1 = T2IMD5
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMD6 <> *Blanks
     C                   EVAL      PInput1 = T2IMD6
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMD7 <> *Blanks
     C                   EVAL      PInput1 = T2IMD7
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMD8 <> *Blanks
     C                   EVAL      PInput1 = T2IMD8
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMD9 <> *Blanks
     C                   EVAL      PInput1 = T2IMD9
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        WTempDS <> *Blanks
     C     P_XML         CAT       OpenTag(73):0 P_XML
     C     P_XML         CAT       WTempDS:0     P_XML
     C     P_XML         CAT       ClosTag(73):0 P_XML
     C                   ENDIF


      ** Safekeeping A/C Intermediary

     C                   EVAL      WTempDS = *Blanks

     C                   IF        T2IMS1 <> *Blanks
     C                   EVAL      PInput1 = T2IMS1
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMS2 <> *Blanks
     C                   EVAL      PInput1 = T2IMS2
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMS3 <> *Blanks
     C                   EVAL      PInput1 = T2IMS3
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMS4 <> *Blanks
     C                   EVAL      PInput1 = T2IMS4
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMS5 <> *Blanks
     C                   EVAL      PInput1 = T2IMS5
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMS6 <> *Blanks
     C                   EVAL      PInput1 = T2IMS6
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMS7 <> *Blanks
     C                   EVAL      PInput1 = T2IMS7
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMS8 <> *Blanks
     C                   EVAL      PInput1 = T2IMS8
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        T2IMS9 <> *Blanks
     C                   EVAL      PInput1 = T2IMS9
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF
                                                                                              CSW210
     C                   IF        T2DIDN <> *Blanks                                          CSW210
     C                   EVAL      PInput1 = T2DIDN                                           CSW210
     C                   EXSR      SRFormat                                                   CSW210
     C                   CAT       POutput1:0    WTempDS                                      CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        T2QFIN <> *Blanks                                          CSW210
     C                   EVAL      PInput1 = T2QFIN                                           CSW210
     C                   EXSR      SRFormat                                                   CSW210
     C                   CAT       POutput1:0    WTempDS                                      CSW210
     C                   ENDIF                                                                CSW210

     C                   IF        WTempDS <> *Blanks
     C     P_XML         CAT       OpenTag(74):0 P_XML
     C     P_XML         CAT       WTempDS:0     P_XML
     C     P_XML         CAT       ClosTag(74):0 P_XML
     C                   ENDIF

     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   EVAL      W4IDEN = TDRF

      ** Item Type Code

     C                   EVAL      W4ITEM = 'SETRAD'

      ** Branch

     C                   EVAL      W4BRCH = TDBA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'TRADSD  '

      ** Counter Party Number

     C                   MOVEL     TCNR          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     TCNR          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  043
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     TDDT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  044
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     TDVD          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  045
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  046
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = TNMC

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      NOML          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  047
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmDptmvd - Setup the Parameters 1 and 2 for DPTMVD       *
      *                                                               *
      *****************************************************************
     C     SrParmDptmvd  BEGSR

     C     K_Dprn        CHAIN     DPTMVDL1
     C                   IF        NOT %FOUND(DPTMVDL1) OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Depot In

     C                   IF        DPID <> *Zeros
     C                   MOVEL     DPID          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(75):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(75):0 P_XML
     C                   ENDIF

      ** Depot Out

     C                   IF        DPOD <> *Zeros
     C                   MOVEL     DPOD          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(76):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(76):0 P_XML
     C                   ENDIF

      ** Chain Extention File for other details

     C     DPRN          CHAIN     DPTMVDY3

     C                   IF        %FOUND(DPTMVDY3)

      ** Account for Payment

     C                   IF        D2AFPN <> *Blanks
     C                   EVAL      PInput1 = D2AFPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(61):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(61):0 P_XML
     C                   ENDIF

      ** A/C with Institution

     C                   IF        D2AWIN <> *Blanks
     C                   EVAL      PInput1 = D2AWIN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(62):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(62):0 P_XML
     C                   ENDIF

      ** Beneficiary

     C                   IF        D2BOFN <> *Blanks
     C                   EVAL      PInput1 = D2BOFN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(63):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(63):0 P_XML
     C                   ENDIF

      ** Instructing Party

     C                   IF        D2IPYN <> *Blanks
     C                   EVAL      PInput1 = D2IPYN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(64):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(64):0 P_XML
     C                   ENDIF

      ** Counterparty

     C                   IF        D2CTYN <> *Blanks
     C                   EVAL      PInput1 = D2CTYN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(65):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(65):0 P_XML
     C                   ENDIF

      ** Safekeeping Account

     C                   IF        D2SKAN <> *Blanks
     C                   EVAL      PInput1 = D2SKAN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(67):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(67):0 P_XML
     C                   ENDIF

      ** Deliverr Instrctg Prty

     C                   IF        D2DCTL <> *Blanks
     C                   EVAL      PInput1 = D2DCTL
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(68):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(68):0 P_XML
     C                   ENDIF

      ** Receivers of Securties

     C                   IF        D2RSSN <> *Blanks
     C                   EVAL      PInput1 = D2RSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(69):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(69):0 P_XML
     C                   ENDIF

      ** Deliverrs of Securties

     C                   IF        D2DSSN <> *Blanks
     C                   EVAL      PInput1 = D2DSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(70):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(70):0 P_XML
     C                   ENDIF

      ** Benfciary of Securties

     C                   IF        D2BSSN <> *Blanks
     C                   EVAL      PInput1 = D2BSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(71):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(71):0 P_XML
     C                   ENDIF

      ** Investor

     C                   IF        D2INVE <> *Blanks
     C                   EVAL      PInput1 = D2INVE
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(72):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(72):0 P_XML
     C                   ENDIF

      ** Sttlmnt Prty Intmdiary

     C                   EVAL      WTempDS = *Blanks

     C                   IF        D2IMD1 <> *Blanks
     C                   EVAL      PInput1 = D2IMD1
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMD2 <> *Blanks
     C                   EVAL      PInput1 = D2IMD2
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMD3 <> *Blanks
     C                   EVAL      PInput1 = D2IMD3
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMD4 <> *Blanks
     C                   EVAL      PInput1 = D2IMD4
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMD5 <> *Blanks
     C                   EVAL      PInput1 = D2IMD5
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMD6 <> *Blanks
     C                   EVAL      PInput1 = D2IMD6
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMD7 <> *Blanks
     C                   EVAL      PInput1 = D2IMD7
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMD8 <> *Blanks
     C                   EVAL      PInput1 = D2IMD8
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMD9 <> *Blanks
     C                   EVAL      PInput1 = D2IMD9
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        WTempDS <> *Blanks
     C     P_XML         CAT       OpenTag(73):0 P_XML
     C     P_XML         CAT       WTempDS:0     P_XML
     C     P_XML         CAT       ClosTag(73):0 P_XML
     C                   ENDIF

      ** Safkeepg A/C Intmdiary

     C                   EVAL      WTempDS = *Blanks

     C                   IF        D2IMS1 <> *Blanks
     C                   EVAL      PInput1 = D2IMS1
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMS2 <> *Blanks
     C                   EVAL      PInput1 = D2IMS2
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMS3 <> *Blanks
     C                   EVAL      PInput1 = D2IMS3
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMS4 <> *Blanks
     C                   EVAL      PInput1 = D2IMS4
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMS5 <> *Blanks
     C                   EVAL      PInput1 = D2IMS5
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMS6 <> *Blanks
     C                   EVAL      PInput1 = D2IMS6
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMS7 <> *Blanks
     C                   EVAL      PInput1 = D2IMS7
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMS8 <> *Blanks
     C                   EVAL      PInput1 = D2IMS8
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2IMS9 <> *Blanks
     C                   EVAL      PInput1 = D2IMS9
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    WTempDS
     C                   ENDIF

     C                   IF        D2DIDN <> *Blanks                                          CSW210
     C                   EVAL      PInput1 = D2DIDN                                           CSW210
     C                   EXSR      SRFormat                                                   CSW210
     C                   CAT       POutput1:0    WTempDS                                      CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        D2QFIN <> *Blanks                                          CSW210
     C                   EVAL      PInput1 = D2QFIN                                           CSW210
     C                   EXSR      SRFormat                                                   CSW210
     C                   CAT       POutput1:0    WTempDS                                      CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        WTempDS <> *Blanks
     C     P_XML         CAT       OpenTag(74):0 P_XML
     C     P_XML         CAT       WTempDS:0     P_XML
     C     P_XML         CAT       ClosTag(74):0 P_XML
     C                   ENDIF

     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   EVAL      W4IDEN = DPRN

      ** Item Type Code

     C                   IF        DPMV = 'WI'
     C                   EVAL      W4ITEM = 'SEWKIN'
     C                   ELSE
     C                   IF        DPMV = 'WO'
     C                   EVAL      W4ITEM = 'SEWKOT'
     C                   ELSE
     C                   EVAL      W4ITEM = 'SEDPOT'
     C                   ENDIF
     C                   ENDIF

      ** Branch

     C                   EVAL      W4BRCH = DPBA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'DPTMVD  '

      ** Counter Party Number

     C                   MOVEL     DPBN          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     DPBN          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  048
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     DMTD          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  049
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     DPVD          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  050
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  051
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = DPSS

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      DPNA          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  052
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmPosetd - Setup the Parameters 1 and 2 for POSETD       *
      *                                                               *
      *****************************************************************
     C     SrParmPosetd  BEGSR

     C     K_Posetd      CHAIN     POSET2
     C                   IF        NOT %FOUND(POSET2)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Settlement account

     C                   IF        PSEA <> *Blanks
     C                   EVAL      PInput1 = PSEA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(77):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(77):0 P_XML
     C                   ENDIF

      ** Counterparty bank

     C                   IF        PCPN <> *Blanks
     C                   EVAL      PInput1 = PCPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(78):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(78):0 P_XML
     C                   ENDIF

      ** For account of

     C                   IF        PFAC <> *Blanks
     C                   EVAL      PInput1 = PFAC
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(79):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(79):0 P_XML
     C                   ENDIF


      ** Chain Extention File for other details

     C     PosetKey      CHAIN     POSETDY2

     C                   IF        %FOUND(POSETDY2)

      ** Account for Payment

     C                   IF        P2AFPN <> *Blanks
     C                   EVAL      PInput1 = P2AFPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(61):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(61):0 P_XML
     C                   ENDIF

      ** Safekeeping Account

     C                   IF        P2SKAN <> *Blanks
     C                   EVAL      PInput1 = P2SKAN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(67):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(67):0 P_XML
     C                   ENDIF

      ** Deliverer of Securities

     C                   IF        P2DSSN <> *Blanks
     C                   EVAL      PInput1 = P2DSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(70):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(70):0 P_XML
     C                   ENDIF

     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine


     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     PCPY          PCPYA
     C                   MOVEL     PDUD          PDUDA
     C                   EVAL      W4IDEN = PBCA + PSSH +PCPYA + PDUDA + PEVT

      ** Item Type Code

     C                   EVAL      W4ITEM = 'POSETD'

      ** Branch

     C                   EVAL      W4BRCH = PBCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'POSETD  '

      ** Counter Party Number

     C                   MOVEL     PCPY          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     PCPY          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  053
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     PDUD          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  054
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     PSVL          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  055
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  056
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = PNCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      PNMP          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  057
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmInpaydd - Setup the Parameters 1 and 2 for INPAYDD     *
      *                                                               *
      *****************************************************************
     C     SrParmInpaydd BEGSR

     C     K_Pref        CHAIN     INPAY
     C                   IF        NOT %FOUND(INPAY) OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   IF        SND1 <> *BLANKS OR SND2 <> *BLANKS OR
     C                             SND3 <> *BLANKS OR SND4 <> *BLANKS
     C                   EVAL      PInput1 = SND1
     C                   EVAL      PInput2 = SND2
     C                   EVAL      PInput3 = SND3
     C                   EVAL      PInput4 = SND4
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(80):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(80):0 P_XML
     C                   ENDIF

     C                   MOVEL     RCCO          WRCCO
     C                   IF        WRCCO <> *BLANKS
     C                   EVAL      PInput1 = WRCCO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(81):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(81):0 P_XML
     C                   ENDIF

     C                   IF        ACBK <> *BLANKS
     C                   EVAL      PInput1 = ACBK
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(82):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(82):0 P_XML
     C                   ENDIF

     C                   IF        BNC1 <> *BLANKS OR BNC2 <> *BLANKS OR
     C                             BNC3 <> *BLANKS OR BNC4 <> *BLANKS OR
     C                             BNC5 <> *BLANKS
     C                   EVAL      PInput1 = BNC1
     C                   EVAL      PInput2 = BNC2
     C                   EVAL      PInput3 = BNC3
     C                   EVAL      PInput4 = BNC4
     C                   EVAL      PInput5 = BNC5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(83):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(83):0 P_XML
     C                   ENDIF

     C                   IF        ORB1 <> *BLANKS OR ORB2 <> *BLANKS OR
     C                             ORB3 <> *BLANKS OR ORB4 <> *BLANKS OR
     C                             ORB5 <> *BLANKS
     C                   EVAL      PInput1 = ORB1
     C                   EVAL      PInput2 = ORB2
     C                   EVAL      PInput3 = ORB3
     C                   EVAL      PInput4 = ORB4
     C                   EVAL      PInput5 = ORB5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(84):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(84):0 P_XML
     C                   ENDIF

     C                   IF        SNC1 <> *BLANKS OR SNC2 <> *BLANKS OR
     C                             SNC3 <> *BLANKS OR SNC4 <> *BLANKS OR
     C                             SNC5 <> *BLANKS
     C                   EVAL      PInput1 = SNC1
     C                   EVAL      PInput2 = SNC2
     C                   EVAL      PInput3 = SNC3
     C                   EVAL      PInput4 = SNC4
     C                   EVAL      PInput5 = SNC5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(85):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(85):0 P_XML
     C                   ENDIF

     C                   IF        ORC1 <> *BLANKS OR ORC2 <> *BLANKS OR
     C                             ORC3 <> *BLANKS OR ORC4 <> *BLANKS
     C                             Or ORC5 <> *BLANKS                                      BUG15105A
     C                   EVAL      PInput1 = ORC1
     C                   EVAL      PInput2 = ORC2
     C                   EVAL      PInput3 = ORC3
     C                   EVAL      PInput4 = ORC4
     C                   EVAL      PInput5 = ORC5                                          BUG15105A
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(86):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(86):0 P_XML
     C                   ENDIF

     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS OR
     C                             DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(87):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(87):0 P_XML
     C                   ENDIF

     C                   IF        INB1 <> *BLANKS OR INB2 <> *BLANKS OR
     C                             INB3 <> *BLANKS OR INB4 <> *BLANKS OR
     C                             INB5 <> *BLANKS
     C                   EVAL      Pinput1 = INB1
     C                   EVAL      Pinput2 = INB2
     C                   EVAL      Pinput3 = INB3
     C                   EVAL      Pinput4 = INB4
     C                   EVAL      Pinput5 = INB5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(88):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(88):0 P_XML
     C                   ENDIF

     C                   IF        INRCO1 <> *BLANKS OR INRCO2 <> *BLANKS OR
     C                             INRCO3 <> *BLANKS OR INRCO4 <> *BLANKS OR
     C                             INRCO5 <> *BLANKS
     C                   EVAL      Pinput1 = INRCO1
     C                   EVAL      Pinput2 = INRCO2
     C                   EVAL      Pinput3 = INRCO3
     C                   EVAL      Pinput4 = INRCO4
     C                   EVAL      Pinput5 = INRCO5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(81):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(81):0 P_XML
     C                   ENDIF

     C                   IF        INACB1 <> *BLANKS OR INACB2 <> *BLANKS OR
     C                             INACB3 <> *BLANKS OR INACB4 <> *BLANKS OR
     C                             INACB5 <> *BLANKS
     C                   EVAL      Pinput1 = INACB1
     C                   EVAL      Pinput2 = INACB2
     C                   EVAL      Pinput3 = INACB3
     C                   EVAL      Pinput4 = INACB4
     C                   EVAL      Pinput5 = INACB5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(82):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(82):0 P_XML
     C                   ENDIF

      ** Process INPAYXPD extension file

     C     PREF          CHAIN     INPAYXL0

     C                   IF        %FOUND(INPAYXL0)

     C                   IF        INTRIB <> *BLANKS OR INTRI1 <> *BLANKS OR
     C                             INTRI2 <> *BLANKS OR INTRI3 <> *BLANKS OR
     C                             INTRI4 <> *BLANKS OR INTRI5 <> *BLANKS
     C                   EVAL      Pinput1 = INTRIB
     C                   EVAL      Pinput2 = INTRI1
     C                   EVAL      Pinput3 = INTRI2
     C                   EVAL      Pinput4 = INTRI3
     C                   EVAL      Pinput5 = INTRI4
     C                   EVAL      Pinput6 = INTRI5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(99):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(99):0 P_XML
     C                   ENDIF
     C                   ENDIF



      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.


     C                   IF        P_XML <> *BLANKS

      ** First Parameter


      ** Identifier

     C                   EVAL      W4IDEN = PREF

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FTIPAY'

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'INPAYDD'

      ** Counter Party Number

     C                   MOVEL     RCCO          WRCCO

     C                   EVAL      PInput1 = SND1
     C                   EVAL      PInput2 = SND2
     C                   EVAL      PInput3 = SND3
     C                   EVAL      PInput4 = SND4
     C                   EVAL      PCurrency =  SMCY
     C                   EXSR      SrFormat

     C                   IF        POutput2 = '*CPART' OR POutput2 = '*FREE'
     C                             OR (SND1 = *BLANKS AND SND2 = *BLANKS AND
     C                             SND3 = *BLANKS and SND4 = *BLANKS)
     C                   EVAL      PInput1 = WRCCO
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PCurrency =  SMCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        %FOUND(INPAYXL0)
     C                   IF        POutput2 = '*CPART' OR POutput2 = '*FREE'
     C                             OR (SND1 = *BLANKS AND SND2 = *BLANKS AND
     C                             SND3 = *BLANKS and SND4 = *BLANKS AND
     C                             WRCCO = *BLANKS)
     C                   EVAL      PInput1 = INTRIB
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PCurrency = SMCY
     C                   EXSR      SrFormat
     C                   ENDIF
     C                   ENDIF

     C                   IF        POutput2 <>'*CPART' AND
     C                             POutput2 <>'*FREE'
     C                   EVAL      W4CNUM = POutput2

      ** Get Customer Detail

     C                   MOVEL     W4CNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  058
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

     C                   ENDIF

      ** Deal Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  059
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      SLDT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  060
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      PVDT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  061
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = SMCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = PCCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      SMAM          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  062
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = POutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      PYAM          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  063
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT2 = POutAmtNum

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmOtpaydd - Setup the Parameters 1 and 2 for OTPAYDD     *
      *                                                               *
      *****************************************************************
     C     SrParmOtpaydd BEGSR

     C     K_Pref        CHAIN     OTPAY
     C                   IF        NOT %FOUND(OTPAY) OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

     C                   IF        DST1 <> *BLANKS or DST2 <> *BLANKS or
     C                             DST3 <> *BLANKS or DST4 <> *BLANKS
     C                   EVAL      PInput1 = DST1
     C                   EVAL      PInput2 = DST2
     C                   EVAL      PInput3 = DST3
     C                   EVAL      PInput4 = DST4
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(89):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(89):0 P_XML
     C                   ENDIF

     C                   MOVEL     SNCO          WSNCO
     C                   IF        WSNCO <> *BLANKS
     C                   EVAL      PInput1 = WSNCO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(85):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(85):0 P_XML
     C                   ENDIF

     C                   MOVEL     ORBK          WORBK
     C                   IF        WORBK <> *BLANKS
     C                   EVAL      PInput1 = WORBK
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(84):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(84):0 P_XML
     C                   ENDIF

     C                   IF        ORC1 <> *BLANKS or ORC2 <> *BLANKS or
     C                             ORC3 <> *BLANKS or ORC4 <> *BLANKS
     C                             Or ORC5 <> *BLANKS                                      BUG15105A
     C                   EVAL      PInput1 = ORC1
     C                   EVAL      PInput2 = ORC2
     C                   EVAL      PInput3 = ORC3
     C                   EVAL      PInput4 = ORC4
     C                   EVAL      PInput5 = ORC5                                          BUG15105A
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(86):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(86):0 P_XML
     C                   ENDIF

     C                   IF        RCO1 <> *BLANKS or RCO2 <> *BLANKS or
     C                             RCO3 <> *BLANKS or RCO4 <> *BLANKS or
     C                             RCO5 <> *BLANKS
     C                   EVAL      PInput1 = RCO1
     C                   EVAL      PInput2 = RCO2
     C                   EVAL      PInput3 = RCO3
     C                   EVAL      PInput4 = RCO4
     C                   EVAL      PInput5 = RCO5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(81):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(81):0 P_XML
     C                   ENDIF

     C                   IF        ACB1 <> *BLANKS or ACB2 <> *BLANKS or
     C                             ACB3 <> *BLANKS or ACB4 <> *BLANKS or
     C                             ACB5 <> *BLANKS
     C                   EVAL      PInput1 = ACB1
     C                   EVAL      PInput2 = ACB2
     C                   EVAL      PInput3 = ACB3
     C                   EVAL      PInput4 = ACB4
     C                   EVAL      PInput5 = ACB5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(82):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(82):0 P_XML
     C                   ENDIF

     C                   IF        BNC1 <> *BLANKS or BNC2 <> *BLANKS or
     C                             BNC3 <> *BLANKS or BNC4 <> *BLANKS or
     C                             BNC5 <> *BLANKS
     C                   EVAL      PInput1 = BNC1
     C                   EVAL      PInput2 = BNC2
     C                   EVAL      PInput3 = BNC3
     C                   EVAL      PInput4 = BNC4
     C                   EVAL      PInput5 = BNC5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(83):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(83):0 P_XML
     C                   ENDIF

     C                   IF        DTP1 <> *BLANKS or DTP2 <> *BLANKS or
     C                             DTP3 <> *BLANKS or DTP4 <> *BLANKS
     C                   EVAL      PInput1 = DTP1
     C                   EVAL      PInput2 = DTP2
     C                   EVAL      PInput3 = DTP3
     C                   EVAL      PInput4 = DTP4
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(87):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(87):0 P_XML
     C                   ENDIF

     C                   IF        INB1 <> *BLANKS or INB2 <> *BLANKS or
     C                             INB3 <> *BLANKS or INB4 <> *BLANKS or
     C                             INB5 <> *BLANKS
     C                   EVAL      PInput1 = INB1
     C                   EVAL      PInput2 = INB2
     C                   EVAL      PInput3 = INB3
     C                   EVAL      PInput4 = INB4
     C                   EVAL      PInput5 = INB5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(88):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(88):0 P_XML
     C                   ENDIF

     C                   IF        ODMT <> *BLANKS
     C                   EVAL      PInput1 = ODMT
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(90):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(90):0 P_XML
     C                   ENDIF

     C                   IF        OPORB1 <> *BLANKS or OPORB2 <> *BLANKS or
     C                             OPORB3 <> *BLANKS or OPORB4 <> *BLANKS or
     C                             OPORB5 <> *BLANKS
     C                   EVAL      PInput1 = OPORB1
     C                   EVAL      PInput2 = OPORB2
     C                   EVAL      PInput3 = OPORB3
     C                   EVAL      PInput4 = OPORB4
     C                   EVAL      PInput5 = OPORB5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(84):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(84):0 P_XML
     C                   ENDIF

      ** Process FTOPAYXPD extension file

     C     PREF          CHAIN     OTPAYXL0

     C                   IF        %FOUND(OTPAYXL0)

     C                   IF        OPTRI1 <> *BLANKS or OPTRI2 <> *BLANKS or
     C                             OPTRI3 <> *BLANKS or OPTRI4 <> *BLANKS or
     C                             OPTRI5 <> *BLANKS
     C                   EVAL      PInput1 = OPTRI1
     C                   EVAL      PInput2 = OPTRI2
     C                   EVAL      PInput3 = OPTRI3
     C                   EVAL      PInput4 = OPTRI4
     C                   EVAL      PInput5 = OPTRI5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(99):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(99):0 P_XML
     C                   ENDIF
     C                   ENDIF


      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.


     C                   IF        P_XML <> *BLANKS

      ** First Parameter


      ** Identifier

     C                   EVAL      W4IDEN = PREF

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FTOPAY'

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'OTPAYDD'

      ** Counter Party Number

     C                   IF        ODMT <> *BLANKS
     C                   EVAL      PInput1 = ODMT
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInput5 = *BLANKS
     C                   EVAL      PCurrency= SMCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 = '*FREE' OR POutput2 = '*CPART' OR
     C                             ODMT = *BLANKS
     C                   EVAL      PInput1 = ORC1
     C                   EVAL      PInput2 = ORC2
     C                   EVAL      PInput3 = ORC3
     C                   EVAL      PInput4 = ORC4
     C**********         EVAL      PInput5 = *BLANKS                                       BUG15105A
     C                   EVAL      PInput5 = ORC5                                          BUG15105A
     C                   EVAL      PCurrency= SMCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 = '*FREE' OR POutput2 = '*CPART' OR
     C                             (ORC1 = *BLANKS and ORC2 = *BLANKS
     C                             and ORC3 = *BLANKS and ORC4 = *BLANKS
     C                             and ORC5 = *BLANKS                                      BUG15105A
     C                             and ODMT = *BLANKS)
     C                   IF        OPMSGR > 0
     C                   EVAL      PInput1 = OPORB1
     C                   EVAL      PInput2 = OPORB2
     C                   EVAL      PInput3 = OPORB3
     C                   EVAL      PInput4 = OPORB4
     C                   EVAL      PInput5 = OPORB5
     C                   EVAL      PCurrency= SMCY
     C                   EXSR      SrFormat
     C                   ENDIF
     C                   ENDIF

     C                   IF        POutput2 = '*FREE' OR POutput2 = '*CPART' OR
     C                             (ORC1 = *BLANKS and ORC2 = *BLANKS
     C                             and ORC3 = *BLANKS and ORC4 = *BLANKS
     C                             and ORC5 = *BLANKS                                      BUG15105A
     C                             and ODMT = *BLANKS AND OPMSGR = 0)
     C                   MOVE      *BLANKS       OrderingBank
     C                   SELECT
     C                   WHEN      ORBT = 'N'
     C                   MOVEL     ORBK          ORBKNostro
     C                   MOVEL     OrderingBank  PInput1
     C                   WHEN      ORBT = 'R'
     C                   MOVEL     ORBK          ORBKRetail
     C                   MOVEL     OrderingBank  PInput1
     C                   OTHER
     C                   MOVEL     ORBK          PInput1
     C                   ENDSL
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInput5 = *BLANKS
     C                   EVAL      PCurrency= SMCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 <> '*CPART' AND POutput2 <> '*FREE'

     C                   EVAL      W4CNUM = POutput2

      ** Get Customer Detail

     C                   MOVEL     W4CNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  064
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

     C                   ENDIF

      ** Deal Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  065
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      SLDT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  066
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      PVDT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  067
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = SMCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = PCCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      SMAM          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  068
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = POutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      PYAM          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  069
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT2 = POutAmtNum

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmFt101hpd - Setup the Parameters 1 and 2 for FT101HPD   *
      *                                                               *
      *****************************************************************
     C     SrParmFt101hpdBEGSR

     C     K_Rftid       CHAIN     FT101HL3
     C                   IF        NOT %FOUND(FT101HL3)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

     C                   EVAL      *IN01 = *OFF

     C     RFTID         SETLL     FT101DD0
     C     RFTID         READE     FT101DD0                             0101

     C                   IF        *IN01 = *ON
     C                   EXSR      SRRFTHProcess

     C                   IF        P_XML <> *BLANKS

      ** Setup first parameter for Compliance Engine Program

     C                   EXSR      Sr1stRFTParm

      ** Send transaction details to Compliance Watch

     C                   EXSR      SrEngine
     C                   ENDIF
     C                   ENDIF

     C                   DOW       *IN01 = *OFF

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** Header

     C                   EXSR      SRRFTHProcess

      ** Process RFT Details

     C                   IF        TINPTY <> *BLANKS
     C                   EVAL      PInput1 = TINPTY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(91):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(91):0 P_XML
     C                   ENDIF

     C                   IF        TOCUS1 <> *BLANKS or TOCUS2 <> *BLANKS or
     C                             TOCUS3 <> *BLANKS or TOCUS4 <> *BLANKS or
     C                             TOCUS5 <> *BLANKS
     C                   EVAL      PInput1 = TOCUS1
     C                   EVAL      PInput2 = TOCUS2
     C                   EVAL      PInput3 = TOCUS3
     C                   EVAL      PInput4 = TOCUS4
     C                   EVAL      PInput5 = TOCUS5
     C                   EVAL      PCurrency= TRNCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(86):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(86):0 P_XML
     C                   ENDIF

     C                   IF        TASI35 <> *BLANKS OR TACC11 <> *BLANKS
     C                   IF        TASI35 <> *BLANKS
     C                   EVAL      PInput1 = TASI35
     C                   ELSE
     C                   EVAL      PInput1 = TACC11
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(92):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(92):0 P_XML
     C                   ENDIF


     C                   IF        TINST1 <> *BLANKS or TINST2 <> *BLANKS or
     C                             TINST3 <> *BLANKS or TINST4 <> *BLANKS or
     C                             TINST5 <> *BLANKS or TINSTA <> *BLANKS

     C                   IF        TINST1 <> *BLANKS or TINST2 <> *BLANKS or
     C                             TINST3 <> *BLANKS or TINST4 <> *BLANKS or
     C                             TINST5 <> *BLANKS
     C                   EVAL      PInput1 = TINST1
     C                   EVAL      PInput2 = TINST2
     C                   EVAL      PInput3 = TINST3
     C                   EVAL      PInput4 = TINST4
     C                   EVAL      PInput5 = TINST5
     C                   EVAL      PCurrency= PAYCCY
     C                   ELSE
     C                   EVAL      PInput1 = TINSTA
     C                   EVAL      PCurrency= PAYCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(88):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(88):0 P_XML
     C                   ENDIF

     C                   IF        TACA35 <> *BLANKS or TACB35 <> *BLANKS or
     C                             TACC35 <> *BLANKS or TACD35 <> *BLANKS or
     C                             TACE35 <> *BLANKS or TACA11 <> *BLANKS

     C                   IF        TACA35 <> *BLANKS or TACB35 <> *BLANKS or
     C                             TACC35 <> *BLANKS or TACD35 <> *BLANKS or
     C                             TACE35 <> *BLANKS
     C                   EVAL      PInput1 = TACA35
     C                   EVAL      PInput2 = TACB35
     C                   EVAL      PInput3 = TACC35
     C                   EVAL      PInput4 = TACD35
     C                   EVAL      PInput5 = TACE35
     C                   EVAL      PCurrency= PAYCCY
     C                   ELSE
     C                   EVAL      PInput1 = TACA11
     C                   EVAL      PCurrency= PAYCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(82):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(82):0 P_XML
     C                   ENDIF

     C                   IF        TBNA35 <> *BLANKS or TBNB35 <> *BLANKS or
     C                             TBNC35 <> *BLANKS or TBND35 <> *BLANKS or
     C                             TBNE35 <> *BLANKS
     C                   EVAL      PInput1 = TBNA35
     C                   EVAL      PInput2 = TBNB35
     C                   EVAL      PInput3 = TBNC35
     C                   EVAL      PInput4 = TBND35
     C                   EVAL      PInput5 = TBNE35
     C                   EVAL      PCurrency= PAYCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(83):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(83):0 P_XML
     C                   ENDIF

     C                   IF        TRMA35 <> *BLANKS or TRMB35 <> *BLANKS or
     C                             TRMC35 <> *BLANKS or TRMD35 <> *BLANKS
     C                   EVAL      PInput1 = TRMA35
     C                   EVAL      PInput2 = TRMB35
     C                   EVAL      PInput3 = TRMC35
     C                   EVAL      PInput4 = TRMD35
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(93):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(93):0 P_XML
     C                   ENDIF

     C                   IF        P_XML <> *BLANKS

      ** Setup first parameter for Compliance Engine Program

     C                   EXSR      Sr1stRFTParm

      ** Send transaction details to Compliance Watch

     C                   EXSR      SrEngine
     C                   ENDIF
     C     RFTID         READE     FT101DD0                             0101
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRFTHProcess - Calling of Engine Program for RFT            *
      *                                                               *
      *****************************************************************

     C     SrRFTHProcess BEGSR

      ** Header

     C                   IF        RFTDST <> *BLANKS
     C                   EVAL      PInput1 = RFTDST
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(89):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(89):0 P_XML
     C                   ENDIF

     C                   IF        HINPTY <> *BLANKS
     C                   EVAL      PInput1 = HINPTY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(91):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(91):0 P_XML
     C                   ENDIF

     C                   IF        HOCUS1 <> *BLANKS or HOCUS2 <> *BLANKS or
     C                             HOCUS3 <> *BLANKS or HOCUS4 <> *BLANKS or
     C                             HOCUS5 <> *BLANKS
     C                   EVAL      PInput1 = HOCUS1
     C                   EVAL      PInput2 = HOCUS2
     C                   EVAL      PInput3 = HOCUS3
     C                   EVAL      PInput4 = HOCUS4
     C                   EVAL      PInput5 = HOCUS5
     C                   EVAL      PCurrency = TRNCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(86):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(86):0 P_XML
     C                   ENDIF

     C                   IF        HACSV1 <> *BLANKS or HACSV2 <> *BLANKS
     C                   IF        HACSV1 <> *BLANKS
     C                   EVAL      PInput1 = HACSV1
     C                   ELSE
     C                   EVAL      PInput1 = HACSV2
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(92):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(92):0 P_XML
     C                   ENDIF

     C                   IF        SINST <> *BLANKS
     C                   EVAL      PInput1 = SINST
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(100):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(100):0P_XML
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stRFTParm - Setup first parm for Compliance Engine Prgm   *
      *                                                               *
      *****************************************************************

     C     Sr1stRFTParm  BEGSR

      ** Setup first parameter for Compliance Engine Program

      ** Identifier

     C                   EVAL      W4IDEN = RFTID

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FTREQT'

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'FT101HPD'

      ** Counter Party Number

     C                   IF        PYTP = 'RI'
     C                   EVAL      PInput1 = HOCUS1
     C                   EVAL      PCurrency = *BLANKS
     C                   EXSR      SrFormat
     C                   ELSE
     C                   EVAL      PInput1 = RFTDST
     C                   EVAL      PCurrency = *BLANKS
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 <> '*CPART' AND POutput2 <> '*FREE'
     C                   EVAL      W4CNUM = POutput2

     C                   MOVEL     W4CNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  070
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

     C                   ENDIF

      ** Deal Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  071
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      DBTVDT        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  072
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  073
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4Den1 = TRNCCY

      ** Denomination Side 2

     C                   EVAL      W4Den2 = PAYCCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      TRNAMT        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  074
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      PAYAMT        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  075
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT2 = POutAmtNum

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmFt102hpd - Setup the Parameters 1 and 2 for FT102HPD   *
      *                                                               *
      *****************************************************************
     C     SrParmFt102hpdBEGSR

     C     K_H2Cctid     CHAIN     FT102HL3
     C                   IF        NOT %FOUND(FT102HL3)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

     C                   EVAL      *IN02 = *OFF

     C     CCTID         SETLL     FT102DD0
     C     CCTID         READE     FT102DD0                             0202

     C                   IF        *IN02 = *ON
     C                   EXSR      SRCCTHProcess

     C                   IF        P_XML <> *BLANKS

      ** Setup first parameter for Compliance Engine Program

     C                   EXSR      Sr1stCCTParm

      ** Send transaction details to Compliance Watch

     C                   EXSR      SrEngine
     C                   ENDIF
     C                   ENDIF

     C                   DOW       *IN02 = *OFF

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** Header

     C                   EXSR      SRCCTHProcess

      ** Process CCT Detail File

     C                   IF        ORDCU1 <> *BLANKS or ORDCU2 <> *BLANKS or
     C                             ORDCU3 <> *BLANKS or ORDCU4 <> *BLANKS
     C                             or ORDCU5 <> *BLANKS                                       CSW207
     C                   EVAL      PInput1 = ORDCU1
     C                   EVAL      PInput2 = ORDCU2
     C                   EVAL      PInput3 = ORDCU3
     C                   EVAL      PInput4 = ORDCU4
     C                   EVAL      PInput5 = ORDCU5                                           CSW207
     C                   EVAL      PCurrency= PAYCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(86):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(86):0 P_XML
     C                   ENDIF

     C                   IF        ORDI35 <> *BLANKS or ORDI11 <> *BLANKS
     C                   IF        ORDI35 <> *BLANKS
     C                   EVAL      PInput1 = ORDI35
     C                   EVAL      PCurrency= PAYCCY
     C                   ELSE
     C                   EVAL      PInput1 = ORDI11
     C                   EVAL      PCurrency= PAYCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(101):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(101):0P_XML
     C                   ENDIF

     C                   IF        ACCI35 <> *BLANKS or ACCI11 <> *BLANKS
     C                   IF        ACCI35 <> *BLANKS
     C                   EVAL      PInput1 = ACCI35
     C                   EVAL      PCurrency= PAYCCY
     C                   ELSE
     C                   EVAL      PInput1 = ACCI11
     C                   EVAL      PCurrency= PAYCCY
     C                   ENDIF

     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(82):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(82):0 P_XML
     C                   ENDIF

     C                   IF        BENF1 <> *BLANKS or BENF2 <> *BLANKS or
     C                             BENF3 <> *BLANKS or BENF4 <> *BLANKS or
     C                             BENF5 <> *BLANKS
     C                   EVAL      PInput1 = BENF1
     C                   EVAL      PInput2 = BENF2
     C                   EVAL      PInput3 = BENF3
     C                   EVAL      PInput4 = BENF4
     C                   EVAL      PInput5 = BENF5
     C                   EVAL      PCurrency= PAYCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(83):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(83):0 P_XML
     C                   ENDIF

     C                   IF        REMI1 <> *BLANKS or REMI2 <> *BLANKS or
     C                             REMI3 <> *BLANKS or REMI4 <> *BLANKS
     C                   EVAL      PInput1 = REMI1
     C                   EVAL      PInput2 = REMI2
     C                   EVAL      PInput3 = REMI3
     C                   EVAL      PInput4 = REMI4
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(93):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(93):0 P_XML
     C                   ENDIF

     C                   IF        P_XML <> *BLANKS

      ** Setup first parameter for Compliance Engine Program

     C                   EXSR      Sr1stCCTParm

      ** Send transaction details to Compliance Watch

     C                   EXSR      SrEngine
     C                   ENDIF
     C     CCTID         READE     FT102DD0                             0202
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCCTHProcess - Calling of Engine Program for CCT            *
      *                                                               *
      *****************************************************************

     C     SrCCTHProcess BEGSR

      ** Header

     C                   IF        H2_SINST <> *BLANKS
     C                   EVAL      PInput1 = H2_SINST
     C                   EVAL      PCurrency = H2_CCTCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(100):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(100):0P_XML
     C                   ENDIF

     C                   IF        H2_CCTDST <> *BLANKS
     C                   EVAL      PInput1 = H2_CCTDST
     C                   EVAL      PCurrency = H2_CCTCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(89):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(89):0 P_XML
     C                   ENDIF

     C                   IF        H2_TOCUS1 <> *BLANKS or H2_TOCUS2 <> *BLANKS
     C                             or H2_TOCUS3 <> *BLANKS or
     C                             H2_TOCUS4 <> *BLANKS
     C                             or H2_TOCUS5 <> *BLANKS                                    CSW207
     C                   EVAL      PInput1 = H2_TOCUS1
     C                   EVAL      PInput2 = H2_TOCUS2
     C                   EVAL      PInput3 = H2_TOCUS3
     C                   EVAL      PInput4 = H2_TOCUS4
     C                   EVAL      PInput5 = H2_TOCUS5                                        CSW207
     C                   EVAL      PCurrency = PAYCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(86):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(86):0 P_XML
     C                   ENDIF

     C                   IF        H2_OINST3 <> *BLANKS or H2_OINST1 <> *BLANKS
     C                   IF        H2_OINST3 <> *BLANKS
     C                   EVAL      PInput1 = H2_OINST3
     C                   EVAL      PCurrency = PAYCCY
     C                   ELSE
     C                   EVAL      PInput1 = H2_OINST1
     C                   EVAL      PCurrency = PAYCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(101):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(101):0P_XML
     C                   ENDIF

     C                   IF        H2_SNDCOR <> *BLANKS
     C                   EVAL      PInput1 = H2_SNDCOR
     C                   EVAL      PCurrency = H2_CCTCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(85):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(85):0 P_XML
     C                   ENDIF

     C                   IF        H2_RCVCOR <> *BLANKS
     C                   EVAL      PInput1 = H2_RCVCOR
     C                   EVAL      PCurrency = H2_CCTCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(81):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(81):0 P_XML
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stCctParm - Setup first parm for Compliance Engine Prgm   *
      *                                                               *
      *****************************************************************

     C     Sr1stCctParm  BEGSR

      ** Setup first parameter for Compliance Engine Program

      ** Identifier

     C                   EVAL      W4IDEN = H2_CCTID

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FTCRED'

      ** Branch

     C                   EVAL      W4BRCH = H2_BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'FT102HPD'

      ** Counter Party Number

     C                   IF        H2_CCTTYP = 'BI'

     C                   IF        SINST <> *BLANKS
     C                   EVAL      PInput1 = SINST
     C                   EVAL      PCurrency = CCTCCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 = '*FREE' OR POutput2 = '*CPART'
     C                             OR SINST = *BLANKS
     C                   EVAL      PInput1 = H2_SNDCOR
     C                   EVAL      PCurrency = CCTCCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   ELSE

     C                   IF        TOCUS1 <> *BLANKS
     C                   EVAL      PInput1 = TOCUS1
     C                   EVAL      PCurrency = PAYCCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 = '*FREE' OR POutput2 = '*CPART'
     C                             OR TOCUS1 = *BLANKS
     C                   EVAL      PInput1 = H2_OINST3
     C                   EVAL      PCurrency = PAYCCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 = '*FREE' OR POutput2 = '*CPART' OR
     C                             (TOCUS1 = *BLANKS AND H2_OINST3 = *BLANKS)
     C                   EVAL      PInput1 = H2_OINST1
     C                   EVAL      PCurrency = PAYCCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   ENDIF

     C                   IF        POutput2 <> '*CPART' AND POutput2 <> '*FREE'
     C                   EVAL      W4CNUM = POutput2

     C                   MOVEL     W4CNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  076
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

     C                   ENDIF

      ** Deal Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  077
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      H2_TTVDTE     PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  078
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  079
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4Den1 = CCTCCY

      ** Denomination Side 2

     C                   EVAL      W4Den2 = PAYCCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      CCTAMT        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  080
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = POutAmtNum


      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      PAYAMT        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  081
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT2 = POutAmtNum

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmCqcocdd  - Setup the Parameters 1 and 2 for CQCOCDD    *
      *                                                               *
      *****************************************************************
     C     SrParmCqcocdd BEGSR

     C     K_Pref        CHAIN     CQCODDDF                           03
     C                   IF        *IN03 = *ON OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

     C                   EVAL      *IN04 = *OFF

     C     PREF          SETLL     CQCOCDD2
     C     PREF          READE     CQCOCDD2                             0404

     C                   IF        *IN04 = *ON
     C                   EXSR      SRCQHProcess

     C                   IF        P_XML <> *BLANKS

      ** Setup first parameter for Compliance Engine Program

     C                   EXSR      Sr1stCQParm

      ** Send transaction details to Compliance Watch

     C                   EXSR      SrEngine
     C                   ENDIF
     C                   ENDIF

     C                   DOW       *IN04 = *OFF

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** Header

     C                   EXSR      SRCQHProcess

      ** Cheques Details

     C                   IF        COB1 <> *BLANKS or COB2 <> *BLANKS or
     C                             COB3 <> *BLANKS or COB4 <> *BLANKS
     C                   EVAL      PInput1 = COB1
     C                   EVAL      PInput2 = COB2
     C                   EVAL      PInput3 = COB3
     C                   EVAL      PInput4 = COB4
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(94):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(94):0 P_XML
     C                   ENDIF

     C                   MOVEL     RCCO          WRCCO
     C                   IF        WRCCO <> *BLANKS
     C                   EVAL      PInput1 = WRCCO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(81):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(81):0 P_XML
     C                   ENDIF

     C                   IF        P_XML <> *BLANKS

      ** Setup first parameter for Compliance Engine Program

     C                   EXSR      Sr1stCQParm

      ** Send transaction details to Compliance Watch

     C                   EXSR      SrEngine
     C                   ENDIF
     C     PREF          READE     CQCOCDD2                             0404
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCQHProcess - Calling of Engine Program for CheqColl        *
      *                                                               *
      *****************************************************************

     C     SrCQHProcess  BEGSR

      ** Header

     C                   MOVEL     C1_CRPY       WCRPY
     C                   IF        WCRPY <> *Blanks
     C                   EVAL      PInput1 = WCRPY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(95):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(95):0 P_XML
     C                   ENDIF

     C                   IF        C1_NAR1 <> *BLANKS or C1_NAR2 <> *BLANKS or
     C                             C1_NAR3 <> *BLANKS or C1_NAR4 <> *BLANKS or
     C                             C1_NAR5 <> *BLANKS or C1_NAR6 <> *BLANKS
     C                   EVAL      PInput1 = C1_NAR1
     C                   EVAL      PInput2 = C1_NAR2
     C                   EVAL      PInput3 = C1_NAR3
     C                   EVAL      PInput4 = C1_NAR4
     C                   EVAL      PInput5 = C1_NAR5
     C                   EVAL      PInput6 = C1_NAR6
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(96):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(96):0 P_XML
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stCQParm - Setup first parm for Compliance Engine Program *
      *                                                               *
      *****************************************************************

     C     Sr1stCQParm   BEGSR

      ** Setup first parameter for Compliance Engine Program

      ** Identifier

     C                   EVAL      W4IDEN = C1_PREF

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FTCHQC'

      ** Branch

     C                   EVAL      W4BRCH = C1_BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'CQCOCDD'

      ** Counter Party Number

     C                   IF        COB1 <> *BLANKS OR COB2 <> *BLANKS
     C                             OR COB3 <> *BLANKS OR COB4 <> *BLANKS
     C                   EVAL      PInput1 = COB1
     C                   EVAL      PInput2 = COB2
     C                   EVAL      PInput3 = COB3
     C                   EVAL      PInput4 = COB4
     C                   EVAL      PCurrency = SMCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 = '*CPART' OR POutput2 = '*FREE' OR
     C                             (COB1 = *BLANKS AND  COB2 = *BLANKS
     C                             AND COB3 = *BLANKS AND COB4 = *BLANKS)
     C                   MOVE      RCCO          PInput1
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PCurrency = SMCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 <> '*CPART' AND POutput2 <> '*FREE'
     C                   EVAL      W4CNUM = POutput2

     C                   MOVEL     W4CNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  082
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST


     C                   ENDIF

      ** Deal Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  083
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  084
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  085
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4Den1 = C1_CRCY

      ** Denomination Side 2

     C                   EVAL      W4Den2 = PDCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      C1_CCYAM      PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  086
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = POutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      PDAM          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  087
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT2 = POutAmtNum

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmCqpacdd  - Setup the Parameters 1 and 2 for CQPACDD    *
      *                                                               *
      *****************************************************************
     C     SrParmCqpacdd BEGSR

     C     K_Pref        CHAIN     CQPACDDF                           05
     C                   IF        *IN05 = *ON OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

     C                   EVAL      *IN06 = *OFF

     C     PREF          SETLL     CQPADDD2
     C     PREF          READE     CQPADDD2                             0606

     C                   IF        *IN06 = *ON
     C                   EXSR      SRCPHProcess

     C                   IF        P_XML <> *BLANKS

      ** Setup first parameter for Compliance Engine Program

     C                   EXSR      Sr1stCPParm

      ** Send transaction details to Compliance Watch

     C                   EXSR      SrEngine
     C                   ENDIF
     C                   ENDIF

     C                   DOW       *IN06 = *OFF

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** Header

     C                   EXSR      SRCPHProcess

      ** Cheques Details

     C                   MOVEL     P1_DRPY       WDRPY
     C                   IF        WDRPY <> *BLANKS
     C                   EVAL      PInput1 = WDRPY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(98):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(98):0 P_XML
     C                   ENDIF


     C                   IF        P_XML <> *BLANKS

      ** Setup first parameter for Compliance Engine Program

     C                   EXSR      Sr1stCPParm

      ** Send transaction details to Compliance Watch

     C                   EXSR      SrEngine
     C                   ENDIF
     C     PREF          READE     CQPADDD2                             0606
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCPHProcess - Calling of Engine Program for CheqPaid        *
      *                                                               *
      *****************************************************************
     C     SrCPHProcess  BEGSR

      ** Header

     C                   IF        RBK1 <> *BLANKS OR RBK2 <> *BLANKS OR
     C                             RBK3 <> *BLANKS OR RBK4 <> *BLANKS
     C                   EVAL      PInput1 = RBK1
     C                   EVAL      PInput2 = RBK2
     C                   EVAL      PInput3 = RBK3
     C                   EVAL      PInput4 = RBK4
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(97):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(97):0 P_XML
     C                   ENDIF

     C                   MOVEL     SNCO          WSNCO
     C                   IF        WSNCO <> *BLANKS
     C                   EVAL      PInput1 = WSNCO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(85):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(85):0 P_XML
     C                   ENDIF

     C                   IF        RCO1 <> *BLANKS OR RCO2 <> *BLANKS OR
     C                             RCO3 <> *BLANKS OR RCO4 <> *BLANKS OR
     C                             RCO5 <> *BLANKS
     C                   EVAL      PInput1 = RCO1
     C                   EVAL      PInput2 = RCO2
     C                   EVAL      PInput3 = RCO3
     C                   EVAL      PInput4 = RCO4
     C                   EVAL      PInput5 = RCO5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(81):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(81):0 P_XML
     C                   ENDIF

     C                   IF        ACB1 <> *BLANKS OR ACB2 <> *BLANKS OR
     C                             ACB3 <> *BLANKS OR ACB4 <> *BLANKS OR
     C                             ACB5 <> *BLANKS
     C                   EVAL      PInput1 = ACB1
     C                   EVAL      PInput2 = ACB2
     C                   EVAL      PInput3 = ACB3
     C                   EVAL      PInput4 = ACB4
     C                   EVAL      PInput5 = ACB5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(82):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(82):0 P_XML
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stCPParm - Setup first parm for Compliance Engine Program *
      *                                                               *
      *****************************************************************

     C     Sr1stCPParm   BEGSR

      ** Setup first parameter for Compliance Engine Program

      ** Identifier

     C                   EVAL      W4IDEN = PREF

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FTCHQP'

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'CQPACDD'

      ** Counter Party Number

     C                   IF        RBK1 <> *BLANKS OR RBK2 <> *BLANKS
     C                             OR RBK3 <> *BLANKS OR RBK4 <> *BLANKS
     C                   EVAL      PInput1 = RBK1
     C                   EVAL      PInput2 = RBK2
     C                   EVAL      PInput3 = RBK3
     C                   EVAL      PInput4 = RBK4
     C                   EVAL      PCurrency = PCCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 = '*CPART' OR POutput2 = '*FREE' OR
     C                             (RBK1 = *BLANKS AND RBK2 = *BLANKS
     C                             AND RBK3 = *BLANKS AND RBK4 = *BLANKS)
     C                   MOVE      SNCO          PInput1
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PCurrency= PCCY
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   IF        POutput2 <> '*CPART' AND POutput2 <> '*FREE'
     C                   EVAL      W4CNUM = POutput2

     C                   MOVEL     W4CNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  088
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

     C                   ENDIF

      ** Deal Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  089
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      PVDT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  090
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  091
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = PCCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      TOTR          PInAmt

     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  092
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmNtrandd - Setup the Parameters 1 and 2 for NTRANDD     *
      *                                                               *
      *****************************************************************
     C     SrParmNtrandd BEGSR

     C     K_Tfrf        CHAIN     NTRAN
     C                   IF        NOT %FOUND(NTRAN) OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter
     C                   MOVEL     DEST          WDEST
     C                   IF        WDEST <> *BLANKS
     C                   EVAL      PInput1 = WDEST
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(89):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(89):0 P_XML
     C                   ENDIF

     C                   MOVEL     ACBN          WACBN
     C                   IF        WACBN <> *BLANKS
     C                   EVAL      PInput1 = WACBN
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(82):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(82):0 P_XML
     C                   ENDIF

     C                   IF        NTINB1 <> *BLANKS OR NTINB2 <> *BLANKS OR
     C                             NTINB3 <> *BLANKS OR NTINB4 <> *BLANKS OR
     C                             NTINB5 <> *BLANKS
     C                   EVAL      PInput1 = NTINB1
     C                   EVAL      PInput2 = NTINB2
     C                   EVAL      PInput3 = NTINB3
     C                   EVAL      PInput4 = NTINB4
     C                   EVAL      PInput5 = NTINB5
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(88):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(88):0 P_XML
     C                   ENDIF


      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   EVAL      W4IDEN = TFRF

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FTNOST'

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'NTRANDD'

      ** Counter Party Number

     C                   MOVE      DEST          PInput1
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat

     C                   IF        POutput2 <> '*CPART' AND POutput2 <> '*FREE'
     C                   EVAL      W4CNUM = POutput2

      ** Get Customer Detail

     C                   MOVEL     W4CNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  093
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

     C                   ENDIF

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  094
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVE      VDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  095
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  096
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = CCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      AMNT          PInAmt
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  097
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = POutAmtNum

      ** Amount Side 2

     C                   Z-ADD     *ZEROS        W4AMT2



     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmDealsdb - Setup the Parameters 1 and 2 for DEALSDB     *
      *                                                               *
      *****************************************************************
     C     SrParmDealsdb BEGSR

     C     K_Dlno        CHAIN     DEALSDBF                           07
     C                   IF        *IN07 = *ON OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   IF        RSCY <> *BLANKS
     C                   EVAL      PCurrency= RSCY
     C                   ELSE
     C                   EVAL      PCurrency= PUCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   IF        PSCY <> *BLANKS
     C                   EVAL      PCurrency = PSCY
     C                   ELSE
     C                   EVAL      PCurrency = SLCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     DLNO          W4IDEN

      ** Item Type Code

     C                   EVAL      W4ITEM = 'DLNT  '

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'DEALSDB '

      ** Counter Party Number

     C                   MOVEL     CNUM          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     CNUM          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  098
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     DDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  099
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     VDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  100
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     OTDT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  101
     C                   EVAL      DBPROC =  'SrWtchCloancl'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = PUCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = SLCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      PUAM          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      SLAM          PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT2 = PoutAmtNum

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmDealsdg - Setup the Parameters 1 and 2 for DEALSDG     *
      *                                                               *
      *****************************************************************
     C     SrParmDealsdg BEGSR

     C     K_Dlno        CHAIN     DEALSDGF                           08
     C                   IF        *IN08 = *ON OR RECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Interest

      ** Receipt Nostro

     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   IF        RSCY <> *BLANKS
     C                   EVAL      PCurrency= RSCY
     C                   ELSE
     C                   EVAL      PCurrency= TCUCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   IF        PSCY <> *BLANKS
     C                   EVAL      PCurrency = PSCY
     C                   ELSE
     C                   EVAL      PCurrency = UCUCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

      ** Maturity

     C                   EVAL      K_Rxedcd = 'MAT'

     C     K_Dlgxstl0    CHAIN     DLGXSTL0

     C                   IF        %FOUND(DLGXSTL0)

      ** Receipt Nostro

     C                   IF        RXRONS <> *BLANKS
     C                   EVAL      PInput1 = RXRONS
     C                   IF        RXRSCY <> *BLANKS
     C                   EVAL      PCurrency= RXRSCY
     C                   ELSE
     C                   EVAL      PCurrency= TCUCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RXRIBN <> *BLANKS OR RXRIBA <> *BLANKS
     C                   EVAL      PInput1 = RXRIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXRIBA:0      P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        RXROBN <> *ZERO                                            CSD027
     C                   IF        RXROBN <> *BLANKS                                          CSD027
     C                   MOVEL     RXROBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        RXROCN <> *ZERO                                            CSD027
     C                   IF        RXROCN <> *BLANKS                                          CSD027
     C                   MOVEL     RXROCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        RXPONS <> *BLANKS
     C                   EVAL      PInput1 = RXPONS
     C                   IF        RXPSCY <> *BLANKS
     C                   EVAL      PCurrency = RXPSCY
     C                   ELSE
     C                   EVAL      PCurrency = UCUCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        RXPIBN <> *BLANKS OR RXPIBA <> *BLANKS
     C                   EVAL      PInput1 = RXPIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXPIBA:0      P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        RXPOBN <> *ZERO                                            CSD027
     C                   IF        RXPOBN <> *BLANKS                                          CSD027
     C                   MOVEL     RXPOBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        RXPOCN <> *ZERO                                            CSD027
     C                   IF        RXPOCN <> *BLANKS                                          CSD027
     C                   MOVEL     RXPOCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RXRCRN <> *BLANKS OR RXRCRA <> *BLANKS
     C                   EVAL      PInput1 = RXRCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXRCRA:0      P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RXRVNO <> *BLANKS
     C                   EVAL      PInput1 = RXRVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        RXAWBN <> *BLANKS OR RXAWBA <> *BLANKS
     C                   EVAL      PInput1 = RXAWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXAWBA:0      P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        RXBENN <> *BLANKS OR RXBENA <> *BLANKS
     C                   EVAL      PInput1 = RXBENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXBENA:0      P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        RXDTP1 <> *BLANKS OR RXDTP2 <> *BLANKS
     C                             OR RXDTP3 <> *BLANKS OR RXDTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       RXDTP1:0      P_XML
     C     P_XML         CAT       RXDTP2:0      P_XML
     C     P_XML         CAT       RXDTP3:0      P_XML
     C     P_XML         CAT       RXDTP4:0      P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

     C                   ENDIF

      ** Value

     C                   EVAL      K_Rxedcd = 'VAL'

     C     K_Dlgxstl0    CHAIN     DLGXSTL0

     C                   IF        %FOUND(DLGXSTL0)

      ** Receipt Nostro

     C                   IF        RXRONS <> *BLANKS
     C                   EVAL      PInput1 = RXRONS
     C                   IF        RXRSCY <> *BLANKS
     C                   EVAL      PCurrency= RXRSCY
     C                   ELSE
     C                   EVAL      PCurrency= UCUCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        RXRIBN <> *BLANKS OR RXRIBA <> *BLANKS
     C                   EVAL      PInput1 = RXRIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXRIBA:0      P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        RXROBN <> *ZERO                                            CSD027
     C                   IF        RXROBN <> *BLANKS                                          CSD027
     C                   MOVEL     RXROBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        RXROCN <> *ZERO                                            CSD027
     C                   IF        RXROCN <> *BLANKS                                          CSD027
     C                   MOVEL     RXROCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        RXPONS <> *BLANKS
     C                   EVAL      PInput1 = RXPONS
     C                   IF        RXPSCY <> *BLANKS
     C                   EVAL      PCurrency = RXPSCY
     C                   ELSE
     C                   EVAL      PCurrency = TCUCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        RXPIBN <> *BLANKS OR RXPIBA <> *BLANKS
     C                   EVAL      PInput1 = RXPIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXPIBA:0      P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        RXPOBN <> *ZERO                                            CSD027
     C                   IF        RXPOBN <> *BLANKS                                          CSD027
     C                   MOVEL     RXPOBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        RXPOCN <> *ZERO                                            CSD027
     C                   IF        RXPOCN <> *BLANKS                                          CSD027
     C                   MOVEL     RXPOCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        RXRCRN <> *BLANKS OR RXRCRA <> *BLANKS
     C                   EVAL      PInput1 = RXRCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXRCRA:0      P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        RXRVNO <> *BLANKS
     C                   EVAL      PInput1 = RXRVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        RXAWBN <> *BLANKS OR RXAWBA <> *BLANKS
     C                   EVAL      PInput1 = RXAWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXAWBA:0      P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        RXBENN <> *BLANKS OR RXBENA <> *BLANKS
     C                   EVAL      PInput1 = RXBENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RXBENA:0      P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        RXDTP1 <> *BLANKS OR RXDTP2 <> *BLANKS
     C                             OR RXDTP3 <> *BLANKS OR RXDTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       RXDTP1:0      P_XML
     C     P_XML         CAT       RXDTP2:0      P_XML
     C     P_XML         CAT       RXDTP3:0      P_XML
     C     P_XML         CAT       RXDTP4:0      P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

     C                   ENDIF
      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     DLNO          W4IDEN

      ** Item Type Code

     C     'IR'          CAT       DTYP:0        W4ITEM

      ** Branch

     C                   EVAL      W4BRCH = BRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'DEALSDG '

      ** Counter Party Number

     C                   MOVEL     CNUM          W4CNUM

      ** Get Customer Detail

     C                   MOVEL     CNUM          PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  104
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     DDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  105
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     VDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  106
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     MDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  107
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = UCUCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = TCUCY

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      UPAMT         PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  108
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      TPAMT         PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  109
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT2 = PoutAmtNum

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmFxclspsh - Setup the Parameters 1 and 2 for FXCLSPSH   *
      *                                                               *
      *****************************************************************
     C     SrParmFxclspshBEGSR

     C     K_Fxclspsh    CHAIN     FXCLSPSDL0
     C                   IF        NOT %FOUND(FXCLSPSDL0) OR PYRECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Get Nostro Details

      ** Use the CLS Dummy Nostro first.

     C                   EVAL      PCcy = PYCCY
     C                   EVAL      PNostCode = PYNOST
     C                   EXSR      SrGetNstDet

      ** This time, use the CLS Pay/Receive Nostro Code.

     C                   EVAL      PNostCode = A7LPR
     C                   EXSR      SRGetNstDet

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      **  CLS Pay/Receive Nostro Code

     C                   IF        A7LPR <> *BLANKS
     C                   EVAL      PInput1 = A7LPR
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(115):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(115):0P_XML
     C                   ENDIF

      ** Customer Number

     C                   IF        A7CUST <> *BLANKS
     C                   EVAL      PInput1 = A7CUST
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(124):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(124):0P_XML
     C                   ENDIF

      ** CLS Settlement Member

     C**********         IF        A7CLSM <> *ZERO                                            CSD027
     C                   IF        A7CLSM <> *BLANKS                                          CSD027
     C                   MOVEL     A7CLSM        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(118):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(118):0P_XML
     C                   ENDIF

      ** CLS Settlement Member

     C**********         IF        A7CLSM <> *ZERO                                            CSD027
     C                   IF        A7CLSM <> *BLANKS                                          CSD027
     C                   MOVEL     A7CLSM        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(123):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(123):0P_XML
     C                   ENDIF

      ** CLS Settlement Members Corr

     C**********         IF        A7CLSC <> *ZERO                                            CSD027
     C                   IF        A7CLSC <> *BLANKS                                          CSD027
     C                   MOVEL     A7CLSC        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(122):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(122):0P_XML
     C                   ENDIF
      *

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVE      PYVDAT        WVDAT
     C                   MOVE      PYSEQN        WSEQN
     C                   EVAL      W4IDEN = PYCCY + PYNOST + WVDAT + WSEQN

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FXCLSP'

      ** Branch

     C                   EVAL      W4BRCH = A7BRCD

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'FXCLSPSH'

      ** Counter Party Number

     C                   MOVEL     A7CUST        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     A7CUST        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  110
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     *ZERO         PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  111
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     PYVDAT        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  112
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     MDAT          PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  113
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = PYCCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      PYAMT         PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  114
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetNstDet - Gets the Nostro details given a currency and    *
      *               Nostro Code pair.                               *
      *                                                               *
      *****************************************************************
     C     SRGetNstDet   BEGSR
      *
      ** Access Nostro Details.
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       PCUST
     C                   PARM                    PCcy
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSN
     C                   PARM                    PNostCode
     C                   PARM      *BLANKS       PBRCD
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        @RtCd <> *BLANKS AND
     C                             @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBKEY = PCcy + PNostCode
     C                   EVAL      DBASE = 115
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmMmdeampp - Setup the Parameters 1 and 2 for MMDEAMPP   *
      *                                                               *
      *****************************************************************
     C     SrParmMmdeamppBEGSR

     C     K_Mmdeampp    CHAIN     MMDEAMLL
     C                   IF        NOT %FOUND (MMDEAMLL)
     C                             OR (HNDSTS <> 'C' AND HNDSTS <> 'A'
     C                             AND HNDSTS <> 'R')
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        HNRONS <> *BLANKS
     C                   EVAL      PInput1 = HNRONS
     C                   IF        HNSTCY <> *BLANKS
     C                   EVAL      PCurrency= HNSTCY
     C                   ELSE
     C                   EVAL      PCurrency= HNCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        HNRIBN <> *BLANKS OR HNRIBA <> *BLANKS
     C                   EVAL      PInput1 = HNRIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HNRIBA:0      P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        HNROBN <> *ZERO                                            CSD027
     C                   IF        HNROBN <> *BLANKS                                          CSD027
     C                   MOVEL     HNROBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        HNROCN <> *ZERO                                            CSD027
     C                   IF        HNROCN <> *BLANKS                                          CSD027
     C                   MOVEL     HNROCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        HNPONS <> *BLANKS
     C                   EVAL      PInput1 = HNPONS
     C                   IF        HNSTCY <> *BLANKS
     C                   EVAL      PCurrency= HNSTCY
     C                   ELSE
     C                   EVAL      PCurrency= HNCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        HNPIBN <> *BLANKS OR HNPIBA <> *BLANKS
     C                   EVAL      PInput1 = HNPIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HNPIBA:0      P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        HNPOBN <> *ZERO                                            CSD027
     C                   IF        HNPOBN <> *BLANKS                                          CSD027
     C                   MOVEL     HNPOBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        HNPOCN <> *ZERO                                            CSD027
     C                   IF        HNPOCN <> *BLANKS                                          CSD027
     C                   MOVEL     HNPOCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        HNRCRN <> *BLANKS OR HNRCRA <> *BLANKS
     C                   EVAL      PInput1 = HNRCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HNRCRA:0      P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        HNRVNO <> *BLANKS
     C                   EVAL      PInput1 = HNRVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        HNAWBN <> *BLANKS OR HNAWBA <> *BLANKS
     C                   EVAL      PInput1 = HNAWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HNAWBA:0      P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        HNBENN <> *BLANKS OR HNBENA <> *BLANKS
     C                   EVAL      PInput1 = HNBENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HNBENA:0      P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        HNDTP1 <> *BLANKS OR HNDTP2 <> *BLANKS
     C                             OR HNDTP3 <> *BLANKS OR HNDTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       HNDTP1:0      P_XML
     C     P_XML         CAT       HNDTP2:0      P_XML
     C     P_XML         CAT       HNDTP3:0      P_XML
     C     P_XML         CAT       HNDTP4:0      P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     HNDA38        WDA38
     C                   MOVEL     HNVDYY        WVDYY
     C                   MOVEL     HNVDMM        WVDMM
     C                   MOVEL     HNVDDD        WVDDD
     C                   MOVEL     HNDS38        WDS38
     C                   EVAL      W4IDEN= WDA38 + WVDYY + WVDMM + WVDDD + WDS38

      ** Item Type Code

     C     'MM'          CAT       HNMTYP:0      W4ITEM

      ** Branch

     C                   EVAL      W4BRCH = HNBRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'MMDEAMPP'

      ** Counter Party Number

     C                   MOVEL     HNCNUM        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     HNCNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  116
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date
     C                   EVAL      WLongYr = HNDMDY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HNDMDM
     C                   EVAL      PZDay = HNDMDD
      *
     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  117
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   EVAL      WLongYr = HNVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HNVDMM
     C                   EVAL      PZDay = HNVDDD

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  118
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  119
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = HNCCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      HNAMNP        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  120
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmFxnetmpd - Setup the Parameters 1 and 2 for FXNETMPD   *
      *                                                               *
      *****************************************************************
     C     SrParmFxnetmpdBEGSR

     C     K_Amnetr      CHAIN     FXNETML3
     C                   IF        NOT %FOUND (FXNETML3)
     C                             OR AMRECI <> 'D'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Our Nostro

     C                   IF        AMOURN <> *BLANKS
     C                   EVAL      PInput1 = AMOURN
     C                   EVAL      PCurrency= AMCCYD
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(116):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(116):0P_XML
     C                   ENDIF

      ** Intermediary Bank  + Account Line

     C                   IF        AMIBNK <> *BLANKS OR AMIBNA <> *BLANKS
     C                   EVAL      PInput1 = AMIBNK
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(117):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AMIBNA:0      P_XML
     C     P_XML         CAT       ClosTag(117):0P_XML
     C                   ENDIF

      ** Ordering Bank

     C                   IF        AMOBNK <> *ZERO
     C                   MOVEL     AMOBNK        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(118):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(118):0P_XML
     C                   ENDIF

      ** Ordering Customer

     C                   IF        AMORDC <> *ZERO
     C                   MOVEL     AMORDC        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(119):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(119):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        AMRCRN <> *BLANKS OR AMRCRA <> *BLANKS
     C                   EVAL      PInput1 = AMRCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(120):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AMRCRA:0      P_XML
     C     P_XML         CAT       ClosTag(120):0P_XML
     C                   ENDIF

      ** Receiver Number

     C                   IF        AMRVNO <> *BLANKS
     C                   EVAL      PInput1 = AMRVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(121):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(121):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        AMAWBN <> *BLANKS OR AMAWBA <> *BLANKS
     C                   EVAL      PInput1 = AMAWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(122):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AMAWBA:0      P_XML
     C     P_XML         CAT       ClosTag(122):0P_XML
     C                   ENDIF

      ** Beneficiary Number + Account Line

     C                   IF        AMBENN <> *BLANKS OR AMBENA <> *BLANKS
     C                   EVAL      PInput1 = AMBENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(123):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AMBENA:0      P_XML
     C     P_XML         CAT       ClosTag(123):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        AMDTP1 <> *BLANKS OR AMDTP2 <> *BLANKS
     C                             OR AMDTP3 <> *BLANKS OR AMDTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       AMDTP1:0      P_XML
     C     P_XML         CAT       AMDTP2:0      P_XML
     C     P_XML         CAT       AMDTP3:0      P_XML
     C     P_XML         CAT       AMDTP4:0      P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   EVAL      W4IDEN= AMNETR

      ** Item Type Code

     C                   EVAL      W4ITEM = 'FXNET'

      ** Branch

     C                   EVAL      W4BRCH = AMBRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'FXNETMPD'

      ** Counter Party Number

     C                   MOVEL     AMCNUM        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     AMCNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  121
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   MOVEL     '000000'      PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  122
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   MOVEL     AMVALD        PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  123
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  124
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = AMCCYD

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      AMDBUY        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  125
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmFxdealpp - Setup the Parameters 1 and 2 for FXDEALPP   *
      *                                                               *
      *****************************************************************
     C     SrParmFxdealppBEGSR

     C     K_Fhdn38      CHAIN     FXDEALLL
     C                   IF        NOT %FOUND (FXDEALLL) OR
     C                             (FHDSTS <> 'C' AND FHDSTS <> 'A'
     C                             AND FHDSTS <> 'R')
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        FHRONS <> *BLANKS
     C                   EVAL      PInput1 = FHRONS
     C                   IF        FHRSCY <> *BLANKS
     C                   EVAL      PCurrency= FHRSCY
     C                   ELSE
     C                   EVAL      PCurrency= FHCCY1
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        FHRIBN <> *BLANKS OR FHRIBA <> *BLANKS
     C                   EVAL      PInput1 = FHRIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       FHRIBA:0      P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        FHROBN <> *ZERO                                            CSD027
     C                   IF        FHROBN <> *BLANKS                                          CSD027
     C                   MOVEL     FHROBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        FHROCN <> *ZERO                                            CSD027
     C                   IF        FHROCN <> *BLANKS                                          CSD027
     C                   MOVEL     FHROCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        FHPONS <> *BLANKS
     C                   EVAL      PInput1 = FHPONS
     C                   IF        FHPSCY <> *BLANKS
     C                   EVAL      PCurrency = FHPSCY
     C                   ELSE
     C                   EVAL      PCurrency = FHCCY2
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        FHPIBN <> *BLANKS OR FHPIBA <> *BLANKS
     C                   EVAL      PInput1 = FHPIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       FHPIBA:0      P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        FHPOBN <> *ZERO                                            CSD027
     C                   IF        FHPOBN <> *BLANKS                                          CSD027
     C                   MOVEL     FHPOBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        FHPOCN <> *ZERO                                            CSD027
     C                   IF        FHPOCN <> *BLANKS                                          CSD027
     C                   MOVEL     FHPOCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        FHRCRN <> *BLANKS OR FHRCRA <> *BLANKS
     C                   EVAL      PInput1 = FHRCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       FHRCRA:0      P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        FHRVNO <> *BLANKS
     C                   EVAL      PInput1 = FHRVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        FHAWBN <> *BLANKS OR FHAWBA <> *BLANKS
     C                   EVAL      PInput1 = FHAWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       FHAWBA:0      P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        FHBENN <> *BLANKS OR FHBENA <> *BLANKS
     C                   EVAL      PInput1 = FHBENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       FHBENA:0      P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        FHDTP1 <> *BLANKS OR FHDTP2 <> *BLANKS
     C                             OR FHDTP3 <> *BLANKS OR FHDTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       FHDTP1:0      P_XML
     C     P_XML         CAT       FHDTP2:0      P_XML
     C     P_XML         CAT       FHDTP3:0      P_XML
     C     P_XML         CAT       FHDTP4:0      P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     FHDN38        W4IDEN

      ** Item Type Code

     C     'FX'          CAT       FHTYPE:0      W4ITEM

      ** Branch

     C                   EVAL      W4BRCH = FHMBCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'FXDEALPP'

      ** Counter Party Number

     C                   MOVEL     FHDCNO        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     FHDCNO        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  126
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   EVAL      WLongYr = FHDDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = FHDDMM
     C                   EVAL      PZDay = FHDDDD

     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  127
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   EVAL      WLongYr = FHVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = FHVDMM
     C                   EVAL      PZDay = FHVDDD

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  128
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   EVAL      WLongYr = FHDOEY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = FHDOEM
     C                   EVAL      PZDay = FHDOED

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  129
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = FHCCY1

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = FHCCY2

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      FHDBUY        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  130
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN2

     C                   EXSR      SrCurrDet

      ** Format Amount 2

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN2
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      FHDSEL        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  131
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT2 = PoutAmtNum

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmMmdeldpp - Setup the Parameters 1 and 2 for MMDELDPP   *
      *                                                               *
      *****************************************************************
     C     SrParmMmdeldppBEGSR

     C     K_Hkdn38      CHAIN     MMDELDP0                           09
     C                   IF        *IN09 = *ON OR
     C                             (HKDSTS <> 'C' AND HKDSTS <> 'A'
     C                             AND HKDSTS <> 'R')
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        HKRONS <> *BLANKS
     C                   EVAL      PInput1 = HKRONS
     C                   IF        HKSTCY  > *BLANKS
     C                   EVAL      PCurrency= HKSTCY
     C                   ELSE
     C                   EVAL      PCurrency= HKCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        HKRIBN <> *BLANKS OR HKRIBA <> *BLANKS
     C                   EVAL      PInput1 = HKRIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HKRIBA:0      P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        HKROBN <> *ZERO                                            CSD027
     C                   IF        HKROBN <> *BLANKS                                          CSD027
     C                   MOVEL     HKROBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        HKROCN <> *ZERO                                            CSD027
     C                   IF        HKROCN <> *BLANKS                                          CSD027
     C                   MOVEL     HKROCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        HKPONS <> *BLANKS
     C                   EVAL      PInput1 = HKPONS
     C                   IF        HKSTCY <> *BLANKS
     C                   EVAL      PCurrency = HKSTCY
     C                   ELSE
     C                   EVAL      PCurrency = HKCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        HKPIBN <> *BLANKS OR HKPIBA <> *BLANKS
     C                   EVAL      PInput1 = HKPIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HKPIBA:0      P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        HKPOBN <> *ZERO                                            CSD027
     C                   IF        HKPOBN <> *BLANKS                                          CSD027
     C                   MOVEL     HKPOBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        HKPOCN <> *ZERO                                            CSD027
     C                   IF        HKPOCN <> *BLANKS                                          CSD027
     C                   MOVEL     HKPOCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        HKRCRN <> *BLANKS OR HKRCRA <> *BLANKS
     C                   EVAL      PInput1 = HKRCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HKRCRA:0      P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        HKRVNO <> *BLANKS
     C                   EVAL      PInput1 = HKRVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        HKAWBN <> *BLANKS OR HKAWBA <> *BLANKS
     C                   EVAL      PInput1 = HKAWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HKAWBA:0      P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        HKBENN <> *BLANKS OR HKBENA <> *BLANKS
     C                   EVAL      PInput1 = HKBENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HKBENA:0      P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        HKDTP1 <> *BLANKS OR HKDTP2 <> *BLANKS
     C                             OR HKDTP3 <> *BLANKS OR HKDTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       HKDTP1:0      P_XML
     C     P_XML         CAT       HKDTP2:0      P_XML
     C     P_XML         CAT       HKDTP3:0      P_XML
     C     P_XML         CAT       HKDTP4:0      P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     HKDN38        W4IDEN

      ** Item Type Code

     C                   IF        HKDRID = *BLANK
     C     'MM'          CAT       HKMTYP:0      W4ITEM
     C                   ELSE
     C     'SE'          CAT       HKMTYP:0      W4ITEM
     C                   ENDIF

      ** Branch

     C                   EVAL      W4BRCH = HKBRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'MMDELDPP'

      ** Counter Party Number

     C                   MOVEL     HKCNUM        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     HKCNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  132
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   EVAL      WLongYr = HKDDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HKDDMM
     C                   EVAL      PZDay = HKDDDD

     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  133
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   EVAL      WLongYr = HKVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HKVDMM
     C                   EVAL      PZDay = HKVDDD

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  134
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   EVAL      WLongYr = HKMDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HKMDMM
     C                   EVAL      PZDay = HKMDDD

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  135
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = HKCCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      HKAMNP        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  136
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmMmdenbpp - Setup the Parameters 1 and 2 for MMDENBPP   *
      *                                                               *
      *****************************************************************
     C     SrParmMmdenbppBEGSR

     C     K_Hldn38      CHAIN     MMDENBP0                           10
     C                   IF        *IN10 = *ON OR
     C                             (HLDSTS <> 'C' AND HLDSTS <> 'A'
     C                             AND HLDSTS <> 'R')
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        HLRONS <> *BLANKS
     C                   EVAL      PInput1 = HLRONS
     C                   IF        HLSTCY  > *BLANKS
     C                   EVAL      PCurrency= HLSTCY
     C                   ELSE
     C                   EVAL      PCurrency= HLCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        HLRIBN <> *BLANKS OR HLRIBA <> *BLANKS
     C                   EVAL      PInput1 = HLRIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HLRIBA:0      P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        HLROBN <> *ZERO                                            CSD027
     C                   IF        HLROBN <> *BLANKS                                          CSD027
     C                   MOVEL     HLROBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        HLROCN <> *ZERO                                            CSD027
     C                   IF        HLROCN <> *BLANKS                                          CSD027
     C                   MOVEL     HLROCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        HLPONS <> *BLANKS
     C                   EVAL      PInput1 = HLPONS
     C                   IF        HLSTCY <> *BLANKS
     C                   EVAL      PCurrency = HLSTCY
     C                   ELSE
     C                   EVAL      PCurrency = HLCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        HLPIBN <> *BLANKS OR HLPIBA <> *BLANKS
     C                   EVAL      PInput1 = HLPIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HLPIBA:0      P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        HLPOBN <> *ZERO                                            CSD027
     C                   IF        HLPOBN <> *BLANKS                                          CSD027
     C                   MOVEL     HLPOBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        HLPOCN <> *ZERO                                            CSD027
     C                   IF        HLPOCN <> *BLANKS                                          CSD027
     C                   MOVEL     HLPOCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        HLRCRN <> *BLANKS OR HLRCRA <> *BLANKS
     C                   EVAL      PInput1 = HLRCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HLRCRA:0      P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        HLRVNO <> *BLANKS
     C                   EVAL      PInput1 = HLRVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        HLAWBN <> *BLANKS OR HLAWBA <> *BLANKS
     C                   EVAL      PInput1 = HLAWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HLAWBA:0      P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        HLBENN <> *BLANKS OR HLBENA <> *BLANKS
     C                   EVAL      PInput1 = HLBENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HLBENA:0      P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        HLDTP1 <> *BLANKS OR HLDTP2 <> *BLANKS
     C                             OR HLDTP3 <> *BLANKS OR HLDTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       HLDTP1:0      P_XML
     C     P_XML         CAT       HLDTP2:0      P_XML
     C     P_XML         CAT       HLDTP3:0      P_XML
     C     P_XML         CAT       HLDTP4:0      P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     HLDN38        W4IDEN

      ** Item Type Code

     C     'MM'          CAT       HLTYPE:0      W4ITEM

      ** Branch

     C                   EVAL      W4BRCH = HLBRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'MMDENBPP'

      ** Counter Party Number

     C                   MOVEL     HLCNUM        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     HLCNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  137
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   EVAL      WLongYr = HLDDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HLDDMM
     C                   EVAL      PZDay = HLDDDD

     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  138
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   EVAL      WLongYr = HLVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HLVDMM
     C                   EVAL      PZDay = HLVDDD

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  139
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   EVAL      WLongYr = HLMDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HLMDMM
     C                   EVAL      PZDay = HLMDDD

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  140
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = HLCCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      HLAMNP        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  141
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrParmMmdenspp - Setup the Parameters 1 and 2 for MMDENSPP   *
      *                                                               *
      *****************************************************************
     C     SrParmMmdensppBEGSR

     C     K_Hmdn38      CHAIN     MMDENSP0                           11
     C                   IF        *IN11 = *ON OR
     C                             (HMDSTS <> 'C' AND HMDSTS <> 'A'
     C                             AND HMDSTS <> 'R')
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OPTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9639'
     C                   EVAL      WScrn = 'B'
     C                   ELSE

      ** Set-up parameter for Compliance Engine Program

     C                   EXSR      SrInitParm

      ** 2nd Parameter

      ** Receipt Nostro

     C                   IF        HMRONS <> *BLANKS
     C                   EVAL      PInput1 = HMRONS
     C                   IF        HMSTCY  > *BLANKS
     C                   EVAL      PCurrency= HMSTCY
     C                   ELSE
     C                   EVAL      PCurrency= HMCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(102):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(102):0P_XML
     C                   ENDIF

      ** Receipt Intermediary Bank + Account Line

     C                   IF        HMRIBN <> *BLANKS OR HMRIBA <> *BLANKS
     C                   EVAL      PInput1 = HMRIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(103):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HMRIBA:0      P_XML
     C     P_XML         CAT       ClosTag(103):0P_XML
     C                   ENDIF

      ** Receipt Ordering Bank

     C**********         IF        HMROBN <> *ZERO                                            CSD027
     C                   IF        HMROBN <> *BLANKS                                          CSD027
     C                   MOVEL     HMROBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(104):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(104):0P_XML
     C                   ENDIF

      ** Receipt Ordering Customer

     C**********         IF        HMROCN <> *ZERO                                            CSD027
     C                   IF        HMROCN <> *BLANKS                                          CSD027
     C                   MOVEL     HMROCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(105):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(105):0P_XML
     C                   ENDIF

      ** Pay Nostro

     C                   IF        HMPONS <> *BLANKS
     C                   EVAL      PInput1 = HMPONS
     C                   IF        HMSTCY <> *BLANKS
     C                   EVAL      PCurrency = HMSTCY
     C                   ELSE
     C                   EVAL      PCurrency = HMCCY
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(106):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(106):0P_XML
     C                   ENDIF

      ** Pay Intermediary Bank + Account Line

     C                   IF        HMPIBN <> *BLANKS OR HMPIBA <> *BLANKS
     C                   EVAL      PInput1 = HMPIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(107):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HMPIBA:0      P_XML
     C     P_XML         CAT       ClosTag(107):0P_XML
     C                   ENDIF

      ** Pay Ordering Bank

     C**********         IF        HMPOBN <> *ZERO                                            CSD027
     C                   IF        HMPOBN <> *BLANKS                                          CSD027
     C                   MOVEL     HMPOBN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(108):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(108):0P_XML
     C                   ENDIF

      ** Pay Ordering Customer

     C**********         IF        HMPOCN <> *ZERO                                            CSD027
     C                   IF        HMPOCN <> *BLANKS                                          CSD027
     C                   MOVEL     HMPOCN        PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(109):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(109):0P_XML
     C                   ENDIF

      ** Receiver Correspondent + Account Line

     C                   IF        HMRCRN <> *BLANKS OR HMRCRA <> *BLANKS
     C                   EVAL      PInput1 = HMRCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(110):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HMRCRA:0      P_XML
     C     P_XML         CAT       ClosTag(110):0P_XML
     C                   ENDIF

      ** Receiver

     C                   IF        HMRVNO <> *BLANKS
     C                   EVAL      PInput1 = HMRVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(111):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(111):0P_XML
     C                   ENDIF

      ** Account with Bank + Account Line

     C                   IF        HMAWBN <> *BLANKS OR HMAWBA <> *BLANKS
     C                   EVAL      PInput1 = HMAWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(112):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HMAWBA:0      P_XML
     C     P_XML         CAT       ClosTag(112):0P_XML
     C                   ENDIF

      ** Beneficiary + Account Line

     C                   IF        HMBENN <> *BLANKS OR HMBENA <> *BLANKS
     C                   EVAL      PInput1 = HMBENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(113):0P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       HMBENA:0      P_XML
     C     P_XML         CAT       ClosTag(113):0P_XML
     C                   ENDIF

      ** Details of Payment

     C                   IF        HMDTP1 <> *BLANKS OR HMDTP2 <> *BLANKS
     C                             OR HMDTP3 <> *BLANKS OR HMDTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(114):0P_XML
     C     P_XML         CAT       HMDTP1:0      P_XML
     C     P_XML         CAT       HMDTP2:0      P_XML
     C     P_XML         CAT       HMDTP3:0      P_XML
     C     P_XML         CAT       HMDTP4:0      P_XML
     C     P_XML         CAT       ClosTag(114):0P_XML
     C                   ENDIF

      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine.  Thus, no need to setup the 1st Parameter.

     C                   IF        P_XML <> *BLANKS

      ** First Parameter

      ** Identifier

     C                   MOVEL     HMDN38        W4IDEN

      ** Item Type Code

     C     'MM'          CAT       HMTYPE:0      W4ITEM

      ** Branch

     C                   EVAL      W4BRCH = HMBRCA

      ** System

     C                   EVAL      W4SYSM = LIBR

      ** Function Type

     C                   EVAL      W4FUNT = 'MMDENBPP'

      ** Counter Party Number

     C                   MOVEL     HMCNUM        W4CNUM

      ** Get Customer Detail

     C                   MOVEL     HMCNUM        PKey1

     C                   EXSR      SrCustDet

      ** If Customer detail not found, issue DB error.

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  142
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Counterparty Type

      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'

     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ELSE

      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.

     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5

     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF

     C                   ENDIF

      ** Counter Party Name

     C     BBCRNM        CAT       BBCRTN        W4CUST

      ** Deal Date

     C                   EVAL      WLongYr = HMDDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HMDDMM
     C                   EVAL      PZDay = HMDDDD

     C                   MOVE      PZDate        PZDateIn
     C                   MOVE      BJDFIN        PZDateFmt

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  143
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4DDAT = POutDate

      ** Value Date

     C                   EVAL      WLongYr = HMVDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HMVDMM
     C                   EVAL      PZDay = HMVDDD

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate

     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  144
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4VDAT = POutDate

      ** Maturity Date

     C                   EVAL      WLongYr = HMMDYY
     C                   EVAL      PZYear = WShortYr
     C                   EVAL      PZMonth = HMMDMM
     C                   EVAL      PZDay = HMMDDD

     C                   MOVE      PZDate        PZDateIn

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateIn
     C                   PARM                    PZDayNo
     C                   PARM                    PZDateFmt
     C                   PARM      *BLANKS       PZRtCd

     C                   MOVEL     PZDayNo       PInDate
     C                   EXSR      SrCvtDate

      ** DB Error Processing

     C
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  145
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4MDAT = POutDate

      ** Denomination Side 1

     C                   EVAL      W4DEN1 = HMCCY

      ** Denomination Side 2

     C                   EVAL      W4DEN2 = *BLANKS

      ** Amount Side 1

      ** Access currency details to check if denomination is a valid ccy

     C                   EVAL      PmCcy = W4DEN1

     C                   EXSR      SrCurrDet

      ** Format Amount 1

     C                   IF        PReturnCode= *BLANK
     C                   EVAL      PCcyV = W4DEN1
     C                   ELSE
     C                   EVAL      PCcyV = *BLANKS
     C                   ENDIF

     C                   MOVE      HMAMNP        PInAmt
     C                   EXSR      SrCvtAmt

      ** DB Error Processing

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  146
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W4AMT1 = PoutAmtNum

      ** Amount Side 2

     C                   EVAL      W4AMT2 = *ZERO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEngine   - Calling of Watch List Check Engine               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SDCWLCHK                                               *
      *                                                               *
      *****************************************************************

     C     SrEngine      BEGSR

     C                   IF        P_XML <> *BLANKS

     C                   CALL      'SDCWLCHK'
     C                   PARM                    PDSWLTD
     C                   PARM                    P_XML

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFormat   - Convert Settlement Details to Customer Name and  *
      *              Address                                          *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: SDCWLFMT                                               *
      *                                                               *
      *****************************************************************

     C     SrFormat      BEGSR

     C                   EVAL      DBPROC =  'SrFormat'

     C                   EVAL      POutput1 = *BLANKS
     C                   EVAL      POutput2 = *BLANKS

     C                   CALL      'SDCWLFMT'
     C                   PARM                    PReturnCode
     C                   PARM                    PInput1
     C                   PARM                    PInput2
     C                   PARM                    PInput3
     C                   PARM                    PInput4
     C                   PARM                    PInput5
     C                   PARM                    PInput6
     C                   PARM                    PCurrency
     C                   PARM                    POutput1
     C                   PARM                    POutput2

      ** Initialize to blanks the input parameters.

     C                   EVAL      PInput1 = *BLANKS
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInput5 = *BLANKS
     C                   EVAL      PInput6 = *BLANKS
     C                   EVAL      PCurrency = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCurrDet - Retrieve Currency Details                         *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR

     C                   EVAL      DBPROC =  'SrCurrDet'

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PReturnCode
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PmCcy
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCustDet - Retrieve Customer Details                         *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *                                                               *
      *****************************************************************
     C     SrCustDet     BEGSR

     C                   EVAL      DBPROC =  'SrCustDet'

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM      *BLANK        PKyst
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtDate - Convert dates to be used for Watch Engine Program *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: ZaCvtDate                                              *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BegSr

     C                   EVAL      DBPROC =  'SrCvtDate'

     C                   CALL      'ZACVTDATE'
     C                   PARM      *Blanks       PReturncode
     C                   PARM                    PInDate
     C                   PARM                    POutDate
     C                   PARM                    PCvtdDate

     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtAmt - Convert amounts for Watch Engine Program           *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: ZaCvtAmt                                               *
      *                                                               *
      *****************************************************************
     C     SrCvtAmt      BegSr

     C                   EVAL      DBPROC =  'SrCvtAmt'
     C                   EVAL      PoutAmtNum = *ZERO
     C                   EVAL      PCvtdAmt = *BLANKS

     C                   CALL      'ZACVTAMT'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM                    PCcyV
     C                   PARM                    PInAmt
     C                   PARM                    PoutAmtNum
     C                   PARM                    PCvtdAmt

     C                   ENDSR
      *********************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrInitParm - Initialize 1st and 2nd Parameters of Watch List  *
      *              Engine                                           *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrInitParm    BEGSR

     C                   EVAL      DBPROC =  'SrInitParm'
     C                   CLEAR                   PDSWLTD
     C                   EVAL      P_XML = *BLANKS

     C                   ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Retrieve ZMUSER details.

     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER

      ** Retrieve RUNDAT details.

     C                   IN        RUNDAT

      ** Retrieve SDSTAT details.

     C                   IN        SDSTAT

      ** Access bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE= 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access SAR Details to see if Concord Interface Development (CCF001)
      ** is installed.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.

     C                   IF        PReturnCode <> *BLANKS
     C                             AND PReturnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CCF001'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PReturnCode = *BLANKS
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
     C                   EVAL      CCF001 = 'N'
     C                   ENDIF

      ** Retrieve compliance watch configuration data file

     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDCWCD        PARM      SDCWCD        DSSDY

      ** Database error

     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE= 'SDCWCDPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access SAR Details to see if Midas Compliance Watch - Entry Level                    CSD019
      ** Watch List Checking (CSD019) is installed.                                           CSD019
                                                                                              CSD019
     C                   CALL      'AOSARDR0'                                                 CSD019
     C                   PARM      *BLANKS       PReturnCode                                  CSD019
     C                   PARM      '*VERIFY'     POptn                                        CSD019
     C                   PARM      'CSD019'      PSard                                        CSD019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD019
                                                                                              CSD019
      ** An NRF (No Record Found) return code is valid.                                       CSD019
      ** Issue database error only for error return codes.                                    CSD019
                                                                                              CSD019
     C                   IF        PReturnCode <> *BLANKS                                     CSD019
     C                             AND PReturnCode <> '*NRF'                                  CSD019
     C     *LOCK         IN        LDA                                                        CSD019
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD019
     C                   EVAL      DBKey = 'CSD019'                                           CSD019
     C                   EVAL      DBase = 147                                                CSD019
     C                   OUT       LDA                                                        CSD019
     C                   EXSR      *PSSR                                                      CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   IF        PReturnCode = *BLANKS                                      CSD019
     C                   EVAL      CSD019 = 'Y'                                               CSD019
     C                   ELSE                                                                 CSD019
     C                   EVAL      CSD019 = 'N'                                               CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019

      ** Access SAR Details to see if Standing Data Authorisation (CSD012)
      ** is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD012'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.

     C                   IF        PReturnCode <> *BLANKS
     C                             AND PReturnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CSD012'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PReturnCode = *BLANKS
     C                   EVAL      CSD012 = 'Y'
     C                   ELSE
     C                   EVAL      CSD012 = 'N'
     C                   ENDIF
     C                   EVAL      WScrn = 'B'
     C
     C     K_Lef1        KLIST
     C                   KFLD                    K_Loan1
     C                   KFLD                    K_Fseq1

     C     K_Lef2        KLIST
     C                   KFLD                    K_Cnum
     C                   KFLD                    K_Facl
     C                   KFLD                    K_Loan2
     C                   KFLD                    K_Fseq2
     C
     C     K_Loamsdk     KLIST
     C                   KFLD                    K_Lnrf
     C                   KFLD                    K_Vdat
     C                   KFLD                    K_Lasn

     C     K_Accntab     KLIST
     C                   KFLD                    K_Brca
     C                   KFLD                    K_CnumX
     C                   KFLD                    K_Ccy
     C                   KFLD                    K_Acod
     C                   KFLD                    K_Acsq

     C     K_Sdexstpd    KLIST
     C                   KFLD                    K_Bycycd
     C                   KFLD                    K_Bycust
     C                   KFLD                    K_Bytrty

     C     K_Posetd      KLIST
     C                   KFLD                    K_Pbca
     C                   KFLD                    K_Pssh
     C                   KFLD                    K_Pcpy
     C                   KFLD                    K_Pdud
     C                   KFLD                    K_Pevt

     C     PosetKey      KLIST
     C                   KFLD                    PBCA
     C                   KFLD                    PSSH
     C                   KFLD                    PCPY
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT

     C     K_Fxclspsh    KLIST
     C                   KFLD                    K_Pyccy
     C                   KFLD                    K_Pynost
     C                   KFLD                    K_Pyvald
     C                   KFLD                    K_Pyseqn

     C     K_Mmdeampp    KLIST
     C                   KFLD                    K_Hnda38
     C                   KFLD                    K_Hnvdyy
     C                   KFLD                    K_Hnvdmm
     C                   KFLD                    K_Hnvddd
     C                   KFLD                    K_Hnds38

     C     K_Dlgxstl0    KLIST
     C                   KFLD                    K_Dlno
     C                   KFLD                    K_Rxedcd

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************

**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** Opentag - Open tags for XML
<Receipt Nostro>
<Receipt Intermed Bank>
<Receipt Ordering Bank>
<Receipt Ordering Cust>
<Payment Nostro>
<Payment Intermed Bank>
<Payment Ordering Bank>
<Payment Ordering Cust>
<Receiver Correspondent>
<Receiver>
<Account With Bank>
<Beneficiary>
<Details Of Payment>
<Customer Name>
<Addr Lines>
<SWIFT Id>
<Ctry of Citizenship>
<Ctry of Domicile>
<Identity Number>
<Date of Birth>
<Cust Alt Name>
<Correspondent's Name>
<Zip Code>
<For attention of>
<Account Name>
<Receipt Our Nostro>
<Receipt Ord Customer>
<Receipt Int Bank>
<Receipt Ord Bank>
<Payment Our Nostro>
<Payment Ord Customer>
<Payment Reciever>
<Payment R Corespondent>
<Payment Int Bank>
<Payment Ord Bank>
<Payment A/C with Bank>
<Payment Beneficiary>
<Payment Details of Pay>
<DR Account>
<DR Retail Account>
<CR Account>
<CR Retail Account>
<Payee>
<Reference>
<Payee Bank>
<Payee Account>
<Broker Settlement Acct>
<Broker for Account Of>
<Broker Counter Nostro>
<Cust Settlement Acct>
<Cust for Account Of>
<Cust Counter Nostro>
<Pay From>
<Pay To>
<For Account of - PayTo>
<Deliver To>
<For Acct of-Deliver To>
<Deliver From>
<For Acct of-Deliver Fr>
<MT510 A/C for Payment>
<Account for Payment>
<A/C with Institution>
<Beneficiary>
<Instructing Party>
<Counterparty>
<MT510 Safekeeping A/C>
<Safekeeping Account>
<Deliverer Instr Party>
<Receivers of Securties>
<Deliverers of Sec>
<Beneficiary of Sec>
<Investor>
<Settlement Party Int>
<Safekeeping A/C Int>
<Depot In>
<Depot Out>
<Settlement account>
<Counterparty bank>
<For account of>
<Sender>
<Receiver's Corresp>
<Account With Inst>
<Beneficiary>
<Ordering Bank>
<Sender's Correspondent>
<Ordering Customer>
<Details of Payment>
<Intermediary>
<Destination>
<MT100 Customer>
<Instructing Party>
<Accnt Servicing Inst>
<Remittance Information>
<Collecting Bank>
<Credit Party>
<Narrative>
<Remitting Bank>
<Debit Party>
<Thrd Reimbursemnt Inst>
<Sending Institution>
<Ordering Institution>
<Receipt Our Nostro>
<Receipt Inter. Bank>
<Receipt Ord. Bank>
<Receipt Ord. Customer>
<Payment Our Nostro>
<Payment Inter. Bank>
<Payment Ord. Bank>
<Payment Ord. Customer>
<Payment Rec. Corr.>
<Payment Recipient>
<Payment Acc. with Bank>
<Payment Beneficiary>
<Payment Details>
<CLS Nostro>
<Our Nostro>
<Intermediary Bank>
<Ordering Bank>
<Ordering Customer>
<Receiver Correspondent>
<Receiver Number>
<Account with Bank>
<Beneficiary>
<Destination>
<Debtor>                                                                                      CSW210
<Qualified Foreign Intermediary>                                                              CSW210
** Closetag - Close tags for XML
</Receipt Nostro>
</Receipt Intermed Bank>
</Receipt Ordering Bank>
</Receipt Ordering Cust>
</Payment Nostro>
</Payment Intermed Bank>
</Payment Ordering Bank>
</Payment Ordering Cust>
</Receiver Correspondent>
</Receiver>
</Account With Bank>
</Beneficiary>
</Details Of Payment>
</Customer Name>
</Addr Lines>
</SWIFT Id>
</Ctry of Citizenship>
</Ctry of Domicile>
</Identity Number>
</Date of Birth>
</Cust Alt Name>
</Correspondent's Name>
</Zip Code>
</For attention of>
</Account Name>
</Receipt Our Nostro>
</Receipt Ord Customer>
</Receipt Int Bank>
</Receipt Ord Bank>
</Payment Our Nostro>
</Payment Ord Customer>
</Payment Reciever>
</Payment R Corespondent>
</Payment Int Bank>
</Payment Ord Bank>
</Payment A/C with Bank>
</Payment Beneficiary>
</Payment Details of Pay>
</DR Account>
</DR Retail Account>
</CR Account>
</CR Retail Account>
</Payee>
</Reference>
</Payee Bank>
</Payee Account>
</Broker Settlement Acct>
</Broker for Account Of>
</Broker Counter Nostro>
</Cust Settlement Acct>
</Cust for Account Of>
</Cust Counter Nostro>
</Pay From>
</Pay To>
</For Account of - PayTo>
</Deliver To>
</For Acct of-Deliver To>
</Deliver From>
</For Acct of-Deliver Fr>
</MT510 A/C for Payment>
</Account for Payment>
</A/C with Institution>
</Beneficiary>
</Instructing Party>
</Counterparty>
</MT510 Safekeeping A/C>
</Safekeeping Account>
</Deliverer Instr Party>
</Receivers of Securties>
</Deliverers of Sec>
</Beneficiary of Sec>
</Investor>
</Settlement Party Int>
</Safekeeping A/C Int>
</Depot In>
</Depot Out>
</Settlement account>
</Counterparty bank>
</For account of>
</Sender>
</Receiver's Corresp>
</Account With Inst>
</Beneficiary>
</Ordering Bank>
</Sender's Correspondent>
</Ordering Customer>
</Details of Payment>
</Intermediary>
</Destination>
</MT100 Customer>
</Instructing Party>
</Accnt Servicing Inst>
</Remittance Information>
</Collecting Bank>
</Credit Party>
</Narrative>
</Remitting Bank>
</Debit Party>
</Thrd Reimbursemnt Inst>
</Sending Institution>
</Ordering Institution>
</Receipt Our Nostro>
</Receipt Inter. Bank>
</Receipt Ord. Bank>
</Receipt Ord. Customer>
</Payment Our Nostro>
</Payment Inter. Bank>
</Payment Ord. Bank>
</Payment Ord. Customer>
</Payment Rec. Corr.>
</Payment Recipient>
</Payment Acc. with Bank>
</Payment Beneficiary>
</Payment Details>
</CLS Nostro>
</Our Nostro>
</Intermediary Bank>
</Ordering Bank>
</Ordering Customer>
</Receiver Correspondent>
</Receiver Number>
</Account with Bank>
</Beneficiary>
</Destination>
</Debtor>                                                                                     CSW210
</Qualified Foreign Intermediary>                                                             CSW210
