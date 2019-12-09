     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits MM database update')           *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMLDNIUPM - LOANS/DEPOSITS MM DATABASE UPDATE                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR926400           Date 19Jun13               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR701789           Date 26Sep16               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 258736             Date 28Aug14               *
      *                 AR1044820          Date 30Jul13               *
      *                 AR983349           Date 05Jun12               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 249782             Date 22Aug07               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24144           Date 12May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248742             Date 30Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 227465             Date 20Sep06               *
      *                 BUG12548           Date 17Nov06               *
      *                 BUG12308           Date 24Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 240751             Date 09Jul06               *
      *                 239566             Date 04May05               *
      *                 CDL049             Date 11Jul06               *
      *                 BUG7461            Date 14Jun06               *
      *                 236684             Date 06Jun06               *
      *                 CSD027             Date 27Apr06               *
      *                 BUG10725           Date 02Mar06               *
      *                 CDL038             Date 10May05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009             Date 04May04               *
      *                 BUG7461            Date 23Jun05               *
      *                 CDL033             Date 10Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 208884             Date 29Aug02               *
      *                 BUG5517            Date 19Jan05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4347            Date 28Sep04               *
      *                 BUG4560            Date 06Sep04               *
      *                 BUG4168            Date 06Sep04               *
      *                 BUG4097            Date 01Sep04               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG3281            Date 17Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CRE020             Date 20Jan04               *
      *                 TDA012             Date 18Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 19Aug02               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      *                 209905             Date 25Sep02               *
      *                 196380             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042             Date 08Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      *                 184720             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001             Date 13Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 10Nov99               *
      *                 CDL007             Date 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 12Oct99               *
      *                 151977             DATE 11Jun99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             DATE 08Mar99               *
      *                 156618             Date 05Feb99               *
      *                 154477             Date 29Jan99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 05May98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR926400 - Unable to update Front Office ID. Allow changes   *
      *             on HKFRNT. (Child: AR926403)                      *
      *  CER050 - Annualised Percentage Rate                          *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  CGL165 - Dual Withholding Tax                                *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  258736 - Reversed 248742. Java will do the complete update   *
      *           on DLDLDCQD which is necessary for Facility Enquiry.*
      *         - Applied for MD029266C                               *
      *  AR1044820 - Incorrect projected movements for Adjustment to  *
      *              Accrued Interest. Added parameters BeDealsDtlC,  *
      *              AfDealsDtlC, and CALLER for AOOUMMU0.            *
      *              (Child: AR1044821)                               *
      *  AR983349 - Last update user ID is wrong (Child:AR983350)     *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to Midas   *
      *           Plus; and apply 249782                              *
      *  249782 - Reinitialize the value of DDACTC to blank.          *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG24144 - Missing Parameters in call to MMLDNIUPM           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248742 - Java flow is adding automatically Record in         *
      *           DLDLDCQD by SQL statement - Do it in RPG to ensure  *
      *           it is also Done by API (Updater or repair)          *
      *  227465 - Prevent front office Id from being blanked.         *
      *  BUG12548 - Serious Midas error occured when confirming       *
      *             the amendment made on a record from the WIP.      *
      *             (Recompile)                                       *
      *  BUG12308 - LDNI was unable to insert new transaction.        *
      *             Serious Midas Plus error is encountered upon      *
      *             confirmation.                                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240751 - DL imbalance occurred becaused of RODA.  Set IKORDA *
      *           to IKRBAT.                                          *
      *  239566 - Need to setup the original rollover amount to be    *
      *           used to update RBDA of the rolled over deal.        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  BUG7461 - Authorising Officer shown as QUS                   *
      *  236684 - Prevent the insertion of two deals with the same    *
      *           deal number.                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10725 - Fiduciary code/charges are not updated during     *
      *             insertion thereby causing Midasplus error in      *
      *             deal amendments                                   *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  BUG7461 - Authorising Officer shown as QUS                   *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  208884 - Delete of unauthorised deal received from interface *
      *           must send a "refused" message to the sender.        *
      *  BUG5517- Authorisation Error on LDNI.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4347 - Deal status was blanked out as a result of BUG4097 *
      *            changes.                                           *
      *  BUG4560 - We should only handle the deal status differently  *
      *            for BUG4097 if it is authorised already.           *
      *  BUG4168 - Move BUG4097 code out of *INZSR.                   *
      *  BUG4097 - Ensure Block/Unblock action leaves deal authorised *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks amended:MMLDNIMD01,MMLDNIMC10,MMLDNIMF01,*
      *                              MMLDNIMC02,MMLDNIMC17            *
      *           Core hooks added:  MMLDNIMC22,MMLDNIMC23            *
      *  BUG3281 - Discrepancies on sources                           *
      *  CGL014 - Collaterals Processing                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  TDA012 - Fix 10-digit account code processing.               *
      *  CDE005 - Data Export - Reservation ID                        *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209905 - Fiduciary API Enhancement                           *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively
      *           not  correctly  updated .  Introduced  new parametrs
      *           when  calling   ZAALTRECIN/ PAYIN  modules .        *
      *  184720 - Do not check if the Timestamp has changed on Insert.*
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CGL011 - Collateral Processing for Midas DBA                 *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a  another Midas Deal . *
      *  151977 - Amend the Midas total interest.                     *
      *  CAP006 - Check for deal being updated by another workstation *
      *  156618 - Field HKRACD not being set up when AUS007 on.       *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP004 - API's Phase 3.                                      *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FMMDEAULL  UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(MMDELDP0)
 
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                       CSD015
     F/COPY WNCPYSRC,MMH00129
                                                                                              CSD015
     FREADVCL1  UF   E           K DISK    INFSR(SRERR)                                       CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CRE020
     FMMEIRDL9  UF   E           K DISK                                                       CAS009
     F                                     COMMIT                                             CAS009
                                                                                              CAS009
     F*DLDEALL5**IF*A*E***********K*DISK*** COMMIT  USROPN                             248742 258736
      ***Missing*DLDLDCQD*Record***************************************                248742 258736
     F**********                           IGNORE(DLDLDBD0)                            248742 258736
     F**********                           IGNORE(DLDLDGD0)                            248742 258736
     F/COPY WNCPYSRC,MMLDNIMF01
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **------------------------------------------------------------------------CAP006 -------------
      ** The following /COPY line includes the definitions for error and        CAP006
      ** warning message arrays.                                                CAP006
     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** DEFINE FIELDS FOR ZDATE9
     D @DAYN           S              5P 0
     D @YMD            S              8S 0
     D @RETN           S              1A
 
      ** Timestamp for the transaction                                          CAP006
     D TimeStamp       S               Z                                        CAP006
                                                                                CAP006
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL
     D MMVLDN        E DS                  EXTNAME(MMVLDNIPD)
     D  @IKCTL                 1     23
     D  @IKDAN                36     41  0
     D  @IKVDY                50     57  0
     D  @IKTDY                58     65  0
     D  @IKDDY               111    118  0
     D  @IKSLY               179    186  0
     D  @IKNIY               205    212  0
     D  @IKIAY               237    244  0
     D  @IKMDY               252    259  0
     D  @IKALR               291    341
     D  @IKALP               342    447
     D  @IKREC               456    524
     D  @IKPY1               525    730
     D  @IKPY2               731    873
     D  @IKPY3               874   1083
     D**@IKALREx            1669   1704                                                CGL029 TDA012
     D**@IKALPEx            1705   1740                                                CGL029 TDA012
     D**@IKRECEx            1741   1758                                                CGL029 TDA012
     D**@IKPY1Ex            1759   1776                                                CGL029 TDA012
     D**@IKALREx************1720   1737                                                TDA012 CGL029
     D**@IKALPEx************1738   1755                                                TDA012 CGL029
     D**@IKRECEx************1756   1773                                                TDA012 CGL029
     D**@IKPY1Ex************1774   1791                                                TDA012 CGL029
     D  @IKCF1              1850   1896                                                       CDL033
                                                                                              CDL096
      ** Business Day Convention fields                                                       CDL096
     D  @IKDET              2148   2181                                                       CDL096
                                                                                              CDL018
      ** Tax Code Fields                                                                      CGL165
     D  @IKTXC              2182   2185                                                       CGL165
                                                                                              CGL165
     D  @IKAPR              2186   2186                                                       CER050
                                                                                              CER050
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL018
      ** File - Payment Further Settlement Instructions                                       CDL018
                                                                                              CDL018
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL018
      ** File - Receive Further Settlement Instructions                                       CDL018
 
      **  DEALS FILE - LOANS/DEPOSITS/NAS ISSUED
     D MMDELD        E DS                  EXTNAME(MMDELDPP)
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
     D  @HKCTL                 1     23
     D  @HKDDY               111    118  0
     D  @HKNIY               205    212  0
     D  @HKMDY               252    259  0
     D  @HKALR               291    341
     D  @HKALP               342    447
     D  @HKREC               456    524
     D  @HKPY1               525    730
     D  @HKPY2               731    873
     D  @HKPY3               874   1083
     D**@HKALREx            1669   1704                                                CGL029 TDA012
     D**@HKALPEx            1705   1740                                                CGL029 TDA012
     D**@HKRECEx            1741   1758                                                CGL029 TDA012
     D**@HKPY1Ex            1759   1776                                                CGL029 TDA012
     D**@HKALREx************1720   1737                                                TDA012 CGL029
     D**@HKALPEx************1738   1755                                                TDA012 CGL029
     D**@HKRECEx************1756   1773                                                TDA012 CGL029
     D**@HKPY1Ex************1774   1791                                                TDA012 CGL029
     D  @HKCF1              1850   1896                                                       CDL033
                                                                                              CDL096
      ** Business Day Convention fields                                                       CDL096
     D  @HKDET              2148   2181                                                       CDL096
      ** Tax Code Fields                                                                      CGL165
     D  @HKTXC              2182   2185                                                       CGL165
     D  @HKAPR              2186   2186                                                       CER050
 
     D ChkDealFmt    E DS                  EXTNAME(MMDELDPP)                    CAP006
      ** Rename fields for Timestamp checking                                   CAP006
     D                                     PREFIX(CH)                           CAP006
                                                                                CAP006
     D MMELDN        E DS                  EXTNAME(MMELDNIPD)                   CAP006
      * Error indicators                                                        CAP006
                                                                                CAP006
      ** Check Deal in File Format of main deal                                               CAP042
     D ChkDealFmt1   E DS                  EXTNAME(MMDELDPP)                                  CAP042
     D                                     Prefix(D1:2)                                       CAP042
     D QQDOR2        E                     EXTFLD(HKDORI)                                     CGL029
     D QQMOR2        E                     EXTFLD(HKMORI)                                     CGL029
     D QQDOP2        E                     EXTFLD(HKDOPI)                                     CGL029
     D QQMOP2        E                     EXTFLD(HKMOPI)                                     CGL029
     D QQRON2        E                     EXTFLD(HKRONS)                                     CGL029
     D QQPON2        E                     EXTFLD(HKPONS)                                     CGL029
     D QQINS2        E                     EXTFLD(HKINSA)                                     CGL029
                                                                                              CAP042
      ** Check Deal in File Format of associated deal                                         CAP042
     D ChkDealFmt2   E DS                  EXTNAME(MMDELDPP)                                  CAP042
     D                                     Prefix(D2:2)                                       CAP042
     D QQDOR3        E                     EXTFLD(HKDORI)                                     CGL029
     D QQMOR3        E                     EXTFLD(HKMORI)                                     CGL029
     D QQDOP3        E                     EXTFLD(HKDOPI)                                     CGL029
     D QQMOP3        E                     EXTFLD(HKMOPI)                                     CGL029
     D QQRON3        E                     EXTFLD(HKRONS)                                     CGL029
     D QQPON3        E                     EXTFLD(HKPONS)                                     CGL029
     D QQINS3        E                     EXTFLD(HKINSA)                                     CGL029
                                                                                              CAP042
      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D DLDLQD        E DS                  EXTNAME(DLSTMPPD)                                  CER049
 
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      * DATA STRUCTURE FOR DEAL DATA CODES
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR MODULE DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
      * DATA STRUCTURE FOR SWITCHABLE FEATURE DETAILS                           CAP051
                                                                                CAP051
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CAP042
      ** External DS for General Ledger ICD                                                   CAP042
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CAP042
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
                                                                                208884
     D InvRp         E DS                  EXTNAME(MMILDNIPD)                   208884
     D                                     PREFIX(R:2)                          208884
 
      * RUN DATE & MULTI-BRANCHING INDICATOR
 
     D RUNDAT          DS
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  @MBIN                 13     13
                                                                                              CAP042
     D ZMUSER        E DS                  EXTNAME(ZMUSER)                                    CAP042
                                                                                CAP006
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
                                                                                CAP006
     D***CDL006*         S              1A   IMPORT                                  CDL006 BUG10725
                                                                                CDL006
     D CDL006          S              1A                                                    BUG10725
     D CDL096          S              1A                                                      CDL096
     D CGL165          S              1A                                                      CGL165
     D CER050          S              1A                                                      CER050
     D/COPY WNCPYSRC,MMLDNIMD02
     D CAP042          S              1A                                                      CAP042
     D PLnkFlag        S              1A                                                      CAP042
     D DDBRC2          S              3A                                                      CAP042
     D OKBRC2          S              1A                                                      CAP042
                                                                                              CAP042
     D CSC011          S              1A   INZ('N')                                           CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D WTimestamp      S             26A                                                      CSC011
     D***PDealNo         S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D WDealNo         S              6A                                                      CSC011
                                                                                              CSC011
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D WFIDTUPF        S              1A                                                      209905
      ** Index for arrays of of warning message ids etc                                       CAS004
     D WIdx            S              3P 0                                                    CAS004
                                                                                              CAS004
      ** Define fields used in CDL010                                                         CDL010
     D CDL010          S              1A                                                      CDL010
                                                                                              CDL010
      ** Fields used for CSD015                                                               CSD015
                                                                                              CSD015
      ** External DS for Compliance Watch Transaction Details                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Watch List Transaction Details Data Structure.                                       CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Customer Details                                                     CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Watch List Configuration Data File                                   CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ** DS for access programs, Long Data Structure                                          CSD015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
     D/COPY WNCPYSRC,MMH00130
                                                                                              CSD015
      ** Compliance Engine Free Format String Parameter.                                      CSD015
     D PFreeFmtStr     S          30000A                                                      CSD015
                                                                                              CSD015
      ** Array Size Definition                                                                CSD015
     D Elements        C                   CONST(13)                                          CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine                                           CSD015
     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine                                           CSD015
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
                                                                                              CSD015
      ** Watch List Fields Array.                                                             CSD015
     D**WLF*****         S             18A   DIME(Elements)                            CSD015 CGL029
     D WLF             S             24A   DIM(Elements)                                      CGL029
                                                                                              CSD015
     D CSD015          S              1                                                       CSD015
     D CCF001          S              1                                                       CSD015
     D WFuncType       S              8                                                       CSD015
     D WIdntifier      S             40                                                       CSD015
     D WBranch         S              3                                                       CSD015
     D WLChgFlg        S              1    INZ('N')                                           CSD015
     D WLOKFlg         S              1    INZ('N')                                           CSD015
     D WDtlOPay        S              1                                                       CSD015
     D WXMLPacket      S            310                                                       CSD015
     D WData           S            216                                                       CSD015
     D WDate           S             10                                                       CSD015
     D WDateTemp4      S              4                                                       CSD015
     D WDateTemp2A     S              2                                                       CSD015
     D WDateTemp2B     S              2                                                       CSD015
     D Ctr             S              2P 0                                                    CSD015
     D PFunc           S              8                                                       CSD015
     D PCust           S             10                                                       CSD015
     D PStKey          S              7                                                       CSD015
     D ConvertedDate   S               D                                                      CSD015
     D ConvertedAmt    S             18P 3                                                    CSD015
     D PDate           S              5                                                       CSD015
     D PAmt            S             15                                                       CSD015
     D PFmtCCY         S              3                                                       CSD015
     D PDummy6         S              6                                                       CSD015
     D PDummy10        S             10                                                       CSD015
     D PDummy16        S             16                                                       CSD015
     D PDummy35        S             35                                                       CSD015
     D ##PONS          S             18                                                       CGL029
     D ##RONS          S             18                                                       CGL029
     D ##DOPI          S             18                                                       CGL029
     D ##DORI          S             18                                                       CGL029
     D ##MOPI          S             18                                                       CGL029
     D ##MORI          S             18                                                       CGL029
     D T#TREF          S             26                                                       CGL029
 
 
      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
     D/COPY WNCPYSRC,MMH00131
                                                                                              CAS005
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('MMLDNIUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('LoansDeposNAsIssued ')                        CRE020
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
                                                                                              CRE020
     D CAS009          S              1A                                                      CAS009
                                                                                              CAS009
     D CER020          S              1A                                                      CER020
      *                                                                                       CER020
     D/COPY WNCPYSRC,MMLDNIMD01
      *                                                                                    AR1044820
      ** DS for DEALSDC - Before being updated by a program.                               AR1044820
      *                                                                                    AR1044820
     D BeDealsDtlC   E DS                  EXTNAME(DEALSDC)                                AR1044820
     D                                     PREFIX(BE_)                                     AR1044820
      *                                                                                    AR1044820
      ** DS for DEALSDC - After being updated by a program.                                AR1044820
      *                                                                                    AR1044820
     D AfDealsDtlC   E DS                  EXTNAME(DEALSDC)                                AR1044820
     D                                     PREFIX(AF_)                                     AR1044820
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
     C/COPY WNCPYSRC,MMLDNIMC01
      *                                                                                      BUG5517
      **  Get default branch and user from ZMUSER                                            BUG5517
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C                   IN        ZMUSER                                                    BUG5517
     C                   UNLOCK    ZMUSER                                                    BUG5517
     C**********         EVAL      PSUser = USRID                                    BUG7461 BUG7461
     C                   EVAL      PSUser = USRID                                           AR983349
     C*                                                                                       249782
     C** Make sure DDACTC is blank before processing                                          249782
     C*                                                                                       249782
     C                   MOVE      *BLANK        DDACTC                                       249782
     C*                                                                                      BUG4168
     C** Setup the Block/Unblock condition from the Return code parameter from MMLDNIVU.     BUG4168
     C*                                                                                      BUG4168
     C     @@RTCD        IFEQ      'BLOCK  '                                                 BUG4168
     C                   MOVE      'B'           DDACTC            1                         BUG4168
     C                   END                                                                 BUG4168
     C*                                                                                      BUG4168
     C     @@RTCD        IFEQ      'UNBLOCK'                                                 BUG4168
     C                   MOVE      'U'           DDACTC                                      BUG4168
     C                   END                                                                 BUG4168
     C*                                                                                      BUG4097
     C***After**INZSR*@@RTCD*will*need*resetting.                                    BUG4097 BUG4168
     C*                                                                                      BUG4097
     C     @@RTCD        IFEQ      'BLOCK  '                                                 BUG4097
     C     @@RTCD        OREQ      'UNBLOCK'                                                 BUG4097
     C                   MOVE      *BLANKS       @@RTCD                                      BUG4097
     C                   END                                                                 BUG4097
     C*                                                                                      BUG4097
                                                                                              209905
      ** Check if called from MMFIDTUPF                                                       209905
                                                                                              209905
     C                   EVAL      WFIDTUPF = 'N'                                             209905
                                                                                              209905
     C                   IF        (@@RTCD <> *BLANK) AND (@@RTCD = 'FIDTUPF')                209905
     C                   EVAL      WFIDTUPF = 'Y'                                             209905
     C                   EVAL      @@RTCD = *BLANKS                                           209905
     C                   ENDIF                                                                209905
 
      *
      ** INITIALIZE WORK FIELDS
      *
     C                   MOVEL     *BLANK        Z#BSTS
     C                   MOVEL     *BLANK        Z#ASTS
     C                   MOVEL     *BLANK        Z#WSTS
      *                                                                         CAP051
      ***  Transaction coming from Interface require an Automatic Authorisation CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C     IKAUTH        ANDEQ     'Y'                                          CAP051
     C     CAP042        OREQ      'Y'                                                        CAP042
     C     IKMTYP        ANDEQ     'IL'                                                       CAP042
     C     CAP042        OREQ      'Y'                                                        CAP042
     C     IKMTYP        ANDEQ     'ID'                                                       CAP042
     C                   MOVE      'N'           BNMMAU                         CAP051
     C                   MOVE      'N'           BNMMRA                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      SAVMAU        BNMMAU                         CAP051
     C                   MOVE      SAVMRA        BNMMRA                         CAP051
     C                   ENDIF                                                  CAP051
      *
      * SET CONTROL FIELDS
      *
     C                   EXSR      SETCTL
      *
      ** Ensure transaction has not been updated by another workstation         CAP006
      ** - if so, bypass updating and return to calling program.                CAP006
     C                   EXSR      CHKOTHUPD                                    CAP006
                                                                                CAP006
     C     @@RTCD        IFNE      *BLANKS                                      CAP006
     C                   GOTO      EXIT                                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      * DO INSERT, AMEND, AUTHORIZE OR DELETE PROCESSING
      *
     C     IKLACT        CASEQ     'I'           INSERT
     C     IKLACT        CASEQ     'A'           AMEND
     C     IKLACT        CASEQ     'X'           AUTHOR
     C     IKLACT        CASEQ     'D'           DELETE
     C                   END
     C/COPY WNCPYSRC,MMLDNIMC03
      *
      ** DO ON-LINE UPDATES
      *
     C     IKLACT        IFEQ      'I'
     C     IKLACT        OREQ      'A'
     C     IKLACT        OREQ      'D'
     C                   EXSR      ONLNUP
     C                   END
      *
      *
      ** DO TREASURY MANAGEMENT UPDATES
      *
     C     BGTRMG        IFEQ      'Y'
     C     IKLACT        IFEQ      'I'
     C     IKLACT        OREQ      'A'
     C     IKLACT        OREQ      'D'
     C                   EXSR      TREAUP
     C                   END
     C                   END
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed, write to the standard                       CSC011
      ** log file when support system is active                                               CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
     C                             AND WFIDTUPF = 'N'                                         209905
                                                                                              CSC011
      ** Setup Loans/Deposits support log                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'MMLDNILOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    IKLACT                                       CSC011
     C                   PARM                    MMVLDN                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** Write to support database log file                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   IF        IKTYPE = 'ID' OR                                           CSC011
     C                             IKTYPE = 'IL'                                              CSC011
     C                   EVAL      APTGTTYPE = 'ABFUND'                                       CSC011
     C                   ELSE                                                                 CSC011
     C                   IF        REPOFlag = 'Y'                                             CSC011
     C                   EVAL      APTGTTYPE = 'MMRPLD'                                       CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      APTGTTYPE = 'MMLDNI'                                       CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
     C                   EVAL      APRPRLOCN = IKREPA                                         CSC011
     C                   MOVEL     IKFRNT        APFOTRANID                                   CSC011
     C                   MOVEL     IKAFRT        APFOASOCID                                   CSC011
     C                   MOVEL     IKDN38        PDealNo                                      CSC011
     C                   EVAL      PADealNo = *BLANKS                                         CSC011
     C                   IF        IKTYPE <> 'ID'                                             CSC011
     C                   MOVEL     IKDADN        PADealNo                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        IKTYPE <> 'IL'                                             CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       WTimestamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM                    PADealNo                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If error occured,                                                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
                                                                                              CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      * EXIT FROM PROGRAM
     C     EXIT          TAG                                                    CAP006
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* INSERT - Loan/Deposit Inserts                                 *
     C*                                                               *
     C*****************************************************************
     C     INSERT        BEGSR
     C*
     C**  SET DEAL FIELDS ON INSERT
     C*
     C                   EXSR      SETINS
     C*
     C**  ACCESS DEAL
     C*
     C                   CLEAR                   MMDELD
     C     IKDN38        CHAIN     MMDELDP0                           99
     C*                                                                                       236684
     C**  DATA BASE ERROR                                                                     236684
     C*                                                                                       236684
     C     *IN99         IFEQ      '0'                                                        236684
     C                   MOVEL     IKDN38        DBKEY                                        236684
     C                   MOVEL     'MMDELDP0'    DBFILE                         ************  236684
     C                   MOVEL     '005'         DBASE                          * DBERR 005*  236684
     C                   EXSR      SRERR                                        ************  236684
     C                   END                                                                  236684
     C/COPY WNCPYSRC,MMLDNIMC14
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDELD        Z#BSTS
     C*
     C**  UPDATE DEAL
     C*
     C                   MOVEL     MMVLDN        MMDELD
     C**********         Z-ADD     IKRRAT        HKRRAT                            BUG12308 BUG24144
     C                   Z-ADD     *ZERO         HKRRAT                                     BUG24144
     C                                                                                        CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   IF        IKORDN = *BLANKS                                           CER020
     C                   MOVEL     IKDN38        HKORDN                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HKTMST  = TimeStamp                          CAP006
                                                                                CAP006
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        HKFRNT = *BLANKS                                           CSC011
     C                   IF        HKMTYP = 'ID'                                              CSC011
     C                   MOVEL     HKDADN        WDealNo                                      CSC011
     C                   ELSE                                                                 CSC011
     C                   MOVEL     HKDN38        WDealNo                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   EVAL      HKFRNT = 'MD' + WDealNo                                    CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
                                                                                              CSD015
     C                   MOVEL     HKRONS        WLF(1)                                       CSD015
     C                   MOVEL     HKROCN        WLF(2)                                       CSD015
     C                   MOVEL     HKRIBN        WLF(3)                                       CSD015
     C                   MOVEL     HKROBN        WLF(4)                                       CSD015
     C                   MOVEL     HKPONS        WLF(5)                                       CSD015
     C                   MOVEL     HKPOCN        WLF(6)                                       CSD015
     C                   MOVEL     HKRVNO        WLF(7)                                       CSD015
     C                   MOVEL     HKRCRN        WLF(8)                                       CSD015
     C                   MOVEL     HKPIBN        WLF(9)                                       CSD015
     C                   MOVEL     HKPOBN        WLF(10)                                      CSD015
     C                   MOVEL     HKAWBN        WLF(11)                                      CSD015
     C                   MOVEL     HKBENN        WLF(12)                                      CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   DOU       Ctr > Elements                                             CSD015
                                                                                              CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                   EVAL      WLOKFlg = 'Y'                                              CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
                                                                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
     C                   IF        WLOKFlg = 'Y'                                              CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C*  WRITE (OR UPDATE IF PRESENT) NEW DEAL
     C*
     C     *IN99         IFEQ      '0'
     C                   UPDATE    MMDELDP0
     C/COPY WNCPYSRC,MMLDNIMC15
     C                   ELSE
     C                   WRITE     MMDELDP0
     C/COPY WNCPYSRC,MMLDNIMC13
     C                   END
     C/COPY WNCPYSRC,MMLDNIMC02
      *****************************************************************                248742 258736
      ***Write*Missing*DLDLDCQD*record*if*it*possible******************                248742 258736
      *****************************************************************                248742 258736
     C**********         OPEN      DLDEALL5                             99             248742 258736
     C**N99*****         Do                                                            248742 258736
     C**********         Move      IKDN38        KEY_CQD           6                   248742 258736
     C*****KEY_CQD       Setll     DLDLDCD0                               99           248742 258736
     C******IN99         IFEQ      *OFF                                                248742 258736
     C**********         Reset                   DLDLDCD0                              248742 258736
     C**********         MOVE      IKBRCA        F1BRCA                                248742 258736
     C**********         MOVE      IKDN38        F1DLNO                                248742 258736
     C**********         Write     DLDLDCD0                                            248742 258736
     C**********         Endif                                                         248742 258736
     C**********         Close     DLDEALL5                             99             248742 258736
     C**********         Enddo                                                         248742 258736
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDELD        Z#ASTS
     C*
     C**  IF ASSOCIATED DEAL FOUND ON DEALS FILE
     C*
     C     IKDADN        IFNE      *BLANKS
     C     IKDADN        ANDNE     *ZEROS
     C     IKMTYP        ANDNE     'IL'
     C     IKMTYP        ANDNE     'ID'
     C*
     C     @IKDAN        CHAIN     MMDELDP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @IKDAN        DBKEY
     C                   MOVEL     'MMDELDP0'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE ROLLOVER DETAILS ON ROLLED OVER DEAL
     C*
     C                   MOVEL     @IKCTL        @HKCTL
     C                   MOVEL     IKDN38        HKROBY
     C                   MOVEL     'O'           HKRBSI
     C                   MOVEL     'Y'           HKWRPI
      *                                                                         CAP004
      * If rollover from/to currency is present (when CEU015 is switched on)    CAP004
      * on rollover deal, update same field on rolled over deal.
      *                                                                         CAP004
     C     IKRTFC        IFNE      *BLANKS                                      CAP004
     C                   MOVE      IKCCY         HKRTFC                         CAP004
     C                   ELSE                                                   CAP004
     C                   MOVE      *BLANKS       HKRTFC                         CAP004
     C                   ENDIF                                                  CAP004
      *                                                                         CAP004
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HKTMST  = TimeStamp                          CAP006
                                                                                CAP006
      **                                                                        CAP051
      ** Automatic Authorisation flag                                           CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   MOVEL     IKAUTH        HKAUTH                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      *BLANKS       HKAUTH                         CAP051
     C                   ENDIF                                                  CAP051
      *                                                                                       CDL010
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   UPDATE    MMDELDP0
     C*
     C**  SAVE RELATED DEAL AMOUNT
     C*
     C                   Z-ADD     HKAMNP        IKRBAT
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AMEND - Loan/Deposit Amends                                   *
     C*                                                               *
     C*****************************************************************
     C     AMEND         BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     IKDN38        CHAIN     MMDELDP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IKDN38        DBKEY
     C                   MOVEL     'MMDELDP0'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
      * Set EIR Recalculation Indicator to 'Y' when interest payment                          CAS009
      * or maturity date is amended and deal is found in MMEIRDPD                             CAS009
      *                                                                                       CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
      *                                                                                       CAS009
     C                   IF        IKMATD <> HKMATD                                           CAS009
     C                             OR IKIPFQ <> HKIPFQ                                        CAS009
     C                             OR IKNIPD <> HKNIPD                                        CAS009
     C                             OR IKIPDM <> HKIPDM                                        CAS009
      *                                                                                       CAS009
     C     IKDN38        CHAIN     MMEIRDL9                                                   CAS009
     C                   IF        %FOUND(MMEIRDL9)                                           CAS009
      *                                                                                       CAS009
     C                   EVAL      EIRCAL = 'Y'                                               CAS009
      *                                                                                       CAS009
     C                   IF        IKMATD <> HKMATD                                           CAS009
     C                             AND IKMATD <= EIENDT                                       CAS009
     C                   EVAL      EIADJP = 'Y'                                               CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C                   UPDATE    MMEIRDD0                                                   CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDELD        Z#BSTS
     C/COPY WNCPYSRC,MMLDNIMC04
     C*
     C**  SET DEAL FIELDS ON AMEND
     C*
     C                   EXSR      SETAMD
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HKTMST  = TimeStamp                          CAP006
                                                                                CAP006
                                                                                              CSD015
     C                   If        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType ='MMDELDPP'                                      CSD015
     C                   MOVEL     HKDN38        WIdntifier                                   CSD015
     C                   EVAL      WBranch = HKBRCA                                           CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                          CSD015
     C                   MOVEL     HKRONS        WLF(1)                                       CSD015
     C                   MOVEL     HKROCN        WLF(2)                                       CSD015
     C                   MOVEL     HKRIBN        WLF(3)                                       CSD015
     C                   MOVEL     HKROBN        WLF(4)                                       CSD015
     C                   MOVEL     HKPONS        WLF(5)                                       CSD015
     C                   MOVEL     HKPOCN        WLF(6)                                       CSD015
     C                   MOVEL     HKRVNO        WLF(7)                                       CSD015
     C                   MOVEL     HKRCRN        WLF(8)                                       CSD015
     C                   MOVEL     HKPIBN        WLF(9)                                       CSD015
     C                   MOVEL     HKPOBN        WLF(10)                                      CSD015
     C                   MOVEL     HKAWBN        WLF(11)                                      CSD015
     C                   MOVEL     HKBENN        WLF(12)                                      CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   MOVEA     *BLANKS       WLF                                          CSD015
                                                                                              CSD015
     C                   IF        HKRONS <> CHHKRONS                                         CSD015
     C                   MOVEL     HKRONS        WLF(1)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKROCN <> CHHKROCN                                         CSD015
     C                   MOVEL     HKROCN        WLF(2)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKRIBN <> CHHKRIBN                                         CSD015
     C                   MOVEL     HKRIBN        WLF(3)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKROBN <> CHHKROBN                                         CSD015
     C                   MOVEL     HKROBN        WLF(4)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKPONS <> CHHKPONS                                         CSD015
     C                   MOVEL     HKPONS        WLF(5)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKPOCN <> CHHKPOCN                                         CSD015
     C                   MOVEL     HKPOCN        WLF(6)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKRVNO <> CHHKRVNO                                         CSD015
     C                   MOVEL     HKRVNO        WLF(7)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKRCRN <> CHHKRCRN                                         CSD015
     C                   MOVEL     HKRCRN        WLF(8)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKPIBN <> CHHKPIBN                                         CSD015
     C                   MOVEL     HKPIBN        WLF(9)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKPOBN <> CHHKPOBN                                         CSD015
     C                   MOVEL     HKPOBN        WLF(10)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKAWBN <> CHHKAWBN                                         CSD015
     C                   MOVEL     HKAWBN        WLF(11)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        HKBENN <> CHHKBENN                                         CSD015
     C                   MOVEL     HKBENN        WLF(12)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      WDtlOPay = 'N'                                             CSD015
     C                   IF        HKDTP1 <> CHHKDTP1 OR                                      CSD015
     C                             HKDTP2 <> CHHKDTP2 OR                                      CSD015
     C                             HKDTP3 <> CHHKDTP3 OR                                      CSD015
     C                             HKDTP4 <> CHHKDTP4                                         CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   EVAL      WDtlOPay = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
                                                                                              CSD015
     C                   IF        WLChgFlg = 'Y'                                             CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C**  UPDATE RECORD
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   UPDATE    MMDELDP0
     C/COPY WNCPYSRC,MMLDNIMC17
      *****************************************************************                248742 258736
      ***Write*Missing*DLDLDCQD*record*if*it*possible******************                248742 258736
      *****************************************************************                248742 258736
     C**********         OPEN      DLDEALL5                             99             248742 258736
     C**N99*****         Do                                                            248742 258736
     C**********         Move      IKDN38        KEY_CQD           6                   248742 258736
     C*****KEY_CQD       Setll     DLDLDCD0                               99           248742 258736
     C******IN99         IFEQ      *OFF                                                248742 258736
     C**********         Reset                   DLDLDCD0                              248742 258736
     C**********         MOVE      IKBRCA        F1BRCA                                248742 258736
     C**********         MOVE      IKDN38        F1DLNO                                248742 258736
     C**********         Write     DLDLDCD0                                            248742 258736
     C**********         Endif                                                         248742 258736
     C**********         Close     DLDEALL5                             99             248742 258736
     C**********         Enddo                                                         248742 258736
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDELD        MMVLDN
     C**********         Z-ADD     HKRRAT        IKRRAT                            BUG12308 BUG24144
     C                   Z-ADD     *ZERO         IKRRAT                                     BUG24144
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDELD        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AUTHOR - Loan/Deposit Authorize                               *
     C*                                                               *
     C*****************************************************************
     C     AUTHOR        BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     IKDN38        CHAIN     MMDELDP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IKDN38        DBKEY
     C                   MOVEL     'MMDELDP0'    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDELD        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON AUTHORIZE
     C*
     C                   EXSR      SETAUT
     C/COPY WNCPYSRC,MMH00138
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HKTMST  = TimeStamp                          CAP006
                                                                                CAP006
     C/COPY WNCPYSRC,MMLDNIMC07
     C**  UPDATE RECORD
     C*
      ** User Authorisation details when CDL010 is ON                                         CDL010
                                                                                              CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EVAL      IKUSER = USRID                                            BUG7461
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CDL010
     C                   UPDATE    MMDELDP0
      *****************************************************************                248742 258736
      ***Write*Missing*DLDLDCQD*record*if*it*possible******************                248742 258736
      *****************************************************************                248742 258736
     C**********         OPEN      DLDEALL5                             99             248742 258736
     C**N99*****         Do                                                            248742 258736
     C**********         Move      IKDN38        KEY_CQD           6                   248742 258736
     C*****KEY_CQD       Setll     DLDLDCD0                               99           248742 258736
     C******IN99         IFEQ      *OFF                                                248742 258736
     C**********         Reset                   DLDLDCD0                              248742 258736
     C**********         MOVE      IKBRCA        F1BRCA                                248742 258736
     C**********         MOVE      IKDN38        F1DLNO                                248742 258736
     C**********         Write     DLDLDCD0                                            248742 258736
     C**********         Endif                                                         248742 258736
     C**********         Close     DLDEALL5                             99             248742 258736
     C**********         Enddo                                                         248742 258736
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDELD        MMVLDN
     C**********         Z-ADD     HKRRAT        IKRRAT                            BUG12308 BUG24144
     C                   Z-ADD     *ZERO         IKRRAT                                     BUG24144
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDELD        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DELETE - Loan/Deposit Deletes                                 *
     C*                                                               *
     C*****************************************************************
     C     DELETE        BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     IKDN38        CHAIN     MMDELDP0                           99
     C*
     C**  DATA BASE ERROR IF NOT FOUND
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IKDN38        DBKEY
     C                   MOVEL     'MMDELDP0'    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDELD        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON DELETE
     C*
     C                   EXSR      SETDEL
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HKTMST  = TimeStamp                          CAP006
                                                                                CAP006
      ** Send a User Defined Journal Entry to simulate a delete from repair     208884
     C     HKDSTS        IFNE      'A'                                          208884
     C     HKDSTS        ANDNE     'R'                                          208884
     C     HKFRNT        ANDNE     *BLANKS                                      208884
     C                   MOVE      'D'           RACTN                          208884
     C                   MOVE      HKFRNT        RFOTRANID                      208884
     C                   MOVE      HKDN38        RDLNO                          208884
     C                   MOVEL     *BLANKS       EntryData                      208884
     C                   MOVEL     *BLANKS       FileName                       208884
     C                   CALL      'RPC1600'                                    208884
     C                   PARM      InvRp         EntryData      3000            208884
     C                   PARM      'MMILDNIPD'   FileName         10            208884
     C                   ENDIF                                                  208884
     C*                                                                         208884
     C**  UPDATE RECORD
     C*
     C                   UPDATE    MMDELDP0
     C/COPY WNCPYSRC,MMLDNIMC23
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDELD        MMVLDN
     C**********         Z-ADD     HKRRAT        IKRRAT                            BUG12308 BUG24144
     C                   Z-ADD     *ZERO         IKRRAT                                     BUG24144
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDELD        Z#ASTS
     C*
     C**  UPDATE RELATED DEAL
     C*
     C     IKDADN        IFNE      *BLANKS
     C     IKDADN        ANDNE     *ZEROS
     C     IKMTYP        ANDNE     'IL'
     C     IKMTYP        ANDNE     'ID'
      *
     C     @IKDAN        CHAIN     MMDELDP0                           99
     C     *IN99         IFNE      '1'
     C                   MOVEL     *BLANKS       HKROBY
     C                   MOVEL     *BLANK        HKRBSI
     C                   MOVE      *BLANKS       HKWRPI                         CAP004
     C                   MOVE      *BLANKS       HKRTFC                         CAP004
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HKTMST  = TimeStamp                          CAP006
     C                   UPDATE    MMDELDP0
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT                                                                                  CDL010
     C****************************************************************                        CDL010
     C*                                                              *                        CDL010
     C* USRUPD    - Update the Last Amend/Insert User field .        *                        CDL010
     C*                                                              *                        CDL010
     C****************************************************************                        CDL010
     C     USRUPD        BEGSR                                                                CDL010
      *                                                                                       CDL010
      **  Update User Details                                                                 CDL010
      *                                                                                       CDL010
     C     IKUSER        IFEQ      *BLANKS                                                    CDL010
     C                   EVAL      HKUSER = PSuser                                            CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      HKUSER = IKUSER                                            CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   ENDSR                                                                CDL010
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETINS - SET DEAL FIELDS ON INSERT                            *
     C*                                                               *
     C*****************************************************************
     C     SETINS        BEGSR
      *                                                                                       CGL011
      ** Initialise Collateral Flag and Amount                                                CGL011
      *                                                                                       CGL011
     C     CGL011        IfEq      'Y'                                                        CGL011
     C                   Move      *BLANK        HKCOLF                                       CGL011
     C                   Z-Add     *ZEROS        HKCOLA                                       CGL011
     C                   EndIf                                                                CGL011
     C**********         Z-ADD     *ZEROS        IKBCAM                               CGL014 BUG3281
     C                   Z-ADD     *ZEROS        HKBCAM                                      BUG3281
     C                   Z-ADD     *ZEROS        IKCAND                                       CDL017
      **
      ** Deal value date - yyyy       IKVDYY
      ** Deal value date - mm         IKVDMM
      ** Deal value date - dd         IKVDDD
      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
     C*
     C                   Z-ADD     IKDVSD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IKVDY
      **
      ** Deal transaction date - yyyy IKDTYY
      ** Deal transaction date - mm   IKDTMM
      ** Deal transaction date - dd   IKDTDD
      **  CONVERT RUN DATE FROM DAY NUMBER TO YMD
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IKTDY
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'I'           @@ACTN            1
     C                   PARM      *BLANK        @@CSTS            1
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS            1
     C                   PARM      *BLANK        @@CHTP            1
     C                   MOVEL     @@FSTS        IKDSTS
     C                   MOVEL     @@CHTP        IKCHTP
     C/COPY WNCPYSRC,MMLDNIMC09
      **
      ** MIDAS deal type
      **
     C                   MOVEL     IKTYPE        IKMTYP
      **
      ** Rollover/bought/sold indic
      **
     C*****IKDADN        IFEQ      *BLANKS                                                    CAP042
     C*****IKDADN        OREQ      *ZEROS                                                     CAP042
     C                   IF        IKDADN = *BLANKS OR IKDADN = *ZEROS OR                     CAP042
     C                             IKTYPE = 'IL' AND CAP042 = 'Y' OR                          CAP042
     C                             IKTYPE = 'ID' AND CAP042 = 'Y'                             CAP042
     C                   MOVEL     *BLANKS       IKRBSI
     C                   ELSE
     C                   MOVEL     'N'           IKRBSI
     C                   END
      **
      ** Deal type (OLD DRS DEAL TYPE)
      **
     C     IKTYPE        IFEQ      'TI'
     C                   MOVEL     'TL'          IKTYPE
     C                   END
      *
     C     IKTYPE        IFEQ      'CD'
     C                   MOVEL     'CT'          IKTYPE
     C                   END
      *
     C     IKTYPE        IFEQ      'CL'
     C                   MOVEL     'CP'          IKTYPE
     C                   END
      *
     C     IKTYPE        IFEQ      'LN'
     C                   MOVEL     'CL'          IKTYPE
     C                   END
      **
      ** Deal done date - yyyy        IKDDYY
      ** Deal done date - mm          IKDDMM
      ** Deal done date - dd          IKDDDD
      **
     C                   Z-ADD     IKDDND        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IKDDY
      **
      ** Time of input
      **
     C                   TIME                    IKTIME
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        IKDUSC
      **
      ** Deal authorisation officer
      **
     C     @@FSTS        IFEQ      'A'
     C                   MOVEL     PSUser        IKAOFR
     C                   END
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          IKLDAT
      **
      ** Start/last interst year date IKSLYY
      ** Start/last interst mnth date IKSLMM
      ** Start/last interest day date IKSLDD
      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
     C*
     C                   Z-ADD     IKDVSD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IKSLY
      **
      ** Nxt intrst pay year date     IKNIYY
      ** Nxt intrst paym mth date     IKNIMM
      ** Next int payment day date    IKNIDD
      **  CONVERT NEXT INT PAY DATE FROM DAY NUMBER TO YMD
      *
     C     IKNIPD        IFNE      *ZERO
     C                   Z-ADD     IKNIPD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IKNIY
     C                   ELSE
     C                   Z-ADD     *ZERO         @IKNIY
     C                   END
      **
      ** Call/notice indicator
      **
     C     IKMATD        IFGT      *ZERO
     C                   MOVEL     *BLANKS       IKCNTI
     C                   ELSE
     C     IKNTCE        IFEQ      *ZEROS
     C                   MOVEL     'C'           IKCNTI
     C                   ELSE
     C                   MOVEL     'N'           IKCNTI
     C                   END
     C                   END
      **
      ** Interest accrual contr year  IKIAYY
      ** Intrst accrual contr method  IKIAMM
      ** Intrst accrual contr day     IKIADD
      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
      *
     C                   Z-ADD     IKDVSD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IKIAY
      **
      ** Midas base rate code
      **
     C                   MOVE      IKDBSR        IKBSRC
      **
      ** Maturity date year           IKMDYY
      ** Maturity date month          IKMDMM
      ** Maturity date day            IKMDDD
      **
     C     IKMATD        IFNE      *ZERO
     C                   Z-ADD     IKMATD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IKMDY
     C                   ELSE
     C                   Z-ADD     *ZERO         @IKMDY
     C                   END
      **
      ** Interest at maturity = Midas total interest
      **
     C                   IF        IKTYPE <> 'IL' and                                         CAP042
     C                             IKTYPE <> 'ID'                                             CAP042
     C                   Z-ADD     IKMTTI        IKIMAT
     C                   ENDIF                                                                CAP042
      **                                                                        CDL007
      ** Breakdown fields                                                       CDL007
      **                                                                        CDL007
     C                   Z-ADD     0             IKPENA                         CDL007
     C                   Z-ADD     0             IKOMDT                         CDL007
     C                   MOVE      *BLANKS       IKBUSR                         CDL007
     C                   MOVE      *BLANKS       IKPRIN                         CDL007
      **
      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
      **
     C                   EXSR      ALRECI
      **
      ** ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS
      **
     C                   EXSR      ALPAYI
      **
      ***If*the*deal*is*created*from*Euro*Rollover,*set*up*the*original                239566 240751
      ***rollover*amount*in*'IN'*currency.*****************************                239566 240751
      *****************************************************************                239566 240751
     C**********         IF        CEU015 = 'Y'                                        239566 240751
     C**********                   AND IKRTFC <> *BLANKS                               239566 240751
     C**********                   AND IKRTFC <> IKCCY                                 239566 240751
     C**********         EXSR      SetORDA                                             239566 240751
     C**********         ENDIF                                                         239566 240751
      *****************************************************************                239566 240751
     C                   Z-ADD     IKRBAT        IKORDA                                       240751
     C                   ENDSR
      ***/EJECT********************************************************                239566 240751
     C*****************************************************************                239566 240751
     C*****************************************************************                239566 240751
     C**SetORDA**-*Setup*the*Original*Rollover*Amount*in*Original******                239566 240751
     C*************Currency.*******************************************                239566 240751
     C*****************************************************************                239566 240751
     C*****************************************************************                239566 240751
     C*****SetORDA       BEGSR                                                         239566 240751
      *****************************************************************                239566 240751
     C**********         CALL      'EU0200'                                            239566 240751
     C**********         PARM      *BLANKS       P@RTCD            7                   239566 240751
     C**********         PARM      IKAMNP        P@FRAM           18 3                 239566 240751
     C**********         PARM      IKCCY         P@FRCY            3                   239566 240751
     C**********         PARM      IKRTFC        P@TOCY            3                   239566 240751
     C**********         PARM      *ZERO         P@OUTA           15 0                 239566 240751
     C**********         PARM                    P@INTA           18 3                 239566 240751
     C**********         PARM                    P@EXRT           15 9                 239566 240751
     C**********         PARM                    P@MDIN            1                   239566 240751
      *****************************************************************                239566 240751
      **DATABASE*ERROR*************************************************                239566 240751
      *****************************************************************                239566 240751
     C*****P@RTCD        IFEQ      '*ERROR*'                                           239566 240751
     C**********         MOVEL     'EU0200'      DBFILE                                239566 240751
     C**********         MOVE      '913'         DBASE                                 239566 240751
     C**********         MOVEL     HKCCY         DBKEY                                 239566 240751
     C**********         EXSR      SRERR                                               239566 240751
     C**********         ELSE                                                          239566 240751
     C**********         EVAL      IKORDA = P@OUTA                                     239566 240751
     C**********         ENDIF                                                         239566 240751
      *****************************************************************                239566 240751
     C**********         ENDSR                                                         239566 240751
     C*****************************************************************                239566 240751
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETAMD - SET DEAL FIELDS ON AMEND                             *
     C*                                                               *
     C*****************************************************************
     C     SETAMD        BEGSR
      *
      ** UPDATE CONTROL FIELDS
      *
     C                   MOVEL     @IKCTL        @HKCTL
     C/COPY WNCPYSRC,MMLDNIMC11
      *                                                                                       CDL033
      ** Update interest rate for CF deals.                                                   CDL033
      *                                                                                       CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     IKMTYP        ANDEQ     'CF'                                                       CDL033
     C                   Z-ADD     IKINTR        HKINTR                                       CDL033
     C                   ENDIF                                                                CDL033
      **
      ** Deal associated deal number
      **
     C                   MOVEL     IKDADN        HKDADN
      **
      ** Broker code
      **
     C                   MOVEL     IKBKCD        HKBKCD
      ** Ensure Block/Unblock amendment action leaves authorised deal still authorised       BUG4097
      ** Temporary measure until Block/Unblock is incorporated into WIP.                     BUG4097
     C     DDACTC        IFEQ      'B'                                                       BUG4097
     C     IKDSTS        ANDEQ     'A'                                                       BUG4560
     C     DDACTC        OREQ      'U'                                                       BUG4097
     C     IKDSTS        ANDEQ     'A'                                                       BUG4560
     C                   MOVEL     'N'           REAUTH            1                         BUG4097
     C                   ELSE                                                                BUG4097
     C                   MOVEL     BNMMRA        REAUTH                                      BUG4097
     C                   END                                                                 BUG4097
      **                                                                                     BUG4347
      ** If current status is Re-authorisation required, overwrite.                          BUG4347
      **                                                                                     BUG4347
     C     IKDSTS        IFEQ      'R'                                                       BUG4347
     C                   MOVEL     'Y'           REAUTH                                      BUG4347
     C                   ENDIF                                                               BUG4347
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'A'           @@ACTN
     C                   PARM      HKDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C**********         PARM                    BNMMRA                                      BUG4097
     C                   PARM                    REAUTH                                      BUG4097
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HKDSTS
     C                   MOVEL     @@CHTP        HKCHTP
      **
      ** Rollover/bought/sold indic
      **
     C*****IKDADN        IFEQ      *BLANKS                                                    CAP042
     C*****IKDADN        OREQ      *ZEROS                                                     CAP042
     C                   IF        IKDADN = *BLANKS OR IKDADN = *ZEROS OR                     CAP042
     C                             IKTYPE = 'IL' AND CAP042 = 'Y' OR                          CAP042
     C                             IKTYPE = 'ID' AND CAP042 = 'Y'                             CAP042
     C                   MOVEL     *BLANKS       HKRBSI
     C                   ELSE
     C                   MOVEL     'N'           HKRBSI
     C                   END
      **
      ** Deal subtype
      **
     C                   MOVEL     IKSTYP        HKSTYP
      **
      ** Customer short name
      ** Customer number
      **
     C                   MOVEL     IKCSNM        HKCSNM
     C                   MOVEL     IKCNUM        HKCNUM
      **
      ** Branch code (alpha)
      ** Deal branch code
      **
     C                   MOVEL     IKDBRC        HKBRCA
     C                   MOVEL     IKDBRC        HKDBRC
      **
      ** Deal done date - yyyy        HKDDYY
      ** Deal done date - mm          HKDDMM
      ** Deal done date - dd          HKDDDD
      **  CONVERT DEAL DONE DATE FROM DAY NUMBER TO YMD
      *
     C                   Z-ADD     IKDDND        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @HKDDY
      **
      ** Deal brokerage
      ** Broker currency code
      ** Broker ccy decimal places
      **
     C                   MOVEL     IKBRKG        HKBRKG
     C                   MOVEL     IKBKCY        HKBKCY
     C                   MOVEL     IKBCDP        HKBCDP
      **                                                                        CDL007
      ** Penalty amount                                                         CDL007
     C                   Z-ADD     IKPENA        HKPENA                         CDL007
      **                                                                        CDL007
      ** Breakdown User                                                         CDL007
     C                   MOVEL     IKBUSR        HKBUSR                         CDL007
      **                                                                        CDL007
      ** Original Maturity Date                                                 CDL007
     C                   Z-ADD     IKOMDT        HKOMDT                         CDL007
      **                                                                        CDL007
      ** Record printed                                                         CDL007
     C                   MOVEL     IKPRIN        HKPRIN                         CDL007
      **                                                                        CAP051
      ** Automatic Authorisation flag                                           CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   MOVEL     IKAUTH        HKAUTH                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      *BLANKS       HKAUTH                         CAP051
     C                   ENDIF                                                  CAP051
      **
      ** Fed funds indicator
      **
     C                   MOVEL     IKFEDF        HKFEDF
      **
      ** Cd reference
      **
     C                   MOVEL     IKCDRF        HKCDRF
      **
      ** Deal last action
      **
     C                   MOVEL     'A'           HKLACT
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        HKDUSC
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          HKLDAT
      **
      ** Nxt intrst pay year date     HKNIYY
      ** Nxt intrst paym mth date     HKNIMM
      ** Next int payment day date    HKNIDD
      **  CONVERT NEXT INT PAY DATE FROM DAY NUMBER TO YMD
      *
     C     IKNIPD        IFNE      *ZERO
     C                   Z-ADD     IKNIPD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @HKNIY
     C                   ELSE
     C                   Z-ADD     *ZERO         @HKNIY
     C                   END
      **
      ** Interest payment frequency
      **
     C                   MOVEL     IKIPFQ        HKIPFQ
      **
      ** Interest calculation method
      **
     C                   MOVEL     IKICMT        HKICMT
      **
      ** Ldi int payment day in month
      **
     C                   MOVEL     IKIPDM        HKIPDM
      **
      ** Capitalise interest ind
      **
     C                   MOVEL     IKCPTI        HKCPTI
      **
      ** Account sequence number
      **
     C                   MOVEL     IKACSQ        HKACSQ
      **
      ** Negative interest indicator
      **
     C                   MOVEL     IKNGVI        HKNGVI
      **
      ** Midas taxable indicator
      **
     C                   MOVEL     IKMTAX        HKMTAX
      **                                                                                      151977
      ** Midas total interest                                                                 151977
      **                                                                                      151977
     C                   MOVEL     IKMTTI        HKMTTI                                       151977
      **
      ** Midas cd held by
      **
     C                   MOVEL     IKMCDH        HKMCDH
      **
      ** Maturity date year           HKMDYY
      ** Maturity date month          HKMDMM
      ** Maturity date day            HKMDDD
      **  CONVERT MATURITY DATE FROM DAY NUMBER TO YMD
      *
     C     IKMATD        IFNE      *ZERO
     C                   Z-ADD     IKMATD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @HKMDY
     C                   ELSE
     C                   Z-ADD     *ZERO         @HKMDY
     C                   END
      **
      ** Notice days
      **
     C                   MOVEL     IKNTCE        HKNTCE
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EVAL      HKOYLC = IKOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
      **
      ** Base currency rate
      ** Midas mult/div indicator
      **
     C                   MOVEL     IKBRAT        HKBRAT
     C                   MOVEL     IKMMDI        HKMMDI
      **
      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
      **
     C                   EXSR      ALRECI
     C                   MOVEL     @IKALR        @HKALR
     C                   MOVEL     IKDORI        HKDORI                                       CGL029
     C                   MOVEL     IKMORI        HKMORI                                       CGL029
      **
      ** ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS
      **
     C                   EXSR      ALPAYI
     C                   MOVEL     @IKALP        @HKALP
     C                   MOVEL     IKDOPI        HKDOPI                                       CGL029
     C                   MOVEL     IKMOPI        HKMOPI                                       CGL029
      **
      ** Book Code
      **
     C                   MOVEL     IKBOKC        HKBOKC
      **
      ** LINKED DEAL NUMBER
      **
     C                   MOVEL     IKLNKN        HKLNKN
      **
      ** Extended Receipt Instructions
      **
     C                   MOVEL     @IKREC        @HKREC
     C                   MOVE      IKRMAC        HKRMAC                                       CDL018
     C                   MOVEL     IKRONS        HKRONS                                       CGL029
      *                                                                                       CDL094
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     IKRBB1        HKRBB1                                       CDL094
     C                   MOVEL     IKRBB2        HKRBB2                                       CDL094
     C                   MOVEL     IKRBB3        HKRBB3                                       CDL094
     C                   MOVEL     IKRBB4        HKRBB4                                       CDL094
     C                   MOVEL     IKRBB5        HKRBB5                                       CDL094
     C                   MOVEL     IKRBB6        HKRBB6                                       CDL094
      **
      ** Extended Payment Instructions
      **
     C                   MOVEL     @IKPY1        @HKPY1
     C                   MOVEL     @IKPY2        @HKPY2
     C                   MOVEL     @IKPY3        @HKPY3
     C                   MOVE      IKPMAC        HKPMAC                                       CDL018
     C                   MOVEL     IKPONS        HKPONS                                       CGL029
      **
      ** Originating branch
      **
     C                   MOVEL     IKORBR        HKORBR
      **
      ** Profit centre
      **
     C                   MOVEL     IKPRFC        HKPRFC
      **
      ** Our Pay Branch
      ** Our Receive Branch
      **
     C                   MOVEL     IKPOBR        HKPOBR
     C                   MOVEL     IKROBR        HKROBR
      **
      ** Repos Indicator
      ** Depot Movement Reference
      **
     C                   MOVEL     IKDRID        HKDRID
     C                   MOVEL     IKDDMR        HKDDMR
      **
      ** COVER MESSAGE REQUIRED
      **
     C                   MOVEL     IKCVMR        HKCVMR
      **
      ** Round down interest
      ** First/last day interest
      ** Front-up interest
      **
     C                   MOVEL     IKRDFC        HKRDFC
     C                   MOVEL     IKFLID        HKFLID
     C                   MOVEL     IKFUID        HKFUID
      **
      ** Auto Rollover
      **
     C                   MOVEL     IKAURO        HKAURO
      **
      ** Int paid sep
      **
     C                   MOVEL     IKIPDS        HKIPDS
      **
      ** Rollover frequency
      **
     C                   MOVEL     IKROFQ        HKROFQ
      **
      ** Rollover day no.
      **
     C                   MOVEL     IKRLDN        HKRLDN
      **
      ** Confirmation Narrative
      **
     C                   MOVEL     IKCNNA        HKCNNA
      **
      ** Int Sett Method
      ** Int set account
      ** Int Counterpart Nostro
      **
     C                   MOVEL     IKIMET        HKIMET
     C                   MOVEL     IKINSA        HKINSA
     C                   MOVEL     IKINOS        HKINOS
      **
      ** Portfolio reference
      **
     C                   MOVEL     IKPTFR        HKPTFR
      **
      ** Funding details
      **
     C                   Z-ADD     IKFSRP        HKFSRP
     C                   MOVE      IKFSGN        HKFSGN
     C                   MOVE      IKFPRC        HKFPRC
      **
      ** EMU Settlement fields
      **
     C                   MOVEL     IKSTCY        HKSTCY
     C                   MOVEL     IKIC72        HKIC72
     C                   MOVEL     IKISCY        HKISCY
     C                   MOVEL     IKII72        HKII72
      **
     C**  Brokerage Rate/Amount indicator.                                      156618
     C*                                                                         156618
     C                   MOVE      IKRACD        HKRACD                         156618
     C*                                                                         156618
      ** Deal done date
      ** Next interest payment date
      ** Maturity date
      **
     C                   MOVEL     IKDDND        HKDDND
     C                   MOVEL     IKNIPD        HKNIPD
     C                   MOVEL     IKMATD        HKMATD
                                                                                CDL006
      ** Fiduciary fields                                                       CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C                   MOVE      IKFCGC        HKFCGC                         CDL006
     C                   MOVE      IKFCGD        HKFCGD                         CDL006
     C                   Z-ADD     IKFCGA        HKFCGA                         CDL006
     C                   Z-ADD     IKFCGT        HKFCGT                         CDL006
     C                   MOVE      IKFCMC        HKFCMC                         CDL006
     C                   MOVE      IKFCMD        HKFCMD                         CDL006
     C                   Z-ADD     IKFCMA        HKFCMA                         CDL006
     C                   Z-ADD     IKFCMT        HKFCMT                         CDL006
     C                   MOVE      IKFTST        HKFTST                         CDL006
     C                   MOVE      IKFRN1        HKFRN1                         CDL006
     C                   MOVE      IKFRN2        HKFRN2                         CDL006
     C                   MOVE      IKFRN3        HKFRN3                         CDL006
     C                   MOVE      IKFRN4        HKFRN4                         CDL006
     C                   ENDIF                                                  CDL006
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C*****IKFRNT        IFNE      *BLANKS                                           227465 AR926400
     C                   MOVEL     IKFRNT        HKFRNT                         CAP013
     C**********         ENDIF                                                       227465 AR926400
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C     IKAFRT        IFNE      *BLANKS                                                    227465
     C                   MOVEL     IKAFRT        HKAFRT                         CAP013
     C                   ENDIF                                                                227465
                                                                                              CAS005
      ** Liquidity Premium                                                                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      HKLQPR = IKLQPR                                            CAS005
     C                   EVAL      HKLQPS = IKLQPS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL016
      ** Rollover Indicator                                                                   CDL016
     C                   IF        CDL016 = 'Y'                                               CDL016
     C                   EVAL      HKROLI = IKROLI                                            CDL016
                                                                                              CDL016
      ** Source of Funds                                                                      CDL016
     C                   EVAL      HKSOFD = IKSOFD                                            CDL016
                                                                                              CDL016
      ** Blocked Indicator                                                                    CDL016
     C                   EVAL      HKBLKA = IKBLKA                                            CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL019
      ** Fix Base Rate                                                                        CDL019
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   EVAL      HKFBRT = IKFBRT                                            CDL019
     C                   ENDIF                                                                CDL019
      *                                                                                       CDL033
      ** Floating Rate CDs                                                                    CDL033
      *                                                                                       CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   EVAL      @HKCF1 = @IKCF1                                            CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL038
      ** Class                                                                                CDL038
     C                   MOVEL     IKCLAS        HKCLAS                                       CDL038
      ** Reference Rate                                                                       CDL049
     C**********         MOVEL     IKRRAT        HKRRAT                              CDL049 BUG24144
     C                   Z-ADD     *ZERO         HKRRAT                                     BUG24144
      *                                                                                       CER020
      ** Initial Start Date, Final Maturity Date and Original                                 CER020
      ** Deal Number                                                                          CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EVAL      HKISDT = IKISDT                                            CER020
     C                   EVAL      HKFMDT = IKFMDT                                            CER020
      *                                                                                       CER020
     C                   IF        IKORDN <> *ZEROS                                           CER020
     C                   EVAL      HKORDN = IKORDN                                            CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   MOVEL     IKDN38        HKORDN                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CDL094
      ** Receive Settlement Instructions                                                      CDL094
     C                   IF        CDL094 = 'Y'                                               CDL094
      *                                                                                       CDL094
     C                   EVAL      HKRBB1 = IKRBB1                                            CDL094
     C                   EVAL      HKRBB2 = IKRBB2                                            CDL094
     C                   EVAL      HKRBB3 = IKRBB3                                            CDL094
     C                   EVAL      HKRBB4 = IKRBB4                                            CDL094
     C                   EVAL      HKRBB5 = IKRBB5                                            CDL094
     C                   EVAL      HKRBB6 = IKRBB6                                            CDL094
      *                                                                                       CDL094
     C                   ENDIF                                                                CDL094
                                                                                              CDL096
      ** Move Business Day Convention fields to MMDELDPP fields                               CDL096
     C                   IF        CDL096 = 'Y'                                               CDL096
     C                   EVAL      @HKDET = @IKDET                                            CDL096
     C                   ENDIF                                                                CDL096
      ** Move Tax Code fields to MMDELDPP fields                                              CGL165
     C                   IF        CGL165 = 'Y'                                               CGL165
     C                   EVAL      @HKTXC = @IKTXC                                            CGL165
     C                   ENDIF                                                                CGL165
                                                                                              CER050
     C                   If        CER050 = 'Y'                                               CER050
     C                   Eval      @HKAPR = @IKAPR                                            CER050
     C                   Endif                                                                CER050
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETAUT - SET DEAL FIELDS ON AUTHORIZE                         *
     C*                                                               *
     C*****************************************************************
     C     SETAUT        BEGSR
      *
      ** UPDATE CONTROL FIELDS
      *
     C                   MOVEL     @IKCTL        @HKCTL
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'X'           @@ACTN
     C                   PARM      HKDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HKDSTS
     C                   MOVEL     @@CHTP        HKCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'X'           HKLACT
      **
      ** Deal authorisation officer
      **
     C                   MOVEL     PSUser        HKAOFR
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          HKLDAT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C*****IKFRNT        IFNE      *BLANKS                                           227465 AR926400
     C                   MOVEL     IKFRNT        HKFRNT                         CAP013
     C**********         ENDIF                                                       227465 AR926400
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C     IKAFRT        IFNE      *BLANKS                                                    227465
     C                   MOVEL     IKAFRT        HKAFRT                         CAP013
     C                   ENDIF                                                                227465
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETDEL - SET DEAL FIELDS ON DELETE                            *
     C*                                                               *
     C*****************************************************************
     C     SETDEL        BEGSR
      *
      ** UPDATE CONTROL FIELDS
      *
     C                   MOVEL     @IKCTL        @HKCTL
      *
      ** FLAG AS 'DELETED'
      *
     C                   MOVEL     'D'           HKDDLT
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'D'           @@ACTN
     C                   PARM      HKDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HKDSTS
     C                   MOVEL     @@CHTP        HKCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'D'           HKLACT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     IKFRNT        HKFRNT                         CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     IKAFRT        HKAFRT                         CAP013
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS                     *
     C*                                                               *
     C*****************************************************************
     C     ALRECI        BEGSR
      *
      * EFFECTIVE SETTLEMENT CURRENCY
      *
     C     IKSTCY        IFNE      *BLANKS
     C                   MOVEL     IKSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IKCCY         EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE RECEIVE INSTRUCTIONS
      *
     C                   CALLB     'ZAALTRECIN'
      ** Customer number                                                                      200400
     C**********         PARM      IKCNUM        ##CNUM            6 0                 200400 CSD027
     C                   PARM      IKCNUM        ##CNUM            6                          CSD027
      ** Rec currency
     C                   PARM      EffSetCcy     ##RCCY            3
      ** Rec - settlement method
     C                   PARM      IKRSTM        ##RSTM            2 0
      ** Rec - our nostro
     C**********         PARM      IKRONS        ##RONS           12                          CGL029
     C                   PARM      IKRONS        ##RONS                                       CGL029
      ** rec - intermediary bank
     C                   PARM      IKRIBN        ##RIBN            8
      ***MIDAS*Our*Receive*Instructions*(*for*Settlm*Meth*'04'*)*********              179510 200400
     C************       PARM                    IKMORI                                179510 200400
      ** midas our receive method
     C                   PARM                    ##ORCM            2 0
      ** our receive method
     C                   PARM                    ##DORM            5
      ** midas our receive instructions
     C**********         PARM                    ##MORI           12                          CGL029
     C                   PARM                    ##MORI                                       CGL029
      ** our receive instructions
     C**********         PARM                    ##DORI           12                          CGL029
     C                   PARM                    ##DORI                                       CGL029
      ** midas customer payment instructions
     C                   PARM                    ##MCPI           10
      ** customer payment instructions
     C                   PARM                    ##DCPI           10
      *
     C*
     C** SETTLEMENT TYPE - MIDAS
     C*
     C                   Z-ADD     ##ORCM        IKORCM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DORM        IKDORM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MORI        IKMORI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DORI        IKDORI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCPI        IKMCPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCPI        IKDCPI
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS                     *
     C*                                                               *
     C*****************************************************************
     C     ALPAYI        BEGSR
      *
      * EFFECTIVE SETTLEMENT CURRENCY
      *
     C     IKSTCY        IFNE      *BLANKS
     C                   MOVEL     IKSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IKCCY         EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE PAYMENT INSTRUCTIONS
      *
     C                   CALLB     'ZAALTPAYIN'
      ** Customer number                                                                      200400
     C**********         PARM      IKCNUM        ##CNUM            6 0                 200400 CSD027
     C                   PARM      IKCNUM        ##CNUM            6                          CSD027
      ** Pay currency
     C                   PARM      EffSetCcy     ##PCCY            3
      ** Pay - settlement method
     C                   PARM      IKPSTM        ##PSTM            2 0
      ** Pay - our nostro
     C**********         PARM      IKPONS        ##PONS           12                          CGL029
     C                   PARM      IKPONS        ##PONS                                       CGL029
      ** account with bank
     C                   PARM      IKAWBN        ##AWBN            8
      ** beneficiary
     C                   PARM      IKBENN        ##BENN            8
      ** bank to bank info 1
     C                   PARM      IKBTB1        ##BTB1           35
      ***MIDAS*Our Pay  Instructions ( for Settlm Meth '04' )                          179510 200400
     C************       PARM                    IKMOPI                                179510 200400
      ** midas our payment method
     C                   PARM                    ##MOPM            2 0
      ** our payment method
     C                   PARM                    ##DOPM            5
      ** midas our payment instructions
     C**********         PARM                    ##MOPI           12                          CGL029
     C                   PARM                    ##MOPI                                       CGL029
      ** our payment instructions
     C**********         PARM                    ##DOPI           12                          CGL029
     C                   PARM                    ##DOPI                                       CGL029
      ** midas customer receive instructions
     C                   PARM                    ##MCRI           10
      ** customer receive instructions
     C                   PARM                    ##DCRI           10
      ** midas for account of
     C                   PARM                    ##MFAO           10
      ** for account of
     C                   PARM                    ##DFAC           10
      ** special instructions
     C                   PARM                    ##SPEC           35
     C*
     C** SETTLEMENT TYPE - MIDAS
     C*
     C                   MOVEL     ##MOPM        IKMOPM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DOPM        IKDOPM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MOPI        IKMOPI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DOPI        IKDOPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCRI        IKMCRI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCRI        IKDCRI
     C*
     C** FOR ACCOUNT OF - MIDAS
     C*
     C                   MOVEL     ##MFAO        IKMFAO
     C*
     C** FOR ACCOUNT OF - FRONT OFFICE
     C*
     C                   MOVEL     ##DFAC        IKDFAC
     C*
     C**  Special instructions.
     C*
     C                   MOVEL     ##SPEC        IKSPEC
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETCTL - SET CONTROL FIELDS                                   *
     C*                                                               *
     C*****************************************************************
     C     SETCTL        BEGSR
      **
      ** Record identifier
      **
     C                   MOVEL     'HK'          IKRCID
      **
      ** Logical delete flag
      **
     C                   MOVEL     *BLANK        IKDLTF
      **
      ** Day of last update
      **
     C                   Z-ADD     @DLUP         IKDLUP
      **
      ** Month of last update
      **
     C                   MOVEL     @MLUP         IKMLUP
      **
      ** Year of last update
      **
     C                   Z-ADD     @YLUP         IKYLUP
      **
      ** Time of last update
      **
     C                   TIME                    IKTLUP
      **
      ** Type of last change (set later in this program)
      **
     C                   MOVEL     IKCHTP        IKCHTP
      **
      ** Last change date
      **
     C                   Z-ADD     BJRDNB        IKLCD
      **
      ** Last update user id
      **
     C                   MOVEL     PSUser        IKLUID
      **
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHUPD - Check for update by another workstation           *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHUPD     BEGSR                                                  CAP006
                                                                                CAP006
      ** Retrieve current deal details                                          CAP006
                                                                                CAP006
     C                   MOVE      IKDN38        MidasDlNum        6            CAP006
                                                                                CAP006
      ** Determine whether program is running interactively or in batch         CAP006
      **  ( 0 = batch   1 = interactive)                                        CAP006
      *                                                                         CAP006
     C                   CALLB     'ZARTVJOBA'                                  CAP006
     C                   PARM                    @Return           6            CAP006
     C                   PARM                    @type             1            CAP006
      *                                                                         CAP006
      * Allow access to transaction record by Front-Office ID when in Repair    168345
      * mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT      168345
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
      * and             b) action code is Insert - 'I'                          168345
      * and             c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     IKLACT        ANDEQ     'I'                                          168345
     C     IKFRNT        ANDNE     *BLANKS                                      168345
     C     @Type         OREQ      '1'                                                      AR926400
     C     IKLACT        ANDEQ     'A'                                                      AR926400
     C     IKFRNT        ANDNE     *BLANKS                                                  AR926400
      *                                                                         168345
     C                   MOVE      '*FRONT'      @@MODE                         168345
      *                                                                         168345
     C                   ELSE                                                   168345
      *                                                                         168345
      * Otherwise, if running in batch use Front-Office ID                      168345
      *            (if insert)                                                  CAP013
      *            else, use Midas Deal Number                                  168345
      *                                                                         168345
     C     @Type         IFEQ      '0'                                          CAP006
     C     IKLACT        ANDEQ     'I'                                          CAP013
     C     IKMTYP        ANDNE     'ID'                                                       CAP042
     C     @Type         OREQ      '0'                                                      AR926400
     C     IKLACT        ANDEQ     'A'                                                      AR926400
     C     IKMTYP        ANDNE     'ID'                                                     AR926400
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   IF        CAP042 = 'Y' AND IKMTYP = 'IL' OR                          CAP042
     C                             CAP042 = 'Y' AND IKMTYP = 'ID'                             CAP042
                                                                                              CAP042
     C                   CALLB     'ABFUNDRTV'                                                CAP042
                                                                                              CAP042
      ** Inputs                                                                               CAP042
      ** ======                                                                               CAP042
      ** Return code                                                                          CAP042
      ** Mode= '*FRONT' (Front Office Transaction Interface)                                  CAP042
      ** Mode = '     ' (Not Front Office Transaction Interface)                              CAP042
      ** Mode = '*RPR  ' (Repair function)                                                    CAP042
      ** Mode = '*SIN  ' (Screen Input function)                                              CAP042
                                                                                              CAP042
     C                   PARM                    RetCodeOut                                   CAP042
     C                   PARM                    @@MODE                                       CAP042
                                                                                              CAP042
      ** Response mode                                                                        CAP042
      ** Action Code                                                                          CAP042
      ** Front Office Transaction ID                                                          CAP042
      ** Front Office Associated Transaction Id                                               CAP042
      ** (Midas) Deal Number                                                                  CAP042
      ** (Midas) Associated Deal Number                                                       CAP042
      ** (Midas) Booking Branch                                                               CAP042
      ** (Midas) Booking Branch for Associated Deal                                           CAP042
                                                                                              CAP042
     C                   PARM                    @@RSMD                                       CAP042
     C                   PARM                    IKLACT                                       CAP042
     C                   PARM      IKFRNT        FOTRID                                       CAP042
     C                   PARM      IKAFRT        FOASID                                       CAP042
     C                   PARM                    MidasDlNum                                   CAP042
     C                   PARM                    DDDADN                                       CAP042
     C                   PARM      IKDBRC        DDBRCA                                       CAP042
     C                   PARM                    DDBRC2                                       CAP042
                                                                                              CAP042
      ** Linked maintenance flag                                                              CAP042
                                                                                              CAP042
     C                   PARM                    PLnkFlag                                     CAP042
                                                                                              CAP042
      ** Standing Data                                                                        CAP042
      ** =============                                                                        CAP042
      ** SDBANKPD                                                                             CAP042
                                                                                              CAP042
     C                   PARM                    BJSBRC                                       CAP042
                                                                                              CAP042
      ** SDGELRPD                                                                             CAP042
                                                                                              CAP042
     C                   PARM                    BKOBUV                                       CAP042
                                                                                              CAP042
      ** ZMUSER                                                                               CAP042
                                                                                              CAP042
     C                   PARM                    DBRN                                         CAP042
                                                                                              CAP042
      ** Outputs                                                                              CAP042
      ** =======                                                                              CAP042
      ** Current deal in file format                                                          CAP042
      ** Associated deal in file format                                                       CAP042
      ** OK - Action code                                                                     CAP042
      ** OK - Deal Number                                                                     CAP042
      ** OK - Booking branch                                                                  CAP042
                                                                                              CAP042
     C                   PARM                    ChkDealFmt1                                  CAP042
     C                   PARM                    ChkDealFmt2                                  CAP042
     C                   PARM      *BLANK        OKACTN                                       CAP042
     C                   PARM      *BLANK        OKDLNO                                       CAP042
     C                   PARM      *BLANK        OKBRCA                                       CAP042
     C                   PARM      *BLANK        OKBRC2                                       CAP042
                                                                                              CAP042
      ** Error fields/message IDs/message data (arrays) from/to caller                        CAP042
                                                                                              CAP042
     C                   PARM                    FldNameArr                                   CAP042
     C                   PARM                    MsgIDArr                                     CAP042
     C                   PARM                    MsgDtaArr                                    CAP042
                                                                                              CAP042
      ** Array index (3P0) from/to caller                                                     CAP042
                                                                                              CAP042
     C                   PARM                    Idx                                          CAP042
                                                                                              CAP042
     C                   IF        IKMTYP = 'IL'                                              CAP042
     C                   EVAL      ChkDealFmt = ChkDealFmt1                                   CAP042
     C                   ELSE                                                                 CAP042
     C                   EVAL      ChkDealFmt = ChkDealFmt2                                   CAP042
     C                   ENDIF                                                                CAP042
                                                                                              CAP042
     C                   ELSE                                                                 CAP042
                                                                                              CAP042
     C                   IF        IKDRID <> *BLANK                                           CAP067
     C                   EVAL      RepoFlag = 'Y'                                             CAP067
     C                   ELSE                                                                 CAP067
     C                   EVAL      RepoFlag = 'N'                                             CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CAP067
     C                   CALLB     'MMLDNIRTV'                                  CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Return code                                                             CAP006
     C                   PARM      *BLANK        RetCodeOut                     CAP006
      *                                                                         CAP006
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
      *                                                                         CAP006
     C                   PARM                    @@MODE            6            CAP006
      *                                                                         CAP006
      * Response mode                                                           CAP006
     C                   PARM      ' '           @@RSMD            1            CAP006
      *                                                                         CAP006
      * Action Code                                                             CAP006
     C                   PARM                    IKLACT                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      IKFRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * Front Office Associated Transaction Id                                  CAP006
     C                   PARM      IKAFRT        FOASID           20            CAP006
      *                                                                         CAP006
      * (Midas) Deal Number                                                     CAP006
     C                   PARM                    MidasDlNum                     CAP006
      *                                                                                       196380
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR            6                          196380
      *                                                                         CAP006
      * (Midas) Associated Deal Number                                          CAP006
     C                   PARM                    DDDADN            6            CAP006
      *                                                                         CAP006
      * Booking branch                                                          CAP006
     C                   PARM      IKDBRC        DDBRCA            3            CAP006
      *                                                                                       CAP067
      * REPO Flag                                                                             CAP067
     C                   PARM                    RepoFlag          1                          CAP067
      *                                                                         CAP006
      * OUTPUTS                                                                 CAP006
      *                                                                         CAP006
      * (Current) deal in file format                                           CAP006
     C                   PARM                    ChkDealFmt                     CAP006
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789
      *                                                                         CAP006
      * OK - Action code                                                        CAP006
     C                   PARM      *BLANK        OKACTN                         CAP006
      *                                                                         CAP006
      * OK - Deal Number                                                        CAP006
     C                   PARM      *BLANK        OKDLNO                         CAP006
      *                                                                         CAP006
      * OK - Booking branch                                                     CAP006
     C                   PARM      *BLANK        OKBRCA                         CAP006
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT             1                          CDL016
      *                                                                         CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM      *BLANK        FldNameArr                     CAP006
     C                   PARM      *BLANK        MsgIdArr                       CAP006
     C                   PARM      *BLANK        MsgDtaArr                      CAP006
      *                                                                         CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMLDNIMC22
                                                                                              CAP042
     C                   ENDIF                                                                CAP042
      *                                                                         CAP006
      *                                                                         CAP006
      ** Error if Timestamp is not the same (record has been changed            CAP006
      **  by another workstation)                                               CAP006
                                                                                CAP006
      ** Processing varies according to mode program is running in.             CAP006
      ** In interacive mode simply check whether the timestamp field            CAP006
      ** has been updated since the original deal was fetched by this           CAP006
      ** program.                                                               CAP006
      ** In batch (API input) check return parameters from Retrieve             CAP006
      ** module for errors, and send message to system operator.                CAP006
                                                                                CAP006
      ** Interactive mode:                                                      CAP006
                                                                                CAP006
     C     @TYPE         IFEQ      '1'                                          CAP006
                                                                                CAP006
     C     CHHKTMST      IFNE      IKTMESTMP                                    CAP006
     C     IKLACT        ANDNE     'I'                                          184720
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Batch mode:                                                            CAP006
     C                   ELSE                                                   CAP006
     C     OKACTN        IFEQ      'N'                                          CAP006
     C     OKDLNO        OREQ      'N'                                          CAP006
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   Z-ADD     1             C                 2 0          CAP006
                                                                                CAP006
     C     C             DOWLE     ArrayMax                                     CAP006
     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
     C                   CLEAR                   DBError         132            CAP013
     C                   EVAL      DBerror = 'Update error: ' + FOTRID          CAP013
     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
     C                   PARM                    MsgSndRtn        10            CAP006
     C                   PARM                    DBError                        CAP006
     C                   PARM                    DummyMsgID                     CAP006
     C                   PARM                    DummyMsgF                      CAP006
     C                   ADD       1             C                              CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   ENDSR                                                  CAP006
     C*****************************************************************         CAP006
      /EJECT                                                                    CAP006
     C*****************************************************************
     C*                                                               *
     C* ONLNUP - ON-LINE UPDATES (MEMOS, PRONO, OLPOS, RSACMTPD)      *
     C*                                                               *
     C*****************************************************************
     C     ONLNUP        BEGSR
      *
     C                   CALL      'AOOUMMU0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM      *BLANK        @AURO             1
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM                    PBFRCD                                       CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM                    PAFRCD                                       CDL033
     C                   PARM                    DLDLQD                                       CER049
     C                   PARM      *BLANKS       BeDealsDtlC                               AR1044820
     C                   PARM      *BLANKS       AfDealsDtlC                               AR1044820
      *                                                                                    AR1044820
      ** Calling Program                                                                   AR1044820
      *                                                                                    AR1044820
     C                   PARM      *BLANKS       CALLER           10                       AR1044820
      *                                                                                       CDL033
     C/COPY WNCPYSRC,MMLDNIMC12
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'AOOUMMU0'    DBFILE                         *************
     C                   MOVEL     '991'         DBASE                          * DBERR 991 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CDE001
     C/COPY WNCPYSRC,MMH00136
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     IKDN38        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'LDNI'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
      *
     C/COPY WNCPYSRC,MMLDNIMC08
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        IKLACT = 'A' OR                                            CRE020
     C                             IKLACT = 'D'                                               CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* TREAUP - TREASURY MANAGEMENT UPDATES                          *
     C*                                                               *
     C*****************************************************************
     C     TREAUP        BEGSR
      *
     C                   CALLB     'MMLDNIUPT'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      IKLACT        @LACT             1
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C     @RTCD         IFEQ      '*ERROR '
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'MMLDNIUPT'   DBFILE                         *************
     C                   MOVEL     '992'         DBASE                          * DBERR 992 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
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
     C                   EVAL      KRefNo = *BLANKS                                           CRE020
     C                   MOVEL     HKDN38        KRefNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
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
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N' AND                                           CRE020
     C                             RSAPIN = ' ' AND                                           CRE020
     C                             HKLACT = 'D'                                               CRE020
     C                   EVAL      RCHTYP = 'R'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,MMH00132
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
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    MMVLDN
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM                    PBFRCD          100                          CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM                    PAFRCD          100                          CDL033
     C                   PARM                    DLDLQD                                       CER049
      *                                                                                       CDL033
     C**********                                                                     BUG4097 BUG4168
     C***Setup*the*Block/Unblock*condition*from*the*Return*code*parameter*from*MMLDNIVU.4097 BUG4168
     C**********                                                                     BUG4097 BUG4168
     C*****@@RTCD        IFEQ      'BLOCK  '                                         BUG4097 BUG4168
     C**********         MOVE      'B'           DDACTC            1                 BUG4097 BUG4168
     C**********         END                                                         BUG4097 BUG4168
     C**********                                                                     BUG4097 BUG4168
     C*****@@RTCD        IFEQ      'UNBLOCK'                                         BUG4097 BUG4168
     C**********         MOVE      'U'           DDACTC                              BUG4097 BUG4168
     C**********         END                                                         BUG4097 BUG4168
     C*                                                                              BUG4097 BUG4168
     C/COPY WNCPYSRC,MMLDNIMC10
     C*
     C** ACCESS BANK DETAILS
     C*
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C/COPY WNCPYSRC,MMH00133
     C*
     C*  ACCESS DEAL DATA
     C*
     C**********         CALLB     'AODEALR0'                                                 CAS011
     C                   CALLB     'AODEALR1'                                                 CAS011
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CAS011
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CAS011
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CAP051
      ** Access SAR details file to determine if                                CAP051
      ** Automatic Authorisation (MM Part) is installed                         CAP051
      *                                                                         CAP051
     C                   MOVE      'N'           CAP051            1            CAP051
     C                   CALLB     'AOSARDR0'                                   CAP051
     C                   PARM      *BLANKS       @RTCD                          CAP051
     C                   PARM      '*VERIFY '    @OPTN                          CAP051
     C                   PARM      'CAP051'      @SAR              6            CAP051
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
      *                                                                         CAP051
     C     @RTCD         IFEQ      *BLANK                                       CAP051
     C                   MOVE      'Y'           CAP051                         CAP051
     C                   ENDIF                                                  CAP051
     C*                                                                         CAP051
     C                   MOVE      BNMMAU        SAVMAU            1            CAP051
     C                   MOVE      BNMMRA        SAVMRA            1            CAP051
     C*
     C** ACCESS MIDAS MODULE DETAILS
     C*
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                                       CGL011
      ** Access SAR details file to determine if CGL011                                       CGL011
      ** (Collateral Details) is on.                                                          CGL011
      *                                                                                       CGL011
     C                   CALLB     'AOSARDR0'                                                 CGL011
     C                   PARM      *BLANKS       @RTCD                                        CGL011
     C                   PARM      '*VERIFY'     @OPTN                                        CGL011
     C                   PARM      'CGL011'      PSARD             6                          CGL011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL011
      *                                                                                       CGL011
      ** An NRF (No Record Found) return code is valid.                                       CGL011
      ** Issue database error only for error return codes.                                    CGL011
      *                                                                                       CGL011
     C     @RTCD         IFNE      *BLANKS                                                    CGL011
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL011
     C     *LOCK         IN        LDA                                                        CGL011
     C                   MOVEL     'CGL011'      DBKEY                                        CGL011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL011
     C                   Z-ADD     903           DBASE                                        CGL011
     C                   OUT       LDA                                                        CGL011
     C                   EXSR      SRERR                                                      CGL011
     C                   ENDIF                                                                CGL011
      *                                                                                       CGL011
     C                   MOVEL     'N'           CGL011                                       CGL011
     C     @RTCD         IFEQ      *BLANK                                                     CGL011
     C                   MOVEL     'Y'           CGL011            1                          CGL011
     C                   ENDIF                                                                CGL011
      *                                                                         CDE001
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD                          CDE001
     C                   PARM      '*VERIFY'     @OPTN                          CDE001
     C                   PARM      'CDE001'      @SARD             6            CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
      *                                                                                       CDL094
      ** Determine if Enhanced Receive Settlement Instructions is On                          CDL094
     C                   MOVEL     'N'           CDL094            1                          CDL094
     C                   CALL      'AOSARDR0'                                                 CDL094
     C                   PARM      *BLANKS       @RTCD                                        CDL094
     C                   PARM      '*VERIFY'     @OPTN                                        CDL094
     C                   PARM      'CDL094'      @SARD             6                          CDL094
      *                                                                                       CDL094
     C     @RTCD         IFEQ      *BLANK                                                     CDL094
     C                   MOVEL     'Y'           CDL094            1                          CDL094
     C                   ENDIF                                                                CDL094
                                                                                              CAP042
      ** Determine if Internal Funding API enhancement is on                                  CAP042
                                                                                              CAP042
     C                   CALL      'AOSARDR0'                                                 CAP042
     C                   PARM      *BLANKS       @RTCD                                        CAP042
     C                   PARM      '*VERIFY'     @OPTN                                        CAP042
     C                   PARM      'CAP042'      @SARD                                        CAP042
                                                                                              CAP042
     C                   IF        @RTCD = *BLANK                                             CAP042
     C                   EVAL      CAP042 = 'Y'                                               CAP042
     C                   ENDIF                                                                CAP042
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 905                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EXSR      SRERR                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CDL010
      ** Access SAR details file to determine if CDL010 is on.                                CDL010
      ** (Dealing Transaction Authorisation)                                                  CDL010
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       PRTCD                                        CDL010
     C                   PARM      '*VERIFY'     POPTN                                        CDL010
     C                   PARM      'CDL010'      PSARD                                        CDL010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
     C                   IF        PRTCD <> *BLANKS AND                                       CDL010
     C                             PRTCD <> '*NRF   '                                         CDL010
     C     *LOCK         IN        LDA                                                        CDL010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
     C                   EVAL      DBASE = 906                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   OUT       LDA                                                        CDL010
     C                   EXSR      SRERR                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        PRTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CDL010
      ** Access General Ledger ICD via access program                                         CAP042
      ** (database error handling done in access program)                                     CAP042
                                                                                              CAP042
     C**********         CALLB     'AOGELRR0'                                          CAP042 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *Blanks       @RTCD                                        CAP042
     C                   PARM      '*FIRST '     @OPTN                                        CAP042
     C*****SDGELR        PARM      SDGELR        DSFDY                                 CAP042 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
                                                                                              CAP042
      ** Database error.                                                                      CAP042
                                                                                              CAP042
     C                   IF        @RTCD <> *BLANKS                                           CAP042
     C                   EVAL      DBKEY = @OPTN                                              CAP042
     C                   EVAL      DBFILE = 'SDGELRPD'                                        CAP042
     C                   Z-ADD     904           DBASE                                        CAP042
     C                   EXSR      SRERR                                                      CAP042
     C                   ENDIF                                                                CAP042
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 906                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*VERIFY'     POPTN                                        CSD015
     C                   PARM      'CSD015'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRTCD <> *BLANKS) AND                                     CSD015
     C                             (PRTCD <> '*NRF   ')                                       CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 904                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRTCD = *BLANKS                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*FIRST'      POPTN                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRTCD <> *BLANKS                                           CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = POPTN                                              CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access Compliance Watch Transaction details                                          CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*KEY    '    POPTN                                        CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database Error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRTCD <> *BLANKS                                           CSD015
     C                             AND PRTCD <> '*NRF'                                        CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = PFunc                                              CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 905                                                CSD015
     C                   Out       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*VERIFY'     POPTN                                        CSD015
     C                   PARM      'CCF001'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRTCD <> *BLANKS) AND                                     CSD015
     C                             (PRTCD <> '*NRF   ')                                       CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 908                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRTCD = *BLANKS                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
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
     C                   EVAL      DBase = 909                                                CRE020
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
     C                   EVAL      DBase = 910                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 907                                                CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      SRERR                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL016
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Autumatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRTCD                                        CDL016
     C                   Parm      '*VERIFY'     POPTN                                        CDL016
     C                   Parm      'CDL016'      PSARD                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        PRTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL019
      ** Access SAR details file to determine if CDL019 is switched on                        CDL019
      ** (Allow Base Rate Changes on Fixed Deposits/Loans)                                    CDL019
                                                                                              CDL019
     C                   CallB     'AOSARDR0'                                                 CDL019
     C                   Parm      *Blanks       PRTCD                                        CDL019
     C                   Parm      '*VERIFY'     POPTN                                        CDL019
     C                   Parm      'CDL019'      PSARD                                        CDL019
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL019
      *                                                                                       CDL019
     C                   Move      'N'           CDL019            1                          CDL019
     C                   If        PRTCD = *Blanks                                            CDL019
     C                   Eval      CDL019 = 'Y'                                               CDL019
     C                   Endif                                                                CDL019
      *****************************************************************                239566 240751
      ***Access*SAR*details*file*to*determine*if*CEU015*is*switched*on                 239566 240751
