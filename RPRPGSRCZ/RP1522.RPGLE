     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extraction Module for HISTSHP.')           *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1522 - Extract module for HISTSHP                          *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Currency Number of Decimal Places.          *
      *                 - Receipt Settlement Account.                 *
      *                 - Receipt Settlement Account's Portf. Ref.    *
      *                 - Payment Settlement Account.                 *
      *                 - Payment Settlement Account's Portf. Ref.    *
      *                 - Maturity Date Settlement Type.              *
      *                 - Interest Rate.                              *
      *                 - Loan Portfolio Reference.                   *                       217797
      *                 - Last Interest Date.                         *                       257661
      *                 - Next Interest Date.                         *                       257661
      *                                                               *
      *  Component of: RP1522 - Extract program for HISTSHP           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE154             Date 07Aug12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR858264A          Date 16Jul12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257661             Date 11Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 249091             Date 06Jul07               *
      *                 246393             Date 12Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 217797             Date 12May03               *
      *                 CPB010             Date 16Jan03               *
      *                 203613             Date 16May02               *
      *                 204147             Date 15May02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 13Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  257661 - To avoid unexpected replication due to human error. *
      *           Apply fix 249612.                                   *
      *         - Initialize array index before attempting to retrieve*
      *           value of REPI indicator. Apply fix 251338.          *
      *  249091 - To properly handle Base Rate Code Change and Spread *
      *           Interest Rate Change loan events, more specially    *
      *           base rate, rate and margin.                         *
      *           Add last interest payment date (same as RP1507).    *
      *  246393 - Add next interest payment date.                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  217797 - Add loan portfolio reference within message.        *
      *  CPB010 - Avoid DB Error by write message in Repair File      *
      *           Execute Subroutine Repair instead of *Pssr in case  *
      *              of database error.                               *
      *           Two possibility, message can be repair or not:      *
      *               Set MessageInd to 'Y' in case of repair or 'N'  *
      *           If the message is associated to an other messages   *
      *           like xxx_B and xxx_After, xxx_B must be setup       *
      *           in the associated messages and _After is the master.*
      *           To manage the repair messages, call RPC1492.        *
      *  204147 - Trigger program dumps due to access on LF/CLOAN.    *
      *  203613 - Put CLOAN on UserControl option to avoid problem    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
 
      **  Midas LE Loans File
     FCLOAN     IF   E           K Disk    Ignore(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     Infsr(*Pssr)
     F                                     Usropn                               203613
 
      **  Midas GL Accounts Master
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
     F                                     Infsr(*Pssr)
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  CHAIN access to SDPBDSL0 failed.                      *
      *  82  -  CHAIN access to CLOAN/ACCNT failed.                   *
      *  89  -  LOOKUP equal search condition resulting indicator.    *                       257661
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
      *       * xx   xx   83   84   85   86   87   88   xx   90 *     *                       257661
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
      *  Repair   - Repair process                                    *         CPB010
      *  WrtTrace - Trace process                                     *         CPB010
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
     C**********/COPY RPCPYSRC,Std_Dcl                                                     AR858264A
     C/COPY RPCPYSRC,STD_DCL                                                               AR858264A
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C**********/COPY RPCPYSRC,Mdn_Hd_DS                                                   AR858264A
     C/COPY RPCPYSRC,MDN_HD_DS                                                             AR858264A
 
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
 
      **  Work Field used for EMU feature CEU004.
     D CEU004          S              1A
 
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
      **----------------  End of Parameters for CPB010  --------------**        CPB010
 
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
     D CustNo          S              6A                                                      CSD027
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
     D K_CustNum       S              6A                                                      CSD027
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **   Image Type - Amend Before, Amend After or Insert.                                  257661
     D ImageType       S             20A                                                      257661
                                                                                              257661
      **  Work Fields used to check REPI flag values, before and after.                       257661
     D W_REPI_Before   S              1A                                                      257661
     D W_REPI_After    S              1A                                                      257661
                                                                                              257661
      **  Composite Data.
     D CompData        S                   LIKE(TransData)
 
      **----------------  Start of additional fields ----------------**
     D W_CcyNbdp       S              1A
     D*W_RecSettlAcc   S             18A                                                      CGL029
     D W_RecSettlAcc   S             24A                                                      CGL029
     D W_RecSettlAccP  S              4A
     D*W_PaySettlAcc   S             18A                                                      CGL029
     D W_PaySettlAcc   S             24A                                                      CGL029
     D W_PaySettlAccP  S              4A
     D W_MatDateSetl   S              2A
     D W_InterestRate  S             13A
     D W_Portfolio     S              4A                                                      217797
     D W_LastIntDate   S              7A                                                      249091
     D W_NextIntDate   S              7A                                                      246393
      **-----------------  End of additional fields -----------------**
                                                                                              246393
      **  Work Field used to store next interest payment date.                                246393
     D W_NIDT          S              5  0                                                    246393
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      **  Work field used for change message type
     D W_PosFin        S              3S 0
 
     D P_Loan          S              6A                                                      CLE148
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
 
     C                   Z-add     1             X                                            257661
     C     'REPI  '      Lookup    ArrFld(X)                              89                  257661
                                                                                              257661
      ** Check image (Before or After) of the message.                                        257661
     C                   Eval      W_PosFin    = %Scan('_B':RAMSGTYPE)                        257661
                                                                                              257661
      ** Before Image Type.                                                                   257661
     C     W_PosFin      Ifne      0                                                          257661
     C                   Eval      ImageType = 'Amend Before'                                 257661
     C                   Eval      AssocData = TransData                                      257661
     C                   Eval      MdHdAssoc = MdnHeadDs                                      257661
     C                   Eval      MessageInd = 'N'                                           257661
      ** Extract REPI indicator.                                                              257661
     C                   Eval      W_REPI_Before = %Subst(TransData:+                         257661
     C                             ArrPos(X):ArrLen(X))                                       257661
     C                   Return                                                               257661
                                                                                              257661
      ** After Image Type.                                                                    257661
     C                   Else                                                                 257661
     C                   If        ImageType <> 'Amend Before'                                257661
     C                   Eval      ImageType = 'Insert'                                       257661
                                                                                              257661
     C                   Else                                                                 257661
     C                   Eval      ImageType = 'Amend After'                                  257661
                                                                                              257661
     C                   EndIf                                                                257661
                                                                                              257661
      ** Extract REPI indicator.                                                              257661
     C                   Eval      W_REPI_After = %Subst(TransData:+                          257661
     C                             ArrPos(X):ArrLen(X))                                       257661
     C                   Endif                                                                257661
                                                                                              257661
      ** Process only After image if REPI indicator was changed from                          257661
      ** 'Y' to 'C'.                                                                          257661
     C                   If        ImageType = 'Insert'                                       257661
     C                             or W_REPI_Before <> 'Y'                                    257661
     C                             or W_REPI_After  <> 'C'                                    257661
     C                   Return                                                               257661
     C                   Endif                                                                257661
                                                                                              257661
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **  Extract custoner number from HISTSHP message data.
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
     C     BBCLST        ANDNE     'Y'                                          223644
     C     *LOCK         IN        LDA
     C                   Eval      DBpgm      = PSProcName
     C                   Eval      DBfile     = 'SDCUSTPD'                      ***************
     C                   Eval      DBase      = 01                              * Db Error 01 *
     C                   Eval      DBkey      = P_Cust                          ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = P_Rtcd
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
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
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
     C                   Endif                                                  End  *in81
 
     C                   Endif                                                  End  BBPRBA
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer.
     C                   If            BBPRBA = 'Y'                             Begin BBPRBA
     C                             Or  PBREPB = 'Y'
 
      **----------------- Start of Additionnal fields ---------------**
 
      **  Extract Loan Reference
     C                   Z-add     1             X
     C     'LNRF  '      Lookup    Arrfld(X)                              89
     C**********         Eval      FieldValue = %Subst(TransData:+                            CLE148
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                            CLE148
     C                   EVAL      FieldValue = %Subst(TransData:+                            CLE148
     C                             ArrPos(X):ArrLen(X))                                       CLE148
     C                   Movel     FieldValue    P_Loan
 
     C     K_Loan        Klist
     C**********         Kfld                    P_Loan            6 0                        CLE148
     C                   KFLD                    P_Loan                                       CLE148
     C                   Kfld                    P_Rcdt            1            204147
 
     C                   Open      CLOAN                                        203613
      **  Retrieve Loan details
     C                   Eval      P_Rcdt = 'A'                                 204147
     C     K_Loan        Chain     CLOAN                              82
 
     C                   Close     CLOAN                                        203613
      **  If Loan does not exist, handle database error.
     C     *in82         Ifeq      True                                         Begin *in82
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'CLOAN'                             ***************
     C                   Eval      Dbase  = 03                                  * Db Error 03 *
     C                   Movel     P_Loan        Dbkey                          ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Endif                                                  End  *in82
                                                                                217797
      **--------------- Start of Portfolio Reference ----------------**         217797
                                                                                217797
     C                   Eval      W_Portfolio = PTFR                           217797
                                                                                217797
      **----------------- End of Portfolio Reference ----------------**         217797
 
      **--------- Start of Currency Number of Decimal Places --------**
 
      **  Retrieve first (purchase) currency number of decimal places.
     C                   Eval      P_Curr = CCY
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_CcyNbdp
 
      **---------- End of Currency Number of Decimal Places ---------**
 
      **--------- Start of Receipt Settlement Full Account ----------**
 
      **  Initialize Receipt Settlement Full Account
     C                   Eval      W_RecSettlAcc = *blanks
     C                   Eval      W_RecSettlAccP = *blanks
 
      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo
 
      **  Extract Transaction Currency Code.
      **  If EMU is installed, use Settlement Currency if entered.
     C                   Eval      FieldValue = *Blanks
     C     CEU004        Ifeq      'Y'                                          Begin CEU004
     C                   Eval      FieldValue = SCCY
     C                   Endif                                                  End CEU004
 
      **  If EMU is not installed or Settlement currency not used,
      **  use currency of transaction.
     C     FieldValue    Ifeq      *blanks                                      Begin FieldValue
     C                   Eval      FieldValue = CCY
     C                   Endif                                                  End FieldValue
 
     C                   Eval      W_Currency = FieldValue
 
      **  Extract Branch Code.
     C                   Eval      Branch = OSDB
 
      **  Extract Settlement Method.
     C                   Movel     SDST          SettleType
 
      **  Extract Settlement Account.
     C                   Eval      SettleAcc = OSDA
 
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
     C     K_Accnt       Chain     ACCNT                              82
 
      **  If Account does not exist, handle database error.
     C     *in82         Ifeq      True                                         Begin *in82
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'ACCNT'                             ***************
     C                   Eval      Dbase  = 04                                  * Db Error 04 *
     C                   Eval      DbKey = W_FullSettlAcc                       ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Endif                                                  End  *in82
 
     C                   Eval      W_RecSettlAccP = A_PTFR
 
     C                   Endif                                                  End CustNo
 
      **---------- End of Receipt Settlement Full Account ------------**
 
      **--------- Start of Payment Settlement Full Account  ----------**
 
      **  Initialize Receipt Settlement Full Account
     C                   Eval      W_PaySettlAcc = *blanks
     C                   Eval      W_PaySettlAccP = *blanks
 
      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo
 
      **  Extract Branch Code.
     C                   Eval      Branch = OMDB
 
      **  Extract Settlement Method.
     C                   Movel     MDST          SettleType
 
      **  Extract Settlement Account.
     C                   Eval      SettleAcc = OMDA
 
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
     C     K_Accnt       Chain     ACCNT                              82
 
      **  If Account does not exist, handle database error.
     C     *in82         Ifeq      True                                         Begin *in82
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'ACCNT'                             ***************
     C                   Eval      Dbase  = 05                                  * Db Error 05 *
     C                   Eval      DbKey = W_FullSettlAcc                       ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Endif                                                  End  *in82
 
     C                   Eval      W_PaySettlAccP = A_PTFR
 
     C                   Endif                                                  End CustNo
 
      **--------- End of Payment Settlement Full Account -----------**
 
      **--------- Start of Maturity Date Settlement Type -----------**
 
     C                   Move      MDST          W_MatDateSetl
 
      **---------- End of Maturity Date Settlement Type  -----------**
 
      **--------- Start of Interest Rate ---------------------------**
 
      **  Set up Interest Rate in message.
     C                   EVAL      fmLength = 11
     C                   EVAL      fmDecPos = 7
     C                   EVAL      fmSign3010 = INTR
     C                   EVAL      fmAlpNum32 =
     C                                ProcSigned(fmSign3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_InterestRate = %subst(fmAlpNum32 : 1 : 13)
 
      **---------- End of Interest Rate ----------------------------**
                                                                                              249091
      **--------- Start of Last Interest Payment Date --------------**                        249091
                                                                                              249091
     C                   Eval      W_LastIntDate = *blanks                                    249091
     C                   Eval      fmLength = 5                                               249091
     C                   Eval      fmDecPos = 0                                               249091
     C                   Eval      fmPack3010 = SLID                                          249091
     C                   Eval      fmAlpNum32  =                                              249091
     C                                ProcPacked(fmPack3010 : fmLength :                      249091
     C                                           fmDecPos : fmDecSep :                        249091
     C                                           fmShwPsSgn)                                  249091
     C                   Eval      W_LastIntDate = %subst(fmAlpNum32 : 1 : 7)                 249091
                                                                                              249091
      **---------- End of Last Interest Payment Date ---------------**                        249091
                                                                                              246393
      **--------- Start of Next Interest Payment Date --------------**                        246393
                                                                                              246393
     C                   MOVE      *BLANKS       W_NextIntDate                                246393
                                                                                              246393
     C                   If        MDAT > 0 and NIDT > MDAT                                   246393
     C                   Eval      W_NIDT = MDAT                                              246393
                                                                                              246393
     C                   Else                                                                 246393
     C                   Eval      W_NIDT = NIDT                                              246393
                                                                                              246393
     C                   Endif                                                                246393
     C                   Eval      fmLength = 5                                               246393
     C                   Eval      fmDecPos = 0                                               246393
                                                                                              246393
     C                   Eval      fmPack3010 = W_NIDT                                        246393
     C                   Eval      fmAlpNum32  =                                              246393
     C                                ProcPacked(fmPack3010 : fmLength :                      246393
     C                                           fmDecPos : fmDecSep :                        246393
     C                                           fmShwPsSgn)                                  246393
     C                   EVAL      W_NextIntDate = %subst(fmAlpNum32 : 1 : 7)                 246393
                                                                                              246393
      **---------- End of Next Interest Payment Date ---------------**                        246393
 
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
     C****               Exsr      *Pssr                                        CPB010
                                                                                CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   Endif                                                  End W_PosFin
 
     C                   Eval      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
 
      **  Place the result in field CompData.
 
     C                   Eval      CompData = %subst(TransData:1:EndPosition)
     C                                      + W_CcyNbdp                         Ccy Dec. Places
     C                                      + W_RecSettlAcc                     Receipt Settl. Acc.
     C                                      + W_RecSettlAccP                    Rec.Settl.Acc. Ptfr.
     C                                      + W_PaySettlAcc                     Payment Settl. Acc.
     C                                      + W_PaySettlAccP                    Pay.Settl.Acc. Ptfr.
     C                                      + W_MatDateSetl                     Maturity Date Setll.
     C                                      + W_InterestRate                    Interest Rate.
     C                                      + W_Portfolio                       Portfolio Ref.217797
     C                                      + W_LastIntDate                     Last Int. Date249091
     C                                      + W_NextIntDate                     Next Int. Date246393
 
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
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   Else                                                   Else ReturnCode
                                                                                CPB010
     C                   Exsr      WrtTrace                                     CPB010
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
     C****               Exsr      *Pssr                                        CPB010
                                                                                CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
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
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Endif                                                  End ReturnCode
 
     C                   Eval      ArrFld(X) = FieldName
     C                   Eval      ArrPos(X) = FieldPosition
     C                   Eval      ArrLen(X) = FieldLength
 
     C                   Endsr
      /Eject                                                                    CPB010
      *****************************************************************         CPB010
      *                                                               *         CPB010
      *  WrtTrace - Write a Trace of outgoing messages.               *         CPB010
      *                                                               *         CPB010
      *  Called by : Main processing.                                 *         CPB010
      *                                                               *         CPB010
      *  Calls     : None.                                            *         CPB010
      *                                                               *         CPB010
      *****************************************************************         CPB010
                                                                                CPB010
     C     WrtTrace      Begsr                                                  CPB010
                                                                                CPB010
     C                   Callb     'RP1590'                                     CPB010
     C                   Parm                    OutQueue                       CPB010
     C                   Parm                    MdnHeadDS                      CPB010
     C                   Parm                    CompData                       CPB010
     C                   Parm                    CommitCtl                      CPB010
     C                   Parm                    ReturnCode                     CPB010
                                                                                CPB010
      **  If any error occurred while retrieving position, handle it.           CPB010
     C     ReturnCode    Ifne      *blanks                                      CPB010
     C     *Lock         In        Lda                                          CPB010
     C                   Eval      DBpgm  = PSProcName                          CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 08                                  * Db Error 8 *CPB010
     C                   Eval      DBkey  = 'RP1590'                            **************CPB010
     C                   Out       Lda                                          CPB010
                                                                                CPB010
     C                   Endif                                                  CPB010
     C                   Endsr                                                  CPB010
                                                                                CPB010
      /Eject                                                                    CPB010
      *****************************************************************         CPB010
      *                                                               *         CPB010
      *  Repair   - Write a Trace of outgoing messages to repair      *         CPB010
      *                                                               *         CPB010
      *  Called by : Main processing.                                 *         CPB010
      *                                                               *         CPB010
      *  Calls     : None.                                            *         CPB010
      *                                                               *         CPB010
      *****************************************************************         CPB010
                                                                                CPB010
     C     Repair        Begsr                                                  CPB010
                                                                                CPB010
     C                   Move      Dbase         dbasea            3            CPB010
                                                                                CPB010
     C                   Eval      DBErrText = 'DBError' +                      CPB010
     C                             ' in : ' + DBpgm +                           CPB010
     C                             ' at: ' + DBasea +                           CPB010
     C                             ' file : ' + DBfile +                        CPB010
     C                             ' Key : ' + DBKey +                          CPB010
     C                             ' Return :' + ReturnCode                     CPB010
                                                                                CPB010
     C                   Eval      RAMSGTYPE = RAMSGOLD                         CPB010
                                                                                CPB010
     C                   Callb     'RP1592'                                     CPB010
     C                   Parm                    OutQueue                       CPB010
     C                   Parm                    MdnHeadDS                      CPB010
     C                   Parm                    TransData                      CPB010
     C                   Parm                    MdHdAssoc                      CPB010
     C                   Parm                    AssocData                      CPB010
     C                   Parm                    CommitCtl                      CPB010
     C                   Parm                    DBErrText                      CPB010
     C                   Parm                    MessageInd                     CPB010
     C                   Parm      *Blanks       ReturnCode                     CPB010
                                                                                CPB010
      **  If any error occurred while retrieving position, handle it.           CPB010
     C     ReturnCode    Ifne      *blanks                                      CPB010
     C     *Lock         In        Lda                                          CPB010
     C                   Eval      DBpgm  = PSProcName                          CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 50                                  * Db Error 50 CPB010
     C                   Eval      DBkey  = 'RP1592'                            **************CPB010
     C                   Out       Lda                                          CPB010
                                                                                CPB010
     C                   exsr      *pssr                                        CPB010
     C                   Else                                                   CPB010
     C                   Return                                                 CPB010
     C                   Endif                                                  CPB010
                                                                                CPB010
     C                   Endsr                                                  CPB010
                                                                                CPB010
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
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
 
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
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
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
 
     C                   Eval      MessageInd = 'Y'                             CPB010
 
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
 
 
      **  Check if CEU004 (EMU) is installed.
     C                   Eval      CEU004 = 'N'
     C                   Callb     'AOSARDR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*VERIFY'     P_Optn
     C                   Parm      'CEU004'      P_Sard
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
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
     C                   Endif                                                  End P_Rtcd
 
      **  If feature is installed.
     C     P_Rtcd        Ifeq      *blanks                                      Begin P_Rtcd
     C                   Eval      CEU004 = 'Y'
 
     C                   Endif                                                  End P_Rtcd
 
     C                   Z-add     0             X                 3 0
 
      **  Retrieve position and length of customer number from HISTSHP message data.
     C                   Eval      FieldName = 'CNUM'
     C**********         Eval      FieldType = 'N'                                          AR970292
     C                   EVAL      FieldType = 'A'                                          AR970292
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Loan Reference from HISTSHP message data.
     C                   Eval      FieldName = 'LNRF'
     C**********         Eval      FieldType = 'N'                                            CLE148
     C                   EVAL      FieldType = 'A'                                            CLE148
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Replication indicator from                          257661
      **  HISTSHP message data.                                                               257661
     C                   Eval      FieldName = 'REPI'                                         257661
     C                   Eval      FieldType = 'A'                                            257661
     C                   Exsr      RtvPos                                                     257661
                                                                                              257661
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     C                   Endsr
      /Eject
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
