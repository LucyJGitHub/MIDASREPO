     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits retrieve a record')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market                                         *
      *                                                               *
      *  MMLDNIR   - MM Loans and deposits retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054028           Date 05Sep19               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR701789           Date 26Sep16               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 30May14               *
      *                 AR1060863          Date 06Apr13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 AR819540A          Date 30Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248297             Date 05Jun07               *
      *                 244784             Date 11JAN07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239400             Date 26Jun06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10943           Date 27Mar06               *
      *                 BUG10688           Date 27Feb06               *
      *                 BUG10563           Date 14Feb06               *
      *                 BUG9827            Date 25Jan06               *
      *                 BUG10296           Date 07Feb06               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG6512            Date 13May05               *
      *                 BUG3792            Date 28Sep04               *
      *                 BUG3684            Date 18Aug04               *
      *                 BUG3986            Date 13Aug04               *
      *                 CMM105             Date 22Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 TCA002             Date 26Mar04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 17Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD046248 - Finastra Rebranding                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  CGL165 - Dual Withholding Tax                                *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  AR1060863 - Deal irregular interest schedules lost           *
      *            - Applied for AR1097090                            *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  AR819540A - Mapping error encountered in LDNI                *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248297   - EXTDTA is no more part of Output buffers          *
      *             - Add DS in Buffer2                               *
      *  244784   - Lux fields are lost. Remove BUG10943 because      *
      *             inconsistent with processing in APTRANVU          *
      *  239400 - Add Front Office ID to be used by SOAP Interface    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10943 - Interest Rate Change Schedule not displayed       *
      *  BUG10688 - LUX Extension Fields error messages occurred after*
      *             cancelling Reversal                               *
      *  BUG10563- Resolve conflict between BUG10296 and 9827.        *
      *  BUG9827 - Fiduciary deal changes for Midas Plus              *
      *  BUG10296 - LUX extension fields are missing                  *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033  - Floating Rate CDs Issued.                          *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG3792- Only allow Block/Unblock on Deposits.               *
      *  BUG3684 - Set up action field for Block/Unblock              *
      *  BUG3986- Pass the status and TimeStamp out to the MidasPlus *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added: MMLDNIZD01,MMLDNIZC02,MMLDNIZC03  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *           (Recompile)                                         *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic Rollover of Fixed Term Loan/Deposit       *
      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *                                                                                      CDL033
      ** Midas DL FRCD Date Schedule Retrieval                                               CDL033
      *                                                                                      CDL033
     FDLFRSCL1  IF   E           K DISK    INFSR(*PSSR)                                      CDL033
      *                                                                                      BUG9827
      ** Midas MM Loan/Deposits by Link No.- Fiduciary only                                  BUG9827
     FMMDELDLF  IF   E           K DISK    INFSR(*PSSR)                                      BUG9827
     F                                     PREFIX(L_)                                        BUG9827

      **********************************************************************
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

      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *                                                                                       CDL033
      ** Fields for enhancement CDL033                                                        CDL033
      *                                                                                       CDL033
     D*******ExtData        E DS          3999    EXTNAME(MMLDEXPD)       CDL033             BUG9827
     DExtData        E DS                  EXTNAME(MMLDEXPD)                                 BUG9827
     DBuffer2          DS          3999                                                       CDL033
     DBufferEx2        DS          9999                                                       CDL033
     DRatDateDS        DS          4800                                                       CDL033
     DPayDateDS        DS          4800                                                       CDL033

     DBufferEx3        DS          9999                                                       CSF011
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
     D                                     PREFIX(NO_)                                        CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                  CSF011
     D @TYPE           S              7                                                      CSF011A
     D @ACID           S             10                                                      CSF011A
     D @CYCD           S              3                                                      CSF011A
     D @ACCD           S             10                                                      CSF011A
     D @ACSN           S              2                                                      CSF011A
     D @BRCA           S              3                                                      CSF011A
     D @NOSN           S              2                                                      CSF011A
     D @CUST           S              6                                                      CSF011A
     D @PNOI           S              1                                                      CSF011A
     D @CSSN           S             10                                                      CSF011A
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** Screen formats
      **--------------------------------------------------------------------------------------------
      *                                                                                       CER001
      ** Regional data in file format                                                         CER001
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(MMLDRXPD)                                  CER001

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL018
      ** External DS for SAR Details                                                          CDL018
                                                                                              CDL018
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL018
      * First DS for Access Programs, Short Data Structure                                    CDL018
                                                                                              CDL018
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER043
      ** Second DS for Access Programs, long Data Structure                                   CER043
      *                                                                                       CER043
     D DealScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * Deal in Screen Format

     D InfData       E DS                  EXTNAME(MMLDIFPD)
      ** Interface Data Format

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format

     D #FRECS        E DS                  EXTNAME(SDFSSRPD)                                  CDL018
      * Receive Further Settlement instructions in screen format                              CDL018
                                                                                              CDL018
     D #FPAYS        E DS                  EXTNAME(SDFSSPPD)                                  CDL018
      ** Payment Further Settlement instructions in screen format                             CDL018
                                                                                              CDL018
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CDL033
      ** External DS for Bank Details                                                         CDL033
                                                                                              CDL033
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
      ** External DS for Customer Details                                                     CER043
      *                                                                                       CER043
      **--------------------------------------------------------------------------------------------
      ** File formats
      **--------------------------------------------------------------------------------------------

     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
      ** Loans and Deposits in File Format
     D  DELDRecIns           470    524                                                       TCA002
     D  DELDPayIns           539   1083                                                       TCA002
     D**DELDRecIns***********456    524                                                       TCA002
     D**DELDPayIns***********525   1083                                                       TCA002
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      *                                                                                       CER001
      ** File Format for LDNI Extension File (LUX)                                            CER001
      *                                                                                       CER001
     D LDNILUXFilFmt E DS                  EXTNAME(MMDLX1PD)                                  CER001

     D TranQExt      E DS                  EXTNAME(DLSTMPPD)                                  CER049
      ** Stamp Tax Extension Screen Format based on DLSTMPPD                                  CER049
                                                                                              CER049
     D***TranInCust    E DS                  EXTNAME(SDCUCUPD)                         CER043 CSF011
      ***Customers*Extension*Screen*Format*based*on*SDCUCUPD                           CER043 CSF011
      *                                                                                       CER043
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D**FLREC******************1     69                                                       TCA002
     D  FLREC2                21     75                                                       TCA002
      * Receive settlement instructions in file format

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D**FLPAY******************1    559                                                       TCA002
     D  FLPAY2                21    565                                                       TCA002
      * Pay settlement instructions in file format

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS settlement instructions in file format

     DPayDATEADS       DS                                                                     CDL033
     D PayDATEA                       8A   DIM(600)                                           CDL033
     D PayDate                        6    OVERLAY(PayDATEA:1)                                CDL033
     D PayCOHO                        1    OVERLAY(PayDATEA:7)                                CDL033
     D PayDTPR                        1    OVERLAY(PayDATEA:8)                                CDL033
                                                                                              CDL033
     DRatDATEADS       DS                                                                     CDL033
     D RatDATEA                       8A   DIM(600)                                           CDL033
     D RatDate                        6    OVERLAY(RatDATEA:1)                                CDL033
     D RatCOHO                        1    OVERLAY(RatDATEA:7)                                CDL033
     D RatDTPR                        1    OVERLAY(RatDATEA:8)                                CDL033
                                                                                             BUG9827
     D WFIDTDTL        DS            48                                                      BUG9827
     D  SFDLNO                 1      6                                                      BUG9827
     D  SFCNUM                 7     16                                                      BUG9827
     D  SFPTFR                17     20                                                      BUG9827
     D  SFAMNT                21     35                                                      BUG9827
     D  SFACOD                36     45                                                      BUG9827
     D  SFACSQ                46     47                                                      BUG9827
     D  SFTRAS                48     48                                                      BUG9827
                                                                                             BUG9827
     D                 DS                                                                    CSF011A
     D  A#OURA                 1     21                                                      CSF011A
     D  A#NOST                 1      2                                                      CSF011A
     D  A#CNUM                 1      6                                                      CSF011A
     D  A#RENO                 1     10                                                      CSF011A
     D  A#ACOD                 7     16                                                      CSF011A
     D  A#ACAS                 7     18                                                      CSF011A
     D  A#ACSQ                17     18                                                      CSF011A
     D  A#REST                 3     18                                                      CSF011A
     D  A#RES2                11     18                                                      CSF011A
     D  A#BRCA                19     21                                                      CSF011A
                                                                                             CSF011A
      **--------------------------------------------------------------------------------------------

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

     D SREMK           S             35                                                       CMM105
     D DDACTC          S              1                                                      BUG3684
     D PLATAK          S              1                                                      BUG3792
     D CDL006          S              1A                                                     BUG3792
     D ULX600          S              1A                                                      CER001
     D CER043          S              1A                                                      CER043
     D CDL033          S              1A                                                      CDL033
     D PDayNo          S              5  0                                                    CDL033
     D PDatFmt         S              1A                                                      CDL033
     D PDate           S              6  0                                                    CDL033
     D PDate2          S              7A                                                      CDL033
     D PFormula        S              8A                                                      CDL033
     D RFormula        S              8A                                                      CDL033
     D N               S              5  0                                                    CDL033
     D P               S              5  0                                                    CDL033
     D R               S              5  0                                                    CDL033
     D DDLNO           S              6  0                                                    CDL033
     D DDFOID          S             20                                                       239400
      ***This*field*should*be*reduced*everytime*a*core*field*is*added              BUG10296 BUG10563
     D*LDNIFil*        S           3953A                                           BUG10296 BUG10563
     D WDUMMY          S             90A                                                    BUG10563
     D FIDTScnRpt      S           4752A                                                     BUG9827
     D FIDTScnRstN     S            240A                                                     BUG9827
     D*Filler2**       S           2523A                                              BUG9827 CER043
     D*Filler2**       S           2072A                                               CER043 CDL096
     D*Filler2         S           2038A                                               CDL096 CGL165
     D Filler2         S           2034A                                                      CGL165
     D Filler3         S           2282A                                                   AR1060863
     D FIDTLen         S              2  0 INZ(48)                                           BUG9827
     D Str             S              4  0                                                   BUG9827
      ** Parameters for ZEDIT                                                                BUG9827
     D ZField          S             16                                                      BUG9827
     D Zdec            S              2P 0                                                   BUG9827
      *                                                                                       CER043
      ** Parameters for Calling AOCUSTR0                                                      CER043
     D PCNum           S             10A                                                      CER043
     D PKey7           S              7A                                                      CER043
                                                                                              CER043
     C/COPY WNCPYSRC,MMLDNIZD01
      **--------------------------------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+

      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   DealFilFmt
     C                   CLEAR                   LDNILUXFilFmt                                CER001
     C                   CLEAR                   RatDATEA                                     CDL033
     C                   CLEAR                   PayDATEA                                     CDL033
     C                   CLEAR                   DealScnfmt                                  CSF011A
                                                                                           AR819540A
      ** Stamp Tax details                                                                 AR819540A
                                                                                           AR819540A
     C**********         EVAL      TranQExt = %SUBST(Buffer:4912:95)                AR819540A CSF011
     C                   EVAL      TranQExt = %SUBST(Buffer2:1468:95)                         CSF011
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF

     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF

     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      MMLDNIRED
     C                   ELSE
     C                   MOVEL     DDDLNO_In     @DLRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C     @DLRED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      MMLDNIRTV
     C                   IF        ULX600 = 'Y'                                               CER001
     C                   EXSR      MMLDNI2RV                                                  CER001
     C                   ENDIF                                                                CER001
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      MMLDNICVT
     C                   IF        ULX600 = 'Y'                                               CER001
     C                   EXSR      MMLDNI2CT                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                      BUG9827
      ** Retrieve screen format details for linked takings                                   BUG9827
     C                   If        CDL006 = 'Y'                                              BUG9827
     C                   If        DDTYPE = 'FL' or                                          BUG9827
     C                             DDTYPE = 'DP' or                                          BUG9827
     C                             DDTYPE = 'LP'                                             BUG9827
     C                   EXSR      MMFIDTDET                                                 BUG9827
     C                   EndIf                                                               BUG9827
     C                   EndIf                                                               BUG9827
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512
                                                                                             BUG6512
     C                   EXSR      ZASETINCVT
      *                                                                                      BUG3792
      * Distinguish takings from placings for conditioning Block/Un-block buttons.           BUG3792
     C                   IF        DDTYPE = 'IP' OR DDTYPE = 'TI'                            BUG3792
     C                             OR DDTYPE = 'CL' OR DDTYPE = 'LN'                         BUG3792
     C                             OR DDTYPE = 'DL'                                          BUG3792
     C                             OR (CDL006 = 'Y' AND DDTYPE = 'FL')                       BUG3792
     C                             OR (CDL006 = 'Y' AND DDTYPE = 'DP')                       BUG3792
     C                             OR (CDL006 = 'Y' AND DDTYPE = 'LP')                       BUG3792
     C                   MOVEL     'P'           PLATAK                                      BUG3792
     C                   ELSE                                                                BUG3792
     C                   MOVEL     'T'           PLATAK                                      BUG3792
     C                   ENDIF                                                               BUG3792
                                                                                              CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
      *                                                                                       CDL018
     C     DDTYPE        IFEQ      'IT'                                                       CDL018
     C     DDTYPE        OREQ      'IP'                                                       CDL018
     C     DDTYPE        OREQ      'TD'                                                       CDL018
     C     DDTYPE        OREQ      'TI'                                                       CDL018
      *                                                                                       CDL018
     C     DDRMAC        IFEQ      'Y'                                                        CDL018
     C     DDPMAC        OREQ      'Y'                                                        CDL018
      *                                                                                       CDL018
     C     FLPSCY        IFEQ      *BLANK                                                     CDL018
     C                   MOVE      DDCCY         ##PCCY                                       CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C     FLRSCY        IFEQ      *BLANK                                                     CDL018
     C                   MOVE      DDCCY         ##RCCY                                       CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C                   EXSR      ZAFSETICVT                                                 CDL018
     C                   ENDIF                                                                CDL018
     C                   ENDIF                                                                CDL018
     C                   ENDIF                                                                CDL018
                                                                                              CDL018
     C                   ENDIF

     C                   ENDIF

     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
                                                                                              CDL033
     C                   IF        CDL033 = 'Y' AND Idx = 0                                   CDL033
     C                   EXSR      SRRetDates                                                 CDL033
     C                   MOVEA     RatDATEA      RatDateDS                                    CDL033
     C                   MOVEA     PayDATEA      PayDateDS                                    CDL033
     C                   ENDIF                                                                CDL033

      *                                                                                       CER043
      ***Population*of*Customer*Details                                                CER043 CSF011
     C**********         IF        CER043 = 'Y'                                        CER043 CSF011
     C**********         EXSR      SrPopCust                                           CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
                                                                                              CSF011
      ** Populate Customer Name Inputs                                                        CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      * Build buffer with required output
     C                   MOVE      HKTMST        @TimeStamp       26                         BUG3986
     C                   EVAL                    Buffer = DealScnfmt +
     C                                           InfData +
     C**********                                   SREMK +                           CMM105 BUG10688
     C                                           RFormula +                                   CDL033
     C                                           PFormula +                                   CDL033
     C                                           SREMK +                                    BUG10688
     C                                           DDSTS + DDCSTS +                            BUG3986
     C                                           CPST     + DSPCP +                          BUG6512
     C                                           BKST     + DSPBK +                          BUG6512
     C**********                                 @TimeStamp +                        BUG3986 BUG3684
     C**********                                 @TimeStamp + DDACTC +               BUG3684 BUG3792
     C                                           @TimeStamp + DDACTC + PLATAK +              BUG3792
     C                                           ACTRJ +                                    AR701789
     C                                           DDFOID  +                                    239400
     C                                           #FRECS  + #FPAYS +                           CDL018
     C**********                                 ##RECS  + ##PAYS                             CER001
     C**********                                 ##RECS  + ##PAYS + RegData          CER001 BUG10296
     C**********                                 + ExtData                           CCDL03 BUG10296
     C**********                                 + ExtData + FIDTScnRstN +          BUG9827 BUG10563
     C                                           ##RECS  + ##PAYS +                         BUG10563
     C                                           WDUMMY + FIDTScnRstN +                     BUG10563
     C                                           Filler2                                      CSF011
     C**********                                 Filler2 + FIDTScnRpt                 BUG9827 CER043
     C**********                                 Filler2 + TranInCust +                CER043 CER049
     C**********                                 Filler2 + TranQExt +               CER049 AR819540A
     C**********                                 TranInCust +                       CER049 AR819540A
     C**********                                 Filler2 + TranInCust +             AR819540A CSF011
     C**********                                 TranQExt +                         AR819540A CSF011
     C**********                                 FIDTScnRpt                            CER043 CSF011
                                                                                              CDL033
     C**********         EVAL      Buffer2 = *Blanks                                 CDL033 BUG10296
     C**********         EVAL      Buffer2 = LDNIFil + RegData                      BUG10296 BUG9827
     C**********         EVAL      Buffer2 = %subst(FIDTScnRpt:754)                   BUG9827 CSF011
     C**********         EVAL      Buffer2 = %SUBST(Filler2:606)                       CSF011 CDL096
     C**********         EVAL      Buffer2 = %SUBST(Filler2:572)                       CDL096 CGL165
     C**********         EVAL      Buffer2 = %SUBST(Filler2:568)                     CGL165 MD054028
     C                   EVAL      Buffer2 = %SUBST(Filler2:357)                            MD054028
     C                                       + TranQExt                                       CSF011
     C                                       + DDAPRC + DDAPRR                              MD054028
     C                                       + FIDTScnRpt                                     CSF011
     C**********         EVAL      BufferEx2 = RatDateDS + PayDateDS                 CDL033 BUG10943
     C**********                              + RegData                            BUG10563 BUG10943
     C******             EVAL      BufferEx2 = RegData + RatDateDS                 BUG10943 244784
     C******                                  + PayDateDS                          BUG10943 244784
     C**********         EVAL      BufferEx2 = RatDateDS + PayDateDS                   244784 CSF011
     C**********                              + RegData                                244784 CSF011
     C**********                              + ExtData                                248297 CSF011
     C**********         EVAL      BufferEx2 = %SUBST(FIDTScnRpt:2438)              CSF011 AR1060863
     C**********                              + RatDateDS + PayDateDS               CSF011 AR1060863
     C**********         EVAL      BufferEx3 = %SUBST(PayDateDS:2885)               CSF011 AR1060863
     C**********                              + RegData + ExtData                   CSF011 AR1060863
     C                   EVAL      BufferEx2 = %SUBST(FIDTScnRpt:2471:2281)                AR1060863
     C                                        + RatDateDS                                  AR1060863
     C                   EVAL      BufferEx3 = Filler3 + PayDateDS                         AR1060863
     C                                        + RegData + ExtData                          AR1060863

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCUST <> *BLANKS                                         CSF011A
     C                   EVAL      PCNum = DDCUST                                            CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Interest Settlement Account                                                         CSF011A
                                                                                             CSF011A
     C                   IF        DDINSA <> *BLANKS                                         CSF011A
                                                                                             CSF011A
     C                   MOVEL     *BLANKS       A#OURA                                      CSF011A
     C                   MOVEL     DDINSA        A#OURA                                      CSF011A
     C                   IF        DDISCY <> *BLANKS                                         CSF011A
     C                   MOVE      DDISCY        @CYCD                                       CSF011A
     C                   ELSE                                                                CSF011A
     C                   MOVE      DDCCY         @CYCD                                       CSF011A
     C                   ENDIF                                                               CSF011A
     C                   EXSR      CNIRTV                                                    CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDIASN = BBCSSN                                           CSF011A
     C                   EVAL      DDIANM = BBCRNM                                           CSF011A
     C                   EVAL      DDIATN = BBCRTN                                           CSF011A
     C                   EVAL      DDIAAN = AC_ANAM                                          CSF011A
     C                   EVAL      DDIASW = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Interest Counterparty Nostro                                                        CSF011A
                                                                                             CSF011A
     C                   IF        DDINOS <> *BLANKS                                         CSF011A
     C                   EVAL      PCNum = DDINOS                                            CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDINSN = BBCSSN                                           CSF011A
     C                   EVAL      DDINNM = BBCRNM                                           CSF011A
     C                   EVAL      DDINTN = BBCRTN                                           CSF011A
     C                   EVAL      DDINSW = BBCSID                                           CSF011A
     C                   ELSE                                                                CSF011A
     C                   EXSR      ACCNST                                                    CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDINSN = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDINNM = AWCPNM                                           CSF011A
     C                   EVAL      DDINTN = AWCNTN                                           CSF011A
     C                   EVAL      DDINSW = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Current Holder of CD                                                                CSF011A
                                                                                             CSF011A
     C                   IF        DDCDCH <> *BLANKS                                         CSF011A
     C                   EVAL      PCNum = DDCDCH                                            CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDCDSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCDNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCDTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACNOST - Access Nostro Details                                *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACNOST        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AONOSTR0'                                                CSF011A
     C                   PARM      *BLANKS       PRtcd                                       CSF011A
     C                   PARM      '*KEY   '     POptn                                       CSF011A
     C                   PARM      *BLANKS       @CUST                                       CSF011A
     C                   PARM                    @CYCD                                       CSF011A
     C                   PARM      *BLANKS       @ACCD                                       CSF011A
     C                   PARM      *BLANKS       @ACSN                                       CSF011A
     C                   PARM                    @NOSN                                       CSF011A
     C                   PARM      *BLANKS       @BRCA                                       CSF011A
     C                   PARM      *BLANKS       @CSSN                                       CSF011A
     C                   PARM      *BLANKS       @PNOI                                       CSF011A
     C     SDNOST        PARM      SDNOST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACACCT - Access Account Details                               *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACACCT        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOACCTV0'                                                CSF011A
     C                   PARM      *BLANKS       PRtcd                                       CSF011A
     C                   PARM                    @ACID                                       CSF011A
     C                   PARM                    @CYCD                                       CSF011A
     C                   PARM                    @ACCD                                       CSF011A
     C                   PARM                    @ACSN                                       CSF011A
     C                   PARM                    @BRCA                                       CSF011A
     C                   PARM                    @TYPE                                       CSF011A
     C                   PARM                    @NOSN                                       CSF011A
     C     ACCNT         PARM      ACCNT         DSSDY                                       CSF011A
     C                                                                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCNST - Access Counterparty Nostro Details                   *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACCNST        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOCNSTR0'                                                CSF011A
     C                   PARM      *BLANKS       PRtcd                                       CSF011A
     C                   PARM      '*KEY   '     POptn                                       CSF011A
     C                   PARM                    PCNum                                       CSF011A
     C     SDCNST        PARM      SDCNST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * CNIRTV - Retrive Customer and Account Details                 *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     CNIRTV        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   SETOFF                                       515253                 CSF011A
     C                   SETOFF                                       54                     CSF011A
                                                                                             CSF011A
     C                   CLEAR                   ACCNT                                       CSF011A
     C                   CLEAR                   SDCUST                                      CSF011A
                                                                                             CSF011A
     C                   TESTN                   A#NOST               51        Nostro       CSF011A
     C                   TESTN                   A#ACOD               52        Ledger       CSF011A
     C   52              TESTN                   A#ACSQ               52        Ledger       CSF011A
     C                   TESTN                   A#RENO               53        Retail       CSF011A
                                                                                             CSF011A
     C                   SELECT                                                              CSF011A
     C                   WHEN      A#CNUM <> *BLANKS AND A#ACAS = *BLANKS                    CSF011A
     C                             AND %LEN(A#CNUM) = 6 AND *IN51 = *OFF                     CSF011A
     C                   EVAL      *IN54 = *ON                                               CSF011A
     C                   EVAL      PCNum = A#CNUM                                            CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN51 = *ON AND A#REST = *BLANKS                          CSF011A
     C                   MOVE      A#NOST        @NOSN                                       CSF011A
     C                   EXSR      ACNOST                                                    CSF011A
     C                   MOVEL     *BLANKS       @ACID                                       CSF011A
     C                   MOVEL     NO_A7CUST     @ACID                                       CSF011A
     C                   MOVE      NO_A7ACCD     @ACCD                                       CSF011A
     C                   MOVE      NO_A7ACSN     @ACSN                                       CSF011A
     C                   MOVE      NO_A7BRCD     @BRCA                                       CSF011A
     C                   IF        @RTCD <> *BLANKS                                          CSF011A
     C                   EVAL      *IN54 = *ON                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN52 = *ON                                               CSF011A
     C                   MOVEL     *BLANKS       @ACID                                       CSF011A
     C                   MOVEL     A#CNUM        @ACID                                       CSF011A
     C                   MOVE      A#ACSQ        @ACSN                                       CSF011A
     C                   MOVE      A#ACOD        @ACCD                                       CSF011A
     C                   MOVE      A#BRCA        @BRCA                                       CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN53 = *ON                                               CSF011A
     C                   MOVEL     A#RENO        @ACID                                       CSF011A
     C                   MOVE      *BLANKS       @CYCD                                       CSF011A
     C                   MOVE      *BLANKS       @ACSN                                       CSF011A
     C                   MOVE      *BLANKS       @ACCD                                       CSF011A
     C                   MOVE      *BLANKS       @BRCA                                       CSF011A
                                                                                             CSF011A
     C                   ENDSL                                                               CSF011A
                                                                                             CSF011A
     C  N54              EXSR      ACACCT                                                    CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      PCNum = AC_CNUM                                           CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      ******************************************************************                     CSF011A
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    Buffer2                                      CDL033
     C                   PARM                    BufferEx2                                    CDL033
     C                   PARM                    BufferEx3                                    CSF011
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
     C                   PARM                    ACTRJ             1                        AR701789

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMLDNIM01

      ** Access SAR details file to determine if CDL018 is switched on                        CDL018
      ** (Multiple Settlement Accounts on Loans/Deposit)                                      CDL018
                                                                                              CDL018
     C                   CallB     'AOSARDR0'                                                 CDL018
     C                   Parm      *Blanks       PRTCD             7                          CDL018
     C                   Parm      '*VERIFY'     POPTN             7                          CDL018
     C                   Parm      'CDL018'      PSARD             6                          CDL018
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL018
      *                                                                                       CDL018
     C                   Move      'N'           CDL018            1                          CDL018
     C                   If        PRTCD = *Blanks                                            CDL018
     C                   Eval      CDL018 = 'Y'                                               CDL018
     C                   Endif                                                                CDL018
                                                                                              CDL018
      ** Check if Fiduciary Dealing is installed                                             BUG3792
                                                                                             BUG3792
     C                   CALL      'AOSARDR0'                                                BUG3792
     C                   PARM      *BLANKS       PRTCD                                       BUG3792
     C                   PARM      '*VERIFY'     POPTN                                       BUG3792
     C                   PARM      'CDL006'      PSARD                                       BUG3792
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3792
                                                                                             BUG3792
     C                   IF        PRTCD = *BLANKS                                           BUG3792
     C                   EVAL      CDL006 = 'Y'                                              BUG3792
     C                   ELSE                                                                BUG3792
     C                   EVAL      CDL006 = 'N'                                              BUG3792
                                                                                             BUG3792
     C                   IF        PRTCD <> '*NRF'                                           BUG3792
     C     *LOCK         IN        LDA                                                       BUG3792
     C                   EVAL      DBKEY = 'CDL006'                                          BUG3792
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3792
     C                   EVAL      DBASE = 909                                               BUG3792
     C                   OUT       LDA                                                       BUG3792
     C                   EXSR      *PSSR                                                     BUG3792
     C                   ENDIF                                                               BUG3792
                                                                                             BUG3792
     C                   ENDIF                                                               BUG3792
      *                                                                                       CDL033
      ** Access SAR details file to determine if CDL033 is switch on                          CDL033
      *                                                                                       CDL033
     C                   MOVEL     'N'           CDL033            1                          CDL033
     C                   CALL      'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C     PRTCD         IFEQ      *BLANK                                                     CDL033
     C                   MOVEL     'Y'           CDL033                                       CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVEL     'N'           CDL033                                       CDL033
      *                                                                                       CDL033
      ** Database Error, if Return Code is not blanks or *NRF                                 CDL033
      *                                                                                       CDL033
     C     PRTCD         IFNE      '*NRF'                                                     CDL033
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
     C                   MOVEL     '002'         DBASE                                        CDL033
     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Access SDBANKPD                                                                      CDL033
      *                                                                                       CDL033
     C                   CALL      'AOBANKR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*FIRST '     POPTN                                        CDL033
     C     SDBANK        PARM      SDBANK        DSFDY                                        CDL033
                                                                                              CDL033
                                                                                             BUG3792
      *                                                                                       CER001
      * Check if Switch ULX600 is on                                                          CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX600'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX600 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX600 = 'N'                                               CER001
                                                                                              CER001
     C                   IF        PRTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX600'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 909                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if CER043 is switched on                                                       CER043
                                                                                              CER043
     C                   CALL      'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      CER043 = 'N'                                               CER043
                                                                                              CER043
     C                   IF        PRTCD <> '*NRF'                                            CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 909                                                CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   ENDIF                                                                CER043
     C/COPY WNCPYSRC,MMLDNIZC02
     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
     C     MMLDNIRED     BEGSR

     C                   CALLB     'MMLDNIRED'
      *
      * Input parameters
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut       10
      *
      * Mode = '*FRONT' (Front Office transaction interface)
      * Mode = '      ' (Not Front Office transaction interface)
      *
     C                   PARM                    ModeofOp          6
      *
      * Action code
     C                   PARM                    DDACTN            1
      *
      * Deal Number Pointer
     C                   PARM      DDDLNO_In     DDDLNO            6
      *
      * Front Office Transaction ID
     C                   PARM                    DDFRTN           20
      *
      * Read Forwards
     C                   PARM                    @RDFWD            1
      *
      * Read Backwards
     C                   PARM                    @RDBCK            1
      *
      * Output Parameters
      *
      * Error Message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Deal Number Read
     C                   PARM      *BLANK        @DLRED            6
      *
      * Front Office Deal Read
     C                   PARM                    @FTRED           20

     C                   ENDSR
      **********************************************************************
     C     MMLDNIRTV     BEGSR

     C                   CALLB     'MMLDNIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeIn        10
      *
      * Mode = '*FRONT' (Front Office transaction interface)
      * Mode = '      ' (Not Front Office transaction interface)
      *
     C                   PARM      *BLANK        ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *
      * (Midas) Depot Movement Reference
     C                   PARM                    DDDDMR            6
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      *
      * Booking branch
     C                   PARM                    DDBRCA
      * REPO Flag
     C                   PARM                    RepoFlag          1
      *
      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      *                                                                                     AR701789
     C                   PARM                    ACTRJ                                      AR701789
      *
      * OK - Action code
     C                   PARM      'Y'           DDActnOK          1
      *
      * OK - Deal Number
     C                   PARM      'Y'           DDDlnoOK          1
      *
      * OK - Booking branch
     C                   PARM      'Y'           DDBrsnOK          1
      *                                                                                       CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT             1                          CDL016
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller

     C                   PARM                    Idx
      ** Warning flds/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    WIdx
     C/COPY WNCPYSRC,MMLDNIZC03

     C                   ENDSR
      **********************************************************************
      *                                                               *                       CER001
      * MMLDNI2RV - Subroutine to retrieve extension file details     *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     MMLDNI2RV     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'MMLDNI2RV'                                                CER001
      *                                                                                       CER001
      ** INPUTS                                                                               CER001
      ** Return Code                                                                          CER001
      ** Action Code                                                                          CER001
      ** (Midas) Deal Number                                                                  CER001
      *                                                                                       CER001
     C                   PARM      *BLANK        RetCodeIn                                    CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DDDLNO                                       CER001
      *                                                                                       CER001
      ** OUTPUTS                                                                              CER001
      ** (Current) Deal in file format                                                        CER001
      *                                                                                       CER001
     C                   PARM                    LDNILUXFilFmt                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      ****************************************************************                        CER001
      /EJECT                                                                                  CER001
      ****************************************************************                        CER001
     C     MMLDNICVT     BEGSR

     C                   CALLB     'MMLDNICVT'

      * INPUTS
      * Return Code
     C                   PARM      *BLANK        ReturnCode       10
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
      * Collateral Status
     C                   PARM                    DDCSTS           10

     C                   EVAL      DDFOID = HKFRNT                                            239400
                                                                                              239400
      *                                                                                       CER050
     C     DDAPRC        IFEQ      'N'                                                        CER050
     C     DDAPRC        OREQ      *Blanks                                                  MD054028
     C*****DDAPRR*       ANDNE     *Blanks                                           CER050 MD054028
     C     DDAPRR        IFNE      *Blanks                                                  MD054028
     C                   MOVE      *Blanks       DDAPRR                                       CER050
     C                   ENDIF                                                                CER050
     C                   ENDIF                                                              MD054028
      *                                                                                       CER050
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * MMLDNI2CT - Subroutine to convert extension details           *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     MMLDNI2CT     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'MMLDNI2CT'                                                CER001
      *                                                                                       CER001
      ** INPUTS                                                                               CER001
      ** Return Code                                                                          CER001
      ** (Midas) Deal Number                                                                  CER001
      ** Payment currency                                                                     CER001
      ** (Current) Deal in file format                                                        CER001
      *                                                                                       CER001
     C                   PARM      *BLANK        ReturnCode                                   CER001
     C                   PARM                    DDDLNO                                       CER001
     C                   PARM                    DDCCY                                        CER001
     C                   PARM                    LDNILUXFilFmt                                CER001
      *                                                                                       CER001
      ** OUTPUTS                                                                              CER001
      ** (Current) Deal in screen format                                                      CER001
      *                                                                                       CER001
     C                   PARM                    RegData                                      CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
     C     ZASETINCVT    BEGSR
      *
      * Set up payment instructions from deal
      *
     C*******************MOVEL     DELDPayIns    FLPAY                                        TCA002
     C                   MOVEL     HKPSTM        FLPSTM                                       TCA002
     C                   MOVEL     HKPONS        FLPONS                                       TCA002
     C                   MOVEL     DELDPayIns    FLPAY2                                       TCA002
     C                   MOVEL     HKPOBR        FLPOBR
     C                   MOVEL     HKCVMR        FLCVMR
     C                   MOVEL     HKSTCY        FLPSCY
     C                   MOVEL     HKIC72        FLIC72
     C                   MOVEL     HKPMAC        FLPMAC                                       CDL018
      *
      * Set up receive instructions from deal
      *
     C*******************MOVEL     DELDRecIns    FLREC                                        TCA002
     C                   MOVEL     HKRSTM        FLRSTM                                       TCA002
     C                   MOVEL     HKRONS        FLRONS                                       TCA002
     C                   MOVEL     DELDRecIns    FLREC2                                       TCA002
     C                   MOVEL     HKROBR        FLROBR
     C                   MOVEL     HKSTCY        FLRSCY
     C                   MOVEL     HKRMAC        FLRMAC                                       CDL018
     C                   MOVEL     HKRBB1        FLRBB1                                       CDL094
     C                   MOVEL     HKRBB2        FLRBB2                                       CDL094
     C                   MOVEL     HKRBB3        FLRBB3                                       CDL094
     C                   MOVEL     HKRBB4        FLRBB4                                       CDL094
     C                   MOVEL     HKRBB5        FLRBB5                                       CDL094
     C                   MOVEL     HKRBB6        FLRBB6                                       CDL094
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDCCY         #TRCCY                                      CSF011A
     C                   PARM      DDCCY         #TPCCY                                      CSF011A
      *
     C                   ENDSR
      /EJECT                                                                                  CDL018
      *****************************************************************                       CDL018
     C     ZAFSETICVT    BEGSR                                                                CDL018
                                                                                              CDL018
     C                   CALLB     'ZAFSETICVT'                                               CDL018
                                                                                              CDL018
      ** INPUT                                                                                CDL018
      ** Deal Number                                                                          CDL018
     C                   PARM                    DDDLNO                                       CDL018
                                                                                              CDL018
      * Action code                                                                           CDL018
     C                   PARM                    DDACTN                                       CDL018
                                                                                              CDL018
      ** Payment currency                                                                     CDL018
     C                   PARM                    ##PCCY            3                          CDL018
                                                                                              CDL018
      ** Receive currency                                                                     CDL018
     C                   PARM                    ##RCCY            3                          CDL018
                                                                                              CDL018
      ** LDNI Deal details                                                                    CDL018
     C                   PARM                    DealFilfmt                                   CDL018
                                                                                              CDL018
      ** OUTPUT                                                                               CDL018
      ** Screen - Payment Further Settlement Instructions                                     CDL018
     C                   PARM                    #FPAYS                                       CDL018
                                                                                              CDL018
      ** Screen - Receive Further Settlement Instructions                                     CDL018
     C                   PARM                    #FRECS                                       CDL018
                                                                                              CDL018
     C                   ENDSR                                                                CDL018
      **********************************************************************                 BUG6512
     C     ZACFFEERTV    BEGSR                                                               BUG6512
                                                                                             BUG6512
     C                   CALLB     'ZACFFEERTV'                                              BUG6512
      *                                                                                      BUG6512
      * INPUTS                                                                               BUG6512
      *                                                                                      BUG6512
      * Return code                                                                          BUG6512
     C                   PARM      *BLANK        RetCodeIn        10                         BUG6512
      *                                                                                      BUG6512
      * Action Code                                                                          BUG6512
     C                   PARM                    DDACTN            1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    DDDLNO            6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    HKBKCD            4                         BUG6512
      *                                                                                      BUG6512
      * OUTPUTS                                                                              BUG6512
      *                                                                                      BUG6512
      * OK - Action code                                                                     BUG6512
     C                   PARM      'Y'           DDActnOK          1                         BUG6512
      *                                                                                      BUG6512
      * Counterparty Status                                                                  BUG6512
     C                   PARM                    CPST              2                         BUG6512
     C                   PARM                    DSPCP             1                         BUG6512
      *                                                                                      BUG6512
      * Broker Status                                                                        BUG6512
     C                   PARM                    BKST              2                         BUG6512
     C                   PARM                    DSPBK             1                         BUG6512
      *                                                                                      BUG6512
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG6512
     C                   PARM                    FldNameArr                                  BUG6512
     C                   PARM                    MsgIdArr                                    BUG6512
     C                   PARM                    MsgDtaArr                                   BUG6512
      *                                                                                      BUG6512
      * Array index (3P0) from/to caller                                                     BUG6512
     C                   PARM                    Idx                                         BUG6512
                                                                                             BUG6512
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG6512
                                                                                             BUG6512
     C                   PARM      *BLANKS       WFldNamArr                                  BUG6512
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG6512
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG6512
                                                                                             BUG6512
      ** Warning array index (3P0) from/to caller                                            BUG6512
                                                                                             BUG6512
     C                   PARM      *ZEROS        WIdx                                        BUG6512
                                                                                             BUG6512
     C                   ENDSR                                                               BUG6512
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
     C     SRRetDates    BEGSR                                                                CDL033
      *                                                                                       CDL033
     C                   EVAL      P = 0                                                      CDL033
     C                   EVAL      R = 0                                                      CDL033
      *                                                                                       CDL033
     C                   MOVE      DDDLNO        DDLNO                                        CDL033
     C     DDLNO         SETLL     DLFRSCL1                                                   CDL033
     C     DDLNO         READE     DLFRSCL1                                                   CDL033
     C                   DOU       %Eof                                                       CDL033
      *                                                                                       CDL033
      ** If Interest Payment Frequency is 'Z'                                                 CDL033
      *                                                                                       CDL033
     C                   IF        DDIPFQ = 'Z' and                                           CDL033
     C                             HHRCIP = 'P'                                               CDL033
     C                   EVAL      P           = P + 1                                        CDL033
     C                   EVAL      PayCOHO (P) = HHCOHO                                       CDL033
     C                   EVAL      PayDTPR (P) = HHDTPR                                       CDL033
      *                                                                                       CDL033
     C                   CALL      'ZDATE2    '                                               CDL033
     C                   PARM      HHPRDT        PDayNo                                       CDL033
     C                   PARM      BJDFIN        PDaTFmt                                      CDL033
     C                   PARM      *Zeros        PDate                                        CDL033
     C                   PARM      *Blanks       PDate2                                       CDL033
      *                                                                                       CDL033
     C                   IF        PDate = 0                                                  CDL033
     C                   MOVE      *BLANKS       PayDate                                      CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVE      PDate         PayDate (P)                                  CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If Rate Change Frequency is 'Z'                                                      CDL033
      *                                                                                       CDL033
     C                   IF        DDRCFR = 'Z' and                                           CDL033
     C                             HHRCIP = 'R'                                               CDL033
     C                   EVAL      R           = R + 1                                        CDL033
     C                   EVAL      RatCOHO (R) = HHCOHO                                       CDL033
     C                   EVAL      RatDTPR (R) = HHDTPR                                       CDL033
      *                                                                                       CDL033
     C                   CALL      'ZDATE2    '                                               CDL033
     C                   PARM      HHPRDT        PDayNo                                       CDL033
     C                   PARM      BJDFIN        PDaTFmt                                      CDL033
     C                   PARM      *Zeros        PDate                                        CDL033
     C                   PARM      *Blanks       PDate2                                       CDL033
      *                                                                                       CDL033
     C                   IF        PDate = 0                                                  CDL033
     C                   MOVE      *BLANKS       PayDate                                      CDL033
     C                   ELSE                                                                 CDL033
     C                   MOVE      PDate         RatDate (R)                                  CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
     C     DDLNO         READE     DLFRSCL1                                                   CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                      BUG9827
      /EJECT                                                                                 BUG9827
      *****************************************************************                      BUG9827
      *                                                               *                      BUG9827
      * MMFIDTDET - Subroutine to retrieve and setup linked takings   *                      BUG9827
      *             screen details                                    *                      BUG9827
      *                                                               *                      BUG9827
      *****************************************************************                      BUG9827
     C     MMFIDTDET     BEGSR                                                               BUG9827
      *                                                                                      BUG9827
     C                   Eval      Str = 1                                                   BUG9827
     C                   MOVE      DDDLNO        DDLNO                                       BUG9827
      *                                                                                      BUG9827
     C     DDLNO         SETLL     MMDELDLF                                                  BUG9827
     C     DDLNO         READE     MMDELDLF                                                  BUG9827
     C                   Dow       not %eof                                                  BUG9827
      *                                                                                      BUG9827
     C                   MOVE      L_HKDN38      SFDLNO                                      BUG9827
     C                   MOVEL     L_HKCNUM      SFCNUM                                      BUG9827
     C                   Eval      SFPTFR = L_HKPTFR                                         BUG9827
     C                   Eval      SFACOD = %subst(L_HKDORI:7:10)                            BUG9827
     C                   Eval      SFACSQ = %subst(L_HKDORI:17:2)                            BUG9827
     C                   Eval      SFTRAS = L_HKFTST                                         BUG9827
      *                                                                                      BUG9827
     C                   MOVE      L_HKAMNP      ZField                                      BUG9827
     C                   Eval      Zdec = L_HKCYDP                                           BUG9827
     C                   CALLB     'ZEDIT2'                                                  BUG9827
     C                   PARM                    ZField                                      BUG9827
     C                   PARM                    Zdec                                        BUG9827
     C                   MOVE      ZField        SFAMNT                                      BUG9827
      *                                                                                      BUG9827
     C                   Eval      %subst(FIDTScnRpt:Str:FIDTLen) = WFIDTDTL                 BUG9827
     C                   Eval      Str = Str + FIDTLen                                       BUG9827
      *                                                                                      BUG9827
     C     DDLNO         READE     MMDELDLF                                                  BUG9827
     C                   enddo                                                               BUG9827
      *                                                                                      BUG9827
     C                   ENDSR                                                               BUG9827
      *****************************************************************
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      *  SrPopCust - Subroutine to Populate Customer Details          *                       CER043
      *                                                               *                       CER043
      *  Called by: MAIN Processing                                   *                       CER043
      *                                                               *                       CER043
      *  Calls: SrRtvCust                                             *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
      **********                                                                       CER043 CSF011
     C*****SrPopCust     BEGSR                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         CLEAR                   TranInCust                            CER043 CSF011
      **********                                                                       CER043 CSF011
      ***Retrieve*Customer*Details                                                     CER043 CSF011
     C**********         IF        DDCUST <> *BLANKS                                   CER043 CSF011
     C**********         EVAL      PCNum = DDCUST                                      CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         EXSR      SrRtvCust                                           CER043 CSF011
     C**********         IF        PRtcd = *BLANKS                                     CER043 CSF011
     C**********         EVAL      DDCSSN = BBCSSN                                     CER043 CSF011
     C**********         EVAL      DDCRNM = BBCRNM                                     CER043 CSF011
     C**********         EVAL      DDCRTN = BBCRTN                                     CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         ENDSR                                                         CER043 CSF011
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CER043
      *                                                               *                       CER043
      *  Called by: SrPopCust                                         *                       CER043
      *                                                               *                       CER043
      *  Calls: None                                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
     C     SrRtvCust     BEGSR                                                                CER043
      *                                                                                       CER043
      ** Call AOCUSTR0 to get Customer Details                                                CER043
     C                   CALLB     'AOCUSTR0'                                                 CER043
     C                   PARM      *BLANKS       PRtcd                                        CER043
     C                   PARM      '*KEY   '     POptn                                        CER043
     C                   PARM                    PCNum                                        CER043
     C                   PARM      *BLANKS       PKey7                                        CER043
     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
      *                                                                                       CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
**  CPY@
(c) Finastra International Limited 2003
