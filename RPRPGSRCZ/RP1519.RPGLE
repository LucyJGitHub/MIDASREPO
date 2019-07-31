     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Extraction Module for CLOSTD')                *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian DBA Replication                             *
      *                                                               *
      *  RP1519 - Extract module for CLOSTD                           *
      *                                                               *
      *  Function:  This module only sends transactions for Private   *
      *  (I/C)      Banking Customers.                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR858264A          Date 16Jul12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245777             Date 19Feb07               *
      *                 240567             Date 21Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CAS010             Date 09Feb05               *
      *                 223644             Date 16Jan03               *
      *                 220430             Date 26Aug03               *
      *                 CPB010             Date 16Jan03               *
      *                 CPB008             Date 15Oct02               *
      *                 203729             Date 08Mar02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196240             Date 24Oct01               *
      *                 196084             Date 24Oct01               *
      *                 195907             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  245777 - Apply 240567                                        *
      *  240567 - Avoid Database Error when sending message to repair *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  220430 - Add Close Out Date on CLOSTT messages.              *
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
      *           - Add portfolio reference to output message to      *
      *             avoid ODBC Client Access.                         *
      *  203729 - Remove *inlr                                        *
      *           Setup correctly w_cori_after                        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  196240 - In case of delete of Close Out, do NOT send any     *
      *           messages relative to CLOSTT. Just send one CLOSTD.  *
      *  196084 - Add Customer Code and Portfolio from transaction    *
      *           file on message sent to TOF                         *
      *  195907 - Only send Insert of Close Out or                    *
      *           Delete (CORI change from 'N' to 'Y')                *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         CHAIN access to CLOST10 failed                  *
      *    81         General file-access indicator                   *
      *    82         CHAIN access to ACCNT failed                    *                       CPB008
      *    89         General-purpose indicator                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRRtvPos   - retrieve position in Meridian message.          *
      *  Repair   - Repair process                                    *                       CPB010
      *  WrtTrace - Trace process                                     *                       CPB010
      *  *PSSR    - Program exception error routine                   *
      *  *INZSR   - Program Initialization routine.                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD API Customer Private Banking Details file.
     FSDPBDSL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas FF Transaction details - detail.
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas FF Close Out Transacts details - detail.
     FCLOST10   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOSTTF:CLOSTTF10)
      **  Midas GL Accounts Master                                                            CPB008
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)               CPB008
     F                                     Infsr(*Pssr)                                       CPB008
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** External Data structure for Local data area (db error details).
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
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
 
      ** Declaration of fields passed to formatting routines
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
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
 
      ** First Data Structure for Access Programs, short Data Structure
     D Dsfdy         E DS                  Extname(DSFDY)
 
      ** Second Data Structure for Access Programs, long Data Structure
     D Dssdy         E DS                  Extname(DSSDY)
 
      ** Third Data structure for Access Programs
     D Dsldy         E DS                  Extname(DSLDY)
 
      ** Data Structure for access to Customer Details.
     D SdCust        E DS                  Extname(SDCUSTPD)
 
      **  Data structure used to group settlement account details.                            CPB008
     D*W_FullSettlAcc  DS            18                                                CPB008 CAS010
     D W_FullSettlAcc  DS            24                                                       CAS010
     D   Branch                1      3                                                       CPB008
     D***CustNo*               4      9S 0                                             CPB008 CSD027
     D   CustNo                4      9                                                       CSD027
     D   A_cust                4      9                                                       CPB008
     D   Currency             10     12                                                       CPB008
     D***A_ACode              13     16                                                CPB008 CAS010
     D***AccCode              13     16S 0                                             CPB008 CAS010
     D***A_ASeq*              17     18                                                CPB008 CAS010
     D***AccSeq*              17     18S 0                                             CPB008 CAS010
     D   A_ACode              13     22                                                       CAS010
     D   AccCode              13     22S 0                                                    CAS010
     D   A_ASeq               23     24                                                       CAS010
     D   AccSeq               23     24S 0                                                    CAS010
                                                                                              CPB008
      ** External data structure for Bank Details.
     D SdBank        E DS                  Extname(SDBANKPD)
 
      ** Structure based on Close out Transaction file used to
      ** pass data to procedure ProcFormat.
     D ClosttDs      E DS                  Extname(CLOSTT)
 
      ** Structure to receive a formatted Close out Transaction
      ** record from procedure ProcFormat.
      ** ClosttPosA (and ClosttPosN) contain the position of the first unused
      ** position in ClosRec. If the input data is blank at the end this
      ** could be well after the last non-blank character.
     D ClosttData      DS
     D  ClosttRec                          Like(TransData)
     D  ClosttPosA                    4
     D  ClosttPosN                    4S 0 Overlay(ClosttPosA)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of parameters --------------------**
      ** Output queue name.
     D OutQueue        S                   LIKE(MQSQueue)
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
      ** Return code
     D P_RtCd          S              7A
      ** Option
     D P_Optn          S              7A
      ** Customer
     D P_Cust          S             10A
      ** Key status
     D P_Kyst          S              7A
      ** ---------- End of fields used by access programs -----------**
 
      ** Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      ** End Position
     D WEndPos         S              7S 0
 
      ** ----------- Start of parameters for ProcFormat -------------**
     D InData          S                   LIKE(TransData) INZ(*BLANKS)
     D InDBFile        S             10A   INZ(*BLANKS)
      **------------- End of Parameters for ProcFormat --------------**
 
      ** Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6                                                       CSD027
 
      ** Work Field used as key to access to Transaction Details.
     D K_Trans         S              6  0
 
      ** Work Field used as key to access to Close Out Transacts.
     D K_Close         S              6  0
 
      **----------------  Start of additional fields ----------------**
     D W_Broker        S              8A
     D W_Instrument    S              5A
     D W_Year          S              4A
     D W_Month         S              4A
     D W_PutCall       S              1A
     D W_Price         S             17A
     D W_InstCcy       S              3A
     D W_Cusc          S              8A                                        196084
     D*W_STTA***       S             15A                                               CPB008 CAS010
     D W_STTA          S             21A                                                      CAS010
     D W_STTB          S              3A                                                      CPB008
     D W_Portfolio     S              4A                                        196084
     D W_CloseOutDate  S              5A                                        220430
      **-----------------  End of additional fields -----------------**
 
      ** Composite Data
     D CompData        S                   LIKE(TransData)
 
      ** Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      ** Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      ** Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** Work Field used to retrieve CORI of the message (Close Out
      **    Reversal Ind.)
     D W_CORI          S              1A
     D W_CORI_After    S              1A                                        195907
 
      ** Work Field used to process replication
     D W_Process       S              1A
 
      ** Work Field used to check type of message (A: After; B: Before)
     D W_Type          S              1A
 
      ** Work Field used to retrieve the Operation
     D W_Operation     S              2A
 
      ** Work Field used to retrieve the Table
     D W_Table         S             18A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
 
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
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                                       CPB010
 
     C                   EVAL      X = 1                                                      203729
     C     'CORI  '      LOOKUP    WArFld(X)                              89                  203729
      ** Check image (Before or After) of the message
     C                   EVAL      W_PosFin    = %Scan('_B':RAMSGTYPE)
      ** Before Image Type
     C     W_PosFin      IFNE      0
     C                   EVAL      W_Type = 'B'
     C                   Eval      ImageType = 'Amend Before'                                 CPB010
     C                   Eval      AssocData = TransData                                      CPB010
     C                   Eval      MdHdAssoc = MdnHeadDs                                      CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C**********         EVAL      X = 1                                                      203729
     C*****'CORI  '      LOOKUP    WArFld(X)                              89                  203729
     C                   EVAL      W_CORI = %Subst(TransData:+
     C                             WArPos(X):WArLen(X))
     C                   Else                                                   195907
                                                                                              CPB010
     C                   If        ImageType <> 'Amend Before'                                CPB010
     C                   Eval      ImageType = 'Insert'                                       CPB010
     C                   Eval      AssocData = *Blanks                                        CPB010
     C                   Eval      MdHdAssoc = *Blanks                                        CPB010
     C                   Else                                                                 CPB010
     C                   Eval      ImageType = 'Amend After'                                  CPB010
     C                   EndIf                                                                CPB010
                                                                                              CPB010
     C                   Eval      W_CORI_After = %Subst(TransData:+            195907
     C                             WArPos(X):WArLen(X))                         195907
     C                   ENDIF
 
      ** After Image Type: Process if CORI has be changed from 'N' to 'Y'
     C*****W_PosFin      Ifeq      0                                            195907
     C*****W_Type        Ifeq      'B'                                          195907
     C*****W_CORI        Andeq     'N'                                          195907
     C*****W_Type        Orne      'B'                                          195907
     C**********         Eval      W_Process = 'Y'                              195907
     C**********         Endif                                                  195907
     C**********         Eval      W_Type = 'A'                                 195907
     C**********         Endif                                                  195907
 
      **  After Image Type: Process if CORI has be changed from 'N' to 'Y'      195907
     C     W_Type        Ifeq      'A'                                          195907
     C     W_CORI        Oreq      'N'                                          195907
     C     W_CORI_After  Andeq     'Y'                                          195907
     C     W_PosFin      Andeq     0                                            195907
     C                   Eval      W_Process = 'Y'                              195907
     C                   Endif                                                  195907
      *** Message After                                                         195907
     C     W_PosFin      Ifeq      0                                            195907
     C                   Eval      W_Type = 'A'                                 195907
     C                   Endif                                                  195907
                                                                                195907
      ** If Amend mode and CLose Out Reversal (CORI) begin changed from 'N' be bypassed
      ** was already to 'Y' before,  Update should be bypassed
     C     W_Process     IFEQ      'Y'
     C                   EVAL      W_Process = *BLANKS
 
      ** Send first the message for CLOSTD
 
      ** Extract customer number from CLOSTD message data.
     C                   Z-ADD     1             X
     C     'CUSC  '      LOOKUP    WArFld(X)                              89
     C**********         EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C**********                   WArPos(X)+W_PosDebut:WArLen(X))                          AR970292
     C                   EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C                             WArPos(X):WArLen(X))                                     AR970292
 
     C                   EVAL      BBPRBA = *BLANKS
     C     P_Cust        IFNE      '000000    '
     C     P_Cust        ANDNE     *BLANKS
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
     C                   EVAL      DBfile = 'SDCUSTPD'
     C                   EVAL      DBase  = 01
     C                   EVAL      DBkey  = P_Cust
     C                   OUT       LDA
     C                   EVAL      ReturnCode =  P_Rtcd
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
     C     K_CustNum     CHAIN     SDPBDSL0                           81
      ** If Customer PB Details do not exist, handle database error.
     C     *in81         IFEQ      *ON
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
     C                             Or  PBREPB = 'Y'
                                                                                              CPB008
      **--------- Start of  Get Portfolio on Account ----------**                             CPB008
                                                                                              CPB008
      ** Extract Settlement account   CLOSTD message data.                                    CPB008
     C                   Z-ADD     1             X                                            CPB008
     C     'STTA  '      LOOKUP    WArFld(X)                              89                  CPB008
     C                   EVAL      W_STTA = %Subst(TransData:+                                CPB008
     C                             WArPos(X):WArLen(X))                                       CPB008
                                                                                              CPB008
      ** Extract Settlement Branch    CLOSTD message data.                                    CPB008
     C                   Z-ADD     1             X                                            CPB008
     C     'STTB  '      LOOKUP    WArFld(X)                              89                  CPB008
     C                   EVAL      W_STTB = %Subst(TransData:+                                CPB008
     C                             WArPos(X):WArLen(X))                                       CPB008
                                                                                              CPB008
      **  Set up key for full account.                                                        CPB008
     C                   Eval      Branch      = W_STTB                                       CPB008
     C                   EVAL      A_Cust      =                                              CPB008
     C                             %Subst(W_STTA:1:6)                                         CPB008
     C                   Eval      Currency    =                                              CPB008
     C                             %Subst(W_STTA:7:3)                                         CPB008
     C                   Eval      A_ACode     =                                              CPB008
     C**********                   %Subst(W_STTA:10:4)                                 CPB008 CAS010
     C                             %Subst(W_STTA:10:10)                                       CAS010
     C                   Eval      A_ASeq      =                                              CPB008
     C**********                   %Subst(W_STTA:14:2)                                 CPB008 CAS010
     C                             %Subst(W_STTA:20:2)                                        CPB008
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
     C     K_Accnt       Chain     ACCNT                              82                      CPB008
                                                                                              CPB008
      **  If Account does not exist, handle database error.                                   CPB008
     C     *in82         Ifeq      *on                                          Begin *in82   CPB008
     C     *lock         In        Lda                                                        CPB008
     C                   Eval      Dbpgm  = PSProcName                                        CPB008
     C                   Eval      Dbfile = 'ACCNT'                             ************* CPB008
     C                   Eval      Dbase  = 10                                  * Db Err 10 * CPB008
     C                   Eval      DbKey = W_FullSettlAcc                       ************* CPB008
     C                   Out       LDA                                                        CPB008
     C                   Eval      ReturnCode  = W_NoRcdFnd                                   CPB008
     C**********         Exsr      *Pssr                                               CPB008 CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End  *in82    CPB008
                                                                                              CPB008
      **---------- End of Access account ------------**                                       CPB008
 
      ** Change message Type from _After to _A
      ** Determine Image Type.
     C                   EVAL      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      ** If it is impossible to determine the image type, handle error.
     C     W_PosFin      IFEQ      0
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'MSG Type'
     C                   EVAL      DBase  = 03
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
 
      ** Retrieve operation in message.
     C                   EVAL      W_Operation = %subst(TransData:1:2)
 
      ** Place the result in field CompData.
     C                   EVAL      CompData  = %subst(TransData:1:WEndPos)
     C                                       + A_PTFR                           Portfolio ref CPB008
 
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
     C                   EVAL      DBfile = 'RPSNDMSG'
     C                   EVAL      DBase  = 04
     C                   EVAL      DBkey  = '*CALL   '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
      ** If no error, commit the unit of work so that messages that have
      ** been got from a queue would be permanently deleted and put
      ** operations would be made permanent.
     C                   ELSE
                                                                                              CPB010
     C                   Exsr      WrtTrace                                                   CPB010
     C                   COMMIT
     C                   ENDIF
 
      **----------------- Start of Additionnal Messages ---------------**
                                                                                196240
      **  Do not send CLOSTT messages when delete (Amend with field CORI = 'Y') 196240
     C     W_CORI_After  Ifne      'Y'                                          196240
                                                                                220430
      ** Extract Close Out date from CLOSTD message data.                       220430
     C                   Z-ADD     1             X                              220430
     C     'CLOD  '      LOOKUP    WArFld(X)                              89    220430
     C                   EVAL      W_CloseOutDate = %Subst(TransData:+          220430
     C                             WArPos(X)+W_PosDebut:WArLen(X))              220430
 
      ** Extract Close Out Number from CLOSTD message data.
     C                   Z-ADD     1             X
     C     'CLON  '      LOOKUP    WArFld(X)                              89
     C                   EVAL      PFldVal = %Subst(TransData:+
     C                             WArPos(X)+W_Posdebut:WArLen(X))
     C                   MOVEL     PFldVal       K_Close
 
      ** Define key list to access to FF Close Out Transacts.
     C     K_Clostt      KLIST
     C                   KFLD                    K_Close
 
      ** Position to first Close Out Transacts from CLOSTT.
     C     K_Clostt      SETLL     CLOST10
     C     K_Clostt      READE     CLOST10                                01
 
      ** Do while Close out to be processed.
     C     *in01         DOWEQ     *OFF
 
      ** Reformat entire CLOSTT record (CLOSTTF).
      ** The relevant member in file RPMSGFPD contains details of
      ** fields in the file to be processed (it is a DSPFFD outfile).
      ** This file must already be set up with the field data for the
      ** file to be processed.
     C                   EVAL      InData   = ClosttDS
     C                   EVAL      InDBFile = 'CLOSTT    '
     C                   EVAL      ClosttData = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      ** The ClosettData data structure has two sub-fields:
      **    - ClosttRec which now contains the formatted data, left aligned.
      **    - ClosttPosA/ClosettPosN which now contains the position of
      **      the first unused byte in ClosttRec.
 
      **------------------ Start of Additionnal fields ----------------**
      ** Define key list to access to FF Transaction Details.
     C     K_Transd      KLIST
     C                   KFLD                    K_Trans
 
     C                   MOVEL     TNBR          K_Trans
 
      ** Access to Transaction details to retrieve value of BOCO
     C     K_Trans       CHAIN     TRANS2                             81
      ** If Transaction Details do not exist, handle database error.
     C     *in81         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'TRANSD'
     C                   EVAL      Dbase  = 05
     C                   MOVEL     K_Trans       DBKey
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   ENDIF
 
     C                   EVAL      W_Broker = *BLANKS
     C                   EVAL      W_Instrument = *BLANKS
     C                   EVAL      W_Year = *BLANKS
     C                   EVAL      W_Month = *BLANKS
     C                   EVAL      W_PutCall = *BLANKS
     C                   EVAL      W_Price = *BLANKS
     C                   EVAL      W_InstCcy = *BLANKS
     C                   Eval      W_Cusc = *Blanks                             196084
     C                   Eval      W_Portfolio = *Blanks                        196084
 
     C                   EVAL      fmLength = 6
     C                   EVAL      fmDecPos = 0
     C*****              EVAL      fmSign3010 = BOCO                                          CSD027
     C*****              EVAL      fmAlpNum32 =                                               CSD027
     C*****                           ProcSigned(fmSign3010 : fmLength :                      CSD027
     C*****                                      fmDecPos : fmDecSep :                        CSD027
     C*****                                      fmShwPsSgn)                                  CSD027
     C*****              EVAL      W_Broker  = %subst(fmAlpNum32 : 1 : 8)                     CSD027
     C                   EVAL      W_Broker  = BOCO                                           CSD027
 
     C                   MOVEL     ISTT          W_Instrument
 
     C                   EVAL      fmLength = 2
     C                   EVAL      fmDecPos = 0
     C                   EVAL      fmSign3010 = YRNO
     C                   EVAL      fmAlpNum32 =
     C                                ProcSigned(fmSign3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_Year  = %subst(fmAlpNum32 : 1 : 4)
 
     C                   EVAL      fmLength = 2
     C                   EVAL      fmDecPos = 0
     C                   EVAL      fmSign3010 = MTHN
     C                   EVAL      fmAlpNum32 =
     C                                ProcSigned(fmSign3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_Month = %subst(fmAlpNum32 : 1 : 4)
 
     C                   MOVEL     PCAL          W_PutCall
 
     C                   EVAL      fmLength = 15
     C                   EVAL      fmDecPos =  8
     C                   EVAL      fmPack3010 = STRP
     C                   EVAL      fmAlpNum32  =
     C                                ProcPacked(fmPack3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_Price = %subst(fmAlpNum32 : 1 : 17)
 
     C                   MOVEL     ISCY          W_InstCcy
                                                                                196084
     C                   EVAL      fmLength = 6                                 196084
     C                   EVAL      fmDecPos = 0                                 196084
     C*****              EVAL      fmSign3010 = CUSC                                   196084 CSD027
     C*****              EVAL      fmAlpNum32 =                                        196084 CSD027
     C*****                           ProcSigned(fmSign3010 : fmLength :               196084 CSD027
     C*****                                      fmDecPos : fmDecSep :                 196084 CSD027
     C*****                                      fmShwPsSgn)                           196084 CSD027
     C*****              EVAL      W_Cusc = %subst(fmAlpNum32 : 1 : 8)                 196084 CSD027
     C                   EVAL      W_Cusc = CUSC                                              CSD027
                                                                                196084
     C                   Movel     PTFR          W_Portfolio                    196084
      **------------------ End of Additionnal fields ----------------**
 
      ** Change message Type for CLOSTT
     C                   EVAL      RAMSGTYPE = 'CLOSTT_A'
 
     C                   EVAL      CompData  = *BLANKS
     C                   EVAL      W_Table = 'CLOSTT'
      ** Place the result in field CompData.
     C                   EVAL      CompData  = W_Operation
     C                                       + W_Table
     C                                       + %subst(ClosttRec:1:
     C                                                ClosttPosN-1)
     C                                       + W_Broker
     C                                       + W_Instrument
     C                                       + W_Year
     C                                       + W_Month
     C                                       + W_PutCall
     C                                       + W_Price
     C                                       + W_InstCcy
     C                                       + W_Cusc                           196084
     C                                       + W_Portfolio                      196084
     C                                       + W_CloseOutDate                   220430
 
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
     C                   EVAL      DBfile = 'RPSNDMSG'
     C                   EVAL      DBase  = 06
     C                   EVAL      DBkey  = '*CALL   '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
      ** If no error, commit the unit of work so that messages that have
      ** been got from a queue would be permanently deleted and put
      ** operations would be made permanent.
     C                   ELSE
                                                                                              CPB010
     C                   Exsr      WrtTrace                                                   CPB010
     C                   COMMIT
     C                   ENDIF
 
     C     K_Clostt      READE     CLOST10                                01
 
     C                   ENDDO
                                                                                196240
     C                   Endif                                                  196240
 
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         MOVE      *ON           *INLR                                        203729
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvPos - Retrieve position in Meridian message.            *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls:     RPC1305, *PSSR                                    *
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
     C                   EVAL      DBase  = 07
     C                   EVAL      DBkey  = '*CALL   '
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
     C                   EVAL      DBase  = 08
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
     C                   Eval      DBase  = 08                                  * Db Error 8 *CPB010
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
     C                   Eval      DBkey  = 'RP1592'                            **************PB213
     C                   Out       Lda                                                        CPB010
                                                                                              CPB010
     C                   exsr      *pssr                                                      CPB010
     C                   Else                                                                 CPB010
      ***At*the*moment,*it's*not*possible*to*use*repair*process********                CPB010 240567
     C**********         exsr      *pssr                                                      240567
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
 
     C     *ENTRY        PLIST
      ** MQSeries queue to write to - this parm is used in this module
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
 
     C                   EVAL      DBpgm  = PSProcName
 
      ** Access Bank details by using access program.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*FIRST '     P_optn
     C     Sdbank        PARM      Sdbank        DsFdy
     C     P_Rtcd        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SDBANKPD'
     C                   EVAL      Dbase  = 09
     C                   EVAL      Dbkey  = '*FIRST'
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                                      CPB010
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
 
      ** Retrieve position and length of cust. no. from CLOSTD msg data
     C                   EVAL      PFldName    = 'CUSC'
     C**********         EVAL      PFldType    = 'N'                                        AR970292
     C                   EVAL      PFldType    = 'A'                                        AR970292
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of Close Out Number from
      **    CLOSTD message data
     C                   EVAL      PFldName    = 'CLON'
     C                   EVAL      PFldType    = 'N'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of Close Out Reversal Ind. from
      **    CLOSTD message data
     C                   EVAL      PFldName    = 'CORI'
     C                   EVAL      PFldType    = 'A'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of Close Out Settlement account                         CPB008
      **    CLOSTD message data                                                               CPB008
     C                   EVAL      PFldName    = 'STTA'                                       CPB008
     C                   EVAL      PFldType    = 'A'                                          CPB008
     C                   EXSR      SRRtvPos                                                   CPB008
                                                                                              CPB008
      ** Retrieve position and length of Close Out Settlement account  branch                 CPB008
      **    CLOSTD message data                                                               CPB008
     C                   EVAL      PFldName    = 'STTB'                                       CPB008
     C                   EVAL      PFldType    = 'A'                                          CPB008
     C                   EXSR      SRRtvPos                                                   CPB008
                                                                                220430
      ** Retrieve position and length of Close Out Date from                    220430
      **    CLOSTD message data                                                 220430
     C                   EVAL      PFldName    = 'CLOD'                         220430
     C                   EVAL      PFldType    = 'N'                            220430
     C                   EXSR      SRRtvPos                                     220430
                                                                                220430
      ** Retrieve begin position of additionnal fields in Meridian msg
     C                   EVAL      PFldName    = '*END_IMAGE'
     C                   EVAL      PFldType    = *BLANK
     C                   EXSR      SRRtvPos
     C                   EVAL      WEndPos     = PFldPos - 1
 
     C                   EVAL      W_CORI = *BLANKS
     C                   Eval      W_Type = 'A'                                 195907
 
     C                   ENDSR
      *****************************************************************
