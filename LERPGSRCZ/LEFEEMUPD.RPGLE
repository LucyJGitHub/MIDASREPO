     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee database update')                         *
      *****************************************************************
      *                                                               *
      *  Midas - LE Customer Lending                                  *
      *                                                               *
      *  LEFEEMUPD - Fee database update                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CLE071             Date 18Jul18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD034020           Date 19Jul17               *
      *                 AR943686           Date 23Sep16               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE164             Date 28Nov14               *
      *                 MD030700           Date 28Nov14               *
      *                 260783             Date 19Aug14               *
      *                 MD025467           Date 28Feb14               *
      *                 MD024342B          Date 25Feb14               *
      *                 MD024342           Date 11Feb14               *
      *                 MD023682           Date 21Nov13               *
      *                 AR868380           Date 11Jun13               *
      *                 MD020953           Date 18Jun13               *
      *                 AR812101           Date 24Apr13               *
      *                 258597             Date 22Oct12               *
      *                 AR1022006          Date 01Aug12               *
      *                 AR744771           Date 01Aug12               *
      *                 AR574498           Date 01Aug12               *
      *                 AR550169           Date 01Aug12               *
      *                 AR545441           Date 01Aug12               *
      *                 262754             Date 01Aug12               *
      *                 260840             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR322732           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 AR750543A          Date 03May11               *
      *                 CLE139             Date 06Dec10               *
      *                 262581             Date 16Jan09               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG20671           Date 14Aug08               *
      *                 CSW208             Date 15Apr08               *
      *                 CAS019             Date 20Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239969             Date 23May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11113           Date 05May06               *
      *                 237679             Date 21Dec05               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9496            Date 05Dec05               *
      *                 BUG9225            Date 16Nov05               *
      *                 BUG8629            Date 19Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 BUG8144            Date 15Aug05               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4478            Date 07Oct04               *
      *                 BUG3760            Date 30Jul04               *
      *                 BUG3071            Date 17Jun04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 223922             Date 22Dec03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034020 - Rename settlement fields of CLOANCL to prevent    *
      *             missing projections when fee customer also has    *
      *             defined customer swiftID.                         *
      *  AR943686 - CLE031: System generating wrong projected move-   *
      *             ments. Add missing CLE031 enhancement to convert  *
      *             amount to account currency. (Child: AR943687)     *
      *           - Applied for MD-40690                              *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD030700 - Missing Lending Loan Fee Advices for bullet fees  *
      *             (FEPYON = ' ' ) and maturing fees entered today.  *
      *           - Also consider fees whose NPYD are amended to      *
      *             today or in the past.                             *
      *  260783 - Settlement currency field not correctly populated.  *
      *           Populate field if not blank and CEU004 is not       *
      *           installed.                                          *
      *           Applied for MD021654.                               *
      *  MD025467 - API locking issues Redesign Approach              *
      *  MD024342B - API issue. Trailer file allocation problem.      *
      *  MD024342 - LEFEEZ  allocation problem                        *
      *  MD023682 - BF COB LERC14 failed due to FCOOB                 *
      *  AR868380 - Pass parameter *RECLCK if a locking problem       *
      *             occurs and prevent program from issuing a         *
      *             database error. (Child: AR868381)                 *
      *  MD020953 - Field LEACCNPD.RPFACT and field LEACCNPD.RPFFNO   *
      *             contains zero values for original loans           *
      *  AR812101 - No projected movements after changing account     *
      *             settlement and next payment date equal to rundate.*
      *             Use last payment date for next payment date field *
      *             for projections (before calling AOOUFEU1) if next *
      *             payment date is in the future and last payment    *
      *             date is equal to rundate. (Child: AR812102)       *
      *           - Applied for AR811842 (Child:AR811841)             *
      *  258597 - Global synchronization failed due to duplicate      *
      *           records in GZLEFEED. Applied 255741.                *
      *           Send error message if all 99 fee sequence is used.  *
      *  AR1022006 - COB Performance Optimisation                     *
      *  AR744771 - Suspend fee allowed must be "y' or 'N'            *
      *           - FEFSFA is blank for fees inserted via SOAP.       *
      *             Default FEFSFA during insert. (Child: AR744772)   *
      *  AR574498 - When a Fee with auto-settle = 'C' is reversed,    *
      *             the LEACCNPD record should be deleted.            *
      *             (Child: AR574499)                                 *
      *  AR550169 - Duplicate projections when fee was early matured. *
      *             Removed part of fix 260840 to ensure that when no *
      *             changes has been made on settlement details or    *
      *             auto settle indicator, and next paydate is amended*
      *             equal to rundate/FELPDT, SR/SRUSHD would no be    *
      *             executed. (Child: AR550170)                       *
      *  AR545441 - If Auto-settle indicator is changed from C to Y/N *
      *             delete record from LEACCNPD. (Child: AR545442)    *
      *  262754 - Corrected setting of facility key.                  *
      *  260840 - Fee Payments projected twice. Suppress update to    *
      *           shadow files when fee is early matured and next     *
      *           payment date = last payment date = business date.   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
      *           - Prevent LTRIX RRN 1 from being locked.            *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00155                                 *
      *             WNCPYSRC,LEH00156                                 *
      *             WNCPYSRC,LEH00157                                 *
      *             WNCPYSRC,LEH00158                                 *
      *  AR750543A - Additional fix for audit report to specify if    *
      *              report is either for Paid or Capitalised         *
      *              (Child: AR750544)                                *
      *  CLE139 - Lending Fee Capitalisation                          *
      *  262581 - Redevelop CAS016 to achieve the following:          *
      *           - seton EIR recalculation indicator on fees that    *
      *             amortise separately from loan;                    *
      *           - if fee amended flag latest EIR period to trigger  *
      *             EIR recalculation;                                *
      *           - if fee deleted then recalculate EIR.              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG20671 - No MT320 production in MGOREFPD.                  *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  239969 - Database error in LEFEEMUPD.                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11113 - Applied under 237679.                             *
      *  237679 - Set last change date equal to system run date for   *
      *           amend/delete/authorise.                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9496- Define COMMIT to LEEIRDL5.                          *
      *         - Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.                                        *
      *  BUG9225 - Update LESTALPD with correct fee sequence.         *
      *  BUG8629 - Incorrect calculation of facility fee              *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  BUG8144- Current timestamp not being written to LEFEED       *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4478 - Do not clear the warning error arrays just         *
      *            prior to the database update.                      *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  BUG3071 - Shadow Posting not updated after authorisation.    *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  223922 - Shadow Postings were not updated when amending the  *
      *           Advice/Confirm indicator of the fee.                *
      *         - Profit centre entered by User never written to file.*
      *         - Status of fee changed from Complete to 'Reauthorise'*
      *         - Shadow Postings were not reversed when amending fee.*
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
 
     FLEFEEDL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDF1)
     F                                     COMMIT
     F***LEFEEZ*   UF   E             DISK    INFSR(*PSSR)                                  MD023682
     F***LEFEEZ*   UF   E             DISK    INFSR(SRFEEZ)                        MD023682 MD024342
     F***LEFEEZ*   UF A E             DISK    INFSR(SRFEEZ)                       MD024342 MD024342B
     F***LEFEEZ*   UF   E             DISK    INFSR(SRFEEZ)                       MD024342B MD025467
     FLEFEEZ    UF A E             DISK    INFSR(SRFEEZ)                                    MD025467
     F                                     COMMIT                                             239969
     F***LEFHSTL1  IF   E           K DISK                                                    258597
     FLEFEEDLU  IF   E           K DISK    USROPN                                             258597
     F                                     RENAME(LEFEEDF:LEFEEDDO)                           258597
                                                                                             BUG3760
     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
      ** Compliance Watch Hit List file                                                      BUG3760
                                                                                              CRE020
     FREADVCL2  UF   E           K DISK    USROPN                                             CRE020
     F                                     COMMIT                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref/Seq No                     CRE020
                                                                                              CRE020
     F***LTRIX**** UF   F   43        DISK    INFSR(*PSSR)                           CSW208 AR322732
     FLTRIX     O  A F   45        DISK    INFSR(*PSSR)                                     AR322732
     F                                     COMMIT                                             CSW208
     F                                     INFDS(FLDTX)                                       CSW208
      ** Midas LE Loan Transaction Index Detail                                               CSW208
                                                                                              CSW208
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)                                       CSW208
     F                                     COMMIT                                             CSW208
     F                                     IGNORE(CLOANHHF)                                   CSW208
     F                                     IGNORE(CLOANCKF)                                   CSW208
     F                                     IGNORE(CLOANZ1F)                                   CSW208
      ** Midas LE Loans File                                                                  CSW208
                                                                                              CSW208
     FLEEIRDL5  UF   E           K DISK                                                       CAS011
     F                                     COMMIT                                            BUG9496
     FLESTALLA  UF   E           K DISK    COMMIT                                            BUG9225
     F                                     PREFIX(XX)                                        BUG9225
      ** Midas LE Settlement Allocation by Parent PC Reference                               BUG9225
      *****************************************************************
                                                                                              CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEEIRDL9  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
     F                                     RENAME(LEEIRDD0:LEEIRDD9)                          CAS019
     FLEERAPL0  UF   E           K DISK    COMMIT                                             262581
                                                                                              CLE134
      ** Retail Account                                                                       CLE134
                                                                                              CLE134
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)                                       CLE134
                                                                                              CLE134
      ** Facilities                                                                           CLE134
                                                                                              CLE134
     FFCLTY     IF   E           K DISK    INFSR(*PSSR) PREFIX(f_)                            CLE134
     F                                     IGNORE(FCLTYHHF) IGNORE(FCLTYZZF)                  CLE134
                                                                                              CLE134
      ** Account Shadow Postings                                                              CLE134
                                                                                              CLE134
     FRSACMTLX  IF   E           K DISK    PREFIX(sp)                                         CLE134
                                                                                              CLE134
      ** Repayment Priority                                                                   CLE134
                                                                                              CLE134
     F***LEACCNLB  UF A E        K DISK    INFSR(*PSSR)                                CLE134 CLE164
     F                                     COMMIT                                             CLE134
                                                                                              CLE134
      ** Account Postings Next Available Number                                               CLE134
                                                                                              CLE134
     FGLAPNAPD  UF A E           K DISK    COMMIT                                             CLE134
                                                                                              CLE134
     F***SDAPDRL0  IF   E           K DISK    INFSR(*PSSR)                         MD024342 MD025467
      ***********************************************************************      MD024342 MD025467
      ***Midas*SD*API*Driving*File*******************************************      MD024342 MD025467
     F***LEFEEZX   O    E             DISK    COMMIT                              MD024342B MD025467
     F**********                           RENAME(LEFEEZF:LEFEEZFX)               MD024342B MD025467
      ***API:*Midas*LE*Fees*Master*Trailer***********************************     MD024342B MD025467
      ***********************************************************************     MD024342B MD025467
     FLEFEDNL0  UF A E           K DISK    COMMIT                                           MD030700
                                                                                            MD030700
     F/COPY WNCPYSRC,LEH00155
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **  Table
     D CURR            S              3    DIM(150)                             ALL CCYS
     D TXND            S              1  0 DIM(150)                             Tlx NtcDay/CCY
                                                                                             BUG3760
      ** Watch List Description Compiled Time Array                                          BUG3760
     DWLARR            S             35    DIM(26) CTDATA PERRCD(2)                          BUG3760
     D*W#FRNT***       S              8A                                           MD024342 MD025467
 
      *****************************************************************
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID FEE
     D ValidFeem     E DS                  EXTNAME(LEVFEEMPD)
 
      * Original Fee in File Format                                                          BUG3760
     D OrgFeeFFmt    E DS                  EXTNAME(LEFEED)                                   BUG3760
     D                                     PREFIX(PV_)                                       BUG3760
                                                                                             BUG3760
      **  FEE IN FILE FORMAT
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
     D QQOURS1       E                     EXTFLD(QQOURS)                                     CGL029
     D LEFEQD        E DS                  EXTNAME(LESTMPPD)                                  CER049
      ***  Externally desc'd DS for screen Loans extension                                    CER049
 
      ** Fee Details OK indicator
     D OkFee         E DS                  EXTNAME(LEEFEEMPD)
 
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
 
      ** DATA AREA TO READ PREVIOUS RUN DATE
     D JNSTAT          DS           200
     D  PRUN                 103    105P 0
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External DS for Nostro Details
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD) PREFIX(ic)                       CLE134
                                                                                              CLE134
      ** Customer lending ICD                                                                 CLE134
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details.
 
     D SDFACT        E DS                  EXTNAME(SDFACTPD)                                  CLE134
                                                                                              CLE134
      ** External DS for facility type details                                                CLE134
                                                                                              CLE134
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)                                  CLE134
                                                                                              CLE134
      ** External DS for loans type details                                                   CLE134
                                                                                              CLE134
     D SDFEE         E DS                  EXTNAME(SDFEEPD)                                   CAS011
      ** External DS for Fee Details                                                          CAS011
                                                                                              CAS011
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, LONG data structure.
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
                                                                                             BUG3760
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG3760
      ** External DS for Customer Details                                                    BUG3760
                                                                                             BUG3760
      ** Midas Functions for Watch List Checking Details File                                BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
                                                                                             BUG3760
      ** Data structure for 1st parameter of Watchlist Engine (SDCWLCHK)                     BUG3760
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                 BUG3760
                                                                                             BUG3760
      ** External DS for Watch List Configuration Data File                                  BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
                                                                                             BUG3760
      ** Data structure for 2st parameter of SDCWLCHK                                        BUG3760
                                                                                             BUG3760
     D PString         DS         30000                                                      BUG3760
                                                                                             BUG3760
     D*MPHAS****       DS             1                                            MD024342 MD025467
      ***Data*Structure*for*MPHAS*Dataarea***********************************      MD024342 MD025467
      ***********************************************************************      MD024342 MD025467
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D Timestamp       S             26Z                                                     BUG8144
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D KEYC1           S             10A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PFunc           S              8A                                                     BUG3760
     D WDealNo         S              6A
     D CSD015          S              1A                                                     BUG3760
     D CCF001          S              1A   INZ('N')                                          BUG3760
     D CAP086          S              1A   INZ('N')                                           CAP086
     D CAS009          S              1                                                       CAS011
     D CAS016          S              1    INZ('N')                                           CAS019
     D CLE031          S              1    INZ('N')                                         AR943686
     D CLE134          S              1    INZ('N')                                           CLE134
     D DSLoop          S              9  0 INZ                                                CLE134
     D***DSCNUM       S                   INZ LIKE(RPCNUM)                             CLE134 CLE164
     D***DSACOD       S                   INZ LIKE(RPACOD)                             CLE134 CLE164
     D***DSACSQ       S                   INZ LIKE(RPACSQ)                             CLE134 CLE164
     D***DSBRCA       S                   INZ LIKE(RPBRCA)                             CLE134 CLE164
     D***DSACCY       S                   INZ LIKE(RPACCY)                             CLE134 CLE164
                                                                                              CLE134
     D #A              S              9  0 INZ                                                CLE134
                                                                                              CLE134
     D DSBCN           S              3  0 INZ DIM(9)                                         CLE134
     D DSBCE           S              3  0 INZ DIM(9)                                         CLE134
                                                                                              CLE134
     D DSRCN           S              3  0 INZ DIM(9)                                         CLE134
     D DSRCE           S              3  0 INZ DIM(9)                                         CLE134
                                                                                              CLE134
     D KACNO           S                   INZ LIKE(ACNO)                                     CLE134
                                                                                              CLE134
     D Kf_CNUM         S                   INZ LIKE(f_CNUM)                                   CLE134
     D Kf_FACT         S                   INZ LIKE(f_FACT)                                   CLE134
     D Kf_FCNO         S                   INZ LIKE(f_FCNO)                                   CLE134
     D Kf_RCTP         S                   INZ LIKE(f_RCTP)                                   CLE134
                                                                                              CLE134
     D KGLNARI         S                   INZ LIKE(GLNARI)                                   CLE134
                                                                                              CLE134
     D***KRPFCNM         S                INZ LIKE(RPFCNM)                             CLE134 CLE164
     D***KRPFLNR         S                INZ LIKE(RPFLNR)                             CLE134 CLE164
     D***KRPFACT         S                INZ LIKE(RPFACT)                             CLE134 CLE164
     D***KRPFSE1         S                INZ LIKE(RPFSE1)                             CLE134 CLE164
     D***KRPFCOD         S                INZ LIKE(RPFCOD)                             CLE134 CLE164
     D***KRPFCBR         S                INZ LIKE(RPFCBR)                             CLE134 CLE164
                                                                                              CLE134
     D KspXRFI         S                   INZ LIKE(spXRFI)                                   CLE134
     D KspXRFN         S                   INZ LIKE(spXRFN)                                   CLE134
     D WFENPYD         S                   INZ LIKE(FENPYD)                                 AR812101
 
      ** CRE020 Variables                                                                     CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KSeqNo          S              3A                                                      CRE020
     D KPrgMn          S             10A   INZ('LEFEEMUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('Fees                ')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D PSysVal02       S             20A                                                      CRE020
     D PCurSet02       S            200A                                                      CRE020
     D PSysVal03       S             20A                                                      CRE020
     D PCurSet03       S            200A                                                      CRE020
     D PSysVal04       S             20A                                                      CRE020
     D PCurSet04       S            200A                                                      CRE020
     D PSysVal05       S             20A                                                      CRE020
     D PCurSet05       S            200A                                                      CRE020
     D PSysVal06       S             20A                                                      CRE020
     D PCurSet06       S            200A                                                      CRE020
     D PSysVal07       S             20A                                                      CRE020
     D PCurSet07       S            200A                                                      CRE020
     D PSysVal08       S             20A                                                      CRE020
     D PCurSet08       S            200A                                                      CRE020
     D PSysVal09       S             20A                                                      CRE020
     D PCurSet09       S            200A                                                      CRE020
     D PSysVal10       S             20A                                                      CRE020
     D PCurSet10       S            200A                                                      CRE020
     D WSysVal01       S              1A                                                      CRE020
     D WNew            S              1A                                                      CRE020
                                                                                              CRE020
      ** Reference Number Data Structure                                                      CRE020
     D                 DS                                                                     CRE020
     D WRefNo                  1     12                                                       CRE020
     D  WCustNo                1      6                                                       CRE020
     D  WTrnRef                7     12                                                       CRE020
                                                                                              CRE020
     D                 DS
      ** Data structure to set partial key
     D**WCNUM***               1      6  0                                                    CSD027
     D  WCNUM                  1      6                                                       CSD027
     D  WFAC03                 7      9  0
     D  WFAC02                10     11  0
     D  WFACL                  7     11
     D  WFAC05                 7     11  0
     D**WLOAN***              12     17  0                                                    CLE148
     D  WLOAN                 12     17                                                       CLE148
     D  WFSEQ                 18     19  0
     D**WFPKEY**               1     19  0                                                    CSD027
     D  WFPKEY                 1     19                                                       CSD027
 
      *
      ** Work file of update to LE position files
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
                                                                                             BUG3760
      ** ZACVTDATE Parameters                                                                BUG3760
     D PZARtCd         S             10                                                      BUG3760
     D PZADayNo        S              5                                                      BUG3760
     D PZADDT          S               D                                                     BUG3760
     D PConvtDate      S             10                                                      BUG3760
                                                                                             BUG3760
      ** ZACVTAMT Parameters                                                                 BUG3760
     D PZAAmt          S             15                                                      BUG3760
     D PZACcy          S              3                                                      BUG3760
     D PZOutAmt        S             18  3                                                   BUG3760
     D PZCvtAmt        S             16                                                      BUG3760
                                                                                             BUG3760
      ** SRConvert Parameters                                                                BUG3760
     D PInput          S             35                                                      BUG3760
     D PInput1         S             35                                                      BUG3760
     D PInput2         S             35                                                      BUG3760
     D PInput3         S             35                                                      BUG3760
     D PInput4         S             35                                                      BUG3760
     D PInput5         S             35                                                      BUG3760
     D PInCcy          S              3                                                      BUG3760
     D OutFmt          S            216                                                      BUG3760
     D OutFmt2         S              6                                                      BUG3760
                                                                                              CAS011
      ** AOFEER0 Parameters                                                                   CAS011
     D PKEY            S              2A                                                      CAS011
                                                                                             BUG3760
      ** Work Variables                                                                      BUG3760
     D WDDT            S               D                                                     BUG3760
     D WFPDT           S              8F                                                     BUG3760
     D Fld1            S             35                                                      BUG3760
     D Fld2            S             35                                                      BUG3760
     D Fld3            S             35                                                      BUG3760
     D Fld4            S             35                                                      BUG3760
     D Fld5            S             35                                                      BUG3760
     D KFuncType       S              8                                                      BUG3760
     D KIden           S             40                                                      BUG3760
     D KBranch         S              3A                                                     BUG3760
     D WCtrpRpt        S             30                                                      BUG3760
     D WCtrpTyp        S              1                                                      BUG3760
     D PFuncCode       S              8                                                      BUG3760
     D PCustNo         S             10A                                                     BUG3760
     D PErrInf         S              7A                                                     BUG3760
     D WUNCF           S              1A                                                     BUG3760
     D W2LOAN          S              6A                                                     BUG3760
     D W2CNUM          S              6A                                                     BUG3760
     D W2FACL          S              5A                                                     BUG3760
     D W2FSEQ          S              2A                                                     BUG3760
     D WUPDEI          S              1A                                                      CAS011
     D WADJY           S              1A                                                      CAS011
     D U               S              2  0                                                   BUG3760
     D CSW208          S              1A                                                      CSW208
     D LSCONF          S              1A                                                      CSW208
     D PSysValLE       S             20A   INZ('LEFSWIFTConf        ')                        CSW208
     D LXRRN           S              5  0                                                    CSW208
     D SVSTS           S              5  0                                                    CSW208
     D WRRNA           S              5  0                                                    CSW208
     D WCLRT           S              1A                                                      CSW208
     D TXERR           S              1A                                                      CSW208
      *                                                                                       CSW208
      *                                                                                     AR322732
      ** Data structure to define LTRIX fields                                              AR322732
      *                                                                                     AR322732
     D RECID           S              1                                                     AR322732
     D RCDTD           S              1                                                     AR322732
     D RRNTD           S              5P 0                                                  AR322732
     D CHTPD           S              1                                                     AR322732
     D CNRQD           S              1                                                     AR322732
     D CNPRD           S              1                                                     AR322732
     D REPRD           S              1                                                     AR322732
     D RRLAD           S              5S 0                                                  AR322732
     D LADID           S              1                                                     AR322732
     D PRI1D           S              1S 0                                                  AR322732
     D BRCAD           S              3                                                     AR322732
     D PRI2D           S              1S 0                                                  AR322732
     D PRI3D           S              1S 0                                                  AR322732
     D PRI4D           S              1S 0                                                  AR322732
                                                                                            AR322732
     D FLDTX           DS                                                                     CSW208
     D  TXSTS            *STATUS                                                              CSW208
                                                                                              CLE164
      ** +--------------------------------------+                                             CLE164
      ** ¦ Enhancement F                        ¦                                             CLE164
      ** ¦ =============                        ¦                                             CLE164
      ** +--------------------------------------+                                             CLE164
                                                                                              CLE164
     D UPDATE_MATRIX   PR                  Extpgm('LE000506')                                 CLE164
     D    pRetCode                    7A                                                      CLE164
     D    pAction                     8A                                                      CLE164
     D    pFile                      10A                                                      CLE164
     D    pLoanRef                    6A                                                      CLE164
     D    pBranch                     3A                                                      CLE164
     D    pCustomer                   6A                                                      CLE164
     D    pFeeFclty                   5S 0                                                    CLE164
     D    pFeeLoan                    6A                                                      CLE164
     D    pFeeSeqn                    2S 0                                                    CLE164
     D    pLSPDPGrpID                 3A                                                      CLE164
     D    pFTPDPGrpID                 3A                                                      CLE164
     D    pFCPDPGrpID                 3A                                                      CLE164
     D    pCategory                   5A                                                      CLE164
                                                                                              CLE164
      ** Variable declaration                                                                 CLE164
     D  Loan_Prefix    S              1A   INZ(*ZEROS)                                        CLE164
     D  wRetCode       S              7A                                                      CLE164
     D  wAction        S              8A                                                      CLE164
     D  wFile          S             10A                                                      CLE164
     D  wLoanRef       S              6A   INZ(*BLANKS)                                       CLE164
     D  wBranch        S              3A   INZ(*BLANKS)                                       CLE164
     D  wCustomer      S              6A   INZ(*BLANKS)                                       CLE164
     D  wFeeFclty      S              5S 0 INZ(*ZEROS)                                        CLE164
     D  wFeeLoan       S              6A   INZ(*BLANKS)                                       CLE164
     D  wFeeSeqn       S              2S 0 INZ(*ZEROS)                                        CLE164
     D  wCategory      S              5A   INZ(*BLANKS)                                       CLE164
     D  wLSPDPGrpID    S              3A   INZ(*BLANKS)                                       CLE164
     D  wFTPDPGrpID    S              3A   INZ(*BLANKS)                                       CLE164
     D  wFCPDPGrpID    S              3A   INZ(*BLANKS)                                       CLE164
                                                                                              CLE164
     D  aCAT           S              5A   DIM(2)                                             CLE164
     D  aLoanFee       S              5A   DIM(2)                                             CLE164
     D  aFcltFee       S              5A   DIM(2)                                             CLE164
     D  aLateFee       S              5A   DIM(2)                                             CLE164
                                                                                              CLE164
     D  Index          S              2S 0 INZ(*ZEROS)                                        CLE164
     D  MAX_CATEGORY   C                   CONST(2)                                           CLE164
      *                                                                                       CSW208
      ** Data Structure for LTRIX                                                             CSW208
      *                                                                                       CSW208
     I*LTRIX**** NS        1 CH                                                      CSW208 AR322732
      *                                                                                       CSW208
      ****Transaction*index*header*************************************              CSW208 AR322732
      *                                                                                       CSW208
     I**********                        1    1  RECID                                CSW208 AR322732
     I**********                        2    2  RCDTD                                CSW208 AR322732
     I**********                        3    8 0LNRFD                                CSW208 AR322732
     I**********                   P    9   11 0NORED                                CSW208 AR322732
     I**********                   P   12   14 0FLSZD                                CSW208 AR322732
     I**********                   P   15   17 0RRLCD                                CSW208 AR322732
     I**********                   P   18   20 0RRNAD                                CSW208 AR322732
     I**********                   P   21   23 0RRLXD                                CSW208 AR322732
     I**********                   P   24   26 0RRXPD                                CSW208 AR322732
     I**********                   P   27   29 0NLNRD                                CSW208 AR322732
     I**********                   P   30   32 0NLARD                                CSW208 AR322732
     I**********                       33   33 0STPID                                CSW208 AR322732
     I**********                   P   38   40 0TNLUD                                CSW208 AR322732
      *                                                                                       CSW208
     I**********NS        1 CD                                                       CSW208 AR322732
      *                                                                                       CSW208
      ***Transaction*index*detail**************************************              CSW208 AR322732
      *                                                                                       CSW208
     I**********                        1    1  RECID                                CSW208 AR322732
     I**********                        2    2  RCDTD                                CSW208 AR322732
     I**********                        3    8 0LNRFD                                CSW208 AR322732
     I**********                        9   13 0VDATD                                CSW208 AR322732
     I**********                       14   16 0LASND                                CSW208 AR322732
     I**********                       17   17  CHTPD                                CSW208 AR322732
     I**********                       18   18  CNRQD                                CSW208 AR322732
     I**********                       19   19  CNPRD                                CSW208 AR322732
     I**********                       20   20  REPRD                                CSW208 AR322732
     I**********                       21   25 0RRLAD                                CSW208 AR322732
     I**********                       26   26  LADID                                CSW208 AR322732
     I**********                       27   27 0PRI1D                                CSW208 AR322732
     I**********                       32   34  BRCAD                                CSW208 AR322732
     I**********                   P   35   37 0RRNTD                                CSW208 AR322732
     I**********                   P   38   40 0TNLUD                                CSW208 AR322732
     I**********                       41   41 0PRI2D                                CSW208 AR322732
     I**********                       42   42 0PRI3D                                CSW208 AR322732
     I**********                       43   43 0PRI4D                                CSW208 AR322732
      *                                                                                       CSW208
     I**********NS                                                                   CSW208 AR322732
      *                                                                                       CSW208
      **  Catch all                                                                           CSW208
      *                                                                                       CSW208
     I**********                        1    1  RECID                                CSW208 AR322732
     ICLOANCLF                                                                              MD034020
     I              OSDB                        COSDB                                       MD034020
     I              OMDB                        COMDB                                       MD034020
     I              RSTM                        CRSTM                                       MD034020
     I              RONS                        CRONS                                       MD034020
     I              RIBN                        CRIBN                                       MD034020
     I              RIBA                        CRIBA                                       MD034020
     I              ROBN                        CROBN                                       MD034020
     I              ROCN                        CROCN                                       MD034020
     I              PSTM                        CPSTM                                       MD034020
     I              PONS                        CPONS                                       MD034020
     I              PIBN                        CPIBN                                       MD034020
     I              PIBA                        CPIBA                                       MD034020
     I              POBN                        CPOBN                                       MD034020
     I              POCN                        CPOCN                                       MD034020
     I              RCRN                        CRCRN                                       MD034020
     I              RCRA                        CRCRA                                       MD034020
     I              RVNO                        CRVNO                                       MD034020
     I              AWBN                        CAWBN                                       MD034020
     I              AWBA                        CAWBA                                       MD034020
     I              BENN                        CBENN                                       MD034020
     I              BENA                        CBENA                                       MD034020
     I              DTP1                        CDTP1                                       MD034020
     I              DTP2                        CDTP2                                       MD034020
     I              DTP3                        CDTP3                                       MD034020
     I              DTP4                        CDTP4                                       MD034020
     I              DCHG                        CDCHG                                       MD034020
     I              BTB1                        CBTB1                                       MD034020
     I              BTB2                        CBTB2                                       MD034020
     I              BTB3                        CBTB3                                       MD034020
     I              BTB4                        CBTB4                                       MD034020
     I              BTB5                        CBTB5                                       MD034020
     I              BTB6                        CBTB6                                       MD034020
     I              CVMR                        CCVMR                                       MD034020
      *
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      ** Check whether user is a web browser user, if so overwrite
     C                   CALL      'SFC000026'
     C                   PARM      *BLANKS       USER             10
      *
     C                   IF        USER <> *BLANKS
     C                   EVAL      PSUSER = USER
     C                   ENDIF
      *
      ** Clear output fields
      *
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C**********         MOVE      *BLANK        WFldNamArr                                  BUG4478
     C**********         MOVE      *BLANK        WMsgIDArr                                   BUG4478
     C**********         MOVE      *BLANK        WMsgDtaArr                                  BUG4478
     C**********         Z-ADD     0             Wx                                          BUG4478
 
     C                   MOVE      VFCNUM        WCNUM
     C                   MOVE      VFFACL        WFAC02
     C                   MOVEL     VFFACL        WFAC03
     C                   MOVE      VFLOAN        WLOAN
     C                   MOVE      VFFSEQ        WFSEQ
                                                                                              CAS011
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                   MOVE      VFFCOD        PKEY                                         CAS011
     C                   CALL      'AOFEER0'                                                  CAS011
     C                   PARM      '*BLANKS'     PRTCD                                        CAS011
     C                   PARM      '*KEY   '     POPTN                                        CAS011
     C                   PARM                    PKEY                                         CAS011
     C     SDFEE         PARM      SDFEE         DSFDY                                        CAS011
                                                                                              CAS011
     C                   EVAL      WADJY = *BLANK                                             CAS011
     C                   IF        PRTCD = *BLANKS                                            CAS011
     C                   EVAL      WADJY = AUADJY                                             CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
 
     C                   CALLB     'ZAGENTMSTM'                                              BUG8144
     C                   PARM                    TimeStamp                                   BUG8144
      *                                                                                      BUG8144
     C                   SELECT
 
      **  Write Fee record
      **  ================
 
     C     VFLCHT        WHENEQ    'I'
     C                   EXSR      WRITER
 
      **  Update Fee record
      **  =================
 
     C     VFLCHT        WHENEQ    'A'
     C                   EXSR      AMENDR
 
      **  Authorise Fee
      **  =============
     C     VFLCHT        WHENEQ    'X'
     C                   EXSR      AMENDR
 
      **  Delete Fee record
      **  ==================
 
     C     VFLCHT        WHENEQ    'D'
     C                   EXSR      AMENDR
 
     C                   ENDSL
 
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
      ** Setup Fee support log
 
     C                   CALLB     'LEFEEMLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    VFLCHT
     C                   PARM                    CrFeFilFmt
     C                   PARM                    CLE006
     C                   PARM                    TRANSDTL
 
      ** Write to support database log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'LEFEEM'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     VFPCRF        APFOTRANID
     C                   MOVEL     VFCNUM        W@VFCNUM          6
     C                   MOVEL     VFFACL        W@VFFACL          5
     C                   MOVEL     VFLOAN        W@VFLOAN          6
     C                   MOVEL     VFFSEQ        W@VFFSEQ          2
     C                   IF        VFFACL <> *Zero
     C                   EVAL      PDealNo = W@VFCNUM + W@VFFACL +
     C                                       W@VFFSEQ
     C                   ELSE
     C                   EVAL      PDealNo = W@VFCNUM + W@VFLOAN +
     C                                       W@VFFSEQ
     C                   ENDIF
 
     C                   EVAL      PADealNo = *BLANKS
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
 
     C                   ENDIF
 
      ** If error occured,
 
     C                   IF        RetCodeOut <> *BLANKS
 
     C                   EVAL      @@RTCD    = '*ERROR'
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  Update the trailer if no errors
      **  Else report an error
 
     C     Ix            IFEQ      0
     C                   EXSR      UPDTRL
      *
      ** Update Shadow Files
     C     VFLCHT        IFEQ      'I'                                                        223922
     C                   CLEAR                   Z#BSTS
     C                   ENDIF                                                                223922
      *                                                                                       223922
     C     FENPYD        IFGT      BJRDNB                                                   AR812101
     C     FELPDT        ANDEQ     BJRDNB                                                   AR812101
     C                   MOVE      '1'           WRKFLD            1                        AR812101
     C                   Z-ADD     FENPYD        WFENPYD                                    AR812101
     C                   Z-ADD     FELPDT        FENPYD                                     AR812101
     C                   ENDIF                                                              AR812101
      *                                                                                     AR812101
     C                   CLEAR                   Z#ASTS
     C                   MOVEL     CrFeFilFmt    Z#ASTS
      *                                                                                     AR812101
     C     WRKFLD        IFEQ      '1'                                                      AR812101
     C                   Z-ADD     WFENPYD       FENPYD                                     AR812101
     C                   MOVE      '0'           WRKFLD                                     AR812101
     C                   ENDIF                                                              AR812101
      *
     C     FEAUTO        IFEQ      'Y'
                                                                                              CLE134
     C     FEAUTO        OREQ      'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
                                                                                              CLE134
     C     FEAUTO        ORNE      WFEAUT                                                     223922
      *                                                                                       260840
      ** Do not project when Next Payment date has been amended and is equal to               260840
      ** the Last Payment date and is equal to the business date except when the              260840
      ** autosettle indicator was changed from 'N' to 'Y' or when settlement                  260840
      ** instructions have been amended.                                                      260840
      *                                                                                       260840
     C     FENPYD        IFEQ      FELPDT                                                     260840
     C     FENPYD        ANDEQ     BJRDNB                                                     260840
     C     FEAUTO        ANDEQ     'Y'                                                        260840
     C     FENPYD        OREQ      FELPDT                                                   AR550169
     C     FENPYD        ANDEQ     BJRDNB                                                   AR550169
     C     FEAUTO        ANDEQ     'C'                                                      AR550169
     C     CLE134        ANDEQ     'Y'                                                      AR550169
     C*****FEAUTO        IFEQ      'Y'                                               260840 AR550169
     C*****FEAUTO        ANDNE     WFEAUT                                            260840 AR550169
     C*****Z#BSTS        ORNE      Z#ASTS                                            260840 AR550169
     C     FEAUTO        IFNE      WFEAUT                                                   AR550169
     C     WFEAUT        ANDEQ     'N'                                                      AR550169
     C     RSTM          ORNE      WRSTM                                                    AR550169
     C     RONS          ORNE      WRONS                                                    AR550169
     C     PSTM          ORNE      WPSTM                                                    AR550169
     C     PONS          ORNE      WPONS                                                    AR550169
     C                   EXSR      SRUSHD                                                     260840
     C                   ENDIF                                                                260840
     C                   ELSE                                                                 260840
     C                   EXSR      SRUSHD
     C                   ENDIF                                                                260840
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01182
 
     C                   ELSE
     C     @@RTCD        IFEQ      *BLANK
     C                   MOVEL     '*ERROR    '  @@RTCD
     C                   ENDIF
     C                   ENDIF
      *
      * Keep The Fee sequence
 
     C                   EVAL      WWFSEQ  = FEFSEQ
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   SELECT                                                               CRE020
     C                   WHEN      VFLCHT = 'X' OR                                            CRE020
     C                             VFLCHT = 'D'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   WHEN      VFLCHT = 'A'                                               CRE020
     C                   EXSR      SRIdxAmd                                                   CRE020
                                                                                              CRE020
     C                   IF        BPFEAU = 'N'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   WHEN      VFLCHT = 'I'                                               CRE020
     C                   IF        BPFEAU = 'N'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
     C                   ENDIF                                                                CRE020
      *
      * EXIT FROM PROGRAM
 
     C                   RETURN
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
      * WRITER   : Write a record to Fee file                         *
      *****************************************************************
     C     WRITER        BEGSR
 
      * INITIALIZE FEE
     C                   CLEAR                   CrFeFilFmt
 
      ** Find next available sequence no. for insert
      *
     C     VFFSEQ        IFEQ      0
     C                   EXSR      SEQGEN
     C                   ELSE
     C                   Z-ADD     VFFSEQ        FEFSEQ
     C                   END
      *
      ** Obtain last transaction number and prepare standard
      *
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FETNLU
      *
      ** Set Swift Message Regeneration Indicator
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF
                                                                                              CAS011
      ** Initialise new fields introduced by CAS009                                           CAS011
                                                                                              CAS011
     C                   EVAL      FEADJY = *BLANKS                                           CAS011
     C                   EVAL      FEAMTD = *ZERO                                             CAS011
     C                   EVAL      FEFEAM = *ZERO                                             CAS011
     C                   EVAL      FEFEAC = *ZERO                                             CAS011
     C                   EVAL      FEAFES = *ZERO                                             CAS011
     C                   EVAL      FEAFEE = *ZERO                                             CAS011
     C                   EVAL      FEAFOF = *ZERO                                             CAS011
     C                   EVAL      FETFTD = *ZERO                                             CAS011
     C                   EVAL      FEAFLS = *ZERO                                             CAS011
     C                   EVAL      FEUAFA = *ZERO                                             CAS011
     C                   EVAL      FEAFLD = *ZERO                                             CAS011
                                                                                              CAS011
     C                   IF        CAS009 = 'Y' AND WFAC05 = 0                                CAS011
     C                             AND VFCALT = *BLANKS                                       CAS011
     C                   EXSR      SRUpdEIR                                                   CAS011
     C                   EVAL      FETFTD = *ZERO                                             CAS011
     C                   EVAL      FEAFLD = *ZERO                                             CAS011
     C                   EVAL      FEADJY = WADJY                                             CAS011
     C                   ENDIF                                                                CAS011
                                                                                            MD030700
      ** Take note of fees with pay date today or in the past                               MD030700
      ** for fee advice generation.                                                         MD030700
                                                                                            MD030700
     C                   IF        VFPYON = 'N'                                             MD030700
     C                             AND VFNPYD <= BJRDNB                                     MD030700
     C                   EVAL      FFCNUM = VFCNUM                                          MD030700
     C                   EVAL      FFFACL = VFFACL                                          MD030700
     C                   EVAL      FFLOAN = VFLOAN                                          MD030700
     C                   EVAL      FFFSEQ = FEFSEQ                                          MD030700
     C                   EVAL      FFBNPD = VFNPYD                                          MD030700
     C                   EVAL      FFANPD = VFNPYD                                          MD030700
     C                   WRITE     LEFEDNPF                                                 MD030700
     C                   ENDIF                                                              MD030700
      *
      ** Obtain Fee details to be written to file
     C                   EXSR      TRSSTF
      *
      ** Settlement details
     C                   Z-ADD     VFRSTM        RSTM
     C                   MOVE      VFRONS        RONS
     C                   MOVE      VFRIBN        RIBN
     C                   MOVE      VFRIBA        RIBA
     C                   MOVE      VFROBN        ROBN
     C                   MOVE      VFROCN        ROCN
     C                   MOVE      VFPSTM        PSTM
     C                   MOVE      VFPONS        PONS
     C                   MOVE      VFPIBN        PIBN
     C                   MOVE      VFPIBA        PIBA
     C                   MOVE      VFPOBN        POBN
     C                   MOVE      VFPOCN        POCN
     C                   MOVE      VFRCRN        RCRN
     C                   MOVE      VFRCRA        RCRA
     C                   MOVE      VFRVNO        RVNO
     C                   MOVE      VFAWBN        AWBN
     C                   MOVE      VFAWBA        AWBA
     C                   MOVE      VFBENN        BENN
     C                   MOVE      VFBENA        BENA
     C                   MOVE      VFDTP1        DTP1
     C                   MOVE      VFDTP2        DTP2
     C                   MOVE      VFDTP3        DTP3
     C                   MOVE      VFDTP4        DTP4
     C                   MOVE      VFDCHG        DCHG
     C                   MOVE      VFBTB1        BTB1
     C                   MOVE      VFBTB2        BTB2
     C                   MOVE      VFBTB3        BTB3
     C                   MOVE      VFBTB4        BTB4
     C                   MOVE      VFBTB5        BTB5
     C                   MOVE      VFBTB6        BTB6
     C                   MOVE      VFCVMR        CVMR
     C                   MOVE      VFFEPEXR      FEPEXR                                       CLE106
     C                   MOVE      VFFEPEXI      FEPEXI                                       CLE106
     C                   MOVE      VFFEREXR      FEREXR                                       CLE106
     C                   MOVE      VFFEREXI      FEREXI                                       CLE106
      *
     C                   MOVE      VFCNUM        FECNUM
     C**********         Z-ADD     VFLOAN        FELOAN                                       CLE148
     C                   MOVEL     VFLOAN        FELOAN                                       CLE148
     C                   Z-ADD     VFFACL        FEFACL
     C                   MOVE      VFLCHT        FELCHT
     C                   Z-ADD     VFLCHD        FELCHD
      *
      ** PTFI should always be blank (receivable) if CLE006 is OFF.
     C     CLE006        IFEQ      'Y'
     C                   MOVE      VFPTFI        PTFI
     C                   ELSE
     C                   MOVE      ' '           PTFI
     C                   ENDIF
 
     C*****FELOAN        IFEQ      0                                                          CLE148
     C     FELOAN        IFEQ      *BLANKS                                                    CLE148
     C                   MOVE      *BLANKS       FELTYP
     C                   MOVE      *BLANKS       FESUTP
     C                   MOVE      *BLANKS       FECLAS                                       CLE042
     C/COPY WNCPYSRC,LEH00156
     C                   ELSE
     C                   MOVE      VFLTYP        FELTYP
     C                   MOVE      VFSUTP        FESUTP
     C                   MOVE      VFCLAS        FECLAS                                       CLE042
     C                   ENDIF
      *
     C                   Z-ADD     VFORED        FEORED
     C                   MOVE      VFBRCA        FEBRCA
     C                   Z-ADD     0             FEADAT
     C                   MOVE      'D'           FERECI
     C                   Z-ADD     0             FEAMTP
     C                   Z-ADD     0             FELPDT
     C                   Z-ADD     0             FELADT
     C                   Z-ADD     0             FEDDAT
     C                   Z-ADD     0             FEAMTO
     C                   Z-ADD     0             FEPLPD
     C                   Z-ADD     0             FELPAM
     C                   Z-ADD     0             FEPAMS
     C                   Z-ADD     0             FEPAMP
     C                   Z-ADD     0             FEADBP
      *
      ** Move work field back into file field
      *
     C                   Z-ADD     VFAMTA        FEAMTA
     C                   Z-ADD     VFAMTS        FEAMTS
     C                   MOVE      *BLANKS       FEACOF
     C                   MOVE      VFDIND        FEDIND
     C                   Z-ADD     VFSDAT        FESDAT
     C                   MOVE      *BLANK        FESPTI
     C                   MOVE      *BLANK        FEPPTI
     C                   MOVE      *BLANK        FEEPTI
     C                   MOVE      *BLANK        FESBTI
     C                   MOVE      *BLANK        FEPBTI
     C                   MOVE      *BLANK        FEEBTI
     C                   Z-ADD     0             LSWC
     C                   Z-ADD     0             LSWS
     C                   Z-ADD     0             FETADJ
     C                   Z-ADD     0             FEWOFF
     C                   Z-ADD     0             FEAMTW
     C                   MOVE      *BLANK        FEINDC
      *
     C     BPFEAU        IFEQ      'N'
     C     CLE002        OREQ      'N'
     C     VFAUTH        OREQ      'Y'                                                        CAP086
     C     CAP086        ANDEQ     'Y'                                                        CAP086
     C                   MOVE      'A'           FSTS
     C                   ELSE
     C                   MOVE      'C'           FSTS
     C                   ENDIF
      *
     C*****CEU004        IFEQ      'Y'                                                        260783
     C                   MOVE      VFSCCY        FESCCY
     C                   MOVE      VFICCY        FEICCY
     C**********         ENDIF                                                                260783
      *                                                                                     AR943686
     C     CLE031        IFEQ      'Y'                                                      AR943686
     C                   MOVE      VFSCCY        FESCCY                                     AR943686
     C                   Z-ADD     VFFEREXR      FEREXR                                     AR943686
     C                   MOVE      VFFEREXI      FEREXI                                     AR943686
     C                   MOVE      VFFEPSCY      FEPSCY                                     AR943686
     C                   Z-ADD     VFFEPEXR      FEPEXR                                     AR943686
     C                   MOVE      VFFEPEXI      FEPEXI                                     AR943686
     C                   ENDIF                                                              AR943686
      *
     C                   MOVEL     VFIUSR        IUSR
     C                   MOVEL     VFAUSR        AUSR
     C                   MOVEL     VFXUSR        XUSR
 
     C                   MOVE      *BLANK        GFPT
     C                   MOVE      *BLANK        PTAI
     C                   MOVE      *BLANK        SMAC
     C                   MOVE      *BLANK        PCOB
      *
     C                   MOVEL     VFPCRF        PCRF
     C                   MOVEL     VFSYIN        FESYIN                                       CLE106
     C                   MOVE      VFSTAL        FESTAL                                       CLE034
      *                                                                                      BUG8144
     C                   Eval      STMP = TimeStamp                                          BUG8144
      *                                                                                      BUG8144
                                                                                             BUG3760
      ** If compliance watch is installed, and entry watch list checking                     BUG3760
      ** is being applied, perform compliance watch processing                               BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                           BUG3760
                                                                                             BUG3760
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                          BUG3760
     C                             OR CSC011 = 'N'                                           BUG3760
     C                   EXSR      SrWatch                                                   BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      FEAUTH = VFAUTH                                            CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C**********         EXSR      xeXRF                                            CLE134 AR1022006
     C                   EVAL      FEXRFI = 'FEE'                                          AR1022006
     C                   ENDIF                                                                CLE134
      *
      ** Write a new record to file LEFEED
      *
     C                   WRITE     LEFEEDF1                             78
 
      ** Update Settlement Allocation file with generated Fee Sequence                       BUG9225
                                                                                             BUG9225
     C     PCRF          CHAIN     LESTALLA                           99                     BUG9225
     C     *IN99         DOWEQ     *OFF                                                      BUG9225
     C                   Z-ADD     FEFSEQ        XXFESQ                                      BUG9225
     C                   UPDATE    LESTALD0                                                  BUG9225
     C     PCRF          READE     LESTALLA                               99                 BUG9225
     C                   ENDDO                                                               BUG9225
                                                                                             BUG9225
      *                                                                                       CSW208
      ** Output Record in LTRIX                                                               CSW208
      ** SWIFT 2008 switched on                                                               CSW208
      ** LE Confirmation should be 'Y'                                                        CSW208
      ** Loan Fee should be Authorised                                                        CSW208
      ** Customer should have SWIFT ID                                                        CSW208
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y'  AND                                          CSW208
     C                             LSCONF = 'Y'  AND                                          CSW208
     C                             FSTS   = 'A'  AND                                          CSW208
     C**********                   FELOAN <> *ZEROS                                    CSW208 CLE148
     C                             FELOAN <> *BLANKS                                          CLE148
      *                                                                                       CSW208
      ** Access Customer details                                                              CSW208
      *                                                                                       CSW208
     C                   EXSR      SRCHCT                                                     CSW208
      *                                                                                       CSW208
     C                   IF        BBCSID <> *BLANKS                                          CSW208
     C                   EXSR      SRLOAN                                                     CSW208
     C**********         EXSR      SRRLTX                                            CSW208 AR322732
     C                   EXSR      SRWLTX                                                     CSW208
     C                   ENDIF                                                                CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
      *                                                                                       CLE164
      ** Output Repayment Priority Details to Customer Loan                                   CLE164
      ** Repayment Priority Extension File                                                    CLE164
     C                   EXSR      WriteExtFile                                               CLE164
                                                                                              CLE134
      ** If Past Due Call Loan Processing & Auto-settle;                                      CLE134
      ** - Initialise Key Fields.                                                             CLE134
                                                                                              CLE134
     C**********         IF        CLE134      = 'Y'           AND                     CLE134 CLE164
     C**********                   FEAUT2      = 'C'                                 CLE134 AR574498
     C**********                   FEAUT2      = 'C'           AND                   AR574498 CLE164
     C**********                   VFLCHT      <> 'D'                                AR574498 CLE164
     C**********         EVAL      KRPFCNM     = FECNUM                                CLE134 CLE164
     C**********         EVAL      KRPFLNR     = FELOAN                                CLE134 CLE164
     C**********         EVAL      KRPFACT     = FEFACL                                CLE134 CLE164
     C**********         EVAL      KRPFSE1     = FEFSEQ                                CLE134 CLE164
     C**********         EVAL      KRPFCOD     = FEFCOD                                CLE134 CLE164
     C**********         EVAL      KRPFCBR     = FEBRCA                                CLE134 CLE164
                                                                                              CLE134
      ***-*Retrieve*Repayment*Priority*Details.***********************                 CLE134 CLE164
                                                                                              CLE134
     C*****KLEACCNLB     CHAIN(E)  LEACCNLB                                            CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(LEACCNLB)            OR                      CLE134 CLE164
     C**********                   %ERROR                                              CLE134 CLE164
     C******LOCK         IN        LDA                                                 262754 CLE164
     C**********         EVAL      DBFILE      = 'LEACCNLB'                            CLE134 CLE164
     C**********         EVAL      DBKEY       = KRPFCNM + KRPFLNR +                   CLE134 CLE164
     C**********                                 %CHAR(KRPFACT) +                      CLE134 CLE164
     C**********                                 %CHAR(KRPFSE1) +                      CLE134 CLE164
     C**********                                 %CHAR(KRPFCOD) +                      CLE134 CLE164
     C**********                                 KRPFCBR                               CLE134 CLE164
     C**********         EVAL      DBASE       = 200                                   CLE134 CLE164
     C**********         OUT       LDA                                                 262754 CLE164
     C**********         EXSR      *PSSR                                               CLE134 262754
     C**********         EXSR      srERR                                               262754 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***-*Set*&*Write*Repayment*Priority*Details.********************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EXSR      xsACCN                                              CLE134 CLE164
     C**********         WRITE(E)  LEACCND0                                            CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %ERROR                                              CLE134 CLE164
     C******LOCK         IN        LDA                                                 CLE134 CLE164
     C**********         EVAL      DBFILE      = 'LEACCNLB'                            CLE134 CLE164
     C**********         EVAL      DBKEY       = KRPFCNM + KRPFLNR +                   CLE134 CLE164
     C**********                                 %CHAR(KRPFACT) +                      CLE134 CLE164
     C**********                                 %CHAR(KRPFSE1) +                      CLE134 CLE164
     C**********                                 %CHAR(KRPFCOD) +                      CLE134 CLE164
     C**********                                 KRPFCBR                               CLE134 CLE164
     C**********         EVAL      DBASE       = 201                                   CLE134 CLE164
     C**********         OUT       LDA                                                 262754 CLE164
     C**********         EXSR      *PSSR                                               CLE134 262754
     C**********         EXSR      srERR                                               262754 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C                   ENDSR
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
      * AMENDR   : Update Fee File                                    *
      *****************************************************************
     C     AMENDR        BEGSR
      *
      ** Check whether amended by another work station
     C     KEY002        SETLL     LEFEEDF1
     C     KEY002        CHAIN     LEFEEDF1                           78
      *
     C     *IN78         IFEQ      '1'
     C     FETNLU        ORNE      H#TNLU
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN      'FldNameArr(Ix)
     C                   MOVEL     'LER0071'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  @@RTCD
     C                   GOTO      EAMENDR
     C                   ENDIF
      *                                                                                     AR812101
     C     FENPYD        IFGT      BJRDNB                                                   AR812101
     C     FELPDT        ANDEQ     BJRDNB                                                   AR812101
     C                   MOVE      '1'           WRKFLD            1                        AR812101
     C                   Z-ADD     FENPYD        WFENPYD                                    AR812101
     C                   Z-ADD     FELPDT        FENPYD                                     AR812101
     C                   ENDIF                                                              AR812101
      *
     C                   CLEAR                   Z#BSTS
     C                   MOVEL     CrFeFilFmt    Z#BSTS
      *                                                                                     AR812101
     C     WRKFLD        IFEQ      '1'                                                      AR812101
     C                   Z-ADD     WFENPYD       FENPYD                                     AR812101
     C                   MOVE      '0'           WRKFLD                                     AR812101
     C                   ENDIF                                                              AR812101
      *
      ** Obtain last transaction number
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FETNLU
     C**********         Z-ADD     VFLCHD        FELCHD                                       237679
      *                                                                                       237679
     ** use rundate as last change date                                                       237679
      *                                                                                       237379
     C                   Z-ADD     BJRDNB        FELCHD                                       237679
      *
      ** Set Swift Message Regeneration Indicator
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF
      *
      ** Set up the following fields for action Amend
     C     VFLCHT        IFEQ      'A'
      *
     C*****CEU004        IFEQ      'Y'                                                        260783
     C                   MOVE      VFSCCY        FESCCY
     C                   MOVE      VFICCY        FEICCY
     C                   MOVE      VFFEPSCY      FEPSCY                                       CLE106
     C**********         ENDIF                                                                260783
      *                                                                                     AR943686
     C     CLE031        IFEQ      'Y'                                                      AR943686
     C                   MOVE      VFSCCY        FESCCY                                     AR943686
     C                   Z-ADD     VFFEREXR      FEREXR                                     AR943686
     C                   MOVE      VFFEREXI      FEREXI                                     AR943686
     C                   MOVE      VFFEPSCY      FEPSCY                                     AR943686
     C                   Z-ADD     VFFEPEXR      FEPEXR                                     AR943686
     C                   MOVE      VFFEPEXI      FEPEXI                                     AR943686
     C                   ENDIF                                                              AR943686
                                                                                              CAS011
     C                   IF        CAS009 = 'Y' AND WFAC05 = 0                                CAS011
     C                             AND VFCALT = *BLANKS                                       CAS011
                                                                                              CAS011
     C                   EVAL      WUPDEI = 'N'                                               CAS011
                                                                                              CAS011
     C                   IF        WADJY <> FEADJY OR VFFCCY <> FEFCCY                        CAS011
     C                             OR VFFAMT <> FEFAMT                                        CAS011
     C                   EVAL      WUPDEI = 'Y'                                               CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** If the Fee is a Bullet Fee or Amortised Fee                                          CAS011
                                                                                              CAS011
     C                   IF        FEPYON = *BLANKS OR FEPYON = 'S'                           CAS011
                                                                                              CAS011
      ** If Start Date has been Amended                                                       CAS011
                                                                                              CAS011
     C                   IF        VFPSTD <> FEPSTD                                           CAS011
     C                   EVAL      WUPDEI = 'Y'                                               CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** The Fee is an Accrued Fee                                                            CAS011
                                                                                              CAS011
     C                   IF        FEPYON = 'E' OR (FEPYON = 'N'                              CAS011
     C                             AND VFFAMT <> 0)                                           CAS011
                                                                                              CAS011
      ** The End Date has been Amended                                                        CAS011
                                                                                              CAS011
     C                   IF        VFPEND <> FEPEND                                           CAS011
     C                   EVAL      WUPDEI = 'Y'                                               CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   IF        WUPDEI = 'Y'                                               CAS011
     C                   EXSR      SRUpdEIR                                                   CAS011
     C                   EVAL      FEADJY = WADJY                                             CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      *
     C                   IF        FEPYON = 'N'                                             MD030700
     C                   EXSR      SRNPAMD                                                  MD030700
     C                   ENDIF                                                              MD030700
      *                                                                                     MD030700
     C                   EXSR      TRSSTF
      *
     C                   MOVE      VFLCHT        FELCHT
     C**********         MOVE      'A'           FSTS                                         223922
     C                   MOVEL     VFAUSR        AUSR
     C                   MOVEL     VFXUSR        XUSR
     C                   MOVEL     VFPCRF        PCRF
     C                   MOVEL     VFSYIN        FESYIN                                       CLE106
     C                   MOVE      VFSTAL        FESTAL                                       CLE034
      *
 
     C     BPFEAU        IFEQ      'N'
     C     CLE002        OREQ      'N'
     C     VFAUTH        OREQ      'Y'                                                        CAP086
     C     CAP086        ANDEQ     'Y'                                                        CAP086
     C                   MOVE      'A'           FSTS
     C                   ELSE
     C     FSTS          IFEQ      'A'
     C     FSTS          OREQ      'R'
     C                   MOVE      'R'           FSTS
     C                   ELSE
     C                   MOVE      'C'           FSTS
     C                   ENDIF
     C                   ENDIF
      *
      ** Settlement details
      *                                                                                     AR550169
      ** Save receipt and pay settlement                                                    AR550169
      *                                                                                     AR550169
     C                   Z-ADD     RSTM          WRSTM             2 0                      AR550169
     C                   MOVE      RONS          WRONS            18                        AR550169
     C                   Z-ADD     PSTM          WPSTM             2 0                      AR550169
     C                   MOVE      PONS          WPONS            18                        AR550169
      *                                                                                     AR550169
     C                   Z-ADD     VFRSTM        RSTM
     C                   MOVE      VFRONS        RONS
     C                   MOVE      VFRIBN        RIBN
     C                   MOVE      VFRIBA        RIBA
     C                   MOVE      VFROBN        ROBN
     C                   MOVE      VFROCN        ROCN
     C                   MOVE      VFPSTM        PSTM
     C                   MOVE      VFPONS        PONS
     C                   MOVE      VFPIBN        PIBN
     C                   MOVE      VFPIBA        PIBA
     C                   MOVE      VFPOBN        POBN
     C                   MOVE      VFPOCN        POCN
     C                   MOVE      VFRCRN        RCRN
     C                   MOVE      VFRCRA        RCRA
     C                   MOVE      VFRVNO        RVNO
     C                   MOVE      VFAWBN        AWBN
     C                   MOVE      VFAWBA        AWBA
     C                   MOVE      VFBENN        BENN
     C                   MOVE      VFBENA        BENA
     C                   MOVE      VFDTP1        DTP1
     C                   MOVE      VFDTP2        DTP2
     C                   MOVE      VFDTP3        DTP3
     C                   MOVE      VFDTP4        DTP4
     C                   MOVE      VFDCHG        DCHG
     C                   MOVE      VFBTB1        BTB1
     C                   MOVE      VFBTB2        BTB2
     C                   MOVE      VFBTB3        BTB3
     C                   MOVE      VFBTB4        BTB4
     C                   MOVE      VFBTB5        BTB5
     C                   MOVE      VFBTB6        BTB6
     C                   MOVE      VFCVMR        CVMR
      *
     C                   ENDIF
      *
      ** Set up the following fields for Authorisation
      *
     C     VFLCHT        IFEQ      'X'
     C     BPFEAU        ANDEQ     'Y'
     C     CLE002        ANDEQ     'Y'
     C                   MOVE      'A'           FSTS
     C                   MOVE      'X'           FELCHT
     C                   MOVEL     USER          XUSR
     C                   ENDIF
      *
      ** Set up the following fields for reverse Amend
     C     VFLCHT        IFEQ      'D'
     C                   IF        CAS009 = 'Y' AND WFAC05 = 0                                CAS011
     C                             AND VFCALT = *BLANKS                                       CAS011
     C                   EXSR      SRUpdEIR                                                   CAS011
     C                   ENDIF                                                                CAS011
     C                   MOVE      'R'           FERECI
     C                   MOVE      'D'           FELCHT
     C                   MOVE      'A'           FSTS
                                                                                            MD030700
     C                   EVAL      FFCNUM = FECNUM                                          MD030700
     C                   EVAL      FFFACL = FEFACL                                          MD030700
     C                   EVAL      FFLOAN = FELOAN                                          MD030700
     C                   EVAL      FFFSEQ = FEFSEQ                                          MD030700
     C     KFNPD         CHAIN     LEFEDNL0                                                 MD030700
     C                   IF        %FOUND(LEFEDNL0)                                         MD030700
     C                   DELETE    LEFEDNL0                                                 MD030700
     C                   ENDIF                                                              MD030700
                                                                                            MD030700
     C                   ENDIF
      *                                                                                      BUG8144
     C                   Eval      STMP = TimeStamp                                          BUG8144
                                                                                             BUG3760
      ** If compliance watch is installed, and entry watch list checking                     BUG3760
      ** is being applied, perform compliance watch processing for amend mode                BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                           BUG3760
                                                                                             BUG3760
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                          BUG3760
     C                             OR CSC011 = 'N'                                           BUG3760
                                                                                             BUG3760
     C                   EVAL      KIden = *Blanks                                           BUG3760
     C                   EVAL      W2CNUM = *Blanks                                          BUG3760
     C                   EVAL      W2FACL = *Blanks                                          BUG3760
     C                   EVAL      W2FSEQ = *Blanks                                          BUG3760
     C                   EVAL      W2LOAN= *Blanks                                           BUG3760
                                                                                             BUG3760
     C**********         IF        FELOAN = *Zeros                                    BUG3760 CLE148
     C                   IF        FELOAN = *BLANKS                                           CLE148
     C                   MOVE      FECNUM        W2CNUM                                      BUG3760
     C                   MOVE      FEFACL        W2FACL                                      BUG3760
     C                   MOVE      FEFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      KIDEN = %TRIM(W2CNUM + W2FACL + W2FSEQ)                   BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      FELOAN        W2LOAN                                      BUG3760
     C                   MOVE      FEFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      KIDEN = %TRIM(W2LOAN + W2FSEQ)                            BUG3760
     C                   ENDIF                                                               BUG3760
     C                   EVAL      KBranch = FEBRCA                                          BUG3760
     C                   EVAL      WUNCF = *Blanks                                           BUG3760
     C                   EVAL      KFuncType = 'LEFEED'                                      BUG3760
     C     CWHTKY        CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                         BUG3760
     C                             OR NOT %FOUND(SDCWHTL1)                                   BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1)                                          BUG3760
     C                   EVAL      WUNCF = W3UNCF                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EXSR      SrWatch                                                   BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      FEAUTH = VFAUTH                                            CAP086
     C                   ENDIF                                                                CAP086
     C/COPY WNCPYSRC,LEH00157
     C                   IF        CLE134      = 'Y'           AND                            CLE134
     C                             FEXRFI      = *BLANKS       AND                            CLE134
     C                             FEXRFN      = 0                                            CLE134
     C**********         EXSR      xeXRF                                            CLE134 AR1022006
     C                   EVAL      FEXRFI = 'FEE'                                          AR1022006
     C                   ENDIF                                                                CLE134
      *
      ** Update record of LEFEED
     C                   UPDATE    LEFEEDF1                             78
      *                                                                                       CSW208
      ** Output Record in LTRIX                                                               CSW208
      ** SWIFT 2008 switched on                                                               CSW208
      ** LE Confirmation should be 'Y'                                                        CSW208
      ** Loan Fee should be Authorised                                                        CSW208
      ** Customer should have SWIFT ID                                                        CSW208
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y'  AND                                          CSW208
     C                             LSCONF = 'Y'  AND                                          CSW208
     C**********                   FELOAN <> *ZEROS                                    CSW208 CLE148
     C                             FELOAN <> *BLANKS                                          CLE148
      *                                                                                       CSW208
      ** Access Customer details                                                              CSW208
      *                                                                                       CSW208
     C                   EXSR      SRCHCT                                                     CSW208
      *                                                                                       CSW208
     C                   IF        BBCSID <> *BLANKS                                          CSW208
      *                                                                                       CSW208
     C                   IF        FELCHT = 'A'  AND                                          CSW208
     C                             WAMDED = 'Y'  OR                                           CSW208
     C                             FELCHT = 'D'  OR                                           CSW208
     C                             FELCHT = 'X'                                               CSW208
     C                   EXSR      SRLOAN                                                     CSW208
     C**********         EXSR      SRRLTX                                            CSW208 AR322732
     C                   EXSR      SRWLTX                                                     CSW208
     C                   ENDIF                                                                CSW208
     C                   ENDIF                                                                CSW208
     C                   ENDIF                                                                CSW208
                                                                                            AR545441
      ***If*Past*Due*Call*Loan*Processing*&*Auto-settle*<>*'C'********               AR545441 CLE164
      ***and*record*exists*in*LEACCNPD********************************               AR545441 CLE164
      ***-*delete*record*in*LEACCNPD**********************************               AR545441 CLE164
                                                                                            AR545441
     C**********         IF        CLE134      = 'Y'           AND                   AR545441 CLE164
     C**********                   FEAUTO      <>'C'                               AR545441 AR574498
     C**********                   FEAUTO      <>'C'           OR                    AR574498 CLE164
     C**********                   VFLCHT      = 'D'                                 AR574498 CLE164
     C**********         EVAL      KRPFCNM     = FECNUM                              AR545441 CLE164
     C**********         EVAL      KRPFLNR     = FELOAN                              AR545441 CLE164
     C**********         EVAL      KRPFACT     = FEFACL                              AR545441 CLE164
     C**********         EVAL      KRPFSE1     = FEFSEQ                              AR545441 CLE164
     C**********         EVAL      KRPFCOD     = FEFCOD                              AR545441 CLE164
     C**********         EVAL      KRPFCBR     = FEBRCA                              AR545441 CLE164
                                                                                            AR545441
      ***-*Retrieve*Repayment*Priority*Details.***********************               AR545441 CLE164
                                                                                            AR545441
     C*****KLEACCNLB     CHAIN(E)  LEACCNLB                                          AR545441 CLE164
     C**********         IF        %FOUND(LEACCNLB)                                  AR545441 CLE164
     C**********         DELETE    LEACCND0                                          AR545441 CLE164
     C**********         ENDIF                                                       AR545441 CLE164
     C**********         ENDIF                                                       AR545441 CLE164
      *
                                                                                              CLE134
      ***If*Past*Due*Call*Loan*Processing*&*Auto-settle;**************                 CLE134 CLE164
      ***-*Initialise*Key*Fields.*************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         IF        CLE134      = 'Y'           AND                     CLE134 CLE164
     C**********                   FEAUT2      = 'C'                                   CLE134 CLE164
     C**********         EVAL      KRPFCNM     = FECNUM                                CLE134 CLE164
     C**********         EVAL      KRPFLNR     = FELOAN                                CLE134 CLE164
     C**********         EVAL      KRPFACT     = FEFACL                                CLE134 CLE164
     C**********         EVAL      KRPFSE1     = FEFSEQ                                CLE134 CLE164
     C**********         EVAL      KRPFCOD     = FEFCOD                                CLE134 CLE164
     C**********         EVAL      KRPFCBR     = FEBRCA                                CLE134 CLE164
                                                                                              CLE134
      ***-*Retrieve*Repayment*Priority*Details.***********************                 CLE134 CLE164
                                                                                              CLE134
     C*****KLEACCNLB     CHAIN(E)  LEACCNLB                                            CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %ERROR                                              CLE134 CLE164
     C******LOCK         IN        LDA                                                 262754 CLE164
     C**********         EVAL      DBFILE      = 'LEACCNLB'                            CLE134 CLE164
     C**********         EVAL      DBKEY       = KRPFCNM + KRPFLNR +                   CLE134 CLE164
     C**********                                 %CHAR(KRPFACT) +                      CLE134 CLE164
     C**********                                 %CHAR(KRPFSE1) +                      CLE134 CLE164
     C**********                                 %CHAR(KRPFCOD) +                      CLE134 CLE164
     C**********                                 KRPFCBR                               CLE134 CLE164
     C**********         EVAL      DBASE       = 205                                   CLE134 CLE164
     C**********         OUT       LDA                                                 262754 CLE164
     C**********         EXSR      *PSSR                                               CLE134 262754
     C**********         EXSR      srERR                                               262754 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***-*Set*&*Update*Repayment*Priority*Details********************                 CLE134 CLE164
      ***(if*Settlement*A/c*Changed).*********************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(LEACCNLB)                                    CLE134 CLE164
     C**********         EVAL      DSCNUM      = RPCNUM                                CLE134 CLE164
     C**********         EVAL      DSACOD      = RPACOD                                CLE134 CLE164
     C**********         EVAL      DSACSQ      = RPACSQ                                CLE134 CLE164
     C**********         EVAL      DSBRCA      = RPBRCA                                CLE134 CLE164
     C**********         EVAL      DSACCY      = RPACCY                                CLE134 CLE164
     C**********         EXSR      xsACCN                                              CLE134 CLE164
                                                                                              CLE134
     C**********         IF        DSCNUM     <> RPCNUM        OR                      CLE134 CLE164
     C**********                   DSACOD     <> RPACOD        OR                      CLE134 CLE164
     C**********                   DSACSQ     <> RPACSQ        OR                      CLE134 CLE164
     C**********                   DSBRCA     <> RPBRCA        OR                      CLE134 CLE164
     C**********                   DSACCY     <> RPACCY                                CLE134 CLE164
     C**********         UPDATE(E) LEACCND0                                            CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***-*Set*&*Write*Repayment*Priority*Details.********************                 CLE134 CLE164
                                                                                              CLE134
     C**********         ELSE                                                          CLE134 CLE164
     C**********         EXSR      xsACCN                                              CLE134 CLE164
     C**********         WRITE(E)  LEACCND0                                            CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %ERROR                                              CLE134 CLE164
     C******LOCK         IN        LDA                                                 262754 CLE164
     C**********         EVAL      DBFILE      = 'LEACCNLB'                            CLE134 CLE164
     C**********         EVAL      DBKEY       = KRPFCNM + KRPFLNR +                   CLE134 CLE164
     C**********                                 %CHAR(KRPFACT) +                      CLE134 CLE164
     C**********                                 %CHAR(KRPFSE1) +                      CLE134 CLE164
     C**********                                 %CHAR(KRPFCOD) +                      CLE134 CLE164
     C**********                                 KRPFCBR                               CLE134 CLE164
     C**********         EVAL      DBASE       = 206                                   CLE134 CLE164
     C**********         OUT       LDA                                                 262754 CLE164
     C**********         EXSR      *PSSR                                               CLE134 262754
     C**********         EXSR      srERR                                               262754 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE164
     C                   IF        VFLCHT = 'A'                                               CLE164
     C                   EXSR      UpdateExtFile                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   IF        VFLCHT = 'D'                                               CLE164
     C                   EXSR      DeleteExtFile                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE134
     C     EAMENDR       ENDSR
      *****************************************************************
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      **xsACCN*-*Set*Repayment*Priority*Details.***********************                CLE134 CLE164
      *****************************************************************                       CLE134
     C*****xsACCN        BEGSR                                                         CLE134 CLE164
                                                                                              CLE134
      ***Initialisation.***********************************************                CLE134 CLE164
                                                                                              CLE134
     C**********         CLEAR                   LEACCND0                              CLE134 CLE164
                                                                                              CLE134
      ***Derive*Settlement*Account.************************************                CLE134 CLE164
      ***-*Set*from*Fee*Payable.***************************************                CLE134 CLE164
                                                                                              CLE134
     C**********         IF        PTFI       <> *BLANKS                               CLE134 CLE164
     C**********         SELECT                                                        CLE134 CLE164
     C**********         WHEN      PSTM        = 01            OR                      CLE134 CLE164
     C**********                   PSTM        = 08                                    CLE134 CLE164
     C**********         EVAL      KCCY        = FEFCCY                                CLE134 CLE164
     C**********         EVAL      KNONB       = %SUBST(PONS:01:02)                    CLE134 CLE164
     C**********         EVAL      KCNUM       = *BLANKS                               CLE134 CLE164
     C**********         CALL      'AONOSTR0'    PLIST1                                CLE134 CLE164
                                                                                              CLE134
     C**********         IF        @RTCD       = *BLANKS                               CLE134 CLE164
     C**********         EVAL      RPCNUM      = A7CUST                                CLE134 CLE164
     C**********         EVAL      RPACOD      = %DEC(A7ACCD:10:0)                     CLE134 CLE164
     C**********         EVAL      RPACSQ      = A7ACSN                                CLE134 CLE164
     C**********         EVAL      RPBRCA      = A7BRCD                                CLE134 CLE164
     C**********         EVAL      RPACCY      = FEFCCY                                CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      PSTM        = 05                                    CLE134 CLE164
     C**********         EVAL      RPCNUM      = %SUBST(PONS:01:06)                    CLE134 CLE164
     C**********         EVAL      RPACOD      = %DEC(%SUBST(PONS:07:10):10:0)         CLE134 CLE164
     C**********         EVAL      RPACSQ      = %DEC(%SUBST(PONS:17:02):02:0)         CLE134 CLE164
     C**********         EVAL      RPBRCA      = OMDB                                  CLE134 CLE164
     C**********         EVAL      RPACCY      = FEFCCY                                CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      PSTM        = 14                                    CLE134 CLE164
     C**********         MOVEL     PONS          KACNO                                 CLE134 CLE164
     C*****KACCNTL1      CHAIN(E)  ACCNTL1                                             CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(ACCNTL1)                                     CLE134 CLE164
     C**********         EVAL      RPCNUM      = CNUM                                  CLE134 CLE164
     C**********         EVAL      RPACOD      = ACOD                                  CLE134 CLE164
     C**********         EVAL      RPACSQ      = ACSQ                                  CLE134 CLE164
     C**********         EVAL      RPBRCA      = BRCA                                  CLE134 CLE164
     C**********         EVAL      RPACCY      = CCY                                   CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDSL                                                         CLE134 CLE164
                                                                                              CLE134
      ***-*Set*From*Fee*Receivable.***********************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         ELSE                                                          CLE134 CLE164
     C**********         SELECT                                                        CLE134 CLE164
     C**********         WHEN      RSTM        = 01            OR                      CLE134 CLE164
     C**********                   RSTM        = 08                                    CLE134 CLE164
     C**********         EVAL      KCCY        = FEFCCY                                CLE134 CLE164
     C**********         EVAL      KNONB       = %SUBST(RONS:01:02)                    CLE134 CLE164
     C**********         EVAL      KCNUM       = *BLANKS                               CLE134 CLE164
     C**********         CALL      'AONOSTR0'    PLIST1                                CLE134 CLE164
                                                                                              CLE134
     C**********         IF        @RTCD       = *BLANKS                               CLE134 CLE164
     C**********         EVAL      RPCNUM      = A7CUST                                CLE134 CLE164
     C**********         EVAL      RPACOD      = %DEC(A7ACCD:10:0)                     CLE134 CLE164
     C**********         EVAL      RPACSQ      = A7ACSN                                CLE134 CLE164
     C**********         EVAL      RPBRCA      = A7BRCD                                CLE134 CLE164
     C**********         EVAL      RPACCY      = FEFCCY                                CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      RSTM        = 05                                    CLE134 CLE164
     C**********         EVAL      RPCNUM      = %SUBST(RONS:01:06)                    CLE134 CLE164
     C**********         EVAL      RPACOD      = %DEC(%SUBST(RONS:07:10):10:0)         CLE134 CLE164
     C**********         EVAL      RPACSQ      = %DEC(%SUBST(RONS:17:02):02:0)         CLE134 CLE164
     C**********         EVAL      RPBRCA      = OSDB                                  CLE134 CLE164
     C**********         EVAL      RPACCY      = FEFCCY                                CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      RSTM        = 14                                    CLE134 CLE164
     C**********         MOVEL     RONS          KACNO                                 CLE134 CLE164
     C*****KACCNTL1      CHAIN(E)  ACCNTL1                                             CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(ACCNTL1)                                     CLE134 CLE164
     C**********         EVAL      RPCNUM      = CNUM                                  CLE134 CLE164
     C**********         EVAL      RPACOD      = ACOD                                  CLE134 CLE164
     C**********         EVAL      RPACSQ      = ACSQ                                  CLE134 CLE164
     C**********         EVAL      RPBRCA      = BRCA                                  CLE134 CLE164
     C**********         EVAL      RPACCY      = CCY                                   CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDSL                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***Set*Repayment*Priority.**************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPPCK1      = 99999                                 CLE134 CLE164
     C**********         EVAL      RPPCK2      = 99999                                 CLE134 CLE164
     C**********         EVAL      RPPCK3      = 99999                                 CLE134 CLE164
     C**********         EVAL      RPPCKO      = 99999                                 CLE134 CLE164
                                                                                              CLE134
     C**********         IF        FEFCOD     <> 0                                     CLE134 CLE164
     C**********         MOVE      FEFCOD        @FECD                                 CLE134 CLE164
     C**********         EXSR      xrFEE                                               CLE134 CLE164
                                                                                              CLE134
     C**********         IF        AUPCKO      > 0                                     CLE134 CLE164
     C**********         EVAL      RPPCK1      = AUPCKO                                CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         SELECT                                                        CLE134 CLE164
     C**********         WHEN      FEFACL     <> 0                                     CLE134 CLE164
     C**********         MOVE      FEFACL        @FACT                                 CLE134 262754
     C**********         MOVEL     FEFACL        @FACT                                 262754 CLE164
     C**********         EXSR      xrFACT                                              CLE134 CLE164
                                                                                              CLE134
     C**********         IF        AMPCKO      > 0                                     CLE134 CLE164
     C**********         EVAL      RPPCK2      = AMPCKO                                CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      FELOAN      = *BLANKS                             CLE134 MD020953
     C**********         WHEN      FELOAN <> *BLANKS                                 MD020953 CLE164
     C**********         EVAL      @LNTY       = FELTYP                                CLE134 CLE164
     C**********         EVAL      @LNST       = FESUTP                                CLE134 CLE164
     C**********         EVAL      @LNCL       = FECLAS                                CLE134 CLE164
     C**********         EXSR      xrLOAN                                              CLE134 CLE164
                                                                                              CLE134
     C**********         IF        AYPCKO      > 0                                     CLE134 CLE164
     C**********         EVAL      RPPCK2      = AYPCKO                                CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDSL                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         SELECT                                                        CLE134 CLE164
     C**********         WHEN      RPPCK1     <= RPPCK2        AND                     CLE134 CLE164
     C**********                   RPPCK1     <= RPPCK3                                CLE134 CLE164
     C**********         EVAL      RPPCKO      = RPPCK1                                CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      RPPCK2     <= RPPCK1        AND                     CLE134 CLE164
     C**********                   RPPCK2     <= RPPCK3                                CLE134 CLE164
     C**********         EVAL      RPPCKO      = RPPCK2                                CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      RPPCK3     <= RPPCK1        AND                     CLE134 CLE164
     C**********                   RPPCK3     <= RPPCK2                                CLE134 CLE164
     C**********         EVAL      RPPCKO      = RPPCK3                                CLE134 CLE164
     C**********         ENDSL                                                         CLE134 CLE164
                                                                                              CLE134
      ***Retrieve*Facility*Details.***********************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      Kf_CNUM     = FECNUM                                CLE134 CLE164
     C**********         MOVEL     FEFACL        Kf_FACT                               CLE134 CLE164
     C**********         MOVE      FEFACL        Kf_FCNO                               CLE134 CLE164
     C**********         EVAL      Kf_RCTP     = 'A'                                   CLE134 CLE164
     C*****KFCLTY        CHAIN(E)  FCLTY                                               CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(FCLTY)                                       CLE134 CLE164
     C**********         EVAL      RPFFCB      = f_BRCA                                CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***Set*Remaining*Fields.****************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPRECI      = FERECI                                CLE134 CLE164
     C**********         EVAL      RPSTDT      = FEPSTD                                CLE134 CLE164
                                                                                              CLE134
      ***Loan*********************************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPLNRF      = FELOAN                                CLE134 CLE164
     C**********         EVAL      RPLCBR      = *BLANKS                               CLE134 CLE164
     C**********         EVAL      RPLCNU      = *BLANKS                               CLE134 CLE164
     C**********         EVAL      RPLTYP      = FELTYP                                CLE134 CLE164
     C**********         EVAL      RPSUTP      = FESUTP                                CLE134 CLE164
     C**********         EVAL      RPLCLS      = FECLAS                                CLE134 CLE164
                                                                                              CLE134
      ***Fee**********************************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPFCBR      = KRPFCBR                               CLE134 CLE164
     C**********         EVAL      RPFCNM      = KRPFCNM                               CLE134 CLE164
     C**********         EVAL      RPFLNR      = KRPFLNR                               CLE134 CLE164
     C**********         EVAL      RPFACT      = KRPFACT                               CLE134 CLE164
     C**********         EVAL      RPFSE1      = KRPFSE1                               CLE134 CLE164
     C**********         EVAL      RPFCOD      = KRPFCOD                               CLE134 CLE164
                                                                                              CLE134
      ***Facility*****************************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPFFCN      = FECNUM                                CLE134 CLE164
     C**********         MOVEL     FEFACL        RPFFAC                                CLE134 CLE164
     C**********         MOVE      FEFACL        RPFFNO                                CLE134 CLE164
                                                                                              CLE134
      ***Misc*********************************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPFRNT      = FRNT                                  CLE134 CLE164
     C**********         EVAL      RPTMST      = STMP                                  CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPXRFI      = FEXRFI                                CLE134 CLE164
     C**********         EVAL      RPXRFN      = FEXRFN                                CLE134 CLE164
                                                                                              CLE134
     C**********         ENDSR                                                         CLE134 CLE164
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      **xeXRF*-*Evaluate*Extension*Reference*Index/Number.*************             CLE134 AR1022006
      *                                                               *                       CLE134
      **********This*routine*checks*whether*the*next*available*number**             CLE134 AR1022006
      **********is*truly*available.**It*also*resuses*earlier*sequence**             CLE134 AR1022006
      **********numbers*if*they***re*available*once*the*maximum*has****             CLE134 AR1022006
      **********been*exceeded.*****************************************             CLE134 AR1022006
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C*****xeXRF         BEGSR                                                      CLE134 AR1022006
                                                                                              CLE134
      ***Retrieve*Next*Available*Key                                                CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      KGLNARI     = 'FEE'                              CLE134 AR1022006
     C*****KAPNAPD       CHAIN(E)  GLAPNAPD                                         CLE134 AR1022006
                                                                                              CLE134
     C**********         IF        %ERROR                                           CLE134 AR1022006
     C******LOCK         IN        LDA                                              262754 AR1022006
     C**********         EVAL      DBFILE      = 'GLAPNAPD'                         CLE134 AR1022006
     C**********         EVAL      DBKEY       = KGLNARI                            CLE134 AR1022006
     C**********         EVAL      DBASE       = 210                                CLE134 AR1022006
     C**********         OUT       LDA                                              262754 AR1022006
     C**********         EXSR      *PSSR                                               CLE134 262754
     C**********         EXSR      srERR                                            262754 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
                                                                                              CLE134
     C**********         IF        NOT %FOUND(GLAPNAPD)                             CLE134 AR1022006
     C**********         EVAL      KspXRFN     = 1                                  CLE134 AR1022006
                                                                                              CLE134
     C**********         ELSE                                                       CLE134 AR1022006
     C**********         EVAL      KspXRFN     = GLNARN                             CLE134 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
                                                                                              CLE134
      ***-*Check*Key*Not*Already*Allocated.                                         CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      KspXRFI     = KGLNARI                            CLE134 AR1022006
     C*****KACMTLX       CHAIN(E)  RSACMTLX                                         CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      DSLoop      = 0                                  CLE134 AR1022006
                                                                                              CLE134
     C**********         DOW       %FOUND(RSACMTLX)                                 CLE134 AR1022006
     C**********         IF        KspXRFN     = 9999999999                         CLE134 AR1022006
     C**********         IF        DSLoop      = 0                                  CLE134 AR1022006
     C**********         EVAL      DSLoop      = 1                                  CLE134 AR1022006
     C**********         EVAL      KspXRFN     = 0                                  CLE134 AR1022006
                                                                                              CLE134
     C**********         ELSE                                                       CLE134 AR1022006
     C******LOCK         IN        LDA                                              262754 AR1022006
     C**********         EVAL      DBFILE      = 'RSACMTLX'                         CLE134 AR1022006
     C**********         EVAL      DBKEY       = 'NO AVAIL KEY'                     CLE134 AR1022006
     C**********         EVAL      DBASE       = 215                                CLE134 AR1022006
     C**********         OUT       LDA                                              262754 AR1022006
     C**********         EXSR      *PSSR                                               CLE134 262754
     C**********         EXSR      srERR                                            262754 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      KspXRFN    += 1                                  CLE134 AR1022006
     C*****KACMTLX       CHAIN(E)  RSACMTLX                                         CLE134 AR1022006
     C**********         ENDDO                                                      CLE134 AR1022006
                                                                                              CLE134
      ***-*Set*Extension*Reference.                                                 CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      FEXRFI      = KspXRFI                            CLE134 AR1022006
     C**********         EVAL      FEXRFN      = KspXRFN                            CLE134 AR1022006
                                                                                              CLE134
      ***-*Update*GLAPNAPD*with*the*Next*Sequence*Number.                           CLE134 AR1022006
                                                                                              CLE134
     C**********         IF        NOT %FOUND(GLAPNAPD)                             CLE134 AR1022006
     C**********         WRITE(E)  GLAPNAPF                                         CLE134 AR1022006
                                                                                              CLE134
     C**********         IF        NOT %FOUND(GLAPNAPD)                             CLE134 AR1022006
     C**********         WRITE(E)  GLAPNAPF                                         CLE134 AR1022006
                                                                                              CLE134
     C**********         ELSE                                                       CLE134 AR1022006
     C**********         UPDATE(E) GLAPNAPF                                         CLE134 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
                                                                                              CLE134
     C**********         ENDSR                                                      CLE134 AR1022006
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      * xrFACT - Retrieve Facility Details.                           *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     xrFACT        BEGSR                                                                CLE134
                                                                                              CLE134
      ** Retrieve Record.                                                                     CLE134
                                                                                              CLE134
     C                   CALLB     'AOFACTR0'                                                 CLE134
     C                   PARM      '*BLANKS'     @RTCD             7                          CLE134
     C                   PARM      '*KEY   '     @OPTN             7                          CLE134
     C                   PARM                    @FACT             3                          CLE134
     C     SDFACT        PARM      SDFACT        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS                                      CLE134
     C     *LOCK         IN        LDA                                                        262754
     C                   EVAL      DBFILE      = 'SDFACTPD'                                   CLE134
     C                   EVAL      DBKEY       = @FACT                                        CLE134
     C                   EVAL      DBASE       = 225                                          CLE134
     C                   OUT       LDA                                                        262754
     C**********         EXSR      *PSSR                                               CLE134 262754
     C                   EXSR      srERR                                                      262754
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      * xrLOAN - Retrieve Loan Details.                               *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     xrLOAN        BEGSR                                                                CLE134
                                                                                              CLE134
      ** Retrieve Record.                                                                     CLE134
                                                                                              CLE134
     C**********         CALL      'AOLOANR0'                                          CLE134 CLE164
     C                   CALL      'AOLOANR1'                                                 CLE164
     C                   PARM      *BLANKS       @RTCD             7                          CLE134
     C                   PARM      '*KEY   '     @OPTN             7                          CLE134
     C                   PARM                    @LNTY             2                          CLE134
     C                   PARM                    @LNST             2                          CLE134
     C                   PARM                    @LNCL             4                          CLE134
     C*****SDLOAN        PARM      SDLOAN        DSFDY                                 CLE134 CLE164
     C     SDLOAN        PARM      SDLOAN        DSSDY                                        CLE164
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS                                      CLE134
     C     *LOCK         IN        LDA                                                        262754
     C                   EVAL      DBFILE      = 'SDLOANPD'                                   CLE134
     C                   EVAL      DBKEY       = @LNST + @LNST + @LNCL                        CLE134
     C                   EVAL      DBASE       = 226                                          CLE134
     C                   OUT       LDA                                                        262754
     C**********         EXSR      *PSSR                                               CLE134 262754
     C                   EXSR      srERR                                                      262754
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      * xrFEE - Retrieve Fee Code Details.                            *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     xrFEE         BEGSR                                                                CLE134
                                                                                              CLE134
      ** Retrieve Record.                                                                     CLE134
                                                                                              CLE134
     C                   CALL      'AOFEER0'                                                  CLE134
     C                   PARM      '*BLANKS'     PRTCD                                        CLE134
     C                   PARM      '*KEY   '     POPTN                                        CLE134
     C                   PARM                    @FECD             2                          CLE134
     C     SDFEE         PARM      SDFEE         DSSDY                                        CLE134
                                                                                              CLE134
     C                   IF        PRTCD      <> *BLANKS                                      CLE134
     C     *LOCK         IN        LDA                                                        262754
     C                   EVAL      DBFILE      = 'SDFEEPD'                                    CLE134
     C                   EVAL      DBKEY       = @FECD                                        CLE134
     C                   EVAL      DBASE       = 227                                          CLE134
     C                   OUT       LDA                                                        262754
     C**********         EXSR      *PSSR                                               CLE134 262754
     C                   EXSR      srERR                                                      262754
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      /EJECT                                                                                  CSW208
      ****************************************************************                        CSW208
      * SRCHCT - Access SDCUSTPD File                                *                        CSW208
      * Called by: WRITER, AMENDR                                    *                        CSW208
      * Calls    : None                                              *                        CSW208
      ****************************************************************                        CSW208
     C     SRCHCT        BEGSR                                                                CSW208
      *                                                                                       CSW208
     C                   MOVEL     FECNUM        PCustNo                                      CSW208
      *                                                                                       CSW208
     C                   CALL      'AOCUSTR0'                                                 CSW208
     C                   PARM      *BLANKS       PRtCd                                        CSW208
     C                   PARM      '*KEY   '     POptn                                        CSW208
     C                   PARM                    PCustNo                                      CSW208
     C                   PARM      *BLANKS       PErrInf                                      CSW208
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSW208
      *                                                                                       CSW208
     C                   IF        PRtCd <> *BLANKS                                           CSW208
     C     *LOCK         IN        LDA                                                        CSW208
     C                   EVAL      DBKey = PCustNo                                            CSW208
     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSW208
     C                   EVAL      DBase = 21                                                 CSW208
     C                   EXSR      *PSSR                                                      CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   ENDSR                                                                CSW208
      ****************************************************************                        CSW208
      /EJECT                                                                                  CSW208
      ****************************************************************                        CSW208
      * SRLOAN - Access CLOAN File                                   *                        CSW208
      * Called by: WRITER, AMENDR                                    *                        CSW208
      * Calls    : None                                              *                        CSW208
      ****************************************************************                        CSW208
     C     SRLOAN        BEGSR                                                                CSW208
      *                                                                                       CSW208
     C                   EVAL      WCLRT = 'A'                                                CSW208
     C                   EVAL      WLOAN = FELOAN                                             CSW208
     C     KEY004        CHAIN     CLOAN                              89                      CSW208
      *                                                                                       CSW208
     C     *IN89         IFEQ      *ON                                                        CSW208
     C     *LOCK         IN        LDA                                                        CSW208
     C                   MOVE      WLOAN         DBKEY                          ************* CSW208
     C                   MOVEL     'CLOAN   '    DBFILE                         * DBERR 023 * CSW208
     C                   Z-ADD     23            DBASE                          ************* CSW208
     C                   OUT       LDA                                                        CSW208
     C                   EXSR      *PSSR                                                      CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   BITOFF    '0'           CNFI                                         CSW208
     C                   UPDATE    CLOANCLF                                                   CSW208
      *                                                                                       CSW208
     C                   ENDSR                                                                CSW208
      ****************************************************************                        CSW208
      /EJECT                                                                                  CSW208
      ****************************************************************                        CSW208
      * SRRLTX - Access the LTRIX header record                      *                        CSW208
      * Called by: WRITER, AMENDR                                    *                        CSW208
      * Calls    : None                                              *                        CSW208
      ****************************************************************                        CSW208
     C     SRRLTX        BEGSR                                                                CSW208
      *                                                                                       CSW208
      ** Chain to transaction header to test whether full                                     CSW208
      *                                                                                       CSW208
     C**********         Z-ADD     1             LXRRN                               CSW208 AR322732
     C*****LXRRN         CHAIN(N)  LTRIX                              89             CSW208 AR322732
     C**********         Z-ADD     RRNAD         WRRNA                               CSW208 AR322732
      *                                                                                       CSW208
     C******IN89         IFEQ      *ON                                               CSW208 AR322732
     C*****RRNAD         ORGT      FLSZD                                             CSW208 AR322732
     C******LOCK         IN        LDA                                               CSW208 AR322732
     C**********         MOVE      LXRRN         DBKEY                          *****CSW208 AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         * DBECSW208 AR322732
     C**********         Z-ADD     22            DBASE                          *****CSW208 AR322732
     C**********         OUT       LDA                                               CSW208 AR322732
     C**********         EXSR      *PSSR                                             CSW208 AR322732
     C**********         ENDIF                                                       CSW208 AR322732
      *                                                                                       CSW208
     C                   ENDSR                                                                CSW208
      ****************************************************************                        CSW208
      /EJECT                                                                                  CSW208
      *****************************************************************                       CSW208
      * SRWLTX - Write an LTRIX record                                *                       CSW208
      * Called by: WRITER, AMENDR                                     *                       CSW208
      * Calls    : None                                               *                       CSW208
      *****************************************************************                       CSW208
     C     SRWLTX        BEGSR                                                                CSW208
      *                                                                                       CSW208
     C**********         MOVE      RRNAD         LXRRN                               CSW208 AR322732
     C**********         MOVE      '1'           TXERR                               CSW208 AR322732
      *                                                                                       CSW208
     C*****LXRRN         CHAIN     LTRIX                              8887           CSW208 AR322732
      *                                                                                       CSW208
     C**********         DOW       *IN87 = *ON  AND                                  CSW208 AR322732
     C**********                   TXERR = '1'  OR                                   CSW208 AR322732
     C**********                   RECID <> *BLANKS                                  CSW208 AR322732
      *                                                                                       CSW208
     C**********         Z-ADD     TXSTS         SVSTS                               CSW208 AR322732
     C**********         UNLOCK    LTRIX                                             CSW208 AR322732
      *                                                                                       CSW208
     C**********         IF        SVSTS =  1218  OR                                 CSW208 AR322732
     C**********                   *IN87 =  *OFF  AND                                CSW208 AR322732
     C**********                   RECID <> *BLANKS                                  CSW208 AR322732
      *                                                                                       CSW208
     C**********         EXSR      SRRLTX                                            CSW208 AR322732
     C**********         MOVE      RRNAD         LXRRN                               CSW208 AR322732
     C*****LXRRN         CHAIN     LTRIX                              8887           CSW208 AR322732
      *                                                                                       CSW208
     C**********         ELSE                                                        CSW208 AR322732
     C**********         MOVE      '0'           TXERR                               CSW208 AR322732
     C**********         ENDIF                                                       CSW208 AR322732
      *                                                                                       CSW208
     C**********         ENDDO                                                       CSW208 AR322732
      *                                                                                       CSW208
     C**********         IF        TXERR = '0'                                       CSW208 AR322732
     C******LOCK         IN        LDA                                               CSW208 AR322732
     C**********         MOVE      LXRRN         DBKEY                          *****CSW208 AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         * DBECSW208 AR322732
     C**********         Z-ADD     53            DBASE                          *****CSW208 AR322732
     C**********         OUT       LDA                                               CSW208 AR322732
     C**********         EXSR      *PSSR                                             CSW208 AR322732
     C**********         ENDIF                                                       CSW208 AR322732
      *                                                                                       CSW208
     C                   IF        FELCHT = 'X'                                               CSW208
     C                   EVAL      CHTPD  = 'I'                                               CSW208
     C                   ELSE                                                                 CSW208
     C                   EVAL      CHTPD  = FELCHT                                            CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   EVAL      RECID  = 'D'                                               CSW208
     C                   EVAL      RCDTD  = 'L'                                               CSW208
     C**********         Z-ADD     LNRF          LNRFD                               CSW208 AR322732
     C**********         Z-ADD     VDAT          VDATD                               CSW208 AR322732
     C**********         Z-ADD     FEFSEQ        LASND                               CSW208 AR322732
     C                   MOVEL     LNRF          LNRFD             6                          CLE148
     C                   Z-ADD     VDAT          VDATD             5 0                      AR322732
     C                   Z-ADD     FEFSEQ        LASND             3 0                      AR322732
     C                   EVAL      CNRQD  = 'Y'                                               CSW208
     C                   EVAL      CNPRD  = 'N'                                               CSW208
     C                   EVAL      REPRD  = 'N'                                               CSW208
     C                   Z-ADD     1             RRLAD                                        CSW208
     C                   EVAL      LADID  = 'N'                                               CSW208
     C                   Z-ADD     0             PRI1D                                        CSW208
     C                   Z-ADD     0             PRI2D                                        CSW208
     C                   Z-ADD     0             PRI3D                                        CSW208
     C                   Z-ADD     0             PRI4D                                        CSW208
     C                   EVAL      BRCAD  = BRCA                                              CSW208
     C**********         Z-ADD     RRNAD         RRNTD                               CSW208 AR322732
     C                   EXCEPT    TRXDTL                                                     CSW208
      *                                                                                       CSW208
     C**********         Z-ADD     1             LXRRN                               CSW208 AR322732
     C*****LXRRN         CHAIN     LTRIX                              89             CSW208 AR322732
      *                                                                                       CSW208
     C******IN89         IFEQ      *ON                                               CSW208 AR322732
     C******LOCK         IN        LDA                                               CSW208 AR322732
     C**********         MOVE      LXRRN         DBKEY                          *****CSW208 AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         * DBECSW208 AR322732
     C**********         Z-ADD     22            DBASE                          *****CSW208 AR322732
     C**********         OUT       LDA                                               CSW208 AR322732
     C**********         EXSR      *PSSR                                             CSW208 AR322732
     C**********         ENDIF                                                       CSW208 AR322732
      *                                                                                       CSW208
     C**********         ADD       1             NORED                               CSW208 AR322732
     C**********         ADD       1             RRNAD                               CSW208 AR322732
     C**********         ADD       1             NLNRD                               CSW208 AR322732
     C**********         EXCEPT    TRXHDR                                            CSW208 AR322732
      *                                                                                       CSW208
     C                   ENDSR                                                                CSW208
      *****************************************************************                       CSW208
      /EJECT
      *****************************************************************
      *  SEQGEN - Subroutine to generate fee sequence number          *
      *****************************************************************
     C     SEQGEN        BEGSR                                                  *** SEQGEN ***
      *
     C                   Z-ADD     99            WFSEQ
      *
      **  Prevent pick up of details from previous fee
     C     KEY002        SETGT     LEFEEDF1
     C     KEY005        READPE    LEFEEDF1                               78
      *
     C     *IN78         IFEQ      '1'
     C                   MOVE      '01'          FEFSEQ
      *
     C                   ELSE
      *
      **  Release File
     C                   UPDATE    LEFEEDF1
      *
     C     WCNUM         IFEQ      FECNUM
     C     WLOAN         ANDEQ     FELOAN
     C     WFAC05        ANDEQ     FEFACL
     C                   ADD       1             FEFSEQ
      *
     C                   ELSE
      *
      ** There are no existing fee records with the key fields input so
      ** put original values back in key fields ready for file update
      ** and allocate a fee sequence no. of 01.
      *
     C                   MOVE      WCNUM         FECNUM
     C**********         Z-ADD     WLOAN         FELOAN                                       CLE148
     C                   MOVEL     WLOAN         FELOAN                                       CLE148
     C                   Z-ADD     WFAC05        FEFACL
     C                   MOVE      '01'          FEFSEQ
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** No need to check fee sequence allocation on LEFHST.                                  258597
      *****************************************************************                       258597
      ***Having*checked*the*live*fees*the*matured*fees*need*to*be******                       258597
      ***checked*in*the*same*way***************************************                       258597
      *****************************************************************                       258597
     C*****KEY012        SETGT     LEFHSTF                                                    258597
     C*****KEY015        READPE    LEFHSTF                                78                  258597
      **********                                                                              258597
     C******IN78         IFEQ      '0'                                                        258597
      **********                                                                              258597
     C*****WCNUM         IFEQ      HICNUM                                                     258597
     C*****WLOAN         ANDEQ     HILNRF                                                     258597
     C*****WFAC05        ANDEQ     HIFACL                                                     258597
     C**********         ADD       1             HIFSEQ                                       258597
      **********                                                                              258597
     C**********         ELSE                                                                 258597
     C**********         MOVE      '01'          HIFSEQ                                       258597
      **********                                                                              258597
     C**********         ENDIF                                                                258597
     C**********         ENDIF                                                                258597
      **********                                                                              258597
      ****Store*allocated sequence number for output                                          258597
     C*****FEFSEQ        IFGT      HIFSEQ                                                     258597
     C**********         MOVE      FEFSEQ        @ALSEQ            2                          258597
     C**********         ELSE                                                                 258597
     C**********         MOVE      HIFSEQ        @ALSEQ            2                          258597
     C**********         ENDIF                                                                258597
      **********                                                                              258597
     C**********         MOVE      @ALSEQ        FEFSEQ                                       258597
      *                                                                                       258597
      ** If all fee sequence (99) has been allocated, reuse fee                               258597
      ** sequence by searching  for gap starting from 01.                                     258597
      *                                                                                       258597
     C     FEFSEQ        IFEQ      0                                                          258597
      *                                                                                       258597
     C                   OPEN      LEFEEDLU                                                   258597
     C                   Z-ADD     01            WFSEQ                                        258597
     C                   MOVE      '0'           *IN15                                        258597
     C     *IN15         DOWEQ     '0'                                                        258597
     C     WFSEQ         ANDGT     0                                                          258597
     C     KEY012        CHAIN     LEFEEDLU                           15                      258597
     C     *IN15         IFEQ      '0'                                                        258597
     C                   ADD       1             WFSEQ                                        258597
     C                   ENDIF                                                                258597
     C                   ENDDO                                                                258597
     C                   CLOSE     LEFEEDLU                                                   258597
      *                                                                                       258597
      ** If no gap found, send error message 'Insertion of new fee                            258597
      ** not possible' (all 99 fees has been actively allocated).                             258597
      *                                                                                       258597
     C     *IN15         IFEQ      '1'                                                        258597
     C                   MOVE      WFSEQ         FEFSEQ                                       258597
     C                   ELSE                                                                 258597
     C                   ADD       1             Ix                                           258597
     C                   MOVEL     'DDFSEQ      'FldNameArr(Ix)                               258597
     C                   MOVEL     '5045819'     MsgIdArr(Ix)                                 258597
     C                   MOVEL     '*RECUPD   '  @@RTCD                                       258597
     C                   GOTO      ESEQGEN                                                    258597
     C                   ENDIF                                                                258597
      *                                                                                       258597
     C                   ENDIF                                                                258597
     C                   MOVE      FEFSEQ        @ALSEQ            2                          258597
      *
     C**********         ENDSR                                                                258597
     C     ESEQGEN       ENDSR                                                                258597
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSWRI  -  Set SWIFT Message Regeneration Indicator           *
      *****************************************************************
     C     SRSWRI        BEGSR
      *
      ** Action Code is Insert
     C     VFLCHT        IFEQ      'I'
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFEAU        ANDEQ     'N'
     C                   MOVE      *BLANK        FESWRI
     C                   ELSE
     C                   MOVE      'I'           FESWRI
     C                   ENDIF
     C                   ENDIF
      *
      ** Action Code is Delete
     C     VFLCHT        IFEQ      'D'
      *
      ** Start, Payment, or End Pay/Receive Telex Indicator is Yes
     C     FESPTI        IFEQ      'Y'
     C     FEPPTI        OREQ      'Y'
     C     FEEPTI        OREQ      'Y'
     C                   MOVE      'R'           FESWRI
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Action Code is Amend
     C     VFLCHT        IFEQ      'A'
     C     FESWRI        ANDNE     'I'
     C     FESWRI        ANDNE     'B'
     C     FESWRI        ANDNE     'H'
      *
      ** Set Telex Notice Date
     C                   EXSR      SRTXDT
      *
      ** If the Fee is a non-calculated Fee
     C     FECALT        IFEQ      *BLANKS
      *
     C** If the Fee is a Bullet Fee or Amortised Fee
     C     FEPYON        IFEQ      *BLANKS
     C     FEPYON        OREQ      'S'
      *
     C                   MOVE      'N'           WAMDED            1
      *
      ** The Start Date has been Amended
     C     VFPSTD        IFNE      FEPSTD
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
      *
      ** The Amount has been Amended
     C     VFFAMT        IFNE      FEFAMT
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
      *
      ** The Confirm Indicator has been Amended
     C     VFAUTO        IFNE      *BLANKS
     C     VFAUTO        ANDNE     FEAUTO
     C     VFAUTO        OREQ      *BLANKS
     C     'N'           ANDNE     FEAUTO
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
      *
      ** The Settlement Instructions have been Amended
     C     VFRSTM        IFNE      RSTM
     C     VFRONS        ORNE      RONS
     C     VFRIBN        ORNE      RIBN
     C     VFRIBA        ORNE      RIBA
     C     VFROBN        ORNE      ROBN
     C     VFROCN        ORNE      ROCN
     C     VFPSTM        ORNE      PSTM
     C     VFPONS        ORNE      PONS
     C     VFPIBN        ORNE      PIBN
     C     VFPIBA        ORNE      PIBA
     C     VFPOBN        ORNE      POBN
     C     VFPOCN        ORNE      POCN
     C     VFRCRN        ORNE      RCRN
     C     VFRCRA        ORNE      RCRA
     C     VFAWBN        ORNE      AWBN
     C     VFAWBA        ORNE      AWBA
     C     VFBENN        ORNE      BENN
     C     VFBENA        ORNE      BENA
     C     VFDTP1        ORNE      DTP1
     C     VFDTP2        ORNE      DTP2
     C     VFDTP3        ORNE      DTP3
     C     VFDTP4        ORNE      DTP4
     C     VFRVNO        ORNE      RVNO
     C     VFDCHG        ORNE      DCHG
     C     VFBTB1        ORNE      BTB1
     C     VFBTB2        ORNE      BTB2
     C     VFBTB3        ORNE      BTB3
     C     VFBTB4        ORNE      BTB4
     C     VFBTB5        ORNE      BTB5
     C     VFBTB6        ORNE      BTB6
     C     VFCVMR        ORNE      CVMR
     C     VFOSDB        ORNE      OSDB
     C     VFOMDB        ORNE      OMDB
     C                   MOVE      'Y'           WAMDED
     C                   ELSE
 
     C*****CEU004        IFEQ      'Y'                                                        260783
     C     VFSCCY        IFNE      FESCCY
     C     VFICCY        ORNE      FEICCY
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
     C**********         ENDIF                                                                260783
     C                   ENDIF
      *
     C     WAMDED        IFEQ      'Y'
      *
     C     FEPSTD        IFGE      BJRDNB
     C     FESPTI        IFEQ      'Y'
     C     VFPSTD        ORLE      TXDT
     C     FEPSTD        ORLE      TXDT
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFEAU        ANDEQ     'N'
     C                   MOVE      'A'           FESWRI
     C                   ELSE
     C                   MOVE      'B'           FESWRI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C** The Fee is a Accrued Fee
     C     FEPYON        IFEQ      'E'
      *
     C                   MOVE      'N'           WAMDED
      *
      ** The End Date has been Amended
     C     VFPEND        IFNE      FEPEND
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
      *
      ** The Amount has been Amended
     C     VFFAMT        IFNE      FEFAMT
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
      *
      ** The Confirm Indicator has been Amended
     C     VFAUTO        IFNE      *BLANKS
     C     VFAUTO        ANDNE     FEAUTO
     C     VFAUTO        OREQ      *BLANKS
     C     'N'           ANDNE     FEAUTO
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
      *
      ** The Settlement Instructions have been Amended
     C     VFRSTM        IFNE      RSTM
     C     VFRONS        ORNE      RONS
     C     VFRIBN        ORNE      RIBN
     C     VFRIBA        ORNE      RIBA
     C     VFROBN        ORNE      ROBN
     C     VFROCN        ORNE      ROCN
     C     VFPSTM        ORNE      PSTM
     C     VFPONS        ORNE      PONS
     C     VFPIBN        ORNE      PIBN
     C     VFPIBA        ORNE      PIBA
     C     VFPOBN        ORNE      POBN
     C     VFPOCN        ORNE      POCN
     C     VFRCRN        ORNE      RCRN
     C     VFRCRA        ORNE      RCRA
     C     VFAWBN        ORNE      AWBN
     C     VFAWBA        ORNE      AWBA
     C     VFBENN        ORNE      BENN
     C     VFBENA        ORNE      BENA
     C     VFDTP1        ORNE      DTP1
     C     VFDTP2        ORNE      DTP2
     C     VFDTP3        ORNE      DTP3
     C     VFDTP4        ORNE      DTP4
     C     VFRVNO        ORNE      RVNO
     C     VFDCHG        ORNE      DCHG
     C     VFBTB1        ORNE      BTB1
     C     VFBTB2        ORNE      BTB2
     C     VFBTB3        ORNE      BTB3
     C     VFBTB4        ORNE      BTB4
     C     VFBTB5        ORNE      BTB5
     C     VFBTB6        ORNE      BTB6
     C     VFCVMR        ORNE      CVMR
     C     VFOSDB        ORNE      OSDB
     C     VFOMDB        ORNE      OMDB
     C                   MOVE      'Y'           WAMDED
     C                   ELSE
 
     C*****CEU004        IFEQ      'Y'                                                        260783
     C     VFSCCY        IFNE      FESCCY
     C     VFICCY        ORNE      FEICCY
     C                   MOVE      'Y'           WAMDED
     C                   ENDIF
     C**********         ENDIF                                                                260783
     C                   ENDIF
      *
     C     WAMDED        IFEQ      'Y'
      *
     C     FEPEND        IFGE      BJRDNB
     C     FEEPTI        IFEQ      'Y'
     C     VFPEND        ORLE      TXDT
     C     FEPEND        ORLE      TXDT
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFEAU        ANDEQ     'N'
     C                   MOVE      'A'           FESWRI
     C                   ELSE
     C                   MOVE      'B'           FESWRI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** The Fee is a calculated Fee (FECALT <> BLANK)
     C                   ELSE
      *
      ** The Fee is a Confirmed Fee
     C     FEAUTO        IFEQ      'Y'
                                                                                              CLE134
     C     FEAUTO        OREQ      'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *
      ** The Payment Pay/Receive Telex Indicator is Yes and Payment on
      ** is Next
     C     FEPPTI        IFEQ      'Y'
     C     FEPYON        ANDEQ     'N'
      *
      ** The next Payment Date has been Amended
     C     VFNPYD        IFNE      FENPYD
      *
     C     VFNPYD        IFLE      TXDT
     C     FENPYD        ORLE      TXDT
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFEAU        ANDEQ     'N'
     C                   MOVE      'A'           FESWRI
     C                   ELSE
     C                   MOVE      'B'           FESWRI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** The Payment Pay/Receive Telex Indicator is blank and Payment
      ** on is Next
     C     FEPPTI        IFEQ      *BLANKS
     C     FEPYON        ANDEQ     'N'
      *
     C     VFNPYD        IFLE      TXDT
     C     FENPYD        ORLE      TXDT
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFEAU        ANDEQ     'N'
     C                   MOVE      'G'           FESWRI
     C                   ELSE
     C                   MOVE      'H'           FESWRI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** The End Pay/Receive Telex Indicator is Yes and Payment on
      ** is End.
     C     FEEPTI        IFEQ      'Y'
     C     FEPYON        ANDEQ     'E'
      *
      ** The End Date has been Amended
     C     VFPEND        IFNE      FEPEND
      *
     C     VFPEND        IFLE      TXDT
     C     FEPEND        ORLE      TXDT
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFEAU        ANDEQ     'N'
     C                   MOVE      'A'           FESWRI
     C                   ELSE
     C                   MOVE      'B'           FESWRI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** The End Pay/Receive Telex Indicator is Blank and Payment on
      ** is End.
     C     FEEPTI        IFEQ      *BLANKS
     C     FEPYON        ANDEQ     'E'
      *
      *
     C     VFPEND        IFLE      TXDT
     C     FEPEND        ORLE      TXDT
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFEAU        ANDEQ     'N'
     C                   MOVE      'G'           FESWRI
     C                   ELSE
     C                   MOVE      'H'           FESWRI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** The confirm Indicator has been amended
     C     VFAUTO        IFNE      *BLANK
     C     VFAUTO        ANDNE     FEAUTO
     C     VFAUTO        OREQ      *BLANK
     C     'N'           ANDNE     FEAUTO
      *
     C     FEPPTI        IFEQ      'Y'
     C     FEPYON        ANDEQ     'N'
     C     VFNPYD        ORLE      TXDT
     C     FEPYON        ANDEQ     'N'
     C     FENPYD        ORLE      TXDT
     C     FEPYON        ANDEQ     'N'
     C     FEEPTI        OREQ      'Y'
     C     FEPYON        ANDEQ     'E'
     C     VFPEND        ORLE      TXDT
     C     FEPYON        ANDEQ     'E'
     C     FEPEND        ORLE      TXDT
     C     FEPYON        ANDEQ     'E'
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFEAU        ANDEQ     'N'
     C                   MOVE      'A'           FESWRI
     C                   ELSE
     C                   MOVE      'B'           FESWRI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Action Code is Authorise
     C     VFLCHT        IFEQ      'X'
      *
     C     FESWRI        IFEQ      'I'
     C                   MOVE      *BLANK        FESWRI
     C                   ENDIF
      *
     C     FESWRI        IFEQ      'B'
     C                   MOVE      'A'           FESWRI
     C                   ENDIF
      *
     C     FESWRI        IFEQ      'H'
     C                   MOVE      'G'           FESWRI
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD030700
      *****************************************************************                     MD030700
      *                                                               *                     MD030700
      *  SRNPAMD - Write to fee file when next pay date is amended to *                     MD030700
      *            today or less.                                     *                     MD030700
      *                                                               *                     MD030700
      *  Called By: AMENDR                                            *                     MD030700
      *  Calls    : None                                              *                     MD030700
      *                                                               *                     MD030700
      *****************************************************************                     MD030700
     C     SRNPAMD       BEGSR                                                              MD030700
                                                                                            MD030700
     C                   EVAL      FFCNUM = FECNUM                                          MD030700
     C                   EVAL      FFFACL = FEFACL                                          MD030700
     C                   EVAL      FFLOAN = FELOAN                                          MD030700
     C                   EVAL      FFFSEQ = FEFSEQ                                          MD030700
     C     KFNPD         CHAIN     LEFEDNL0                                                 MD030700
                                                                                            MD030700
     C                   IF        %FOUND(LEFEDNL0)                                         MD030700
                                                                                            MD030700
      ** Delete record when the update is changing the record to                            MD030700
      ** a value higher than rundate.                                                       MD030700
                                                                                            MD030700
     C                   IF        VFNPYD > BJRDNB                                          MD030700
     C                   DELETE    LEFEDNL0                                                 MD030700
     C                   ELSE                                                               MD030700
     C                   EVAL      FFANPD = VFNPYD                                          MD030700
     C                   UPDATE    LEFEDNPF                                                 MD030700
     C                   ENDIF                                                              MD030700
                                                                                            MD030700
      ** If not found.                                                                      MD030700
                                                                                            MD030700
     C                   ELSE                                                               MD030700
                                                                                            MD030700
     C                   IF        FENPYD <> VFNPYD                                         MD030700
     C                             AND VFNPYD <= BJRDNB                                     MD030700
     C                   EVAL      FFBNPD = FENPYD                                          MD030700
     C                   EVAL      FFANPD = VFNPYD                                          MD030700
     C                   WRITE     LEFEDNPF                                                 MD030700
     C                   ENDIF                                                              MD030700
                                                                                            MD030700
     C                   ENDIF                                                              MD030700
                                                                                            MD030700
     C                   ENDSR                                                              MD030700
      *****************************************************************                     MD030700
      /EJECT
      *****************************************************************
      *  TRSSTF - To convert Valid file fields to file                *
      *****************************************************************
     C     TRSSTF        BEGSR
      *
     C                   Z-ADD     VFPEND        FEPEND
     C                   Z-ADD     VFFAMT        FEFAMT
 
     C     VFPTFI        IFEQ      'P'
     C     VFPTFI        OREQ      'S'                                                        CLE106
     C     VFPTFI        OREQ      'R'                                                        CLE106
     C                   MOVE      VFPSTM        FESTTL
     C                   MOVEL     VFPONS        FEOURS
     C                   MOVEL     VFPIBN        FETHER
     C                   MOVE      VFOMDB        FEOSBR
     C                   MOVE      VFOMDB        OMDB
     C                   ENDIF
      *
     C     VFPTFI        IFEQ      *BLANK
     C                   MOVE      VFRSTM        FESTTL
     C                   MOVEL     VFRONS        FEOURS
     C                   MOVEL     VFRIBN        FETHER
     C                   MOVE      VFOSDB        FEOSBR
     C                   MOVE      VFOSDB        OSDB
     C                   ENDIF
      *
     C                   MOVE      VFFCOD        FEFCOD
     C                   MOVE      VFFCCY        FEFCCY
     C                   Z-ADD     VFPSTD        FEPSTD
     C                   MOVE      VFPYON        FEPYON
     C                   MOVE      FEAUTO        WFEAUT            1                          223922
      *
     C     VFAUTO        IFEQ      *BLANKS
     C                   MOVE      'N'           FEAUTO
     C                   ELSE
     C                   MOVE      VFAUTO        FEAUTO
     C                   ENDIF
      *
     C                   MOVE      VFCALT        FECALT
     C                   Z-ADD     VFFRT1        FEFRT1
     C                   Z-ADD     VFFRT2        FEFRT2
     C                   Z-ADD     VFFRT3        FEFRT3
     C                   Z-ADD     VFFRT4        FEFRT4
     C                   Z-ADD     VFFRT5        FEFRT5
     C                   Z-ADD     VFAMT1        FEAMT1
     C                   Z-ADD     VFAMT2        FEAMT2
     C                   Z-ADD     VFAMT3        FEAMT3
     C                   Z-ADD     VFAMT4        FEAMT4
     C                   Z-ADD     VFAMT5        FEAMT5
     C                   Z-ADD     VFCALC        FECALC
     C                   Z-ADD     VFERAT        FEERAT
     C                   MOVE      VFMDIN        FEMDIN
     C                   Z-ADD     VFNPYD        FENPYD
     C                   MOVE      VFFREQ        FEFREQ
     C                   Z-ADD     VFDYIM        FEDYIM
     C                   MOVE      VFPIND        FEPIND
     C                   IF        VFPIND = *BLANKS                                          BUG8629
     C                   IF        FECALT = '03'                                             BUG8629
     C                             OR FECALT = '06'                                          BUG8629
     C                             OR FECALT = '13'                                          BUG8629
     C                             OR FECALT = '16'                                          BUG8629
     C                             OR FECALT = '21'                                          BUG8629
     C                             OR FECALT = '22'                                          BUG8629
     C                   MOVE      'A'           FEPIND                                      BUG8629
     C                   ENDIF                                                               BUG8629
     C                   ENDIF                                                               BUG8629
     C                   MOVE      VFSHFI        SHFI
     C                   Z-ADD     VFAMTO        FEAMTO
     C                   Z-ADD     VFAMTS        FEAMTS
     C                   MOVE      VFPRFC        FEPRFC                                       223922
     C                   MOVE      VFMASF        FEMASF                                       CLE106
                                                                                              CAS019
      ** If CAS016 is *ON move new fields introduced by CAS019 feature to file                CAS019
      *                                                                                       CAS019
                                                                                              CAS019
     C                   IF        (CAS016 = 'Y')                                             CAS019
     C                   EVAL      FESAMT = VFSAMT                                            CAS019
     C                   EVAL      FEAMRI = VFAMRI                                            CAS019
     C                   EVAL      FESTPD = VFSTPD                                            CAS019
     C                   EVAL      FEENPD = VFENPD                                            CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CLE139
     C                   EVAL      FECAPI = VFCAPI                                            CLE139
      *
      ** If Past Due Processing;                                                              CLE134
      ** - Set Miscellaneous Values.                                                          CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
                                                                                              CLE134
     C                   EVAL      FEAUT2      = FEAUTO                                       CLE134
                                                                                              CLE134
     C                   EVAL      FEPLNR      = VFEPLNR                                      CLE134
                                                                                              CLE134
      ** - Set Reporting Values.                                                              CLE134
                                                                                              CLE134
     C                   IF        FERIDT     <> VFERIDT       AND                            CLE134
     C                             FERIDT     <> 0                                            CLE134
     C                   EVAL      FERIDC     += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        FERCAT     <> VFERCAT       AND                            CLE134
     C                             FERCAT     <> 0                                            CLE134
     C                   EVAL      FERCAC     += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      FERIDT      = VFERIDT                                      CLE134
     C                   EVAL      FERCSD      = VFERIDT                                      CLE134
     C                   EVAL      FERCAT      = VFERCAT                                      CLE134
                                                                                              CLE134
     C                   IF        FERCAT      > 1                                            CLE134
     C                   IF        DSRCN(FERCAT-1) > 0         AND                            CLE134
     C                             DSRCN(FERCAT-1) < 999                                      CLE134
     C                   EVAL      FERCSD     += DSRCN(FERCAT-1)                              CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      FERCDY      = DSRCE(FERCAT)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** - Set Basel II Values.                                                               CLE134
                                                                                              CLE134
     C                   IF        FEBIDT     <> VFEBIDT       AND                            CLE134
     C                             FEBIDT     <> 0                                            CLE134
     C                   EVAL      FEBIDC     += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        FEBCAT     <> VFEBCAT       AND                            CLE134
     C                             FEBCAT     <> 0                                            CLE134
     C                   EVAL      FEBCAC     += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      FEBIDT      = VFEBIDT                                      CLE134
     C                   EVAL      FEBCSD      = VFEBIDT                                      CLE134
     C                   EVAL      FEBCAT      = VFEBCAT                                      CLE134
                                                                                              CLE134
     C                   IF        FEBCAT      > 1                                            CLE134
     C                   IF        DSBCN(FEBCAT-1) > 0         AND                            CLE134
     C                             DSBCN(FEBCAT-1) < 999                                      CLE134
     C                   EVAL      FEBCSD     += DSBCN(FEBCAT-1)                              CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      FEBCDY      = DSBCE(FEBCAT)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** - Set Suspense Values.                                                               CLE134
                                                                                              CLE134
     C                   EXSR      SRFSFA                                                   AR744771
                                                                                            AR744771
     C                   EVAL      FEFSFA      = VFEFSFA                                      CLE134
     C                   EVAL      FESFA       = VFESFA                                       CLE134
     C                   EVAL      FESFAM      = VFESFAM                                      CLE134
     C                   EVAL      FESFP       = VFESFP                                       CLE134
     C                   EVAL      FESFPM      = VFESFPM                                      CLE134
     C                   EVAL      FEFPPA      = VFEFPPA                                      CLE134
     C                   EVAL      FEPSIN      = VFEPSIN                                      CLE134
     C                   EVAL      FEPSLM      = VFEPSLM                                      CLE134
     C                   EVAL      FEFEMC      = VFEFEMC                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTRL- UPDATE THE FEE FILE TRAILER                          *
     C*                                                              *
     C****************************************************************
     C     UPDTRL        BEGSR
      *
     C*****MTHREAD       IFEQ      'N'                                             MD024342 MD025467
     C*****1****         SETLL     LEFEEZ                                                   MD025467
     C**********         READ      LEFEEZ                                 78                MD025467
      **********************************************************************                MD025467
     C******IN78         IFEQ      '1'                                                      MD025467
     C**********         MOVEL     'LEFEEZ'      DBFILE                         ************MD025467
     C**********         MOVEL     1             DBKEY                          * DBERR 13 *MD025467
     C**********         Z-ADD     13            DBASE                          ************MD025467
     C**********         EXSR      *PSSR                                                    MD025467
     C**********         ENDIF                                                              MD025467
     C**********         ENDIF                                                     MD024342 MD025467
      **********************************************************************       MD024342 MD025467
     C**********         IF        MTHREAD = 'Y'                                   MD024342 MD025467
     C                   EXSR      Initialise                                               MD024342
     C**********         ENDIF                                                     MD024342 MD025467
                                                                                           AR750543A
     C                   IF        VFCAPI = 'Y'                                            AR750543A
     C     VFLCHT        IFEQ      'I'                                                     AR750543A
     C                   ADD       1             CANINT                                    AR750543A
     C                   ADD       1             CANORE                                    AR750543A
     C                   ENDIF                                                             AR750543A
      *                                                                                    AR750543A
     C     VFLCHT        IFEQ      'A'                                                     AR750543A
     C                   ADD       1             CANAMD                                    AR750543A
     C                   ENDIF                                                             AR750543A
      *                                                                                    AR750543A
     C     VFLCHT        IFEQ      'D'                                                     AR750543A
     C                   ADD       1             CANDEL                                    AR750543A
     C                   ENDIF                                                             AR750543A
     C                   ELSE                                                              AR750543A
      *
     C     VFLCHT        IFEQ      'I'
     C                   ADD       1             FENINT
     C                   ADD       1             FENORE
     C                   END
      *
     C     VFLCHT        IFEQ      'A'
     C                   ADD       1             FENAMD
     C                   END
      *
     C     VFLCHT        IFEQ      'D'
     C                   ADD       1             FENDEL
     C                   END
                                                                                           AR750543A
     C                   ENDIF                                                             AR750543A
      *
     C**********         IF        MTHREAD = 'N'                                   MD024342 MD025467
     C**********         UPDATE    LEFEEZF                                                  MD025467
     C**********         ELSE                                                      MD024342 MD025467
     C                   MOVEL     'D'           FERECI                                     MD024342
     C**********         WRITE     LEFEEZF                                        MD024342 MD024342B
     C**********         WRITE     LEFEEZFX                                       MD024342B MD025467
     C**********         ENDIF                                                              MD024342
     C                   WRITE     LEFEEZF                                                  MD025467
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUSHD  -  Update Shadow Record                               *
      *****************************************************************
     C     SRUSHD        BEGSR
      *
      ** Do On-line updates
     C     VFLCHT        IFEQ      'I'
     C     VFLCHT        OREQ      'A'
     C     VFLCHT        OREQ      'D'
     C     VFLCHT        OREQ      'X'                                                       BUG3071
     C     VFPTFI        IFNE      'I'
      *
      *  Suppress rollback in batch mode                                           ?????
      *
     C     P#MODE        IFEQ      'B'
     C                   MOVE      '*LEBTCH'     ##RTCD
     C                   ELSE
     C                   MOVE      *BLANKS       ##RTCD
     C                   ENDIF
      *
     C                   CALL      'AOOUFEU0'
     C                   PARM                    ##RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM                    LEFEQD                                       CER049
      *                                                                                     AR868380
     C     ##RTCD        IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   ENDIF                                                              AR868380
      *
     C     ##RTCD        IFEQ      '*ERROR*'
     C                   MOVEL     'AOOUFEU0'    DBFILE                         ************
     C                   Z-ADD     20            DBASE                          * DBERR 20 *
     C                   MOVEL     ##RTCD        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,LEH01183
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
     C/COPY WNCPYSRC,LEH01184
      *****************************************************************
      /EJECT
      *****************************************************************
      *    SRTXDT - Set Telex Notice Date
      ********************************************************************
      *
     C     SRTXDT        BEGSR
      *
     C                   MOVE      VFFCCY        ZCCY
     C                   Z-ADD     BJRDNB        ZDAYNO
      *
      ** Retrieve the Telex Notice Day for the currency.
     C     VFFCCY        LOOKUP    CURR(Y)                                75
     C                   MOVE      TXND(Y)       ZNRDYS
      *
      ** Method = Telex, Cheque to be sent, CHIPS, SWIFT, or Cheque to
      **          Collected
     C     FESTTL        IFEQ      1
     C     FESTTL        OREQ      2
     C     FESTTL        OREQ      7
     C     FESTTL        OREQ      8
     C     FESTTL        OREQ      12
      *
     C     VFPTFI        IFEQ      'P'
     C     VFPTFI        OREQ      'S'                                                        CLE106
     C     VFPTFI        OREQ      'R'                                                        CLE106
     C                   MOVEL     VFPONS        WOURST            2
     C                   ENDIF
      *
     C     VFPTFI        IFEQ      *BLANKS
     C                   MOVEL     VFRONS        WOURST
     C                   ENDIF
      *
     C     VFPTFI        IFNE      'I'
      *
     C                   MOVE      VFFCCY        KCCY
     C                   MOVE      WOURST        KNONB
     C                   MOVE      *BLANKS       KCNUM
     C                   CALL      'AONOSTR0'    PLIST1
      ** Call Nostro Details Access Object
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANK        ZLOC
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      ZFWDT
      ** Calculate Number of days forward
      *
     C                   Z-ADD     ZDYNBR        TXDT              5 0
      ** Set Telex Notice Date
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     ZFWDT         BEGSR
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   ENDSR
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       WRefNo                                       CRE020
     C                   MOVE      FECNUM        WCustNo                                      CRE020
                                                                                              CRE020
     C**********         IF        FELOAN <> *ZERO                                     CRE020 CLE148
     C                   IF        FELOAN <> *BLANKS                                          CLE148
     C                   MOVEL     FELOAN        WTrnRef                                      CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVEL     FEFACL        WTrnRef                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVEL     WRefNo        KRefNo                                       CRE020
     C                   MOVEL     FEFSEQ        KSeqNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANK        WNew                                         CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL2                                                   CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Check first if this is a new advice index.                                           CRE020
                                                                                              CRE020
     C                   IF        WNew = *BLANK                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'Y'           WNew                                         CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           WNew                                         CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Set default values if the advice indicator is equal to blank.                        CRE020
                                                                                              CRE020
     C                   IF        RSAPIN = ' '                                               CRE020
                                                                                              CRE020
     C                   IF        FELCHT = 'D'                                               CRE020
     C                   MOVE      'D'           RCHTYP                                       CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Change type is always 'I' for newly inserted records.                                CRE020
                                                                                              CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        FELCHT = 'D'                                               CRE020
                                                                                              CRE020
      ** Delete the advice index if the current record is a new fee.                          CRE020
      ** Reverse it otherwise.                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'D'           RCHTYP                                       CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute amend processing.                                                            CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
                                                                                              CRE020
      ** Change field values only if the authorise indicator is equal to 'N'.                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   IF        FELCHT = 'X'                                               CRE020
     C                   EVAL      RCHTYP = 'A'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      FELCHT        RCHTYP                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxAmd - Handles the advice index during 'A' processing.   *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxAmd      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       WRefNo                                       CRE020
     C                   MOVE      FECNUM        WCustNo                                      CRE020
                                                                                              CRE020
     C**********         IF        FELOAN <> *ZERO                                     CRE020 CLE148
     C                   IF        FELOAN <> *BLANKS                                          CLE148
     C                   MOVEL     FELOAN        WTrnRef                                      CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVEL     FEFACL        WTrnRef                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVEL     WRefNo        KRefNo                                       CRE020
     C                   MOVEL     FEFSEQ        KSeqNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL2                                                   CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Execute amend processing if necessary.                                               CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'Y' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'N'           RAUTHI                                       CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                     MD024342
      /EJECT                                                                                MD024342
      *****************************************************************                     MD024342
      * Initialise - Initialise trailer fields                        *                     MD024342
      *****************************************************************                     MD024342
     C     Initialise    BEGSR                                                              MD024342
      *                                                                                     MD024342
     C                   EVAL      FENORE = 0                                               MD024342
     C                   EVAL      FENINT = 0                                               MD024342
     C                   EVAL      FENAMD = 0                                               MD024342
     C                   EVAL      FENDEL = 0                                               MD024342
     C                   EVAL      FENRIC = 0                                               MD024342
     C                   EVAL      CANORE = 0                                               MD024342
     C                   EVAL      CANINT = 0                                               MD024342
     C                   EVAL      CANAMD = 0                                               MD024342
     C                   EVAL      CANDEL = 0                                               MD024342
     C                   EVAL      CANRIC = 0                                               MD024342
      *                                                                                     MD024342
     C                   ENDSR                                                              MD024342
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    P#MODE            1
     C                   PARM                    ValidFeem
     C                   PARM                    OrgFeeFFmt                                  BUG3760
     C                   PARM                    LEFEQD                                       CER049
     C                   PARM                    CLE002            1
     C                   PARM                    CSC011            1
     C                   PARM                    BPFEAU            1
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    H#TNLU            5 0
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    OkFee
      * Fee sequence
     C                   PARM                    WWFSEQ            2 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
      **  DEFINE DTAARA JNSTAT
     C     *DTAARA       DEFINE                  JNSTAT
 
     C                   IN        SDSTAT                                                    BUG3760
     C     CSC011        IFEQ      'Y'
     C                   IN        SC24X7
     C**********         IN        SDSTAT                                                    BUG3760
     C                   END
 
      ** Determine if EMU LE Settlement Currency Conversion
      ** Upgrade feature is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      'CEU004'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004            1
     C                   ELSE
     C                   MOVE      'N'           CEU004
     C                   ENDIF
 
      ** Determine if Customer Lending Enhancements - Authorisation
      ** feature is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE002
     C                   ENDIF
      *
      ** Determine if Customer Lending Enhancements - Syndications
      ** feature is installed - CLE006
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if Customer Lending MISC Enhancements
      ** feature is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE007            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE007
     C                   ENDIF
      *
      ** Determine if Customer Lending Enhancements
      ** Swift Message Genereation for Fees Feature is installed
     C     CLE007        IFEQ      'Y'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE009            1
     C                   ELSE
     C                   MOVE      'Y'           CLE009
     C                   Z-ADD     1             Y                 3 0
                                                                                              CRE020
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 101                                                CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM                    PSysVal01                                    CRE020
     C                   PARM                    PCurSet01                                    CRE020
     C                   PARM                    PSysVal02                                    CRE020
     C                   PARM                    PCurSet02                                    CRE020
     C                   PARM                    PSysVal03                                    CRE020
     C                   PARM                    PCurSet03                                    CRE020
     C                   PARM                    PSysVal04                                    CRE020
     C                   PARM                    PCurSet04                                    CRE020
     C                   PARM                    PSysVal05                                    CRE020
     C                   PARM                    PCurSet05                                    CRE020
     C                   PARM                    PSysVal06                                    CRE020
     C                   PARM                    PCurSet06                                    CRE020
     C                   PARM                    PSysVal07                                    CRE020
     C                   PARM                    PCurSet07                                    CRE020
     C                   PARM                    PSysVal08                                    CRE020
     C                   PARM                    PCurSet08                                    CRE020
     C                   PARM                    PSysVal09                                    CRE020
     C                   PARM                    PCurSet09                                    CRE020
     C                   PARM                    PSysVal10                                    CRE020
     C                   PARM                    PCurSet10                                    CRE020
                                                                                              CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 102                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                             BUG3760
      ** Check if CSD015 is enabled.                                                         BUG3760
                                                                                             BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*VERIFY'     POptn                                       BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd = *BLANKS                                           BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd <> '*NRF'                                           BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 111                                               BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      SRErr                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      **  Access SAR details to see if CCF001 is switched on.                                BUG3760
                                                                                             BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*VERIFY'     POptn                                       BUG3760
     C                   PARM      'CCF001'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd = *BLANKS                                           BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
      ** Database error                                                                      BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd <> '*NRF'                                           BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CCF001'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 910                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      SRERR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
                                                                                             BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*KEY   '     POptn                                       BUG3760
     C                   PARM      'LENDING '    PFuncCode                                   BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
                                                                                             BUG3760
      ** Database error                                                                      BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd <> *BLANKS AND                                      BUG3760
     C                             PRtCd <> '*NRF'                                           BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 908                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      SRERR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      **  Access the Compliance Watch Configuration Data.                                    BUG3760
                                                                                             BUG3760
     C                   CALL      'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*FIRST '     POptn                                       BUG3760
     C     SDCWCD        PARM      SDCWCD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd <> *BLANKS                                          BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = @Optn                                             BUG3760
     C                   EVAL      DBFile = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBase = 909                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      SRERR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Check if CAP086 is enabled                                                           CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      '*VERIFY'     POptn                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRtCd = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 22                                                 CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      SRErr                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAS011
      **  Access SAR details to see if CAS009 is switched on.                                 CAS011
                                                                                              CAS011
     C                   CALL      'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRtCd                                        CAS011
     C                   PARM      '*VERIFY'     POptn                                        CAS011
     C                   PARM      'CAS009'      PSARD                                        CAS011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
                                                                                              CAS011
     C                   IF        PRtCd = *BLANKS                                            CAS011
     C                   EVAL      CAS009 = 'Y'                                               CAS011
     C                   ELSE                                                                 CAS011
                                                                                              CAS011
      ** Database error                                                                       CAS011
                                                                                              CAS011
     C                   IF        PRtCd <> '*NRF'                                            CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBKey = 'CAS009'                                           CAS011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS011
     C                   EVAL      DBase = 911                                                CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      SRERR                                                      CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS019
      **  Access SAR details to see if CAS016 is switched on.                                 CAS019
                                                                                              CAS019
     C                   CALL      'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       PRtCd                                        CAS019
     C                   PARM      '*VERIFY'     POptn                                        CAS019
     C                   PARM      'CAS016'      PSARD                                        CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
                                                                                              CAS019
     C                   IF        PRtCd = *BLANKS                                            CAS019
     C                   EVAL      CAS016 = 'Y'                                               CAS019
     C                   ELSE                                                                 CAS019
                                                                                              CAS019
      ** Database error                                                                       CAS019
                                                                                              CAS019
     C                   IF        PRtCd <> '*NRF'                                            CAS019
     C     *LOCK         IN        LDA                                                        CAS019
     C                   EVAL      DBKey = 'CAS016'                                           CAS019
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS019
     C                   EVAL      DBase = 912                                                CAS019
     C                   OUT       LDA                                                        CAS019
     C                   EXSR      SRERR                                                      CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CLE134
      ** Access SAR details to see if CLE134 is switched on.                                  CLE134
                                                                                              CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRtCd                                        CLE134
     C                   PARM      '*VERIFY'     POptn                                        CLE134
     C                   PARM      'CLE134'      PSARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        PRtCd       = *BLANKS                                      CLE134
     C                   EVAL      CLE134      = 'Y'                                          CLE134
     C                   ELSE                                                                 CLE134
                                                                                              CLE134
      ** Database error                                                                       CLE134
                                                                                              CLE134
     C                   IF        PRtCd      <> '*NRF'                                       CLE134
     C     *LOCK         IN        LDA                                                        CLE134
     C                   EVAL      DBKey       = 'CLE134'                                     CLE134
     C                   EVAL      DBFile      = 'SCSARDPD'                                   CLE134
     C                   EVAL      DBase       = 914                                          CLE134
     C                   OUT       LDA                                                        CLE134
     C                   EXSR      SRERR                                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                     AR943686
      **  Access SAR details to see if CLE031 is switched on.                               AR943686
      *                                                                                     AR943686
     C                   CALL      'AOSARDR0'                                               AR943686
     C                   PARM      *BLANKS       PRtCd                                      AR943686
     C                   PARM      '*VERIFY'     POptn                                      AR943686
     C                   PARM      'CLE031'      PSARD                                      AR943686
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR943686
                                                                                            AR943686
     C                   IF        PRtCd       = *BLANKS                                    AR943686
     C                   EVAL      CLE031      = 'Y'                                        AR943686
     C                   ELSE                                                               AR943686
      *                                                                                     AR943686
      ** Database error                                                                     AR943686
      *                                                                                     AR943686
     C                   IF        PRtCd      <> '*NRF'                                     AR943686
     C     *LOCK         IN        LDA                                                      AR943686
     C                   EVAL      DBKey       = 'CLE031'                                   AR943686
     C                   EVAL      DBFile      = 'SCSARDPD'                                 AR943686
     C                   EVAL      DBase       = 915                                        AR943686
     C                   OUT       LDA                                                      AR943686
     C                   EXSR      SRERR                                                    AR943686
     C                   ENDIF                                                              AR943686
     C                   ENDIF                                                              AR943686
     C/COPY WNCPYSRC,LEH00158
      *
     C                   MOVEL     *BLANKS       @RTCD
     C                   MOVEL     '*FIRST '     @OPTN
     C                   CALLB     'AOCURRR0'
     C                   PARM                    @RTCD
     C                   PARM                    @OPTN
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   MOVE      A6CYCD        CURR(Y)
     C                   MOVE      A6TXND        TXND(Y)                        Telex Nt Day
      *
     C     @RTCD         DOWNE     '*EOF    '
     C                   MOVEL     *BLANKS       @RTCD
     C                   MOVEL     '*NEXT  '     @OPTN
     C                   CALLB     'AOCURRR0'
     C                   PARM                    @RTCD
     C                   PARM                    @OPTN
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      '*EOF    '
     C     A6DLCI        ANDEQ     'Y'
      *
     C                   ADD       1             Y
     C                   MOVE      A6CYCD        CURR(Y)
     C                   MOVE      A6TXND        TXND(Y)                        Telex Nt Day
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW208
      ** Determine if CSW208 is installed                                                     CSW208
      *                                                                                       CSW208
     C                   MOVEL     'N'           CSW208                                       CSW208
     C**********         CALL      'SWIF2007'                                        CSW208 BUG20671
     C                   CALL      'SWIF2008'                                               BUG20671
     C                   PARM      *BLANKS       PRtCd                                        CSW208
      *                                                                                       CSW208
     C                   MOVEL     'N'           LSCONF                                       CSW208
     C                   IF        PRtCd = 'CSW2008'                                          CSW208
     C                   MOVEL     'Y'           CSW208                                       CSW208
      *                                                                                       CSW208
     C                   CALLB     'AOSVALR0'                                                 CSW208
     C                   PARM      *BLANKS       PRtCd                                        CSW208
     C                   PARM                    PSysValLE                                    CSW208
     C                   PARM                    PCurSet01                                    CSW208
     C                   PARM                    PSysVal02                                    CSW208
     C                   PARM                    PCurSet02                                    CSW208
     C                   PARM                    PSysVal03                                    CSW208
     C                   PARM                    PCurSet03                                    CSW208
     C                   PARM                    PSysVal04                                    CSW208
     C                   PARM                    PCurSet04                                    CSW208
     C                   PARM                    PSysVal05                                    CSW208
     C                   PARM                    PCurSet05                                    CSW208
     C                   PARM                    PSysVal06                                    CSW208
     C                   PARM                    PCurSet06                                    CSW208
     C                   PARM                    PSysVal07                                    CSW208
     C                   PARM                    PCurSet07                                    CSW208
     C                   PARM                    PSysVal08                                    CSW208
     C                   PARM                    PCurSet08                                    CSW208
     C                   PARM                    PSysVal09                                    CSW208
     C                   PARM                    PCurSet09                                    CSW208
     C                   PARM                    PSysVal10                                    CSW208
     C                   PARM                    PCurSet10                                    CSW208
      *                                                                                       CSW208
     C                   IF        PRtCd = *BLANKS                                            CSW208
     C                   MOVEL     PCurSet01     LSCONF                                       CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   ENDIF                                                                CSW208
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRtCd                                        CSD083
     C                   PARM      '*VERIFY'     POptn                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
     C                             PRtCd <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 913                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRERR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRtCd = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C/COPY WNCPYSRC,LEH01185
                                                                                              CSD083
      ** If Past Due Call Loans Processing;                                                   CLE134
      ** - Retrieve Lending ICD Details.                                                      CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   CALL      'AOCLNDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*FIRST '     @OPTN                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS                                      CLE134
     C     *LOCK         IN        LDA                                                        262754
     C                   EVAL      DBFILE      = 'SDCLNDPD'                                   CLE134
     C                   EVAL      DBASE       = 7                                            CLE134
     C                   EVAL      DBKEY       = @OPTN                                        CLE134
     C                   OUT       LDA                                                        262754
     C**********         EXSR      *PSSR                                               CLE134 262754
     C                   EXSR      srERR                                                      262754
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Set Basel II Classification Period Description & Days Arrays.                        CLE134
                                                                                              CLE134
     C                   EVAL      DSBCN(1)    = icBPCLN1                                     CLE134
     C                   EVAL      DSBCN(2)    = icBPCLN2                                     CLE134
     C                   EVAL      DSBCN(3)    = icBPCLN3                                     CLE134
     C                   EVAL      DSBCN(4)    = icBPCLN4                                     CLE134
     C                   EVAL      DSBCN(5)    = icBPCLN5                                     CLE134
     C                   EVAL      DSBCN(6)    = icBPCLN6                                     CLE134
     C                   EVAL      DSBCN(7)    = icBPCLN7                                     CLE134
     C                   EVAL      DSBCN(8)    = icBPCLN8                                     CLE134
     C                   EVAL      DSBCN(9)    = icBPCLN9                                     CLE134
                                                                                              CLE134
      ** - Determine Number of Days in Each Period.                                           CLE134
                                                                                              CLE134
     C                   EVAL      DSBCE       = *ALL'999'                                    CLE134
     C                   EVAL      DSBCE(1)    = DSBCN(1)                                     CLE134
                                                                                              CLE134
     C     2             DO        9             #A                                           CLE134
     C                   IF        DSBCN(#A)   > 0             AND                            CLE134
     C                             DSBCN(#A)   < 999                                          CLE134
     C                   EVAL      DSBCE(#A)   = DSBCN(#A) - DSBCN(#A-1)                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
      ** Set Reporting Classification Period Description & Days Arrays.                       CLE134
                                                                                              CLE134
     C                   EVAL      DSRCN(1)    = icBPRCN1                                     CLE134
     C                   EVAL      DSRCN(2)    = icBPRCN2                                     CLE134
     C                   EVAL      DSRCN(3)    = icBPRCN3                                     CLE134
     C                   EVAL      DSRCN(4)    = icBPRCN4                                     CLE134
     C                   EVAL      DSRCN(5)    = icBPRCN5                                     CLE134
     C                   EVAL      DSRCN(6)    = icBPRCN6                                     CLE134
     C                   EVAL      DSRCN(7)    = icBPRCN7                                     CLE134
     C                   EVAL      DSRCN(8)    = icBPRCN8                                     CLE134
     C                   EVAL      DSRCN(9)    = icBPRCN9                                     CLE134
                                                                                              CLE134
      ** - Determine Number of Days in Each Period.                                           CLE134
                                                                                              CLE134
     C                   EVAL      DSRCE       = *ALL'999'                                    CLE134
     C                   EVAL      DSRCE(1)    = DSRCN(1)                                     CLE134
                                                                                              CLE134
     C     2             DO        9             #A                                           CLE134
     C                   IF        DSRCN(#A)   > 0             AND                            CLE134
     C                             DSRCN(#A)   < 999                                          CLE134
     C                   EVAL      DSRCE(#A)   = DSRCN(#A) - DSRCN(#A-1)                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
     C                   ENDIF                                                                CLE134
      ***********************************************************************      MD024342 MD025467
      ***Get*MPHAS*dataarea.*************************************************      MD024342 MD025467
      ***********************************************************************      MD024342 MD025467
     C******DTAARA       DEFINE                  MPHAS                             MD024342 MD025467
     C**********         IN        MPHAS                                           MD024342 MD025467
     C**********         UNLOCK    MPHAS                                           MD024342 MD025467
      *                                                                                     MD024342
     C**********         MOVEL     RPFRNT        W#FRNT                            MD024342 MD025467
      *                                                                                     MD024342
     C**********         MOVEL     'N'           MTHREAD           1               MD024342 MD025467
     C**********         MOVE      'FEEM'        WAPIC                             MD024342 MD025467
     C**********         MOVEL     'LEFEEZ'      WFILN                             MD024342 MD025467
      *                                                                                     MD024342
     C**********         IF        MPHAS = 'A' AND                                 MD024342 MD025467
     C**********                   W#FRNT <> 'LE000473'                            MD024342 MD025467
     C*****KAPILST       CHAIN     SDAPDRL0                           99           MD024342 MD025467
     C******IN99         IFEQ      '0'                                             MD024342 MD025467
     C**********         MOVEL     A8MULT        MTHREAD                           MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
      *                                                                                      BUG3760
      ** Compliance Watch Hit List Key.                                                      BUG3760
      *                                                                                      BUG3760
     C     CWHTKY        KLIST                                                               BUG3760
     C                   KFLD                    KFuncType                                   BUG3760
     C                   KFLD                    KIden                                       BUG3760
     C                   KFLD                    KBranch                                     BUG3760
      *                                                                                      BUG3760
      ** KLIST for file LEFEED
     C     KEY002        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C                   KFLD                    WFSEQ
      *                                                                                       CSW208
      ** KLIST for file CLOAN                                                                 CSW208
      *                                                                                       CSW208
     C     KEY004        KLIST                                                                CSW208
     C                   KFLD                    WLOAN                                        CSW208
     C                   KFLD                    WCLRT                                        CSW208
      *
      ** KLIST for file LEFEED
     C     KEY005        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
      *
      ** KLIST for file LEFHSTL1
     C     KEY012        KLIST
     C                   KFLD                    VFBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C                   KFLD                    WFSEQ
      *
      ** KLIST for file LEFHSTL1
     C     KEY015        KLIST
     C                   KFLD                    VFBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key Lists                                    CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
     C                   KFLD                    KSeqNo                                       CRE020
                                                                                              CLE134
      ** Retail Account Key List                                                              CLE134
                                                                                              CLE134
     C     KACCNTL1      KLIST                                                                CLE134
     C                   KFLD                    KACNO                                        CLE134
                                                                                              CLE134
     C     KFCLTY        KLIST                                                                CLE134
     C                   KFLD                    Kf_CNUM                                      CLE134
     C                   KFLD                    Kf_FACT                                      CLE134
     C                   KFLD                    Kf_FCNO                                      CLE134
     C                   KFLD                    Kf_RCTP                                      CLE134
                                                                                              CLE134
      ** Repayment Priority Key List                                                          CLE134
                                                                                              CLE134
     C*****KLEACCNLB     KLIST                                                         CLE134 CLE164
     C**********         KFLD                    KRPFCNM                               CLE134 CLE164
     C**********         KFLD                    KRPFLNR                               CLE134 CLE164
     C**********         KFLD                    KRPFACT                               CLE134 CLE164
     C**********         KFLD                    KRPFSE1                               CLE134 CLE164
     C**********         KFLD                    KRPFCOD                               CLE134 CLE164
     C**********         KFLD                    KRPFCBR                               CLE134 CLE164
                                                                                              CLE134
      ** Key: GLAPNAPD                                                                        CLE134
      ** -Nx Avail Ref                                                                        CLE134
                                                                                              CLE134
     C     KAPNAPD       KLIST                                                                CLE134
     C                   KFLD                    KGLNARI                                      CLE134
                                                                                              CLE134
      ** Key: RSACMTPD                                                                        CLE134
      ** -Nx Avl Ref Id                                                                       CLE134
      ** -Nx Avl Ref No                                                                       CLE134
                                                                                              CLE134
     C     KACMTLX       KLIST                                                                CLE134
     C                   KFLD                    KspXRFI                                      CLE134
     C                   KFLD                    KspXRFN                                      CLE134
                                                                                              CLE134
     C*****KAPILST       KLIST                                                     MD024342 MD025467
     C**********         KFLD                    WAPIC             4               MD024342 MD025467
     C**********         KFLD                    WFILN            10               MD024342 MD025467
      ** Key for LEFEDNL0                                                                   MD030700
                                                                                            MD030700
     C     KFNPD         KLIST                                                              MD030700
     C                   KFLD                    FFCNUM                                     MD030700
     C                   KFLD                    FFFACL                                     MD030700
     C                   KFLD                    FFLOAN                                     MD030700
     C                   KFLD                    FFFSEQ                                     MD030700
                                                                                            MD030700
     C*
      ** Set up parameter fields
      ** PLIST for access program AONOSTR0
     C     PLIST1        PLIST
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    KCNUM             6
     C                   PARM                    KCCY              3
     C**********         PARM                    KEYC1             4                          CGL029
     C                   PARM                    KEYC1                                        CGL029
     C                   PARM                    KEYD              2
     C                   PARM                    KNONB             2
     C                   PARM                    KEYF              3
     C                   PARM                    KEYG             10
     C                   PARM                    KEYH              1
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'LEFEEMUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************                      MD023682
      /EJECT                                                                                MD023682
     C****************************************************************                      MD023682
     C*                                                              *                      MD023682
     C* SRFEEZ - LEFEEZ EXCEPTION ERRORS                             *                      MD023682
     C*                                                              *                      MD023682
     C****************************************************************                      MD023682
     C     SRFEEZ        BEGSR                                                              MD023682
     C*                                                                                     MD023682
     C                   EVAL      @@RTCD = '*RECUPD   '                                    MD023682
     C                   EVAL      DBPGM  = 'LEFEEMUPD'                                     MD023682
     C                   EVAL      *INU7  = *ON                                             MD023682
     C                   EVAL      *INU8  = *ON                                             MD023682
     C                   EVAL      *INLR  = *ON                                             MD023682
     C                   DUMP                                                               MD023682
     C*                                                                                     MD023682
     C**  TERMINATE THE PROGRAM                                                             MD023682
     C*                                                                                     MD023682
     C                   RETURN                                                             MD023682
     C*                                                                                     MD023682
     C                   ENDSR                                                              MD023682
      *****************************************************************
      /EJECT
      ********************************************************************
     C     ZTNLU1        BEGSR
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NATN              5 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SrWatch - Perform Midas Watch List processing.                *                      BUG3760
      *                                                               *                      BUG3760
      * Called by: SR/INSERT, SR/AMEND                                *                      BUG3760
      *                                                               *                      BUG3760
      * Calls: None                                                   *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SrWatch       BEGSR                                                               BUG3760
                                                                                             BUG3760
     C                   CLEAR                   SDWLTD                                      BUG3760
     C                   CLEAR                   PString                                     BUG3760
     C                   EVAL      U = *Zeros                                                BUG3760
     C                   EVAL      Fld1 = *Blanks                                            BUG3760
     C                   EVAL      Fld2 = *Blanks                                            BUG3760
     C                   EVAL      Fld3 = *Blanks                                            BUG3760
     C                   EVAL      Fld4 = *Blanks                                            BUG3760
     C                   EVAL      Fld5 = *Blanks                                            BUG3760
     C                   IF        FEPSCY <> *Blanks                                         BUG3760
     C                   EVAL      PInCcy = FEPSCY                                           BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      PInCcy = FEFCCY                                           BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receipt Nostro                                                                      BUG3760
     C                   IF        RONS <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  RONS <> PV_RONS                        BUG3760
     C                   EVAL      Fld1 = RONS                                               BUG3760
     C                   EVAL      U = 1                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receipt Ordering Customer                                                           BUG3760
     C**********         IF        ROCN <> *Zeros                                      UG3760 CSD027
     C                   IF        ROCN <> *Blanks                                            CSD027
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  ROCN <> PV_ROCN                        BUG3760
     C                   MOVEL     ROCN          Fld1                                        BUG3760
     C                   EVAL      U = 3                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receipt Ordering Bank                                                               BUG3760
     C**********         IF        ROBN <> *Zeros                                      UG3760 CSD027
     C                   IF        ROBN <> *Blanks                                            CSD027
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  ROBN <> PV_ROBN                        BUG3760
     C                   MOVEL     ROBN          Fld1                                        BUG3760
     C                   EVAL      U = 5                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receipt Intermediary Bank                                                           BUG3760
     C                   IF        RIBN <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  RIBN <> PV_RIBN OR                     BUG3760
     C                             VFLCHT = 'A'  AND  RIBA <> PV_RIBA                        BUG3760
     C                   EVAL      Fld1 = RIBN                                               BUG3760
     C                   EVAL      Fld2 = RIBA                                               BUG3760
     C                   EVAL      U = 7                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Pay Nostro                                                                          BUG3760
     C                   IF        PONS <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  PONS <> PV_PONS                        BUG3760
     C                   EVAL      Fld1 = PONS                                               BUG3760
     C                   EVAL      U = 9                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Pay Ordering Customer                                                               BUG3760
     C**********         IF        POCN <> *Zeros                                      UG3760 CSD027
     C                   IF        POCN <> *Blanks                                            CSD027
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  POCN <> PV_POCN                        BUG3760
     C                   MOVEL     POCN          Fld1                                        BUG3760
     C                   EVAL      U = 11                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Pay Ordering Bank                                                                   BUG3760
     C**********         IF        POBN <> *Zeros                                      UG3760 CSD027
     C                   IF        POBN <> *Blanks                                            CSD027
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  POBN <> PV_POBN                        BUG3760
     C                   MOVEL     POBN          Fld1                                        BUG3760
     C                   EVAL      U = 13                                                    BUG3760
     C                   MOVEL     POCN          Fld1                                        BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Pay Intermediary Bank                                                               BUG3760
     C                   IF        PIBN <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  PIBN <> PV_PIBN OR                     BUG3760
     C                             VFLCHT = 'A'  AND  PIBA <> PV_PIBA                        BUG3760
     C                   EVAL      Fld1 = PIBN                                               BUG3760
     C                   EVAL      Fld2 = PIBA                                               BUG3760
     C                   EVAL      U = 15                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receivers Correspondent                                                             BUG3760
     C                   IF        RCRN <> *Blanks                                           BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  RCRN <> PV_RCRN                        BUG3760
     C                   EVAL      Fld1 = RCRN                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ELSE                                                                BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  RCRA <> PV_RCRA                        BUG3760
     C                   EVAL      Fld1 = RCRA                                               BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        Fld1 <> *Blanks                                           BUG3760
     C                   EVAL      U = 17                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receiver Number                                                                     BUG3760
     C                   IF        RVNO <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  RVNO <> PV_RVNO                        BUG3760
     C                   EVAL      Fld1 = RVNO                                               BUG3760
     C                   EVAL      U = 19                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Account with Bank                                                                   BUG3760
     C                   IF        AWBN <> *Blanks                                           BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  AWBN <> PV_AWBN                        BUG3760
     C                   EVAL      Fld1 = AWBN                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ELSE                                                                BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  AWBA <> PV_AWBA                        BUG3760
     C                   EVAL      Fld1 = AWBA                                               BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        Fld1 <> *Blanks                                           BUG3760
     C                   EVAL      U = 21                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Beneficiary                                                                         BUG3760
     C                   IF        BENN <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  BENN <> PV_BENN OR                     BUG3760
     C                             VFLCHT = 'A'  AND  BENA <> PV_BENA                        BUG3760
     C                   EVAL      Fld1 = BENN                                               BUG3760
     C                   EVAL      Fld2 = BENA                                               BUG3760
     C                   EVAL      U = 23                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Details of Payment                                                                  BUG3760
     C                   IF        DTP1 <> *Blanks  OR  DTP2 <> *Blanks  OR                  BUG3760
     C                             DTP3 <> *Blanks  OR  DTP4 <> *Blanks                      BUG3760
                                                                                             BUG3760
     C                   IF        VFLCHT = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             VFLCHT = 'A'  AND  DTP1 <> PV_DTP1 OR                     BUG3760
     C                             VFLCHT = 'A'  AND  DTP2 <> PV_DTP2 OR                     BUG3760
     C                             VFLCHT = 'A'  AND  DTP3 <> PV_DTP3 OR                     BUG3760
     C                             VFLCHT = 'A'  AND  DTP4 <> PV_DTP4                        BUG3760
     C                   EVAL      Fld1 = DTP1                                               BUG3760
     C                   EVAL      Fld2 = DTP2                                               BUG3760
     C                   EVAL      Fld3 = DTP3                                               BUG3760
     C                   EVAL      Fld4 = DTP4                                               BUG3760
     C                   EVAL      U = 25                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      *                                                                                      BUG3760
      ** If second parameter is not blank, setup first parameter and                         BUG3760
      ** send transaction details to Compliance Watch by calling SDCWLCHK                    BUG3760
      *                                                                                      BUG3760
     C                   IF        PString <> *Blanks                                        BUG3760
                                                                                             BUG3760
     C                   EXSR      SRSet1stParm                                              BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLCHK'                                                BUG3760
     C                   PARM                    SDWLTD                                      BUG3760
     C                   PARM                    PString                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRSet1stParm - Setup first parameter of SDCWLCHK.             *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRSet1stParm  BEGSR                                                               BUG3760
                                                                                             BUG3760
      ** Item Type Code                                                                      BUG3760
     C                   EVAL      W4ITEM = 'LEFEE'                                          BUG3760
                                                                                             BUG3760
      ** Identifier                                                                          BUG3760
     C**********         IF        FELOAN = *Zeros                                    BUG3760 CLE148
     C                   IF        FELOAN = *BLANKS                                           CLE148
     C                   EVAL      W4IDEN = *Blanks                                          BUG3760
     C                   MOVEL     FECNUM        W2CNUM                                      BUG3760
     C                   MOVEL     FEFACL        W2FACL                                      BUG3760
     C                   MOVEL     FEFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      W4IDEN = %TRIM(W2CNUM + W2FACL + W2FSEQ)                  BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4IDEN = *Blanks                                          BUG3760
     C                   MOVEL     FELOAN        W2LOAN                                      BUG3760
     C                   MOVEL     FEFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      W4IDEN = %TRIM(W2LOAN + W2FSEQ)                           BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Branch                                                                              BUG3760
     C                   EVAL      W4BRCH = FEBRCA                                           BUG3760
                                                                                             BUG3760
      ** System                                                                              BUG3760
      ** If Midas 24x7 is installed, use Main system prefix otherwise use system prefix      BUG3760
     C                   IF        CSC011 = 'Y'                                              BUG3760
     C                   EVAL      W4SYSM = S1MAIN                                           BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4SYSM = LIBR                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Function Type                                                                       BUG3760
     C                   EVAL      W4FUNT = 'LEFEED'                                         BUG3760
                                                                                             BUG3760
      ** Counterparty Details                                                                BUG3760
     C                   EXSR      SRGetCtrpDet                                              BUG3760
     C                   MOVEL     FECNUM        W4CNUM                                      BUG3760
     C                   EVAL      W4CTYP = WCtrpTyp                                         BUG3760
     C                   EVAL      W4CUST = WCtrpRpt                                         BUG3760
                                                                                             BUG3760
      ** Deal Date                                                                           BUG3760
     C                   MOVE      *Blanks       PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4DDAT = WDDT                                             BUG3760
                                                                                             BUG3760
      ** Value Date                                                                          BUG3760
     C                   MOVE      FEPSTD        PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4VDAT = WDDT                                             BUG3760
                                                                                             BUG3760
      ** Maturity Date                                                                       BUG3760
     C                   MOVE      FEPEND        PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4MDAT = WDDT                                             BUG3760
                                                                                             BUG3760
      ** Denomination Side 1                                                                 BUG3760
     C                   EVAL      W4DEN1  = FEFCCY                                          BUG3760
                                                                                             BUG3760
      ** Denomination Side 2                                                                 BUG3760
     C                   EVAL      W4DEN2  = *Blanks                                         BUG3760
                                                                                             BUG3760
      ** Amount Side 1                                                                       BUG3760
     C                   EVAL      PZACcy = FEFCCY                                           BUG3760
     C                   MOVE      FEFAMT        PZAAmt                                      BUG3760
     C                   EXSR      SRAmtToFPDT                                               BUG3760
     C                   EVAL      W4AMT1 = WFPDT                                            BUG3760
                                                                                             BUG3760
      ** Amount Side 2                                                                       BUG3760
     C                   EVAL      W4AMT2 = *Zeros                                           BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRDateToDDT - Converts a date into Date Data Type format.     *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRDateToDDT   BEGSR                                                               BUG3760
                                                                                             BUG3760
      ** Convert the derived Midas Day Number into Date Data Type.                           BUG3760
                                                                                             BUG3760
     C                   CALL      'ZACVTDATE'                                               BUG3760
     C                   PARM      *BLANKS       PZARtCd                                     BUG3760
     C                   PARM                    PZADayNo                                    BUG3760
     C                   PARM                    PZADDT                                      BUG3760
     C                   PARM                    PConvtDate                                  BUG3760
                                                                                             BUG3760
     C                   EVAL      WDDT = PZADDT                                             BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRAmtToFPDT - Converts an amount into Floating Point Data     *                      BUG3760
      *               Type format.                                    *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRAmtToFPDT   BEGSR                                                               BUG3760
      *                                                                                      BUG3760
      ** Directly convert the given amount into Floating Point format.                       BUG3760
      *                                                                                      BUG3760
     C                   CALL      'ZACVTAMT'                                                BUG3760
     C                   PARM      *BLANKS       PZARtCd                                     BUG3760
     C                   PARM                    PZACcy                                      BUG3760
     C                   PARM                    PZAAmt                                      BUG3760
     C                   PARM                    PZOutAmt                                    BUG3760
     C                   PARM                    PZCvtAmt                                    BUG3760
      *                                                                                      BUG3760
     C                   EVAL      WFPDT = PZOutAmt                                          BUG3760
      *                                                                                      BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRGetCtrpDet - Gets the Counterparty Details given a Customer *                      BUG3760
      *                Number.                                        *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRGetCtrpDet  BEGSR                                                               BUG3760
      *                                                                                      BUG3760
      ** Initialise the relevant variables.                                                  BUG3760
      *                                                                                      BUG3760
     C                   EVAL      WCtrpRpt = *BLANKS                                        BUG3760
     C                   EVAL      WCtrpTyp = *BLANKS                                        BUG3760
     C                   MOVEL     FECNUM        PCustNo                                     BUG3760
      *                                                                                      BUG3760
      ** Get the Customer Detail.                                                            BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOCUSTR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*KEY   '     POptn                                       BUG3760
     C                   PARM                    PCustNo                                     BUG3760
     C                   PARM      *BLANKS       PErrInf                                     BUG3760
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRtCd = *BLANKS                                           BUG3760
      *                                                                                      BUG3760
      ** Assemble the Counterparty Report information.                                       BUG3760
      *                                                                                      BUG3760
     C     BBCRNM        CAT       BBCRTN        WCtrpRpt                                    BUG3760
      *                                                                                      BUG3760
      ** Determine the Counterparty Type.                                                    BUG3760
      *                                                                                      BUG3760
     C                   IF        CCF001 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
     C                   IF        BBCRPC = 'Y'                                              BUG3760
     C                   EVAL      WCtrpTyp = 'C'                                            BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      WCtrpTyp = 'I'                                            BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        BBLICD <> *BLANKS AND                                     BUG3760
     C                             BBLICD <> W1IND1  AND                                     BUG3760
     C                             BBLICD <> W1IND2  AND                                     BUG3760
     C                             BBLICD <> W1IND3  AND                                     BUG3760
     C                             BBLICD <> W1IND4  AND                                     BUG3760
     C                             BBLICD <> W1IND5                                          BUG3760
     C                   EVAL      WCtrpTyp = 'C'                                            BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      WCtrpTyp = 'I'                                            BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
      ** Handle Database Errors if any occur.                                                BUG3760
      *                                                                                      BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = POptn                                             BUG3760
     C                   EVAL      DBFile = 'SDCUSTPD'                                       BUG3760
     C                   EVAL      DBase = 21                                                BUG3760
     C                   EXSR      SrErr                                                     BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRConvert - Subroutine to convert accounts, customer no. to   *                      BUG3760
      *             customer name and address.                        *                      BUG3760
      * Called by: SRWatch                                            *                      BUG3760
      *                                                               *                      BUG3760
      * Calls: SDCWHLCHK                                              *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRConvert     BEGSR                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      OutFmt = *Blanks                                          BUG3760
     C                   EVAL      PInput = *Blanks                                          BUG3760
     C                   EVAL      PInput1 = *Blanks                                         BUG3760
     C                   EVAL      PInput2 = *Blanks                                         BUG3760
     C                   EVAL      PInput3 = *Blanks                                         BUG3760
     C                   EVAL      PInput4 = *Blanks                                         BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLFMT'                                                BUG3760
     C                   PARM      *Blanks       PRtcd                                       BUG3760
     C                   PARM      Fld1          PInput                                      BUG3760
     C                   PARM      Fld2          PInput1                                     BUG3760
     C                   PARM      Fld3          PInput2                                     BUG3760
     C                   PARM      Fld4          PInput3                                     BUG3760
     C                   PARM      Fld5          PInput4                                     BUG3760
     C                   PARM                    PInput5                                     BUG3760
     C                   PARM                    PInCcy                                      BUG3760
     C                   PARM                    OutFmt                                      BUG3760
     C                   PARM                    OutFmt2                                     BUG3760
                                                                                             BUG3760
     C                   EVAL      Fld1 = *Blanks                                            BUG3760
     C                   EVAL      Fld2 = *Blanks                                            BUG3760
     C                   EVAL      Fld3 = *Blanks                                            BUG3760
     C                   EVAL      Fld4 = *Blanks                                            BUG3760
     C                   EVAL      Fld5 = *Blanks                                            BUG3760
                                                                                             BUG3760
     C     PString       CAT       WLARR(U):0    PString                                     BUG3760
     C     PString       CAT       OUTFMT:0      PString                                     BUG3760
     C                   EVAL      U = U+1                                                   BUG3760
     C     PString       CAT(P)    WLARR(U):0    PString                                     BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                       CAS011
      *                                                               *                       CAS011
      * SRUpdEIR  - Subroutine to update EIR info                     *                       CAS011
      *                                                               *                       CAS011
      *****************************************************************                       CAS011
     C     SRUpdEIR      BEGSR                                                                CAS011
                                                                                              CAS011
     C                   IF        WADJY = 'Y'                                                CAS011
     C                             OR VFLCHT = 'D'                                            262581
                                                                                              CAS011
     C                   IF        (CAS016 = 'Y')                                             CAS019
     C                             AND (VFAMRI = 'Y')                                         262581
     C*****WLOAN         CHAIN     LEEIRDL9                                            CAS019 262581
     C**********         IF        %FOUND(LEEIRDL9)                                    CAS019 262581
     C**********         IF        (VFAMRI = 'Y' AND VFSTPD <= BJRDNB) OR              CAS019 262581
     C**********                   (VFRECI = '*')                                      CAS019 262581
     C     WLOAN         CHAIN     LEERAPD0                           81                      262581
     C                   DOW       *IN81 = *OFF                                               262581
     C                   IF        VFFSEQ = EIFSEQ                                            262581
     C                   EVAL      EIRCAL = 'Y'                                               CAS019
     C**********         EVAL      EIADJP = 'Y'                                        CAS019 262581
     C**********         UPDATE    LEEIRDD9                                            CAS019 262581
     C                   UPDATE    LEERAPD0                                                   262581
     C**********         ENDIF                                                         CAS019 262581
     C                   ENDIF                                                                CAS019
     C     WLOAN         READE     LEERAPD0                               81                  262581
     C                   ENDDO                                                                262581
     C                   ELSE                                                                 CAS019
     C*****WLOAN         CHAIN     LEEIRDL5                                            CAS011 262581
     C     WLOAN         CHAIN     LEEIRDL9                                                   262581
     C**********         IF        %FOUND(LEEIRDL5) and VFPSTD <= EIENDT               CAS011 262581
     C                   IF        %FOUND(LEEIRDL9)                                           262581
     C                   IF        VFPSTD <= EIENDT                                           262581
     C                             or VFSTPD <= BJRDNB and CAS016 = 'Y'                       262581
     C                             or VFRECI = '*' and CAS016 = 'Y'                           262581
     C                   EVAL      EIRCAL = 'Y'                                               CAS011
     C                   EVAL      EIADJP = 'Y'                                               262581
     C**********         UPDATE    LEEIRDD0                                            CAS011 262581
     C                   UPDATE    LEEIRDD9                                                   262581
     C                   ENDIF                                                                262581
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDSR                                                                CAS011
      *****************************************************************                     AR744771
      *                                                               *                     AR744771
      * SRFSFA - Default value of FEFSFA                              *                     AR744771
      *                                                               *                     AR744771
      *****************************************************************                     AR744771
     C     SRFSFA        BEGSR                                                              AR744771
      *                                                                                     AR744771
     C                   IF        VFLCHT = 'I'                                             AR744771
      *                                                                                     AR744771
     C                   MOVE      VFFCOD        @FECD                                      AR744771
     C                   EXSR      XRFEE                                                    AR744771
      *                                                                                     AR744771
     C                   IF        AUFSFA = 'Y'                                             AR744771
     C                   EVAL      VFEFSFA = AUFSFA                                         AR744771
     C                   ELSE                                                               AR744771
     C                   EVAL      VFEFSFA = 'N'                                            AR744771
     C                   ENDIF                                                              AR744771
     C                   ENDIF                                                              AR744771
      *                                                                                     AR744771
     C                   IF        VFLCHT = 'A' and                                         AR744771
     C                             VFEFSFA = ' '                                            AR744771
     C                   EVAL      VFEFSFA = FEFSFA                                         AR744771
     C                   ENDIF                                                              AR744771
      *                                                                                     AR744771
     C                   ENDSR                                                              AR744771
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * ProcessMatrix - Process Repayment Matrix  Details from        *                       CLE164
      *                                                               *                       CLE164
      * Called by: INSERT                                             *                       CLE164
      *                                                               *                       CLE164
      * Calls:                                                        *                       CLE164
      *                                                               *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     ProcessMatrix BEGSR                                                                CLE164
                                                                                              CLE164
     C                   FOR       Index = 1 TO MAX_CATEGORY                                  CLE164
     C                   CALLP     UPDATE_MATRIX(                                             CLE164
     C                               wRetCode                                                 CLE164
     C                             : wAction                                                  CLE164
     C                             : wFile                                                    CLE164
     C                             : LNRF                                                     CLE164
     C                             : wBranch                                                  CLE164
     C                             : wCustomer                                                CLE164
     C                             : wFeeFclty                                                CLE164
     C                             : wFeeLoan                                                 CLE164
     C                             : wFeeSeqn                                                 CLE164
     C                             : wLSPDPGrpID                                              CLE164
     C                             : wFTPDPGrpID                                              CLE164
     C                             : wFCPDPGrpID                                              CLE164
     C                             : aCAT(Index)                                              CLE164
     C                             )                                                          CLE164
     C                   IF        wRetCode <> *Blanks                                        CLE164
     C     *LOCK         IN        LDA                                                        CLE164
     C                   MOVE      *BLANKS       DBKEY                                        CLE164
     C                   MOVEL     'LEFEEZTD'    DBFILE                                       CLE164
     C                   Z-ADD     102           DBASE                                        CLE164
     C                   OUT       LDA                                                        CLE164
     C                   EXSR      SRERR                                                      CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDFOR                                                               CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * WriteExtFile - Write Repayment Priority Details to            *                       CLE164
      *                LEFEEZTD                                       *                       CLE164
      *                                                               *                       CLE164
      * Called by: WRITER                                             *                       CLE164
      *                                                               *                       CLE164
      * Calls: LE000506 - Midas LE Update Repayment Priority          *                       CLE164
      *                   Extension Table                             *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     WriteExtFile  BEGSR                                                                CLE164
                                                                                              CLE164
     C                   IF        CLE134 = *OFF OR                                           CLE164
     C                             VFAUTO <> 'C'                                              CLE164
     C                   LEAVESR                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
      ** Initialise arrays                                                                    CLE164
     C                   EVAL      wFTPDPGrpID = *BLANKS                                      CLE164
     C                   EVAL      wLSPDPGrpID = *BLANKS                                      CLE164
     C                   EVAL      wFCPDPGrpID = *BLANKS                                      CLE164
                                                                                              CLE164
     C                   EVAL      aLoanFee(1) = 'LFEE'                                       CLE164
     C                   EVAL      aLoanFee(2) = 'LFEM'                                       CLE164
                                                                                              CLE164
     C                   EVAL      aFcltFee(1) = 'FFEE'                                       CLE164
     C                   EVAL      aFcltFee(2) = 'FFEM'                                       CLE164
                                                                                              CLE164
     C                   EVAL      aLateFee(1) = 'Fee90'                                      CLE164
     C                   EVAL      aLateFee(2) = 'Fee9M'                                      CLE164
                                                                                              CLE164
      ** Facility fees, retrieve SDFACTPD->PDP Group ID                                       CLE164
     C                   IF        FEFACL <> *ZEROS AND FELOAN = *BLANKS                      CLE164
     C                   MOVEL     FEFACL        @FACT                                        CLE164
     C                   EXSR      XrFact                                                     CLE164
     C                   EVAL      wFTPDPGrpID = AMPGID                                       CLE164
     C                   EVAL      wLSPDPGrpID = '***'                                        CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
      ** Loan Fees, retrieve SDLOANPD->PDP Group ID                                           CLE164
     C                   IF        FEFACL = *ZEROS AND FELOAN <> *BLANKS                      CLE164
     C                   EVAL      WCLRT  = 'A'                                               CLE164
     C                   EVAL      WLOAN  = FELOAN                                            CLE164
     C     KEY004        CHAIN     CLOAN                                                      CLE164
     C                   IF        %FOUND(CLOAN)                                              CLE164
     C                   EVAL      @LNTY = LTYP                                               CLE164
     C                   EVAL      @LNST = SUTP                                               CLE164
     C                   EVAL      @LNCL = CLAS                                               CLE164
     C                   EXSR      XrLoan                                                     CLE164
     C                   EVAL      wLSPDPGrpID = AYPGID                                       CLE164
                                                                                              CLE164
      ** Loan Fees, retrieve SDFACTPD->PDP Group ID                                           CLE164
     C                   MOVEL     FTYP          @FACT                                        CLE164
     C                   EXSR      XrFact                                                     CLE164
     C                   EVAL      wFTPDPGrpID = AMPGID                                       CLE164
                                                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
      ** Retrieve SDFEEPD->PDP Group ID                                                       CLE164
     C                   MOVEL     FEFCOD        @FECD                                        CLE164
     C                   EXSR      XrFee                                                      CLE164
     C                   EVAL      wFCPDPGrpID = AUPGID                                       CLE164
                                                                                              CLE164
     C                   EVAL      wAction = '*INSERT'                                        CLE164
     C                   EVAL      wFile = 'LEFEEZTD'                                         CLE164
     C                   EVAL      wLoanRef  = *BLANKS                                        CLE164
     C                   EVAL      wCustomer = FECNUM                                         CLE164
     C                   EVAL      wBranch  = FEBRCA                                          CLE164
     C                   EVAL      wFeeFclty = FEFACL                                         CLE164
     C                   EVAL      wFeeLoan = FELOAN                                          CLE164
     C                   EVAL      wFeeSeqn = FEFSEQ                                          CLE164
                                                                                              CLE164
      ** --------------------------------------------------------- **                         CLE164
      **  Process Loan Fees tagged as pre-check order              **                         CLE164
      ** *-------------------------------------------------------- **                         CLE164
     C                   IF        FEFACL = *ZEROS AND FELOAN <> *BLANKS                      CLE164
     C                             AND FECALT <> '90'                                         CLE164
     C                   EVAL      aCAT = %SUBARR(aLoanFee:1)                                 CLE164
     C                   EXSR      ProcessMatrix                                              CLE164
     C                   ENDIF                                                                CLE164
      ** --------------------------------------------------------- **                         CLE164
      **  Process Facility Fees tagged as pre-check order          **                         CLE164
      ** *-------------------------------------------------------- **                         CLE164
     C                   IF        FEFACL <> *ZEROS AND FELOAN = *BLANKS                      CLE164
     C                             AND FECALT <> '90'                                         CLE164
     C                   EVAL      aCAT = %SUBARR(aFcltFee:1)                                 CLE164
     C                   EXSR      ProcessMatrix                                              CLE164
     C                   ENDIF                                                                CLE164
      ** --------------------------------------------------------- **                         CLE164
      **  Process Late Fees tagged as pre-check order              **                         CLE164
      ** *-------------------------------------------------------- **                         CLE164
     C                   IF        FECALT = '90'                                              CLE164
     C                   EVAL      aCAT = %SUBARR(aLateFee:1)                                 CLE164
     C                   EXSR      ProcessMatrix                                              CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * UpdateExtFile - Update Repayment Priority Details to          *                       CLE164
      *                   LEFEEZTD                                    *                       CLE164
      *                                                               *                       CLE164
      * Called by: INSERT                                             *                       CLE164
      *                                                               *                       CLE164
      * Calls: WriteExtFile                                           *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     UpdateExtFile BEGSR                                                                CLE164
                                                                                              CLE164
     C                   IF        CLE134 = *OFF                                              CLE164
     C                   LEAVESR                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   IF        PV_FEAUTO <> VFAUTO                                        CLE164
                                                                                              CLE164
     C                   IF        PV_FEAUTO <> 'C' AND VFAUTO = 'C'                          CLE164
     C                   EXSR      WriteExtFile                                               CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   IF        PV_FEAUTO =  'C' AND VFAUTO <> 'C'                         CLE164
     C                   EXSR      DeleteExtFile                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ELSE                                                                 CLE164
                                                                                              CLE164
     C                   IF        PV_FEFCOD <> VFFCOD AND VFAUTO = 'C' OR                    CLE164
     C                             PV_FECALT <> VFCALT AND VFAUTO = 'C'                       CLE164
                                                                                              CLE164
     C                   EXSR      DeleteExtFile                                              CLE164
     C                   EXSR      WriteExtFile                                               CLE164
                                                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
                                                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * DeleteExtFile - Delete Repayment Priority Details from        *                       CLE164
      *                 LEFEEZTD                                      *                       CLE164
      *                                                               *                       CLE164
      * Called by: INSERT                                             *                       CLE164
      *                                                               *                       CLE164
      * Calls: LE000506 - Midas LE Update Repayment Priority          *                       CLE164
      *        Extension Table                                        *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     DeleteExtFile BEGSR                                                                CLE164
                                                                                              CLE164
     C                   IF        CLE134 = *ON                                               CLE164
     C                   LEAVESR                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   EVAL      wLoanRef  = *BLANKS                                        CLE164
     C                   EVAL      wAction = '*DELETE'                                        CLE164
     C                   EVAL      wFile = 'LEFEEZTD'                                         CLE164
     C                   EVAL      wLoanRef  = *BLANKS                                        CLE164
     C                   EVAL      wCustomer = FECNUM                                         CLE164
     C                   EVAL      wBranch  = FEBRCA                                          CLE164
     C                   EVAL      wFeeFclty = FEFACL                                         CLE164
     C                   EVAL      wFeeLoan = FELOAN                                          CLE164
     C                   EVAL      wFeeSeqn = FEFSEQ                                          CLE164
 
     C                   CALLP     UPDATE_MATRIX(                                             CLE164
     C                               wRetCode                                                 CLE164
     C                             : wAction                                                  CLE164
     C                             : wFile                                                    CLE164
     C                             : LNRF                                                     CLE164
     C                             : wBranch                                                  CLE164
     C                             : wCustomer                                                CLE164
     C                             : wFeeFclty                                                CLE164
     C                             : wFeeLoan                                                 CLE164
     C                             : wFeeSeqn                                                 CLE164
     C                             : wLSPDPGrpID                                              CLE164
     C                             : wFTPDPGrpID                                              CLE164
     C                             : wFCPDPGrpID                                              CLE164
     C                             : wCategory                                                CLE164
     C                             )                                                          CLE164
     C                   IF        wRetCode <> *Blanks                                        CLE164
     C     *LOCK         IN        LDA                                                        CLE164
     C                   MOVE      *BLANKS       DBKEY                                        CLE164
     C                   MOVEL     'LEFEEZTD'    DBFILE                                       CLE164
     C                   Z-ADD     101           DBASE                                        CLE164
     C                   OUT       LDA                                                        CLE164
     C                   EXSR      SRERR                                                      CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDSR                                                                CLE164
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      /EJECT                                                                                  CSW208
      ********************************************************************                    CSW208
      *                                                                                       CSW208
      ** Update LTRIX header record                                                           CSW208
      *                                                                                       CSW208
     O*LTRIX**** E            TRXHDR                                                 CSW208 AR322732
     O**********             NORED               11P                                 CSW208 AR322732
     O**********             RRNAD               20P                                 CSW208 AR322732
     O**********             NLNRD               29P                                 CSW208 AR322732
     O**********             NATN                40P                                 CSW208 AR322732
      *                                                                                       CSW208
      ** Update LTRIX detail record                                                           CSW208
      *                                                                                       CSW208
     O**********E            TRXDTL                                                  CSW208 AR322732
     OLTRIX     EADD         TRXDTL                                                         AR322732
     O                       RECID                1                                           CSW208
     O                       RCDTD                2                                           CSW208
     O                       LNRFD                8                                           CSW208
     O                       VDATD               13                                           CSW208
     O                       LASND               16                                           CSW208
     O                       CHTPD               17                                           CSW208
     O                       CNRQD               18                                           CSW208
     O                       CNPRD               19                                           CSW208
     O                       REPRD               20                                           CSW208
     O                       RRLAD               25                                           CSW208
     O                       LADID               26                                           CSW208
     O                       PRI1D               27                                           CSW208
     O                       BRCAD               34                                           CSW208
     O                       RRNTD               37P                                          CSW208
     O                       NATN                40P                                          CSW208
     O                       PRI2D               41                                           CSW208
     O                       PRI3D               42                                           CSW208
     O                       PRI4D               43                                           CSW208
     O                                           44 ' '                                     AR322732
     O                                           45 ' '                                     AR322732
     C****************************************************************
**  CPY@
(c) Finastra International Limited 2002
** WLArr - Watch List Description Array                                                      BUG3760
<Receipt Nostro>                   </Receipt Nostro>                                         BUG3760
<Receipt Ordering Customer>        </Receipt Ordering Customer>                              BUG3760
<Receipt Ordering Bank>            </Receipt Ordering Bank>                                  BUG3760
<Receipt Intermediary Bank>        </Receipt Intermediary Bank>                              BUG3760
<Pay Nostro>                       </Pay Nostro>                                             BUG3760
<Pay Ordering Customer>            </Pay Ordering Customer>                                  BUG3760
<Pay Ordering Bank>                </Pay Ordering Bank>                                      BUG3760
<Pay Intermediary Bank>            </Pay Intermediary Bank>                                  BUG3760
<Receivers Correspondent>          </Receivers Correspondent>                                BUG3760
<Receiver Number>                  </Receiver Number>                                        BUG3760
<Account with Bank>                </Account with Bank>                                      BUG3760
<Beneficiary>                      </Beneficiary>                                            BUG3760
<Details of Payment>               </Details of Payment>                                     BUG3760
