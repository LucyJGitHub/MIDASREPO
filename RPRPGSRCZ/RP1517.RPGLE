     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Extraction Module for TRANSD')                *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian DBA Replication                             *
      *                                                               *
      *  RP1517 - Extract module for TRANSD                           *
      *                                                               *
      *  Function:  This module only sends transactions for Private   *
      *  (I/C)      Banking Customers.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR858264A          Date 16Jul12               *
      *  Prev Amend No. AR983495           Date 04Jun12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245868             Date 21Feb07               *
      *                 220152             Date 01Aug03               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 CPB010             Date 16Jan03               *
      *                 CPB008             Date 15Oct02               *
      *                 206938             Date 26Jun02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR983495 - Missing fixes in some replication trigger         *
      *             programs for TOF (Child: AR983496)                *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  245868 - Apply 220152                                        *
      *  220152 - Avoid missing of access to Inst detail, always      *
      *           do the CHAIN in INTYPD for each message             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  CPB010 - Avoid DB Error by write message in Repair File      *
      *           Execute Subroutine Repair instead of *Pssr in case  *
      *              of database error.                               *
      *           Two possibility, message can be repair or not:      *
      *               Set MessageInd to 'Y' in case of repair or 'N'  *
      *           If the message is associated to an other messages   *
      *           like xxx_B and xxx_After, xxx_B must be setup       *
      *           in the associated messages and _After is the master.*
      *           To manage the repair messages, call RPC1492.        *
      *  CPB008 - TOF ODBC Management Enhancement:                    *
      *           - Add Instrument types Info to output message to    *
      *             avoid ODBC Client Access:                         *
      *                 IN_INNR = Instrument Type                     *
      *                 IN_ISCY = Instrument Currency                 *
      *                 IN_ISTI = Instrument Ind. OTC                 *
      *  206938 - Access to TRSETD with trans. number signed          *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    89         General-purpose indicator                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRRtvPos - retrieve position in Meridian message             *
      *  SRGetDecPl - get number of decimal places                    *
      *  SRGetSetAc - Get settlement account details                  *
      *  Repair   - Repair process                                    *         CPB010
      *  WrtTrace - Trace process                                     *         CPB010
      *  *PSSR    - Program exception error routine                   *
      *  *INZSR   - Program Initialization routine                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD API Customer Private Banking Details file
     FSDPBDSL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas FF Transaction Settlement Details
     FTRSET1    IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas FF Instrument Types Details
     FINTYP     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IN_)
 
      ** Midas FF Market Center Details.
     FMARKT     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MA_)
 
      ** Midas GL Accounts Master
     FACCNT     IF   E           K DISK    IGNORE(ACCNTAAF:ACCNTACF)
     F                                     PREFIX(A_)
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** Contains various standard declares
     D**********/COPY RPCPYSRC,Std_Dcl                                                     AR858264A
     D/COPY RPCPYSRC,STD_DCL                                                               AR858264A
 
      ** Contains the layout of the Meridian header as a data structure
     D**********/COPY RPCPYSRC,Mdn_Hd_DS                                                   AR858264A
     D/COPY RPCPYSRC,MDN_HD_DS                                                             AR858264A
 
      ** Declaration for fields passed to the formatting routines
     D/COPY RPCPYSRC,RPFMTDCL
 
      ** Procedure prototype for the Packed routine
     D/COPY RPCPYSRC,RPFMTPPP
 
      ** Procedure prototype for the Signed routine
     D/COPY RPCPYSRC,RPFMTPPS
 
      ** Procedure prototype for the Format routine that is used to
      ** process an entire record
     D/COPY RPCPYSRC,RPFMTPPF
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Arrays used to store Position and Length of each fields
     D WArFld          S              6    Dim(100)
     D WArPos          S              7  0 Dim(100)
     D WArLen          S              4  0 Dim(100)
 
      ** Arrays used to store Currency and Decimal Places
     D WArCcy          S              3    Dim(200)
     D WArDec          S              1  0 Dim(200)
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA
      ** External Data structure for Local data area (db error details)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    EXTNAME(RPDFTSDA) DTAARA
 
      ** API DUMP Information Data Area for database error reporting;
      ** based on external file
     D Apdump        E DS                  EXTNAME(APDUMP) DTAARA
 
      ** External Data structure for Run Date Informations.
     D Rundat        E DS                  Extname(RUNDAT) DTAARA
 
      ** Data structure used to group settlement account details.
     D*W_FullSettlAcc  DS            18                                                       CGL029
     D W_FullSettlAcc  DS            24                                                       CGL029
     D   W_Branch              1      3
     D   W_CustNo              4      9
     D   W_Currency           10     12
     D   W_AccCode            13     22                                                       CGL029
     D   W_AccSeq             23     24                                                       CGL029
     D***W_AccCode            13     16                                                       CGL029
     D***W_AccSeq             17     18                                                       CGL029
 
      ** First data structure for access programs, short data structure
     D Dsfdy         E DS                  Extname(DSFDY)
 
      ** Second data structure for access programs, long data structure
     D Dssdy         E DS                  Extname(DSSDY)
 
      ** Third Data Structure for access programs
     D Dsldy         E DS                  Extname(DSLDY)
 
      ** Data Structure for access to Customer Details.
      ** Also used to pass data to procedure ProcFormat.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      ** Data Structure for access to Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      ** Data Structure for access to Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      ** Structure based on the Transaction Settlement file used to
      ** pass data to procedure ProcFormat.
     D TrsetdDS      E DS                  Extname(TRSETD)
 
      ** Structure to receive a formatted Transaction settlement
      ** detail record from procedure ProcFormat.
      ** TrsetdPosA (and TrsetdPosN) contain the position of the first
      ** unused position in TrsetdRec. If the input data is blank at
      ** end this would be well after the last non-blank character.
     D TrsetdData      DS
     D  TrsetdRec                          Like(TransData)
     D  TrsetdPosA                    4
     D  TrsetdPosN                    4S 0 Overlay(TrsetdPosA)
 
      ** Rededine Instrument Type to retrieve OTC instrument
     D ISTT            DS
     D   W_InstMarket          1      2
     D   W_InstOTC             1      3
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of parameters --------------------**
      ** Output queue name.
     D OutQueue        S                   Like(MQSQueue)
      **--------------------- End of parameters ---------------------**
 
      **-------------- Start of parameters for RPC1305 --------------**
     D PScriptName     S             10A
     D PImageName      S             32A
     D PFldName        S             10A
     D PFldType        S              1A
     D PFldPos         S              7S 0
     D PFldLen         S              4S 0
     D PFldVal         S           9999A
      **--------------- End of parameters for RPC1305 ---------------**
      **---------------- start of Parameters for CPB010 --------------**        CPB010
     D MessageInd      S              1A                                        CPB010
                                                                                CPB010
     D RAMSGOLD        S                   LIKE(RAMSGTYPE)                      CPB010
                                                                                CPB010
      **   Database Error Messsage Text                                         CPB010
     D DBErrText       S            256A                                        CPB010
                                                                                CPB010
      **   Transaction Data of associated transaction                           CPB010
     D AssocData       S                   LIKE(TransData)                      CPB010
                                                                                CPB010
      **   Meridian header Layout of associated transaction                     CPB010
     D MdHdAssoc       S                   LIKE(MdnHeadDs)                      CPB010
                                                                                CPB010
      **   Image Type - Amend Before, Amend After or Insert                     CPB010
     D ImageType       S             20A                                        CPB010
      **----------------  End of Parameters for CPB010  --------------**        CPB010
 
      **------------ Start of parameters for ZAGetSetAc -------------**
      ** -------
      ** Outputs
      ** -------
     D*PZAccCde*       S              4S 0                                                    CGL029
     D PZAccCde        S             10S 0                                                    CGL029
     D PZAccSeq        S              2S 0
      ** MEMOS update required.
     D PZMEMOSInd      S              1A
      ** PRONO update required.
     D PZPRONOInd      S              1A
      ** ------------
      ** Input/output
      ** ------------
      ** Transaction branch.
     D PZBrch          S              3A
      ** Tansaction customer.
     D*PZCustNo*       S              6S 0                                                    CSD027
     D PZCustNo        S              6                                                       CSD027
      ** Settlement currency.
     D PZCcy           S              3A
      ** ------
      ** Inputs
      ** ------
      ** Settlement type.
     D PZSettleType    S              2S 0
      ** Settlement account.
     D*PZSettleAcc     S             12A                                                      CGL029
     D PZSettleAcc     S             18A                                                      CGL029
      **------------- End of parameters for ZAGETSETAC --------------**
 
      ** --------- Start of fields used by access programs ----------**
     D P_RtCd          S              7A
     D P_Optn          S              7A
     D P_Cust          S             10A
     D P_Kyst          S              7A
      ** Decimal Places.
     D P_CcyDec        S              1S 0
      ** ---------- End of fields used by access programs -----------**
 
      ** ---------- Start of fields used for FFDATE ----------**
      ** -------
      ** Outputs
      ** -------
      ** Return code.
     D P_Return        S             10A
      ** Workin Day
     D P_FFDAY         S              5P 0
      ** ------
      ** Inputs
      ** ------
      ** Date Formula
     D P_FFDATC        S              7A
      ** Month of Required Date
     D P_FFMTH         S              2P 0
      ** Year of required date
     D P_FFYR          S              2P 0
      ** Market Currency
     D P_FFCCY1        S              3A
      ** Market Location
     D P_FFLOC         S              3A
      ** Instrument Currency
     D P_FFCCY2        S              3A
      ** Other Currency
     D P_FFCCY3        S              3A
      ** ---------- End of fields used by access programs -----------**
 
      ** Used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      ** End Position.
     D WEndPos         S              7S 0
 
      ** Parameters for ProcFormat.
     D InData          S                   LIKE(TransData) INZ(*BLANKS)
     D InDBFile        S             10A   INZ(*BLANKS)
 
      ** Used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6                                                       CSD027
 
      ** Used as key to access Currency dtls w/ Instrument Ccy
     D K_Ccy           S              3A
 
      ** Used as key to access to Transaction Settlement dtls
     D K_Trans         S              6  0
 
      ** Used as key to access to Instument Type
     D K_Instrument    S              5A
 
      ** Used as key to access to Market Center
     D K_Market        S              2A
 
      ** Used to produce only one dump.
     D W_RunBefore     S              1A
 
      ** Used to retrieve number of contract from the msg
     D W_NbrContrat    S              5S 0
 
      ** Used to calculate Final and Settlement Date
     D W_MktLocCcy     S              3A
     D W_MktLocCode    S              3A
 
      ** Used to retrieve Market Center
     D W_Market        S              2A
 
      ** Used to retrieve Month Number from the message
     D W_Month         S              2S 0
 
      ** Used to retrieve Year Number from the message
     D W_Year          S              2S 0
 
      ** Used to retrieve RECI of the message
     D W_RECI          S              1A
                                                                                              206938
      **  Work Field used to retrive sign of numeric field                                    206938
     D W_Sign          S              1A                                                      206938
 
      ** Composite Data.
     D CompData        S                   LIKE(TransData)
 
      **----------------  Start of additional fields ----------------**
     D W_CcyNbdp       S              1A
     D W_FinalDate     S              7A
     D W_SettlDate     S              7A
     D*W_CustSettlAcc  S             18A                                                      CGL029
     D W_CustSettlAcc  S             24A                                                      CGL029
     D W_CustSettlPor  S              4A
      **-----------------  End of additional fields -----------------**
 
      ** Used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      ** Used for change message type
     D W_PosFin        S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *INZSR is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                         CPB010
 
      ** Enter the processing to read the additional files and produce
      ** a composite message here.
 
      ** Check image (Before or After) of the message
     C                   EVAL      W_PosFin    = %Scan('_B':RAMSGTYPE)
 
      ** Before Image Type
     C     W_PosFin      IFNE      0
     C                   Eval      ImageType = 'Amend Before'                   CPB010
     C                   Eval      AssocData = TransData                        CPB010
     C                   Eval      MdHdAssoc = MdnHeadDs                        CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   EVAL      X = 1
     C     'RECI  '      LOOKUP    WArFld(X)                              89
     C                   EVAL      W_RECI = %Subst(TransData:+
     C                             WArPos(X):WArLen(X))
      ** DO NOT CONTINUE PROCESS IF BEFORE IMAGE IS PROCESSED                               AR983495
     C                   RETURN                                                             AR983495
                                                                                CPB010
     C                   Else                                                   CPB010
     C                   If        ImageType <> 'Amend Before'                  CPB010
     C                   Eval      ImageType = 'Insert'                         CPB010
     C                   Eval      AssocData = *Blanks                          CPB010
     C                   Eval      MdHdAssoc = *Blanks                          CPB010
     C                   Else                                                   CPB010
     C                   Eval      ImageType = 'Amend After'                    CPB010
     C                   EndIf                                                  CPB010
     C                   ENDIF
 
      ** If RECI of the Before Image = '*', Update should be bypassed
     C                   EVAL      WBypass = 'Y'                                            AR983495
     C     W_RECI        IFNE      '*'
     C     W_PosFin      ANDEQ     0
     C                   EVAL      W_RECI = *BLANKS
 
      ** Extract customer number from TRANSD message data.
     C                   EVAL      X = 1
     C     'CUSC  '      LOOKUP    WArFld(X)                              89
     C**********         EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C**********                   WArPos(X)+W_PosDebut:WArLen(X))                          AR970292
     C                   EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C                             WArPos(X):WArLen(X))                                     AR970292
 
     C                   MOVE      *BLANKS       WBypass           1
     C                   IF        P_Cust = '000000    '
     C                             Or P_Cust = *BLANKS
     C                   EVAL      WBypass = 'Y'
     C                   ENDIF
 
     C                   IF        WBypass = *BLANKS
      ** Access Customer Details by using Access Object,
      ** to retrieve Private Banking Customer Indicator.
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust
     C                   PARM                    P_Kyst
     C     Sdcust        PARM      Sdcust        Dsldy
 
      ** If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        IFNE      *BLANKS
     C     BBCLST        ANDNE     'Y'                                          223644
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile     = 'SDCUSTPD'
     C                   EVAL      DBase      = 01
     C                   EVAL      DBkey      = P_Cust
     C                   OUT       LDA
     C                   EVAL      ReturnCode = P_Rtcd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
      ** If Customer is not a Private Banking customer, check
      ** Requested PB Customer flag in case it would have been
      ** set to 'Y'.
     C                   IF        BBPRBA      <> 'Y'
 
      ** Define key list to access to Customer PB Details file.
     C     K_SDPbds      KLIST
     C                   KFLD                    K_CustNum
     C                   MOVE      BBCUST        K_CustNum
 
      ** Access to Customer PB Details file.
     C     K_CustNum     CHAIN     SDPBDSL0                           89
 
      ** If Customer PB Details do not exist, handle database error.
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 02
     C                   EVAL      Dbkey  = BBCUST
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Only send the message if Customer is a Private
      ** Banking Customer or flagged as requested to become
      ** a Private Banking Customer.
     C                   IF            BBPRBA = 'Y'
     C                             And WBypass = *BLANKS
     C                             Or  PBREPB = 'Y'
     C                             And WBypass = *BLANKS
 
      **----------------- Start of Additionnal fields ---------------**
 
      ** Define key list to access to Transaction Settlement Details
     C     K_Trsetd      KLIST
     C                   KFLD                    K_Trans
 
      ** Extract Transaction number from TRANSD message data.
     C                   EVAL      X = 1
     C     'TNBR  '      LOOKUP    WArFld(X)                              89
     C                   EVAL      PFldVal = %Subst(TransData:+
     C                             WArPos(X)+W_PosDebut:WArLen(X))
     C                   MOVEL     PFldVal       K_Trans
 
      ** Extract Transaction number from TRANSD message data to                               206938
      ** retrieve sign                                                                        206938
     C                   Eval      X = 1                                                      206938
     C     'TNBR  '      Lookup    WArFld(X)                              89                  206938
     C                   Eval      W_Sign = %Subst(TransData:+                                206938
     C                             WArPos(X):1)                                               206938
                                                                                              206938
     C                   If        W_Sign = '-'                                               206938
     C                   Eval      K_Trans = - K_Trans                                        206938
     C                   EndIf                                                                206938
                                                                                              206938
      ** Access to Transaction Settlement Details file.
     C     K_Trsetd      CHAIN     TRSET1                             89
 
      ** If Transaction Details do not exist, handle database error.
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'TRSET1'
     C                   EVAL      Dbase  = 03
     C                   MOVEL     K_Trans       Dbkey
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
      ** Reformat entire TRSETD record (TRSETDF).
      ** The relevant member in file RPMSGFPD contains details of the
      ** fields in the file to be processed (it is a DSPFFD outfile).
      ** This file must already be set up with the field data for the
      ** file to be processed.
     C                   EVAL      CompData = *BLANKS
     C                   EVAL      Indata   = TrsetdDS
     C                   EVAL      InDBFile = 'TRSETD    '
     C                   EVAL      TrsetdData = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      ** The TrsetdData data structure has two sub-fields:
      **    - TrsetdRec which now contains the formatted data, left aligned.
      **    - TrsetdPosA/TrsetdPosN which now contains the position of
      **    the first unused byte in TrsetdRec.
 
      ** Extract Instrument Currency from TRANSD message data.
     C                   EVAL      X = 1
     C     'ISCY  '      LOOKUP    WArFld(X)                              89
     C                   EVAL      K_Ccy = %Subst(TransData:+
     C                             WArPos(X):WArLen(X))
 
      ** Retrieve currency (Instrument) decimal places
     C                   EXSR      SRGetDecPl
     C                   MOVE      P_CcyDec      W_CcyNbdp
 
      ** Retrieve Final Transaction Date and Settlement Date
     C                   MOVE      *BLANKS       W_FinalDate
     C                   MOVE      *BLANKS       W_SettlDate
 
      ** Extract Number of Open Contracts: Customer/Book from TRANSD
      ** message data
     C                   EVAL      X = 1
     C     'NOCO  '      LOOKUP    WArFld(X)                              89
     C                   EVAL      PFldVal = %Subst(TransData:+
     C                             WArPos(X)+W_PosDebut:WArLen(X))
     C                   MOVEL     PFldVal       W_NbrContrat
 
      ** Always access Instrument Type details.                                               220152
     C*****W_NbrContrat  IFNE      *zeros                                                     220152
 
      ** Define key list to access to Instrument Type Details file.
     C     K_Intypd      KLIST
     C                   KFLD                    K_Instrument
 
      ** Extract Instrument Type from TRANSD message data.
     C                   EVAL      X = 1
     C     'ISTT  '      LOOKUP    WArFld(X)                              89
     C                   EVAL      K_Instrument = %Subst(TransData:+
     C                             WArPos(X):WArLen(X))
 
      ** Access Instrument Types Details file.
     C     K_Intypd      CHAIN     INTYP                              89
 
      ** If Instrument Details do not exist, handle database error.
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'INTYP '
     C                   EVAL      Dbase  = 04
     C                   EVAL      Dbkey  = K_Instrument
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   EVAL      W_Market = *BLANKS
 
     C     IN_ISTI       IFNE      'Y'
     C                   EVAL      W_InstOTC = K_Instrument
     C                   EVAL      W_Market = W_InstMarket
     C     W_InstOTC     IFEQ      'OTC'
     C                   EVAL      W_Market = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** Reset Market Local Currency and Market Location Code work flds
     C                   EVAL      W_MktLocCcy  = *BLANKS
     C                   EVAL      W_MktLocCode = *BLANKS
 
     C     W_Market      IFNE      *BLANKS
 
      ** Define key list to access to Market Center Details file.
     C     K_Marktd      KLIST
     C                   KFLD                    K_Market
     C                   EVAL      K_Market = W_Market
 
      ** Access Instrument Types Details file.
     C     K_Marktd      CHAIN     MARKT                              89
 
      ** If Market Center Details do not exist, handle database error.
     C     *IN89         IFEQ      *ON
     C     *IN89         OREQ      *OFF
     C     MA_RECI       ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'MARKT '
     C                   EVAL      Dbase  = 05
     C                   EVAL      Dbkey  = K_Market
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   EVAL      W_MktLocCcy  = MA_MKLC
     C                   EVAL      W_MktLocCode = MA_MLOC
     C                   ENDIF
 
      ** Extract Month Number from TRANSD message data.
     C                   EVAL      X = 1
     C     'MTHN  '      LOOKUP    WArFld(X)                              89
     C                   EVAL      PFldVal = %Subst(TransData:+
     C                             WArPos(X)+W_PosDebut:WArLen(X))
     C                   MOVEL     PFldVal       W_Month
 
      ** Extract Year Number from TRANSD message data.
     C                   EVAL      X = 1
     C     'YRNO  '      LOOKUP    WArFld(X)                              89
     C                   EVAL      PFldVal = %Subst(TransData:+
     C                             WArPos(X)+W_PosDebut:WArLen(X))
     C                   MOVEL     PFldVal       W_Year
 
      ** If Settlement Date is entered
     C     IN_SETD       IFNE      *zeros
     C                   EVAL      fmLength = 5
     C                   EVAL      fmDecPos = 0
 
     C                   EVAL      fmPack3010 = IN_SETD
     C                   EVAL      fmAlpNum32  =
     C                                ProcPacked(fmPack3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_SettlDate = %subst(fmAlpNum32 : 1 : 7)
     C                   ELSE
      ** Calculate Settlement Date via FFDATE
     C                   EVAL      P_FFDAY = *zeros
     C                   EVAL      P_FFMTH = W_Month
     C                   EVAL      P_FFYR  = W_Year
 
     C                   CALLB     'FFDATE'
     C                   PARM      *BLANKS       P_Return
     C                   PARM                    P_FFDAY
     C                   PARM      IN_SEDF       P_FFDATC
     C                   PARM                    P_FFMTH
     C                   PARM                    P_FFYR
     C                   PARM      W_MktLocCcy   P_FFCCY1
     C                   PARM      W_MktLocCode  P_FFLOC
     C                   PARM      K_Ccy         P_FFCCY2
     C                   PARM      IN_OTHC       P_FFCCY3
     C                   PARM                    BJDFIN
 
      ** If Error on FFDATE procedure, handle database error.
     C     P_Return      IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'FFDATE'
     C                   EVAL      Dbase  = 06
     C                   EVAL      Dbkey  = '*CALL '
     C                   OUT       LDA
     C                   EVAL      ReturnCode = P_Return
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   EVAL      fmLength = 5
     C                   EVAL      fmDecPos = 0
 
     C                   EVAL      fmPack3010 = P_FFDAY
     C                   EVAL      fmAlpNum32  =
     C                                ProcPacked(fmPack3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_SettlDate = %subst(fmAlpNum32 : 1 : 7)
     C                   ENDIF
 
      ** If Final Transaction Date is entered
     C     IN_FTDT       IFNE      *zeros
     C                   EVAL      fmLength = 5
     C                   EVAL      fmDecPos = 0
 
     C                   EVAL      fmPack3010 = IN_FTDT
     C                   EVAL      fmAlpNum32  =
     C                                ProcPacked(fmPack3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_FinalDate = %subst(fmAlpNum32 : 1 : 7)
     C                   ELSE
      ** Calculate Settlement Date via FFDATE
     C                   EVAL      P_FFDAY = *zeros
     C                   EVAL      P_FFMTH = W_Month
     C                   EVAL      P_FFYR  = W_Year
 
     C                   CALLB     'FFDATE'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    P_FFDAY
     C                   PARM      IN_FTDF       P_FFDATC
     C                   PARM                    P_FFMTH
     C                   PARM                    P_FFYR
     C                   PARM      W_MktLocCcy   P_FFCCY1
     C                   PARM      W_MktLocCode  P_FFLOC
     C                   PARM      K_Ccy         P_FFCCY2
     C                   PARM      IN_OTHC       P_FFCCY3
     C                   PARM                    BJDFIN
 
      ** If Error on FFDATE procedure, handle database error.
     C     ReturnCode    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'FFDATE'
     C                   EVAL      Dbase  = 07
     C                   EVAL      Dbkey  = '*CALL '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   EVAL      fmLength = 5
     C                   EVAL      fmDecPos = 0
 
     C                   EVAL      fmPack3010 = P_FFDAY
     C                   EVAL      fmAlpNum32  =
     C                                ProcPacked(fmPack3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_FinalDate = %subst(fmAlpNum32 : 1 : 7)
 
     C                   ENDIF
 
     C**********         ENDIF                                                                220152
 
      **---------- Start of Charge Settlement Full Account ----------**
 
      ** Initialize Customer Settlement Full Account
     C                   EVAL      W_CustSettlAcc = *BLANKS
     C                   EVAL      W_CustSettlPor = *BLANKS
 
     C                   MOVEL     P_Cust        PZCustNo
     C                   EVAL      PZCcy = K_Ccy
     C                   EVAL      PZBrch = BRSC
     C                   EVAL      PZSettleType = CSLT
     C                   EVAL      PZSettleAcc = CSLA
 
      ** Get Settlement Details.
     C                   EXSR      SRGetSetAc
 
      ** Set up full account only if account details are available.
     C*****PZCustNo      IFNE      *zeros                                                     CSD027
     C     PZCustNo      IFNE      *blanks                                                    CSD027
     C                   EVAL      W_Branch      = PZBrch
     C                   MOVE      PZCustNo      W_CustNo
     C                   EVAL      W_Currency    = PZCcy
     C                   MOVE      PZAccCde      W_AccCode
     C                   MOVE      PZAccSeq      W_AccSeq
     C                   EVAL      W_CustSettlAcc = W_FullSettlAcc
 
      ** Define key list to access to Account Master Details file.
     C     K_Accnt       KLIST
     C                   KFLD                    KCustNo
     C                   KFLD                    KCcy
     C                   KFLD                    KAccCde
     C                   KFLD                    KAccSeq
     C                   KFLD                    KBrch
 
      ** Retrieve Account details (Portfolio Reference)
     C                   EVAL      KCustNo = PZCustNo
     C                   EVAL      KCcy    = PZCcy
     C                   EVAL      KAccCde = PZAccCde
     C                   EVAL      KAccSeq = PZAccSeq
     C                   EVAL      KBrch   = PZBrch
     C     K_Accnt       CHAIN     ACCNT                              89
      ** If Account does not exist, handle database error.
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'ACCNT'
     C                   EVAL      Dbase  = 08
     C                   EVAL      DbKey = W_FullSettlAcc
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   EVAL      W_CustSettlPor = A_PTFR
 
     C                   ENDIF
 
      **----------- End of Charge Settlement Full Account -----------**
 
      **------------------ End of Additionnal fields ----------------**
 
      ** Change message Type from _After to _A
      ** Determine Image Type.
     C                   EVAL      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      ** If it is impossible to determine the image type, handle error.
     C     W_PosFin      IFEQ      0
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'MSG Type'
     C                   EVAL      DBase  = 09
     C                   EVAL      DBkey  = RAMSGTYPE
     C                   OUT       LDA
     C                   EVAL      ReturnCode = 'Image_Type'
     C**********         EXSR      *PSSR                                                      CPB010
                                                                                              CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   ENDIF
 
     C                   EVAL      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
     C
 
      ** Place the result in field CompData.
     C                   EVAL      CompData = %subst(TransData:1:WEndPos)
     C                                       + %subst(TrsetdRec:1:+
     C                                                    TrsetdPosN-1)
     C                                       + W_CcyNbdp
     C                                       + W_FinalDate
     C                                       + W_SettlDate
     C                                       + W_CustSettlAcc
     C                                       + W_CustSettlPor
     C                                       + IN_INNR                          Inst Type     CPB008
     C                                       + IN_ISCY                          Inst Ccy      CPB008
     C                                       + IN_ISTI                          Inst IND OTC  CPB008
 
      ** Call a standard routine to actually send the message.
     C                   CallB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'RPSNDMSG'
     C                   EVAL      Dbase  = 10
     C                   EVAL      DbKey  = '*CALL   '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ELSE
      ** If no error, commit the unit of work so that messages that
      ** have been got from a queue would be permanently deleted
      ** and put operations would be made permanent.
                                                                                              CPB010
     C                   Exsr      WrtTrace                                                   CPB010
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetSetAc - Get settlement account details.                 *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     ZAGETSETAC, *PSSR                                 *
      *                                                               *
      *****************************************************************
     C     SRGetSetAc    BEGSR
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ZAGETSETAC'
      ** Outputs
      ** -------
      ** Return code (10A).
     C                   PARM                    ReturnCode
      ***Account*code*(4,0S).******************************************                       CGL029
      ** Account code (10,0S).                                                                CGL029
     C                   PARM                    PZAccCde
      ** Account sequence (2,0S).
     C                   PARM                    PZAccSeq
      ** MEMOS update required.
     C                   PARM                    PZMEMOSInd
      ** PRONO update required.
     C                   PARM                    PZPRONOInd
      ** Input/output
      ** ------------
      ** Transaction Branch (3A) (can also be returned).
     C                   PARM                    PZBrch
      ** Tansaction customer (6,0S) (can also be returned).
     C                   PARM                    PZCustNo
      ** Sttlement currency (3A) (can also be returned).
     C                   PARM                    PZCcy
      ** Inputs
      ** ------
      ** Settlement type (2,0S)
     C                   PARM                    PZSettleType
      ***Settlement*account*(12A)**************************************                       CGL029
      ** Settlement account (18A)                                                             CGL029
     C                   PARM                    PZSettleAcc
 
      ** Retrieve data area QTEMP/APDUMP to check if any error
      ** occurred while getting Settlement Details without
      ** return code being set up.
     C                   IN        Apdump
 
     C     ReturnCode    IFNE      *BLANKS
     C     ARErrMod      ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'ZAGETSETAC'
     C                   EVAL      DBase  = 11
     C                   EVAL      DBkey  = '*CALL     '
     C                   OUT       LDA
     C                   EVAL      ReturnCode = 'Error'
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetDecPl - Get number of decimal places.                   *
      *                                                               *
      *  Called by: Main processing.                                  *
      *                                                               *
      *  Calls:     *PSSR, AOCURRR0                                   *
      *                                                               *
      *****************************************************************
     C     SRGetDecPl    BEGSR
 
     C                   Z-ADD     1             X
 
     C                   EVAL      X = 1
     C     K_ccy         LOOKUP    WArCcy(X)                              89
 
     C                   IF        *IN89 = *ON
      ** Currency already exists in Currency Table
      ** Retrieve Decimal places of the currency
 
     C                   EVAL      P_CcyDec = WArDec(X)
     C                   ELSE
 
     C                   EVAL      Index = Index + 1
      ** If any error occurred, handle it.
     C                   IF        Index > 200
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 12
     C                   EVAL      DBkey  = 'Index  '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
      ** Access to Currency Details, by using access object.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    K_Ccy
     C     Sdcurr        PARM      Sdcurr        Dssdy
      ** If currency does not exist, handle database error.
     C     P_Rtcd        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SDCURRPD'
     C                   EVAL      Dbase  = 13
     C                   EVAL      Dbkey  = K_Ccy
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = P_RTCD
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
      ** Add Currency and Decimal Places in Currency Table
     C                   EVAL      WArCcy(Index) = A6CYCD
     C                   EVAL      WArDec(Index) = A6NBDP
     C                   EVAL      P_CcyDec = A6NBDP
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvPos - Retrieve position in Meridian message.            *
      *                                                               *
      *  Called by:  *INZSR                                           *
      *                                                               *
      *  Calls:      RPC1305, *PSSR                                   *
      *                                                               *
      *****************************************************************
     C     SRRtvPos      BEGSR
 
     C                   CALLB     'RPC1305'
     C                   PARM                    PScriptName
     C                   PARM      RAMSGTYPE     PImageName
     C                   PARM                    PFldName
     C                   PARM                    PFldType
     C                   PARM                    TransData
     C                   PARM      0             PFldPos
     C                   PARM      0             PFldLen
     C                   PARM      *BLANK        PFldVal
     C                   PARM      *BLANK        ReturnCode
 
      ** If any error occurred while retrieving position, handle it.
     C     ReturnCode    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'RPC1305 '
     C                   EVAL      DBase  = 14
     C                   EVAL      DBkey  = '*CALL  '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                                      CPB010
                                                                                              CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   ENDIF
 
     C                   EVAL      X = X + 1
      ** If any error occurred while retrieving position, handle it.
     C                   IF        X > 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 15
     C                   EVAL      DBkey  = 'Index  '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   EVAL      WArFld(X) = PFldName
     C                   EVAL      WArPos(X) = PFldPos
     C                   EVAL      WArLen(X) = PFldLen
 
     C                   ENDSR
      /Eject                                                                                  CPB010
      *****************************************************************                       CPB010
      *                                                               *                       CPB010
      *  WrtTrace - Write a Trace of outgoing messages.               *                       CPB010
      *                                                               *                       CPB010
      *  Called by : Main processing.                                 *                       CPB010
      *                                                               *                       CPB010
      *  Calls     : None.                                            *                       CPB010
      *                                                               *                       CPB010
      *****************************************************************                       CPB010
                                                                                              CPB010
     C     WrtTrace      Begsr                                                                CPB010
                                                                                              CPB010
     C                   Callb     'RP1590'                                                   CPB010
     C                   Parm                    OutQueue                                     CPB010
     C                   Parm                    MdnHeadDS                                    CPB010
     C                   Parm                    CompData                                     CPB010
     C                   Parm                    CommitCtl                                    CPB010
     C                   Parm                    ReturnCode                                   CPB010
                                                                                              CPB010
      **  If any error occurred while retrieving position, handle it.                         CPB010
     C     ReturnCode    Ifne      *blanks                                                    CPB010
     C     *Lock         In        Lda                                                        CPB010
     C                   Eval      DBpgm  = PSProcName                                        CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 08                                  * Db Error 08 CPB010
     C                   Eval      DBkey  = 'RP1590'                            **************CPB010
     C                   Out       Lda                                                        CPB010
                                                                                              CPB010
     C                   Endif                                                                CPB010
     C                   Endsr                                                                CPB010
                                                                                              CPB010
      /Eject                                                                                  CPB010
      *****************************************************************                       CPB010
      *                                                               *                       CPB010
      *  Repair   - Write a Trace of outgoing messages to repair      *                       CPB010
      *                                                               *                       CPB010
      *  Called by : Main processing.                                 *                       CPB010
      *                                                               *                       CPB010
      *  Calls     : None.                                            *                       CPB010
      *                                                               *                       CPB010
      *****************************************************************                       CPB010
                                                                                              CPB010
     C     Repair        Begsr                                                                CPB010
                                                                                              CPB010
     C                   Move      Dbase         dbasea            3                          CPB010
                                                                                              CPB010
     C                   Eval      DBErrText = 'DBError' +                                    CPB010
     C                             ' in : ' + DBpgm +                                         CPB010
     C                             ' at: ' + DBasea +                                         CPB010
     C                             ' file : ' + DBfile +                                      CPB010
     C                             ' Key : ' + DBKey +                                        CPB010
     C                             ' Return :' + ReturnCode                                   CPB010
                                                                                              CPB010
     C                   Eval      RAMSGTYPE = RAMSGOLD                                       CPB010
                                                                                              CPB010
     C                   Callb     'RP1592'                                                   CPB010
     C                   Parm                    OutQueue                                     CPB010
     C                   Parm                    MdnHeadDS                                    CPB010
     C                   Parm                    TransData                                    CPB010
     C                   Parm                    MdHdAssoc                                    CPB010
     C                   Parm                    AssocData                                    CPB010
     C                   Parm                    CommitCtl                                    CPB010
     C                   Parm                    DBErrText                                    CPB010
     C                   Parm                    MessageInd                                   CPB010
     C                   Parm      *Blanks       ReturnCode                                   CPB010
                                                                                              CPB010
      **  If any error occurred while retrieving position, handle it.                         CPB010
     C     ReturnCode    Ifne      *blanks                                                    CPB010
     C     *Lock         In        Lda                                                        CPB010
     C                   Eval      DBpgm  = PSProcName                                        CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 50                                  * Db Error 50 CPB010
     C                   Eval      DBkey  = 'RP1592'                            **************CPB010
     C                   Out       Lda                                                        CPB010
                                                                                              CPB010
     C                   exsr      *pssr                                                      CPB010
     C                   Else                                                                 CPB010
     C                   Return                                                               CPB010
     C                   Endif                                                                CPB010
                                                                                              CPB010
     C                   Endsr                                                                CPB010
                                                                                              CPB010
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     W_RunBefore   IFEQ      *BLANK
 
      ** If commitment control required, back out the unit of work so
      ** that current message could be available again.
     C                   IF        CommitCtl = 'Y'
     C                   ROLBK
     C                   ENDIF
 
     C                   MOVE      'Y'           W_RunBefore
     C                   DUMP
 
     C                   ENDIF
 
     C     ReturnCode    IFEQ      *BLANK
     C                   EVAL      ReturnCode = '*PSSR'
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     AOBANKR0, *PSSR, SRRtvPos                         *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      ** MQSeries queue to write to - this parm IS used in this module
     C                   PARM                    OutQueue
      ** Merdian header
     C                   PARM                    MdnHeadDS
      ** Transaction Data
     C                   PARM                    TransData
      ** Commitment control flag
     C                   PARM                    CommitCtl
      ** Return Code
     C                   PARM                    ReturnCode
 
     C                   Eval      MessageInd = 'Y'                                           CPB010
                                                                                              CPB010
      ** Define K_Accnt key fields used to access ACCNT
     C     *LIKE         DEFINE    A_CNUM        KCustNo
     C     *LIKE         DEFINE    A_CCY         KCcy
     C     *LIKE         DEFINE    A_ACOD        KAccCde
     C     *LIKE         DEFINE    A_ACSQ        KAccSeq
     C     *LIKE         DEFINE    A_BRCA        KBrch
 
     C                   EVAL      DBpgm      = PSProcName
 
      ** Access Bank details by using access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*FIRST'      P_optn
     C     Sdbank        PARM      Sdbank        DsFdy
     C     P_Rtcd        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile     = 'SDBANKPD'
     C                   EVAL      DBase      = 16
     C                   EVAL      DBkey      = '*FIRST'
     C                   OUT       LDA
     C                   EVAL      ReturnCode = P_Rtcd
     C****               EZSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
      ** Set up work fields for formatting that will not change if
      ** Replication formatting is required.
      **    - signs are not shown for Positive numbers.
      **    - get decimal separator from Replication data area RPDFTSDA
     C                   IN        RPDftsDa
     C                   EVAL      fmDecSep   = RCDECSEP
     C                   EVAL      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   MOVE      fmDpLen       W_PosDebut
     C                   EVAL      fmShwPsSgn = 'N'
 
      ** Set up work fields that will not change if retrieve
      ** function is to be used.
     C                   EVAL      PScriptName = 'RP' + RATGTSYS
 
     C                   Z-ADD     0             X                 3 0
     C                   Z-ADD     0             Index             3 0
 
      ** Retrieve position and length of RECI from TRANSD message data
     C                   EVAL      PFldName   = 'RECI'
     C                   EVAL      PFldType   = 'A'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of customer number from TRANSD
      ** message data
     C                   EVAL      PFldName   = 'CUSC'
     C**********         EVAL      PFldType   = 'N'                                         AR970292
     C                   EVAL      PFldType   = 'A'                                         AR970292
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of Transaction Number from TRANSD
      ** message data
     C                   EVAL      PFldName   = 'TNBR'
     C                   EVAL      PFldType   = 'N'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of Instrument currency from
      ** TRANSD message data
     C                   EVAL      PFldName   = 'ISCY'
     C                   EVAL      PFldType   = 'A'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of Number of Contrats from TRANSD
      ** message data
     C                   EVAL      PFldName   = 'NOCO'
     C                   EVAL      PFldType   = 'N'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of Instrument Type from TRANSD
      ** message data
     C                   EVAL      PFldName   = 'ISTT'
     C                   EVAL      PFldType   = 'A'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position & length of Month Number from TRANSD msg dta
     C                   EVAL      PFldName   = 'MTHN'
     C                   EVAL      PFldType   = 'N'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position & length of Year Number from TRANSD msg data
     C                   EVAL      PFldName   = 'YRNO'
     C                   EVAL      PFldType   = 'N'
     C                   EXSR      SRRtvPos
 
      ** Retrieve begin position of additionnal fields in Meridian msg
     C                   EVAL      PFldName   = '*END_IMAGE'
     C                   EVAL      PFldType   = *BLANK
     C                   EXSR      SRRtvPos
     C                   EVAL      WEndPos = PFldPos - 1
 
     C                   ENDSR
      *****************************************************************