***** *****************************************************************                239566 240751
     C**********         CallB     'AOSARDR0'                                          239566 240751
     C**********         Parm      *Blanks       PRTCD                                 239566 240751
     C**********         Parm      '*VERIFY'     POPTN                                 239566 240751
     C**********         Parm      'CEU015'      PSARD                                 239566 240751
     C*****SCSARD        Parm      SCSARD        DSFDY                                 239566 240751
      *****************************************************************                239566 240751
     C**********         Move      'N'           CEU015            1                   239566 240751
     C**********         If        PRTCD = *Blanks                                     239566 240751
     C**********         Eval      CEU015 = 'Y'                                        239566 240751
     C**********         Endif                                                         239566 240751
      *                                                                                       CDL033
      ** Access SAR details file to determine if CDL033                                       CDL033
      ** (Floating Rate CDs Issued) is on.                                                    CDL033
      *                                                                                       CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
      ** An NRF (No Record Found) return code is valid.                                       CDL033
      ** Issue database error only for error return codes.                                    CDL033
      *                                                                                       CDL033
     C     @RTCD         IFNE      *BLANKS                                                    CDL033
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
     C                   Z-ADD     911           DBASE                                        CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      SRERR                                                      CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   MOVEL     'N'           CDL033                                       CDL033
     C     @RTCD         IFEQ      *BLANK                                                     CDL033
     C                   MOVEL     'Y'           CDL033            1                          CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      *                                                                                       CAS009
      ** Access SAR details file to determine if CAS009 is on                                 CAS009
      *                                                                                       CAS009
     C                   CALLB     'AOSARDR0'                                                 CAS009
     C                   PARM      *BLANKS       PRTCD                                        CAS009
     C                   PARM      '*VERIFY'     POPTN                                        CAS009
     C                   PARM      'CAS009'      PSARD                                        CAS009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS009
                                                                                              CAS009
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '                    CAS009
     C     *LOCK         IN        LDA                                                        CAS009
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS009
     C                   EVAL      DBASE = 909                                                CAS009
     C                   EVAL      DBKEY = 'CAS009'                                           CAS009
     C                   OUT       LDA                                                        CAS009
     C                   EXSR      SRERR                                                      CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   IF        PRTCD = *BLANKS                                            CAS009
     C                   EVAL      CAS009 = 'Y'                                               CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      CAS009 = 'N'                                               CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
                                                                                            BUG10725
      ** Check if Fiduciary Dealing is installed                                            BUG10725
                                                                                            BUG10725
     C                   CALLB     'AOSARDR0'                                               BUG10725
     C                   PARM      *BLANKS       PRtCd                                      BUG10725
     C                   PARM      '*VERIFY'     POptn                                      BUG10725
     C                   PARM      'CDL006'      PSARD                                      BUG10725
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG10725
                                                                                            BUG10725
     C                   EVAL      CDL006 = 'N'                                             BUG10725
                                                                                            BUG10725
     C                   IF        PRtCd = *BLANKS                                          BUG10725
     C                   EVAL      CDL006 = 'Y'                                             BUG10725
     C                   ELSE                                                               BUG10725
                                                                                            BUG10725
     C                   IF        PRtCd <> '*NRF'                                          BUG10725
     C     *LOCK         IN        LDA                                                      BUG10725
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG10725
     C                   EVAL      DBase = 912                                              BUG10725
     C                   EVAL      DBKey = 'CDL006'                                         BUG10725
     C                   OUT       LDA                                                      BUG10725
     C                   EXSR      SRErr                                                    BUG10725
     C                   ENDIF                                                              BUG10725
                                                                                            BUG10725
     C                   ENDIF                                                              BUG10725
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRtCd                                        CSD083
     C                   PARM      '*VERIFY'     POptn                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
     C                             PRtCd <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 914                                                CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRErr                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRtCd = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CER020
      ** Check if CER020 is enabled.                                                          CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRtcd                                        CER020
     C                   PARM      '*VERIFY'     POptn                                        CER020
     C                   PARM      'CER020'      PSard                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        PRtcd = *BLANKS                                            CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'N'                                               CER020
     C                   ENDIF                                                                CER020
     C/COPY WNCPYSRC,MMH00134
     C*
     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      **************                                                               CAP042    BUG5517
      ***Retrieve*ZMUSER details.                                                  CAP042    BUG5517
      **************                                                               CAP042    BUG5517
     C******DTAARA**     DEFINE                  ZMUSER                            CAP042    BUG5517
     C**************     IN        ZMUSER                                          CAP042    BUG5517
     C/COPY WNCPYSRC,MMLDNIMC05
     C*
      *                                                                                       CDL096
      ** Access SAR details file to determine if CDL096 is on.                                CDL096
      *                                                                                       CDL096
     C                   CALLB     'AOSARDR0'                                                 CDL096
     C                   PARM      *BLANKS       PRTCD                                        CDL096
     C                   PARM      '*VERIFY'     POPTN                                        CDL096
     C                   PARM      'CDL096'      PSARD                                        CDL096
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL096
      *                                                                                       CDL096
     C                   IF        PRTCD = *BLANKS                                            CDL096
     C                   EVAL      CDL096 = 'Y'                                               CDL096
     C                   ELSEIF    PRTCD = '*NRF'                                             CDL096
     C                   EVAL      CDL096 = 'N'                                               CDL096
     C                   ELSE                                                                 CDL096
                                                                                              CDL096
      ** Access program error                                                                 CDL096
     C                   MOVEL     'CDL096'      DBKEY                                        CDL096
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL096
     C                   MOVEL     '915'         DBASE                                        CDL096
     C                   EXSR      SRERR                                                      CDL096
      *                                                                                       CDL096
     C                   ENDIF                                                                CDL096
      *                                                                                       CDL096
      ** Access SAR details file to determine if CGL165 is on.                                CGL165
      *                                                                                       CGL165
     C                   CALLB     'AOSARDR0'                                                 CGL165
     C                   PARM      *BLANKS       PRTCD                                        CGL165
     C                   PARM      '*VERIFY'     POPTN                                        CGL165
     C                   PARM      'CGL165'      PSARD                                        CGL165
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL165
      *                                                                                       CGL165
     C                   IF        PRTCD = *BLANKS                                            CGL165
     C                   EVAL      CGL165 = 'Y'                                               CGL165
     C                   ELSE                                                                 CGL165
     C                   EVAL      CGL165 = 'N'                                               CGL165
     C                   ENDIF                                                                CGL165
                                                                                              CGL165
      ** Access SAR details file to determine if CER050 is on.                                CER050
      *                                                                                       CER050
     C                   CallB     'AOSARDR0'                                                 CER050
     C                   Parm      *BLANKS       PRTCD                                        CER050
     C                   Parm      '*VERIFY'     POPTN                                        CER050
     C                   Parm      'CER050'      PSARD                                        CER050
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER050
      *                                                                                       CER050
     C                   If        PRtcd = *Blanks                                            CER050
     C                   Eval      CER050 = 'Y'                                               CER050
     C                   Else                                                                 CER050
     C                   Eval      CER050 = 'N'                                               CER050
     C                   Endif                                                                CER050
                                                                                              CER050
     C                   ENDSR
      *****************************************************************
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWatch - Initiates the Midas Compliance Engine.              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWatch       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Initialise the Transaction Details parameter.                                        CSD015
                                                                                              CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
                                                                                              CSD015
      ** Setup First Parameter                                                                CSD015
                                                                                              CSD015
     C                   IF        HKDRID = *BLANK                                            CSD015
     C                   CAT       'MM':0        W4ITEM                                       CSD015
     C                   ELSE                                                                 CSD015
     C                   CAT       'SE':0        W4ITEM                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   CAT       HKMTYP:0      W4ITEM                                       CSD015
                                                                                              CSD015
     C                   MOVEL     HKDN38        W4IDEN                                       CSD015
     C                   EVAL      W4BRCH = HKBRCA                                            CSD015
      *                                                                                       CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4FUNT = 'MMDELDPP'                                        CSD015
                                                                                              CSD015
     C                   MOVEL     HKCNUM        PCUST                                        CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*KEY'        POPTN                                        CSD015
     C                   Parm                    PCUST                                        CSD015
     C                   PARM      *BLANKS       PSTKEY                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRTCD <> *BLANKS                                           CSD015
     C                             AND PRTCD <> '*NRF   '                                     CSD015
     C                   EVAL      DBKEY = POPTN                                              CSD015
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBASE = 911                                                CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   MOVE      HKCNUM        W4CNUM                                       CSD015
                                                                                              CSD015
      ** Determine Counterparty Type                                                          CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                   CSD015
                                                                                              CSD015
      ** Convert Dates                                                                        CSD015
                                                                                              CSD015
     C                   MOVE      HKDDYY        WDateTemp4                                   CSD015
     C                   MOVE      HKDDMM        WDateTemp2A                                  CSD015
     C                   MOVE      HKDDDD        WDateTemp2B                                  CSD015
     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
     C                   MOVE      WDate         W4DDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      HKVDYY        WDateTemp4                                   CSD015
     C                   MOVE      HKVDMM        WDateTemp2A                                  CSD015
     C                   MOVE      HKVDDD        WDateTemp2B                                  CSD015
     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
     C                   MOVE      WDate         W4VDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      HKMDYY        WDateTemp4                                   CSD015
     C                   MOVE      HKMDMM        WDateTemp2A                                  CSD015
     C                   MOVE      HKMDDD        WDateTemp2B                                  CSD015
     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
                                                                                              CSD015
     C                   IF        WDate = '0000-00-00'                                       CSD015
     C                   EVAL      WDate = '0001-01-01'                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   MOVE      WDate         W4MDAT                                       CSD015
                                                                                              CSD015
     C                   EVAL      W4DEN1 = HKCCY                                             CSD015
                                                                                              CSD015
     C                   MOVE      HKAMNP        PAmt                                         CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   MOVE      ConvertedAmt  W4AMT1                                       CSD015
                                                                                              CSD015
      ** Build the free format string.                                                        CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   DOU       Ctr >= Elements                                            CSD015
                                                                                              CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                             AND WLF(Ctr) <> '000000'                                   CSD015
                                                                                              CSD015
     C                   IF        HKSTCY <> *Blanks                                          CSD015
     C                   EVAL      PFmtCCY = HKSTCY                                           CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      PFmtCCY = HKCCY                                            CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM                    PRTCD                                        CSD015
     C                   PARM                    WLF(Ctr)                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PFmtCCY                                      CSD015
     C                   PARM                    WData                                        CSD015
     C                   PARM                    PDummy6                                      CSD015
      *                                                                                       CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WData:0       WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   SELECT                                                               CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 3                                                    CSD015
     C                   CAT       HKRIBA:0      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 8                                                    CSD015
     C                   CAT       HKRCRA:1      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 9                                                    CSD015
     C                   CAT       HKPIBA:1      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 11                                                   CSD015
     C                   CAT       HKAWBA:1      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 12                                                   CSD015
     C                   CAT       HKBENA:1      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   ENDSL                                                                CSD015
                                                                                              CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
      ** Add the Payment Details.                                                             CSD015
                                                                                              CSD015
     C                   IF        HKDTP1 <> *BLANKS OR HKDTP2 <> *BLANKS                     CSD015
     C                             OR HKDTP3 <> *BLANKS OR HKDTP4 <> *BLANKS                  CSD015
     C                   IF        WDtlOPay = 'Y' OR                                          CSD015
     C                             IKLACT = 'I'                                               CSD015
                                                                                              CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       HKDTP1:0      WXMLPacket                                   CSD015
     C                   CAT       HKDTP2:1      WXMLPacket                                   CSD015
     C                   CAT       HKDTP3:1      WXMLPacket                                   CSD015
     C                   CAT       HKDTP4:1      WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check for compliance.                                                                CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SrCvtAmt - Converts Amount by calling the ZACVTAMT Module     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtAmt      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALLB     'ZACVTAMT'                                                 CSD015
     C                   PARM                    ReturnCode                                   CSD015
     C                   PARM                    HKCCY                                        CSD015
     C                   PARM                    PAmt                                         CSD015
     C                   PARM                    ConvertedAmt                                 CSD015
     C                   PARM                    PDummy16                                     CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT
     C*****************************************************
     C*                                                   *
     C* SRERR - EXCEPTION ERRORS                          *
     C*                                                   *
     C*****************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMLDNIUPM'   DBPGM            10
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
     C*****************************************************
     C/EJECT
     C/COPY WNCPYSRC,MMLDNIMC06
      *********************************************************************
      ** FIELD LOG
      *********************************************************************
      **                                      SET IN     SET IN
      **                                    VALIDATION    THIS    AMENDABLE
      **                                     FUNCTION   FUNCTION
      *********************************************************************
      ** Record identifier            IKRCID              YES       YES
      ** Logical delete flag          IKDLTF              YES       YES
      ** Day of last update           IKDLUP              YES       YES
      ** Month of last update         IKMLUP              YES       YES
      ** Year of last update          IKYLUP              YES       YES
      ** Time of last update          IKTLUP              YES       YES
      ** Type of last change          IKCHTP              YES       YES
      ** Last change date             IKLCD               YES       YES
      ** Last update user id          IKLUID              YES       YES
      ** Deal number pc               IKPCDN -----------------------------
      ** Deal number 38               IKDN38   YES
      ** Deal associated deal number  IKDADN   YES                  YES
      ** Broker code                  IKBKCD   YES                  YES
      ** Currency code                IKCCY    YES
      ** Currency decimal places      IKCYDP   YES
      ** Deal value date - yyyy       IKVDYY              YES
      ** Deal value date - mm         IKVDMM              YES
      ** Deal value date - dd         IKVDDD              YES
      ** Deal transaction date - yyyy IKDTYY              YES
      ** Deal transaction date - mm   IKDTMM              YES
      ** Deal transaction date - dd   IKDTDD              YES
      ** Deal deleted indicator       IKDDLT              YES
      ** Deal status indicator        IKDSTS              YES       YES
      ** MIDAS deal type              IKMTYP              YES
      ** Rollover/bought/sold indic   IKRBSI              YES       YES
      ** Deal type                    IKTYPE   YES        YES
      ** Deal subtype                 IKSTYP   YES                  YES
      ** Customer short name          IKCSNM   YES                  YES
      ** Customer number              IKCNUM   YES                  YES
      ** Amount                       IKAMNP   YES
      ** Interest rate                IKINTR   YES
      ** Branch code (alpha)          IKBRCA   YES                  YES
      ** Deal branch code             IKDBRC   YES                  YES
      ** Deal done date - yyyy        IKDDYY              YES       YES
      ** Deal done date - mm          IKDDMM              YES       YES
      ** Deal done date - dd          IKDDDD              YES       YES
      ** Deal brokerage               IKBRKG   YES                  YES
      ** Broker currency code         IKBKCY   YES                  YES
      ** Broker ccy decimal places    IKBCDP   YES                  YES
      ** Fed funds indicator          IKFEDF   YES                  YES
      ** Cd reference                 IKCDRF   YES                  YES
      ** Deal pc transation number    IKPCTN--------------------------------
      ** Confirm/delete reply         IKCDRP--------------------------------
      ** Deal last action             IKLACT   YES                  YES
      ** Time of input                IKTIME              YES
      ** Deal user code               IKDUSC              YES       YES
      ** Deal authorisation officer   IKAOFR              YES       YES
      ** Deal action date             IKLDAT              YES       YES
      ** Start/last interst year date IKSLYY              YES
      ** Start/last interst mnth date IKSLMM              YES
      ** Start/last interest day date IKSLDD              YES
      ** Rolled over by               IKROBY              YES
      ** Spread                       IKSPRD   YES
      ** Input interest rate          IKIIRT   YES
      ** Nxt intrst pay year date     IKNIYY              YES       YES
      ** Nxt intrst paym mth date     IKNIMM              YES       YES
      ** Next int payment day date    IKNIDD              YES       YES
      ** Interest payment frequency   IKIPFQ   YES                  YES
      ** Interest calculation method  IKICMT   YES                  YES
      ** Ldi int payment day in month IKIPDM   YES                  YES
      ** Capitalise interest ind      IKCPTI   YES                  YES
      ** Call/notice indicator        IKCNTI              YES
      ** Account sequence number      IKACSQ   YES                  YES
      ** Negative interest indicator  IKNGVI   YES                  YES
      ** Total midas interest         IKMTTI   YES
      ** Midas taxable indicator      IKMTAX   YES                  YES
      ** Midas cd held by             IKMCDH   YES                  YES
      ** Interest accrual contr year  IKIAYY              YES
      ** Intrst accrual contr method  IKIAMM              YES
      ** Intrst accrual contr day     IKIADD              YES
      ** Midas base rate code         IKBSRC              YES
      ** DRs base rate code           IKDBSR   YES
      ** Maturity date year           IKMDYY              YES       YES
      ** Maturity date month          IKMDMM              YES       YES
      ** Maturity date day            IKMDDD              YES       YES
      ** Notice days                  IKNTCE   YES                  YES
      ** Facility                     IKFCLY-------------------------------
      ** Interest at maturity         IKIMAT              YES
      ** Base currency rate           IKBRAT   YES                  YES
      ** Midas mult/div indicator     IKMMDI   YES                  YES
      ** Deal our receive method      IKDORM              YES       YES
      ** Deal midas our receve method IKORCM              YES       YES
      ** Deal our receive instructns  IKDORI              YES       YES
      ** Deal midas our receive instr IKMORI              YES       YES
      ** Deal customer payment instr  IKDCPI              YES       YES
      ** Deal midas cust payment inst IKMCPI              YES       YES
      ** Deal our payment method      IKDOPM              YES       YES
      ** Deal midas our payment meth. IKMOPM              YES       YES
      ** Deal our payment instructns  IKDOPI              YES       YES
      ** Deal midas our payment instr IKMOPI              YES       YES
      ** Deal customer receive instr  IKDCRI              YES       YES
      ** Deal Customer Receive Instru IKMCRI              YES       YES
      ** Deal for A/C of              IKDFAC              YES       YES
      ** Deal midas ''FOR A/C OF''    IKMFAO              YES       YES
      ** Deal special instructions    IKSPEC              YES       YES
      ** Book Code                    IKBOKC   YES                  YES
      ** LINKED DEAL NUMBER           IKLNKN   YES                  YES
      ** receipt - settlement method  IKRSTM   YES*                 YES
      ** receipt - our nostro         IKRONS   YES*                 YES
      ** receipt - intermediary bank  IKRIBN   YES*                 YES
      ** receipt - intermediary bank  IKRIBA   YES*                 YES
      ** receipt - ordering bank no   IKROBN   YES*                 YES
      ** receipt - ordering customer  IKROCN   YES*                 YES
      ** pay - settlement method      IKPSTM   YES*                 YES
      ** pay - our nostro             IKPONS   YES*                 YES
      ** pay - intermediary bank no   IKPIBN   YES*                 YES
      ** pay - intermediary bank a/c  IKPIBA   YES*                 YES
      ** pay - ordering bank no       IKPOBN   YES*                 YES
      ** pay - ordering customer no   IKPOCN   YES*                 YES
      ** receiver correspondent no    IKRCRN   YES*                 YES
      ** receiver correspondent a/c l IKRCRA   YES*                 YES
      ** Receiver number              IKRVNO   YES*                 YES
      ** a/c with bank no             IKAWBN   YES*                 YES
      ** a/c with bank a/c line       IKAWBA   YES*                 YES
      ** beneficiary no               IKBENN   YES*                 YES
      ** beneficiary a/c line         IKBENA   YES*                 YES
      ** DETAILS OF PAY 1             IKDTP1   YES*                 YES
      ** DETAILS OF PAY 2             IKDTP2   YES*                 YES
      ** DETAILS OF PAY 3             IKDTP3   YES*                 YES
      ** DETAILS OF PAY 4             IKDTP4   YES*                 YES
      ** details of charges           IKDCHG   YES*                 YES
      ** bank to bank info 1          IKBTB1   YES*                 YES
      ** bank to bank info 2          IKBTB2   YES*                 YES
      ** bank to bank info 3          IKBTB3   YES*                 YES
      ** bank to bank info 4          IKBTB4   YES*                 YES
      ** bank to bank 5               IKBTB5   YES*                 YES
      ** bank to bank 6               IKBTB6   YES*                 YES
      ** Originating branch           IKORBR   YES                  YES
      ** Profit centre                IKPRFC   YES                  YES
      ** Our Pay Branch               IKPOBR   YES*                 YES
      ** Our Receive Branch           IKROBR   YES*                 YES
      ** Repos Indicator              IKDRID   YES                  YES
      ** Depot Movement Reference     IKDDMR   YES                  YES
      ** COVER MESSAGE REQUIRED       IKCVMR   YES*                 YES
      ** Round down interest          IKRDFC   YES                  YES
      ** First/last day interest      IKFLID   YES                  YES
      ** Front-up interest            IKFUID   YES                  YES
      ** Auto Rollover                IKAURO   YES                  YES
      ** Int paid sep                 IKIPDS   YES                  YES
      ** Rollover frequency           IKROFQ   YES                  YES
      ** Rollover day no.             IKRLDN   YES                  YES
      ** Confirmation Narrative       IKCNNA   YES                  YES
      ** Int Sett Method              IKIMET   YES                  YES
      ** Int set account              IKINSA   YES                  YES
      ** Int Counterpart Nostro       IKINOS   YES                  YES
      ** Warning report printed ind   IKWRPI              YES       YES
      ** Portfolio reference          IKPTFR   YES                  YES
      ** Funding Spread/Rate          IKFSRP   YES                  YES
      ** Funding Spread Sign          IKFSGN   YES                  YES
      ** Funding Profit Centre        IKFPRC   YES                  YES
      ** Settlement Currency          HKSTCY   YES                  YES
      ** In Currency in Field 72      HKIC72   YES                  YES
      ** Interest Currency            HKISCY   YES                  YES
      ** Interest In Ccy in Field 72  HKII72   YES                  YES
      ** Deal value/start date        IKDVSD   YES
      ** Deal done date               IKDDND   YES                  YES
      ** Next interest payment date   IKNIPD   YES                  YES
      ** Start date or last int. date IKSLID   YES
      ** Maturity date                IKMATD   YES                  YES
      ***Front*Office*Transaction*Id**FRONTO***YES*****                         CAP013
      ** Front Office Transaction Id  IKFRNT   YES                  YES         CAP013
      ** Assoc Front Office Trans Id  IKAFRT   YES                  YES         CAP013
      ** Deal Repair Location         REPAIR
      ** Rollover To/From Currency    IKRTFC   YES                              CAP004
      ** Penalty amount               IKPENA   YES                  YES         CDL007
      ** Breakdown User               IKBUSR   NO                               CDL007
      ** Record Printed               IKPINR   NO                               CDL007
      ** Automatic Authorisation      IKAUTH   NO                               CAP051
      ** Class                        IKCLAS   YES                  YES         CDL038
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
<Receipt Our Nostro>                                                                          CSD015
<Receipt Ord Customer>                                                                        CSD015
<Receipt Int Bank>                                                                            CSD015
<Receipt Ord Bank>                                                                            CSD015
<Payment Our Nostro>                                                                          CSD015
<Payment Ord Customer>                                                                        CSD015
<Payment Receiver>                                                                            CSD015
<Payment Receiver Corr>                                                                       CSD015
<Payment Int Bank>                                                                            CSD015
<Payment Ord Bank>                                                                            CSD015
<Payment A/C with Bank>                                                                       CSD015
<Payment Beneficiary>                                                                         CSD015
<Payment Details of Pay>                                                                      CSD015
** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                   CSD015
</Receipt Our Nostro>                                                                         CSD015
</Receipt Ord Customer>                                                                       CSD015
</Receipt Int Bank>                                                                           CSD015
</Receipt Ord Bank>                                                                           CSD015
</Payment Our Nostro>                                                                         CSD015
</Payment Ord Customer>                                                                       CSD015
</Payment Receiver>                                                                           CSD015
</Payment Receiver Corr>                                                                      CSD015
</Payment Int Bank>                                                                           CSD015
</Payment Ord Bank>                                                                           CSD015
</Payment A/C with Bank>                                                                      CSD015
</Payment Beneficiary>                                                                        CSD015
</Payment Details of Pay>                                                                     CSD015
