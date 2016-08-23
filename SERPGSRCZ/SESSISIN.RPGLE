     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Standard Settlement Additional Info')         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESSISIN - Standard Settlement Additional Information        *
      *                                                               *
      *  Function:  This module will be the entry module for screen-  *
      *             input function for Standard Settlement Additional *
      *             Information.                                      *
      *                                                               *
      *  Component of: SESSISIN - Standard Settlement Additional      *
      *                           Information                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD022652           Date 07Oct13               *
      *  Prev Amend No. AR325342           Date 19May10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2400            Date 11May04               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209247             Date 08Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205450             Date 02May02               *
      *                 CSE034             Date 22Apr02               *
      *                 203368             Date 26Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022652 - Excluded Phase Processing                         *
      *  AR325342 - Clearing correspondent field must not be displayed*
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2400 - Initialised the trade and depot data structures.   *
      *  209247 - Add Custodian and Safe A/c narrative                *
      *  205450 - Template function not working correctly.            *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  203368 - Field 'To be used for Depot Movement' erroneously   *
      *           defaulted to 'N' even if value exist on file.       *
      *  CSE028  -  Standing Settlement Instructions Enhancement      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         No indicators used                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     -  Initial Processing                             *
      *  SRDefault  -  Setup default template                         *
      *  SRRetrieve -  Retrieve existing details                      *
      *  SRDisplay  -  Display additional SSI for swift               *
      *  SRUpdate   -  Update additional standard settlement          *
      *                instructions                                   *
      *  SRReturn   -  Return to calling program                      *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
 
      ** SE Market Centres file                                                               CSE034
     FSEMKC     IF   E           K DISK    Prefix(WJ)                                         CSE034
      *                                                                                       CSE034
 
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
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS security customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** External DS for book code details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** Externam DS SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for trade purchase (for retrieve)
     D PTradePRtv    E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TPR:2)
 
      ** DS for trade sale     (for retrieve)
     D PTradeSRtv    E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TSR:2)
 
      ** DS for depot in       (for retrieve)
     D PDepotIRtv    E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DIR:2)
 
      ** DS for depot out      (for retrieve)
     D PDepotORtv    E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DOR:2)
 
      ** DS for trade purchase (for default)
     D PTradePTpl    E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TPT:2)
 
      ** DS for trade sale     (for default)
     D PTradeSTpl    E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TST:2)
 
      ** DS for depot in       (for default)
     D PDepotITpl    E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DIT:2)
 
      ** DS for depot out      (for default)
     D PDepotOTpl    E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DOT:2)
 
      ** DS for trade purchase (for update)
     D PTradeP       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TP:2)
 
      ** DS for trade sale     (for update)
     D PTradeS       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TS:2)
 
      ** DS for depot in       (for update)
     D PDepotI       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DI:2)
 
      ** DS for depot out      (for update)
     D PDepotO       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DO:2)
 
      ** DS for STDADSED to passed to SETSSIDSP or SEDSSIDSP
     D PAddSetD      E DS                  EXTNAME(STDADSED)
     D                                     Prefix(PA:2)
 
      ** DS for additional settlement details screen definition
     D PSetDetS        DS             6
     D  ISOMsg                 1      1
     D  ForDpM                 2      2
     D  TradeP                 3      3
     D  TradeS                 4      4
     D  DepotI                 5      5
     D  DepotO                 6      6
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Entry Parameter
     D PBranch         S              3A
     D PCustomer       S              6A
     D PBook           S              2A
     D PCcy            S              3A
     D PMktCtr         S              2A                                                      CSE034
     D PInvType        S              3A
     D PPorRef         S              4A
     D PSNEW           S              1A
     D PSTFDM          S              1A
 
     D PMode           S              1A
     D PINKC           S              1A
     D PINKL           S              1A
     D PCBInd          S              1A
     D PAdDType        S              1A
     D POvrXDet        S              1A
     D PKeySts         S              7A
     D PCNum           S             10A
     D PDescrptn       S             20A
     D*PCustNum*       S              6S 0                                                    CSD027
     D PCustNum        S              6A                                                      CSD027
 
     D CSE029          S              1A
     D CFT007          S              1A
     D CSW014          S              1A
     D CSW098          S              1A
     D CSW210          S              1A                                                      CSW210
     D CFT004          S              1A                                                      CSW210
     D PCSW202         S              1A                                                    AR325342
 
     D PRetCode        S                   LIKE(ReturnCode)
     D WRetTpl         S                   LIKE(ReturnCode)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * Main Procedure                                                    *
      *********************************************************************
 
      ** Initial processing
 
     C                   EXSR      SRInit
 
      ** Do while screen: Initial default template details screen
 
     C                   DOW       PMode = 'I'
 
     C                   IF        ActionCode = 'I' or ActionCode = 'A'
     C                   EVAL      PTradePRtv = *Blanks                                      BUG2400
     C                   EVAL      PTradeSRtv = *Blanks                                      BUG2400
     C                   EVAL      PDepotIRtv = *Blanks                                      BUG2400
     C                   EVAL      PDepotORtv = *Blanks                                      BUG2400
     C                   EXSR      SRDefault
     C                   ELSE
     C                   EVAL      PMode = 'D'
     C                   ENDIF
 
     C                   ENDDO
                                                                                              CSE034
      ** Default Place of Settlement from Market Centre                                       CSE034
     C                   IF        ActionCode = 'I' AND                                       CSE034
     C                             PMktCtr <> '  '                                            CSE034
                                                                                              CSE034
     C                   EXSR      SRDftPlcSett                                               CSE034
                                                                                              CSE034
     C                   ENDIF                                                                CSE034
 
      ** Retrieve existing details on file
     C                   IF        ActionCode = 'A' or ActionCode = 'E'
 
     C                   EXSR      SRRetrieve
 
     C                   ENDIF
 
      ** Do while screen: Main Details
 
     C                   DOW       PMode = 'D'
     C                   EXSR      SRDisplay
     C                   ENDDO
 
      ** Do while update
 
     C                   DOW       PMode = 'U'
     C                   EXSR      SRUpdate
     C                   ENDDO
 
      **  Return
 
     C                   IF        PMode = 'R'
     C                   EXSR      SRReturn
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      *  SRInit - Initial Processing                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   MOVEL     PCustomer     PCustNum
 
      ** Perform Customer processing if key is customer
     C**********         IF        PCustomer <> *BLANKS AND PCustNum <> 0                     CSD027
     C                   IF        PCustomer <> *BLANKS AND PCustNum <> *BLANKS               CSD027
 
     C                   EVAL      PCBInd = 'C'
     C                   MOVEL     PCustomer     PCNum
 
      ** Access Customer Details
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCNum
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   EVAL      PCustomer = BBCUST
     C                   MOVEL     BBCRNM        PDescrptn
 
     C                   CALL      'AOSECSR0'
     C                   PARM      'DBERR  '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCustomer
     C     SDSECS        PARM      SDSECS        DSSDY
 
      ** Otherwise, perform book processing
     C                   ELSE
 
     C                   EVAL      PCBInd = 'B'
     C                   EVAL      BFCLAS = *Blanks
 
      ** Access Book Code Details
 
     C                   CALLB     'AOBOOKR0'
     C                   PARM      'DBERR  '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PBook
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C                   MOVEL     BDBKD         PDescrptn
 
     C                   ENDIF
 
     C                   EVAL      PMode = 'I'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault - Setup default template                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRDefault     BEGSR
 
     C                   CALLB     'SESSITPL'
 
      ** Input Parameters
      ** ================
      ** Action code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Customer/Book indicator
 
     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM                    PCBInd
 
      ** SDBANKPD
      ** ========
      ** Midas Rundate
 
     C                   PARM                    BJMRDT
 
      ** SDMMODPD
      ** ========
      ** Portfolio Management
      ** Private Banking
 
     C                   PARM                    BGPFMG
     C                   PARM                    BGN4ST
 
      ** Output Parameters
      ** =================
      ** Override existing details (Y/N)
      ** Data Structure for Trade Purchase
      ** Data Structure for Trade Sale
      ** Data Structure for Depot In
      ** Data Structure for Depot Out
      ** Return Code
 
     C                   PARM                    POvrXDet
     C                   PARM      *BLANKS       PTradePTpl
     C                   PARM      *BLANKS       PTradeSTpl
     C                   PARM      *BLANKS       PDepotITpl
     C                   PARM      *BLANKS       PDepotOTpl
     C                   PARM      *BLANKS       PRetCode
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      PRetCode = 'SE10000'
     C                   EXSR      SRReturn
 
      ** F12 Pressed
 
     C                   WHEN      PRetCode = 'SE10001'
     C                   EXSR      SRReturn
 
     C                   OTHER
 
     C                   EVAL      WRetTpl = *BLANKS
 
     C                   IF        PRetCode  <> *BLANKS
     C                   EVAL      WRetTpl = PRetCode
     C                   ELSE
 
     C                   IF        ActionCode = 'I'
     C                   EVAL      PTradePRtv = PTradePTpl
     C                   EVAL      PTradeSRtv = PTradeSTpl
     C                   EVAL      PDepotIRtv = PDepotITpl
     C                   EVAL      PDepotORtv = PDepotOTpl
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      PMode = 'D'
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE034
      *****************************************************************                       CSE034
      *                                                               *                       CSE034
      *  SRDftPlcSett - Default Place of Settlement from Market Ctr   *                       CSE034
      *                                                               *                       CSE034
      * Called by: Main processing                                    *                       CSE034
      *                                                               *                       CSE034
      * Calls:                                                        *                       CSE034
      *                                                               *                       CSE034
      *****************************************************************                       CSE034
     C     SRDftPlcSett  BEGSR                                                                CSE034
                                                                                              CSE034
     C     PMktCtr       CHAIN     SEMKC                                                      CSE034
                                                                                              CSE034
     C                   IF        TPRPSET = *blanks                                          CSE034
     C                   EVAL      TPRPSET = WJPSETL                                          CSE034
     C                   ENDIF                                                                CSE034
                                                                                              CSE034
     C                   IF        TSRPSET = *blanks                                          CSE034
     C                   EVAL      TSRPSET = WJPSETL                                          CSE034
     C                   ENDIF                                                                CSE034
                                                                                              CSE034
     C                   IF        DIRPSET = *blanks                                          CSE034
     C                   EVAL      DIRPSET = WJPSETL                                          CSE034
     C                   ENDIF                                                                CSE034
                                                                                              CSE034
     C                   IF        DORPSET = *blanks                                          CSE034
     C                   EVAL      DORPSET = WJPSETL                                          CSE034
     C                   ENDIF                                                                CSE034
                                                                                              CSE034
     C                   ENDSR                                                                CSE034
      *****************************************************************                       CSE034
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRetrieve - Retrieve existing details                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRRetrieve    BEGSR
 
     C                   CALLB     'SESSIRTV'
 
      ** Input Parameters
      ** ================
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book indicator
 
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PCBInd
 
      ** Output Parameters
      ** =================
      ** Data Structure for Trade Purchase
      ** Data Structure for Trade Sale
      ** Data Structure for Depot In
      ** Data Structure for Depot Out
      ** Return Code
 
     C                   PARM                    PTradePRtv
     C                   PARM                    PTradeSRtv
     C                   PARM                    PDepotIRtv
     C                   PARM                    PDepotORtv
     C                   PARM      *BLANKS       PRetCode
 
     C                   IF        PRetCode   <> *BLANKS
 
     C                   IF        ActionCode = 'E'
     C                   EVAL      PMode = 'R'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        ActionCode = 'A'  AND
     C                             WRetTpl    = *BLANKS AND
     C                             POvrXDet   = 'Y'
 
     C                   EVAL      PTradePRtv = PTradePTpl
     C                   EVAL      PTradeSRtv = PTradeSTpl
     C                   EVAL      PDepotIRtv = PDepotITpl
     C                   EVAL      PDepotORtv = PDepotOTpl
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display additional SSI for swift                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRDisplay     BEGSR
 
     C                   IF        PSTFDM <> *BLANKS                                          203368
     C                   Eval      ForDpM = PSTFDM                                            203368
     C                   ENDIF                                                                203368
                                                                                              203368
     C                   CALLB     'SESSIDSP'
 
      ** Input Parameters
      ** ================
      ** Action code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Customer Classification
      ** CSE029 SAR
      ** Customer/Book indicator
 
     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM                    BFCLAS
     C                   PARM                    CSE029
     C                   PARM                    PCBInd
 
      ** SDBANKPD
      ** ========
      ** Midas Rundate
 
     C                   PARM                    BJMRDT
 
      ** SDMMODPD
      ** ========
      ** Portfolio Management
      ** Private Banking
 
     C                   PARM                    BGPFMG
     C                   PARM                    BGN4ST
 
      ** Input/Output Parameters
      ** =======================
      ** Data Structure for additional settlement details screen definition
 
     C                   PARM                    PSetDetS
 
      ** Output Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANKS       PRetCode
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      PRetCode = 'SE10000'
     C                   EXSR      SRReturn
 
      ** F12 Pressed
 
     C                   WHEN      PRetCode = 'SE10001'
     C                   EXSR      SRReturn
 
     C                   OTHER
 
     C**********         IF        TradeP = 'Y' OR TradeS = 'Y'                               205450
     C                   EXSR      SRExSetTr
     C**********         ENDIF                                                                205450
 
     C                   IF        PRetCode   = *BLANKS
 
     C**********         IF        DepotI = 'Y' OR DepotO = 'Y'                               205450
     C                   EXSR      SRExSetDp
     C**********         ENDIF                                                                205450
 
     C                   ENDIF
 
     C                   IF        PRetCode   = *BLANKS
 
     C                   EVAL      PMode = 'U'
 
     C                   ELSE
 
     C                   IF        PRetCode   = 'SE10001'
     C                   EVAL      PMode = 'D'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExSetTr - Display SSI for swift (Trade)                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRExSetTr     BEGSR
 
     C                   IF        TradeP = 'Y'
 
     C                   CALLB     'SETSSIDSP'
 
      ** Input Parameters
      ** ================
      ** Action Code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Additional detail type
      ** Customer/Book indicator
      ** ISO15022 message indicator
      ** To be used for depot movement
 
     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM      'P'           PAdDType
     C                   PARM                    PCBInd
     C                   PARM                    ISOMsg
     C                   PARM                    ForDpm
 
      ** SDBANKPD
      ** ========
      ** Rundate
 
     C                   PARM                    BJMRDT
 
      ** SDMMODPD
      ** ========
      ** Portfolio Management
      ** Private Banking
 
     C                   PARM                    BGPFMG
     C                   PARM                    BGN4ST
 
      ** SDSECSPD
      ** ========
      ** Customer classification
 
     C                   PARM                    BFCLAS
 
      ** SCSARDPD
      ** ========
      ** ERI
      ** SWIFT 1998 changes
      ** BIC database plus
      ** ISO 15022 Data Export                                                                209247
      ** SWIFT 2010 changes                                                                   CSW210
      ** IBAN                                                                                 CSW210
 
     C                   PARM                    CSW014
     C                   PARM                    CSW098
     C                   PARM                    CFT007
     C                   PARM                    CSE029                                       209247
     C                   PARM                    CSW206            1                         CSW206E
     C                   PARM                    CSW210                                       CSW210
     C                   PARM                    CFT004                                       CSW210
     C                   PARM                    PCSW202                                    AR325342
 
      ** Input/Output Parameters
      ** =======================
      ** Data Structure for additional settlement details
 
     C                   PARM      PTradePRtv    PAddSetD
 
      ** Output Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANKS       PRetCode
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      PRetCode = 'SE10000'
     C                   EXSR      SRReturn
 
      ** F12 Pressed
 
     C                   WHEN      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'D'
     C                   GOTO      EndTrade
 
     C                   OTHER
 
     C                   IF        PRetCode   = *BLANKS
     C                   EVAL      PMode = 'U'
     C                   EVAL      PTradeP = PAddSetD
     C                   ELSE
     C                   EVAL      PMode = 'R'
     C                   ENDIF
 
     C                   ENDSL
                                                                                              205450
     C                   ELSE                                                                 205450
     C                   EVAL      PTradeP = PTradePRtv                                       205450
 
     C                   ENDIF
 
     C                   IF        TradeS = 'Y'
 
     C                   CALLB     'SETSSIDSP'
 
      ** Input Parameters
      ** ================
      ** Action Code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Additional detail type
      ** Customer/Book indicator
      ** ISO15022 message indicator
      ** To be used for depot movement
 
     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM      'S'           PAdDType
     C                   PARM                    PCBInd
     C                   PARM                    ISOMsg
     C                   PARM                    ForDpm
 
      ** SDBANKPD
      ** ========
      ** Rundate
 
     C                   PARM                    BJMRDT
 
      ** SDMMODPD
      ** ========
      ** Portfolio Management
      ** Private Banking
 
     C                   PARM                    BGPFMG
     C                   PARM                    BGN4ST
 
      ** SDSECSPD
      ** ========
      ** Customer classification
 
     C                   PARM                    BFCLAS
 
      ** SCSARDPD
      ** ========
      ** ERI
      ** SWIFT 1998 changes
      ** BIC database plus
      ** ISO 15022 Data Export                                                                209247
      ** SWIFT 2010 changes                                                                   CSW210
      ** IBAN                                                                                 CSW210
 
     C                   PARM                    CSW014
     C                   PARM                    CSW098
     C                   PARM                    CFT007
     C                   PARM                    CSE029                                       209247
     C                   PARM                    CSW206                                      CSW206E
     C                   PARM                    CSW210                                       CSW210
     C                   PARM                    CFT004                                       CSW210
     C                   PARM                    PCSW202                                    AR325342
 
      ** Input/Output Parameters
      ** =======================
      ** Data Structure for additional settlement details
 
     C                   PARM      PTradeSRtv    PAddSetD
 
      ** Output Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANKS       PRetCode
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      PRetCode = 'SE10000'
     C                   EXSR      SRReturn
 
      ** F12 Pressed
 
     C                   WHEN      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'D'
     C                   GOTO      EndTrade
 
     C                   OTHER
 
     C                   IF        PRetCode   = *BLANKS
     C                   EVAL      PMode = 'U'
     C                   EVAL      PTradeS = PAddSetD
     C                   ELSE
     C                   EVAL      PMode = 'R'
     C                   ENDIF
 
     C                   ENDSL
                                                                                              205450
     C                   ELSE                                                                 205450
     C                   EVAL      PTradeS = PTradeSRtv                                       205450
 
     C                   ENDIF
 
     C     EndTrade      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExSetDp - Display SSI for swift (Depot)                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRExSetDp     BEGSR
 
     C                   IF        DepotI = 'Y'
 
     C                   CALLB     'SEDSSIDSP'
 
      ** Input Parameters
      ** ================
      ** Action Code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Additional detail type
      ** Customer/Book indicator
      ** ISO15022 message indicator
 
     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM      'I'           PAdDType
     C                   PARM                    PCBInd
     C                   PARM                    ISOMsg
 
      ** SDBANKPD
      ** ========
      ** Rundate
 
     C                   PARM                    BJMRDT
 
      ** SDSECSPD
      ** ========
      ** Customer classification
 
     C                   PARM                    BFCLAS
 
      ** SCSARDPD
      ** ========
      ** ERI
      ** SWIFT 1998 changes
      ** BIC database plus
      ** ISO 15022 Data Export                                                                209247
      ** SWIFT 2010 changes                                                                   CSW210
      ** IBAN                                                                                 CSW210
 
     C                   PARM                    CSW014
     C                   PARM                    CSW098
     C                   PARM                    CFT007
     C                   PARM                    CSE029                                       209247
     C                   PARM                    CSW206                                      CSW206E
     C                   PARM                    CSW210                                       CSW210
     C                   PARM                    CFT004                                       CSW210
     C                   PARM                    PCSW202                                    AR325342
 
      ** Input/Output Parameters
      ** =======================
      ** Data Structure for additional settlement details
 
     C                   PARM      PDepotIRtv    PAddSetD
 
      ** Output Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANKS       PRetCode
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      PRetCode = 'SE10000'
     C                   EXSR      SRReturn
 
      ** F12 Pressed
 
     C                   WHEN      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'D'
     C                   GOTO      EndDepot
 
     C                   OTHER
 
     C                   IF        PRetCode   = *BLANKS
     C                   EVAL      PMode = 'U'
     C                   EVAL      PDepotI = PAddSetD
     C                   ELSE
     C                   EVAL      PMode = 'R'
     C                   ENDIF
 
     C                   ENDSL
                                                                                              205450
     C                   ELSE                                                                 205450
     C                   EVAL      PDepotI = PDepotIRtv                                       205450
 
     C                   ENDIF
 
     C                   IF        DepotO = 'Y'
 
     C                   CALLB     'SEDSSIDSP'
 
      ** Input Parameters
      ** ================
      ** Action Code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Additional detail type
      ** Customer/Book indicator
      ** ISO15022 message indicator
 
     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM      'O'           PAdDType
     C                   PARM                    PCBInd
     C                   PARM                    ISOMsg
 
      ** SDBANKPD
      ** ========
      ** Rundate
 
     C                   PARM                    BJMRDT
 
      ** SDSECSPD
      ** ========
      ** Customer classification
 
     C                   PARM                    BFCLAS
 
      ** SCSARDPD
      ** ========
      ** ERI
      ** SWIFT 1998 changes
      ** BIC database plus
      ** ISO 15022 Data Export                                                                209247
      ** SWIFT 2010 changes                                                                   CSW210
      ** IBAN                                                                                 CSW210
 
     C                   PARM                    CSW014
     C                   PARM                    CSW098
     C                   PARM                    CFT007
     C                   PARM                    CSE029                                       209247
     C                   PARM                    CSW206                                      CSW206E
     C                   PARM                    CSW210                                       CSW210
     C                   PARM                    CFT004                                       CSW210
     C                   PARM                    PCSW202                                    AR325342
 
      ** Input/Output Parameters
      ** =======================
      ** Data Structure for additional settlement details
 
     C                   PARM      PDepotORtv    PAddSetD
 
      ** Output Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANKS       PRetCode
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      PRetCode = 'SE10000'
     C                   EXSR      SRReturn
 
      ** F12 Pressed
 
     C                   WHEN      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'D'
     C                   GOTO      EndDepot
 
     C                   OTHER
 
     C                   IF        PRetCode   = *BLANKS
     C                   EVAL      PMode = 'U'
     C                   EVAL      PDepotO = PAddSetD
     C                   ELSE
     C                   EVAL      PMode = 'R'
     C                   ENDIF
 
     C                   ENDSL
                                                                                              205450
     C                   ELSE                                                                 205450
     C                   EVAL      PDepotO = PDepotORtv                                       205450
 
     C                   ENDIF
 
     C     EndDepot      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update additional standard settlement instructions*
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   CALLB     'SESSIUPD'
 
      ** Input Parameters
      ** ================
      ** Action code
      ** Data Structure for Trade Purchase
      ** Data Structure for Trade Sale
      ** Data Structure for Depot In
      ** Data Structure for Depot Out
 
     C                   PARM                    ActionCode
     C                   PARM                    PTradeP
     C                   PARM                    PTradeS
     C                   PARM                    PDepotI
     C                   PARM                    PDepotO
 
      ** Output Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANKS       PRetCode
 
     C                   EVAL      PMode = 'R'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return to calling program                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRReturn      BEGSR
 
     C                   IF        PRetCode   <> *BLANKS
 
     C                   EVAL      RetCodeOut = PRetCode
 
     C                   ELSE
 
     C                   EVAL      RetCodeOut = *BLANKS
     C                   EVAL      PSNEW = ISOMsg
     C                   EVAL      PSTFDM = ForDpM
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Receive entry parameters.
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Action code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
 
     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
 
      ** Output Parameters
      ** -----------------
      ** ISO15022 Message Indicator
      ** Trade settlement to be use for depot movement indicator
      ** Return code
 
     C                   PARM                    PSNEW
     C                   PARM                    PSTFDM
     C                   PARM                    RetCodeOut
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDBANKPD'                         * DBERR 001*
     C                   EVAL      DBASE  =  001                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDMMODPD'                         * DBERR 002*
     C                   EVAL      DBASE  =  002                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSE029 is installed
 
     C                   EVAL      CSE029 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSE029'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error.
 
     C                   IF        @RtCd <> *BLANKS  AND
     C                             @RtCd <> '*NRF   '
     C                   EVAL      DBKEY = @SARD                                ************
     C                   EVAL      DBFILE = 'SCSARDPD'                          * DBASE 003*
     C                   EVAL      DBASE  =  003                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RtCd = *Blanks
     C                   EVAL      CSE029 = 'Y'
     C                   ENDIF
 
      ** Check if CFT007 is installed
 
     C                   EVAL      CFT007 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFT007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error.
 
     C                   IF        @RtCd <> *BLANKS  AND
     C                             @RtCd <> '*NRF   '
     C                   EVAL      DBKEY = @SARD                                ************
     C                   EVAL      DBFILE = 'SCSARDPD'                          * DBASE 004*
     C                   EVAL      DBASE  =  004                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RtCd = *Blanks
     C                   EVAL      CFT007 = 'Y'
     C                   ENDIF
 
      ** Check if CSW014 is installed
 
     C                   EVAL      CSW014 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSW014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error.
 
     C                   IF        @RtCd <> *BLANKS  AND
     C                             @RtCd <> '*NRF   '
     C                   EVAL      DBKEY = @SARD                                ************
     C                   EVAL      DBFILE = 'SCSARDPD'                          * DBASE 005*
     C                   EVAL      DBASE  =  005                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RtCd = *Blanks
     C                   EVAL      CSW014 = 'Y'
     C                   ENDIF
 
      ** Check if CSW098 is installed
 
     C                   EVAL      CSW098 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSW098'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error.
 
     C                   IF        @RtCd <> *BLANKS  AND
     C                             @RtCd <> '*NRF   '
     C                   EVAL      DBKEY = @SARD                                ************
     C                   EVAL      DBFILE = 'SCSARDPD'                          * DBASE 006*
     C                   EVAL      DBASE  =  006                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RtCd = *Blanks AND BJRDNB > 9876
     C                   EVAL      CSW098 = 'Y'
     C                   ENDIF
                                                                                            AR325342
     C                   CALL      'SWIF2002'                                               AR325342
     C                   PARM      *BLANKS       PRtCd                                      AR325342
                                                                                            AR325342
     C                   IF        PRtCd = 'CSW2002'                                        AR325342
     C                   EVAL      PCSW202 = 'Y'                                            AR325342
     C                   ELSE                                                               AR325342
     C                   EVAL      PCSW202 = 'N'                                            AR325342
     C                   ENDIF                                                              AR325342
                                                                                             CSW206E
      ** Check if SWIFT 2006 is installed                                                    CSW206E
                                                                                             CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD             7                         CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                              CSW210
      ** Check if CSW210 is installed                                                         CSW210
                                                                                              CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM      *BLANKS       @RtCd                                        CSW210
                                                                                              CSW210
     C                   IF        @RtCd = 'CSW2010'                                          CSW210
     C                   EVAL      CSW210 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Check if CFT004 is installed                                                         CSW210
                                                                                              CSW210
     C                   EVAL      CFT004 = 'N'                                               CSW210
     C                   CALLB     'AOSARDR0'                                                 CSW210
     C                   PARM      *Blanks       @RtCd                                        CSW210
     C                   PARM      '*VERIFY'     @Optn                                        CSW210
     C                   PARM      'CFT004'      @SARD                                        CSW210
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW210
                                                                                              CSW210
      ** Database error.                                                                      CSW210
                                                                                              CSW210
     C                   IF        @RtCd <> *BLANKS  AND                                      CSW210
     C                             @RtCd <> '*NRF   '                                         CSW210
     C                   EVAL      DBKEY = @SARD                                              CSW210
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW210
     C                   EVAL      DBASE  =  007                                              CSW210
     C                   EXSR      *PSSR                                                      CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        @RtCd = *Blanks                                            CSW210
     C                   EVAL      CFT004 = 'Y'                                               CSW210
     C                   ENDIF                                                                CSW210
                                                                                            MD022652
      ** Check if CFT050 is installed                                                       MD022652
                                                                                            MD022652
     C                   CALLB     'AOSARDR0'                                               MD022652
     C                   PARM      *Blanks       PRtCd             7                        MD022652
     C                   PARM      '*VERIFY'     POptn             7                        MD022652
     C                   PARM      'CFT050'      PSARD             6                        MD022652
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD022652
                                                                                            MD022652
      ** Database error.                                                                    MD022652
                                                                                            MD022652
     C                   IF        PRtCd <> *BLANKS  AND                                    MD022652
     C                             PRtCd <> '*NRF   '                                       MD022652
     C                   EVAL      DBKEY = PSARD                                            MD022652
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD022652
     C                   EVAL      DBASE  =  008                                            MD022652
     C                   EXSR      *PSSR                                                    MD022652
     C                   ENDIF                                                              MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
     C                   IF        PRtCd = *Blanks                                          MD022652
     C                   EVAL      CFT007 = 'Y'                                             MD022652
     C                   ENDIF                                                              MD022652
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
