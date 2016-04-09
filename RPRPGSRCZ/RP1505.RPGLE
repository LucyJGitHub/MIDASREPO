     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extraction Module for GLJENHPD.')          *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1505 - Extract module for GLJENHPD                         *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Currency Number of Decimal Places.          *
      *                 - Entire Journal Entry Posting record.        *
      *                                                               *
      *  Component of: RP1505 - Extract program for GLJENHPD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD027587           Date 19Jun14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR858264A          Date 16Jul12               *
      *                 AR970292           Date 14May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CAS010             Date 09Feb05               *
      *                 223644             Date 03Oct03               *
      *                 219491             Date 16Jul03               *
      *                 CPB010             Date 16Jan03               *
      *                 CPB008             Date 16oct02               *
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
      *  MD027587 - Unable to used the C for Copy and T for Template  *
      *             (Recompile)                                       *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Decimal Data Error in RPG routine PROCFORM.       *
      *             Due to new field BTPDID added into (GZ)GLJENPPD   *
      *             (Child:AR970293)                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  219491 - Retrieve narrative description when narrative code  *
      *           used during input. Necessary to avoid problem with  *
      *           TMS Receiver ("Cannot insert the value NULL into    *
      *           column 'lft_text'").                                *
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
      *           - Access account to provide Portfolio information   *
      *             and avoid ODBC acccess by Meridian                *
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
 
      **  GL Journal Entry Postings.
     FGLJENPL1  IF   E           K DISK
     F                                     Infsr(*Pssr)
      **  Midas GL Accounts Master                                                            CPB008
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)               CPB008
     F                                     Infsr(*Pssr)                                       CPB008
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  End of file GLJENPL1.                                 *
      ***82**-  CHAIN access to SDPBDSL0 failed.                      *                       CPB008
      *  82  -  CHAIN access to SDPBDSL0/ACCNT failed.                *                       CPB008
      *                                                               *                       CPB008
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
      /COPY ZACPYSRC,PSDS
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
 
      **  External data structure for Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)
      *                                                                                       219491
      ** Externally described DS for Narrative Details                                        219491
     D SDNARR        E DS                  EXTNAME(SDNARRPD)                                  219491
 
      **  Data structure used to group settlement account details.                            CPB008
     D*W_FullSettlAcc  DS            18                                                CPB008 CAS010
     D W_FullSettlAcc  DS            24                                                       CPB008
     D   Branch                1      3                                                       CPB008
     D***CustNo*               4      9S 0                                             CPB008 CSD027
     D   CustNo                4      9                                                       CSD027
     D   Currency             10     12                                                       CPB008
     D***AccCode              13     16S 0                                             CPB008 CAS010
     D***AccSeq               17     18S 0                                             CPB008 CAS010
     D   AccCode              13     22S 0                                                    CAS010
     D   AccSeq               23     24S 0                                                    CAS010
                                                                                              CPB008
     D Sdacod        E DS                  Extname(SDACODPD)
      **  External data structure for Account Code Details.
 
      **  External data structure for Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      **  Structure based on the Journal Entry Posting file used to
      **  pass data to procedure ProcFormat.
     D GljenDS       E DS                  Extname(GLJENPPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
 
      **  Structure to receive a formatted journal entry posting
      **  record from procedure ProcFormat.
      **  CustPosA (and CustPosN) contain the position of the first unused
      **  positionr in CustRec.  If the input data is blank at the end this
      **  could be well after the last non-blank character.
     D GljenppdData    DS
     D  GljenppdRec                        Like(TransData)
     D  GljenppdPosA                  4
     D  GLjenppdPosN                  4S 0 Overlay(GljenppdPosA)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of Parameters --------------------**
      **   Output queue name
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
      **---------------- End of Parameters for RPC1305 --------------**
 
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
      **  Key Status.
     D P_Kyst          S              7A
      **  Account Code.
     D*P_Acod***       S              4A                                                      CGL029
     D P_Acod          S             10A                                                      CGL029
      ** ---------- End of fields used by access programs -----------**
 
      ** ----------- Start of parameters for ProcFormat -------------**
     D   InData        S                   LIKE(TransData) INZ(*BLANKS)
     D   InDBFile      S             10A   INZ(*BLANKS)
      **------------- End of Parameters for ProcFormat --------------**
 
      **  Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      **  Field used to position to Journal Entry Postings file.
     D K_BatchNum      S              3A
 
      **----------------  Start of additional fields ----------------**
     D W_CcyNbdp       S              1A
      **-----------------  End of additional fields -----------------**
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Composite Data.
     D CompData        S                   Like(TransData)
 
      **  True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      **  Work field used for change message type
     D W_PosFin        S              3S 0
 
      **  Batch Status Flag
     D W_Status        S              1A
 
      **  Front Office Id
     D W_FrontId       S             20A
     D W_FrontId2      S              2A
 
      **  Work Field used to retrieve the Operation
     D W_Operation     S              2A
 
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
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                                       CPB010
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 01                                  * Db Error 01 *
     C                   Eval      DBkey  = RAMSGTYPE                           ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = 'Image_Type'
     C**********         Exsr      *Pssr                                                      CPB010
                                                                                              CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End W_PosFin
 
     C                   Eval      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **  Retrieve operation in message.
     C                   Eval      W_Operation = %subst(TransData:1:2)
 
      **  Extract Batch Status Flag from GLJENHPD message data.
     C                   Z-add     1             X
     C     'BRBTSF'      Lookup    Arrfld(X)                              89
     C                   Eval      W_Status = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Front Office Id from GLJENHPD message data.
     C                   Z-add     1             X
     C     'BRFRNT'      Lookup    Arrfld(X)                              89
     C                   Eval      W_FrontId = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                   Movel     W_Frontid     W_Frontid2
 
      **  Extract Batch Number from GLJENHPD message data.
     C                   Z-add     1             X
     C     'BRBTNB'      Lookup    Arrfld(X)                              89
     C                   Eval      K_BatchNum = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Position to first Journal Entry Posting for Journal Entry.
     C     K_GLJenp      Setll     GLJENPL1
     C     K_GLJenp      Reade     GLJENPL1                               81
 
      **  In case of Delete, as Detail Rcds (GLJENPPD) are deleted before Header Rcd (GLJENHPD),
      **  Ensure one message is sent to TOF with Operation Code 'D'elete
      **  Send delete only if from front office                                               CPB008
     c                   If            W_Status = 'H'
     C                             And W_Operation = 'D '
     C                             And *IN81 = True
     C                             And  W_Frontid2 = 'TO'                                     CPB008
     C                   Eval      *in81 = False
     C                   Clear                   GljenDS
     C                   Endif
 
      **  Do while Journal Entry Postings to be processed.
     C     *in81         Doweq     False                                        Begin DO_W_N81
                                                                                            AR970292
     C                   Z-ADD     *ZEROS        BTPDID                                     AR970292
      *
      * Access Account Code details
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM      BTACCD        P_Acod
     C     SDACOD        PARM      SDACOD        Dsfdy
 
     C                   If            A5ACTY = 'R'                             Begin Retail Account
     C                             Or  W_Status = 'H'
     C                             And W_Operation = 'D '
 
     C                   If            W_Status = 'A'                           Begin W_Status
 
      **  Extract customer number from GLJENPPD message data.
     C                   Eval      P_Cust = BTCUST
 
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
     C                   Eval      DBase  = 02                                  * Db Error 02 *
     C                   Eval      DBkey  = P_Cust                              ***************
     C                   Out       Lda
     C                   Eval      ReturnCode  = P_RTCD
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif
 
      **  If Customer is not a Private Banking customer, check
      **  Requested PB Customer flag in case it would have been
      **  set to 'Y'.
     C                   If        BBPRBA      <> 'Y'                           Begin BBPRBA
 
      **  Define key list to access to Customer PB Details file.
     C     K_SDPbds      Klist
     C                   Kfld                    K_CustNum
     C                   Move      BBCUST        K_CustNum
 
      **  Access to Customer PB Details file.
     C     K_CustNum     Chain     SDPBDSL0                           82
 
      **  If Customer PB Details do not exist, handle database error.
     C     *in82         Ifeq      True                                         Begin *in82
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDPBDSL0'                          ***************
     C                   Eval      Dbase  = 03                                  * Db Error 03 *
     C                   Eval      Dbkey  = BBCUST                              ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End  *in82
 
     C                   Endif                                                  End  BBPRBA
 
     C                   Endif                                                  End  W_Status
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer and batch status is 'A' (Accepted)
      **  or if it's a delete of a batch in status 'H' (Hold)
     C                   If            BBPRBA = 'Y'                             Begin BBPRBA
     C                             and W_Status = 'A'
     C                             Or  W_Status = 'H'
     C                             And W_Operation = 'D '
     C                             Or  PBREPB = 'Y'
     C                             and W_Status = 'A'
 
      **----------------- Start of Additionnal fields ---------------**
 
      **------- Start of Currency Number of Decimal Places  ---------**
 
      **  Retrieve currency number of decimal places.
     c                   If            W_Status = 'A'
     C                   Eval      P_Curr = BTCYCD
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_CcyNbdp
     C                   Else
     C                   Move      *Blanks       W_CcyNbdp
     C                   Endif
                                                                                              219491
     C     BTNRDC        Ifeq      *blank                                                     219491
     C     BTNVCD        Andne     *blank                                                     219491
     C                   CALL      'AONARRR0'                                                 219491
     C                   PARM      *BLANKS       PRTCD             7                          219491
     C                   PARM      '*KEY   '     POPTN             7                          219491
     C                   PARM                    BTNVCD                                       219491
     C     SDNARR        PARM      SDNARR        DSFDY                                        219491
                                                                                              219491
      **  If Narrative code does not exist, handle database error.                            219491
     C     P_Rtcd        Ifne      *blanks                                                    219491
     C     *lock         In        Lda                                                        219491
     C                   Eval      Dbpgm  = PSProcName                                        219491
     C                   Eval      Dbfile = 'SDNARRPD'                                        219491
     C                   Eval      Dbase  = 09                                                219491
     C                   Eval      Dbkey  = BTNVCD                                            219491
     C                   Out       LDA                                                        219491
     C                   Eval      ReturnCode  = PRTCD                                        219491
     C                   Exsr      Repair                                                     219491
     C                   Endif                                                                219491
                                                                                              219491
     C                   Eval      BTNRDC = ALDON                                             219491
                                                                                              219491
     C                   Endif                                                                219491
 
      **--------- End of Currency Number of Decimal Places ----------**
                                                                                              CPB008
      **--------- Start of  Get Portfolio on Account ----------**                             CPB008
      **  Only process if not a delete                                                        CPB008
     C                   If            W_Operation <> 'D '                                    CPB008
                                                                                              CPB008
      **  Set up key for full account.                                                        CPB008
     C                   Eval      Branch      = BTIBCA                                       CPB008
     C                   Move      BTCUST        CustNo                                       CPB008
     C                   Eval      Currency    = BTCYCD                                       CPB008
     C                   Move      BTACCD        AccCode                                      CPB008
     C                   Move      BTACSN        AccSeq                                       CPB008
                                                                                              CPB008
      **  Define key list to access to Account Master Details file.                           CPB008
     C     K_Accnt       Klist                                                                CPB008
     C                   Kfld                    CustNo                                       CPB008
     C                   Kfld                    Currency                                     CPB008
     C                   Kfld                    AccCode                                      CPB008
     C                   Kfld                    AccSeq                                       CPB008
     C                   Kfld                    Branch                                       CPB008
                                                                                              CPB008
      **  Retrieve Account details (Portfolio Reference)                                      CPB008
     C     Branch        IFNE      '   '                                                      CPB008
     C     K_Accnt       Chain     ACCNT                              82                      CPB008
                                                                                              CPB008
      **  If Account does not exist, handle database error.                                   CPB008
     C     *in82         Ifeq      True                                                       CPB008
     C     *lock         In        Lda                                                        CPB008
     C                   Eval      Dbpgm  = PSProcName                                        CPB008
     C                   Eval      Dbfile = 'ACCNT'                             **************CPB008
     C                   Eval      Dbase  = 03                                  * Db Error 03 CPB008
     C                   Eval      DbKey = W_FullSettlAcc                       **************CPB008
     C                   Out       LDA                                                        CPB008
     C                   Eval      ReturnCode  = W_NoRcdFnd                                   CPB008
     C**********         Exsr      *Pssr                                               CPB010 CPB008
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                                CPB008
     C                   Endif                                                                CPB008
                                                                                              CPB008
                                                                                              CPB008
     C                   Endif                                                                CPB008
      **---------- End of Access account ------------**                                       CPB008
                                                                                              CPB008
 
      **  Reformat entire GLJENPPD record (@BTREMG0).
      **  The relevant member in file RPMSGFPD contains details of the fields
      **  in the file to be processed (it is a DSPFFD outfile).
      **  This file must already be set up with the field data for the
      **  file to be processed.
     C                   Eval      CompData = *blanks
     C                   Eval      InData   = GljenDS
     C                   Eval      InDBFile = 'GLJENPPD  '
     C                   Eval      GljenppdData = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      **  The GljenppdData data structure has two sub-fields:
      **     - GljenppdRec which now contains the formatted data, left aligned.
      **     - GljenppdPosA/GljenppdCustPosN which now contains the position of
      **     the first unused byte in GljenppdRec.
 
      **------------------ End of Additionnal fields ----------------**
 
      **  Place the result in field CompData.
 
     C                   Eval      CompData  = %subst(TransData:1:EndPosition)
     C                                       + %subst(GljenppdRec:1:
     C                                                GljenppdPosN-1)
     C                                       + W_CcyNbdp                        Number Dec. Places
     C                                       + A_PTFR                           Portfolio ref CPB008
 
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
 
     C                   Endif                                                  End ReturnCode
                                                                                              CPB010
     C                   Exsr      WrtTrace                                                   CPB010
 
     C                   Endif                                                  End BBPRBA
     C                   Endif                                                  Edn Retail Account
 
      **  Read next Journal Entry Posting record.
     C     K_GLJenp      Reade     GLJENPL1                               81
 
     C                   Enddo                                                  End DO_W_N81
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   If        ReturnCode = *blank                          Begin ReturnCode
     C                   Commit
 
     C                   Endif                                                  End ReturnCode
 
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
     C     *lock         in        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 04                                  * Db Error 04 *
     C                   Eval      DBkey  = 'RPC1305'                           ***************
     C                   Out       Lda
     C                   Exsr      *Pssr
 
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
     C                   Exsr      *Pssr
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
     C                             ' Return :' + ReturnCode +                                 CPB010
     C                             ' Rollback: Check trigger process'                         CPB010
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
      ** At the moment, it's not possible to use repair process                               CPB010
     C                   exsr      *pssr                                                      CPB010
     C                   Return                                                               CPB010
     C                   Endif                                                  End ReturnCodeCPB010
                                                                                              CPB010
     C                   Endsr                                                                CPB010
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
     C                   Eval      Dbase  = 06                                  * Db Error 06 *
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
 
      **  Set up Key List to access to Journal Entry Postings file.
     C     K_GLJenp      Klist
     C                   Kfld                    K_BatchNum
 
     C                   Z-add     0             X                 3 0
 
      **  Retrieve position and length of batch number from GLJENHPD message data.
     C                   Eval      FieldName   = 'BRBTNB'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of batch status flag from GLJENHPD message data.
     C                   Eval      FieldName   = 'BRBTSF'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Front Office Id from GLJENHPD message data.
     C                   Eval      FieldName   = 'BRFRNT'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     C                   ENDSR
      /Eject
      *****************************************************************
**  Cpy@
(c) Misys International Banking Systems Ltd. 2001
