     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Set up Transaction and Settlement Data')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Interface Module                                 *
      *                                                               *
      *  APPARSMSG - Midas AP Set up Transaction and Settlement Data  *
      *                                                               *
      *  Function:  This program sets up the Transaction and          *
      *             Settlement Data Structures.                       *
      *                                                               *
      *  Called By - APINCOMMSG - Process incoming messages           *
      *            - APINCOMMSF - Process incoming messages from file *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054039           Date 05Aug19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CIR017             Date 10Apr14               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      *                 CFT120             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 AR400813           Date 01Aug12               *
      *                 CSW212             Date 03May12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 262664             Date 11Nov09               *
      *                 BUG25877           Date 03Sep09               *
      *                 BUG23742           Date 09May09               *
      *                 CER034A            Date 19May08               *
      *                 CER047             Date 19May08               *
      *                 CER034             Date 19May08               *
      *                 CER030             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256407B            Date 03Nov08               *
      *                 256407A            Date 01Oct08               *
      *                 256353A            Date 08Sep08               *
      *                 256330             Date 02Sep08               *
      *                 BUG15052A          Date 19Oct07               *
      *                 BUG15052           Date 19Oct07               *
      *                 247770             Date 15May07               *
      *                 246418             Date 28Mar07               *
      *                 243084             Date 10Jul06               *
      *                 241470             Date 07Sep06               *
      *                 BUG9887            Date 12Jan06               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 CAP183             Date 05Jan06               *
      *                 CER001             Date 25Apr05               *
      *                 CGL032             Date 05Jul04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009             Date 04May04               *
      *                 CDL033             Date 10Feb05               *
      *                 BG5977             Date 24Mar05               *
      *                 BG6335             Date 18Mar05               *
      *                 CDL028             Date 07Feb05               *
      *                 BG5888             Date 16Feb05               *
      *                 CDL018             Date 03Feb04               *
      *                 222331             Date 20Oct03               *
      *                 CSE045             Date 20Oct03               *
      *                 CAP083  *CREATE    Date 20Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054039 - DBU_SPTR did not update the spot rate             *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions (recompile) *
      *  CIR017 - SIRS Business Day Conventions for both legs         *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD092 - Account Review                                      *
      *  CSD093 - Document Management                                 *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *  AR400813 - Error in settlement when processing LELAPI tran-  *
      *             sactions. Add 500 bytes to the data layout file   *
      *             for Loan Amendments/Principal Increase to get the *
      *             correct settlement details.                       *
      *             (Child AR400814)                                  *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262664 - GF Phase 1 - Incorrect parameter - FTIPAYCTL /      *
      *           FTOPAYCTL.                                          *
      *         - Corrected the parameters.                           *
      *  BUG25877 - Data is always truncated and ends in ACUD repair  *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface  Input                                  *
      *  CER034A - German Features - New Fields and Enquiries         *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CER034 - LF046 German Features - New Fields and Enquiries    *
      *  CER030 - Multicash German Features                           *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256407B - Modification after fix 256407A.                    *
      *  256407A - LEFEES are not Data after pos. 261 are not coming  *
      *            thru.                                              *
      *  256353A - Process fees input when API type is LEFEES.        *
      *  256330 - Wrong position getting length of FAMDLN             *
      *  BUG15052A - Missing record on SDCUSWPD                        *
      *  BUG15052 - SWIFT 2007 Standard Changes                       *
      *             Add extension table fro Swift Customer details.   *
      *  247770 - Lending fees amendment are always rejected.         *
      *  246418 - CGL013 changes for Midas Plus                       *
      *  243084 - Incorrect/missing parsing.                          *
      *           To add missing processing relating to getting of    *
      *           record length of data layout file SDJACMPD.         *
      *           To add missing setup of regional data variable for  *
      *           SEDMWI and SEDMWO functions.                        *
      *  241470 - Applied fix BUG9887.                                *
      *  BUG9887 - No information passed to IRCIRSCTL at all...       *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs                               *
      *  CER001 - Lux Upgrade to MidasPlus                            *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BG5977 - Error in CAP083 which missed out 196570             *
      *  BG6335 - Error in CAP083 which missed out 214637             *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BG5888 - Changes missing for CAP077, CAP079, CAP075, CAP076  *
      *           CAP074, CAL073 Lending inputs                       *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  222331 - Error in CAP083 which missed out CAS006             *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *  CAP083 - APISERVER File Adapter                              *
      *                                                               *
      *****************************************************************

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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

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

      ** Data structure for incoming message formats
     D*BUFFER***       DS          6000                                                       CFT039
     D*BUFFER***       DS         12000                                              CFT039 MD054039
     D BUFFER          DS         29997                                                     MD054039
     D  TYPE                   1      8
     D  USERID                33     42
     D  PASSWORD              43     52

     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions
     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions
     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions

     D PayStmtV      E DS                  EXTNAME(SDESSPPD)  PREFIX(V)
      * Pay Settlement Instructions
     D RecStmtV      E DS                  EXTNAME(SDESSRPD)  PREFIX(V)
      * Receive Settlement Instructions

     D PayStmtM      E DS                  EXTNAME(SDESSPPD)  PREFIX(M)
      * Pay Settlement Instructions
     D RecStmtM      E DS                  EXTNAME(SDESSRPD)  PREFIX(M)
      * Receive Settlement Instructions
     D** Short Data Structure                                                                 CAS011
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAS011
      ** External DS for SAR Details                                                          CAS011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS011
                                                                                            MD054039
     D  DLRIS1In     E DS                  EXTNAME(DLRIS1PD)                                MD054039
     D  DLRIS2In     E DS                  EXTNAME(DLRIS2PD)                                MD054039
     D  DLRIS3In     E DS                  EXTNAME(DLRIS3PD)                                MD054039
     D  DLRIS4In     E DS                  EXTNAME(DLRIS4PD)                                MD054039
     D  SDSW13In     E DS                  EXTNAME(SDSW13PD)                                MD054039
     D                                     PREFIX(S13)                                      MD054039
                                                                                            MD054039
     D InSwift2013     DS                                                                   MD054039
     D   DLRIS1DS                          LIKE(DLRIS1In)                                   MD054039
     D   DLRIS2DS                          LIKE(DLRIS2In)                                   MD054039
     D   DLRIS3DS                          LIKE(DLRIS3In)                                   MD054039
     D   DLRIS4DS                          LIKE(DLRIS4In)                                   MD054039
      * Reporting Information                                                               MD054039
                                                                                            MD054039
     D Trans9999_2     DS          9999                                                     MD054039
     D  SDSW13Ds                           LIKE(SDSW13In)                                   MD054039
     D  Trans2Fil8942              8942                                                     MD054039
                                                                                            MD054039
     D Trans9999_3     DS          9999                                                     MD054039
      ** Work variables used by CAP067
     D REP1Ln          S              4P 0
     D REP2Ln          S              4P 0

      ** Work variables used by CAP055/CAP056
     D CACFLn          S              4P 0
     D CACXLn          S              4P 0
     D IRRSLn          S              4P 0
     D IRRXLn          S              4P 0
     D IRRPLn          S              4P 0
     D IRFALn          S              4P 0

      ** Work variable used by CAS001
     D SDYRLn          S              4P 0
     D YRAT1Ln         S              4P 0
     D YRAT2Ln         S              4P 0
     D YRAT3Ln         S              4P 0
     D YRAT4Ln         S              4P 0
     D PRtCd           S              7A
     D POptn           S              7A
     D PSarD           S              6A
     D CAS001          S              1A

      ** Work variables used by CDL006
     D WFIDT1Ln        S              4P 0
     D WFIDT2Ln        S              4P 0
     D WFIDT3Ln        S              4P 0
     D WFIDT4Ln        S              4P 0
     D WFIDT5Ln        S              4P 0
     D WFIDT6Ln        S              4P 0
     D WFIDT7Ln        S              4P 0
     D WFIDT8Ln        S              4P 0
     D WFIDT9Ln        S              4P 0

      ** Work variable used by CAP043
     D WCFSC1OLn       S              4P 0
     D WCFSC2OLn       S              4P 0
     D WCFSC3OLn       S              4P 0
     D WCFSC4OLn       S              4P 0
     D WPCSC1OLn       S              4P 0
     D WPCSC2OLn       S              4P 0
     D WPCSC3OLn       S              4P 0
     D WPCSC4OLn       S              4P 0
     D WCFSC1TLn       S              4P 0
     D WCFSC2TLn       S              4P 0
     D WCFSC3TLn       S              4P 0
     D WCFSC4TLn       S              4P 0
     D WPCSC1TLn       S              4P 0
     D WPCSC2TLn       S              4P 0
     D WPCSC3TLn       S              4P 0
     D WPCSC4TLn       S              4P 0
     D WTRSCLn         S              4P 0

      *  Work variable used by CAS009                                                         CAS009
     D DLFELn          S              4P 0                                                    CAS009
     D DFEXLn          S              4P 0                                                    CAS009
     D CAS009          S              1A                                                      CAS009
                                                                                              CDL033
     D DLFRHO        E DS                  EXTNAME(DLFRHOPD)                                  CDL033
      ** External data structure for the Confirmed Holiday indicators                         CDL033
                                                                                              CAS009
      ** Work variable used by CGL032                                                         CGL032
     D ACUDLn          S              4P 0                                                    CGL032
     D ACEXLn          S              4P 0                                                    CGL032
     D SDNALn          S              4P 0                                                    CGL032
     D NaEXLn          S              4P 0                                                    CGL032
     D CCTXLn          S              4P 0                                                    CGL032
     D NATXLn          S              4P 0                                                    CGL032
     D JACMLn          S              4P 0                                                    CGL032
     D CUEXLn          S              4P 0                                                   CER034A
     D FTCSLn          S              4P 0                                                    CGL132
     D FTNHLn          S              4P 0                                                    CGL132
                                                                                              CGL032
      *                                                                                       CER034
      ***Work*variable*used*by*CER034*************************                        CER034 CER034A
      *                                                                               CER034 CER034A
     D*Trans10**       S            500A                                              CER034 CER034A
     D*Trans11**       S            500A                                              CER034 CER034A
     D*Trans12**       S            500A                                              CER034 CER034A
     D*Trans13**       S            500A                                              CER034 CER034A
     D*Trans14**       S            500A                                              CER034 CER034A
     D*Trans15**       S            500A                                              CER034 CER034A
     D*Trans16**       S            500A                                              CER034 CER034A
     D*Trans17**       S            500A                                              CER034 CER034A
      *                                                                                       CER034
     D WACUD1          S              4P 0                                                    CER034
     D WACUD2          S              4P 0                                                    CER034
      *                                                                                      CER034A
      ** Work variable used by Customer/Authority Details                                    CER034A
      *                                                                                      CER034A
     D CUAH1Ln         S              4P 0                                                   CER034A
     D CUAH2Ln         S              4P 0                                                   CER034A
     D CUAH3Ln         S              4P 0                                                   CER034A
     D CUAH4Ln         S              4P 0                                                   CER034A
     D CUAH5Ln         S              4P 0                                                   CER034A
     D CUAH6Ln         S              4P 0                                                   CER034A
     D CUAH7Ln         S              4P 0                                                   CER034A
      ** Work variable used by CSD092                                                         CSD092
     D ACRVLn1         S              4P 0                                                    CSD092
     D ACRXLn          S              4P 0                                                    CSD092
                                                                                              CSD092
      ** Work variable used by CSD093                                                         CSD093
     D DCMTLn          S              4P 0                                                    CSD093
     D DCMXLn          S              4P 0                                                    CSD093
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS

      ** Other Depot Details for Securities Customer.
      ** This totals to 150 additional other depot details from the incoming message.
     D OthDData        S           4755A
     D OthrData        S           4878A                                                     CSF011A

      ** Work variable used by CSW209                                                         CSW209
     D IPY9ALn         S              4P 0                                                    CSW209
     D IPY9BLn         S              4P 0                                                    CSW209
     D OPYALn          S              4P 0                                                    CSW209
     D OPYCLn          S              4P 0                                                    CSW209
     D TRANS9C         S           3000A                                                      CGL132
     D TRANS9A         S           1000A                                                      CSW209
     D TRANS9B         S           1000A                                                      CSW209
                                                                                              CSW209
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************

      ** Set up the Transaction & Settlement DS's

     C                   EXSR      TRANSETI

     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      ****************************************************************
      *                                                              *
      *  Set up Transaction and Settlement Data Structures           *
      *                                                              *
      ****************************************************************
     C     TRANSETI      BEGSR

     C                   CLEAR                   TRANS1          500
     C                   CLEAR                   TRANS1A        1000                          CDL028
     C                   CLEAR                   TRANS1B        1500                        BUG25877
     C                   CLEAR                   TRANS2          500
     C                   CLEAR                   TRANS2A        1000                         CSF011A
     C                   CLEAR                   TRANS3          500
     C                   CLEAR                   TRANS3A        1000                         CSF011A
     C                   CLEAR                   TRANS4          500
     C                   CLEAR                   TRANS5          500
     C                   CLEAR                   TRANS5A        1000                         CSF011A
     C                   CLEAR                   TRANS6          500
     C                   CLEAR                   TRANS6A        1000                         CSF011A
     C                   CLEAR                   TRANS7          500
     C                   CLEAR                   TRANS8          500
     C                   CLEAR                   TRANS9          500
     C                   CLEAR                   TRANS9A                                      CSW209
     C                   CLEAR                   TRANS9B                                      CSW209
     C                   CLEAR                   TRANS10         500                          262664
     C                   CLEAR                   TRANS9C                                      CGL132
     C**********         CLEAR                   Trans10                              CER034 CER034A
     C**********         CLEAR                   Trans11                              CER034 CER034A
     C**********         CLEAR                   Trans12                              CER034 CER034A
     C**********         CLEAR                   Trans13                              CER034 CER034A
     C**********         CLEAR                   Trans14                              CER034 CER034A
     C**********         CLEAR                   Trans15                              CER034 CER034A
     C**********         CLEAR                   Trans16                              CER034 CER034A
     C**********         CLEAR                   Trans17                              CER034 CER034A
     C                   CLEAR                   PaySttmt
     C                   CLEAR                   RecSttmt
     C                   CLEAR                   FRASttmt
     C                   CLEAR                   PayStmtV
     C                   CLEAR                   RecStmtV
     C                   CLEAR                   PayStmtM
     C                   CLEAR                   RecStmtM
     C                   CLEAR                   ExtData         500
     C                   CLEAR                   InfData         500
     C                   CLEAR                   OthDData
     C                   CLEAR                   RegData         500                          CER001
     C                   EVAL      Bypass = 'N'

      ** Position Buffer pointer to 1st byte after the header data

     C     HEADLn        ADD       1             Bfp               4 0

      **--- Explanation of BUFFER substringing -----------------------------------------------------
      ** The following select block extracts the transaction data from
      ** the incoming transaction string.  Each WHEN section works as
      ** follows:
      **
      ** 1. The field BUFFER is substringed from position Bfp by the
      **    length of the transaction format definition file, and the
      **    result placed in field TRANS. (Bfp = length of header info
      **    plus 1; the length of the format definition is determined in
      **    *inzsr)
      **
      ** 2. Bfp is incremented by the length of the format definition
      **
      ** 3. The field BUFFER is substringed from the new value of Bfp
      **    by the length of the receive settlement instructions format
      **    definition file, and the result placed in RecSttmt.
      **
      ** 4. Bfp is incremented by the length of the receive
      **    settlements format definition.
      **
      ** 5. Point 3 is repeated for pay settlement instructions, and
      **    the result placed in PaySttmt.
      **
      ** 6. Bfp is incremeted by the length of the pay settlement
      **    instructions.
      **
      ** 7. The field BUFFER is substringed from the new value of Bfp
      **    by the length of the relevant Extra Data file. This file will
      **    be supplied with a 50 byte core field. This is a free format
      **    narrative text field for transferring instructions to the back
      **    office.
      **    Custom data coming from the front office will be added to this
      **    file.
      **
      ** The above applies for most transaction types; FRAs also
      ** extract the FRA settlement instructions, and FF includes
      ** broker and customer settlement instructions in the transaction
      ** structure, and does not have pay or receive settlements.
      ** Other variations may occur in the future, but the same
      ** principles will be followed.
      **--------------------------------------------------------------------------------------------

     C                   SELECT

      * FX deals

     C     TYPE          WHENEQ    'FXFXDL'

     C     FXDLLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FXDLLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CSW212
     C                   ADD       ESSFLn        Bfp                                          CSW212
      **  Non-Screen Interface Data for Class 1 enhancements
     C     FXFILn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       FXFILn        Bfp
     C     FXFXLn        SUBST     BUFFER:Bfp    ExtData

      * Loans/Deposits

     C     TYPE          WHENEQ    'MMLDNI'

     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
     C     LDNILn        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
     C                   ADD       LDNILn        Bfp
                                                                                              CDL033
      ** Buffer - R_Dtes(164x6A), RH_Ins(164x1A), P_Dtes(164x6A), PH_Ins(164x1A)              CDL033
      ** X - Rate Change Confirmed Holiday pointer                                            CDL033
      ** Y - Payment Confirmed Holiday pointer                                                CDL033
     C                   Z-ADD     1             X                 4 0                        CDL033
     C                   Z-ADD     1             Y                 4 0                        CDL033
      ** TRANS2 - 1st set of Rate Change dates (1-82 elements)                                CDL033
     C     RFRSCLn       SUBST     BUFFER:Bfp    TRANS2                                       CDL033
     C                   ADD       RFRSCLn       Bfp                                          CDL033
      ** TRANS3 - 2nd set of Rate Change dates (83-164 elements)                              CDL033
     C     RFRSCLn       SUBST     BUFFER:Bfp    TRANS3                                       CDL033
     C                   ADD       RFRSCLn       Bfp                                          CDL033
      ** TRANS6 - 1st/2nd sets of Rate Change dates Confirmed Holiday indicators (1-164)      CDL033
     C     FRHOLn        SUBST     BUFFER:Bfp    DLFRHO                                       CDL033
     C                   ADD       FRHOLn        Bfp                                          CDL033
     C                   EVAL      %SUBST(TRANS6:X:FRHOLn)=DLFRHO                             CDL033
     C                   ADD       FRHOLn        X                                            CDL033
     C     FRHOLn        SUBST     BUFFER:Bfp    DLFRHO                                       CDL033
     C                   ADD       FRHOLn        Bfp                                          CDL033
     C                   EVAL      %SUBST(TRANS6:X:FRHOLn)=DLFRHO                             CDL033
     C                   ADD       FRHOLn        X                                            CDL033
      ** TRANS4 - 1st set of Payment dates     (1-82 elements)                                CDL033
     C     PFRSCLn       SUBST     BUFFER:Bfp    TRANS4                                       CDL033
     C                   ADD       PFRSCLn       Bfp                                          CDL033
      ** TRANS5 - 2nd set of Payment dates     (83-164 elements)                              CDL033
     C     PFRSCLn       SUBST     BUFFER:Bfp    TRANS5                                       CDL033
     C                   ADD       PFRSCLn       Bfp                                          CDL033
      ** TRANS7 - 1st/2nd sets of Payment dates Confirmed Holiday indicators     (164)        CDL033
     C     FRHOLn        SUBST     BUFFER:Bfp    DLFRHO                                       CDL033
     C                   ADD       FRHOLn        Bfp                                          CDL033
     C                   EVAL      %SUBST(TRANS7:Y:FRHOLn)=DLFRHO                             CDL033
     C                   ADD       FRHOLn        Y                                            CDL033
     C     FRHOLn        SUBST     BUFFER:Bfp    DLFRHO                                       CDL033
     C                   ADD       FRHOLn        Bfp                                          CDL033
     C                   EVAL      %SUBST(TRANS7:Y:FRHOLn)=DLFRHO                             CDL033
     C                   ADD       FRHOLn        Y                                            CDL033
                                                                                              CDL033
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp

      **  Non-Screen Interface Data for Class 1 enhancements
     C     MMLILn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       MMLILn        Bfp
     C     MMLRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       MMLRLn        Bfp                                          CER001
     C     MMLDLn        SUBST     BUFFER:Bfp    ExtData

     C     TYPE          WHENEQ    'MMFIDT'

     C     WFIDT1Ln      SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WFIDT1Ln      Bfp
     C     WFIDT2Ln      SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       WFIDT2Ln      Bfp
     C     WFIDT3Ln      SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       WFIDT3Ln      Bfp
     C     WFIDT4Ln      SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       WFIDT4Ln      Bfp
     C     WFIDT5Ln      SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       WFIDT5Ln      Bfp
     C     WFIDT6Ln      SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       WFIDT6Ln      Bfp
     C     WFIDT7Ln      SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       WFIDT7Ln      Bfp
     C     WFIDT8Ln      SUBST     BUFFER:Bfp    TRANS8
     C                   ADD       WFIDT8Ln      Bfp
     C     WFIDT9Ln      SUBST     BUFFER:Bfp    TRANS9
     C                   ADD       WFIDT9Ln      Bfp

     C     TYPE          WHENEQ    'MMFITR'

     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     MMLILn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       MMLILn        Bfp
     C     MMLDLn        SUBST     BUFFER:Bfp    ExtData

      * Deal Amendments

     C     TYPE          WHENEQ    'MMDEAM'

     C     DEAMLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       DEAMLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
      **  Non-Screen Interface Data for Class 1 enhancements
     C     MMDILn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       MMDILn        Bfp
     C     MMDALn        SUBST     BUFFER:Bfp    ExtData

      * NAs Purchased

     C     TYPE          WHENEQ    'MMNASP'

     C     NASPLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       NASPLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     MMNRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       MMNRLn        Bfp                                          CER001
     C     MMNPLn        SUBST     BUFFER:Bfp    ExtData

      * NAs Sold

     C     TYPE          WHENEQ    'MMNASS'

     C     NASSLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       NASSLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     MMNSLn        SUBST     BUFFER:Bfp    ExtData

      * Forward Rate Agreements

     C     TYPE          WHENEQ    'IRFRA '

     C     FRALn         SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FRALn         Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp

      **  Non-Screen Interface Data for Class 1 enhancements

     C     IRFALn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       IRFALn        Bfp

     C     IRFRLn        SUBST     BUFFER:Bfp    ExtData

      * Single Currency Interest Rate Swaps

     C     TYPE          WHENEQ    'IRSIRS'

     C*****SIRSLn        SUBST     BUFFER:Bfp    TRANS1                                       CIR017
     C     SIRSLn        SUBST     BUFFER:Bfp    TRANS1A                                      CIR017
     C                   ADD       SIRSLn        Bfp
     C     DTORLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       DTORLn        Bfp
     C     DTOPLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       DTOPLn        Bfp
     C     DTTRLn        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       DTTRLn        Bfp
     C     DTTPLn        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       DTTPLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp

      **  Non-Screen Interface Data for Class 1 enhancements

     C     IRRSLn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       IRRSLn        Bfp

     C     IRSSLn        SUBST     BUFFER:Bfp    ExtData

      ** Additional Date Schedules (Rate Change & Interest Payment Dates - Single Ccy)

     C     TYPE          WHENEQ    'IRSIRI'

     C     DTORLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       DTORLn        Bfp
     C     DTOPLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       DTOPLn        Bfp
     C     DTTRLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       DTTRLn        Bfp
     C     DTTPLn        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       DTTPLn        Bfp

      ** Cash Flow Schedules (Single Ccy)

     C     TYPE          WHENEQ    'IRSICF'

      ** Our Cash Flow

     C     WCFSC1OLn     SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WCFSC1OLn     Bfp
     C     WCFSC2OLn     SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       WCFSC2OLn     Bfp
     C     WCFSC3OLn     SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       WCFSC3OLn     Bfp
     C     WCFSC4OLn     SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       WCFSC4OLn     Bfp

      ** Their Cash Flow

     C     WCFSC1TLn     SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       WCFSC1TLn     Bfp
     C     WCFSC2TLn     SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       WCFSC2TLn     Bfp
     C     WCFSC3TLn     SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       WCFSC3TLn     Bfp
     C     WCFSC4TLn     SUBST     BUFFER:Bfp    TRANS8

      ** Principal Change Schedules (Single Ccy)

     C     TYPE          WHENEQ    'IRSIPC'

      ** Principal Change

     C     WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WPCSC1OLn     Bfp
     C     WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       WPCSC2OLn     Bfp
     C     WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       WPCSC3OLn     Bfp
     C     WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       WPCSC4OLn     Bfp

      ** Trailer record (Single Ccy)

     C     TYPE          WHENEQ    'IRSITR'

     C     WTRSCLn       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WTRSCLn       Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp
     C     IRRSLn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       IRRSLn        Bfp
     C     IRSSLn        SUBST     BUFFER:Bfp    ExtData

      * Cross Currency Interest Rate Swaps

     C     TYPE          WHENEQ    'IRCIRS'

     C*****CIRSLn********SUBST     BUFFER:Bfp    TRANS1                                       CDL028
     C     CIRSLn        SUBST     BUFFER:Bfp    TRANS1A                                      CDL028
     C                   ADD       CIRSLn        Bfp
     C     DTORLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       DTORLn        Bfp
     C     DTOPLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       DTOPLn        Bfp
     C     DTTRLn        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       DTTRLn        Bfp
     C     DTTPLn        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       DTTPLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp

      ** Extra Settlements
     C     ESSRLn        SUBST     BUFFER:Bfp    RecStmtV
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PayStmtV
     C                   ADD       ESSPLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecStmtM
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PayStmtM
     C                   ADD       ESSPLn        Bfp

      **  Non-Screen Interface Data for Class 1 enhancements

     C     IRRXLn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       IRRXLn        Bfp

     C     IRCSLn        SUBST     BUFFER:Bfp    ExtData

      ** Additional Date Schedules (Rate Change & Interest Payment Dates - Cross Ccy)

     C     TYPE          WHENEQ    'IRCIRI'

     C     DTORLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       DTORLn        Bfp
     C     DTOPLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       DTOPLn        Bfp
     C     DTTRLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       DTTRLn        Bfp
     C     DTTPLn        SUBST     BUFFER:Bfp    TRANS4

      ** Cash Flow Schedules (Cross Ccy)

     C     TYPE          WHENEQ    'IRCICF'

      ** Our Cash Flow

     C     WCFSC1OLn     SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WCFSC1OLn     Bfp
     C     WCFSC2OLn     SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       WCFSC2OLn     Bfp
     C     WCFSC3OLn     SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       WCFSC3OLn     Bfp
     C     WCFSC4OLn     SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       WCFSC4OLn     Bfp

      ** Their Cash Flow

     C     WCFSC1TLn     SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       WCFSC1TLn     Bfp
     C     WCFSC2TLn     SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       WCFSC2TLn     Bfp
     C     WCFSC3TLn     SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       WCFSC3TLn     Bfp
     C     WCFSC4TLn     SUBST     BUFFER:Bfp    TRANS8

      ** Principal Change Schedules (Cross Ccy)

     C     TYPE          WHENEQ    'IRCIPC'

      ** Our Principal Change

     C     WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WPCSC1OLn     Bfp
     C     WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       WPCSC2OLn     Bfp
     C     WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       WPCSC3OLn     Bfp
     C     WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       WPCSC4OLn     Bfp

      ** Their Principal Change

     C     WPCSC1TLn     SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       WPCSC1TLn     Bfp
     C     WPCSC2TLn     SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       WPCSC2TLn     Bfp
     C     WPCSC3TLn     SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       WPCSC3TLn     Bfp
     C     WPCSC4TLn     SUBST     BUFFER:Bfp    TRANS8

      ** Trailer record (Cross Ccy)

     C     TYPE          WHENEQ    'IRCITR'

     C     WTRSCLn       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WTRSCLn       Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp

      ** Extra Settlements

     C     ESSRLn        SUBST     BUFFER:Bfp    RecStmtV
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PayStmtV
     C                   ADD       ESSPLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecStmtM
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PayStmtM
     C                   ADD       ESSPLn        Bfp
     C     IRRXLn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       IRRXLn        Bfp
     C     IRCSLn        SUBST     BUFFER:Bfp    ExtData

      * SE Trade

     C     TYPE          WHENEQ    'SETRAD'

     C     TRPRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       TRPRLn        Bfp
     C     TRSELn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       TRSELn        Bfp
     C     TREXLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       TREXLn        Bfp
     C     TRSTLn        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       TRSTLn        Bfp
     C     TRCCLn        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       TRCCLn        Bfp
     C     TRSWLn        SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       TRSWLn        Bfp
     C     TRSWLn        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       TRSWLn        Bfp
      **  Extended Settlements                                                                CSE045
     C*****TRTELn        SUBST     BUFFER:Bfp    OthDData                             CSE045 CSF011A
     C     TRTELn        SUBST     BUFFER:Bfp    OthrData                                    CSF011A
     C                   ADD       TRTELn        Bfp                                          CSE045
     C     TRTHLn        SUBST     BUFFER:Bfp    TRANS8                                       222331
     C                   ADD       TRTHLn        Bfp                                          222331
      **  Non-Screen Interface Data for Class 1 enhancements
     C     SETILn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       SETILn        Bfp
     C     SERRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       SERRLn        Bfp                                          CER001
     C     SETRLn        SUBST     BUFFER:Bfp    ExtData

      * SE Walk In Depot Movement

     C     TYPE          WHENEQ    'SEDMWI'

     C     DMWILn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       DMWILn        Bfp
      **  Extended Settlements                                                                CSE045
     C     DMESLn        SUBST     BUFFER:Bfp    OthDData                                     CSE045
     C                   ADD       DMESLn        Bfp                                          CSE045
     C     SEDRLn        SUBST     BUFFER:Bfp    RegData                                      243084
     C                   ADD       SEDRLn        Bfp                                          CER001
     C     SEWILn        SUBST     BUFFER:Bfp    ExtData

      * SE Walk Out Depot Movement

     C     TYPE          WHENEQ    'SEDMWO'

     C     DMWOLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       DMWOLn        Bfp
      **  Extended Settlements                                                                CSE045
     C     DMESLn        SUBST     BUFFER:Bfp    OthDData                                     CSE045
     C                   ADD       DMESLn        Bfp                                          CSE045
     C     SEDRLn        SUBST     BUFFER:Bfp    RegData                                      243084
     C                   ADD       SEDRLn        Bfp                                          CER001
     C     SEWOLn        SUBST     BUFFER:Bfp    ExtData

      * AB Internal Contract

     C     TYPE          WHENEQ    'ABINTC'

     C     INTCLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       INTCLn        Bfp
     C     ABICLn        SUBST     BUFFER:Bfp    ExtData

      * FF exchange-traded futures and options
     C     TYPE          WHENEQ    'FFEXTR'

     C     EXTRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       EXTRLn        Bfp
     C     BSETLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       BSETLn        Bfp
     C     CSETLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       CSETLn        Bfp
     C     FFERLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       FFERLn        Bfp                                          CER001
     C     FFETLn        SUBST     BUFFER:Bfp    ExtData

      * FF over-the-counter options
     C     TYPE          WHENEQ    'FFOTCC'

     C     OTCCLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       OTCCLn        Bfp
     C     CSETLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       CSETLn        Bfp
     C     FFORLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       FFORLn        Bfp                                          CER001
     C     FFOTLn        SUBST     BUFFER:Bfp    ExtData

      ** FF Market Price                                                                      CAP183
                                                                                              CAP183
     C     TYPE          WHENEQ    'FFMPRI'                                                   CAP183
                                                                                              CAP183
     C     MPRILn        SUBST     BUFFER:Bfp    TRANS1                                       CAP183
     C                   ADD       MPRILn        Bfp                                          CAP183
     C     FFMPLn        SUBST     BUFFER:Bfp    ExtData                                      CAP183
                                                                                              CAP183
      ** FF non-currency over-the-counter options

     C     TYPE          WHENEQ    'FFOTCO'

     C     OTCOLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       OTCOLn        Bfp
     C     CSETLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       CSETLn        Bfp
     C     FFOTLn        SUBST     BUFFER:Bfp    ExtData

      * Forward Rates

     C     TYPE          WHENEQ    'FDFWRT'

     C     FWRTLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FWRTLn        Bfp
     C     FDFRLn        SUBST     BUFFER:Bfp    ExtData

      * Money Market Rates

     C     TYPE          WHENEQ    'FDINTR'

     C     INTR1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       INTR1Ln       Bfp
     C     INTR2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       INTR2Ln       Bfp
     C     FDIRLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** Portfolio Definition Details
      *
     C     TYPE          WHENEQ    'PMPFDM'
     C     PFDMLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       PFDMLn        Bfp
     C     PFEXLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** Journal Entry Header Details
      *
     C     TYPE          WHENEQ    'GLBITH'
     C     BITHLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       BITHLn        Bfp
     C     BHEXLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** Journal Entry Item Details
      *
     C     TYPE          WHENEQ    'GLBITP'
     C     BITPLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       BITPLn        Bfp
     C     BIPXLn        SUBST     BUFFER:Bfp    TRANS2                                       246418
     C                   ADD       BIPXLn        Bfp                                          246418
      *                                                                                     BUG23742
     C     500           SUBST     BUFFER:Bfp    TRANS3                                     BUG23742
     C                   ADD       500           Bfp                                        BUG23742
      *                                                                                     BUG23742
     C     270           SUBST     BUFFER:Bfp    TRANS4                                     BUG23742
     C                   ADD       270           Bfp                                        BUG23742
      *                                                                                     BUG23742
     C     GLBRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       GLBRLn        Bfp                                          CER001
     C     BPEXLn        SUBST     BUFFER:Bfp    ExtData
      *

      * FT Outgoing Payment

     C     TYPE          WHENEQ    'FTOPAY'

     C*****OPY1Ln        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
     C     OPY1Ln        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
     C                   ADD       OPY1Ln        Bfp
     C*****OPY2Ln        SUBST     BUFFER:Bfp    TRANS2                                      CSF011A
     C     OPY2Ln        SUBST     BUFFER:Bfp    TRANS2A                                     CSF011A
     C                   ADD       OPY2Ln        Bfp
     C*****OPY3Ln        SUBST     BUFFER:Bfp    TRANS3                                      CSF011A
     C     OPY3Ln        SUBST     BUFFER:Bfp    TRANS3A                                     CSF011A
     C                   ADD       OPY3Ln        Bfp
     C     OPY4Ln        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       OPY4Ln        Bfp
     C     OPY5Ln        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       OPY5Ln        Bfp
     C*****OPY6Ln        SUBST     BUFFER:Bfp    TRANS6                                      CSF011A
     C     OPY6Ln        SUBST     BUFFER:Bfp    TRANS6A                                     CSF011A
     C                   ADD       OPY6Ln        Bfp
     C     OPY7Ln        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       OPY7Ln        Bfp
     C     OPY8Ln        SUBST     BUFFER:Bfp    TRANS8
     C                   ADD       OPY8Ln        Bfp
     C     OPYALn        SUBST     BUFFER:Bfp    TRANS9A                                      CSW209
     C                   ADD       OPYALn        Bfp                                          CSW209
     C     OPYCLn        SUBST     BUFFER:Bfp    TRANS9B                                      CSW209
     C                   ADD       OPYCLn        Bfp                                          CSW209
     C     OPY9Ln        SUBST     BUFFER:Bfp    TRANS9                                       262664
     C                   ADD       OPY9Ln        Bfp                                          262664
     C     OPY10Ln       SUBST     BUFFER:Bfp    TRANS10                                      262664
     C                   ADD       OPY10Ln       Bfp                                          262664
     C     FTORLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       FTORLn        Bfp                                          CER001
     C     OPEXLn        SUBST     BUFFER:Bfp    ExtData

      * SD Customers Details

     C     TYPE          WHENEQ    'SDCUSD'

     C     CUPRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       CUPRLn        Bfp
     C     CUSELn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       CUSELn        Bfp
     C     CUMTLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       CUMTLn        Bfp
     C     CUMRLn        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       CUMRLn        Bfp
     C     CUBR1Ln       SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       CUBR1Ln       Bfp
     C     CUBR2Ln       SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       CUBR2Ln       Bfp
     C     CUPBLn        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       CUPBLn        Bfp
     C     CUSWLn        SUBST     BUFFER:Bfp    TRANS8                                     BUG15052
     C                   ADD       CUSWLn        Bfp                                        BUG15052
     C     SDCRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       SDCRLn        Bfp                                          CER001
     C     FTCSLn        SUBST     BUFFER:Bfp    TRANS9C                                      CGL132
     C                   ADD       CUSWLn        Bfp                                          CGL132
     C     SDCULn        SUBST     BUFFER:Bfp    ExtData


      * GL Accounts Maintenance

     C     TYPE          WHENEQ    'GLAMAD'

     C     AMMDLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       AMMDLn        Bfp
     C     AMDILn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       AMDILn        Bfp
     C     AMCILn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       AMCILn        Bfp
     C     AMCOLn        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       AMCOLn        Bfp
     C     AMODLn        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       AMODLn        Bfp
     C     GLARLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       GLARLn        Bfp                                          CER001
     C     GLAMLn        SUBST     BUFFER:Bfp    ExtData


      * SE Price Input

     C     TYPE          WHENEQ    'SEPRCS'

     C     PRCSLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       PRCSLn        Bfp
     C     PRCXLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** Funds Transfer - Incoming Payments
      *
     C     TYPE          WHENEQ    'FTIPAY'
     C*****IPY1Ln        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
     C     IPY1Ln        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
     C                   ADD       IPY1Ln        Bfp
     C     IPY2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       IPY2Ln        Bfp
     C*****IPY3Ln        SUBST     BUFFER:Bfp    TRANS3                                      CSF011A
     C     IPY3Ln        SUBST     BUFFER:Bfp    TRANS3A                                     CSF011A
     C                   ADD       IPY3Ln        Bfp
     C     IPY4Ln        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       IPY4Ln        Bfp
     C*****IPY5Ln        SUBST     BUFFER:Bfp    TRANS5                                      CSF011A
     C     IPY5Ln        SUBST     BUFFER:Bfp    TRANS5A                                     CSF011A
     C                   ADD       IPY5Ln        Bfp
     C     IPY6Ln        SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       IPY6Ln        Bfp
     C     IPY7Ln        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       IPY7Ln        Bfp
     C     IPY8Ln        SUBST     BUFFER:Bfp    TRANS8
     C                   ADD       IPY8Ln        Bfp
     C     IPY9ALn       SUBST     BUFFER:Bfp    TRANS9A                                      CSW209
     C                   ADD       IPY9ALn       Bfp                                          CSW209
     C     IPY9BLn       SUBST     BUFFER:Bfp    TRANS9B                                      CSW209
     C                   ADD       IPY9BLn       Bfp                                          CSW209
     C     IPY9Ln        SUBST     BUFFER:Bfp    TRANS9                                       262664
     C                   ADD       IPY9Ln        Bfp                                          262664
     C*****IPY9Ln        SUBST     BUFFER:Bfp    TRANS9                               CER030 CER034A
     C**********         ADD       IPY9Ln        Bfp                                  CER030 CER034A
     C     FTIRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       FTIRLn        Bfp                                          CER001
     C     IPEXLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** Securities
      *
     C     TYPE          WHENEQ    'SESECS'
     C     SEC1Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SEC1Ln        Bfp
     C     SEC2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       SEC2Ln        Bfp
     C     SEC3Ln        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       SEC3Ln        Bfp
     C     SEC4Ln        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       SEC4Ln        Bfp
     C     SESRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       SESRLn        Bfp                                          CER001
     C     SEEXLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** SD Security Customer Details
      *
     C     TYPE          WHENEQ    'SDSECD'
     C     SECDLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SECDLn        Bfp
     C     SDSOLn        SUBST     BUFFER:Bfp    OthDData
     C                   ADD       SDSOLn        Bfp
     C     SDSELn        SUBST     BUFFER:Bfp    ExtData
      *
      ** SE Security Diary Events Detail
      *
     C     TYPE          WHENEQ    'SESEDE'
     C     SEDELn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SEDELn        Bfp
     C     SDEXLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** SD Additional Customer Detail                                                        CGL032
      *                                                                                       CGL032
     C     TYPE          WHENEQ    'SDACUD'                                                   CGL032
     C*****ACUDLn        SUBST     BUFFER:Bfp    TRANS1                              CGL032 BUG25877
     C     ACUDLn        SUBST     BUFFER:Bfp    TRANS1B                                    BUG25877
     C**********         ADD       ACEXLn        Bfp                                  CGL032 CER034A
     C                   ADD       ACUDLn        Bfp                                         CER034A
      *                                                                                       CER034
     C                   EVAL      Trans2 = %SUBST(BUFFER : Bfp : WACUD1)                     CER034
     C                   ADD       WACUD1        Bfp                                          CER034
      *                                                                                       CER034
     C                   EVAL      Trans3 = %SUBST(BUFFER : Bfp : WACUD2)                     CER034
     C                   ADD       WACUD2        Bfp                                          CER034
      *                                                                                       CER034
     C**********         EVAL      Trans4 = %SUBST(BUFFER : Bfp : 500)                CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans5 = %SUBST(BUFFER : Bfp : 500)                CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans6 = %SUBST(BUFFER : Bfp : 500)                CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans7 = %SUBST(BUFFER : Bfp : 500)                CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans8 = %SUBST(BUFFER : Bfp : 500)                CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans9 = %SUBST(BUFFER : Bfp : 500)                CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans10 = %SUBST(BUFFER : Bfp : 500)               CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans11 = %SUBST(BUFFER : Bfp : 500)               CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans12 = %SUBST(BUFFER : Bfp : 500)               CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans13 = %SUBST(BUFFER : Bfp : 500)               CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans14 = %SUBST(BUFFER : Bfp : 500)               CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans15 = %SUBST(BUFFER : Bfp : 500)               CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans16 = %SUBST(BUFFER : Bfp : 500)               CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C**********         EVAL      Trans17 = %SUBST(BUFFER : Bfp : 500)               CER034 CER034A
     C**********         ADD       500           Bfp                                  CER034 CER034A
      *                                                                                       CER034
     C     ACEXLn        SUBST     BUFFER:Bfp    ExtData                                      CGL032
      *                                                                                      CER034A
      ** SD Customer/Authority Details                                                       CER034A
      *                                                                                      CER034A
     C     TYPE          WHENEQ    'SDCUAH'                                                  CER034A
     C     CUAH1Ln       SUBST     BUFFER:Bfp    TRANS1                                      CER034A
     C                   ADD       CUAH1Ln       Bfp                                         CER034A
      *                                                                                      CER034A
     C     CUAH2Ln       SUBST     BUFFER:Bfp    TRANS2                                      CER034A
     C                   ADD       CUAH2Ln       Bfp                                         CER034A
      *                                                                                      CER034A
     C     CUAH3Ln       SUBST     BUFFER:Bfp    TRANS3                                      CER034A
     C                   ADD       CUAH3Ln       Bfp                                         CER034A
      *                                                                                      CER034A
     C     CUAH4Ln       SUBST     BUFFER:Bfp    TRANS4                                      CER034A
     C                   ADD       CUAH4Ln       Bfp                                         CER034A
      *                                                                                      CER034A
     C     CUAH5Ln       SUBST     BUFFER:Bfp    TRANS5                                      CER034A
     C                   ADD       CUAH5Ln       Bfp                                         CER034A
      *                                                                                      CER034A
     C     CUAH6Ln       SUBST     BUFFER:Bfp    TRANS6                                      CER034A
     C                   ADD       CUAH6Ln       Bfp                                         CER034A
      *                                                                                      CER034A
     C     CUAH7Ln       SUBST     BUFFER:Bfp    TRANS7                                      CER034A
     C                   ADD       CUAH7Ln       Bfp                                         CER034A
      *                                                                                      CER034A
     C     CUEXLn        SUBST     BUFFER:Bfp    ExtData                                     CER034A
      *                                                                                       CGL032
      ** SD Non-A/C Holders Detail                                                            CGL032
      *                                                                                       CGL032
     C     TYPE          WHENEQ    'SDNAHL'                                                   CGL032
     C*****SDNALn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 CGL132
     C     SDNALn        SUBST     BUFFER:Bfp    TRANS9A                                      CGL132
     C                   ADD       SDNALn        Bfp                                          CGL132
     C     FTNHLn        SUBST     BUFFER:Bfp    TRANS9C                                      CGL132
     C                   ADD       FTNHLn        Bfp                                          CGL132
     C                   ADD       NaEXLn        Bfp                                          CGL032
     C                   EVAL      Trans2 = %SUBST(BUFFER : Bfp : 500)                        CER047
     C                   ADD       500           Bfp                                          CER047
     C     NaEXLn        SUBST     BUFFER:Bfp    ExtData                                      CGL032
      *                                                                                       CGL032
      ** SD Non-A/C Holders Detail                                                            CGL032
      *                                                                                       CGL032
     C     TYPE          WHENEQ    'SDCCTX'                                                   CGL032
     C     CCTXLn        SUBST     BUFFER:Bfp    TRANS1                                       CGL032
      *                                                                                       CGL032
      ** SD Non-A/C Holders Detail                                                            CGL032
      *                                                                                       CGL032
     C     TYPE          WHENEQ    'SDNATX'                                                   CGL032
     C     NATXLn        SUBST     BUFFER:Bfp    TRANS1                                       CGL032
      *                                                                                       CGL032
      ** SD Joint A/c Members Detail                                                          CGL032
      *                                                                                       CGL032
     C     TYPE          WHENEQ    'SDJACM'                                                   CGL032
     C     JACMLn        SUBST     BUFFER:Bfp    TRANS1                                       CGL032
      *
      ** SD Market Data Feed Spot Rate Details
      *
     C     TYPE          WHENEQ    'SDSPTR'
     C     SPTRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SPTRLn        Bfp
     C     SDSPLn        SUBST     BUFFER:Bfp    ExtData
      *
      * SD Base Rate Maintenance

     C*****TYPE          WHENEQ    'SDBSRT'                                                   BG5977
     C     TYPE          WHENEQ    'SDBSRS'                                                   BG5977

     C     SDBSLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SDBSLn        Bfp
     C     SDBXLn        SUBST     BUFFER:Bfp    ExtData

      ** AB Internal Funding Deals Detail
      *
     C     TYPE          WHENEQ    'ABFUND'
     C     FUNDLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FUNDLn        Bfp
     C     FUEXLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** MM REPOs Loans & Deposits Detail
      *
     C     TYPE          WHENEQ    'MMRPLD'
     C     LDNILn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LDNILn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     MMLILn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       MMLILn        Bfp
     C     MMLDLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** MM REPOs Depot Movements Detail
      *
     C     TYPE          WHENEQ    'MMRPDM'
     C     REP1Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       REP1Ln        Bfp
     C     MMLDLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** MM REPOs Trailer Detail
      *
     C     TYPE          WHENEQ    'MMRPTR'
     C     REP2Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       REP2Ln        Bfp
     C     MMLDLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** SE Buy-Sell Trade
      *
     C     TYPE          WHENEQ    'SEBYSL'

     C     20            SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       20            Bfp
     C                   EVAL      %SUBST(TRANS1:21) = %SUBST(BUFFER:Bfp:TRPRLn)
     C                   ADD       TRPRLn        Bfp
     C     TRSELn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       TRSELn        Bfp
     C     TREXLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       TREXLn        Bfp
     C     TRSTLn        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       TRSTLn        Bfp
     C     TRCCLn        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       TRCCLn        Bfp
     C     TRSWLn        SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       TRSWLn        Bfp
     C     TRSWLn        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       TRSWLn        Bfp
     C     TRTHLn        SUBST     BUFFER:Bfp    TRANS8                                       222331
     C                   ADD       TRTHLn        Bfp                                          222331
      *
      **  Non-Screen Interface Data for Class 1 enhancements
      *
     C     SETILn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       SETILn        Bfp
     C     SETRLn        SUBST     BUFFER:Bfp    ExtData

      ** SD Yield Rates Details

     C     TYPE          WHENEQ    'SDYRAT'

     C     YRAT1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       YRAT1Ln       Bfp
     C     YRAT2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       YRAT2Ln       Bfp
     C     YRAT3Ln       SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       YRAT3Ln       Bfp
     C     YRAT4Ln       SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       YRAT4Ln       Bfp
     C     SDYRLn        SUBST     BUFFER:Bfp    ExtData

      * LE Assignments

     C     TYPE          WHENEQ    'LEASGN'

     C     ASGNLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       ASGNLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp

      * LE Risk Participants

     C     TYPE          WHENEQ    'LERPRT'

     C     RPRTLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       RPRTLn        Bfp
     C     LIAB1Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LIAB1Ln       Bfp
     C     LIAB2Ln       SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       LIAB2Ln       Bfp
     C     LIAZLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       LIAZLn        Bfp

      * LE Funding Participants

     C     TYPE          WHENEQ    'LEFPRT'

     C     FPRTLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FPRTLn        Bfp
     C     LIAB1Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LIAB1Ln       Bfp
     C     LIAB2Ln       SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       LIAB2Ln       Bfp
     C     LIAZLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       LIAZLn        Bfp

      * LE Facility Amendments

     C     TYPE          WHENEQ    'LEFAMD'

     C     FAMDLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FAMDLn        Bfp

      * LE Fee Adjustment input

     C     TYPE          WHENEQ    'LEFEAD'

     C     FEADLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FEADLn        Bfp

      * LE Fee Settlement input

     C     TYPE          WHENEQ    'LEFEST'

     C     FESTLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FESTLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp

      * LE Facility Input

     C     TYPE          WHENEQ    'LEFCTY'

     C     FCTY1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FCTY1Ln       Bfp
     C     FCTY2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       FCTY2Ln       Bfp
     C     FCTY3Ln       SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       FCTY3Ln       Bfp

      * LE Loans Input

     C     TYPE          WHENEQ    'LELOAN'

     C     LOAN1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LOAN1Ln       Bfp
     C     LOAN2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LOAN2Ln       Bfp
     C     LOAN3Ln       SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       LOAN3Ln       Bfp

      * LE Participations Purchased Input

     C     TYPE          WHENEQ    'LEPTPU'

     C     PTPU1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       PTPU1Ln       Bfp
     C     PTPU2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       PTPU2Ln       Bfp
     C     PTPU3Ln       SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       PTPU3Ln       Bfp

      * LE Participations Sold Input

     C     TYPE          WHENEQ    'LEPTSO'

     C     PTSO1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       PTSO1Ln       Bfp
     C     PTSO2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       PTSO2Ln       Bfp
     C     PTSO3Ln       SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       PTSO3Ln       Bfp

      * LE Loan Amendments Input - Principal Transfer To

     C     TYPE          WHENEQ    'LELAPT'

     C     LAPT1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LAPT1Ln       Bfp
     C     LAPT2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LAPT2Ln       Bfp

      * LE Loan Amendments Input - Principal Transfer From

     C     TYPE          WHENEQ    'LELAPF'

     C     LAPF1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LAPF1Ln       Bfp
     C     LAPF2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LAPF2Ln       Bfp

      * LE Loan Amendments Input - Principal Increase

     C     TYPE          WHENEQ    'LELAPI'

     C     LAPI1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LAPI1Ln       Bfp
     C     LAPI2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LAPI2Ln       Bfp
     C     LAPI3Ln       SUBST     BUFFER:Bfp    TRANS3                                     AR400813
     C                   ADD       LAPI3Ln       Bfp                                        AR400813

      * LE Loan Amendments Input - Base Rate Change

     C     TYPE          WHENEQ    'LELABC'

     C     LABC1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LABC1Ln       Bfp
     C     LABC2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LABC2Ln       Bfp

      * LE Loan Amendments Input - Spread Change

     C     TYPE          WHENEQ    'LELASC'

     C     LASC1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LASC1Ln       Bfp
     C     LASC2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LASC2Ln       Bfp

      * LE Loan Amendments Input - Stop/Start Accrual

     C     TYPE          WHENEQ    'LELASA'

     C     LASA1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LASA1Ln       Bfp
     C     LASA2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LASA2Ln       Bfp

      * LE Loan Amendments Input - Stop/Start Accrual

     C     TYPE          WHENEQ    'LELALS'

     C     LALS1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LALS1Ln       Bfp
     C     LALS2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LALS2Ln       Bfp

      * LE Rollover Input

     C     TYPE          WHENEQ    'LEROLL'

     C     ROLL1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       ROLL1Ln       Bfp
     C     ROLL2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       ROLL2Ln       Bfp

      * LE Manual Repayment

     C     TYPE          WHENEQ    'LELAMR'

     C     LAMR1Ln       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LAMR1Ln       Bfp
     C     LAMR2Ln       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LAMR2Ln       Bfp

      * LE Fees Input

     C     TYPE          WHENEQ    'LEFEEM'
     C*****TYPE          OREQ      'LEFEES'                                          256353A 256407A
      *
     C     FEEMLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FEEMLn        Bfp
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     247770
     C*****              ADD       ESSRLn        Bfp                                          247770
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     247770
     C*****              ADD       ESSPLn        Bfp                                          247770
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     247770
     C                   ADD       ESSPLn        Bfp                                          247770
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     247770
     C                   ADD       ESSRLn        Bfp                                          247770
                                                                                             256407A
      * LE Fees Input                                                                        256407A
                                                                                             256407A
     C     TYPE          WHENEQ    'LEFEES'                                                  256407A
      *                                                                                      256407A
     C     FEES1Ln       SUBST     BUFFER:Bfp    TRANS1                                      256407A
     C                   ADD       FEES1Ln       Bfp                                         256407A
     C     FEES2Ln       SUBST     BUFFER:Bfp    TRANS2                                      256407A
     C                   ADD       FEES2Ln       Bfp                                         256407A
     C     FEES3Ln       SUBST     BUFFER:Bfp    TRANS3                                      256407B
     C                   ADD       FEES3Ln       Bfp                                         256407B
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                    256407A
     C                   ADD       ESSPLn        Bfp                                         256407A
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                    256407A
     C                   ADD       ESSRLn        Bfp                                         256407A
      * LE Facility                                                                           BG5888
                                                                                              BG5888
     C     TYPE          WHENEQ    'LEFCIP'                                                   BG5888
                                                                                              BG5888
     C     FCI1Ln        SUBST     BUFFER:Bfp    TRANS1                                       BG5888
     C                   ADD       FCI1Ln        Bfp                                          BG5888
                                                                                              BG5888
     C     FCI2Ln        SUBST     BUFFER:Bfp    TRANS2                                       BG5888
     C                   ADD       FCI2Ln        Bfp                                          BG5888
     C     LEFRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       LEFRLn        Bfp                                          CER001
                                                                                              BG5888
      * LE Loans                                                                              BG5888
                                                                                              BG5888
     C     TYPE          WHENEQ    'LECLIP_N'                                                 BG5888
     C     TYPE          OREQ      'LECLIP_U'                                                 BG5888
     C     TYPE          OREQ      'LECLIP_O'                                                 BG5888
                                                                                              BG5888
     C     CLI1Ln        SUBST     BUFFER:Bfp    TRANS1                                       BG5888
     C                   ADD       CLI1Ln        Bfp                                          BG5888
     C     CLI2Ln        SUBST     BUFFER:Bfp    TRANS2                                       BG5888
     C                   ADD       CLI2Ln        Bfp                                          BG5888
     C     CLI3Ln        SUBST     BUFFER:Bfp    TRANS3                                       BG5888
     C                   ADD       CLI3Ln        Bfp                                          BG5888
     C     CLI4Ln        SUBST     BUFFER:Bfp    TRANS4                                       BG5888
     C                   ADD       CLI4Ln        Bfp                                          BG5888
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     BG5888
     C                   ADD       ESSRLn        Bfp                                          BG5888
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     BG5888
     C                   ADD       ESSPLn        Bfp                                          BG5888
     C     LECRLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       LECRLn        Bfp                                          CER001
                                                                                              BG5888
      * LE Rollover Instructions                                                              BG5888
     C     TYPE          WHENEQ    'LELERI'                                                   BG5888
                                                                                              BG5888
     C     LERILn        SUBST     BUFFER:Bfp    TRANS1                                       BG5888
     C                   ADD       LERILn        Bfp                                          BG5888
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     BG5888
     C                   ADD       ESSRLn        Bfp                                          BG5888
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     BG5888
     C                   ADD       ESSPLn        Bfp                                          BG5888
                                                                                              BG5888
      * LE Loan amendments                                                                    BG5888
     C     TYPE          WHENEQ    'LELOAM'                                                   BG5888
                                                                                              BG5888
     C     LOAMLn        SUBST     BUFFER:Bfp    TRANS1                                       BG5888
     C                   ADD       LOAMLn        Bfp                                          BG5888
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     BG5888
     C                   ADD       ESSRLn        Bfp                                          BG5888
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     BG5888
     C                   ADD       ESSPLn        Bfp                                          BG5888
      *                                                                                       BG5888
      * LE Repayments schedule                                                                BG5888
     C     TYPE          WHENEQ    'LERPSC'                                                   BG5888
      *                                                                                       BG5888
     C     RPSCLn        SUBST     BUFFER:Bfp    TRANS1                                       BG5888
     C                   ADD       RPSCLn        Bfp                                          BG5888
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     BG5888
     C                   ADD       ESSRLn        Bfp                                          BG5888
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     BG5888
     C                   ADD       ESSPLn        Bfp                                          BG5888
      *                                                                                       BG5888
      * LE Manual payments                                                                    BG5888
     C     TYPE          WHENEQ    'LEMAPY'                                                   BG5888
      *                                                                                       BG5888
     C     MAPYLn        SUBST     BUFFER:Bfp    TRANS1                                       BG5888
     C                   ADD       RPSCLn        Bfp                                          BG5888
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     BG5888
     C                   ADD       ESSRLn        Bfp                                          BG5888
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     BG5888
     C                   ADD       ESSPLn        Bfp                                          BG5888

      ** IR Caps/Collars/Floors Details

     C     TYPE          WHENEQ    'IRCACF'

     C     CACFLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       CACFLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp

      **  Non-Screen Interface Data for Class 1 enhancements

     C     IRRPLn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       IRRPLn        Bfp
     C     CACXLn        SUBST     BUFFER:Bfp    ExtData

      ***LE*Funding*Participants***************************************                       256330
      *****************************************************************                       256330
     C**********         MOVEL     'LEFPRTPD'    FileName                                     256330
     C**********         EXSR      GETRCDLN                                                   256330
     C**********         Z-ADD     RecordLen     FPRTLn            4 0                        256330
      *****************************************************************                       256330
      ***LE*Facility*Amendments****************************************                       256330
      *****************************************************************                       256330
     C**********         MOVEL     'LEFAMDPD'    FileName                                     256330
     C**********         EXSR      GETRCDLN                                                   256330
     C**********         Z-ADD     RecordLen     FAMDLn            4 0                        256330
      *****************************************************************                       256330
      ***LE*Fee*Adjustment*input***************************************                       256330
      *****************************************************************                       256330
     C**********         MOVEL     'LEFEADPD'    FileName                                     256330
     C**********         EXSR      GETRCDLN                                                   256330
     C**********         Z-ADD     RecordLen     FEADLn            4 0                        256330
      *****************************************************************                       256330
      ***LE*Fee*Settlement*input***************************************                       256330
      *****************************************************************                       256330
     C**********         MOVEL     'LEFESTPD'    FileName                                     256330
     C**********         EXSR      GETRCDLN                                                   256330
     C**********         Z-ADD     RecordLen     FESTLn            4 0                        256330
      ** Principal Change Schedules (Caps/Collars/Floors)

     C     TYPE          WHENEQ    'IRCAPC'

      ** Principal Change

     C     WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WPCSC1OLn     Bfp
     C     WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       WPCSC2OLn     Bfp
     C     WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       WPCSC3OLn     Bfp
     C     WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       WPCSC4OLn     Bfp

      ** Trailer record (Caps/Collars/Floors)

     C     TYPE          WHENEQ    'IRCATR'

     C     WTRSCLn       SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       WTRSCLn       Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp
     C     IRRPLn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       IRRPLn        Bfp
     C     IRSSLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** SE Movements Details
      *
     C     TYPE          WHENEQ    'SEMVTS'
     C     MVTSLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       MVTSLn        Bfp
     C     MVEXLn        SUBST     BUFFER:Bfp    ExtData

      ** SE Trade Settlements Details
      *
     C     TYPE          WHENEQ    'SETRSM'
     C     TRSMLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       TRSMLn        Bfp
     C     TREXLn        SUBST     BUFFER:Bfp    ExtData
      *
      ** SE Statement Production Requests
      *
     C     TYPE          WHENEQ    'SESTPR'
     C     STPRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       STPRLn        Bfp
     C     SPEXLn        SUBST     BUFFER:Bfp    ExtData

      **  Dealing Fees                                                                        CAS009
                                                                                              CAS009
     C     TYPE          WHENEQ    'DLDLFE'                                                   CAS009
     C     CAS009        ANDEQ     'Y'                                                        CAS009
                                                                                              CAS009
     C     DLFELn        SUBST     BUFFER:Bfp    TRANS1                                       CAS009
     C                   ADD       DLFELn        Bfp                                          CAS009
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAS009
     C                   ADD       ESSRLn        Bfp                                          CAS009
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAS009
     C                   ADD       ESSPLn        Bfp                                          CAS009
     C     DFEXLn        SUBST     BUFFER:Bfp    ExtData                                      CAS009
                                                                                              CAS009
      *                                                                                       CSD093
      ** SD Document Management Details                                                       CSD093
      *                                                                                       CSD093
     C     TYPE          WHENEQ    'SDDCMT'                                                   CSD093
     C     DCMTLn        SUBST     BUFFER:Bfp    TRANS1                                       CSD093
     C                   ADD       DCMTLn        Bfp                                          CSD093
     C     DCMXLn        SUBST     BUFFER:Bfp    ExtData                                      CSD093
      *                                                                                       CSD093
      ** SD Account Review                                                                    CSD092
                                                                                              CSD092
     C     TYPE          WHENEQ    'SDACRV'                                                   CSD092
                                                                                              CSD092
     C     500           SUBST     BUFFER:Bfp    TRANS1                                       CSD092
     C                   ADD       500           Bfp                                          CSD092
     C     ACRVLn1       SUBST     BUFFER:Bfp    TRANS2                                       CSD092
     C                   ADD       ACRVLn1       Bfp                                          CSD092
     C     ACRXLn        SUBST     BUFFER:Bfp    ExtData                                      CSD092
                                                                                              CSD092
     C/COPY WNCPYSRC,APPARSMMC1
      *
      ** Any unrecognised message types are written to the error file
      *
     C                   OTHER
     C                   EVAL      Bypass = 'Y'
     C                   ENDSL


     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Get Record Lengths of Transaction Data Blocks               *
      *                                                              *
      ****************************************************************
     C     GETRCDLN      BEGSR

     C                   CALLB     'UTGETRCDLN'

      ** Return code
     C                   PARM                    ReturnCode
      ** Record length
     C                   PARM      *ZERO         RecordLen         5 0

      ** File name
     C                   PARM                    FileName         10
      ** File library
     C                   PARM      '*LIBL     '  FileLib          10

      ** Clear the file name field to prevent it getting corrupted by
      ** later MOVELs.
     C                   CLEAR                   FileName

     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Initialisation                                              *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    BUFFER
     C                   PARM                    TRANS1
     C                   PARM                    TRANS1A                                     BUG9887
     C                   PARM                    TRANS1B                                    BUG25877
     C                   PARM                    TRANS2
     C                   PARM                    TRANS3
     C                   PARM                    TRANS3A                                      CFT120
     C                   PARM                    TRANS4
     C                   PARM                    TRANS5
     C                   PARM                    TRANS5A                                      CFT120
     C                   PARM                    TRANS6
     C                   PARM                    TRANS7
     C                   PARM                    TRANS8
     C                   PARM                    TRANS9
     C                   PARM                    TRANS9A                                      CSW209
     C                   PARM                    TRANS9B                                      CSW209
     C                   PARM                    TRANS10                                      262664
     C                   PARM                    TRANS9C                                      CGL132
     C**********         PARM                    Trans10                              CER034 CER034A
     C**********         PARM                    Trans11                              CER034 CER034A
     C**********         PARM                    Trans12                              CER034 CER034A
     C**********         PARM                    Trans13                              CER034 CER034A
     C**********         PARM                    Trans14                              CER034 CER034A
     C**********         PARM                    Trans15                              CER034 CER034A
     C**********         PARM                    Trans16                              CER034 CER034A
     C**********         PARM                    Trans17                              CER034 CER034A
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    PayStmtV
     C                   PARM                    RecStmtV
     C                   PARM                    PayStmtM
     C                   PARM                    RecStmtM
     C                   PARM                    InfData
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    OthDData
     C                   PARM                    InSwift2013                                MD054039
     C                   PARM                    Trans9999_2                                MD054039
     C                   PARM                    Trans9999_3                                MD054039
     C                   PARM                    Bypass            1

      ** Set up the procedure/module/program names
     C                   EVAL      #ProcPgm  = PSProcPgm
     C                   EVAL      #ProcMod  = PSProcMod
     C                   EVAL      #ProcName = PSProcName

      ** Determine API Header record lengths

     C                   MOVEL     'APHEADPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     HEADLn            4 0

      ** Determine transaction data record lengths

      ** (Dealing) Extended Payment Instructions

     C                   MOVEL     'SDESSPPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ESSPLn            4 0

      ** (Dealing) Extended Receive Instructions

     C                   MOVEL     'SDESSRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ESSRLn            4 0

      ** (Dealing) Extended FRA/IRS Instructions

     C                   MOVEL     'SDESSFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ESSFLn            4 0

      ** FX deals

     C                   MOVEL     'FXFXDLPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FXDLLn            4 0

      ** Loans/deposits

     C                   MOVEL     'MMLDNIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LDNILn            4 0

     C                   MOVEL     'MMFIDT1PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT1Ln
     C                   MOVEL     'MMFIDT2PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT2Ln
     C                   MOVEL     'MMFIDT3PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT3Ln
     C                   MOVEL     'MMFIDT4PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT4Ln
     C                   MOVEL     'MMFIDT5PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT5Ln
     C                   MOVEL     'MMFIDT6PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT6Ln
     C                   MOVEL     'MMFIDT7PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT7Ln
     C                   MOVEL     'MMFIDT8PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT8Ln
     C                   MOVEL     'MMFIDT9PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WFIDT9Ln

      ** Deal Amendments

     C                   MOVEL     'MMDEAMPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DEAMLn            4 0

      ** NAs Purchased

     C                   MOVEL     'MMNASPPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     NASPLn            4 0

      ** NAs Sold

     C                   MOVEL     'MMNASSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     NASSLn            4 0

      ** Forward Rate Agreements

     C                   MOVEL     'IRFRAPD '    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FRALn             4 0

      ** Single Currency Interest Rate Swaps

     C                   MOVEL     'IRSIRSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SIRSLn            4 0
     C                   MOVEL     'IRDTSCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DTORLn            4 0
     C                   Z-ADD     RecordLen     DTOPLn            4 0
     C                   Z-ADD     RecordLen     DTTRLn            4 0
     C                   Z-ADD     RecordLen     DTTPLn            4 0

      ** Cross Currency Interest Rate Swaps

     C                   MOVEL     'IRCIRSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CIRSLn            4 0
     C                   MOVEL     'IRDTSCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DTORLn            4 0
     C                   Z-ADD     RecordLen     DTOPLn            4 0
     C                   Z-ADD     RecordLen     DTTRLn            4 0
     C                   Z-ADD     RecordLen     DTTPLn            4 0

      ** SE Trade: Primary, Secondary, Exchange Rates, Settlement Details,
      **           Charges & Commissions, SWIFT Details

     C                   MOVEL     'SETRPRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRPRLn            4 0
     C                   MOVEL     'SETRSEPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRSELn            4 0
     C                   MOVEL     'SETRTHPD'    FileName                                     222331
     C                   EXSR      GETRCDLN                                                   222331
     C                   Z-ADD     RecordLen     TRTHLn            4 0                        222331
     C                   MOVEL     'SETREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TREXLn            4 0
     C                   MOVEL     'SETRSTPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRSTLn            4 0
     C                   MOVEL     'SETRCCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRCCLn            4 0
     C                   MOVEL     'SETRSWPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRSWLn            4 0
                                                                                              CSE045
      ** Trades Extended Settlement Detail                                                    CSE045
                                                                                              CSE045
     C                   MOVEL     'SETESDPD'    FileName                                     CSE045
     C                   EXSR      GETRCDLN                                                   CSE045
     C     2             MULT      RecordLen     TRTELn            4 0                        CSE045

      ** SE Walk In Depot Movement

     C**********         MOVEL     'SEDMWIPD'    FileName                                     CSE045
     C                   MOVEL     'SEDMIDPD'    FileName                                     CSE045
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DMWILn            4 0

      ** SE Walk Out Depot Movement

     C**********         MOVEL     'SEDMWOPD'    FileName                                     CSE045
     C                   MOVEL     'SEDMODPD'    FileName                                     CSE045
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DMWOLn            4 0
                                                                                              CSE045
      ** SE API Depot Movement Extended Settlements                                           CSE045
                                                                                              CSE045
     C                   MOVEL     'SEDMESPD'    FileName                                     CSE045
     C                   EXSR      GETRCDLN                                                   CSE045
     C                   Z-ADD     RecordLen     DMESLn            4 0                        CSE045

      ** AB Internal Contracts

     C                   MOVEL     'ABINTCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     INTCLn            4 0

      ** FF Exchange-traded futures and options: comprises transaction
      ** details, broker settlements details and customer settlements
      ** details.
     C                   MOVEL     'FFEXTRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     EXTRLn            4 0

     C                   MOVEL     'FFBSETPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     BSETLn            4 0

     C                   MOVEL     'FFCSETPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CSETLn            4 0

      ** FF Currency over-the-counter options: comprises transaction
      ** details and customer settlements details (the latter length is
      ** determined above).
     C                   MOVEL     'FFOTCCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OTCCLn            4 0

      ** FF non-currency over-the-counter options: comprises transaction
      ** details and customer settlements details (the latter length is
      ** determined above).

     C                   MOVEL     'FFOTCOPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OTCOLn            4 0
                                                                                              CAP183
      ** FF Market Price                                                                      CAP183
                                                                                              CAP183
     C                   MOVEL     'FFMPRIPD'    FileName                                     CAP183
     C                   EXSR      GETRCDLN                                                   CAP183
     C                   Z-ADD     RecordLen     MPRILn            4 0                        CAP183

      ** Forward Rates

     C                   MOVEL     'FDFWRTPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FWRTLn            4 0

      ** Money Market Rates

     C**********         MOVEL     'FDINTR1PD'   FileName                                     BG6335
     C**********         EXSR      GETRCDLN                                                   BG6335
     C**********         Z-ADD     RecordLen     INTR1Ln           4 0                        BG6335
     C**********         MOVEL     'FDINTR2PD'   FileName                                     BG6335
     C**********         EXSR      GETRCDLN                                                   BG6335
     C**********         Z-ADD     RecordLen     INTR2Ln           4 0                        BG6335
     C                   MOVEL     'FDINTRPD'    FileName                                     BG6335
     C                   EXSR      GETRCDLN                                                   BG6335
     C                   Z-ADD     500           INTR1Ln           4 0                        BG6335
     C     RecordLen     SUB       500           INTR2Ln           4 0                        BG6335

      ** FT Outgoing Payment : First, Second, Third and Fourth Details
      **                     : Fifth, Sixth, Seventh and Eighth

     C                   MOVEL     'FTOPY1PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY1Ln            4 0
     C                   MOVEL     'FTOPY1APD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY2Ln            4 0
     C                   MOVEL     'FTOPY2PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY3Ln            4 0
     C                   MOVEL     'FTOPY3PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY4Ln            4 0
     C                   MOVEL     'FTOPY4PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY5Ln            4 0
     C                   MOVEL     'FTOPY5PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY6Ln            4 0
     C                   MOVEL     'FTOPY6PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY7Ln            4 0
     C                   MOVEL     'FTOPY7PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY8Ln            4 0
     C                   MOVEL     'FTOPYAPD'    FileName                                     CSW209
     C                   EXSR      GETRCDLN                                                   CSW209
     C                   Z-ADD     RecordLen     OPYALn                                       CSW209
     C                   MOVEL     'FTOPYCPD'    FileName                                     CSW209
     C                   EXSR      GETRCDLN                                                   CSW209
     C                   Z-ADD     RecordLen     OPYCLn                                       CSW209
     C                   MOVEL     'FTOPY7APD'   FileName                                     262664
     C                   EXSR      GETRCDLN                                                   262664
     C                   Z-ADD     RecordLen     OPY9Ln            4 0                        262664
     C                   MOVEL     'FTOPY7BPD'   FileName                                     262664
     C                   EXSR      GETRCDLN                                                   262664
     C                   Z-ADD     RecordLen     OPY10Ln           4 0                        262664

      ** SD Customers: Primary, Secondary, Message Routing,
      **               Base Rate Tax details and Private Banking

     C                   MOVEL     'SDCUPRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CUPRLn            4 0
     C                   MOVEL     'SDCUSEPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CUSELn            4 0
     C                   MOVEL     'SDCUMTPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CUMTLn            4 0
     C                   MOVEL     'SDCUMRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CUMRLn            4 0
     C                   MOVEL     'SDCUBRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CUBRLn            4 0
     C                   Z-ADD     500           CUBR1Ln           4 0
     C     Recordlen     SUB       CUBR1Ln       CUBR2Ln           4 0
     C                   MOVEL     'SDCUPBPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CUPBLn            4 0
                                                                                             BG15052
     C**********         MOVEL     'SDCSSWPD'    FileName                          BG15052 BUG15052A
     C                   MOVEL     'SDCUSWPD'    FileName                                  BUG15052A
     C                   EXSR      GETRCDLN                                                  BG15052
     C                   Z-ADD     RecordLen     CUSWLn            4 0                       BG15052

      ** GL Accounts maintenance : Master, Debit interests, Credit interests
      **               Commissions & Overdraft charges and Other details

     C                   MOVEL     'GLAMADPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMMDLn            4 0
     C                   MOVEL     'GLAMDIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMDILn            4 0
     C                   MOVEL     'GLAMCIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMCILn            4 0
     C                   MOVEL     'GLAMCOPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMCOLn            4 0
     C                   MOVEL     'GLAMODPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMODLn            4 0

      ** SD Security Customer Details:

     C                   MOVEL     'SDSECDPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SECDLn            4 0

     **  SD Other Depot Details layout file for APIs
     **  (Set this to the length of the expected message length)
     C                   Z-ADD     4755          SDSOLn            4 0
      *
      ** Get record length of Data Layout files for SE Security
      ** Diary Events API.
      *
     C                   MOVEL     'SESEDEPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SEDELn            4 0
      *
      ** Get record length of Extra Data Layout file for SE
      ** Security Diary Events - API
      *
     C                   MOVEL     'SESDEXPD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SDEXLn            4 0

      ** SD Market Data Feeds Spot Rate Details

     C                   MOVEL     'SDSPTRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SPTRLn            4 0


      ** SD Base Rate Details

     C                   MOVEL     'SDBSRSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDBSLn            4 0

      ** Get record length of Data Layout files for AB Internal
      ** Funding Deals API

     C                   MOVEL     'ABFUNDPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FUNDLn            4 0
      *
      ** Get record length of Extra Data Layout file for AB
      ** Internal Funding Deals - API
      *
     C                   MOVEL     'ABFUEXPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     FUEXLn            4 0

      ** FX Extra Data file (50 byte narrative text plus any custom info)

     C                   MOVEL     'FXFXEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FXFXLn            4 0

      ** MM Loan/deposits Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'MMLDEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MMLDLn            4 0

      ** MM Deal amendments Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'MMDAEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MMDALn            4 0

      ** MM NAs Purchased Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'MMNPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MMNPLn            4 0

      ** MM NAs Sold Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'MMNSEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MMNSLn            4 0

      ** IR FRAs Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'IRFREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRFRLn            4 0

      ** IR IRS Cross Ccy Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'IRCSEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRCSLn            4 0

      ** IR IRS Single Ccy Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'IRSSEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRSSLn            4 0

      ** SE Trades Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'SETDEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SETRLn            4 0

      ** SE Walk In Depot Movts Extra Data file (50 byte narrative text
      ** plus any custom info)

     C                   MOVEL     'SEDMEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SEWILn            4 0

      ** SE Walk Out Depot Movts Extra Data file (50 byte narrative text
      ** plus any custom info)

     C                   MOVEL     'SEDMEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SEWOLn            4 0

      ** AB Internal Contracts Extra Data file (50 byte narrative text
      ** plus any custom info)

     C                   MOVEL     'ABICEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ABICLn            4 0

      ** FF Exchange Traded Options Extra Data file (50 byte narrative text
      ** plus any custom info)

     C                   MOVEL     'FFETEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FFETLn            4 0

      ** FF Over the Counter Options Extra Data file (50 byte narrative text
      ** plus any custom info)

     C                   MOVEL     'FFOTEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FFOTLn            4 0
                                                                                              CAP183
      ** FF Market Prices Extra Data file (50 byte narrative text                             CAP183
      ** plus any custom info)                                                                CAP183
                                                                                              CAP183
     C                   MOVEL     'FFMPEXPD'    FileName                                     CAP183
     C                   EXSR      GETRCDLN                                                   CAP183
     C                   Z-ADD     RecordLen     FFMPLn            4 0                        CAP183

      ** FD Forward Rates Extra Data file (50 byte narrative text
      ** plus any custom info)

     C                   MOVEL     'FDFREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FDFRLn            4 0

      ** FD MM Interest Rates Extra Data file (50 byte narrative text
      ** plus any custom info)

     C                   MOVEL     'FDIREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FDIRLn            4 0

      ** SE Price Input

     C                   MOVEL     'SEPRCSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     PRCSLn            4 0

      ** SE Price Input  Extra Data file (50 byte narrative text
      ** plus any custom info)

      ** MM Loan/deposits Interface Data  Format Definition Layout
      ** (50 byte narrative text plus any custom info)

     C                   MOVEL     'MMLDIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MMLILn            4 0

      ** FX Foreign Exchange Interface Data  Format Definition Layout
      ** (50 byte narrative text plus any custom info)

     C                   MOVEL     'FXFXIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FXFILn            4 0

      ** MM Money Market Dealing Interface Data  Format Definition Layout
      ** (50 byte narrative text plus any custom info)

     C                   MOVEL     'MMDAIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MMDILn            4 0

      ** SE Trades Interface Data  Format Definition Layout
      ** (50 byte narrative text plus any custom info)

     C                   MOVEL     'SETRIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SETILn            4 0

      ** IR Single Currency Interface Data Format Definition Layout

     C                   MOVEL     'IRRSIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRRSLn

      ** IR Cross Currency Interface Data Format Definition Layout

     C                   MOVEL     'IRRXIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRRXLn

      ** IR Forward Rate Agreement Interface Data Format Definition Layout

     C                   MOVEL     'IRFRIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRFALn

      ** IR Caps/Collars/Floors Interface Data Format Definition Layout

     C                   MOVEL     'IRRPIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRRPLn
      *
      ** Get record length of Data Layout file for Portfolio Definition
      ** Details API.
     C                   MOVEL     'PMPFDMPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     PFDMLn            4 0
      *
      ** Get record length of Extra Data Layout file for Portfolio
      ** Definition Details API.
     C                   MOVEL     'PMPFEXPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     PFEXLn            4 0
      *
      ** Get record length of Data Layout file for Journal
      ** Entry Header API.
     C                   MOVEL     'GLBITHPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     BITHLn            4 0
      *
      ** Get record length of Data Layout file for Journal
      ** Entry Item API.
     C                   MOVEL     'GLBITPPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     BITPLn            4 0
                                                                                              246418
     C                   MOVEL     *BLANKS       FileName                                     246418
     C                   MOVEL     'GLBITPXPD'   FileName                                     246418
     C                   EXSR      GETRCDLN                                                   246418
     C                   Z-ADD     RecordLen     BIPXLn            4 0                        246418
      *
      ** Get record length of Extra Data Layout file for Journal
      ** Entry Header API.
     C                   MOVEL     *BLANKS       FileName                                     246418
     C                   MOVEL     'GLBHEXPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     BHEXLn            4 0
      *
      ** Get record length of Extra Data Layout file for Journal
      ** Entry Item API.
     C                   MOVEL     'GLBPEXPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     BPEXLn            4 0
      *

      ** FT Outgoing Payment Extra Data file (50 byte narrative text
      ** plus any custom info)

     C                   MOVEL     'FTOPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPEXLn            4 0

      ** SD Customers Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'SDCUEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDCULn            4 0

      ** GL Accounts Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'GLAMEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     GLAMLn            4 0


     C                   MOVEL     'SEPREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     PRCXLn            4 0
      *
      ** Get record length of Data Layout files for FT Incoming
      ** Payments API - first, second, third, fourth, fifth, sixth,
      ** seventh and eighth details.
      *
     C                   MOVEL     'FTIPY1PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     IPY1Ln            4 0
      *
     C                   MOVEL     'FTIPY1APD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     IPY2Ln            4 0
      *
     C                   MOVEL     'FTIPY2PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     IPY3Ln            4 0
      *
     C                   MOVEL     'FTIPY3PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     IPY4Ln            4 0
      *
     C                   MOVEL     'FTIPY4PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY5Ln            4 0
      *
     C                   MOVEL     'FTIPY4APD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY6Ln            4 0
      *
     C                   MOVEL     'FTIPY5PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY7Ln            4 0
      *
     C                   MOVEL     'FTIPY6PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY8Ln            4 0
      *                                                                                       CSW209
     C                   MOVEL     'FTIPY7PD'    FileName                                     CSW209
     C                   EXSR      GETRCDLN                                                   CSW209
     C                   Z-ADD     RecordLen     IPY9ALn                                      CSW209
      *                                                                                       CSW209
     C                   MOVEL     'FTIPY8PD'    FileName                                     CSW209
     C                   EXSR      GETRCDLN                                                   CSW209
     C                   Z-ADD     RecordLen     IPY9BLn                                      CSW209
      *                                                                                       262664
     C                   MOVEL     'FTIPY6APD'   FileName                                     262664
     C                   EXSR      GETRCDLN                                                   262664
     C                   Z-ADD     RecordLen     IPY9Ln            4 0                        262664
      *                                                                                       CER030
     C**********         MOVEL     'FTIPY6APD'   FileName                             CER030 CER034A
     C**********         EXSR      GETRCDLN                                           CER030 CER034A
     C**********         Z-ADD     RecordLen     IPY9Ln            4 0                CER030 CER034A
      *
      ** Get record length of Extra Data Layout file for FT Incoming
      ** Payments API.
      *
     C                   MOVEL     'FTIPEXPD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     IPEXLn            4 0
      *
      ** Get record length of Data Layout files for SE Securities
      ** API - first, second, and third  details.
      *
     C                   MOVEL     'SESEC1PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC1Ln            4 0
      *
     C                   MOVEL     'SESEC2PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC2Ln            4 0
      *
     C                   MOVEL     'SESEC3PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC3Ln            4 0
      *
     C                   MOVEL     'SESEC4PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC4Ln            4 0
      *
      ** Get record length of Extra Data Layout file for SE
      ** Securities - API.
      *
     C                   MOVEL     'SESEEXPD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEEXLn            4 0

      ** SD Security Customers Details Extra Data file
      ** (50 byte narrative text plus any custom info)

     C                   MOVEL     'SDSEEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDSELn            4 0

      ** SD Market Data Feed Spot Rate Details
      ** (50 byte narrative text plus any custom info)

     C                   MOVEL     'SDSPTXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDSPLn            4 0

      ** SD Base Rates Extra Data file

     C                   MOVEL     'SDBSEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDBXLn            4 0

      ** Get record length of Data Layout files for MM REPOs
      ** Depot Movements - API

     C                   MOVEL     'MMRPDDPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     REP1Ln

      ** Get record length of Data Layout files for MM REPOs
      ** Trailer - API

     C                   MOVEL     'MMRPTRPD'    Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     REP2Ln

     C                   MOVEL     'SDYRAT1PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     YRAT1Ln
     C                   MOVEL     'SDYRAT2PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     YRAT2Ln
     C                   MOVEL     'SDYRAT3PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     YRAT3Ln
     C                   MOVEL     'SDYRAT4PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     YRAT4Ln

      ** SD Yield Rates Extra Data File

     C                   MOVEL     'SDYREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDYRLn

      ** Cash Flow Schedules

     C                   CLEAR                   FileName
     C                   MOVEL     'IRCFSC1PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WCFSC1OLn
     C                   Z-ADD     RecordLen     WCFSC1TLn
     C                   MOVEL     'IRCFSC2PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WCFSC2OLn
     C                   Z-ADD     RecordLen     WCFSC2TLn
     C                   MOVEL     'IRCFSC3PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WCFSC3OLn
     C                   Z-ADD     RecordLen     WCFSC3TLn
     C                   MOVEL     'IRCFSC4PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WCFSC4OLn
     C                   Z-ADD     RecordLen     WCFSC4TLn

      ** Principal Change Schedules

     C                   MOVEL     'IRPCSC1PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WPCSC1OLn
     C                   Z-ADD     RecordLen     WPCSC1TLn
     C                   MOVEL     'IRPCSC2PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WPCSC2OLn
     C                   Z-ADD     RecordLen     WPCSC2TLn
     C                   MOVEL     'IRPCSC3PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WPCSC3OLn
     C                   Z-ADD     RecordLen     WPCSC3TLn
     C                   MOVEL     'IRPCSC4PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WPCSC4OLn
     C                   Z-ADD     RecordLen     WPCSC4TLn

      ** Trailer Record

     C                   CLEAR                   FileName
     C                   MOVEL     'IRTRSCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     WTRSCLn
     C                   CLEAR                   FileName

      ** LE Assignments

     C                   MOVEL     'LEASGNPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ASGNLn            4 0

      ** LE Risk Participants

     C                   MOVEL     'LERPRTPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     RPRTLn            4 0

      ** LE Settlement Details

     C                   MOVEL     'SETLIAB'     FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           LIAB1Ln           4 0
     C     Recordlen     SUB       LIAB1Ln       LIAB2Ln           4 0

      ** LE Settle/Detail format (inc Cont/Parms)

     C                   MOVEL     'SETLIAZ'     FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LIAZLn            4 0

      ** LE Facility Input format

     C                   MOVEL     'LEF1MFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           FCTY1Ln           4 0
     C                   Z-ADD     500           FCTY2Ln           4 0
     C     Recordlen     SUB       1000          FCTY3Ln           4 0

      ** LE Loan Input format
      ** LE Participations Purchased Input format
      ** LE Participations Sold Input

     C                   MOVEL     'LEN1MFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           LOAN1Ln           4 0
     C                   Z-ADD     500           PTPU1Ln           4 0
     C                   Z-ADD     500           PTSO1Ln           4 0
     C                   Z-ADD     500           LOAN2Ln           4 0
     C                   Z-ADD     500           PTPU2Ln           4 0
     C                   Z-ADD     500           PTSO2Ln           4 0
     C     Recordlen     SUB       1000          LOAN3Ln           4 0
     C     Recordlen     SUB       1000          PTPU3Ln           4 0
     C     Recordlen     SUB       1000          PTSO3Ln           4 0

      ** LE Loan Amendment Input
      * Principal Transfer To
      * Principal Transfer From
      * Principal Increase
      * Base Rate Change
      * Spread Change
      * Stop/Start Change Accrual
      * Loan Subtype Change
     C                   MOVEL     'LEA1MFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           LAPT1Ln           4 0
     C                   Z-ADD     500           LAPF1Ln           4 0
     C                   Z-ADD     500           LAPI1Ln           4 0
     C                   Z-ADD     500           LABC1Ln           4 0
     C                   Z-ADD     500           LASC1Ln           4 0
     C                   Z-ADD     500           LASA1Ln           4 0
     C                   Z-ADD     500           LALS1Ln           4 0
     C     Recordlen     SUB       LAPT1Ln       LAPT2Ln           4 0
     C     Recordlen     SUB       LAPF1Ln       LAPF2Ln           4 0
     C*****Recordlen     SUB       LAPI1Ln       LAPI2Ln           4 0                      AR400813
     C                   Z-ADD     500           LAPI2Ln           4 0                      AR400813
     C     Recordlen     SUB       1000          LAPI3Ln           4 0                      AR400813
     C     Recordlen     SUB       LABC1Ln       LABC2Ln           4 0
     C     Recordlen     SUB       LASC1Ln       LASC2Ln           4 0
     C     Recordlen     SUB       LASA1Ln       LASA2Ln           4 0
     C     Recordlen     SUB       LALS1Ln       LALS2Ln           4 0

      ** LE Rollover Input format

     C                   MOVEL     'LEO1MFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           ROLL1Ln           4 0
     C     Recordlen     SUB       ROLL1Ln       ROLL2Ln           4 0

      ** LE Manual Repayment format

     C                   MOVEL     'LEM1MFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           LAMR1Ln           4 0
     C     Recordlen     SUB       LAMR1Ln       LAMR2Ln           4 0

      ** LE Fees Input Maintenance format

     C                   MOVEL     'LEF3MFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           FEES1Ln           4 0
     C*****Recordlen     SUB       FEES1Ln       FEES2Ln           4 0                       256407B
     C                   Z-ADD     500           FEES2Ln           4 0                       256407B
     C     Recordlen     SUB       1000          FEES3Ln           4 0                       256407B

      ** LE Facility                                                                          BG5888
                                                                                              BG5888
     C                   MOVEL     'LEFCPPPD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     FCI1Ln            4 0                        BG5888
                                                                                              BG5888
     C                   MOVEL     'LEFCSPPD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     FCI2Ln            4 0                        BG5888
                                                                                              BG5888
      ** LE Loans                                                                             BG5888
                                                                                              BG5888
     C                   MOVEL     'LECLI1PD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     CLI1Ln            4 0                        BG5888
                                                                                              BG5888
     C                   MOVEL     'LECLI2PD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     CLI2Ln            4 0                        BG5888
                                                                                              BG5888
     C                   MOVEL     'LECLI3PD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     CLI3Ln            4 0                        BG5888
                                                                                              BG5888
     C                   MOVEL     'LECLI4PD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     CLI4Ln            4 0                        BG5888
                                                                                              BG5888
      ** LE Rollover Instructions                                                             BG5888
                                                                                              BG5888
     C                   MOVEL     'LELERIPD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     LERILn            4 0                        BG5888
                                                                                              BG5888
      ** LE Loan amendments                                                                   BG5888
                                                                                              BG5888
     C                   MOVEL     'LELOAMPD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     LOAMLn            4 0                        BG5888
                                                                                              BG5888
      ** LE Repayments schedule                                                               BG5888
      *                                                                                       BG5888
     C                   MOVEL     'LERPSCPD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     RPSCLn            4 0                        BG5888
      *                                                                                       BG5888
      ** LE Manual payments                                                                   BG5888
      *                                                                                       BG5888
     C                   MOVEL     'LEMAPYPD'    FileName                                     BG5888
     C                   EXSR      GETRCDLN                                                   BG5888
     C                   Z-ADD     RecordLen     MAPYLn            4 0                        BG5888
      *                                                                                       BG5888
      ** Caps/Collars/Floors Format Definition File

     C                   EVAL      Filename = 'IRCACFPD'
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CACFLn

      ** Caps/Collars/Floors Extra Data File

     C                   EVAL      Filename = 'IRCPEXPD'
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CACXLn
      ** LE Fee input                                                                         CAP078
      *                                                                                       CAP078
     C                   MOVEL     'LEFEEMPD'    FileName                                     CAP078
     C                   EXSR      GETRCDLN                                                   CAP078
     C                   Z-ADD     RecordLen     FEEMLn            4 0                        CAP078
      *                                                                                       CAP078

      ** SE Movements Status: Primary and Extra Details
      *
     C                   MOVEL (P) 'SEMVTS1PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MVTSLn            4 0
      *
     C                   MOVEL (P) 'SEMVEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MVEXLn            4 0

      ** Get record length of Data Layout files for SE Trade
      ** Settlements API.
     C                   MOVEL     'SETRSMPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRSMLn            4 0

      ** SE Statement Production Requests: Primary and Extra Details
      *
     C                   MOVEL (P) 'SESTPR1PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     STPRLn            4 0
      *
     C                   MOVEL (P) 'SESPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SPEXLn            4 0
                                                                                              CDL033
     C                   MOVEL     'DLFRSCPF'    Filename                                     CDL033
     C                   EXSR      GETRCDLN                                                   CDL033
     C                   Z-ADD     RecordLen     PFRSCLn           4 0                        CDL033
                                                                                              CDL033
     C                   MOVEL     'DLFRSCPF'    Filename                                     CDL033
     C                   EXSR      GETRCDLN                                                   CDL033
     C                   Z-ADD     RecordLen     RFRSCLn           4 0                        CDL033
                                                                                              CDL033
     C                   MOVEL     'DLFRHOPD'    Filename                                     CDL033
     C                   EXSR      GETRCDLN                                                   CDL033
     C                   Z-ADD     RecordLen     FRHOLn            4 0                        CDL033

      ** Check if CAS009 is installed                                                         CAS009
                                                                                              CAS009
     C                   CALLB     'AOSARDR0'                                                 CAS009
     C                   PARM      *BLANKS       PRtCd                                        CAS009
     C                   PARM      '*VERIFY'     POptn                                        CAS009
     C                   PARM      'CAS009'      PSarD                                        CAS009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS009
                                                                                              CAS009
     C     PRtCd         IFEQ      *BLANK                                                     CAS009
     C                   MOVEL     'Y'           CAS009                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVEL     'N'           CAS009                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** DL Dealing Fees                                                                      CAS009
                                                                                              CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
     C                   EVAL      Filename = 'DLDLFEPD'                                      CAS009
     C                   EXSR      GETRCDLN                                                   CAS009
     C                   Z-ADD     RecordLen     DLFELn                                       CAS009
                                                                                              CAS009
     C                   EVAL      Filename = 'DLDFEXPD'                                      CAS009
     C                   EXSR      GETRCDLN                                                   CAS009
     C                   Z-ADD     RecordLen     DFEXLn                                       CAS009
     C                   ENDIF                                                                CAS009
     C/COPY WNCPYSRC,APH00057
                                                                                              CAS009
      ** Get record length of Data Layout files for SD Additional                             CGL032
      ** Customer Details. Default Extra Data length to 500.                                  CGL032
                                                                                              CGL032
     C                   MOVEL     'SDACUDPD'    FileName                                     CGL032
     C                   EXSR      GETRCDLN                                                   CGL032
     C                   Z-ADD     RecordLen     ACUDLn                                       CGL032
     C**********         Z-ADD     500           ACEXLn                               CGL032 CER034A
      *                                                                                       CER034
     C**********         MOVEL     'SDACUD3PD'   FileName                             CER034 CER034A
     C                   MOVEL     'SDACU3DPD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                   CER034
     C                   Z-ADD     RecordLen     WACUD1                                       CER034
      *                                                                                       CER034
     C**********         MOVEL     'SDACUD4PD'   FileName                             CER034 CER034A
     C                   MOVEL     'SDACU4DPD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                   CER034
     C                   Z-ADD     RecordLen     WACUD2                                       CER034
      *                                                                                       CER034
     C                   Z-ADD     500           ACEXLn                                      CER034A
      *                                                                                      CER034A
      ** Get record length of Data Layout files for SD Customer/                             CER034A
      ** Authority Details. Default Extra Data length to 500.                                CER034A
      *                                                                                      CER034A
     C                   MOVEL     'SDCUAH1PD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                  CER034A
     C                   Z-ADD     RecordLen     CUAH1Ln                                     CER034A
      *                                                                                      CER034A
     C                   MOVEL     'SDCUAH2PD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                  CER034A
     C                   Z-ADD     RecordLen     CUAH2Ln                                     CER034A
      *                                                                                      CER034A
     C                   MOVEL     'SDCUAH3PD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                  CER034A
     C                   Z-ADD     RecordLen     CUAH3Ln                                     CER034A
      *                                                                                      CER034A
     C                   MOVEL     'SDCUAH4PD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                  CER034A
     C                   Z-ADD     RecordLen     CUAH4Ln                                     CER034A
      *                                                                                      CER034A
     C                   MOVEL     'SDCUAH5PD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                  CER034A
     C                   Z-ADD     RecordLen     CUAH5Ln                                     CER034A
      *                                                                                      CER034A
     C                   MOVEL     'SDCUAH6PD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                  CER034A
     C                   Z-ADD     RecordLen     CUAH6Ln                                     CER034A
      *                                                                                      CER034A
     C                   MOVEL     'SDCUAH7PD'   FileName                                    CER034A
     C                   EXSR      GETRCDLN                                                  CER034A
     C                   Z-ADD     RecordLen     CUAH7Ln                                     CER034A
      *                                                                                      CER034A
     C                   Z-ADD     500           CUEXLn                                      CER034A
                                                                                              CGL032
      ** Get record length of Data Layout files for SD Non-A/C                                CGL032
      ** Holders API. Default Extra Data length to 500.                                       CGL032
                                                                                              CGL032
     C                   MOVEL     'SDNAHLPD'    FileName                                     CGL032
     C                   EXSR      GETRCDLN                                                   CGL032
     C                   Z-ADD     RecordLen     SDNALn                                       CGL032
     C                   Z-ADD     500           NaEXLn                                       CGL032
                                                                                              CGL032
      ** Get record length of Data Layout files for SD Customer                               CGL032
      ** Details by Country of Tax API.                                                       CGL032
                                                                                              CGL032
     C                   MOVEL     'SDCCTXPD'    FileName                                     CGL032
     C                   EXSR      GETRCDLN                                                   CGL032
     C                   Z-ADD     RecordLen     CCTXLn                                       CGL032
                                                                                              CGL032
      ** Get record length of Data Layout files for SD Customer                               CGL032
      ** Details by Country of Tax API.                                                       CGL032
                                                                                              CGL032
     C                   MOVEL     'SDNATXPD'    FileName                                     CGL032
     C                   EXSR      GETRCDLN                                                   CGL032
     C                   Z-ADD     RecordLen     NATXLn                                       CGL032
                                                                                              CGL032
      ** Get record length of Data Layout files for SD Joint A/c                              CGL032
      ** Member Details API.                                                                  CGL032
                                                                                              CGL032
     C                   MOVEL     'SDJACMPD'    FileName                                     CGL032
     C                   EXSR      GETRCDLN                                                   CGL032
     C                   Z-ADD     RecordLen     JACMLn                                       243084
      *                                                                                       CER001
      ** Regional Extra Data                                                                  CER001
      *                                                                                       CER001
                                                                                              CER001
     C                   MOVEL (P) 'MMLDRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     MMLRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'MMNPRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     MMNRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'GLAMRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     GLARLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'LEFCRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     LEFRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'LECLRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     LECRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'SESERXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     SESRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'FFOTRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     FFORLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'FFETRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     FFERLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'GLBPRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     GLBRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'SDCURXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     SDCRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'SETDRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     SERRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'FTOPRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     FTORLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'FTIPRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     FTIRLn            4 0                        CER001
                                                                                              CER001
     C                   MOVEL (P) 'SEDMRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     SEDRLn            4 0                        CER001
      *                                                                                       256330
      ** LE Funding Participants                                                              256330
      *                                                                                       256330
     C                   MOVEL     'LEFPRTPD'    FileName                                     256330
     C                   EXSR      GETRCDLN                                                   256330
     C                   Z-ADD     RecordLen     FPRTLn            4 0                        256330
      *                                                                                       256330
      ** LE Facility Amendments                                                               256330
      *                                                                                       256330
     C                   MOVEL     'LEFAMDPD'    FileName                                     256330
     C                   EXSR      GETRCDLN                                                   256330
     C                   Z-ADD     RecordLen     FAMDLn            4 0                        256330
      *                                                                                       256330
      ** LE Fee Adjustment input                                                              256330
      *                                                                                       256330
     C                   MOVEL     'LEFEADPD'    FileName                                     256330
     C                   EXSR      GETRCDLN                                                   256330
     C                   Z-ADD     RecordLen     FEADLn            4 0                        256330
      *                                                                                       256330
      ** LE Fee Settlement input                                                              256330
      *                                                                                       256330
     C                   MOVEL     'LEFESTPD'    FileName                                     256330
     C                   EXSR      GETRCDLN                                                   256330
     C                   Z-ADD     RecordLen     FESTLn            4 0                        256330
                                                                                              CGL132
     C                   MOVEL (P) 'SDFTCRPD'    FileName                                     CGL132
     C                   EXSR      GETRCDLN                                                   CGL132
     C                   Z-ADD     RecordLen     FTCSLn            4 0                        CGL132
                                                                                              CGL132
     C                   MOVEL (P) 'SDFTNRPD'    FileName                                     CGL132
     C                   EXSR      GETRCDLN                                                   CGL132
     C                   Z-ADD     RecordLen     FTNHLn            4 0                        CGL132
                                                                                              CER001
      ** Get record length of Data Layout files for SD Document                               CSD093
      ** Member Details API.                                                                  CSD093
                                                                                              CSD093
     C                   MOVEL     'SDDCMSPD'    FileName                                     CSD093
     C                   EXSR      GETRCDLN                                                   CSD093
     C                   Z-ADD     RecordLen     DCMTLn                                       CSD093
      ** Extra Data                                                                           CSD093
     C                   MOVEL     'SDDCMXPD'    FileName                                     CSD093
     C                   EXSR      GETRCDLN                                                   CSD093
     C                   Z-ADD     RecordLen     DCMXLn                                       CSD093
                                                                                              CSD093
      ** Account Review Format Definition File                                                CSD092
                                                                                              CSD092
     C                   EVAL      Filename = 'SDACRFPD'                                      CSD092
     C                   EXSR      GETRCDLN                                                   CSD092
     C                   Z-ADD     RecordLen     ACRVLn1                                      CSD092
     C                   EVAL      ACRVLn1 = ACRVLn1 + Bfp - 500                              CSD092
                                                                                              CSD092
      ** Account Review Extra Data File                                                       CSD092
                                                                                              CSD092
     C                   EVAL      Filename = 'SDACEXPD'                                      CSD092
     C                   EXSR      GETRCDLN                                                   CSD092
     C                   Z-ADD     RecordLen     ACRXLn                                       CSD092
                                                                                              CSD092
     C/COPY WNCPYSRC,APPARSMMC2

     C                   ENDSR
      /EJECT
      ****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------------
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2003
