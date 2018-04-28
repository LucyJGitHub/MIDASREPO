     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Extraction Module for LOAMSDK.')              *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1507 - Extract module for LOAMSDK                          *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Currency Number of Decimal Places.          *
      *                 - Our Settlement Account.                     *
      *                 - Our Settlement Account's Portfolio Ref.     *
      *                 - Payment Settlement Account.                 *
      *                 - Payment Settlement Account's Portfolio Ref. *
      *                                                               *
      *  Component of: RP1507 - Extract program for LOAMSDK           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR858264A          Date 16Jul12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 249091             Date 06Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 CPB010             Date 16Jan03               *
      *                 205682             Date 08May02               *
      *                 203613             Date 16May02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197920             Date 28Nov01               *
      *                 196083             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  249091 - To properly handle Base Rate Code Change and Spread *
      *           Interest Rate Change loan events, more specially    *
      *           base rate, rate and margin.                         *
      *           Add last interest payment date (same as RP1522).    *
      *           Add next interest payment date (similar to 246393). *
      *           Add margin and base rate.                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
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
      *  205682 - Review sending of loans,loan amendments,facilities  *
      *           with feature CLE002 - Lending Authorisation         *
      *  203613 - If amendment type is SC, default settl. instruction *
      *           based on original loan detail.                      *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  197920 - Ensure that MR/PI/PD are replicated for deletion.   *
      *  196083 - As there are some problems with filter (MDBASCRIPT),*
      *           ensure in the trigger that only records with CHTP   *
      *           equal to 'I' are taken into consideration.          *
      *           Fix to remove when Amend/Reverse of Loan Amendments *
      *           needed to be sent to TOF.                           *
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
 
      **  Midas GL Accounts Master
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
     F                                     Infsr(*Pssr)
                                                                                              203613
      **  Midas LE Loans File                                                                 203613
     FCLOAN     IF   E           K Disk    Ignore(CLOANHHF:CLOANCKF:CLOANZ1F)                 203613
     F                                     Prefix(C_) Infsr(*Pssr)                            203613
     F                                     Usropn                                             203613
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  CHAIN access to SDPBDSL0/ACCNT failed.                *
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
      *       * xx   82   83   84   85   86   87   88   89   90 *     *
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
      *  *inzsr   - Program Initialization routine.                   *
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
 
      ** Array containing Copyright statement
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
     D*W_FullSettlAcc  DS            18                                                       CGL029
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
 
      ** External data structure for Feature Details.
     D Scsard        E DS                  Extname(SCSARDPD)
 
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
                                                                                              205682
     D SDCLND        E DS                  Extname(SDCLNDPD)                                  205682
      ** DS for Customer Lending Details                                                      205682
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of Parameters --------------------**
      **  Output queue name.
     D OutQueue        S                   LIKE(MQSQueue)
      **--------------------- End of Parameters ---------------------**
 
      **-------------- Start of Parameters for ²PC1305 --------------**
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
      **---------------- Start of Parameters for CPB010 --------------**                      CPB010
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
     D CustNo          S              6A                                                      CSD027
      **  Settlement currency.
     D Currency        S              3A
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
      **  Amendment type                                                        197920
     D P_Amtp          S              2A                                        197920
      **  Last change type                                                      197920
     D P_Chtp          S              1A                                        197920
      ** ---------- End of fields used by access programs -----------**
 
      **  Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
                                                                                196083
      **  Work Field used to retrieve the Operation                             196083
     D W_Operation     S              2A                                        196083
 
      **  Work Field used for EMU feature CEU004.
     D CEU004          S              1A
                                                                                              205682
      **  Work Fields used for Lending.                                                       205682
     D CLE002          S              1A                                                      205682
     D CLE105          S              1A                                                      205682
     D W_Send          S              1A                                                      205682
     D W_Status        S              1A                                                      205682
     D W_User          S             10A                                                      205682
     D W_Record        S              1A                                                      205682
                                                                                              249091
      **  Work fields used for new rate spread (loan event 'SC').                             249091
     D W_NewSpreadNum  S             12S 7                                                    249091
     D W_NewSpreadAlp  S             12A                                                      249091
                                                                                              249091
      **  Work Field used to store next interest payment date.                                249091
     D W_NIDT          S              5  0                                                    249091
 
      **----------------  Start of additional fields ----------------**
     D W_TransCcyNbdp  S              1A
     D*W_OurSettAc     S             18A                                                      CGL029
     D W_OurSettAc     S             24A                                                      CGL029
     D W_OurSettPo     S              4A
     D*W_PaySettAc     S             18A                                                      CGL029
     D W_PaySettAc     S             24A                                                      CGL029
     D W_PaySettPo     S              4A
     D W_LastIntDate   S              7A                                                      249091
     D W_NextIntDate   S              7A                                                      249091
     D W_Margin        S             13A                                                      249091
     D W_BaseRate      S             13A                                                      249091
      **-----------------  End of additional fields -----------------**
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **   Composite Data
     D CompData        S                   LIKE(TransData)
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      **  Work field used for currency
     D W_TransCcy      S              3A
 
      **  Work field used for change message type
     D W_PosFin        S              3S 0
      **  Loan.                                                                               203613
     D P_Loan          S              6A                                                      203613
 
     D K_Loan          S              6A                                                      CLE148
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
                                                                                196083
      **  Retrieve operation in message.                                        196083
     C                   Eval      W_Operation = %subst(TransData:1:2)          196083
      **  Extract loan amendment typ e from LOAMSDK                             197920
     C                   Z-add     1             X                              197920
     C     'AMTP  '      Lookup    Arrfld(X)                              89    197920
     C                   Eval      P_Amtp = %Subst(TransData:+                  197920
     C                             ArrPos(X):ArrLen(X))                         197920
      **  Extract last change type from LOAMSDK                                 197920
     C                   Z-add     1             X                              197920
     C     'CHTP  '      Lookup    Arrfld(X)                              89    197920
     C                   Eval      P_Chtp = %Subst(TransData:+                  197920
     C                             ArrPos(X):ArrLen(X))                         197920
                                                                                              205682
      **  Extract Authorise User.                                                             205682
     C                   Z-add     1             X                                            205682
     C     'XUSR  '      Lookup    Arrfld(X)                              89                  205682
     C                   Eval      W_User = %Subst(TransData:+                                205682
     C                             ArrPos(X):ArrLen(X))                                       205682
                                                                                197920
     C     W_Operation   Ifeq      'I '                                         197920
     C     W_Operation   OReq      'A '                                         197920
     C     P_CHTP        Andeq     'R'                                          197920
     C     P_Amtp        Andeq     'MR'                                         197920
     C     W_Operation   OReq      'A '                                         197920
     C     P_CHTP        Andeq     'R'                                          197920
     C     P_Amtp        Andeq     'PI'                                         197920
     C     W_Operation   OReq      'A '                                         197920
     C     P_CHTP        Andeq     'R'                                          197920
     C     P_Amtp        Andeq     'PD'                                         197920
     C     W_Operation   OReq      'A '                                                       205682
     C     W_User        Andne     *blanks                                                    205682
     C     CLE002        Andeq     'Y'                                                        205682
 
      **  Extract custoner number from LOAMSDK message data.
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
     C     *Lock         In        Lda
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
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer.
     C                   If            BBPRBA = 'Y'                             Begin BBPRBA
     C                             Or  PBREPB = 'Y'
                                                                                              205682
     C                   Eval      W_Send = 'Y'                                               205682
                                                                                              205682
      **  If features CLE105 - New Maint. Funct - Enhanced Lending Input                      205682
      **              CLE002 - Authorizations                                                 205682
      **  And ICD Field from PF/SDCLNDPD 'Loans Amend. to be authorized' is 'Y'               205682
     C                   If            CLE105 = 'Y'                                           205682
     C                             And CLE002 = 'Y'                                           205682
     C                             And BPLMAU = 'Y'                                           205682
                                                                                              205682
      **  Extract Loan Status Indicator.                                                      205682
     C                   Z-add     1             X                                            205682
     C     'ASTS  '      Lookup    Arrfld(X)                              89                  205682
     C                   Eval      W_Status = %Subst(TransData:+                              205682
     C                             ArrPos(X):ArrLen(X))                                       205682
                                                                                              205682
      **  If loan status indicator is not 'A', do not send the message !                      205682
     C                   If            W_Status <> 'A'                                        205682
     C                   Eval      W_send = 'N'                                               205682
     C                   Else                                                                 205682
                                                                                              205682
      **  Extract Record Id.                                                                  205682
     C                   Z-add     1             X                                            205682
     C     'RECI  '      Lookup    Arrfld(X)                              89                  205682
     C                   Eval      W_Record = %Subst(TransData:+                              205682
     C                             ArrPos(X):ArrLen(X))                                       205682
                                                                                              205682
      **  If it's a reverse, ensure loan was previously authorised (XUSR <> '')               205682
     C                   If            W_Record = 'R'                                         205682
                                                                                              205682
      **  Loan not previously authorised, do not send the message !                           205682
     C                   If            W_User = *blanks                                       205682
     C                   Eval      W_send = 'N'                                               205682
     C                   Endif                                                                205682
                                                                                              205682
     C                   Endif                                                                205682
     C                   Endif                                                                205682
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
     C                   If            W_Send = 'Y'                                           205682
 
      **----------------- Start of Additionnal fields ---------------**
 
      **--------------- Start of Transaction Currency ---------------**
      **                   Number of Decimal Places                  **
 
      **  Extract Currency Code.
     C                   Z-add     1             X
     C     'CCY   '      Lookup    Arrfld(X)                              89
     C                   Eval      W_TransCcy = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Retrieve currency number of decimal places.
     C                   Eval      P_Curr = W_TransCcy
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_TransCcyNbdp
 
      **--------- End of Currency Number of Decimal Places ----------**
 
      **------------- Start of Our Settlement Account ---------------**
 
      **  Initialize Our Settlement Full Account.
     C                   Eval      W_OurSettAc = *blanks
     C                   Eval      W_OurSettPo = *blanks
 
      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo
 
      **  Extract Currency Code.
      **  If EMU is installed, use Settlement Currency if entered.
     C                   Eval      FieldValue  = *blanks
     C     CEU004        Ifeq      'Y'                                          Begin CEU004
     C                   Z-add     1             X
     C     'SCCY  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                   Endif                                                  End CEU004
 
      **  If EMU is not installed or Settlement currency not used,
      **  extract currency of transaction.
     C     FieldValue    Ifeq      *blanks                                      Begin FieldValue
     C                   Z-add     1             X
     C     'CCY   '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                   Endif                                                  End FieldValue
 
     C                   Eval      Currency    = FieldValue
     C                   Eval      W_Currency  = FieldValue
 
      **  Extract Branch Code.
     C                   Z-add     1             X
     C     'OSBR  '      Lookup    Arrfld(X)                              89
     C                   Eval      Branch = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
                                                                                              203613
      **  Access to Loan details to get at least last and next interest                       249091
      **  dates, whatever loan event it is.                                                   249091
     C**********         If        P_Amtp= 'SC'                                        203613 249091
                                                                                              203613
      **  Extract loan number from CLOANCL message data.                                      203613
     C                   Z-add     1             X                                            203613
     C     'LNRF  '      Lookup    Arrfld(X)                              89                  203613
     C**********         Eval      P_Loan = %Subst(TransData:+                         203613 CLE148
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                     203613 CLE148
     C                   Eval      P_Loan = %Subst(TransData:+                                CLE148
     C                             ArrPos(X):ArrLen(X))                                       CLE148
     C**********         Movel     P_Loan        K_Loan            6 0                 203613 CLE148
     C                   MOVEL     P_Loan        K_Loan                                       CLE148
     C                   Open      CLOAN                                                      203613
      **  Retrieve Loan details                                                               203613
     C     K_Loan        Chain     CLOAN                              81                      203613
     C                   Close     CLOAN                                                      203613
                                                                                              203613
      **  If Loan does not exist, handle database error.                                      203613
     C     *in81         Ifeq      True                                         Begin *in81   203613
     C     *lock         In        Lda                                                        203613
     C                   Eval      Dbpgm  = PSProcName                                        203613
     C                   Eval      Dbfile = 'CLOAN'                             **************203613
     C                   Eval      Dbase  = 05                                  * Db Error 05 203613
     C                   Movel     P_Loan        Dbkey                          **************203613
     C                   Out       LDA                                                        203613
     C                   Eval      ReturnCode  = W_NoRcdFnd                                   203613
     C**********         Exsr      *Pssr                                               203613 CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                                203613
     C**********         EndIf                                                         203613 249091
 
      **  Extract Settlement Method.
     C                   Z-add     1             X
     C     'SETP  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   Movel     FieldValue    SettleType
 
      **  Extract Settlement Account.
     C                   Z-add     1             X
     C     'OSAC  '      Lookup    Arrfld(X)                              89
     C                   Eval      SettleAcc = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                                                                                        203613
     C                   If        P_Amtp = 'SC'                                              203613
     C                             or P_Amtp= 'BC'                                            249091
     C                   Movel     C_PONS        SettleAcc                                    203613
     C                   Movel     C_PSTM        SettleType                                   203613
     C                   Movel     C_BRCA        Branch                                       203613
     C                   EndIf                                                                203613
 
      **  Get Settlement Details.
     C                   Exsr      GetSetAc
 
      **  Set up full account only if account details are available.
     C*****CustNo        Ifne      *zeros                                       Begin CustNo  CSD027
     C     CustNo        Ifne      *blanks                                      Begin CustNo  CSD027
     C                   Eval      W_Branch      = Branch
     C                   Move      CustNo        W_CustNo
     C                   Move      AccCode       W_AccCode
     C                   Move      AccSeq        W_AccSeq
     C                   Eval      W_OurSettAc = W_FullSettlAcc
 
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
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in81
 
     C                   Eval      W_OurSettPo = A_PTFR
 
     C                   Endif                                                  End CustNo
 
      **-------------- End of Our Settlement Account ----------------**
 
      **------------- Start of Pay Settlement Account ---------------**
 
      **  Initialize Pay Settlement Full Account.
     C                   Eval      W_PaySettAc = *blanks
     C                   Eval      W_PaySettPo = *blanks
 
      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo
 
      **  Extract Branch Code.
     C                   Z-add     1             X
     C     'BRCA  '      Lookup    Arrfld(X)                              89
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
     C                                                                                        203613
     C                   If        P_Amtp =  'SC'                                             203613
     C                   Movel     C_PONS        SettleAcc                                    203613
     C                   Movel     C_PSTM        SettleType                                   203613
     C                   Movel     C_BRCA        Branch                                       203613
     C                   EndIf                                                                203613
 
      **  Get Settlement Details.
     C                   Exsr      GetSetAc
 
      **  Set up full account only if account details are available.
     C*****CustNo        Ifne      *zeros                                       Begin CustNo  CSD027
     C     CustNo        Ifne      *blanks                                      Begin CustNo  CSD027
     C                   Eval      W_Branch      = Branch
     C                   Move      CustNo        W_CustNo
     C                   Move      AccCode       W_AccCode
     C                   Move      AccSeq        W_AccSeq
     C                   Eval      W_PaySettAc = W_FullSettlAcc
 
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
 
     C                   Eval      W_PaySettPo = A_PTFR
 
     C                   Endif                                                  End CustNo
 
      **------- End of Maturity Date Settlement Full Account --------**
 
      **--------- Start of Last Interest Payment Date --------------**                        249091
                                                                                              249091
     C                   Eval      W_LastIntDate = *blanks                                    249091
     C                   Eval      fmLength = 5                                               249091
     C                   Eval      fmDecPos = 0                                               249091
     C                   Eval      fmPack3010 = C_SLID                                        249091
     C                   Eval      fmAlpNum32  =                                              249091
     C                                ProcPacked(fmPack3010 : fmLength :                      249091
     C                                           fmDecPos : fmDecSep :                        249091
     C                                           fmShwPsSgn)                                  249091
     C                   Eval      W_LastIntDate = %Subst(fmAlpNum32 : 1 : 7)                 249091
                                                                                              249091
      **---------- End of Last Interest Payment Date ---------------**                        249091
                                                                                              249091
      **--------- Start of Next Interest Payment Date --------------**                        249091
                                                                                              249091
     C                   Eval      W_NextintDate = *blanks                                    249091
     C                   Eval      fmLength = 5                                               249091
     C                   Eval      fmDecPos = 0                                               249091
                                                                                              249091
     C                   If        C_MDAT > 0 and C_NIDT > C_MDAT                             249091
     C                   Eval      W_NIDT = C_MDAT                                            249091
                                                                                              249091
     C                   Else                                                                 249091
     C                   Eval      W_NIDT = C_NIDT                                            249091
                                                                                              249091
     C                   Endif                                                                249091
     C                   Eval      fmPack3010 = W_NIDT                                        249091
     C                   Eval      fmAlpNum32  =                                              249091
     C                                ProcPacked(fmPack3010 : fmLength :                      249091
     C                                           fmDecPos : fmDecSep :                        249091
     C                                           fmShwPsSgn)                                  249091
     C                   Eval      W_NextIntDate = %Subst(fmAlpNum32 : 1 : 7)                 249091
                                                                                              249091
      **---------- End of Next Interest Payment Date ---------------**                        249091
                                                                                              249091
      **------------ Start of margin for loan event 'BC' ------------**                       249091
                                                                                              249091
     C                   Eval      W_Margin = *blanks                                         249091
     C                   If        P_Amtp =  'BC'                                             249091
     C                   Eval      fmLength = 11                                              249091
     C                   Eval      fmDecPos = 7                                               249091
     C                   Eval      fmPack3010 = C_RTSP                                        249091
                                                                                              249091
      ** Sign margin depending on Rate Spread Indicator.                                      249091
     C                   If        C_SPIN = 'D'                                               249091
     C                   Mult      -1            fmPack3010                                   249091
                                                                                              249091
     C                   EndIf                                                                249091
                                                                                              249091
     C                   Eval      fmAlpNum32  =                                              249091
     C                                ProcPacked(fmPack3010 : fmLength :                      249091
     C                                           fmDecPos : fmDecSep :                        249091
     C                                           fmShwPsSgn)                                  249091
     C                   Eval      W_Margin = %Subst(fmAlpNum32 : 1 : 13)                     249091
                                                                                              249091
     C                   EndIf                                                                249091
                                                                                              249091
      **------------- End of margin for loan event 'BC' -------------**                       249091
                                                                                              249091
      **----------- Start of base rate for loan event 'SC' ----------**                       249091
     C                   Eval      W_BaseRate = *blanks                                       249091
     C                   If        P_Amtp =  'SC'                                             249091
     C                   Eval      fmLength = 11                                              249091
     C                   Eval      fmDecPos = 7                                               249091
     C                   Eval      fmPack3010 = C_BRTE                                        249091
     C                   Eval      fmAlpNum32  =                                              249091
     C                                ProcPacked(fmPack3010 : fmLength :                      249091
     C                                           fmDecPos : fmDecSep :                        249091
     C                                           fmShwPsSgn)                                  249091
     C                   Eval      W_BaseRate = %Subst(fmAlpNum32 : 1 : 13)                   249091
                                                                                              249091
      ** Sign new rate spread depending on Rate Spread Indicator.                             249091
     C                   If        C_SPIN = 'D'                                               249091
     C                   Eval      fmLength = 11                                              249091
     C                   Eval      fmDecPos = 7                                               249091
                                                                                              249091
      **  Extract new rate spread from LOAMSDK message data.                                  249091
     C                   Z-add     1             X                                            249091
     C     'RTSP  '      Lookup    Arrfld(X)                              89                  249091
     C                   Eval      W_NewSpreadAlp                                             249091
     C                             = %Replace('':                                             249091
     C                                  %Subst(Transdata:                                     249091
     C                                         ArrPos(X):                                     249091
     C                                         ArrLen(X)):                                    249091
     C                                  %Scan(RCDECSEP:                                       249091
     C                                        %Subst(Transdata:                               249091
     C                                               ArrPos(X):                               249091
     C                                               ArrLen(X))):                             249091
     C                                  1)                                                    249091
                                                                                              249091
     C                   Move      W_NewSpreadAlpW_NewSpreadNum                               249091
     C                   Mult      -1            W_NewSpreadNum                               249091
     C                   Eval      fmPack3010  = W_NewSpreadNum                               249091
     C                   Eval      fmAlpNum32  =                                              249091
     C                                ProcPacked(fmPack3010 : fmLength :                      249091
     C                                           fmDecPos : fmDecSep :                        249091
     C                                           fmShwPsSgn)                                  249091
     C                   Eval      %Subst(TransData:ArrPos(X):+                               249091
     C                             ArrLen(X)+2) = %Subst(fmAlpNum32 : 1 : 13)                 249091
                                                                                              249091
     C                   EndIf                                                                249091
                                                                                              249091
     C                   EndIf                                                                249091
                                                                                              249091
      **------------ End of base rate for loan event 'SC' -----------**                       249091
                                                                                              249091
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
     C                                       + W_TransCcyNbdp                   Number Dec. Places
     C                                       + W_OurSettAc                      Start Date Settl A/C
     C                                       + W_OurSettPo                      Start Date Settl Ptf
     C                                       + W_PaySettAc                      Matur Date Settl A/C
     C                                       + W_PaySettPo                      Matur Date Settl Ptf
     C                                       + W_LastIntDate                    Last Int. Date249091
     C                                       + W_NextIntDate                    Next Int. Date249091
     C                                       + W_Margin                         Margin        249091
     C                                       + W_BaseRate                       Base Rate     249091
 
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
                                                                                              205682
     C                   Endif                                                                205682
 
     C                   Endif                                                  End BBPRBA
                                                                                196083
     C                   Endif                                                  196083
 
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
     C                   Parm                    Currency
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
     C     *lock         in        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 08                                  * Db Error 08 *
     C                   Eval      DBkey  = 'ZAGETSETAC'                        ***************
     C                   Out       Lda
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
     C****               Exsr      *Pssr                                                      CPB010
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
      * *INZSR - Program Initialisation routine                       *
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
     C                   Eval      DBase  = 10                                  * Db Error 10 *
     C                   Eval      DBkey  = P_Sard                              ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = 'Error'
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End P_Rtcd
 
      **  If feature is installed.
     C     P_Rtcd        Ifeq      *blanks                                      Begin P_Rtcd
     C                   Eval      CEU004 = 'Y'
 
     C                   Endif                                                  End P_Rtcd
                                                                                              205682
      **  Check if CLE105 (Lending) is installed.                                             205682
     C                   Eval      CLE105 = 'N'                                               205682
     C                   Callb     'AOSARDR0'                                                 205682
     C                   Parm      *blanks       P_Rtcd                                       205682
     C                   Parm      '*VERIFY'     P_Optn                                       205682
     C                   Parm      'CLE105'      P_Sard                                       205682
     C     Scsard        Parm      Scsard        Dsfdy                                        205682
                                                                                              205682
      **  If any error occurred when checking feature.                                        205682
     C     P_Rtcd        Ifne      *blanks                                                    205682
     C     P_Rtcd        andne     '*NRF   '                                                  205682
     C     *lock         in        Lda                                                        205682
     C                   Eval      DBpgm  = PSProcName                                        205682
     C                   Eval      DBfile = 'SCSARDPD'                                        205682
     C                   Eval      DBase  = 11                                                205682
     C                   Eval      DBkey  = P_Sard                                            205682
     C                   Out       Lda                                                        205682
     C                   Eval      ReturnCode = 'Error'                                       205682
     C**********         Exsr      *Pssr                                               205682 CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
      **  If feature is installed.                                                            205682
     C     P_Rtcd        Ifeq      *blanks                                                    205682
     C                   Eval      CLE105 = 'Y'                                               205682
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
      **  Check if CLE002 (Lending) is installed.                                             205682
     C                   Eval      CLE002 = 'N'                                               205682
     C                   Callb     'AOSARDR0'                                                 205682
     C                   Parm      *blanks       P_Rtcd                                       205682
     C                   Parm      '*VERIFY'     P_Optn                                       205682
     C                   Parm      'CLE002'      P_Sard                                       205682
     C     Scsard        Parm      Scsard        Dsfdy                                        205682
                                                                                              205682
      **  If any error occurred when checking feature.                                        205682
     C     P_Rtcd        Ifne      *blanks                                                    205682
     C     P_Rtcd        andne     '*NRF   '                                                  205682
     C     *lock         in        Lda                                                        205682
     C                   Eval      DBpgm  = PSProcName                                        205682
     C                   Eval      DBfile = 'SCSARDPD'                                        205682
     C                   Eval      DBase  = 12                                                205682
     C                   Eval      DBkey  = P_Sard                                            205682
     C                   Out       Lda                                                        205682
     C                   Eval      ReturnCode = 'Error'                                       205682
     C**********         Exsr      *Pssr                                               205682 CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
      **  If feature is installed.                                                            205682
     C     P_Rtcd        Ifeq      *blanks                                                    205682
     C                   Eval      CLE002 = 'Y'                                               205682
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
      **  Access Customer Lending Data                                                        205682
     C                   If            CLE002 = 'Y'                                           205682
                                                                                              205682
     C                   Call      'AOCLNDR0'                                                 205682
     C                   Parm      *blanks       P_Rtcd                                       205682
     C                   Parm      '*VERIFY'     P_Optn                                       205682
     C*****SDCLND        Parm      SDCLND        Dsfdy                                 205682 CLE134
     C     SDCLND        Parm      SDCLND        Dssdy                                        CLE134
                                                                                              205682
      **  If any error occurred when checking feature.                                        205682
     C     P_Rtcd        Ifne      *blanks                                                    205682
     C     *lock         in        Lda                                                        205682
     C                   Eval      DBpgm  = PSProcName                                        205682
     C                   Eval      DBfile = 'SDCLNDPD'                                        205682
     C                   Eval      DBase  = 13                                                205682
     C                   Eval      DBkey  = '*First'                                          205682
     C                   Out       Lda                                                        205682
     C                   Eval      ReturnCode = 'Error'                                       205682
     C**********         Exsr      *Pssr                                               205682 CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              205682
     C                   Endif                                                                205682
     C                   Endif                                                                205682
 
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
 
     C                   Z-add     0             X                 3 0
 
      **  Retrieve position and length of customer number from LOAMSDK message data.
     C                   Eval      FieldName   = 'CNUM'
     C**********         Eval      FieldType   = 'N'                                        AR970292
     C                   EVAL      FieldType   = 'A'                                        AR970292
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of change type                           197920
     C                   Eval      FieldName   = 'CHTP'                         197920
     C                   Eval      FieldType   = 'A'                            197920
     C                   Exsr      RtvPos                                       197920
                                                                                197920
      **  Retrieve position and length of Amendment type                        197920
     C                   Eval      FieldName   = 'AMTP'                         197920
     C                   Eval      FieldType   = 'A'                            197920
     C                   Exsr      RtvPos                                       197920
                                                                                197920
      **  Retrieve position and length of currency from LOAMSDK message data.
     C                   Eval      FieldName   = 'CCY'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of settlement currency from LOAMSDK message data.
     C                   Eval      FieldName   = 'SCCY'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Our settlement branch from LOAMSDK message data.
     C                   Eval      FieldName   = 'OSBR'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of settlement type from LOAMSDK message data.
     C                   Eval      FieldName   = 'SETP'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Our settle. A/C from LOAMSDK message data.
     C                   Eval      FieldName   = 'OSAC'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Branch Code from LOAMSDK message data.
     C                   Eval      FieldName   = 'BRCA'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay Settle. Methode from LOAMSDK message data.
     C                   Eval      FieldName   = 'PSTM'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Pay our Nostro from LOAMSDK message data.
     C                   Eval      FieldName   = 'PONS'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
                                                                                              203613
      **  Retrieve position and length of Loan number from LOAMSDK message data.              203613
     C                   Eval      FieldName   = 'LNRF'                                       203613
     C**********         Eval      FieldType   = 'N'                                   203613 CLE148
     C                   Eval      FieldType   = 'A'                                          CLE148
     C                   Exsr      RtvPos                                                     203613
                                                                                              205682
      **  Retrieve position and length of Loan Status Indicator from LOAMSDK                  205682
     C                   Eval      FieldName   = 'ASTS'                                       205682
     C                   Eval      FieldType   = 'A'                                          205682
     C                   Exsr      RtvPos                                                     205682
                                                                                              205682
      **  Retrieve position and length of Authorise user profile from LOAMSDK                 205682
     C                   Eval      FieldName   = 'XUSR'                                       205682
     C                   Eval      FieldType   = 'A'                                          205682
     C                   Exsr      RtvPos                                                     205682
                                                                                              205682
      **  Retrieve position and length of Record Id from LOAMSDK                              205682
     C                   Eval      FieldName   = 'RECI'                                       205682
     C                   Eval      FieldType   = 'A'                                          205682
     C                   Exsr      RtvPos                                                     205682
                                                                                              249091
      **  Retrieve position and length of Rate/spread from LOAMSDK message data.              249091
     C                   Eval      FieldName   = 'RTSP'                                       249091
     C                   Eval      FieldType   = 'N'                                          249091
     C                   Exsr      RtvPos                                                     249091
 
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
