     H***DEBUG                                                                  192099
     H DEBUG FIXNBR(*INPUTPACKED)                                               192099
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Extraction Module for DEALSDC.')              *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1509 - Extract module for DEALSDC                          *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Currency Number of Decimal Places.          *
      *                 - Receipt Settlement Account.                 *
      *                 - Receipt Settlement Account's Portfolio Ref. *
      *                 - Payment Settlement Account.                 *
      *                 - Payment Settlement Account's Portfolio Ref. *
      *                 - Front Office Id.                            *
      *                 - Witholding Tax                              *
      *                 - Event Amount                                *
      *                                                               *
      *  Component of: RP1509 - Extract program for DEALSDC           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR858264           Date 13Jul12               *
      *                 242820             Date 05Jun12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 215312             Date 10Apr03               *
      *                 CPB010             Date 16Jan03               *
      *                 CPB008             Date 15Oct02               *
      *                 205941             Date 21Oct02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 195935             Date 24Oct01               *
      *                 195331             Date 24Oct01               *
      *                 193433             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 192099             Date 04May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR858264 - Compilation Issues on RP1509 and RP1520           *
      *  242820 - Wrong interest amount sent to TOF for rolled over   *
      *           deal with intermediary interest payment             *
      *           Applied for AR983495 (Child: AR983496)              *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  215312 - Fix to send correct interest amount for TD          *
      *           rollovers.                                          *
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
      *           - Add fields :                                      *
      *              * Base Rate Code                                 *
      *              * Base Rate Value Date                           *
      *              * Associated Linked Deal                         *
      *           to output message to avoid ODBC Client Access       *
      *  205941 - Consider deal type 'IT' and 'IP'.                   *
      *           Consider Rollover generated by the system.          *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
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
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  195935 - do not use field HKMATD, as it may be not filled.   *
      *  195331 - field HKTYPE used while HKMTYP should be used.      *
      *  193433 - design changes Posting of Interest one separate     *
      *           account                                             *
      *  192099 - Avoid Decimal Data Error                            *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Midas SD API Customer Private Banking Details file.
     FSDPBDSL0  IF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  Midas MM Deals File
     FMMDEALLL  IF   E           K Disk    IGNORE(MMDENSP0:MMDENBP0)
     F                                     Infsr(*Pssr)
 
      **  Midas DL Dealing History File -  detail.
     FHIST4     IF   E           K Disk    Prefix(H_)
     F                                     Infsr(*Pssr)
 
      **  Midas GL Accounts Master
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
     F                                     Infsr(*Pssr)
      **  Midas SD Base Rate Codes                                                            CPB008
     FSDBSRTL0  IF   E           K Disk                              Prefix(B_)               CPB008
     F                                     Infsr(*Pssr)
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  CHAIN access to SDPBDSL0/ACCNT failed.                *
      *  82  -  CHAIN access to MMDEALLL failed.                      *
      *  84  -  CHAIN access to SDBSRTL0 failed.                      *                       CPB008
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  RtvPos   - retrieve position in Meridian message.            *
      *  Repair   - Repair process                                    *                       CPB010
      *  WrtTrace - Trace process                                     *                       CPB010
      *  GetSetAc - Get settlement account details.                   *
      *  *Pssr    - Program exception error routine                   *
      *  *Inzsr   - Program Initialization routine.                   *
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
 
      ** The following /COPY contains various standard declares
     C**********/COPY RPCPYSRC,Std_Dcl                                                      AR858264
     C/COPY RPCPYSRC,STD_DCL                                                                AR858264
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C**********/COPY RPCPYSRC,Mdn_Hd_DS                                                    AR858264
     C/COPY RPCPYSRC,MDN_HD_DS                                                              AR858264
 
      ** Following /COPY is the declares for fields passed to the formatting
      **  routines
     C/COPY RPCPYSRC,RPFMTDCL
 
      ** Following /COPY is the procedure prototype for the Packed routine
     C/COPY RPCPYSRC,RPFMTPPP
 
      ** Following /COPY is the procedure prototype for the Signed routine
     C/COPY RPCPYSRC,RPFMTPPS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
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
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D Lda           E DS           256    Extname(LDA) Dtaara
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  Arrays used to store Position and Length of each fields
     D ArrFld          S              6    Dim(100)
     D ArrPos          S              7  0 Dim(100)
     D ArrLen          S              4  0 Dim(100)
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
 
      ** API DUMP Information Data Area for database error reporting;
      ** based on external file
     D Apdump        E DS                  Extname(APDUMP) Dtaara
 
      **  External Data structure for Run Date Informations.
     D Rundat        E DS                  Extname(RUNDAT) Dtaara
 
      **  Data structure used to group settlement account details.
     D*W_FullSettlAcc  DS            18                                                       CGL029
     D W_FullSettlAcc  DS            24                                                       CGL029
     D   W_Branch              1      3
     D   W_CustNo              4      9
     D   W_Currency           10     12
     D   W_AccCode            13     22                                                       CGL029
     D   W_AccSeq             23     24                                                       CGL029
     D***W_AccCode            13     16                                                       CGL029
     D***W_AccSeq             17     18                                                       CGL029
 
      **  Data Structure for access to Feature Details.
     D Scsard        E DS                  Extname(SCSARDPD)
 
      **  Data Structure for access to Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      **  Data Structure for access to Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      **  Data Structure for access to Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  Work Field used for EMU feature CEU003.
     D CEU003          S              1A
 
      **-------------------- Start of parameters --------------------**
 
      **  Output queue name.
     D OutQueue        S                   Like(MQSQueue)
 
      **--------------------- End of parameters ---------------------**
 
      **-------------- Start of parameters for RPC1305 --------------**
 
      **  Script Name.
     D ScriptName      S             10A
      **  Image Name.
     D ImageName       S             32A
      **  Field Name.
     D FieldName       S             10A
      **  Field Type.
     D FieldType       S              1A
      **  Field Value.
     D FieldValue      S           9999A
      **  Field Position.
     D FieldPosition   S              7S 0
      **  Field Length
     D FieldLength     S              4S 0
 
      **--------------- End of parameters for RPC1305 ---------------**
      **---------------- start of Parameters for CPB010 --------------**                      CPB010
     D MessageInd      S              1A                                                      CPB010
                                                                                              CPB010
     D RAMSGOLD        S                   LIKE(RAMSGTYPE)                                    CPB010
                                                                                              CPB010
      **   Database Error Messsage Text                                                       CPB010
     D DBErrText       S            256A                                                      CPB010
                                                                                              CPB010
      **   Transaction Data of associated transaction                                         CPB010
     D AssocData       S                   LIKE(TransData)                                    CPB010
                                                                                              CPB010
      **   Meridian header Layout of associated transaction                                   CPB010
     D MdHdAssoc       S                   LIKE(MdnHeadDs)                                    CPB010
      **----------------  End of Parameters for CPB010  --------------**                      CPB010
 
      **------------ Start of parameters for ZAGETSETAC -------------**
      **  -------
      **  Outputs
      **  -------
      **  Account code.
     D*AccCode**       S              4S 0                                                    CGL029
     D AccCode         S             10S 0                                                    CGL029
      **  Account sequence.
     D AccSeq          S              2S 0
      **  MEMOS update required.
     D MemosInd        S              1A
      **  PRONO update required.
     D PronoInd        S              1A
      **  ------------
      **  Input/output
      **  ------------
      **  Transaction branch.
     D Branch          S              3A
      **  Tansaction customer.
     D*CustNo***       S              6S 0                                                    CSD027
     D CustNo          S              6                                                       CSD027
      **  ------
      **  Inputs
      **  ------
      **  Settlement type.
     D SettleType      S              2S 0
      **  Settlement account.
     D*SettleAcc       S             12A                                                      CGL029
     D SettleAcc       S             18A                                                      CGL029
 
      **------------- End of parameters for ZAGETSETAC --------------**
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
      **  Key status.
     D P_Kyst          S              7A
      **  Switchable feature number.
     D P_Sard          S              6A
      ** ---------- End of fields used by access programs -----------**
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
     D W_SettCcy       S              3A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6                                                       CSD027
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Composite Data.
     D CompData        S                   LIKE(TransData)
 
      **----------------  Start of additional fields ----------------**
     D W_CcyNbdp       S              1A
     D*W_RecSettlAcc   S             18A                                                      CGL029
     D W_RecSettlAcc   S             24A                                                      CGL029
     D W_RecSettlPor   S              4A
     D*W_PaySettlAcc   S             18A                                                      CGL029
     D W_PaySettlAcc   S             24A                                                      CGL029
     D W_PaySettlPor   S              4A
     D*W_IntSettlAcc   S             18A                                               193433 CGL029
     D W_IntSettlAcc   S             24A                                                      CGL029
     D W_IntSettlPor   S              4A                                        193433
     D W_FrontOffId    S             20A
     D W_WitholdingT   S             17A
     D W_EAMT          S             17A
      **  Field to replace function GetMIDASMMDealUser                                        CPB008
     D W_Hkluid        S              3A                                                      CPB008
     D W_Hkdusc        S              3A                                                      CPB008
      **  Field to replace function GetMIDASRateValueDate                                     CPB008
     D W_BaseValue     S              5A                                                      CPB008
      **  Data structure used to Base Rate .                                                  CPB008
     DBaserateKey      DS             5                                                       CPB008
     D   P_Curr                1      3                                                       CPB008
     D   W_BaseCode            4      5                                                       CPB008
      **  Field to replace function GetMIDASCustomerDetails                                   CPB008
     D W_ShortName     S             10A                                                      CPB008
      **-----------------  End of additional fields -----------------**
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      **  Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     C     Start         Tag
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
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
                                                                                              CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                                       CPB010
 
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **  Extract custoner number from DEALSDC message data.
     C                   Z-add     1             X
     C     'CNUM  '      Lookup    Arrfld(X)                              89
     C**********         Eval      P_Cust = %Subst(TransData:+                              AR970292
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                          AR970292
     C                   EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
     C                   Callb     'AOCUSTR1'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm                    P_Cust
     C                   Parm                    P_Kyst
     C     Sdcust        Parm      Sdcust        Dsldy
 
      **  If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     BBCLST        ANDNE     'Y'                                                        223644
     C     *LOCK         IN        LDA
     C                   Eval      DBpgm      = PSProcName
     C                   Eval      DBfile     = 'SDCUSTPD'                      ***************
     C                   Eval      DBase      = 01                              * Db Error 01 *
     C                   Eval      DBkey      = P_Cust                          ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = P_Rtcd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End P_Rtcd
 
      **  If Customer is not a Private Banking customer, check
      **  Requested PB Customer flag in case it would have been
      **  set to 'Y'.
     C                   If        BBPRBA      <> 'Y'                           Begin BBPRBA
 
      **  Define key list to access to Customer PB Details file.
     C     K_SDPbds      Klist
     C                   Kfld                    K_CustNum
     C                   Move      BBCUST        K_CustNum
 
      **  Access to Customer PB Details file.
     C     K_CustNum     Chain     SDPBDSL0                           81
 
      **  If Customer PB Details do not exist, handle database error.
     C     *in81         Ifeq      True                                         Begin *in81
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDPBDSL0'                          ***************
     C                   Eval      Dbase  = 02                                  * Db Error 02 *
     C                   Eval      Dbkey  = BBCUST                              ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End  *in81
 
     C                   Endif                                                  End  BBPRBA
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer.
     C                   If            BBPRBA = 'Y'                             Begin BBPRBA
     C                             Or  PBREPB = 'Y'
 
      **----------------- Start of Additionnal fields ---------------**
 
      **--------- Start of Currency Number of Decimal Places --------**
 
      **  Extract Currency Code.
     C                   Z-add     1             X
     C     'CCY   '      Lookup    Arrfld(X)                              89
     C                   Eval      P_Curr = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                   Move      P_Curr        W_Currency                                   CPB008
 
      **  Retrieve first (purchase) currency number of decimal places.
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_CcyNbdp
 
      **---------- End of Currency Number of Decimal Places ---------**
 
      **--------- Start of Receipt Settlement Full Account ----------**
 
      **  Initialize Receipt Settlement Full Account
     C                   Eval      W_RecSettlAcc = *blanks
     C                   Eval      W_RecSettlPor = *blanks
 
      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo
 
      **--------- Start of  Get Base Code  ----------**                                       CPB008
     ***  Extract Base rate Code                                                              CPB008
     C                   Z-add     1             X                                            CPB008
     C     'BRTT  '      Lookup    Arrfld(X)                              89                  CPB008
     C                   Eval      W_BaseCode = %Subst(TransData:+                            CPB008
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))                            CPB008
                                                                                              CPB008
     C                   Movel     *Zeros        W_BaseValue                                  CPB008
     C*****W_BaseCode    Ifne      '00'                                                CPB008 CSD103
     C     W_BaseCode    Ifne      *BLANKS                                                    CSD103
      **--------- Start of  Get Base rate Value Date --                                       CPB008
                                                                                              CPB008
     C     K_SDBSRTPD    Klist                                                                CPB008
     C                   Kfld                    P_Curr                                       CPB008
     C                   Kfld                    W_BaseCode                                   CPB008
                                                                                              CPB008
      **  Retrieve Base rate Value date                                                       CPB008
     C     K_SDBSRTPD    Chain     SDBSRTL0                           84                      CPB008
                                                                                              CPB008
      **  If Base Rate   not exist, handle database error.                                    CPB008
     C     *IN84         Ifeq      True                                         Begin *in84   CPB008
     C     *lock         In        Lda                                                        CPB008
     C                   Eval      Dbpgm  = PSProcName                                        CPB008
     C                   Eval      Dbfile = 'SDBSRTL0'                          **************CPB008
     C                   Eval      Dbase  = 12                                  * Db Error 12*CPB008
     C                   Eval      DbKey = BaserateKey                          **************CPB008
     C                   Out       LDA                                                        CPB008
     C                   Eval      ReturnCode  = W_NoRcdFnd                                   CPB008
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in84    CPB008
                                                                                              CPB008
      **  Setup base rate Value Date                                                          CPB008
                                                                                              CPB008
     C                   Movel     B_BAVDRC      W_BaseValue                                  CPB008
     C                   Endif                                                  End  *in84    CPB008
                                                                                              CPB008
      **--------- End   of  Get Base Code  ----------**                                       CPB008
      **  Extract Transaction Currency Code.
     C                   Z-add     1             X
     C     'CCY   '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Settlement Currency Code.
     C                   Z-add     1             X
     C     'STCY  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_SettCcy = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  If feature CEU003 (EMU Dealing Settlement Currency Conversion)
      **  and Settlement Currency is filled, settlement will take
      **  place in Settlement Currency.
     C     CEU003        Ifeq      'Y'                                          Begin CEU003
     C     W_SettCcy     Andne     *blanks
     C                   Eval      W_Currency = W_SettCcy
     C                   Endif                                                  End CEU003
 
      **  Extract Branch Code.
     C                   Z-add     1             X
     C     'ROBR  '      Lookup    Arrfld(X)                              89
     C                   Eval      Branch = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Settlement Method.
     C                   Z-add     1             X
     C     'RSTM  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   Movel     FieldValue    SettleType
 
      **  Extract Settlement Account.
     C                   Z-add     1             X
     C     'RONS  '      Lookup    Arrfld(X)                              89
     C                   Eval      SettleAcc = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Get Settlement Details.
     C                   Exsr      GetSetAc
 
      **  Set up full account only if account details are available.
     C*****CustNo        Ifne      *zeros                                       Begin CustNo  CSD027
     C     CustNo        Ifne      *blanks                                      Begin CustNo  CSD027
     C                   Eval      W_Branch      = Branch
     C                   Move      CustNo        W_CustNo
     C                   Move      AccCode       W_AccCode
     C                   Move      AccSeq        W_AccSeq
     C                   Eval      W_RecSettlAcc = W_FullSettlAcc
 
      **  Define key list to access to Account Master Details file.
     C     K_Accnt       Klist
     C                   Kfld                    CustNo
     C                   Kfld                    W_Currency
     C                   Kfld                    AccCode
     C                   Kfld                    AccSeq
     C                   Kfld                    Branch
 
      **  Retrieve Account details (Portfolio Reference)
     C     K_Accnt       Chain     ACCNT                              81
 
      **  If Account does not exist, handle database error.
     C     *in81         Ifeq      True                                         Begin *in81
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'ACCNT'                             ***************
     C                   Eval      Dbase  = 03                                  * Db Error 03 *
     C                   Eval      DbKey = W_FullSettlAcc                       ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in81
 
     C                   Eval      W_RecSettlPor = A_PTFR
 
     C                   Endif                                                  End CustNo
 
      **---------- End of Receipt Settlement Full Account ------------**
 
      **--------- Start of Payment Settlement Full Account  ----------**
 
      **  Initialize Receipt Settlement Full Account
     C                   Eval      W_PaySettlAcc = *blanks
     C                   Eval      W_PaySettlPor = *blanks
 
      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo
 
      **  Extract Branch Code.
     C                   Z-add     1             X
     C     'POBR  '      Lookup    Arrfld(X)                              89
     C                   Eval      Branch = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Settlement Method.
     C                   Z-add     1             X
     C     'PSTM  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   Movel     FieldValue    SettleType
 
      **  Extract Settlement Account.
     C                   Z-add     1             X
     C     'PONS  '      Lookup    Arrfld(X)                              89
     C                   Eval      SettleAcc = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Get Settlement Details.
     C                   Exsr      GetSetAc
 
      **  Set up full account only if account details are available.
     C*****CustNo        Ifne      *zeros                                       Begin CustNo  CSD027
     C     CustNo        Ifne      *blanks                                      Begin CustNo  CSD027
     C                   Eval      W_Branch      = W_Branch
     C                   Move      CustNo        W_CustNo
     C                   Move      AccCode       W_AccCode
     C                   Move      AccSeq        W_AccSeq
     C                   Eval      W_PaySettlAcc = W_FullSettlAcc
 
      **  Retrieve Account details (Portfolio Reference)
     C     K_Accnt       Chain     ACCNT                              81
 
      **  If Account does not exist, handle database error.
     C     *in81         Ifeq      True                                         Begin *in81
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'ACCNT'                             ***************
     C                   Eval      Dbase  = 04                                  * Db Error 04 *
     C                   Eval      DbKey = W_FullSettlAcc                       ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in81
 
     C                   Eval      W_PaySettlPor = A_PTFR
 
     C                   Endif                                                  End CustNo
 
      **--------- End of Payment Settlement Full Account -----------**
 
      **--------- Start of Interest Settlement Full Account  ----------**       193433
                                                                                193433
      **  Initialize Interest Settlement Full Account                           193433
     C                   Eval      W_IntSettlAcc = *blanks                      193433
     C                   Eval      W_IntSettlPor = *blanks                      193433
                                                                                193433
      **  Extract Customer Number.                                              193433
     C                   Movel     P_Cust        CustNo                         193433
                                                                                193433
      **  Extract Settlement Method.                                            193433
     C                   Z-add     1             X                              193433
     C     'IMET  '      Lookup    Arrfld(X)                              89    193433
     C                   Eval      FieldValue = %Subst(TransData:+              193433
     C                             ArrPos(X):ArrLen(X))                         193433
     C                   Movel     FieldValue    SettleType                     193433
                                                                                193433
      **  Extract Settlement Account.                                           193433
     C                   Z-add     1             X                              193433
     C     'INSA  '      Lookup    Arrfld(X)                              89    193433
     C                   Eval      W_IntSettlAcc = %Subst(TransData:+           193433
     C                             ArrPos(X):ArrLen(X))                         193433
     C                   Eval      SettleAcc = W_IntSettlAcc                    193433
                                                                                193433
      **  Extract Branch Code.                                                  193433
     C**********         Eval      Branch = %Subst(W_IntSettlAcc:13:3)                 193433 CGL029
     C                   Eval      Branch = %Subst(W_IntSettlAcc:19:3)                        CGL029
     C                   Eval      W_IntSettlAcc = *blanks                      193433
                                                                                193433
      **  Get Settlement Details.                                               193433
     C                   Exsr      GetSetAc                                     193433
                                                                                193433
      **  Set up full account only if account details are available.            193433
     C*****CustNo        Ifne      *zeros                                 193433 Begin CustNo CSD027
     C     CustNo        Ifne      *blanks                                      193433 Begin  CSD027
     C                   Eval      W_Branch      = W_Branch                     193433
     C                   Move      CustNo        W_CustNo                       193433
     C                   Move      AccCode       W_AccCode                      193433
     C                   Move      AccSeq        W_AccSeq                       193433
     C                   Eval      W_IntSettlAcc = W_FullSettlAcc               193433
                                                                                193433
      **  Retrieve Account details (Portfolio Reference)                        193433
     C     K_Accnt       Chain     ACCNT                              81        193433
                                                                                193433
      **  If Account does not exist, handle database error.                     193433
     C     *in81         Ifeq      True                                         193433 Begin *in81
     C     *lock         In        Lda                                          193433
     C                   Eval      Dbpgm  = PSProcName                          193433
     C                   Eval      Dbfile = 'ACCNT'                             193433**************
     C**********         Eval      Dbase  = 04                                  * Db E 193433 CPB010
     C                   Eval      Dbase  = 13                                  * Db Error 13 CPB010
     C                   Eval      DbKey = W_FullSettlAcc                       193433**************
     C                   Out       LDA                                          193433
     C                   Eval      ReturnCode  = W_NoRcdFnd                     193433
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  193433 End *n81
                                                                                193433
     C                   Eval      W_IntSettlPor = A_PTFR                       193433
                                                                                193433
     C                   Endif                                                  193433   End CustNo
                                                                                193433
      **--------- End of Interest Settlement Full Account -----------**         193433
      **--------- Start of Front Office Id --------------------------**
 
      **  Extract Deal Number
     C                   Z-add     1             X
     C     'DLNO  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   Movel     FieldValue    P_Deal
 
     C     K_Deal        Klist
     C                   Kfld                    P_Deal            6 0
 
      **  Retrieve Front Office Id of the Deal
      **  and retrieve User codes for additional field                                        CPB008
     C     K_Deal        Chain     MMDEALLL                           82
 
      **  If Deal do not exist, handle database error.
     C     *in82         Ifeq      True                                         Begin *in82
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'MMDELDPP'                          ***************
     C                   Eval      Dbase  = 05                                  * Db Error 05 *
     C                   Movel     P_Deal        Dbkey                          ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in82
 
     C                   Eval      W_FrontOffId = HKFRNT
     C                   Eval      W_Hkluid     = HKLUID                                      CPB008
     C                   Eval      W_Hkdusc     = HKDUSC                                      CPB008
 
      **---------- End of Front Office Id ---------------------------**
 
 
      **  Access Bank details by using access program.
     C                   Callb     'AOBANKR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_optn
     C     Sdbank        Parm      Sdbank        Dssdy
 
     C                   Z-add     0             W_Withold        15 0
     C/COPY WNCPYSRC,RP1509C001
 
     C                   EVAL      fmSign3010 = W_Withold
     C                   EVAL      fmLength = 15
     C                   EVAL      fmDecPos = 0
     C                   EVAL      fmAlpNum32 =
     C                                ProcSigned(fmSign3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_WitholdingT  = %subst(fmAlpNum32 : 1 : 17)
 
      **  WithHolding Tax details
 
      **------------------ Start of Additionnal fields from HISTSAA ---**
                                                                                195935
      **  Extract Maturity Date.                                                195935
     C                   Z-add     1             X                              195935
     C     'MDAT  '      Lookup    Arrfld(X)                              89    195935
     C                   Eval      FieldValue = %Subst(TransData:+              195935
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))              195935
     C                   Movel     FieldValue    K_MATD                         195935
 
      **  If deal type is 'TD' or 'CD ' or 'CI' ot 'TI' and maturity date
      **  event, check retrieve in HISTSAA file the event amount
     C**********         If            (HKTYPE='TD' or HKTYPE='CD')             195331
     C**********                   and  HKMATD <= AGRDNB                        195935
     C**********                   or  (HKTYPE='CI' or HKTYPE='TI')             195331
     C**********                   and  HKMATD <= AGRDNB                        195935
     C                   If            (HKMTYP='TD' or HKMTYP='CD')             195331
     C                             and  K_MATD <= AGRDNB                        195935
     C                             or  (HKMTYP='CI' or HKMTYP='TI')             195331
     C                             and  K_MATD <= AGRDNB                        195935
     C                             or  (HKMTYP='IT' or HKMTYP='IP')                           205941
     C                             and  K_MATD <= AGRDNB                                      205941
 
      **  Define key list to access to DL History by Customer/Deal/Event Dt
     C     K_HISTSAA     Klist
     C                   Kfld                    HKCNUM
     C                   Kfld                    HKDN38
     C**********         Kfld                    HKMATD                         195935
     C                   Kfld                    K_MATD            5 0          195935
 
      **  Access to History details file to retrieve event amount
     C     K_HISTSAA     Setll     HIST4
     C     K_HISTSAA     Reade     HIST4                                  83
 
      **  Do while IP record not found or key unmatched.
     C     *in83         Doweq     False
     C     H_RTYP        Andne     'IP'
     C     H_RTYP        Andne     'RO'                                                       205941
 
     C     K_HISTSAA     Reade     HIST4                                  83
 
     C                   Enddo
                                                                                              215312
     C     *in83         Ifeq      False                                                      215312
     C     H_RTYP        Andeq     'RO'                                                       215312
 
     C                   Z-add     1             X                                            215312
     C     'IPRD  '      Lookup    Arrfld(X)                              89                  215312
     C                   Eval      FieldValue = %Subst(TransData:+                            215312
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))                            215312
     C                   Movel     FieldValue    WIPRD            13 0                        215312
     C*                                                                                       242820
     C* Check for intermediary interest payments on HISTSAA                                   242820
     C     K_HISTSA2     Klist                                                                242820
     C                   Kfld                    HKCNUM                                       242820
     C                   Kfld                    HKDN38                                       242820
     C     K_HISTSA2     SETLL     HIST4                                                      242820
     C                   READ      HIST4                                  83                  242820
     C     *IN83         DOWEQ     '0'                                                        242820
     C     HKDN38        ANDEQ     H_DLNO                                                     242820
     C     H_RTYP        IFEQ      'IP'                                                       242820
     C     H_EDAT        ANDNE     K_MATD                                                     242820
     C     WIPRD         SUB       H_EAMT        WIPRD                    83                  242820
     C                   ENDIF                                                                242820
     C                   READ      HIST4                                  83                  242820
     C                   ENDDO                                                                242820
     C*                                                                                       242820
     C                   Eval      H_EAMT     =  WIPRD                                        215312
     C                                                                                        215312
     C                   Endif                                                                215312
 
     C                   Else
 
      ** Not maturity of deal type 'TD', 'CD', 'CI' or 'TI'
      ** Force *IN83 to True to reset event amount
     C                   Eval      *IN83       = True
     C                   Endif
 
      **  If record not found, reset to 0 event amount.
     C     *in83         Ifeq      True
     C                   Eval      H_EAMT      = 0
     C                   Endif
 
      **  Set up event amount in message.
     C                   EVAL      fmLength = 15
     C                   EVAL      fmDecPos = 0
     C                   EVAL      fmSign3010 = H_EAMT
     C                   EVAL      fmAlpNum32 =
     C                                ProcSigned(fmSign3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_EAMT    = %subst(fmAlpNum32 : 1 : 17)
 
      **------------------ Start of access associated Linked deal----**                       CPB008
     C                   Movel     *Blanks       W_ShortName                                  CPB008
     C     HKLNKN        Ifne      0                                                          CPB008
                                                                                              CPB008
      **  and retrieve User codes for additional field                                        CPB008
     C     HKLNKN        Chain     MMDEALLL                           82                      CPB008
                                                                                              CPB008
      **  If Deal do not exist, handle database error.                                        CPB008
     C     *in82         Ifeq      True                                                       CPB008
     C     *lock         In        Lda                                                        CPB008
     C                   Eval      Dbpgm  = PSProcName                                        CPB008
     C                   Eval      Dbfile = 'MMDELDPP'                          **************CPB008
     C                   Eval      Dbase  = 15                                  * Db Error 15*CPB008
     C                   Movel     HKLNKN        Dbkey                          **************CPB008
     C                   Out       LDA                                                        CPB008
     C                   Eval      ReturnCode  = W_NoRcdFnd                                   CPB008
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End *in82     CPB008
                                                                                              CPB008
     C                   Eval       W_ShortName = HKCSNM                                      CPB008
     C                   Endif                                                                CPB008
                                                                                              CPB008
      **------------------ end   of access associated Linked deal----**                       CPB008
      **------------------ End of Additionnal fields ----------------**
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 06                                  * Db Error 06 *
     C                   Eval      DBkey  = RAMSGTYPE                           ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = 'Image_Type'
     C**********         Exsr      *Pssr                                                      CPB010
                                                                                              CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   Endif                                                  End W_PosFin
 
     C                   Eval      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
 
      **  Place the result in field CompData.
 
     C                   Eval      CompData = %subst(TransData:1:EndPosition)
     C                                      + W_CcyNbdp                         Ccy Dec. Places
     C                                      + W_RecSettlAcc                     Receipt Settl. Acc.
     C                                      + W_RecSettlPor                     Receipt Settl. Portf
     C                                      + W_PaySettlAcc                     Payment Settl. Acc.
     C                                      + W_PaySettlPor                     Payment Settl. Portf
     C                                      + W_IntSettlAcc                     193433Int. Set. Acc.
     C                                      + W_IntSettlPor                     193433Int. Set. Port
     C                                      + W_FrontOffId                      Front Office Id
     C                                      + W_WitholdingT                     Witholding Tax
     C                                      + W_EAMT                            Event Amount
     C                                      + W_Hkluid                                User    CPB008
     C                                      + W_Hkdusc                                        CPB008
     C                                      + W_BaseValue                                     CPB008
     C                                      + W_ShortName                                     CPB008
     C/COPY WNCPYSRC,RP1509C002
 
      **------------------ End of Additionnal fields ----------------**
 
      **  Call a standard routine to actually send the message.
     C                   CallB     'RPSNDMSG'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   Parm                    CompData
     C                   Parm                    CommitCtl
     C                   Parm                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   If        ReturnCode <> *blank                         Begin ReturnCode
     C     *Lock         In        Lda
     C                   Move      'RPSNDMSG  '  DBpgm
     C                   Out       Lda
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   Else                                                   Else ReturnCode
                                                                                              CPB010
     C                   Exsr      WrtTrace                                                   CPB010
     C                   Commit
 
     C                   Endif                                                  End ReturnCode
 
     C                   Endif                                                  End BBPRBA
 
     C                   Return
 
      /Eject
      *****************************************************************
      *                                                               *
      *  RtvPos   - retrieve position in Meridian message.            *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     RtvPos        Begsr
 
     C                   Callb     'RPC1305'
     C                   Parm                    ScriptName
     C                   Parm      RAMSGTYPE     ImageName
     C                   Parm                    FieldName
     C                   Parm                    FieldType
     C                   Parm                    TransData
     C                   Parm      0             FieldPosition
     C                   Parm      0             FieldLength
     C                   Parm      *blank        FieldValue
     C                   Parm      *blank        ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 07                                  * Db Error 07 *
     C                   Eval      DBkey  = 'RPC1305'                           ***************
     C                   Out       LDA
     C**********         Exsr      *Pssr                                                      CPB010
                                                                                              CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   Endif                                                  End ReturnCode
 
     C                   Eval      X = X + 1
      **  If any error occurred while retrieving position, handle it.
     C                   If        X > 100
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Array   '                          ***************
     C                   Eval      DBase  = 08                                  * Db Error 08 *
     C                   Eval      DBkey  = 'Index  '                           ***************
     C                   Out       LDA
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End ReturnCode
 
     C                   Eval      ArrFld(X) = FieldName
     C                   Eval      ArrPos(X) = FieldPosition
     C                   Eval      ArrLen(X) = FieldLength
 
     C                   Endsr
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
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCoCPB010
     C     *Lock         In        Lda                                                        CPB010
     C                   Eval      DBpgm  = PSProcName                                        CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 08                                  * Db Error 08 CPB010
     C                   Eval      DBkey  = 'RP1590'                            **************CPB010
     C                   Out       Lda                                                        CPB010
                                                                                              CPB010
     C                   Endif                                                  End ReturnCodeCPB010
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
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCoCPB010
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
     C                   Endif                                                  End ReturnCodeCPB010
                                                                                              CPB010
     C                   Endsr                                                                CPB010
                                                                                              CPB010
      /Eject
      *****************************************************************
      *                                                               *
      *  GetSetAc - Get settlement account details.                   *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     GetSetAc      Begsr
 
     C                   Reset                   ReturnCode
     C                   Callb     'ZAGETSETAC'
      **  Outputs
      **  -------
      **  Return code (10A).
     C                   Parm                    ReturnCode
      ****Account*code*(4,0S).*****************************************                       CGL029
      **  Account code (10,0S).                                                               CGL029
     C                   Parm                    AccCode
      **  Account sequence (2,0S).
     C                   Parm                    AccSeq
      **  MEMOS update required.
     C                   Parm                    MemosInd
      **  PRONO update required.
     C                   Parm                    PronoInd
      **  Input/output
      **  ------------
      **  Transaction branch (3A) (can also be returned).
     C                   Parm                    Branch
      **  Tansaction customer (6,0S) (can also be returned).
     C                   Parm                    CustNo
      **  Sttlement currency (3A) (can also be returned).
     C                   Parm                    W_Currency
      **  Inputs
      **  ------
      **  Settlement type (2,0S)
     C                   Parm                    SettleType
      ****Settlement*account*(12A)*************************************                       CGL029
      **  Settlement account (18A)                                                            CGL029
     C                   Parm                    SettleAcc
 
      **  Retrieve data area QTEMP/APDUMP to check if any error
      **  occurred while getting Settlement Details without
      **  return code being set up.
     C                   In        Apdump
 
      **  If any error occurred while getting Settlement Details, handle it.
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     ARErrMod      Orne      *blanks
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 09                                  * Db Error 09 *
     C                   Eval      DBkey  = 'ZAGETSETAC'                        ***************
     C                   Out       LDA
     C                   Eval      ReturnCode = 'Error'
     C****               Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
 
     C                   Endif                                                  End ReturnCode
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  GetDecPl - get number of decimal places.                     *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     GetDecPl      Begsr
 
      **  Access to Currency Details, by using access object.
     C                   Callb     'AOCURRR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    P_Curr            3            I:Key field
     C     Sdcurr        Parm      Sdcurr        Dssdy                          O:Format
 
      **  If currency does not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCURRPD'                          ***************
     C                   Eval      Dbase  = 10                                  * Db Error 10 *
     C                   Eval      Dbkey  = P_Curr                              ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = P_RTCD
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr
 
     C     W_RunBefore   Ifeq      *blank                                       Begin W_RunBefore
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
     C                   If        CommitCtl = 'Y'                              Begin CommiCtl
     C                   Rolbk
 
     C                   Endif                                                  End CommitCtl
 
     C     *Lock         In        Lda
     C     DBpgm         Ifeq      *blanks                                      Begin DBpgm
     C                   Move      PSProcName    DBpgm
     C                   Out       Lda
 
     C                   Endif                                                  End DBpgm
 
     C                   Move      'Y'           W_RunBefore
     C                   Dump
 
     C                   Endif                                                  End W_RunBefore
 
     C     ReturnCode    Ifeq      *blank                                       Begin ReturnCode
     C                   Eval      ReturnCode = '*PSSR'
     C                   Endif                                                  End ReturnCode
 
     C                   Seton                                        U7U8LR
     C                   Return
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        Begsr
 
     C     *Entry        Plist
      ** MQSeries queue to write to - this parameter IS used in this module
     C                   Parm                    OutQueue
      ** Merdian header
     C                   Parm                    MdnHeadDS
      ** Transaction Data
     C                   Parm                    TransData
      ** Commitment control flag
     C                   Parm                    CommitCtl
      ** Return Code
     C                   Parm                    ReturnCode
 
     C                   Eval      MessageInd = 'Y'                                           CPB010
                                                                                              CPB010
      **  Set up work fields for formatting that will not change if
      **  Replication formatting is required.
      **     - signs are not shown for Positive numbers.
      **     - get decimal separator from Replication data area RPDFTSDA.
     C                   In        RPDftsDa
     C                   Eval      fmDecSep   = RCDECSEP
     C                   Eval      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   Move      fmDpLen       W_PosDebut
     C                   Eval      fmShwPsSgn = 'N'
 
      **  Set up work fields that will not change if retrieve
      **  function is to be used.
     C                   Eval      ScriptName = 'RP' + RATGTSYS
 
      **  Check if CEU003 (EMU Dealing Settlement Currency
      **  conversion) is installed.
     C                   Eval      CEU003 = 'N'
     C                   Callb     'AOSARDR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*VERIFY'     P_Optn
     C                   Parm      'CEU003'      P_Sard
     C     Scsard        Parm      Scsard        Dsfdy
 
      **  If any error occurred when checking feature.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     P_Rtcd        andne     '*NRF   '
     C     *lock         in        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SCSARDPD'                          ***************
     C                   Eval      DBase  = 11                                  * Db Error 11 *
     C                   Eval      DBkey  = P_Sard                              ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = 'Error'
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End P_Rtcd
 
      **  If feature is installed.
     C     P_Rtcd        Ifeq      *blanks                                      Begin P_Rtcd
     C                   Eval      CEU003 = 'Y'
     C                   Endif                                                  End P_Rtcd
 
      **  Get run day number.
     C                   In        Rundat
 
     C                   Z-add     0             X                 3 0
 
      **  Retrieve position and length of customer number from DEALSDC message data.
     C                   Eval      FieldName = 'CNUM'
     C**********         Eval      FieldType = 'N'                                          AR970292
     C                   EVAL      FieldType = 'A'                                          AR970292
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of currency from DEALSDC message data.
     C                   Eval      FieldName = 'CCY'
     C                   Eval      FieldType = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Settl. Ccy from DEALSDC message data.
     C                   Eval      FieldName = 'STCY'
     C                   Eval      FieldType = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Receiv. Branch from DEALSDC message data.
     C                   Eval      FieldName = 'ROBR'
     C                   Eval      FieldType = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Settl. Methode from DEALSDC message data.
     C                   Eval      FieldName = 'RSTM'
     C                   Eval      FieldType = 'N'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Our Nostro from DEALSDC message data.
     C                   Eval      FieldName = 'RONS'
     C                   Eval      FieldType = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Our Pay Branch from DEALSDC message data.
     C                   Eval      FieldName = 'POBR'
     C                   Eval      FieldType = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay Settl. Methode from DEALSDC message data.
     C                   Eval      FieldName = 'PSTM'
     C                   Eval      FieldType = 'N'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay Our Nostro from DEALSDC message data.
     C                   Eval      FieldName = 'PONS'
     C                   Eval      FieldType = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Deal Number from DEALSDC message data.
     C                   Eval      FieldName = 'DLNO'
     C                   Eval      FieldType = 'N'
     C                   Exsr      RtvPos
                                                                                193433
      **  Retrieve position and length of Interest Settlement Method from       193433
      **  DEALSDC message data.                                                 193433
     C                   Eval      FieldName = 'IMET'                           193433
     C                   Eval      FieldType = 'A'                              193433
     C                   Exsr      RtvPos                                       193433
                                                                                193433
      **  Retrieve position and length of Interest Settlement Account from      193433
      **  message data.                                                         193433
     C                   Eval      FieldName = 'INSA'                           193433
     C                   Eval      FieldType = 'A'                              193433
     C                   Exsr      RtvPos                                       193433
 
      **  Retrieve position and length of Maturity Date from DEALSDC msg data.  195935
     C                   Eval      FieldName = 'MDAT'                           195935
     C                   Eval      FieldType = 'N'                              195935
     C                   Exsr      RtvPos                                       195935
                                                                                195935
                                                                                              CPB008
      **  Retrieve position and length of Baserate Code from DEALSDC message data.            CPB008
     C                   Eval      FieldName = 'BRTT'                                         CPB008
     C                   Eval      FieldType = 'N'                                            CPB008
     C                   Exsr      RtvPos                                                     CPB008
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     C                   Endsr
      /Eject
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
