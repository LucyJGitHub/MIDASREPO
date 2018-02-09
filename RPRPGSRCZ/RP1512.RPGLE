     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Extraction Module for SDPBDSPD.')             *
      *****************************************************************
 
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1512 - Extract module for SDPBDSPD                         *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Entire Customer Master Details record.      *
      *                 - Portfolio Reference from PMPORTPD.          *
      *                 - Portfolio Narrative from PMPORTPD.          *
      *                 - Customer currency from SDPLCSPD.            *
      *                 - Portfolio currency from PMPORTPD.           *
      *                 - Management Type from PMPORTPD.              *
      *                 - Investment Profile from PMPORTPD.           *
      *                                                               *
      *  Component of: RP1512 - Extract program for SDPBDSPD          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CSW214             Date 25Nov14               *
      *                 BUG14840           Date 09Sep13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR858264A          Date 16Jul12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243773             Date 02Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CPB010             Date 16Jan03               *
      *                 CPB008             Date 15Oct02               *
      *                 211268             Date 29Oct02               *
      *                 203616             Date 14Oct02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 199445             Date 03Dec01               *
      *                 198848             Date 24Oct01               *
      *                 198200             Date 24Oct01               *
      *                 197191             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  BUG14840 - Missing objects from Swift 2007 Delivery          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  243773 - to only produce audit report when account officer   *
      *           is missing for Private Banking or "Requested for    *
      *           Private Banking" customer                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
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
      *           - Add Extension details format fields :             *
      *              * PbcustpdRec                                    *
      *              * PbcustpdPosA                                   *
      *              * PbcustpdPosN                                   *
      *           to output message to avoid ODBC Client Access       *
      *  211268 - Reviewed send of msg  for SDPBDSPD                  *
      *  203616 - Reviewed send of msg for SDPBDSPD. Account Officer  *
      *           can be blank for NPB customer.                      *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  199445 - Although, the access object for customer return     *
      *           *NRF, check to include closing customers.           *
      *  198848 - Remove setup additional field, since PBCUSTXT exists*
      *  198200 - Try to manage correctly customers who have to be    *
      *           send to Meridian                                    *
      *  197191 - Also send Non PB Customers which are declared as    *
      *           Valid Counterparty                                  *
      *  CPB002 - New Private Banking Customer Processing.            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  PM Live Portfolio Definition Details.
     FPMPORTLL  IF   E           K DISK
     F                                     Infsr(*Pssr)
 
      **  Midas GL Accounts Master                                                            CPB008
     FPBCUSTL0  IF   E           K Disk    UsrOpn                                             CPB008
                                                                                              CPB008
      **  Midas SD Stamp Tax Customer Extension File                                        AR970292
     FSDCUSQL0  IF   E           K DISK    UsrOpn                                           AR970292
                                                                                            AR970292
      **  PB Wrong Setup on Customer audit report.
     FRP1512AU  O    E             PRINTER Infds(SpoolU)
     F                                     Infsr(*Pssr)
     F                                     Usropn
     FSDCSSWL0  IF   E           K Disk    UsrOpn                                           BUG14840
                                                                                            BUG14840
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  End of file PMPORTLL was reached.                     *
      *  82  -  End of file PBCUSTL0 was reached.                     *                       CPB008
      *  83  -  End of file SDCSSWL0 was reached.                     *                     BUG14840
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
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *  #Audit  - Subroutine to Output Audit report.                 *
      *  RtvPos - retrieve position in Meridian message.              *
      *  Repair   - Repair process                                    *                       CPB010
      *  WrtTrace - Trace process                                     *                       CPB010
      *  *Pssr  - Program exception error routine                     *
      *  *Inzsr - Program Initialization routine.                     *
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
 
      **  File Information Data Structure for printer file RP1512AU.
     D Spoolu          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0
 
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
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  External data structure for Customer extension                                      CPB008
     D PbCust        E DS                  Extname(PBCUSTXT)                                  CPB008
      **  Data Structure for access to Customer Details.
      **  Also used to pass data to procedure ProcFormat.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      ** Data Structure for access to Portfolio Management Customer Details.
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
 
      ** External data structure for Feature Details.                           199445
     D Scsard        E DS                  Extname(SCSARDPD)                    199445
                                                                                199445
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      **  External data structure for Customer extension Swift details                      BUG14840
     D SDCSSW        E DS                  Extname(SDCSSWPD)                                BUG14840
                                                                                            BUG14840
      **  Structure to receive a formatted customer details
      **  record from procedure ProcFormat.
      **  SdcustpdPosA (and SdcustpdPosN) contain the position of the first
      **  unused position in SdcustpdRec. If the input data is blank at the
      **  end this would be well after the last non-blank character.
     D SdcustpdData    DS
     D  SdcustpdRec                        Like(TransData)
     D  SdcustpdPosA                  4
     D  SDcustpdPosN                  4S 0 Overlay(SdcustpdPosA)
                                                                                            BUG14840
      **  Structure to receive a formatted customer extended                                BUG14840
      **  swift record from procedure ProcFormat.                                           BUG14840
      **  SDCSSWPDPosA (and SDCSSWPDPosN) contain the position of the first                 BUG14840
      **  unused position in SDCSSWpdRec. If the input data is blank at the                 BUG14840
      **  end this would be well after the last non-blank character.                        BUG14840
     D SDCSSWpdData    DS                                                                   BUG14840
     D  SDCSSWpdRec                        Like(TransData)                                  BUG14840
     D  SDCSSWpdPosA                  4                                                     BUG14840
     D  SDCSSWpdPosN                  4S 0 Overlay(SDCSSWpdPosA)                            BUG14840
 
                                                                                              CPB008
      **  Structure to receive a formatted customer extended                                  CPB008
      **  record from procedure ProcFormat.                                                   CPB008
      **  PbcustpdPosA (and PbcustpdPosN) contain the position of the first                   CPB008
      **  unused position in PbcustpdRec. If the input data is blank at the                   CPB008
      **  end this would be well after the last non-blank character.                          CPB008
     D PbcustpdData    DS                                                                     CPB008
     D  PbcustpdRec                        Like(TransData)                                    CPB008
     D  PbcustpdPosA                  4                                                       CPB008
     D  PbcustpdPosN                  4S 0 Overlay(PbcustpdPosA)                              CPB008
                                                                                              CPB008
      **  Data Structure used to set up Portfolio additional fields.
     D PortfolioDetls  DS
     D  PortfolioRef                  4
     D  PortfolioNarr                20
     D  CustomerCcy                   3
     D  PortfolioCcy                  3
     D  ManagmntType                  5
     D  InvPrflCode                   5
 
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
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
     D K_Cust          S              6A                                                      CPB008
      **  Request Flag After.
     D P_RqPA          S              1A
      **  Request Flag Before.
     D P_RqPB          S              1A
      **  Valid Counterparty Flag After.                                                      197191
     D P_VcoA          S              1A                                                      197191
      *   Valid Counterparty Flag Before.                                                     211268
     D P_VcoB          S              1A                                                      211268
      **  Key status.
     D P_Kyst          S              7A
      **  Switchable feature number.                                            199445
     D P_Sard          S              6A                                        199445
      ** ---------- End of fields used by access programs -----------**
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Parameters for ProcFormat.
     D   InData        S                   LIKE(TransData) INZ(*BLANKS)
     D   InDBFile      S             10A   INZ(*BLANKS)
 
      **  Work field used as key to access to Portfolio Definition Details.
     D*K_Cnum***       S              6S 0                                                    CSD027
     D K_Cnum          S              6A                                                      CSD027
 
      **  Work Field used to process replication
     D W_Process       S              1A
 
      **  Work Field used to check type of message (A: After; B: Before)
     D W_Type          S              1A
     D W_TypeB         S              1A                                                      198200
     D W_TypeA         S              1A                                                      198200
 
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
                                                                                199445
      **  Work Field used for EMU feature CSD007.                               199445
     D CSD007          S              1A                                        199445
                                                                                              243773
      **  Work Field used for audit report generation.                                        243773
     D W_Audit         S              1A                                                      243773
 
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
                                                                                              243773
      ** Initialize indicator that is used for audit report generation.                       243773
     C                   Eval      W_Audit = 'N'                                              243773
                                                                                              CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                                       CPB010
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
     C**********         Eval      X = 1                                                      198200
     C*****'PBREPB'      Lookup    Arrfld(X)                              89                  198200
 
      **  Check image (Before or After) of the message
     C                   Eval      W_PosFin    = %Scan('_B':RAMSGTYPE)
 
      **  Before Image Type
     C     W_PosFin      Ifne      0                                            Begin Before
     C                   Eval      ImageType = 'Amend Before'                                 CPB010
     C                   Eval      AssocData = TransData                                      CPB010
     C                   Eval      MdHdAssoc = MdnHeadDs                                      CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C**********         Eval      W_Type = 'B'                                               198200
     C                   Eval      W_TypeB = 'B'                                              198200
     C                   Eval      X = 1                                                      198200
     C     'PBREPB'      Lookup    Arrfld(X)                              89                  198200
      **  Extract Request Flag from SDPBDSPD message data.
     C                   Eval      P_RqPB = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C**********         Else                                                   Else Before   198200
     C                   Eval      W_Type  = ' '                                              198200
      *                                                                                       211268
      *   Extract Valid Counterparty from SDPBDSPD message data.                              211268
     C                   Eval      X = 1                                                      211268
     C     'PBCOUN'      Lookup    Arrfld(X)                              89                  211268
     C                   Eval      P_VcoB = %Subst(TransData:+                                211268
     C                             ArrPos(X):ArrLen(X))                                       211268
     C                   Return                                                               211268
      *                                                                                       211268
                                                                                              CPB010
     C                   If        ImageType <> 'Amend Before'                                CPB010
     C                   Eval      ImageType = 'Insert'                                       CPB010
     C                   Eval      AssocData = *Blanks                                        CPB010
     C                   Eval      MdHdAssoc = *Blanks                                        CPB010
     C                   Else                                                                 CPB010
     C                   Eval      ImageType = 'Amend After'                                  CPB010
     C                   EndIf                                                                CPB010
                                                                                              CPB010
     C                   else                                                                 198200
      ** After image                                                                          198200
     C                   Eval      W_TypeA = 'A'                                              198200
     C                   Eval      X = 1                                                      198200
     C     'PBREPB'      Lookup    Arrfld(X)                              89                  198200
      **  Extract Request Flag from SDPBDSPD message data.
     C                   Eval      P_RqPA = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
      **  Extract Valid Counterparty from SDPBDSPD message data.                              197191
     C                   Eval      X = 1                                                      197191
     C     'PBCOUN'      Lookup    Arrfld(X)                              89                  197191
     C                   Eval      P_VcoA = %Subst(TransData:+                                197191
     C                             ArrPos(X):ArrLen(X))                                       197191
                                                                                              197191
     C                   if        W_TypeB = 'B'                                              198200
      ** If I have got an after image check that previous image was before                    198200
      ** If yes then it is an amendment                                                       198200
     C                   Eval      W_Type  = 'A'                                              198200
      ** Switch back status for new row read from jhournal entries                            198200
     C                   Eval      W_TypeB = ' '                                              198200
     C                   Else                                                                 198200
      ** if the previous image was not Before, then it 's an insert                           198200
     C                   Eval      W_Type  = 'I'                                              198200
      ** Switch back status for new row read from jhournal entries                            198200
     C                   Eval      W_TypeB = ' '                                              198200
     C                   Endif                                                                198200
     C                   Endif                                                  End Before
 
      ****After*Image*Type:*Do*NOT*process*if*PBREPB*has*be*changed*from*'Y' to 'N'           198200
     C*****W_PosFin      Ifeq      0                                            Begin After   198200
     C**********         Eval      W_Process = 'Y'                                            198200
 
     C*****W_Type        Ifeq      'B'                                          Begin PBREPB  198200
     C*****P_RqPB        Andeq     'Y'                                                        198200
     C*****P_RqPA        Andeq     'N'                                                        198200
     C**********         Eval      W_Process = 'N'                                            198200
     C**********         Endif                                                  EndPBREPB     198200
 
     C**********         Eval      W_Type = 'A'                                               198200
     C**********         Endif                                        End After               198200
      *Do no treat before image                                                               198200
     C                   If        W_TypeB = 'B'                                              198200
     C                   Eval      W_Process = 'N'                                            198200
     C                   Else                                                                 198200
     C                   Eval      W_Process = 'Y'                                            198200
     C                   Endif                                                                198200
      *                                                                                       198200
      **If it is an amend then                                                                198200
     C     W_Type        Ifeq      'A'                                                        198200
     C     P_RqPB        Andeq     'Y'                                                        198200
     C     P_RqPA        Andeq     'N'                                                        198200
     C                   Eval      W_Process = 'N'                                            198200
     C                   Endif                                                                198200
 
     C     W_Process     Ifeq      'Y'
     C**********         Eval      W_Process = *Blanks                                        198200
 
      **  Extract Customer number from SDPBDSPD message data.
     C                   Z-add     1             X
     C     'PBCNUM'      Lookup    Arrfld(X)                              89
     C**********         Eval      P_Cust = %Subst(TransData:+                              AR970292
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                          AR970292
     C                   EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
     C                   Movel     P_Cust        K_Cust                                       CPB008
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
     C                   Callb     'AOCUSTR1'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm                    P_Cust
     C                   Parm                    P_Kyst
     C     Sdcust        Parm      Sdcust        Dsldy
 
      **  Initialize old account code not retrieved in AOCUSTR1                             AR970292
      **  to avoid decimal data error during 'ProcFormat'                                   AR970292
     C                   Z-ADD     *ZEROS        QQDFAC                                     AR970292
 
      **  If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
      *Check if the customer is only closed CSD007 feature                      199445
     C     CSD007        ifeq      'Y'                                          199445
     C     BBCLST        andne     'Y'                                          199445
     C     CSD007        orne      'Y'                                          199445
      *                                                                         199445
     C     P_Rtcd        Ifeq      '*NRF'                                                     203616
     C     BBDTDL        Andne     0                                                          203616
     C                   Else                                                                 203616
                                                                                              203616
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDCUSTPD'                          ***************
     C                   Eval      DBase  = 01                                  * Db Error 01 *
     C                   Eval      DBkey  = P_Cust                              ***************
     C                   Out       Lda
     C                   Eval       ReturnCode =  P_Rtcd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                                203616
                                                                                              203616
     C                   Endif                                                  199445
     C                   Endif                                                  End P_Rtcd
 
     C     W_Type        Ifeq      'I'                                                        211268
      ** Insert or Delete (image after only)                                                  211268
     C     P_RqPA        Ifeq      'Y'                                                        211268
     C     P_VcoA        Oreq      'Y'                                                        211268
     C     BBPRBA        Oreq      'Y'                                                        211268
     C                   Eval      W_Process = 'Y'                                            211268
     C                   Else                                                                 211268
     C                   Eval      W_Process = 'N'                                            211268
     C                   EndIf                                                                211268
     C                   Else                                                                 211268
      ** Amend send                                                                           211268
      *** If Valid Counterpart pass from Y to N                                               211268
     C     P_VcoB        Ifeq      'Y'                                                        211268
     C     P_VcoA        Andeq     'N'                                                        211268
      *** Or Valid Counterpart pass from N to Y                                               211268
     C     P_VcoB        Oreq      'N'                                                        211268
     C     P_VcoA        Andeq     'Y'                                                        211268
      *** Or If Request for PB                                                                211268
     C     P_RqPB        Oreq      'N'                                                        211268
     C     P_RqPA        Andeq     'Y'                                                        211268
      *** Or If amend on Counterpart                                                          211268
     C     P_VcoB        Oreq      'Y'                                                        211268
     C     P_VcoA        Andeq     'Y'                                                        211268
      *** Or If amend on PB customer                                                          211268
     C     BBPRBA        Oreq      'Y'                                                        211268
     C                   Eval      W_Process = 'Y'                                            211268
     C                   Else                                                                 211268
     C                   Eval      W_Process = 'N'                                            211268
     C                   EndIf                                                                211268
     C                   EndIf                                                                211268
      **If it's an insert then                                                                198200
     C     W_Type        Ifeq      'I'                                                        198200
     C     P_RqPA        Andeq     'N'                                                        198200
     C     BBPRBA        Andeq     'N'                                                        198200
     C*****W_Type        Oreq      'I'                                                 198200 203616
     C     P_VcoA        Andeq     'N'                                                        198200
     C*****BBPRBA        Andeq     'N'                                                 198200 203616
     C                   Eval      W_Process = 'N'                                            198200
     C                   Endif                                                                198200
                                                                                              203616
     C     BBACOC        Ifeq      *blanks                                                    203616
     C     P_RqPA        Andeq     'Y'                                                        203616
     C     BBACOC        Oreq      *blanks                                                    203616
     C     BBPRBA        Andeq     'Y'                                                        203616
     C                   Eval      W_Process = 'N'                                            203616
     C                   Eval      W_Audit = 'Y'                                              243773
     C                   Endif                                                                203616
      **  Don't send message if Account Officer is not setup
     C*****BBACOC        Ifne      *blanks                                                    203616
     C*****W_Process     Andeq     'Y'                                                 198200 203616
     C*****BBPRBA        Andeq     'Y'                                                        198200
     C*****BBACOC        Orne      *blanks                                                    198200
     C*****P_RqPA        Andeq     'Y'                                                        198200
     C     W_Process     Ifeq      'Y'                                                        203616
     C                   Eval      W_Process = *Blanks                                        198200
                                                                                            AR970292
     C     BBFRNT        IFEQ      *Blanks                                                  AR970292
                                                                                            AR970292
     C                   OPEN      SDCUSQL0                                                 AR970292
     C     K_Cust        CHAIN(N)  SDCUSQL0                           84                    AR970292
     C                   CLOSE     SDCUSQL0                                                 AR970292
                                                                                            AR970292
     C     *IN84         IFEQ      '0'                                                      AR970292
     C     CQFRID        ANDNE     *Blanks                                                  AR970292
     C                   EVAL      BBFRNT = CQFRID                                          AR970292
     C                   ENDIF                                                              AR970292
                                                                                            AR970292
     C                   ENDIF                                                              AR970292
 
      **----------------- Start of Additionnal fields ---------------**
 
      **  Reformat entire SDCUSTPD record (SDCUSTD0).
      **  The relevant member in file RPMSGFPD contains details of the fields
      **  in the file to be processed (it is a DSPFFD outfile).
      **  This file must already be set up with the field data for the
      **  file to be processed.
     C                   Eval      CompData = *blanks
     C                   Eval      InData   = Sdcust
     C                   Eval      InDBFile = 'SDCUSTPD  '
     C                   Eval      SdcustpdData = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      **  The SdcustpdData data structure has two sub-fields:
      **     - SdcustpdRec which now contains the formatted data, left aligned.
      **     - SdcustpdPosA/SdcustpdPosN which now contains the position of
      **     the first unused byte in SdcustpdRec.
                                                                                            BUG14840
      **  Initialize Swift extension additional fields                                      BUG14840
     C                   Clear                   SDCSSW                                     BUG14840
      **  Reformat entire PBCUSTXT                                                          BUG14840
     C                   Open      SDCSSWL0                                                 BUG14840
     C     K_Cust        Chain     SDCSSWL0                           83                    BUG14840
     C                   Close     SDCSSWL0                                                 BUG14840
                                                                                            BUG14840
      **  The relevant member in file RPMSGFPD contains details of the fields               BUG14840
      **  in the file to be processed (it is a DSPFFD outfile).                             BUG14840
      **  This file must already be set up with the field data for the                      BUG14840
      **  file to be processed.                                                             BUG14840
     C                   Eval      CompData = *blanks                                       BUG14840
     C                   Eval      InData   = SDCSSW                                        BUG14840
     C                   Eval      InDBFile = 'SDCSSWPD  '                                  BUG14840
     C                   Eval      SDCSSWpdData = ProcFormat(InData:InDBFile:               BUG14840
     C                                        fmDecSep:fmShwPsSgn)                          BUG14840
                                                                                            BUG14840
      **  The SDCSSWpdData data structure has two sub-fields:                               BUG14840
      **     - SDCSSWpdRec which now contains the formatted data, left aligned.             BUG14840
      **     - SDCSSWpdPosA/SDCSSWpdPosN which now contains the position of                 BUG14840
      **     the first unused byte in SDCSSWpdRec.                                          BUG14840
                                                                                              CPB008
      **  Initialize extension additional fields.                                             CPB008
     C                   Clear                   Pbcust                                       CPB008
      **  Reformat entire PBCUSTXT                                                            CPB008
     C                   Open      PBCUSTL0                                                   CPB008
     C     K_Cust        Chain     PBCUSTL0                           82                      CPB008
     C                   Close     PBCUSTL0                                                   CPB008
                                                                                              CPB008
      **  The relevant member in file RPMSGFPD contains details of the fields                 CPB008
      **  in the file to be processed (it is a DSPFFD outfile).                               CPB008
      **  This file must already be set up with the field data for the                        CPB008
      **  file to be processed.                                                               CPB008
     C                   Eval      CompData = *blanks                                         CPB008
     C                   Eval      InData   = Pbcust                                          CPB008
     C                   Eval      InDBFile = 'PBCUSTXT  '                                    CPB008
     C                   Eval      PbcustpdData = ProcFormat(InData:InDBFile:                 CPB008
     C                                        fmDecSep:fmShwPsSgn)                            CPB008
                                                                                              CPB008
      **  The PbcustpdData data structure has two sub-fields:                                 CPB008
      **     - PbcustpdRec which now contains the formatted data, left aligned.               CPB008
      **     - PbcustpdPosA/PbcustpdPosN which now contains the position of                   CPB008
      **     the first unused byte in PbcustpdRec.                                            CPB008
 
      **  Initialize Portfolio additional fields.
     C                   Clear                   PortfolioDetls
      *                                                                                       198848
      ** Access pmportpd only if gateway process is required                                  198848
      *                                                                                       198848
     C     P_RqPA        IfEq      'Y'                                                        198848
 
      **  Access to first Portfolio Definition details.
     C                   Movel     P_Cust        K_Cnum
     C     K_Cnum        Setll     PMPORTLL
     C     K_Cnum        Reade     PMPORTLL                               81
 
      **  If at least one Portfolio Definition already exists for
      **  the customer (due to migration), set up Portfolio fields.
     C     *in81         Ifeq      False                                        Begin *in81
     C                   Eval      PortfolioRef  = PNPTFR                       Portfolio Reference
     C                   Eval      PortfolioNarr = PNPTFN                       Portfolio Narrative
     C                   Eval      PortfolioCcy  = PNPTCY                       Portfolio Currency
 
     C**********         Eval      fmSign3010 = PNMGTP                                        198848
     C**********         Eval      fmAlpNum32  = ProcSigned(fmSign3010:                       198848
     C**********                       3:0:fmDecSep:fmShwPsSgn)                               198848
     C**********         Eval      ManagmntType  = %subst(fmAlpNum32:1:5)       Investment Typ198848
                                                                                              198848
     C**********         Eval      fmSign3010 = PNINTP                                        198848
     C**********         Eval      fmAlpNum32  = ProcSigned(fmSign3010:                       198848
     C**********                       3:0:fmDecSep:fmShwPsSgn)                               198848
     C**********         Eval      InvPrflCode  = %subst(fmAlpNum32:1:5)        Investment Pro198848
 
     C                   Else
 
     C**********         Eval      PortfolioCcy  = BJCYCD     Portfolio Currency              198848
     C**********         Eval      ManagmntType  = '1'        Management Type                 198848
     C**********         Eval      InvPrflCode  = '1'         Investment Profile              198848
 
     C                   Endif                                                  End *in81
 
      **  Access to Portfolio Management Customer Details to get
      **  the Customer Currency.
     C                   Callb     'AOPLCSR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm                    P_Cust
     C     Sdplcs        Parm      Sdplcs        Dsfdy
 
      **  If Portfolio Management Customer Details exist.
     C     P_Rtcd        Ifeq      *blanks                                      Begin P_Rtcd
     C                   Eval      CustomerCcy   = QBCSBY                       Customer Currency
     C                   Else
     C                   Eval      CustomerCcy   = BJCYCD                       Customer Currency
     C
     C                   Endif                                                  End P_Rtcd
     C                   Endif                                                                198848
 
      **------------------ End of Additionnal fields ----------------**
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 02                                  * Db Error 02 *
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
     C                                       + %subst(SdcustpdRec:1:+
     C                                                           SdcustpdPosN-1)
     C                                       + PortfolioDetls
     C                                       + %subst(PbcustpdRec:1:+                         CPB008
     C                                                           PbcustpdPosN-1)              CPB008
     C                                       + %subst(SDCSSWpdRec:1:+                       BUG14840
     C                                                           SDCSSWpdPosN-1)            BUG14840
 
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
 
     C                   Else                                                   Else BBACOC
 
     C                   If        W_Audit = 'Y'                                              243773
      **  Invalid Customer --> Account Officer not setup
     C                   Exsr      #Audit
     C                   Endif                                                                243773
     C                   Endif                                                  End BBACOC
     C                   Endif                                                  End PBREPB
 
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
     C                   Eval      DBase  = 03                                  * Db Error 03 *
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
     C                   Eval      DBase  = 04                                  * Db Error 04 *
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
 
      /Eject
      *****************************************************************
      /Title SR/#Audit
      *****************************************************************
      *                                                               *
      *  #Audit - Subroutine to output Audit report.                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Audit        Begsr                                                  ** #Audit SR **
 
      **  Open Audit Report printer file.
     C                   Open      RP1512AU                             99
 
      **  Ensure Audit Report Spool File Recorded by RCF.
     C                   Exsr      #Rcfau
 
      **  Output Report Header and File Controls.
     C                   Write     HEADP1
 
     C                   Movel     BBCUST        P1CUST
     C                   Eval      P1CSSN = BBCSSN
 
     C                   Write     DETAIL1
 
      **  Close Audit Report printer file.
     C                   Close     RP1512AU
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Rcfau
      *****************************************************************
      *                                                               *
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by: #Audit                                            *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
 
     C     #Rcfau        Begsr                                                  ** #Rcfau SR **
 
      **  Ensure Audit Spool File recorded by RCF.
     C                   move      Sfnumu        Zsnumu
 
     C                   Call      'ZSFILE'
     C                   Parm      *Blanks       Seq               5
     C                   Parm      *Blanks       Senty             3
     C                   Parm                    Sfileu
     C                   Parm                    Zsnumu            6 0
     C                   Parm      *Blank        Zserr             1
 
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         Ifeq      'Y'                                          Begin Zserr
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endif                                                  End Zserr
 
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
      *
     C                   Parm                    ReturnCode
                                                                                              CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
      *                                                                         199445
      **  Check if CSD007 (Customer Closing) is installed                       199445
     C                   Eval      CSD007 = 'N'                                 199445
     C                   Callb     'AOSARDR0'                                   199445
     C                   Parm      *blanks       P_Rtcd                         199445
     C                   Parm      '*VERIFY'     P_Optn                         199445
     C                   Parm      'CSD007'      P_Sard                         199445
     C     Scsard        Parm      Scsard        Dsfdy                          199445
                                                                                199445
      **  If any error occurred when checking feature.                          199445
     C     P_Rtcd        Ifne      *blanks                                      199445
     C     P_Rtcd        andne     '*NRF   '                                    199445
     C     *lock         in        Lda                                          199445
     C                   Eval      DBpgm  = PSProcName                          199445
     C                   Eval      DBfile = 'SCSARDPD'                          199445
     C                   Eval      DBase  = 06                                  199445
     C                   Eval      DBkey  = P_Sard                              199445
     C                   Out       Lda                                          199445
     C                   Eval      ReturnCode = 'Error'                         199445
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                199445
     C                   Endif                                                  199445
                                                                                199445
      **  If feature is installed.                                              199445
     C     P_Rtcd        Ifeq      *blanks                                      199445
     C                   Eval      CSD007 = 'Y'                                 199445
                                                                                199445
     C                   Endif                                                  199445
 
      **  Access Bank details by using access program.
     C                   Callb     'AOBANKR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_optn
     C     Sdbank        Parm      Sdbank        Dsldy
 
      **  If Bank details do not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDBANKPD'                          ***************
     C                   Eval      Dbase  = 05                                  * Db Error 05 *
     C                   Eval      Dbkey  = '*first'                            ***************
     C                   Out       LDA
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End  P_Rtcd
 
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
 
      **  Retrieve position and length of customer number from SDPBDSPD message data.
     C                   Eval      FieldName   = 'PBCNUM'
     C**********         Eval      FieldType   = 'N'
     C                   Eval      FieldType   = 'A'                                        AR970292
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of customer number from SDPBDSPD message data.
     C                   Eval      FieldName   = 'PBREPB'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
                                                                                              197191
      **  Retrieve position and length of valid counterparty from SDPBDSPD msg                197191
     C                   Eval      FieldName   = 'PBCOUN'                                     197191
     C                   Eval      FieldType   = 'A'                                          197191
     C                   Exsr      RtvPos                                                     197191
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     C                   Eval      P_RqPB = *blanks
 
     C                   Endsr
      /Eject
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
