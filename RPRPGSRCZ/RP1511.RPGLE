     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Extraction Module for TRADSD.')               *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1511 - Extract module for TRADSD                           *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Nominal currency number of decimal places.  *
      *                 - Pay From Settlement Account.                *
      *                 - Pay From Settlement Account's Portfolio Ref.*
      *                 - Pay To Settlement Account.                  *
      *                 - Pay To Settlement Account's Portfolio Ref.  *
      *                                                               *
      *  Component of: RP1511 - Extract program for TRADSD            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR858264A          Date 16Jul12               *
      *                 207288             Date 11Jul12               *
      *                 AR978289           Date 23May12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 CPB010             Date 16Jan03               *
      *                 210120             Date 30Sep02               *
      *                 206076             Date 23May02               *
      *                 206491             Date 08Oct02               *
      *                 206490             Date 07Oct02               *
      *                 206304             Date 17Sep02               *
      *                 203358             Date 20May02               *
      *                 201695             Date 16May02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 207049             Date 26Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD011             Date 04Mar02               *
      *                 196903             Date 24Oct01               *
      *                 196853             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 192099             Date 10Apr01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  207288 - Recompile over changes in RP1511.                   *
      *           Applied for AR999664 (Child: AR999668)              *
      *  AR978289 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Authorization in BF Midas has changed with WIP.   *
      *             Review completely processing when ICD field       *
      *             "Trade Authorisation Type" = 00 (PF/SDSTRDPD)     *
      *             (Child:AR978290) (Recompile)                      *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
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
      *  CPB010 - Avoid DB Error by write message in Trace File       *
      *  210120 - If input of SE Trade with customer number blank     *
      *           do not send message. And avoid DBErr on customer det*
      *  206076 - When Aut. Lvl = '00', trade is directly written as  *
      *           'C'ompleted. No image before should be used for     *
      *           checking.                                           *
      *  206491 - Do not send Amend of authorised counterparty trades *
      *  206490 - Process for settl. method 15 as other method.       *
      *  206304 - If Delete of trade with RECI='L', send it           *
      *           done in conjunction of with 203470.                 *
      *           Review delete of trade before & after authorization *
      *           for trade concerning a Private Banking Customer     *
      *  203358 - For Aut. Lvl > '00', do not check TRADSD RECI       *
      *           evolution, just check rcd with AU in TRAUTD (or DL) *
      *  201695 - For Trade with counterpart, resend it only once>TOF *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  207049 - Trade coming from ToF and deleted before any        *
      *           authorisation are not sent back to ToF.             *
      *  CSD011 - Performance Incentive Fees. Recompile over changed  *
      *           SDTOFPD.                                            *
      *  196903 - If user has entry limit, trade is automatically     *
      *           authorised and there is no record in TRAUTD         *
      *           Same when deletion of an incomplete trade           *
      *           Then check the value of RECI and TINC               *
      *  196853 - Use Settl.ccy instead of Nominal ccy for settlement.*
      *  192099 - Avoid DATABASE ERROR in file ACCNT at 004           *
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
 
      * SE Trade Authorisation
     FTRAUT     IF   E           K DISK
     F                                     Infsr(*Pssr)
 
      **  Midas GL Accounts Master
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
     F                                     Infsr(*Pssr)
      *
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  CHAIN access to SDPBDSL0/ACCNT failed.                *
      *  82  -  Begin of file TRAUT after ReadPe.                     *
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
     C**********/COPY RPCPYSRC,Std_Dcl                                                     AR858264A
     C/COPY RPCPYSRC,STD_DCL                                                               AR858264A
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C**********/COPY RPCPYSRC,Mdn_Hd_DS                                                   AR858264A
     C/COPY RPCPYSRC,MDN_HD_DS                                                             AR858264A
 
      ** Following /COPY is the declares for fields passed to the formatting
      ** routines
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
     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
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
     D Apdump        E DS                  Extname(APDUMP) DTAARA(APDUMP)
 
      **  Data structure used to group settlement account details.
     D***W_FullSettlAcc  DS            18                                                     CGL029
     D W_FullSettlAcc  DS            24                                                       CGL029
     D   W_Branch              1      3
     D   W_CustNo              4      9
     D   W_Currency           10     12
     D   W_AccCode            13     22                                                       CGL029
     D   W_AccSeq             23     24                                                       CGL029
     D***W_AccCode            13     16                                                       CGL029
     D***W_AccSeq             17     18                                                       CGL029
 
      ** Data Structure for access to Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      ** Data Structure for access to Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      ** Data Structure for access to Securities I.C.D. details
     D Sdstrd        E DS                  Extname(SDSTRDPD)
 
      ** Data Structure for access to Private Banking I.C.D. details
     D Sdtofd        E DS                  Extname(SDTOFPD)
 
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of Parameters --------------------**
      **  Output queue name.
     D OutQueue        S                   LIKE(MQSQueue)
      **--------------------- End of Parameters ---------------------**
 
      **-------------- Start of Parameters for RPC1305 --------------**
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
      **--------------- End of Parameters for RPC1305 ---------------**
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
                                                                                              CPB010
      **   Image Type - Amend Before, Amend After or Insert                                   CPB010
     D ImageType       S             20A                                                      CPB010
      **----------------  End of Parameters for CPB010  --------------**                      CPB010
 
      **------------ Start of parameters for ZAGETSETAC -------------**
      **  -------
      **  Outputs
      **  -------
      **  Account code.
     D***AccCode**       S              4S 0                                                  CGL029
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
      **  Settlement currency.
     D Currency        S              3A
      **  ------
      **  Inputs
      **  ------
      **  Settlement type.
     D SettleType      S              2S 0
      **  Settlement account.
     D*SettleAcc*******S             12A                                        192099
     D***Settleacc       DS            12                                              192099 CGL029
     D***WW_AccCode            7     10                                                192099 CGL029
     D***WW_AccSeq            11     12                                                192099 CGL029
     D SettleAcc       DS            18                                                       CGL029
     D   WW_AccNum             1      6                                                       206490
     D   WW_AccCode            7     16                                                       CGL029
     D   WW_AccSeq            17     18                                                       CGL029
 
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
      ** ---------- End of fields used by access programs -----------**
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      **  Work field used to access to SE Trade Authorization.
     D K_TradeRef      S              6A
 
      **  Work field used to access to SE Trade incomplete/complete indicator   196903
     D K_Tinc          S              1A                                        196903
                                                                                196903
      **  Work field used to access to SE Trade RECI                            196903
     D K_Reci          S              1A                                        196903
                                                                                196903
      **  Work field used to store Incomplete Ind before update                               201695
     D B_Tinc          S              1A                                                      201695
      **  Work field used to store If 1st authorisation is done                               201695
     D W_OneAut        S              1A                                                      201695
      **  Work field used to store Private Banking Order Number.
     D W_OrderNumber   S              6S 0
 
      **  Work field used to retrieve Trade type
     D W_Type          S              2A
 
      **----------------  Start of additional fields ----------------**
     D W_NomCcyNbdp    S              1A
     D***W_PayFrSettAcc  S             18A                                                    CGL029
     D W_PayFrSettAcc  S             24A                                                      CGL029
     D W_PayFrSettPor  S              4A
     D***W_PayToSettAcc  S             18A                                                    CGL029
     D W_PayToSettAcc  S             24A                                                      CGL029
     D W_PayToSettPor  S              4A
      **-----------------  End of additional fields -----------------**
 
      **  Work Field used to condition Meridian message sending.
     D W_SendMsg       S              1A
 
      **   Composite Data
     D CompData        S                   LIKE(TransData)
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      **  Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /Eject
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
                                                                                              201695
      **  Check image (Before or After) of the message                                        201695
     C                   Eval      W_PosFin    = %Scan('_B':RAMSGTYPE)                        201695
                                                                                              201695
      **  Before Image Type                                                                   201695
     C     W_PosFin      Ifne      0                                                          201695
     C                   Eval      ImageType = 'Amend Before'                                 CPB010
     C                   Eval      AssocData = TransData                                      CPB010
     C                   Eval      MdHdAssoc = MdnHeadDs                                      CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
                                                                                              201695
      **  Extract Incomplete/complete indicator Image Before                                  201695
     C                   Z-add     1             X                                            201695
     C     'TINC  '      Lookup    Arrfld(X)                              89                  201695
     C                   Eval      B_Tinc = %Subst(TransData:+                                201695
     C                             ArrPos(X):ArrLen(X))                                       201695
      ** DO NOT CONTINUE PROCESS IF BEFORE IMAGE IS PROCESSED                                 201695
     C                   Return                                                               201695
                                                                                              201695
     C                   Else                                                                 201695
                                                                                              CPB010
     C                   If        ImageType <> 'Amend Before'                                CPB010
     C                   Eval      ImageType = 'Insert'                                       CPB010
     C                   Eval      AssocData = *Blanks                                        CPB010
     C                   Eval      MdHdAssoc = *Blanks                                        CPB010
     C                   Else                                                                 CPB010
     C                   Eval      ImageType = 'Amend After'                                  CPB010
     C                   EndIf                                                                CPB010
                                                                                              201695
      **  Extract Incomplete/complete indicator Image After                                   201695
     C                   Z-add     1             X                                            201695
     C     'TINC  '      Lookup    Arrfld(X)                              89                  201695
     C                   Eval      K_Tinc = %Subst(TransData:+                                201695
     C                             ArrPos(X):ArrLen(X))                                       201695
                                                                                              201695
     C                   Endif                                                                201695
 
      **  Extract Customer number from TRADSD message data.
     C                   Z-add     1             X
     C     'TCNR  '      Lookup    Arrfld(X)                              89
     C**********         Eval      P_Cust = %Subst(TransData:+                              AR970292
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                          AR970292
     C                   EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
 
      **  Extract Private Banking Order Number.
     C                   Z-add     1             X
     C     'ORDE  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   Movel     FieldValue    W_OrderNumber
 
     C     K_Tinc        Ifeq      'C'                                                        210120
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
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDCUSTPD'                          ***************
     C                   Eval      DBase  = 01                                  * Db Error 01 *
     C                   Eval      DBkey  = P_Cust                              ***************
     C                   Out       Lda
     C                   Eval       ReturnCode =  P_Rtcd
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
 
     C                   Else                                                                 210120
     C*****P_Cust        Ifeq      '000000    '                                        210120 CSD027
     C     P_Cust        Ifeq      '          '                                               CSD027
     C                   Movel     'N'           BBPRBA                                       210120
     C                   Endif                                                                210120
     C                   Endif                                                                210120
      **  Initialize work field used to condition Meridian message sending.
     C                   Clear                   W_SendMsg
 
     C                   Select                                                 Begin Select
 
     C                   When      BVAUTH = '00'                                Authority level = 0
                                                                                              206304
      **  Extract Reci indicator                                                              206304
     C                   Z-add     1             X                                            206304
     C     'RECI  '      Lookup    Arrfld(X)                              89                  206304
     C                   Eval      K_Reci = %Subst(TransData:+                                206304
     C                             ArrPos(X):ArrLen(X))                                       206304
 
      **  If customer not PB and Order number not 0 and OMS flag = 'Y'
      ****Or*customer*is*PB*******************************************************            206304
      ****Or*customer*is*flagged*as*requested*to*become*a*Private*Banking*Custom**            206304
      **  ... send message.
     C                   If        BBPRBA <> 'Y'                                Begin BBPRBA
     C                             and W_OrderNumber <> 0
     C                             and W_OrderNumber <> 999999                                201695
     C**********                   and TQOMS = 'Y'                                          AR978289
     C**********                   Or  BBPRBA = 'Y'                                           201695
     C**********                   Or  PBREPB = 'Y'                                           201695
     C*****B_Tinc        Ifeq      'I'                                                 201695 206076
     C*****K_Tinc        Andeq     'C'                                                 201695 206076
                                                                                              206304
      **  Only send complete trade or delete of incomplete trade coming from                  206304
      **  interface                                                                           206304
     C     K_Tinc        Ifeq      'C'                                                        206304
     C     K_Tinc        Oreq      'I'                                                        206304
     C     K_Reci        Andeq     'C'                                                        206304
     C     W_OrderNumber Andne     0                                                          206304
     C     W_OrderNumber Andne     999999                                                     206304
     C                   Eval      W_SendMsg = 'Y'
     C                   Endif                                                                206304
     C*******************Clear                   B_TINC                                201695 206076
     C*******************Endif                                                         201695 206076
                                                                                              206076
      ** Do not send update of counterparty trades                                            206076
      ** but send delete of counterparty trades coming from interface                         206304
     C     B_Tinc        Ifeq      'C'                                                        206076
     C     K_Tinc        Andeq     'C'                                                        206076
     C     K_Reci        Andne     'C'                                                        206304
     C                   Eval      W_SendMsg = 'N'                                            206076
     C                   Clear                   B_TINC                                       206076
     C                   Endif                                                                206076
 
     C                   Endif                                                  End BBPRBA
                                                                                              206304
      **  If customer is PB                                                                   206304
      **  Or customer is flagged as requested to become a Private Banking Cust.               206304
      **  ... send message.                                                                   206304
     C                   If            BBPRBA = 'Y'                                           201695
     C                             Or  PBREPB = 'Y'                                           201695
      **********                                                                     206304 AR978289
      ****Only send complete trade or delete of incomplete trade coming from         206304 AR978289
      ****interface                                                                  206304 AR978289
     C*****K_Tinc        Ifeq      'C'                                               206304 AR978289
     C*****K_Tinc        Oreq      'I'                                               206304 AR978289
     C*****K_Reci        Andeq     'C'                                               206304 AR978289
     C*****W_OrderNumber Andne     0                                                 206304 AR978289
     C*****W_OrderNumber Andne     999999                                            206304 AR978289
      **                                                                                    AR978289
      **  ALWAYS send actions on TRADSD for Private Banking customers |                     AR978289
      **                                                                                    AR978289
     C                   Eval      W_SendMsg = 'Y'                                            201695
     C**********         Endif                                                       206304 AR978289
                                                                                              201695
     C                   Endif                                                                201695
                                                                                              206304
      **  Delete trade received from Tof with Incomplete indicator                            206304
      **  ==> It must send M_TOFLfsrefused and NOT M_TOFLFsecurities as it's                  206304
      **      done when taking action code 'Q' into repair queue.                             206304
      **      So, ensure field REPI set to 'D'. (See TRADSD_A mapping decision)               206304
     C     W_SendMsg     Ifeq      'Y'                                                        206304
     C     K_Tinc        Andeq     'I'                                                        206304
      **  Retrieve position of Replication Indicator                                          206304
     C                   Z-add     1             X                                            206304
     C     'REPI  '      Lookup    Arrfld(X)                              89                  206304
     C                   Eval      %Subst(TransData:+                                         206304
     C                             ArrPos(X):1) = 'D'                                         206304
     C                   Endif                                                                206304
 
     C                   Other                                                   Authority level > 0
 
      **  If customer not PB and Order number not 0 and OMS flag = 'Y'
      **  Or customer is PB
      **  Or customer is flagged as requested to become a Private Banking Customer.
      **  ... send message.
      ** IN CASE OF AUTH.LEVEL <>'00', SPLIT ORIGINAL CONDITION IN 2                          201695
      ** 1- IN CASE OF CUSTOMER NOT PB, IF ITS TRANSACTION COMING FROM OMS                    201695
      **    FOR COUNTERPART, SEND ONLY THE FIRST AUTHORISATION.                               201695
      ** 2- IN CASE OF PB CUSTOMER, ORIGINAL PROCESS REMAINS.                                 201695
      **                                                                                      201695
      ** 1                                                                                    201695
     C                   If        BBPRBA <> 'Y'                                Begin BBPRBA
     C                             and W_OrderNumber <> 0
     C                             and W_OrderNumber <> 999999                                201695
     C**********                   and TQOMS = 'Y'                                          AR978289
     C**********                   Or  BBPRBA = 'Y'                                           201695
                                                                                              201695
      **  Extract Trade Reference.                                                            201695
     C                   Z-add     1             X                                            201695
     C     'TDRF  '      Lookup    Arrfld(X)                              89                  201695
     C                   Eval      K_TradeRef = %Subst(TransData:+                            201695
     C                             ArrPos(X):ArrLen(X))                                       201695
                                                                                              201695
      **  Extract Incomplete/complete indicator                                               201695
     C                   Z-add     1             X                                            201695
     C     'TINC  '      Lookup    Arrfld(X)                              89                  201695
     C                   Eval      K_Tinc = %Subst(TransData:+                                201695
     C                             ArrPos(X):ArrLen(X))                                       201695
                                                                                              201695
      **  Extract Reci indicator                                                              201695
     C                   Z-add     1             X                                            201695
     C     'RECI  '      Lookup    Arrfld(X)                              89                  201695
     C                   Eval      K_Reci = %Subst(TransData:+                                201695
     C                             ArrPos(X):ArrLen(X))                                       201695
                                                                                              201695
      **  Look for Authorisation Record                                                       201695
     C                                                                                        201695
     C                   Eval      W_OneAut='N'                                               201695
     C                                                                                        201695
     C     K_TradeRef    Setll     TRAUT                                                      201695
     C     K_TradeRef    Reade     TRAUT                                  82                  201695
     C     *IN82         Doweq     '0'                                                        201695
     C*****W_OneAut      Andeq     'N'                                                 201695 206491
      *                                                                                       206491
      ** If still records after 'AU' ==> skip them                                            206491
      *                                                                                       206491
     C     W_OneAut      Ifeq      'Y'                                                        206491
     C                   Eval      W_OneAut='N'                                               206491
     C                   Leave                                                                206491
     C                   Endif                                                                206491
                                                                                              201695
     C     TATYP         Ifeq      'AU'                                                       201695
     C     TATYP         oreq      'DL'                                                       201695
     C                   Eval      W_OneAut='Y'                                               201695
                                                                                              206491
     C     TATYP         Ifeq      'DL'                                                       206491
      *                                                                                       206491
      **  Retrieve position of Replication Indicator                                          206491
      *                                                                                       206491
     C                   Z-add     1             X                                            206491
     C     'REPI  '      Lookup    Arrfld(X)                              89                  206491
     C                   Eval      %Subst(TransData:+                                         206491
     C                             ArrPos(X):1) = 'D'                                         206491
     C                   Endif                                                                206491
     C                   Endif                                                                201695
     C     K_TradeRef    Reade     TRAUT                                  82                  201695
     C                   Enddo                                                                201695
                                                                                              201695
      **  If Trade Authorization Details exists and only one                                  201695
      ****And*if*Trade*has*already*been*authorised...********************              201695 203358
      ****Or*Trade*RECI*is*'D'*and*is*complete*(under*user*entry*limit),*              201695 203358
      ****Or*Trade*RECI*is*'*',*is*incomplete*and*comes*from*Tof,********              201695 203358
      **  Or Trade RECI is 'C' and comes from Tof                                             206304
     C     *in82         Ifeq      True                                         Begin *in82   201695
     C     W_OneAut      Andeq     'Y'                                                        201695
     C*****K_Reci        Ifeq      'D'                                                 201695 203358
     C*****K_Tinc        Andeq     'C'                                                 201695 203358
     C*****K_Reci        Oreq      '*'                                                 201695 203358
     C*****K_Tinc        Andeq     'I'                                                 201695 203358
     C*****W_OrderNumber Andne     0                                                   201695 203358
      **  Delete before authorization of a trade received from Tof                            206304
      **  (No send of msg if delete of a non authorized trade inputted in Midas)              206304
     C     K_Reci        Oreq      'C'                                                        206304
     C     W_OrderNumber Andne     0                                                          206304
     C     W_OrderNumber Andne     999999                                                     206304
     C                   Eval      W_SendMsg = 'Y'                                            201695
     C**********         Endif                                                         201695 203358
     C                   Endif                                                  End *in82     201695
     C                   Endif                                                                201695
      **                                                                                      201695
      ** 2                                                                                    201695
     C                   If            BBPRBA = 'Y'                                           201695
     C                             Or  PBREPB = 'Y'
 
      **  Extract Trade Reference.
     C                   Z-add     1             X
     C     'TDRF  '      Lookup    Arrfld(X)                              89
     C                   Eval      K_TradeRef = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
                                                                                196903
      **  Extract Incomplete/complete indicator                                 196903
     C                   Z-add     1             X                              196903
     C     'TINC  '      Lookup    Arrfld(X)                              89    196903
     C                   Eval      K_Tinc = %Subst(TransData:+                  196903
     C                             ArrPos(X):ArrLen(X))                         196903
                                                                                196903
      **  Extract Reci indicator                                                196903
     C                   Z-add     1             X                              196903
     C     'RECI  '      Lookup    Arrfld(X)                              89    196903
     C                   Eval      K_Reci = %Subst(TransData:+                  196903
     C                             ArrPos(X):ArrLen(X))                         196903
 
      **  Position on file to check if already authorised.
     C     K_TradeRef    Setgt     TRAUT
     C     K_TradeRef    ReadPe    TRAUT                                  82
 
      **  If Trade Authorization Details exists
      **  And if Trade has already been authorised...
      **  Or Trade RECI is 'D' and is complete (under user entry limit),        196903
      ****Or*Trade*RECI*is*'*',*is*incomplete*and*comes*from*Tof,***********           196903 206304
      ***Or*Trade*RECI*is*'C',*is*complete*and*comes*from*Tof.**************           207049 206304
      **  Or Trade RECI is 'R' and is complete                                                206304
      **  Or Trade RECI is 'C' and comes from Tof                                             206304
      *                                                                                       206304
     C     *in82         Ifeq      False                                        Begin *in82
     C     TATYP         Andeq     'AU'
     C     K_Reci        Oreq      'D'                                          196903
     C     K_Tinc        Andeq     'C'                                          196903
     C*****K_Reci        Oreq      '*'                                                 196903 206304
     C*****K_Tinc        Andeq     'I'                                                 196903 206304
     C*****W_OrderNumber Andne     0                                                   196903 206304
      **  Delete after authorization                                                          206304
     C     K_Reci        Oreq      'R'                                                        206304
     C     K_Tinc        Andeq     'C'                                                        206304
      ***Delete*before*authorization***************************************            207049 206304
      **  Delete before authorization of a trade received from Tof                            206304
      **  (No send of msg if delete of a non authorized trade inputted in Midas)              206304
      *
     C     K_Reci        Oreq      'C'                                                        207049
     C     K_Tinc        Andeq     'C'                                                        206304
     C     W_OrderNumber Andne     0                                                          207049
     C     W_OrderNumber Andne     999999                                                     206304
     C                   Eval      W_SendMsg = 'Y'
     C                   Endif                                                  End *in82
     C                   Endif                                                  End BBPRBA
                                                                                              206304
      **  Delete before authorization of a trade received from Tof                            206304
      **  ==> It must send M_TOFLfsrefused and NOT M_TOFLFsecurities as it's                  206304
      **      done when taking action code 'Q' into repair queue.                             206304
      **      So, ensure field REPI set to 'D'. (See TRADSD_A mapping decision)               206304
     C     K_Reci        Ifeq      'C'                                                        206304
     C     W_SendMsg     Andeq     'Y'                                                        206304
                                                                                              206304
      **  Retrieve position of Replication Indicator                                          206304
     C                   Z-add     1             X                                            206304
     C     'REPI  '      Lookup    Arrfld(X)                              89                  206304
     C                   Eval      %Subst(TransData:+                                         206304
     C                             ArrPos(X):1) = 'D'                                         206304
     C                   Endif                                                                206304
                                                                                              206304
 
     C                   Endsl                                                  End Select
 
      **  If Meridian message has to be sent.
     C     W_SendMsg     Ifeq      'Y'                                          Begin W_SendMsg
 
      **----------------- Start of Additionnal fields ---------------**
 
      **---------------- Start of Nominal Currency ---------------**
      **                   Number of Decimal Places                  **
 
     C                   Z-add     1             X
     C     'TNMC  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Get Nominal Currency number of decimal places.
     C                   Eval      P_Curr = W_Currency
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_NomCcyNbdp
 
      **                  End of Nominal Currency                 **
      **-----------------  Number of Decimal Places  ----------------**
 
      **  Extract Trade Type.
     C                   Z-add     1             X
     C     'TDTP  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Type = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **-------- Start of Pay From Settlement Full Account ----------**
 
      **  Initialize Pay From Settlement Full Account.
     C                   Eval      W_PayFrSettAcc = *blanks
     C                   Eval      W_PayFrSettPor = *blanks
 
      **  Extract Pay From Branch Code.
     C                   Z-add     1             X
     C     'PYFA  '      Lookup    Arrfld(X)                              89
     C                   Eval      Branch = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo
 
      **  Extract Currency Code.
     C                   Z-add     1             X
     C*****'TNMC  '      Lookup    Arrfld(X)                              89    196853
     C     'SETC  '      Lookup    Arrfld(X)                              89    196853
     C                   Eval      Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Settlement Method.
     C                   Z-add     1             X
     C     'SMTH  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   Movel     FieldValue    SettleType
 
      **  Extract Settlement Account.
     C                   Z-add     1             X
     C     'PYFM  '      Lookup    Arrfld(X)                              89
     C                   Eval      SettleAcc = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
     C     SettleAcc     Ifne      *Blanks
     C     W_Type        Andeq     'TP'
 
     C     SettleType    Ifne      15
      **  Get Settlement Details.
     C                   Exsr      GetSetAc
     C                   Else                                                   192099
     C                   Movel     WW_AccNum     CustNo                                       206490
     C                   Movel     WW_AccCode    AccCode                        192099
     C                   Movel     WW_AccSeq     AccSeq                         192099
     C                   Endif
 
      **  Set up full account only if account details are available.
     C*****CustNo        Ifne      *zeros                                       Begin CustNo  CSD027
     C     CustNo        Ifne      *blanks                                      Begin CustNo  CSD027
     C                   Eval      W_Branch      = Branch
     C                   Move      CustNo        W_CustNo
     C                   Move      AccCode       W_AccCode
     C                   Move      AccSeq        W_AccSeq
     C                   Eval      W_PayFrSettAcc = W_FullSettlAcc
 
      **  Define key list to access to Account Master Details file.
     C     K_Accnt       Klist
     C                   Kfld                    CustNo
     C                   Kfld                    Currency
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
     C***********        Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in81
 
     C                   Eval      W_PayFrSettPor = A_PTFR
 
     C                   Endif                                                  End CustNo
     C                   Endif
 
      **--------- End of Pay From Settlement Full Account -----------**
 
      **-------- Start of Pay To Settlement Full Account ----------**
 
      **  Initialize Pay From Settlement Full Account.
     C                   Eval      W_PayToSettAcc = *blanks
     C                   Eval      W_PayToSettPor = *blanks
 
      **  Extract Pay To Branch Code.
     C                   Z-add     1             X
     C     'PYTA  '      Lookup    Arrfld(X)                              89
     C                   Eval      Branch = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo
 
      **  Extract Currency Code.
     C                   Z-add     1             X
     C*****'TNMC  '      Lookup    Arrfld(X)                              89    196853
     C     'SETC  '      Lookup    Arrfld(X)                              89    196853
     C                   Eval      Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Settlement Account.
     C                   Z-add     1             X
     C     'PAYT  '      Lookup    Arrfld(X)                              89
     C                   Eval      SettleAcc = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
     C     SettleAcc     Ifne      *Blanks
     C     W_Type        Andeq     'TS'
 
     C     SettleType    Ifne      15
      **  Get Settlement Details.
     C                   Exsr      GetSetAc
     C                   Else                                                   192099
     C                   Movel     WW_AccNum     CustNo                                       206490
     C                   Movel     WW_AccCode    AccCode                        192099
     C                   Movel     WW_AccSeq     AccSeq                         192099
     C                   Endif
 
      **  Set up full account only if account details are available.
     C*****CustNo        Ifne      *zeros                                       Begin CustNo  CSD027
     C     CustNo        Ifne      *blanks                                      Begin CustNo  CSD027
     C                   Eval      W_Branch      = Branch
     C                   Move      CustNo        W_CustNo
     C                   Move      AccCode       W_AccCode
     C                   Move      AccSeq        W_AccSeq
     C                   Eval      W_PayToSettAcc = W_FullSettlAcc
 
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
 
     C                   Eval      W_PayToSettPor = A_PTFR
 
     C                   Endif                                                  End CustNo
     C                   Endif
 
      **------------------ End of Additionnal fields ----------------**
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 05                                  * Db Error 05 *
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
 
     C                   Eval      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_NomCcyNbdp                     Nominal Dec Places
     C                                       + W_PayFrSettAcc                   Pay From Settl A/C
     C                                       + W_PayFrSettPor                   Pay From Settl A/C
     C                                       + W_PayToSettAcc                   Pay To   Settl A/C
     C                                       + W_PayToSettPor                   Pay To   Settl A/C
 
      **  Call a standard routine to actually send the message.
     C                   Callb     'RPSNDMSG'
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
 
     C                   Endif                                                  End W_SendMsg
 
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
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 06                                  * Db Error 06 *
     C                   Eval      DBkey  = 'RPC1305'                           ***************
     C                   Out       Lda
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
     C                   Eval      DBase  = 07                                  * Db Error 07 *
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
 
     C                   Clear                   ReturnCode
     C                   Callb     'ZAGETSETAC'
      **  Outputs
      **  -------
      **  Return code (10A).
     C                   Parm                    ReturnCode
      ****Account*code*(4,0S).*****************************************                       CGL029
      **  Account Code (10,0S).                                                               CGL029
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
     C                   Parm                    Currency
      **  Inputs
      **  ------
      **  Settlement type (2,0S)
     C                   Parm                    SettleType
      ****Settlement*account*(12A)*************************************                       CGL029
      **  Settlement Account (18A)                                                            CGL029
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
     C                   Eval      DBase  = 08                                  * Db Error 08 *
     C                   Eval      DBkey  = 'ZAGETSETAC'                        ***************
     C                   Out       LDA
     C                   Eval      ReturnCode = 'Error'
     C**********         Exsr      *Pssr                                                      CPB010
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
     C                   Eval      Dbase  = 09                                  * Db Error 09 *
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
      * *Pssr  - Program exception error routine                      *
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
      * Called at : program initialization time.                      *
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
 
      **  Get Securities Trading Data by using Access Object.
     C                   Callb     'AOSTRDR0'
     C                   Parm      *Blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_Optn
     C     Sdstrd        Parm      Sdstrd        Dssdy
 
      **  If Securities Trading Details do not exist, handle Database Error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDSTRDPD'                          ***************
     C                   Eval      DBase  = 10                                  * Db Error 10 *
     C                   Eval      DBkey  = '*FIRST'                            ***************
     C                   Out       Lda
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End P_Rtcd
 
      **  Get Private Banking details by using Access Object.
     C                   Callb     'AOTOFR0'
     C                   Parm      *Blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_Optn
     C     Sdtofd        Parm      Sdtofd        Dssdy
 
      **  If Private Banking details do not exist, handle Database Error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDTOFPD'                           ***************
     C                   Eval      DBase  = 11                                  * Db Error 11 *
     C                   Eval      DBkey  = '*FIRST'                            ***************
     C                   Out       Lda
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End P_Rtcd
 
     C                   Z-add     0             X                 3 0
 
      **  Retrieve position and length of customer number from TRADSD message data.
     C                   Eval      FieldName   = 'TCNR'
     C**********         Eval      FieldType   = 'N'                                        AR970292
     C                   Eval      FieldType   = 'A'                                        AR970292
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Order number from TRADSD message data.
     C                   Eval      FieldName   = 'ORDE'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Trade Reference from TRADSD message data.
     C                   Eval      FieldName   = 'TDRF'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Nomincal Currency from TRADSD message data.
     C                   Eval      FieldName   = 'TNMC'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay From Branch from TRADSD message data.
     C                   Eval      FieldName   = 'PYFA'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay From Branch from TRADSD message   196853
     C                   Eval      FieldName   = 'SETC'                         196853
     C                   Eval      FieldType   = 'A'                            196853
     C                   Exsr      RtvPos                                       196853
                                                                                196853
      **  Retrieve position and length of in/complete ind from TRADSD message   196903
     C                   Eval      FieldName   = 'TINC'                         196903
     C                   Eval      FieldType   = 'A'                            196903
     C                   Exsr      RtvPos                                       196903
                                                                                196903
      **  Retrieve position and length of RECI from TRADSD message              196903
     C                   Eval      FieldName   = 'RECI'                         196903
     C                   Eval      FieldType   = 'A'                            196903
     C                   Exsr      RtvPos                                       196903
                                                                                196903
      **  Retrieve position and length of Settlement Methode from TRADSD message data.
     C                   Eval      FieldName   = 'SMTH'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay From from TRADSD message data.
     C                   Eval      FieldName   = 'PYFM'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay To Branch TRADSD message data.
     C                   Eval      FieldName   = 'PYTA'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay To TRADSD message data.
     C                   Eval      FieldName   = 'PAYT'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Trade type from TRADSD message data.
     C                   Eval      FieldName   = 'TDTP'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *                                                                                       206491
      **  Retrieve position and length of Replication Flag from                               206491
      **  TRADSD message data.                                                                206491
      *                                                                                       206491
     C                   Eval      FieldName   = 'REPI'                                       206491
     C                   Eval      FieldType   = 'A'                                          206491
     C                   Exsr      RtvPos                                                     206491
 
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
