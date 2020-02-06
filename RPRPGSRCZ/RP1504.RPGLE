     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extraction Module for DEALSDB.')           *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1504 - Extract module for DEALSDB                          *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Purchase Currency Number of Decimal Places. *
      *                 - Sell     Currency Number of Decimal Places. *
      *                 - Receipt Settlement Account.                 *
      *                 - Receipt Settlement Account's Portf. Ref.    *
      *                 - Payment Settlement Account.                 *
      *                 - Payment Settlement Account's Portf. Ref.    *
      *                 - Front Office Id.                            *
      *                                                               *
      *  Component of: RP1504 - Extract program for DEALSDB           *
      *                                                               *
      *  (c)Finastra International Limited 2001                       *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 AR858264A          Date 16Jul12               *
      *                 AR970292           Date 14May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 03Oct03               *
      *                 223549             Date 03Dec03               *
      *                 CPB010             Date 16Jan03               *
      *                 CPB008             Date 26Nov02               *
      *                 207050             Date 21Aug02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  223549 - Reset portfolio reference of second settlement      *
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
      *           - Add fields to output message to avoid             *
      *             ODBC Client Access.                               *
      *  207050 - Do not send amend of transaction of swap            *
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
     F                                     INFSR(*Pssr)

      **  Midas FX Deals File
     FFXDEALLL  IF   E           K Disk
     F                                     INFSR(*Pssr)

      **  Midas GL Accounts Master
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
     F                                     Infsr(*Pssr)
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  CHAIN access to SDPBDSL0/ACCNT failed.                *
      *  82  -  CHAIN access to FXDEALLL failed.                      *
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

      **  The following /COPY contains various standard declares
     D**********/COPY RPCPYSRC,Std_Dcl                                                     AR858264A
     D/COPY RPCPYSRC,STD_DCL                                                               AR858264A

      **  The following /COPY contains the layout of the Meridian header as
      **  a data structure
     D**********/COPY RPCPYSRC,Mdn_Hd_DS                                                   AR858264A
     D/COPY RPCPYSRC,MDN_HD_DS                                                             AR858264A

      **  Following /COPY is the declares for fields passed to the formatting
      **  routines
     D/COPY RPCPYSRC,RPFMTDCL

      **  Following /COPY is the procedure prototype for the Packed routine
     D/COPY RPCPYSRC,RPFMTPPP

      **  Following /COPY is the procedure prototype for the Signed routine
     D/COPY RPCPYSRC,RPFMTPPS

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
     D Lda           E DS           256    Extname(LDA) Dtaara(LDA)
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
     D Apdump        E DS                  Extname(APDUMP) Dtaara(APDUMP)

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

      **  Data Structure for access to Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)

      **  Data Structure for access to Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)

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
      **  Field to replace function GetMIDASMMDealUser                                        CPB008
     D W_Fhluid        S              3A                                                      CPB008
     D W_Fhdusc        S              3A                                                      CPB008

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
      ** ---------- End of fields used by access programs -----------**

      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A

      **  End Position.
     D EndPosition     S              7S 0

      **  Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027

      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A

      **  Composite Data.
     D CompData        S                   LIKE(TransData)

      **----------------  Start of additional fields ----------------**
     D W_PurchCcyNbdp  S              1A
     D W_SellCcyNbdp   S              1A
     D*W_RecSettlAcc   S             18A                                                      CGL029
     D W_RecSettlAcc   S             24A                                                      CGL029
     D W_RecSettlPor   S              4A
     D*W_PaySettlAcc   S             18A                                                      CGL029
     D W_PaySettlAcc   S             24A                                                      CGL029
     D W_PaySettlPor   S              4A
     D W_FrontOffId    S             20A
      **-----------------  End of additional fields -----------------**

      **  True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off

      **  Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')

      **  Work field used for Purchase and Sell Currency
     D W_PurchCcy      S              3A
     D W_SellCcy       S              3A

      **  Work field used for change message type
     D W_PosFin        S              3S 0

     D A_DTYP          S              2A                                                      207050
     D A_FSLI          S              1A                                                      207050
     D A_RECI          S              1A                                                      207050
     D A_CHTP          S              1A                                                      207050
     D N_FSLI          S              1S 0                                                    207050
                                                                                              207050
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

      **  Extract custoner number from DEALSDB message data.
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
     C     BBCLST        Andne     'Y'                                                        223644
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDCUSTPD'                          ***************
     C                   Eval      DBase  = 01                                  * Db Error 01 *
     C                   Eval      DBkey  = P_Cust                              ***************
     C                   Out       Lda
     C                   Eval      ReturnCode  = P_RTCD
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
                                                                                              207050
      **  Extract deal type from DEALSDB message data.                                        207050
     C                   Z-add     1             X                                            207050
     C     'DTYP  '      Lookup    Arrfld(X)                              89                  207050
     C                   Eval      A_DTYP = %Subst(TransData:+                                207050
     C                             ArrPos(X):ArrLen(X))                                       207050
                                                                                              207050
      **  Extract 1st/2nd leg swap indicator from DEALSDB message data.                       207050
     C                   Z-add     1             X                                            207050
     C     'FSLI  '      Lookup    Arrfld(X)                              89                  207050
     C                   Eval      A_FSLI = %Subst(TransData:+                                207050
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))                            207050
     C                   Movel     A_FSLI        N_FSLI                                       207050
                                                                                              207050
      **  Extract RECI from DEALSDB message data.                                             207050
     C                   Z-add     1             X                                            207050
     C     'RECI  '      Lookup    Arrfld(X)                              89                  207050
     C                   Eval      A_RECI = %Subst(TransData:+                                207050
     C                             ArrPos(X):ArrLen(X))                                       207050
                                                                                              207050
      **  Extract CHTP from DEALSDB message data.                                             207050
     C                   Z-add     1             X                                            207050
     C     'CHTP  '      Lookup    Arrfld(X)                              89                  207050
     C                   Eval      A_CHTP = %Subst(TransData:+                                207050
     C                             ArrPos(X):ArrLen(X))                                       207050
                                                                                              207050
      **  If Swap and 1st leg: do not send it now!                                            207050
      **     Unless reversal or maturity of deal                                              207050
     C                   If        A_CHTP='R' or A_RECI='M'                                   207050
     C                   Else                                                                 207050
     C                   If        A_DTYP='SW' and N_FSLI=1                                   207050
     C                   Return                                                               207050
     C                   Endif                                                                207050
     C                   Endif                                                                207050
                                                                                              207050

      **----------------- Start of Additionnal fields ---------------**

      **----- Start of First Currency Number of Decimal Places ------**

      **  Extract Currency Code.
     C                   Z-add     1             X
     C     'PUCY  '      Lookup    Arrfld(X)                              89
     C                   Eval      Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                   Eval      W_PurchCcy  = Currency

      **  Retrieve first (purchase) currency number of decimal places.
     C                   Eval      P_Curr = W_PurchCcy
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_PurchCcyNbdp

      **------ End of First Currency Number of Decimal Places -------**

      **----- Start of Second Currency Number of Decimal Places -----**

      **  Extract Currency Code.
     C                   Z-add     1             X
     C     'SLCY  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_SellCcy = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))

      **  Retrieve second (sell) currency number of decimal places.
     C                   Eval      P_Curr = W_SellCcy
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_SellCcyNbdp

      **------ End of Second Currency Number of Decimal Places ------**

      **--------- Start of Receipt Settlement Full Account ----------**

      **  Initialize Receipt Settlement Full Account
     C                   Eval      W_RecSettlAcc = *blanks
     C                   Eval      W_RecSettlPor = *blanks

      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo

      **  Extract Purchase Currency Code.
     C                   Z-add     1             X
     C     'PUCY  '      Lookup    Arrfld(X)                              89
     C                   Eval      Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))

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
     C                   Eval      W_Currency    = Currency
     C                   Move      AccCode       W_AccCode
     C                   Move      AccSeq        W_AccSeq
     C                   Eval      W_RecSettlAcc = W_FullSettlAcc

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

     C                   Eval      W_RecSettlPor = A_PTFR

     C                   Endif                                                  End CustNo

      **---------- End of Receipt Settlement Full Account ------------**

      **--------- Start of Payment Settlement Full Account  ----------**

      **  Initialize Receipt Settlement Full Account
     C                   Eval      W_PaySettlAcc = *blanks
     C                   Eval      W_PaySettlPor = *blanks                                    223549

      **  Extract Customer Number.
     C                   Movel     P_Cust        CustNo

      **  Extract Sell Currency Code.
     C                   Z-add     1             X
     C     'SLCY  '      Lookup    Arrfld(X)                              89
     C                   Eval      Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))

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
     C                   Eval      W_Currency    = Currency
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
     C     K_Deal        Chain     FXDEALLL                           82

      **  If Deal do not exist, handle database error.
     C     *in82         Ifeq      True                                         Begin *in82
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'FXDEALPP'                          ***************
     C                   Eval      Dbase  = 05                                  * Db Error 05 *
     C                   Movel     P_Deal        Dbkey                          ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in82

     C                   Eval      W_FrontOffId = FHFRNT
     C                   Eval      W_Fhluid     = FHLUID                                      CPB008
     C                   Eval      W_Fhdusc     = FHDUSC                                      CPB008

      **---------- End of Front Office Id ---------------------------**

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

     C                   Eval      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_PurchCcyNbDp                   1rst Ccy Dec. Places
     C                                       + W_SellCcyNbDp                    2nd  Ccy Dec. Places
     C                                       + W_RecSettlAcc                    Receipt Settl. Acc.
     C                                       + W_RecSettlPor                    Receipt Settl. Portf
     C                                       + W_PaySettlAcc                    Payment Settl. Acc.
     C                                       + W_PaySettlPor                    Payment Settl. Portf
     C                                       + W_FrontOffId                     Front Office Id
     C                                       + W_Fhluid                         user          CPB008
     C                                       + W_Fhdusc                                       CPB008

      **------------------ End of Additionnal fields ----------------**

      **  Call a standard routine to actually send the message
     C                   CallB     'RPSNDMSG'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   Parm                    CompData
     C                   Parm                    CommitCtl
     C                   Parm                    ReturnCode

      **  If error then perform any special processing and exit.
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
      ****Account code (4,0S).                                                                CGL029
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
      ****Settlement account (12A)                                                            CGL029
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
      *
      * *Pssr  - Program exception error routine.                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by : (**calling routines**).                           *
      *                                                               *
      * Calls     : None.                                             *
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
     C                   Eval      DBpgm = PSProcName
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
      * *Inzsr - Program Initialisation routine.                      *
      *                                                               *
      * Called at : program initialization time.                      *
      *                                                               *
      * Calls     : None.                                             *
      *                                                               *
      *****************************************************************

     C     *Inzsr        Begsr

     C     *Entry        Plist
      **  MQSeries queue to write to - this parameter IS used in this module
     C                   Parm                    OutQueue
      **  Merdian header
     C                   Parm                    MdnHeadDS
      **  Transaction Data
     C                   Parm                    TransData
      **  Commitment control flag
     C                   Parm                    CommitCtl
      **  Return Code
     C                   Parm                    ReturnCode
     C                   Eval      MessageInd = 'Y'                                           CPB010

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

      **  Retrieve position and length of customer number from DEALSDB message data.
     C                   Eval      FieldName   = 'CNUM'
     C**********         Eval      FieldType   = 'N'                                        AR970292
     C                   EVAL      FieldType   = 'A'                                        AR970292
     C                   Exsr      RtvPos

      **  Retrieve position and length of Purchase Ccy from DEALSDB message data.
     C                   Eval      FieldName   = 'PUCY'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Sell Ccy from DEALSDB message data.
     C                   Eval      FieldName   = 'SLCY'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Our Receive Branch from DEALSDB message data.
     C                   Eval      FieldName   = 'ROBR'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Rcpt - Settl. Methode from DEALSDB message data.
     C                   Eval      FieldName   = 'RSTM'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Rcpt - Our nostro from DEALSDB message data.
     C                   Eval      FieldName   = 'RONS'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Our Pay Branch from DEALSDB message data.
     C                   Eval      FieldName   = 'POBR'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Pay Settl. Methode from DEALSDB message data.
     C                   Eval      FieldName   = 'PSTM'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Pay our Nostro Methode from DEALSDB message data.
     C                   Eval      FieldName   = 'PONS'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Deal Number from DEALSDB message data.
     C                   Eval      FieldName   = 'DLNO'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
                                                                                              207050
      **  Retrieve position and length of Deal type from DEALSDB message data.                207050
     C                   Eval      FieldName   = 'DTYP'                                       207050
     C                   Eval      FieldType   = 'A'                                          207050
     C                   Exsr      RtvPos                                                     207050
                                                                                              207050
      **  Retrieve position and length of First Leg from DEALSDB message data.                207050
     C                   Eval      FieldName   = 'FSLI'                                       207050
     C                   Eval      FieldType   = 'N'                                          207050
     C                   Exsr      RtvPos                                                     207050
                                                                                              207050
      **  Retrieve position and length of Change type from DEALSDB message data.              207050
     C                   Eval      FieldName   = 'CHTP'                                       207050
     C                   Eval      FieldType   = 'A'                                          207050
     C                   Exsr      RtvPos                                                     207050
                                                                                              207050
      **  Retrieve position and length of RECIfrom DEALSDB message data.                      207050
     C                   Eval      FieldName   = 'RECI'                                       207050
     C                   Eval      FieldType   = 'A'                                          207050
     C                   Exsr      RtvPos                                                     207050

      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1

     C                   Endsr
      /Eject
      *****************************************************************
**  Cpy@
(c)Finastra International Limited 2001
