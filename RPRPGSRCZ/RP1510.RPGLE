     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extraction Module for OTPAYDD.')           *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1510 - Extract module for OTPAYDD                          *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Settlement currency number decimal places.  *
      *                 - Ordering customer settlement account.       *
      *                 - Ordering customer settl. account's Portf.   *
      *                 - Outgoing Payments Details Extension File    *                       222761
      *                                                               *
      *  Component of: RP1510 - Extract program for OTPAYDD           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR858264A          Date 16Jul12               *
      *                 AR983495           Date 05Jun12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25864           Date 04Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15105A          Date 25Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243947             Date 08Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 222761             Date 20Jun03               *
      *                 215305             Date 01Apr03               *
      *                 CPB010             Date 16Jan03               *
      *                 212012             Date 18Dec02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 199266             Date 28Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR983495 - Missing fixes in some replication trigger         *
      *             programs for TOF (Child: AR983496)                *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  BUG25864 - Recompiled in effect of CSW209 changes in LFs     *
      *             OTPAYXL0 and INPAYXL0                             *
      *  BUG15105A - Missing Process for SWIFT 2007 (Reopen)          *
      *  243947 - Change set up of outgoing message if CFT014 is off  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  222761 - Touch of Finance and MT103 Swift Changes.           *
      *           Add Outgoing Payment Detail Ext. File at end of Msg *
      *           Description of OTPAYXPD must be added in RPMSGFPD.  *
      *           (Mandatory with PBS 3.08.00)                        *
      *  215305 - With new feature CFT014 - "Phase 2 MT103 for Funds  *
      *           Transfer", some new charges have been added and     *
      *           must be sent to TOF.                                *
      *  CPB010 - Avoid DB Error by write message in Repair File      *
      *           Execute Subroutine Repair instead of *Pssr in case  *
      *              of database error.                               *
      *           Two possibility, message can be repair or not:      *
      *               Set MessageInd to 'Y' in case of repair or 'N'  *
      *           If the message is associated to an other messages   *
      *           like xxx_B and xxx_After, xxx_B must be setup       *
      *           in the associated messages and _After is the master.*
      *           To manage the repair messages, call RPC1492.        *
      *  212012 - Complete Nostro Correspondent details               *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  199266 - When ordering type is nostro, change ordering bank  *
      *           to have 2 characters. If retail, keep only 10 first *
      *           characters.                                         *
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
                                                                                              215305
      **  Midas FT Outgoing Payments Details Extension                                        215305
     FOTPAYXL0  IF   E           K Disk                                                       215305
     F                                     Infsr(*Pssr)                                       215305
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
      *  RtvPos     - retrieve position in Meridian message.          *
      *  Repair   - Repair process                                    *                       CPB010
      *  WrtTrace - Trace process                                     *                       CPB010
      *  GetFTSetAc - Get Funds Transfer Settlement Account Details.  *
      *  *Pssr      - Program exception error routine                 *
      *  *Inzsr     - Program Initialization routine.                 *
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
                                                                                              222761
      ** Procedure prototype for the Format routine that is used to                           222761
      ** process an entire record                                                             222761
     D/COPY RPCPYSRC,RPFMTPPF                                                                 222761
 
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
 
      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  External Data structure for Run Date Informations.
     D RUNDAT        E DS                  Extname(RUNDAT) Dtaara
 
      **-------------- Start of parameters for RP1431 ---------------**
     D GetFTSacParm    DS            98
      **  ------
      **  Inputs
      **  ------
      **  Customer.
     D  Customer       S             35A
      **  Bank.
     D**Bank********   S             35A                                                     199266
     D BankDS          DS            35                                                      199266
     D   Bank                  1     35                                                      199266
     D   BankNostro            3     35                                                      199266
     D   BankRetail           11     35                                                      199266
      **  ------------
      **  Input/output
      **  ------------
      **  Currency.
     D  Currency       S              3A
      **  -------
      **  Outputs
      **  -------
      **  Branch code.
     D  BranchCode     S              3A
      **  Account sequence.
     D**CustNumber     S              6S 0                                                    CSD027
     D  CustNumber     S              6A                                                      CSD027
      **  Account Code.
     D**AccountCode    S              4S 0                                                    CGL029
     D  AccountCode    S             10S 0                                                    CGL029
      **  Account Sequence.
     D  AccountSeq     S              2S 0
 
      **--------------- End of parameters for RP1431 ----------------**
      **  Last Change Type.
     D  ChangeType     S              1A
      **  Front Office Id.
     D  FrontId        S             20A
     D  W_FrontId      S              2A
     D TmpCustomer     S             35A                                                   BUG15105A
     D ORCT            S              1A                                                   BUG15105A
 
      **  Data structure used to group settlement account details.
     D*W_FullSettAcc   DS            18                                                       CGL029
     D W_FullSettAcc   DS            24                                                       CGL029
     D   W_BranchCode          1      3
     D   W_CustNumber          4      9
     D   W_Currency           10     12
     D   W_AccCode            13     22                                                       CGL029
     D   W_AccSequ            23     24                                                       CGL029
     D***W_AccCode            13     16                                                       CGL029
     D***W_AccSequ            17     18                                                       CGL029
                                                                                              212012
      **  Data structure used for address data structure                                      212012
      *                                                                                       212012
     D W8FT            DS           128                                                       212012
      * Currency                                                                              212012
     D   W8CCY                 1      3                                                       212012
      * Settlement Type                                                                       212012
     D   W8STMT                4      5                                                       212012
      * Mandatory Text - convert BIC identifiers                                              212012
     D   W8MTXT                6      6                                                       212012
      * Message Tag                                                                           212012
     D   W8MTAG                7     11                                                       212012
      * Construct of data in field                                                            212012
     D   W8TYPE               12     12                                                       212012
      * Number of Lines available                                                             212012
     D   W8NLIN               13     14  0                                                    212012
      * Network and Message Type                                                              212012
     D   W8NWRK               15     20                                                       212012
     D   W8MTPY               21     23                                                       212012
      * Calling Program                                                                       212012
     D   W8CPGM               24     33                                                       212012
      * Action *PRINT/*ENQ/*MSG GEN                                                           212012
     D   W8ACT                34     41                                                       212012
      * Critical reporting - Database error if 'Y'                                            212012
      * If no BIC directory and BIC entered no error                                          212012
     D   W8CRIT               42     42                                                       212012
      * Force Midas Address - where possible                                                  212012
     D   W8MADD               43     43                                                       212012
      * If Retail get first address from account                                              212012
     D   W8RTAD               44     44                                                       212012
      * Alternative Address                                                                   212012
     D   W8ALIN               45     45                                                       212012
      * Address type selected in W0MSG                                                        212012
     D   W8ADTP               46     46                                                       212012
      *                                                                                       212012
      ** DS for Redefining Address Fields                                                     212012
     D                 DS                                                                     212012
     D  WADDRSS                1    175                                                       212012
     D  WADCHK1                1     35                                                       212012
     D  WADCHK2               36     70                                                       212012
     D  WADCHK3               71    105                                                       212012
     D  WADCHK4              106    140                                                       212012
     D  WADCHK5              141    175                                                       212012
                                                                                              215305
     D WPAYREF         S             15A                                                      215305
     D WCHARGE         S             11S 0                                                    215305
     D WCHARGE_A       S             11A                                                      215305
 
      ** Data Structure for access to Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      ** Data Structure for access to Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
                                                                                              212012
      ** External data structure for Feature Details.                                         212012
     D Scsard        E DS                  Extname(SCSARDPD)                                  212012
 
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
                                                                                              222761
      **  Structure based on the Outgoing Payments Details Extension                          222761
      **  file used to pass data to procedure ProcFormat.                                     222761
     D OtpayxDS      E DS                  Extname(OTPAYXPD)                                  222761
                                                                                              222761
      **  Structure to receive a formatted Outgoing Payments Details                          222761
      **  record from procedure ProcFormat.                                                   222761
      **  OtpayxPosA (and OtpayxPosN) contain the position of the first                       222761
      **  unused position in OtpayxRec. If the input data is blank at the                     222761
      **  end this would be well after the last non-blank character.                          222761
     D OtpayxData      DS                                                                     222761
     D  OtpayxRec                          Like(TransData)                                    222761
     D  OtpayxPosA                    4                                                       222761
     D  OtpayxPosN                    4S 0 Overlay(OtpayxPosA)                                222761
 
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
      **----------------  End of Parameters for CPB010  --------------**                      CPB010
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
      **  Key status.
     D P_Kyst          S              7A
      **  Switchable feature number.                                                          212012
     D P_Sard          S              6A                                                      212012
      ** ---------- End of fields used by access programs -----------**
                                                                                              212012
      ****Work Field used for feature CFT004.                                          212012 215305
      **  Work Field used for feature CFT014.                                                 215305
     D*CFT004***       S              1A                                               212012 215305
     D CFT014          S              1A                                                      215305
 
      **  Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      **----------------  Start of additional fields ----------------**
      **  Settlement Currency Number of Decimal Places.
     D W_CcyNbdp       S              1A
      **  Full Ordering Customer Settlement Account.
     D*W_OrderSettAcc  S             18A                                                      CGL029
     D W_OrderSettAcc  S             24A                                                      CGL029
      **  Customer Settlement Account's Portfolio Reference.
     D W_OrderSettPor  S              4A
      **-----------------  End of additional fields -----------------**
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **   Composite Data
     D CompData        S                   LIKE(TransData)
                                                                                              222761
      **  Parameters for ProcFormat.                                                          222761
     D   InData        S                   LIKE(TransData) INZ(*BLANKS)                       222761
     D   InDBFile      S             10A   INZ(*BLANKS)                                       222761
 
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
 
      **  Initialize parameters to be passed to RP1431.
     C                   Clear                   GetFTSacParm
 
     C                   Eval      W_OrderSettAcc = *blanks
     C                   Eval      W_OrderSettPor = *blanks
 
      **  Extract Last Change Type.
     C                   Z-add     1             X
     C     'CHTP  '      Lookup    Arrfld(X)                              89
     C                   Eval      ChangeType = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Front Office Id.
     C                   Z-add     1             X
     C     'FRNT  '      Lookup    Arrfld(X)                              89
     C                   Eval      FrontId = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Ordering Customer from OTPAYDD message data.
     C                   Z-add     1             X
     C     'ORC1  '      Lookup    Arrfld(X)                              89
     C                   Eval      Customer = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Check ordering type                                                              BUG15105A
     C                   If        %Subst(Customer:1:1) = '/'                              BUG15105A
     C                   Z-add     1             X                                         BUG15105A
     C     'ORCT  '      Lookup    Arrfld(X)                              89               BUG15105A
     C                   Eval      ORCT = %Subst(TransData:+                               BUG15105A
     C                             ArrPos(X):ArrLen(X))                                    BUG15105A
     C                   If        ORCT = 'P' Or ORCT = 'R' or ORCT = 'I'                  BUG15105A
     C                   Eval      TmpCustomer = Customer                                  BUG15105A
     C                   Eval      Customer = *Blanks                                      BUG15105A
     C                   Eval      Customer = %Subst(TmpCustomer:2:34)                     BUG15105A
     C                   Else                                                              BUG15105A
     C                   Z-add     1             X                                         BUG15105A
     C     'ORC2  '      Lookup    Arrfld(X)                              89               BUG15105A
     C                   Eval      Customer = *Blanks                                      BUG15105A
     C                   Eval      Customer = %Subst(TransData:+                           BUG15105A
     C                             ArrPos(X):ArrLen(X))                                    BUG15105A
     C                   EndIf                                                             BUG15105A
     C                   EndIf                                                             BUG15105A
                                                                                           BUG15105A
      **  Extract Ordering Bank.
     C                   Z-add     1             X
     C     'ORBK  '      Lookup    Arrfld(X)                              89
     C**********         Eval      Bank = %Subst(TransData:+                                AR970292
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                          AR970292
     C                   EVAL      Bank = %Subst(TransData:+                                AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
 
      **  If Ordering Bank was not set.
     C                   If        %Subst(Bank: 1: ArrLen(X)) = *All'0'
     C                   Eval      Bank = *ALL' '
 
     C                   EndIf
 
      **  Extract Ordering Bank Type.
     C                   Z-add     1             X
     C     'ORBT  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
                                                                                             199266
      **  If Nostro account, keep only the 2 first characters of bank                        199266
     C     FieldValue    Ifeq      'N'                                          Begin Nostro 199266
     C                   Eval      BankNostro = *ALL' '                                      199266
     C                   Endif                                                  End Nostro   199266
                                                                                             199266
      **  If Retail account, keep only the 10 first characters of bank                       199266
     C     FieldValue    Ifeq      'R'                                          Begin Retail 199266
     C                   Eval      BankRetail = *ALL' '                                      199266
     C                   Endif                                                  End Retail   199266
 
      **  If partial account in Multi-branching environment.
     C     AGMBIN        Ifeq      'Y'                                          Begin AGMBIN
     C     FieldValue    Andeq     'P'
 
      **  Extract Ordering Branch Code.
     C                   Z-add     1             X
     C     'ORBB  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                   Cat       FieldValue:0  Bank
     C                   Endif                                                  End AGMBIN
 
      **  Extract Settlement Currency Code.
     C                   Z-add     1             X
     C     'SMCY  '      Lookup    Arrfld(X)                              89
     C                   Eval      Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Get Funds Transfer Full Settlement Account Details.
     C                   Exsr      GetFTSetAc
 
      **  Set up full account.
     C                   Eval      W_BranchCode  = BranchCode
     C                   Move      CustNumber    W_CustNumber
     C                   Eval      W_Currency    = Currency
     C                   Move      AccountCode   W_AccCode
     C                   Move      AccountSeq    W_AccSequ
     C                   Eval      W_OrderSettAcc = W_FullSettAcc
 
      **  Define key list to access to Account Master Details file.
     C     K_Accnt       Klist
     C                   Kfld                    CustNumber
     C                   Kfld                    W_Currency
     C                   Kfld                    AccountCode
     C                   Kfld                    AccountSeq
     C                   Kfld                    BranchCode
 
      **  Retrieve Account details (Portfolio Reference)
     C     K_Accnt       Chain     ACCNT                              81
 
      **  If Account does not exist, handle database error.
     C     *in81         Ifeq      True                                         Begin *in81
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'ACCNT'                             ***************
     C                   Eval      Dbase  = 03                                  * Db Error 03 *
     C                   Eval      DbKey = W_FullSettAcc                        ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in81
 
     C                   Eval      W_OrderSettPor = A_PTFR
 
     C                   Movel     CustNumber    P_Cust
 
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
 
     C                   Movel     FrontId       W_FrontID
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer.
     C                   If            BBPRBA = 'Y'                             Begin BBPRBA
     C                             and ChangeType <> 'D'
     C                             or  BBPRBA = 'Y'
     C                             and ChangeType = 'D'
     C                             and W_FrontId = 'TO'
     C                             Or  PBREPB = 'Y'
 
      **----------------- Start of Additionnal fields ---------------**
 
      **---------------- Start of Settlement Currency ---------------**
      **                   Number of Decimal Places                  **
 
      **  Get Settlement Currency number of decimal places.
     C                   Eval      P_Curr = W_Currency
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_CcyNbdp
 
      **                  End of Settlement Currency                 **
      **-----------------  Number of Decimal Places  ----------------**
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 03                                  * Db Error 03 *
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
                                                                                              212012
      **  Expand data where possible                                                          212012
                                                                                              212012
      **  Extract Ordering Bank.                                                              212012
     C                   Clear                   W8FT                                         212012
                                                                                              212012
     C                   Z-add     1             X                                            212012
     C     'STMT  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      W8STMT = %Subst(TransData:+                                212012
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))                            212012
      *                                                                                       212012
     C                   MOVEL     PSProcPgm     W8CPGM                                       212012
     C                   MOVEL     '*MSG  '      W8ACT                                        212012
     C                   MOVEL     'Y'           W8CRIT                                       212012
     C                   Z-ADD     4             W8NLIN                                       212012
      *                                                                                       212012
      *  Destination                                                                          212012
      *                                                                                       212012
                                                                                              212012
      **  Extract Destination type.                                                           212012
     C                   Z-add     1             X                                            212012
     C     'DSTT  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      W8TYPE = %Subst(TransData:+                                212012
     C                             ArrPos(X):ArrLen(X))                                       212012
                                                                                              212012
      **  Extract Prime Currency Code.                                                        212012
     C                   Z-add     1             X                                            212012
     C     'PCCY  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      W8CCY = %Subst(TransData:+                                 212012
     C                             ArrPos(X):ArrLen(X))                                       212012
                                                                                              212012
     C                   MOVEL     *BLANKS       WADDRSS                                      212012
                                                                                              212012
      **  Extract Destination 1.                                                              212012
     C                   Z-add     1             X                                            212012
     C     'DST1  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      WADCHK1 = %Subst(TransData:+                               212012
     C                             ArrPos(X):ArrLen(X))                                       212012
                                                                                              212012
      **  Extract Destination 2.                                                              212012
     C                   Z-add     1             X                                            212012
     C     'DST2  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      WADCHK2 = %Subst(TransData:+                               212012
     C                             ArrPos(X):ArrLen(X))                                       212012
                                                                                              212012
      **  Extract Destination 3.                                                              212012
     C                   Z-add     1             X                                            212012
     C     'DST3  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      WADCHK3 = %Subst(TransData:+                               212012
     C                             ArrPos(X):ArrLen(X))                                       212012
                                                                                              212012
      **  Extract Destination 4.                                                              212012
     C                   Z-add     1             X                                            212012
     C     'DST4  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      WADCHK4 = %Subst(TransData:+                               212012
     C                             ArrPos(X):ArrLen(X))                                       212012
                                                                                              212012
     C                   MOVEL     WADDRSS       W8LINS                                       212012
                                                                                              212012
      **  Call expansion program                                                              212012
     C                   CALL      'FT0315'                             9090                  212012
     C                   PARM      *BLANKS       W8RTN             7                          212012
     C                   PARM                    W8FT                                         212012
     C                   PARM                    W8LINS          256                          212012
     C                   PARM                    W8RPT           256                          212012
     C                   PARM                    W8MSG           256                          212012
     C                   PARM                    W8SCR           256                          212012
                                                                                              212012
      **  If currency does not exist, handle database error.                                  212012
     C     *IN90         Ifeq      '1'                                                        212012
     C     W8RTN         Orne      *blanks                                                    212012
     C     *lock         In        Lda                                                        212012
     C                   Eval      Dbpgm  = PSProcName                                        212012
     C                   Eval      Dbfile = 'FT0315  '                                        212012
     C                   Eval      Dbase  = 08                                                212012
     C                   Eval      Dbkey  = '*CALL'                                           212012
     C                   Out       LDA                                                        212012
     C                   Eval      ReturnCode  = W8RTN                                        212012
     C**********         Exsr      *Pssr                                               212012 CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                                212012
                                                                                              212012
     C                   MOVEL     W8SCR         WADDRSS                                      212012
                                                                                              212012
      **  Update Destination 1,2,3 & 4.                                                       212012
     C                   Z-add     1             X                                            212012
     C     'DST1  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      %Subst(TransData:ArrPos(X):+                               212012
     C                             ArrLen(X)) = WADCHK1                                       212012
                                                                                              212012
     C                   Z-add     1             X                                            212012
     C     'DST2  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      %Subst(TransData:ArrPos(X):+                               212012
     C                             ArrLen(X)) = WADCHK2                                       212012
                                                                                              212012
     C                   Z-add     1             X                                            212012
     C     'DST3  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      %Subst(TransData:ArrPos(X):+                               212012
     C                             ArrLen(X)) = WADCHK3                                       212012
                                                                                              212012
     C                   Z-add     1             X                                            212012
     C     'DST4  '      Lookup    Arrfld(X)                              89                  212012
     C                   Eval      %Subst(TransData:ArrPos(X):+                               212012
     C                             ArrLen(X)) = WADCHK4                                       212012
                                                                                              212012
      **  If CFT014 (MT103 for Funds Transfer) switched ON                                    215305
     C     CFT014        Ifeq      'Y'                                                        215305
                                                                                              215305
      **  Extract Payment reference.                                                          215305
     C                   Z-add     1             X                                            215305
     C     'PREF  '      Lookup    Arrfld(X)                              89                  215305
     C                   Eval      WPAYREF = %Subst(TransData:+                               215305
     C                             ArrPos(X):ArrLen(X))                                       215305
                                                                                              215305
      **  Retrieve FT Outgoing Payments Details Extension                                     215305
     C     WPAYREF       Chain     OTPAYXL0                           81                      215305
                                                                                              215305
      **  If record does not exist, handle database error.                                    215305
     C     *in81         Ifeq      True                                                       215305
     C     *lock         In        Lda                                                        215305
     C                   Eval      Dbpgm  = PSProcName                                        215305
     C                   Eval      Dbfile = 'OTPAYXL0'                                        215305
     C                   Eval      Dbase  = 11                                                215305
     C                   Eval      DbKey = WPAYREF                                            215305
     C                   Out       LDA                                                        215305
     C                   Eval      ReturnCode  = W_NoRcdFnd                                   215305
     C                   Exsr      Repair                                                     215305
     C                   Endif                                                                215305
                                                                                              215305
      **  Extract Telex charge.                                                               215305
     C                   Z-add     1             X                                            215305
     C     'TXCH  '      Lookup    Arrfld(X)                              89                  215305
     C                   Eval      FieldValue = %Subst(TransData:+                            215305
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))                            215305
     C                   Movel     FieldValue    WCHARGE                                      215305
                                                                                              215305
      **  Add Receiver's charges remitted to Telex charge                                     215305
     C                   Eval      WCHARGE = WCHARGE + OPRCSC                                 215305
     C                   Move      WCHARGE       WCHARGE_A                                    215305
                                                                                              215305
      **  Update Telex charge.                                                                215305
     C                   Z-add     1             X                                            215305
     C     'TXCH  '      Lookup    Arrfld(X)                              89                  215305
     C                   Eval      %Subst(TransData:ArrPos(X)+W_PosDebut:+                    215305
     C                             ArrLen(X)) = WCHARGE_A                                     215305
                                                                                              215305
     C                   Else                                                               AR983495
     C                   Clear                   OtpayxDS                                   AR983495
     C                   Endif                                                                215305
                                                                                              215305
      **  Reformat entire OTPAYXPD record (OTPAYXDF).                                         222761
      **  The relevant member in file RPMSGFPD contains details of the fields                 222761
      **  in the file to be processed (it is a DSPFFD outfile).                               222761
      **  This file must already be set up with the field data for the                        222761
      **  file to be processed.                                                               222761
     C     CFT014        Ifeq      'Y'                                                        243947
     C                   Eval      CompData = *blanks                                         222761
     C                   Eval      Indata   = OtpayxDS                                        222761
     C                   Eval      InDBFile = 'OTPAYXPD  '                                    222761
     C                   Eval      OtpayxData = ProcFormat(InData:InDBFile:                   222761
     C                                        fmDecSep:fmShwPsSgn)                            222761
     C                   Endif                                                                243947
                                                                                              222761
      **  The OtpayxData data structure has two sub-fields:                                   222761
      **     - OtpayxRec which now contains the formatted data, left aligned.                 222761
      **     - OtpayxPosA/OtpayxPosN which now contains the position of                       222761
      **     the first unused byte in OtpayxRec.                                              222761
 
      **  Place the result in field CompData.
 
     C     CFT014        Ifeq      'Y'                                                        243947
     C                   Eval      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_CcyNbdp                        Currency Dec. Places
     C                                       + W_OrderSettAcc                   Benefic. Settl. Acc.
     C                                       + W_OrderSettPor                   Benefic. Settl. Port
     C                                       + %subst(OtpayxRec:1:+                           222761
     C                                                           OtpayxPosN-1)                222761
     C                   Else                                                                 243947
     C                   Eval      CompData  = %subst(TransData:1:EndPosition)                243947
     C                                       + W_CcyNbdp                                      243947
     C                                       + W_OrderSettAcc                                 243947
     C                                       + W_OrderSettPor                                 243947
     C                   Endif                                                                243947
 
      **------------------ End of Additionnal fields ----------------**
 
      **  Call a standard routine to actually send the message.
     C                   CallB     'RPSNDMSG'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   PArm                    CompData
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
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 04                                  * Db Error 04 *
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
     C                   Eval      DBase  = 05                                  * Db Error 05 *
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
      *  GetFTSetAc - Get Funds Transfer Settlement Account Details.  *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     GetFTSetAc    Begsr
 
     C                   Clear                   ReturnCode
     C                   Callb     'RP1431'
      **  ------
      **  Inputs
      **  ------
      **  Customer.
     C                   Parm                    Customer
      **  Bank.
     C                   Parm                    Bank
      **  --------------
      **  Inputs/Outputs
      **  --------------
      **  Currency.
     C                   Parm                    Currency
      **  -------
      **  Outputs
      **  -------
      ** Branch Code.
     C                   Parm                    BranchCode
      **  Customer Number.
     C                   Parm                    CustNumber
      **  Account Code.
     C                   Parm                    AccountCode
      **  Account Sequence.
     C                   Parm                    AccountSeq
      **  Return Code.
     C                   Parm                    ReturnCode
 
      **  If any error occurred while getting Settlement Details, handle it.
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 06                                  * Db Error 06 *
     C                   Eval      DBkey  = 'RP1431'                            ***************
     C                   Out       LDA
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
     C                   Eval      Dbase  = 07                                  * Db Error 07 *
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
 
      **  Read RUNDAT Data Area to get Multi-branching Indicator.
     C                   In        RUNDAT
 
     C                   Z-add     0             X                 3 0
                                                                                              212012
      ****Check*if*CFT004*is*installed.*********************************               212012 215305
      **  Check if CFT014 is installed.                                                       215305
     C**********         Eval      CFT004 = 'N'                                        212012 215305
     C                   Eval      CFT014 = 'N'                                               215305
     C                   Callb     'AOSARDR0'                                                 212012
     C                   Parm      *blanks       P_Rtcd                                       212012
     C                   Parm      '*VERIFY'     P_Optn                                       212012
     C**********         Parm      'CFT004'      P_Sard                                212012 215305
     C                   Parm      'CFT014'      P_Sard                                       215305
     C     Scsard        Parm      Scsard        Dsfdy                                        212012
                                                                                              212012
      **  If any error occurred when checking feature.                                        212012
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd  212012
     C     P_Rtcd        andne     '*NRF   '                                                  212012
     C     *lock         in        Lda                                                        212012
     C                   Eval      DBpgm  = PSProcName                                        212012
     C                   Eval      DBfile = 'SCSARDPD'                          **************212012
     C                   Eval      DBase  = 10                                  * Db Error 10 212012
     C                   Eval      DBkey  = P_Sard                              **************212012
     C                   Out       Lda                                                        212012
     C                   Eval      ReturnCode = 'Error'                                       212012
     C**********         Exsr      *Pssr                                               212012 CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              212012
     C                   Endif                                                  End P_Rtcd    212012
                                                                                              215305
      **  If feature is installed.                                                            215305
     C     P_Rtcd        Ifeq      *blanks                                                    215305
     C                   Eval      CFT014 = 'Y'                                               215305
     C                   Endif                                                                215305
 
      **  Retrieve position and length of Ordering Customer from OTPAYDD message data.
     C                   Eval      FieldName   = 'ORC1'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
                                                                                           BUG15105A
      **  Retrieve position and length of Ordering Cust 2 from OTPAYDD message data.       BUG15105A
     C                   Eval      FieldName   = 'ORC2'                                    BUG15105A
     C                   Eval      FieldType   = 'A'                                       BUG15105A
     C                   Exsr      RtvPos                                                  BUG15105A
                                                                                           BUG15105A
      **  Retrieve position and length of Ordering Type from OTPAYDD message data.         BUG15105A
     C                   Eval      FieldName   = 'ORCT'                                    BUG15105A
     C                   Eval      FieldType   = 'A'                                       BUG15105A
     C                   Exsr      RtvPos                                                  BUG15105A
 
      **  Retrieve position and length of Ordering Bank from OTPAYDD message data.
     C                   Eval      FieldName   = 'ORBK'
     C**********         Eval      FieldType   = 'N'                                        AR970292
     C                   EVAL      FieldType   = 'A'                                        AR970292
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Ordering Bank Type from OTPAYDD message data.
     C                   Eval      FieldName   = 'ORBT'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Ordering Bank Branch Type from OTPAYDD message data.
     C                   Eval      FieldName   = 'ORBB'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Settlement Currency from OTPAYDD message data.
     C                   Eval      FieldName   = 'SMCY'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Last Change Type from INPAYDD message data.
     C                   Eval      FieldName   = 'CHTP'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Front Office Id from INPAYDD message data.
     C                   Eval      FieldName   = 'FRNT'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Settlement type from OTPAYDD msg data.              212012
     C                   Eval      FieldName   = 'STMT'                                       212012
     C                   Eval      FieldType   = 'N'                                          212012
     C                   Exsr      RtvPos                                                     212012
                                                                                              212012
      **  Retrieve position and length of Destination type from OTPAYDD msg data              212012
     C                   Eval      FieldName   = 'DSTT'                                       212012
     C                   Eval      FieldType   = 'A'                                          212012
     C                   Exsr      RtvPos                                                     212012
                                                                                              212012
      **  Retrieve position and length of Prime Currency from OTPAYDD msg data.               212012
     C                   Eval      FieldName   = 'PCCY'                                       212012
     C                   Eval      FieldType   = 'A'                                          212012
     C                   Exsr      RtvPos                                                     212012
                                                                                              212012
      **  Retrieve position and length of Destination 1 from OTPAYDD msg data.                212012
     C                   Eval      FieldName   = 'DST1'                                       212012
     C                   Eval      FieldType   = 'A'                                          212012
     C                   Exsr      RtvPos                                                     212012
                                                                                              212012
      **  Retrieve position and length of Destination 2 from OTPAYDD msg data.                212012
     C                   Eval      FieldName   = 'DST2'                                       212012
     C                   Eval      FieldType   = 'A'                                          212012
     C                   Exsr      RtvPos                                                     212012
                                                                                              212012
      **  Retrieve position and length of Destination 3 from OTPAYDD msg data.                212012
     C                   Eval      FieldName   = 'DST3'                                       212012
     C                   Eval      FieldType   = 'A'                                          212012
     C                   Exsr      RtvPos                                                     212012
                                                                                              212012
      **  Retrieve position and length of Destination 4 from OTPAYDD msg data.                212012
     C                   Eval      FieldName   = 'DST4'                                       212012
     C                   Eval      FieldType   = 'A'                                          212012
     C                   Exsr      RtvPos                                                     212012
                                                                                              215305
      **  Retrieve position and length of Payment reference from OTPAYDD msg                  215305
     C                   Eval      FieldName   = 'PREF'                                       215305
     C                   Eval      FieldType   = 'A'                                          215305
     C                   Exsr      RtvPos                                                     215305
                                                                                              215305
      **  Retrieve position and length of Telex Charge from OTPAYDD msg data.                 215305
     C                   Eval      FieldName   = 'TXCH'                                       215305
     C                   Eval      FieldType   = 'A'                                          215305
     C                   Exsr      RtvPos                                                     215305
                                                                                              215305
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
