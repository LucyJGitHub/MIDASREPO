     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extraction Module for ACCNTAB.')           *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1513 - Extract module for ACCNTAB                          *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Account Decimal Places                      *
      *                 - Entire Interests and Charges record.        *
      *                                                               *
      *  Component of: RP1513 - Extract program for ACCNTAB           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1095876          Date 30Sep13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR858264A          Date 16Jul12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243739             Date 24Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7315            Date 13Dec05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 214003             Date 27Jan03               *
      *                 CPB010             Date 16Jan03               *
      *                 CPB008             Date 16oct02               *
      *                 CPB004             Date 08Mar01               *
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
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  243739 - Amend of account failed within TMS Receiver.        *
      *           At first, CGL029 was incompletely implemented.      *
      *           Then, additional REIACD record was wrongly defined  *
      *  BUG7315 - Incorrect incorporation of CPB004 and CPB008 into  *
      *            RPGLE/RP1513                                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  214003 - DB Error in RP1513 if customer closed.              *
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
      *           - Access account to provide Full account number for *
      *             alternate account Debit and Credit. No retail     *
      *             number.                                           *
      *  CPB004 - Replicate block and refer debits and credits.       *
      *           In addition to Retail accouts, transfer GL account  *
      *           details for account codes set for transfer to TOF.  *
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
 
      **  RE Retail Interests and Charges.
     FREIAC     IF   E           K DISK
     F                                     Infsr(*Pssr)
      **  Midas GL Accounts Master                                                            CPB008
     FMEMOSL2   IF   E           K Disk    Prefix(M_) Usropn                                  CPB008
     F                                     Infsr(*Pssr)                                       CPB008
                                                                                            AR970292
      **  Midas GL Account Master Extension File                                            AR970292
     FGLACNTL3  IF   E           K DISK    UsrOpn                                           AR970292
     F                                     Infsr(*Pssr)                                     AR970292
                                                                                            AR970292
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  CHAIN access to SDPBDSL0 failed.                      *
      *  82  -  CHAIN access to MEMOSL2  failed.                      *                       CPB008
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
      *  Repair   - Repair process                                    *         CPB010
      *  WrtTrace - Trace process                                     *         CPB010
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
 
      ** Following /COPY is the procedure prototype for the Format routine
      ** that is used to process an entire record
     C/COPY RPCPYSRC,RPFMTPPF
 
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
 
      **  Midas Local Data Area for database error reporting; based on
      **  external file
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
 
      **---------- Start of fields used as keys to access -----------**
      **               to Retail Interests and Charges
     D W_FullAcc       DS
      **  Customer Number.
     D***K_Cnum*       S              6S 0                                                    CSD027
     D   K_Cnum        S              6A                                                      CSD027
      **  Currency.
     D   K_Ccy         S              3A
      **  Account Code.
     D***K_Acod*       S              4S 0                                                    CGL029
     D   K_Acod        S             10S 0                                                    CGL029
      **  Account Sequence.
     D   K_Acsq        S              2S 0
      **  Branch Code.
     D   K_Brca        S              3A
      **             End of fields used as keys to access
      **----------     to Retail Interests and Charges    -----------**
 
      **  Data Structure for access to Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      **  Data structure used to group alternate  account details.                            CPB008
     D W_Alternate     DS            15                                                       CPB008
     D   W_RetailNb            1     10S 0                                                    CPB008
     D   W_Notacno            11     15                                                       CPB008
                                                                                              CPB008
      **  Data structure used for dr alternate  account details.                              CPB008
     D*W_Dr_Set_Acc****DS            15                                               CPB008 BUG7315
     D W_Dr_Set_Acc    DS            21                                                      BUG7315
     D   W_DrCnum              1      6                                                       CPB008
     D   W_DrCcy               7      9                                                       CPB008
     D***W_DrAcod***          10     13                                               CPB008 BUG7315
     D***W_DrAcsq***          14     15                                               CPB008 BUG7315
     D   W_DrAcod             10     19                                                      BUG7315
     D   W_DrAcsq             20     21                                                      BUG7315
                                                                                              CPB008
      **  Data structure used for dr alternate  account details.                              CPB008
     D*W_Cr_Set_Acc****DS            18                                               CPB008 BUG7315
     D W_Cr_Set_Acc    DS            21                                                      BUG7315
     D   W_CrCnum              1      6                                                       CPB008
     D   W_CrCcy               7      9                                                       CPB008
     D***W_CrAcod***          10     13                                               CPB008 BUG7315
     D***W_CrAcsq***          14     15                                               CPB008 BUG7315
     D   W_CrAcod             10     19                                                      BUG7315
     D   W_CrAcsq             20     21                                                      BUG7315
                                                                                              CPB008
      **  Data structure used for charge alternate  account details.                          CPB008
     D*W_Ch_Set_Acc****DS            18                                               CPB008 BUG7315
     D W_Ch_Set_Acc    DS            21                                               CPB008 BUG7315
     D   W_ChCnum              1      6                                                       CPB008
     D   W_ChCcy               7      9                                                       CPB008
     D***W_ChAcod***          10     13                                               CPB008 BUG7315
     D***W_ChAcsq***          14     15                                               CPB008 BUG7315
     D   W_ChAcod             10     19                                                      BUG7315
     D   W_ChAcsq             20     21                                                      BUG7315
                                                                                              CPB008
      **  Data Structure for access to Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      **  Data Structure used to pass Retail Interests and Charges
      **  Data to procedure ProcFormat.
     D Reiacd        E DS                  Extname(REIACD)
 
      ** External data structure for Feature Details.                           CPB004
     D Scsard        E DS                  Extname(SCSARDPD)                    CPB004
                                                                                CPB004
      **  External data structure for Account Code Details.                     CPB004
     D Sdacod        E DS                  Extname(SDACODPD)                    CPB004
                                                                                CPB004
      **  External data structure for Bank Details.                                           CPB008
     D Sdbank        E DS                  Extname(SDBANKPD)                                  CPB008
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      **  Structure to receive a formatted Retail Interests and Charges
      **  record from procedure ProcFormat.
      **  ReiacdPosA (and ReiacdPosN) contain the position of the first
      **  unused position in ReiacdRec. If the input data is blank at the
      **  end this would be well after the last non-blank character.
     D ReiacdData      DS
     D  ReiacdRec                          Like(TransData)
     D  ReiacdPosA                    4
     D  ReiacdPosN                    4S 0 Overlay(ReiacdPosA)
 
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
 
      **---------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
      **  Key status.
     D P_Kyst          S              7A
      **  Account Code.                                                         CPB004
     D*P_Acod***       S              4A                                              CPB004 BUG7315
     D P_Acod          S             10A                                                     BUG7315
      **----------- End of fields used by access programs -----------**
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Work Field used as key to access to Customer PB Details.
     D***K_CustNum       S              6  0                                                  CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      **  Parameters for ProcFormat.
     D   InData        S                   LIKE(TransData) INZ(*BLANKS)
     D   InDBFile      S             10A   INZ(*BLANKS)
 
      **----------------  Start of additional fields ----------------**
     D W_CcyNbdp       S              1A
     D W_TakeDate      S              5S 0                                                    CPB008
     D A_TakeDate      S              5A                                                      CPB008
                                                                                CPB004
      ** Credit Blocking Indicator                                              CPB004
     D  W_CreditBlock  S              1A                                        CPB004
                                                                                CPB004
      ** Debit Blocking Indicator                                               CPB004
     D  W_DebitBlock   S              1A                                        CPB004
                                                                                CPB004
      ** Credit Referring Indicator                                             CPB004
     D  W_CreditRef    S              1A                                        CPB004
                                                                                CPB004
      ** Credit Referring Indicator                                             CPB004
     D  W_DebitRef     S              1A                                        CPB004
      **-----------------  End of additional fields -----------------**
                                                                                CPB004
      **  Work Field used to check type of message (A: After; B: Before)        CPB004
     D W_Type          S              1A                                        CPB004
      **  Work Field used to check the action (A:Amend; I:Insert)               CPB004
     D W_Action        S              1A                                        CPB004
      **  Work Field used to retrieve REPI Flag                                 CPB004
     D W_REPI          S              1A                                        CPB004
     D W_REPIBefore    S              1A                                        CPB004
      **  Work Field used to retrieve Account Type                              CPB004
     D W_Atyp          S              1A                                        CPB004
 
      **   Composite Data
     D CompData        S                   LIKE(TransData)
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
                                                                                CPB004
      **  Work Field used to retrieve retail indicator                          CPB004
     D W_RETB          S              1A                                        CPB004
 
      **  Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      **  Work field used for account currency
     D W_Currency      S              3A
 
      **  Work field used for change message type
     D W_PosFin        S              3S 0
 
      **  Work Field used to validate the procecc                               CPB004
     D W_Process       S              1A                                        CPB004
      **  Work Field used for the feature CPB004.                               CPB004
     D WPB004          S              1A                                        CPB004
     D*ReiacdFmt*******S            196A                                               CPB004 243739
                                                                                214003
      **  Work Field used for EMU feature CSD007.                               214003
     D CSD007          S              1A                                        214003
                                                                                            AR970292
      **  Work Field used for Front Office Id processing                                    AR970292
     D P_FrontOffice   S             20A                                                    AR970292
                                                                                            AR970292
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
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                         CPB010
                                                                                CPB004
      **  Check image (Before or After) of the message                          CPB004
     C                   Eval      W_PosFin    = %Scan('_B':RAMSGTYPE)          CPB004
                                                                                CPB004
      **  Before Image Type                                                     CPB004
     C     W_PosFin      Ifne      0                                            CPB004
     C                   Eval      W_Type = 'B'                                 CPB004
     C                   Eval      W_Action = *Blanks                           CPB004
     C                   Eval      ImageType = 'Amend Before'                   CPB010
     C                   Eval      AssocData = TransData                        CPB010
     C                   Eval      MdHdAssoc = MdnHeadDs                        CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Else                                                   CPB004
                                                                                CPB010
     C                   If        ImageType <> 'Amend Before'                  CPB010
     C                   Eval      ImageType = 'Insert'                         CPB010
     C                   Eval      AssocData = *Blanks                          CPB010
     C                   Eval      MdHdAssoc = *Blanks                          CPB010
     C                   Else                                                   CPB010
     C                   Eval      ImageType = 'Amend After'                    CPB010
     C                   EndIf                                                  CPB010
                                                                                CPB004
      **  After Image Type: Setup Action Code                                   CPB004
      **     If Before Image exists, 'A'mend mode                               CPB004
      **     else 'I'nsert Mode                                                 CPB004
     C     W_Type        Ifeq      'B'                                          CPB004
     C                   Eval      W_Action = 'A'                               CPB004
     C                   Else                                                   CPB004
     C                   Eval      W_Action = 'I'                               CPB004
     C                   EndIf                                                  CPB004
     C                   Eval      W_Type  = 'A'                                CPB004
     C                   EndIf                                                  CPB004
                                                                                CPB004
      **  Extract REPI Flag from ACCNTAB message data.                          CPB004
     C                   Z-add     1             X                              CPB004
     C     'REPI  '      Lookup    Arrfld(X)                              89    CPB004
     C                   Eval      W_REPI = %Subst(TransData:+                  CPB004
     C                             ArrPos(X):ArrLen(X))                         CPB004
                                                                                CPB004
      ** Keep REPI Flag of Before image                                         CPB004
     C                   If        W_Action = *Blanks                           CPB004
     C                   Eval      W_REPIBefore = W_REPI                        CPB004
     C                   EndIf                                                  CPB004
                                                                                CPB004
      ** Extract Account type from ACCNTAB message data.                        CPB004
     C                   Z-add     1             X                              CPB004
     C     'ATYP  '      Lookup    Arrfld(X)                              89    CPB004
     C                   Eval      W_Atyp = %Subst(TransData:+                  CPB004
     C                             ArrPos(X):ArrLen(X))                         CPB004
                                                                                CPB004
      ** Send the Account only if REPI Flag has been changed                    CPB004
      **                          Or Retail Account                             CPB004
     C                   If        W_Action = 'I' And W_REPI <> *Blanks         CPB004
     C                             Or W_Action = 'A'                            CPB004
     C                                AND W_REPI <> W_REPIBefore                CPB004
     C                                AND W_REPI <> *Blanks                     CPB004
     C                             Or W_Type = 'A'                              CPB004
     C                                And W_Atyp = 'R'                          CPB004
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **  Extract Customer number from ACCNTAB message data.
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
     C     Sdcust        Parm      Sdcust        DSLDY
 
      **  If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
      *                                                                         214003
      ***  Check if the customer is only closed CSD007 feature.                 214003
      *                                                                         214003
     C     CSD007        ifeq      'Y'                                          214003
     C     BBCLST        andne     'Y'                                          214003
     C     CSD007        orne      'Y'                                          214003
      *                                                                         214003
     C     P_Rtcd        Ifeq      '*NRF'                                       214003
     C     BBDTDL        Andne     0                                            214003
     C                   Else                                                   214003
      *                                                                         214003
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDCUSTPD'                          ***************
     C                   Eval      DBase  = 01                                  * Db Error 01 *
     C                   Eval      DBkey  = P_Cust                              ***************
     C                   Out       Lda
     C                   Eval       ReturnCode =  P_Rtcd
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
     C                   Endif                                                  214003
      *                                                                         214003
     C                   Endif                                                  214003
      *                                                                         214003
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
                                                                                CPB004
      **  Set up key list.                                                      CPB004
     C                   Movel     P_Cust        K_Cnum                         CPB004
                                                                                CPB004
      **  Set up indicator used to condition process                            CPB004
     C                   Eval      W_Process  = 'Y'                             CPB004
                                                                                CPB004
      **  Extract Account Code from ACCNTAB message data.                       CPB004
     C                   Z-add     1             X                              CPB004
     C     'ACOD  '      Lookup    Arrfld(X)                              89    CPB004
     C                   Eval      FieldValue = %Subst(TransData:+              CPB004
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))              CPB004
     C                   Movel     FieldValue    K_Acod                         CPB004
                                                                                CPB004
      **  Access Account Code details                                           CPB004
     C                   Move      K_Acod        P_Acod                         CPB004
     C                   CALL      'AOACODR0'                                   CPB004
     C                   PARM      *BLANKS       P_Rtcd                         CPB004
     C                   PARM      '*KEY   '     P_Optn                         CPB004
     C                   PARM                    P_Acod                         CPB004
     C     SDACOD        PARM      SDACOD        Dssdy                          CPB004
                                                                                CPB004
      **  If CPB004 "Account Closing" is not present                            CPB004
     C     WPB004        Ifne      'Y'                                          CPB004
                                                                                CPB004
      **  Omit if it is a General Ledger posting                                CPB004
     C                   If        A5ACTY = 'G'                                 CPB004
     C                   Eval      W_Process  = 'N'                             CPB004
     C                   Endif                                                  CPB004
                                                                                CPB004
      **  CPB004 "Account Closing" is present                                   CPB004
     C                   Else                                                   CPB004
                                                                                CPB004
      **  Must be transfert if it is a Retail Account                           CPB004
     C                   If        A5ACTY = 'R'                                 CPB004
     C                             Or A5ACTY = 'G'                              CPB004
     C                             And A5TRAN = 'Y'                             CPB004
     C                   Eval      W_Process  = 'Y'                             CPB004
     C                   Else                                                   CPB004
     C                   Eval      W_Process  = 'N'                             CPB004
     C                   EndIf                                                  CPB004
                                                                                CPB004
     C                   EndIf                                                  CPB004
     C                                                                          CPB004
      **  Only process if the condition is yes                                  CPB004
     C     W_Process     IfEq      'Y'                                          CPB004
 
      **----------------- Start of Additionnal fields ---------------**
 
      **---------------- Start of Account Currency ---------------**
      **                   Number of Decimal Places                  **
 
     C                   Z-add     1             X
     C     'CCY   '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Get Account Currency number of decimal places.
     C                   Eval      P_Curr = W_Currency
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_CcyNbdp
 
      **                  End of Account Currency                 **
      **-----------------  Number of Decimal Places  ----------------**
 
 
      **  Define key list to access to Retail Interests and Charges.
     C     K_FullAcc     Klist
     C                   Kfld                    K_Cnum
     C                   Kfld                    K_Ccy
     C                   Kfld                    K_Acod
     C                   Kfld                    K_Acsq
     C                   Kfld                    K_Brca
      ****                                                                         ***********CPB004
      ****Set up key list.                                                         ***********CPB004
     C****               Movel     P_Cust        K_Cnum                            ***********CPB004
 
      **  Extract Currency from ACCNTAB message data.
     C                   Z-add     1             X
     C     'CCY   '      Lookup    Arrfld(X)                              89
     C                   Eval      K_Ccy = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
                                                                                   ***********CPB004
      ****Extract Account Code from ACCNTAB message data.                          ***********CPB004
     C****               Z-add     1             X                                 ***********CPB004
     C**** 'ACOD  '      Lookup    Arrfld(X)                              89       ***********CPB004
     C****               Eval      FieldValue = %Subst(TransData:+                 ***********CPB004
     C****                         ArrPos(X)+W_PosDebut:ArrLen(X))                 ***********CPB004
     C****               Movel     FieldValue    K_Acod                            ***********CPB004
 
      **  Extract Account Sequence from ACCNTAB message data.
     C                   Z-add     1             X
     C     'ACSQ  '      Lookup    Arrfld(X)                              89
     C                   Eval      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   Movel     FieldValue    K_Acsq
 
      **  Extract Branch Code from ACCNTAB message data.
     C                   Z-add     1             X
     C     'BRCA  '      Lookup    Arrfld(X)                              89
     C                   Eval      K_Brca = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      ** Retrieve Full account details only for retail account                  CPB004
     C                   If        A5ACTY = 'R'                                 CPB004
      **  Access to retail Interests and Charges Details.
     C     K_FullAcc     Chain     REIAC                              81
 
      **  If Retail Interests and Charges do not exist, handle database error.
     C     *in81         Ifeq      True                                         Begin *in81
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'REIACD  '                          ***************
     C                   Eval      DBase  = 03                                  * Db Error 03 *
     C                   Eval      DBkey  = W_FullAcc                           ***************
     C                   Out       Lda
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
     C                   Endif                                                  End *in81
                                                                                              CPB008
      ** Reformat alternate Debit   from account to full account if necessary                 CPB008
                                                                                              CPB008
     C     DACP          Ifne      *blank                                                     CPB008
     C                   Eval      W_Alternate = DACP                                         CPB008
     C     W_Notacno     Ifeq      *blank                                                     CPB008
     C
      **  Access to retail Memos to get full account                                          CPB008
     C                   Open      MEMOSL2                                                    CPB008
     C     W_RetailNb    Chain     MEMOSL2                            82                      CPB008
     C                   Close     MEMOSL2                                                    CPB008
                                                                                              CPB008
      **  If Retail Interests and Charges do not exist, handle database error.                CPB008
     C     *in82         Ifeq      True                                                       CPB008
     C     *Lock         In        Lda                                                        CPB008
     C                   Eval      DBpgm  = PSProcName                                        CPB008
     C                   Eval      DBfile = 'MEMOSL2 '                          **************CPB008
     C                   Eval      DBase  = 04                                  *BDb2Error 04 CPB008
     C                   Eval      DBkey  = W_Alternate                         **************CPB008
     C                   Out       Lda                                                        CPB008
     C**********         Exsr      *Pssr                                               CPB008 CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              CPB008
     C                   Endif                                                                CPB008
     C                   Movel     M_CNUM        W_DrCnum                                     CPB008
     C                   Eval      W_DrCcy = M_CCY                                            CPB008
     C                   Movel     M_ACOD        W_DrAcod                                     CPB008
     C                   Movel     M_ACSQ        W_DrAcsq                                     CPB008
     C                   Eval      DRBR    = M_BRCA                                           CPB008
     C                   Eval      DACP    = W_Dr_Set_Acc                                     CPB008
                                                                                              CPB008
     C                   Endif                                                                CPB008
     C                   Endif                                                                CPB008
                                                                                              CPB008
      ** Reformat alternate Credit  from account to full account if necessary                 CPB008
                                                                                              CPB008
     C     CACP          Ifne      *blank                                                     CPB008
     C                   Eval      W_Alternate = CACP                                         CPB008
     C     W_Notacno     Ifeq      *blank                                                     CPB008
                                                                                              CPB008
      **  Access to retail Memos to get full account                                          CPB008
     C                   Open      MEMOSL2                                                    CPB008
     C     W_RetailNb    Chain     MEMOSL2                            82                      CPB008
     C                   Close     MEMOSL2                                                    CPB008
                                                                                              CPB008
      **  If Retail Interests and Charges do not exist, handle database error.                CPB008
     C     *in82         Ifeq      True                                                       CPB008
     C     *Lock         In        Lda                                                        CPB008
     C                   Eval      DBpgm  = PSProcName                                        CPB008
     C                   Eval      DBfile = 'MEMOSL2 '                          **************CPB008
     C                   Eval      DBase  = 05                                  *BDb2Error 05 CPB008
     C                   Eval      DBkey  = W_Alternate                         **************CPB008
     C                   Out       Lda                                                        CPB008
     C**********         Exsr      *Pssr                                               CPB008 CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              CPB008
     C                   Endif                                                                CPB008
     C                   Movel     M_CNUM        W_CrCnum                                     CPB008
     C                   Eval      W_CrCcy = M_CCY                                            CPB008
     C                   Movel     M_ACOD        W_CrAcod                                     CPB008
     C                   Movel     M_ACSQ        W_CrAcsq                                     CPB008
     C                   Eval      CRBR    = M_BRCA                                           CPB008
     C                   Eval      CACP    = W_Cr_Set_Acc                                     CPB008
                                                                                              CPB008
     C                   Endif                                                                CPB008
     C                   Endif                                                                CPB008
                                                                                              CPB008
      ** Reformat alternate Charge  from account to full account if necessary                 CPB008
                                                                                              CPB008
     C     CHAC          Ifne      *blank                                                     CPB008
     C                   Eval      W_Alternate = CHAC                                         CPB008
     C     W_Notacno     Ifeq      *blank                                                     CPB008
                                                                                              CPB008
      **  Access to retail Memos to get full account                                          CPB008
     C                   Open      MEMOSL2                                                    CPB008
     C     W_RetailNb    Chain     MEMOSL2                            82                      CPB008
     C                   Close     MEMOSL2                                                    CPB008
                                                                                              CPB008
      **  If Retail Interests and Charges do not exist, handle database error.                CPB008
     C     *in82         Ifeq      True                                                       CPB008
     C     *Lock         In        Lda                                                        CPB008
     C                   Eval      DBpgm  = PSProcName                                        CPB008
     C                   Eval      DBfile = 'MEMOSL2 '                          **************CPB008
     C                   Eval      DBase  = 06                                  *BDb2Error 05 CPB008
     C                   Eval      DBkey  = W_Alternate                         **************CPB008
     C                   Out       Lda                                                        CPB008
     C**********         Exsr      *Pssr                                               CPB008 CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              CPB008
     C                   Endif                                                                CPB008
     C                   Movel     M_CNUM        W_ChCnum                                     CPB008
     C                   Eval      W_ChCcy = M_CCY                                            CPB008
     C                   Movel     M_ACOD        W_ChAcod                                     CPB008
     C                   Movel     M_ACSQ        W_ChAcsq                                     CPB008
     C                   Eval      CHBR    = M_BRCA                                           CPB008
     C                   Eval      CHAC    = W_Ch_Set_Acc                                     CPB008
                                                                                              CPB008
     C                   Endif                                                                CPB008
     C                   Endif                                                                CPB008
                                                                                              CPB008
     C                   Else                                                   CPB004
      ** In case of general ledger, reset record format                         CPB004
     C                   Clear                   Reiacd                         CPB004
     C                   Endif                                                  CPB004
 
      **  Reformat entire REIACD record (REIACDF).
      **  The relevant member in file RPMSGFPD contains details of the fields
      **  in the file to be processed (it is a DSPFFD outfile).
      **  This file must already be set up with the field data for the
      **  file to be processed.
     C                   Eval      CompData = *blanks
     C                   Eval      InData   = Reiacd
     C                   Eval      InDBFile = 'REIACD    '
     C                   Eval      ReiacdData = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      **  The ReiacdData data structure has two sub-fields:
      **     - ReiacdRec which now contains the formatted data, left aligned.
      **     - ReiacdPosA/ReiacdPosN which now contains the position of
      **     the first unused byte in ReiacdRec.
 
     C**********         Eval      ReiacdFmt = %subst(ReiacdRec:1:ReiacdPosN-1)        CPB004 243739
                                                                                CPB004
      **  Extract Retail indicator from ACCNTAB message data.                   CPB004
     C                   Z-add     1             X                              CPB004
     C     'RETB  '      Lookup    Arrfld(X)                              89    CPB004
     C                   Eval      W_RETB = %Subst(TransData:+                  CPB004
     C                             ArrPos(X):ArrLen(X))                         CPB004
                                                                                CPB004
      **  Check the retail indicator                                            CPB004
      *                                                                         CPB004
     C                   TESTB     '3'           W_RETB                   20    CPB004
     C                   If        *in20                                        CPB004
     C                   Eval      W_CreditBlock = 'Y'                          CPB004
     C                   Else                                                   CPB004
     C                   Eval      W_CreditBlock = 'N'                          CPB004
     C                   Endif                                                  CPB004
      *                                                                         CPB004
     C                   TESTB     '2'           W_RETB                   20    CPB004
     C                   If        *in20                                        CPB004
     C                   Eval      W_DebitBlock = 'Y'                           CPB004
     C                   Else                                                   CPB004
     C                   Eval      W_DebitBlock = 'N'                           CPB004
     C                   Endif                                                  CPB004
      *                                                                         CPB004
     C                   TESTB     '1'           W_RETB                   20    CPB004
     C                   If        *in20                                        CPB004
     C                   Eval      W_CreditRef = 'Y'                            CPB004
     C                   Else                                                   CPB004
     C                   Eval      W_CreditRef = 'N'                            CPB004
     C                   Endif                                                  CPB004
      *                                                                         CPB004
     C                   TESTB     '0'           W_RETB                   20    CPB004
     C                   If        *in20                                        CPB004
     C                   Eval      W_DebitRef = 'Y'                             CPB004
     C                   Else                                                   CPB004
     C                   Eval      W_DebitRef = 'N'                             CPB004
     C                   Endif                                                  CPB004
                                                                                            AR970292
     C                   Z-ADD     1             X                                          AR970292
     C     'FRNT  '      LOOKUP    Arrfld(X)                              89                AR970292
     C                   EVAL      P_FrontOffice = %Subst(TransData:+                       AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
                                                                                            AR970292
     C     P_FrontOffice IFEQ      *Blanks                                                  AR970292
                                                                                            AR970292
     C                   OPEN      GLACNTL3                                                 AR970292
     C     K_FullAcc     CHAIN(N)  GLACNTL3                           83                    AR970292
     C                   CLOSE     GLACNTL3                                                 AR970292
                                                                                            AR970292
     C     *IN83         IFEQ      '0'                                                      AR970292
     C     F1FRID        ANDNE     *Blanks                                                  AR970292
                                                                                            AR970292
      **  Update Front Office Id                                                            AR970292
     C                   Z-ADD     1             X                                          AR970292
     C     'FRNT  '      LOOKUP    Arrfld(X)                              89                AR970292
     C                   EVAL      %Subst(TransData:ArrPos(X):+                             AR970292
     C                             ArrLen(X)) = F1FRID                                      AR970292
     C                   ENDIF                                                              AR970292
                                                                                            AR970292
     C                   ENDIF                                                              AR970292
      **------------------ End of Additionnal fields ----------------**
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 04                                  * Db Error 04 *
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
 
     C                   Eval      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_CcyNbdp
     C****************                       + %subst(ReiacdRec:1:ReiacdPosN-1) CPB004
     C**********                             + ReiacdFmt                               CPB004 243739
     C                                       + %subst(ReiacdRec:1:ReiacdPosN-1)               243739
     C                                       + W_CreditBlock                    CPB004
     C                                       + W_DebitBlock                     CPB004
     C                                       + W_CreditRef                      CPB004
     C                                       + W_DebitRef                       CPB004
     C                                       + A_TakeDate                                     CPB008
 
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
     C                   Endif                                                  End W_Process CPB004
 
     C                   Endif                                                  End BBPRBA
     C                   EndIf                                                  End W_REPI CPB004
 
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
     C                   Eval      DBfile = 'Callb   '                          ***************
     C                   Eval      DBase  = 05                                  * Db Error 05 *
     C                   Eval      DBkey  = 'RPC1305'                           ***************
     C                   Out       Lda
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
     C                   Eval      DBase  = 06                                  * Db Error 06 *
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
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *Lock         In        Lda                                          CPB010
     C                   Eval      DBpgm  = PSProcName                          CPB010
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 08                                  * Db Error 08 *
     C                   Eval      DBkey  = 'RP1590'                            ***************
     C                   Out       Lda                                          CPB010
                                                                                CPB010
     C                   Endif                                                  End ReturnCode
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
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *Lock         In        Lda                                          CPB010
     C                   Eval      DBpgm  = PSProcName                          CPB010
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 50                                  * Db Error 50 *
     C                   Eval      DBkey  = 'RP1592'                            ***************
     C                   Out       Lda                                          CPB010
                                                                                CPB010
     C                   exsr      *pssr                                        CPB010
     C                   Else                                                   CPB010
     C                   Return                                                 CPB010
     C                   Endif                                                  End ReturnCode
                                                                                CPB010
     C                   Endsr                                                  CPB010
                                                                                CPB010
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
     C****               Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
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
 
     C     ReturnCode    Ifeq      *blanks                                      Begin ReturnCode
     C                   Eval      ReturnCode = '*Pssr     '
 
     C                   Endif                                                  End ReturnCode
 
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
 
     C                   Eval      MessageInd = 'Y'                             CPB010
                                                                                              CPB008
      **  Access Bank details by using access program.                                        CPB008
     C                   Callb     'AOBANKR0'                                                 CPB008
     C                   Parm      *blanks       P_Rtcd                                       CPB008
     C                   Parm      '*FIRST '     P_optn                                       CPB008
     C     Sdbank        Parm      Sdbank        Dssdy                                        CPB008
                                                                                              CPB008
      **  If Bank details do not exist, handle database error.                                CPB008
     C     P_Rtcd        Ifne      *blanks                                                    CPB008
     C     *lock         In        Lda                                                        CPB008
     C                   Eval      Dbpgm  = PSProcName                                        CPB008
     C                   Eval      Dbfile = 'SDBANKPD'                          **************CPB008
     C                   Eval      Dbase  = 06                                  *BDb0Error 06 CPB008
     C                   Eval      Dbkey  = '*first'                            **************CPB008
     C                   Out       LDA                                                        CPB008
     C**********         Exsr      *Pssr                                               CPB008 CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                                CPB008
                                                                                              CPB008
      **  Set-up Takeon date to be Run date                                                   CPB008
                                                                                              CPB008
     C                   Eval      W_TakeDate = BJRDNB                                        CPB008
     C                   Movel     W_TakeDate    A_TakeDate                                   CPB008
 
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
 
      **  Retrieve position and length of customer number from ACCNTAB message data.
     C                   Eval      FieldName   = 'CNUM'
     C**********         Eval      FieldType   = 'N'                                        AR970292
     C                   EVAL      FieldType   = 'A'                                        AR970292
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of currency code from ACCNTAB message data.
     C                   Eval      FieldName   = 'CCY'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Account Code from ACCNTAB message data.
     C                   Eval      FieldName   = 'ACOD'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Account Sequence from ACCNTAB message data.
     C                   Eval      FieldName   = 'ACSQ'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Branch code from ACCNTAB message data.
     C                   Eval      FieldName   = 'BRCA'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
                                                                                CPB004
      **  Retrieve position and length of retail indicators from ACCNTAB.       CPB004
     C                   Eval      FieldName   = 'RETB'                         CPB004
     C                   Eval      FieldType   = 'A'                            CPB004
     C                   Exsr      RtvPos                                       CPB004
                                                                                CPB004
      **  Retrieve position and length of REPI flag from ACCNTAB.               CPB004
     C                   Eval      FieldName   = 'REPI'                         CPB004
     C                   Eval      FieldType   = 'A'                            CPB004
     C                   Exsr      RtvPos                                       CPB004
                                                                                CPB004
      **  Retrieve position and length of ATYP flag from ACCNTAB.               CPB004
     C                   Eval      FieldName   = 'ATYP'                         CPB004
     C                   Eval      FieldType   = 'A'                            CPB004
     C                   Exsr      RtvPos                                       CPB004
                                                                                            AR970292
      **  Retrieve position and length of FRNT flag from ACCNTAB.                           AR970292
     C                   EVAL      FieldName   = 'FRNT'                                     AR970292
     C                   EVAL      FieldType   = 'A'                                        AR970292
     C                   EXSR      RtvPos                                                   AR970292
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
                                                                                CPB004
      **  Access Bank details by using access program.                          CPB004
     C                   Eval      WPB004 = 'N'                                 CPB004
     C                   Callb     'AOSARDR0'                                   CPB004
     C                   Parm      *blanks       P_Rtcd            7            CPB004
     C                   Parm      '*VERIFY'     P_optn            7            CPB004
     C                   Parm      'CPB004'      P_Sard            6            CPB004
     C     Scsard        Parm      Scsard        Dsfdy                          CPB004
                                                                                CPB004
      **  If feature is installed.                                              CPB004
     C     P_Rtcd        Ifeq      *blanks                                      CPB004
     C                   Eval      WPB004 = 'Y'                                 CPB004
     C                   Endif                                                  CPB004
     C                   Eval      W_Type  = *Blanks                            CPB004
      *                                                                         214003
      ***  Check if CSD007 (Customer Closing) is installed.                     214003
      *                                                                         214003
     C                   Eval      CSD007 = 'N'                                 214003
     C                   Callb     'AOSARDR0'                                   214003
     C                   Parm      *blanks       P_Rtcd                         214003
     C                   Parm      '*VERIFY'     P_optn                         214003
     C                   Parm      'CSD007'      P_Sard                         214003
     C     Scsard        Parm      Scsard        Dsfdy                          214003
      *                                                                         214003
      ***  If any error occurred when checking feature.                         214003
      *                                                                         214003
     C     P_Rtcd        Ifne      *blanks                                      214003
     C     P_Rtcd        andne     '*NRF   '                                    214003
     C     *lock         in        LDA                                          214003
     C                   Eval      Dbpgm  = PSProcName                          214003
     C                   Eval      Dbfile = 'SCSARDPD'                          214003
     C                   Eval      Dbase  = 08                                  214003
     C                   Eval      Dbkey  = P_Sard                              214003
     C                   Out       LDA                                          214003
     C                   Eval      ReturnCode = P_Rtcd                          214003
     C                   Exsr      *Pssr                                        214003
      *                                                                         214003
     C                   Endif                                                  214003
      *                                                                         214003
      ***  If feature is installed.                                             214003
      *                                                                         214003
     C     P_Rtcd        Ifeq      *blanks                                      214003
     C                   Eval      CSD007 = 'Y'                                 214003
      *                                                                         214003
     C                   Endif                                                  214003
 
     C                   Endsr
      /Eject
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
