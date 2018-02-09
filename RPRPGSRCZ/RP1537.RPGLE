     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extraction Module for RPEOPSPD')           *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1537 - Extract module for RPEOPSPD                         *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Settlement Account.                         *
      *                 - Settlement Account's Portf. Ref.            *
      *                                                               *
      *  Component of: RP1537 - Extract program for RPEOPSPD          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR970292           Date 14May12               *
      *                 AR213436           Date 26Jun10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  AR213436 - GAP043 - Position Settlement Interface            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Midas SD API Customer Private Banking Details file.
     FSDPBDSL0  IF   E           K Disk
     F                                     Infsr(*PSSR)
 
      **  Midas GL Accounts Master
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
     F                                     Infsr(*PSSR)
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  CHAIN access to SDPBDSL0 failed.                      *
      *  82  -  CHAIN access to ACCNT failed.                         *
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
      *  Repair   - Repair process                                    *
      *  WrtTrace - Trace process                                     *
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
     C/COPY RPCPYSRC,STD_DCL
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C/COPY RPCPYSRC,MDN_HD_DS
 
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
 
     D W_NomCcy        S              3A
     D W_AmountDue     S             13  0
     D W_ChargeAmount  S             13  0
     D W_CommAmount    S             13  0
     D W_TaxAtSource   S             13  0
     D W_TaxRefund     S             13  0
     D W_TaxByUser     S             13  0
     D W_ExchgRate     S             13  8
     D W_ExchgRateA    S             13
     D W_MultDivInd    S              1
 
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
     D W_FullSettlAcc  DS            24
     D   W_Branch              1      3
     D   W_CustNo              4      9
     D   W_Settccy            10     12
     D   W_AccCode            13     22
     D   W_AccSeq             23     24
 
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
 
      ** Start of parameters
 
      **  Output queue name.
     D OutQueue        S                   Like(MQSQueue)
 
      ** End of parameters
 
      ** Start of parameters for RPC1305
 
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
 
      ** End of parameters for RPC1305
      ** Start of Parameters for CPB010
     D MessageInd      S              1A
 
     D RAMSGOLD        S                   LIKE(RAMSGTYPE)
 
      **   Database Error Messsage Text
     D DBErrText       S            256A
 
      **   Transaction Data of associated transaction
     D AssocData       S                   LIKE(TransData)
 
      **   Meridian header Layout of associated transaction
     D MdHdAssoc       S                   LIKE(MdnHeadDs)
      **  End of Parameters for CPB010
 
      ** Start of parameters for ZAGETSETAC
      **  -------
      **  Outputs
      **  -------
      **  Account code.
     D***AccCode         S              4S 0
     D AccCode         S             10S 0
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
     D***CustNo          S              6S 0
     D CustNo          S              6A
      **  ------
      **  Inputs
      **  ------
      **  Settlement type.
     D SettleType      S              2S 0
      **  Settlement account.
     D SettleAcc       S             12A
 
      ** End of parameters for ZAGETSETAC
 
      ** Start of fields used by access programs
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
      **  Key status.
     D P_Kyst          S              7A
      ** End of fields used by access programs
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Work Field used as key to access to Customer PB Details.
     D***K_CustNum       S              6  0
     D K_CustNum       S              6A
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Composite Data.
     D CompData        S                   LIKE(TransData)
 
      **  Start of additional fields
     D W_SettlAccP     S              4A
      ** End of additional fields
 
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
     C                   EVAL      MessageInd = 'Y'
     C                   EVAL      RAMSGOLD = RAMSGTYPE
     C                   EVAL      AssocData = *Blanks
     C                   EVAL      MdHdAssoc = *Blanks
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **  Extract customer number from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'PCPY  '      LOOKUP    Arrfld(X)                              89
     C**********         EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                          AR970292
     C                   EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *blanks       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust
     C                   PARM                    P_Kyst
     C     Sdcust        PARM      Sdcust        Dsldy
 
      **  If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        IFNE      *blanks
     C     BBCLST        ANDNE     'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm      = PSProcName
     C                   EVAL      DBfile     = 'SDCUSTPD'
     C                   EVAL      DBase      = 01
     C                   EVAL      DBkey      = P_Cust
     C                   OUT       Lda
     C                   EVAL      ReturnCode = P_Rtcd
     C                   EXSR      Repair
 
     C                   ENDIF
 
      **  If Customer is not a Private Banking customer, check
      **  Requested PB Customer flag in case it would have been
      **  set to 'Y'.
     C                   IF        BBPRBA      <> 'Y'
 
      **  Define key list to access to Customer PB Details file.
     C     K_SDPbds      KLIST
     C                   KFLD                    K_CustNum
     C                   MOVE      BBCUST        K_CustNum
 
      **  Access to Customer PB Details file.
     C     K_CustNum     CHAIN     SDPBDSL0                           81
 
      **  If Customer PB Details do not exist, handle database error.
     C     *IN81         IFEQ      True
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 02
     C                   EVAL      Dbkey  = BBCUST
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
 
     C                   ENDIF
     C                   ENDIF
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer.
     C                   IF            BBPRBA = 'Y'
     C                             OR  PBREPB = 'Y'
 
      ** Start of Additionnal fields
 
      ** Start of Settlement Full Account
 
      **  Initialize Settlement Full Account
     C                   EVAL      W_FullSettlAcc = *blanks
     C                   EVAL      W_SettlAccP = *blanks
 
      **  Extract Customer Number.
     C                   MOVEL     P_Cust        CustNo
 
      **  Extract Nominal Currency Code.
     C                   Z-ADD     1             X
     C     'PNCY  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_NomCcy = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Settlement Currency Code.
     C                   Z-ADD     1             X
     C     'PSCU  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_Settccy  = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Settlement Branch.
     C                   Z-ADD     1             X
     C     'PSEB  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      Branch = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract settlement method from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'PSMT  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    SettleType
 
      **  If no settlement type, just ignore message
     C     SettleType    IFEQ      *Zeros
     C                   RETURN
     C                   ENDIF
 
      **  Extract Settlement Account.
     C                   Z-ADD     1             X
     C     'PSEA  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      SettleAcc = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Get Settlement Details.
     C                   EXSR      GetSetAc
 
      **  Set up full account only if account details are available.
     C     CustNo        IFNE      *Zeros
     C                   EVAL      W_Branch      = Branch
     C                   MOVE      CustNo        W_CustNo
     C                   MOVE      AccCode       W_AccCode
     C                   MOVE      AccSeq        W_AccSeq
 
      **  Define key list to access to Account Master Details file.
     C     K_Accnt       KLIST
     C                   KFLD                    CustNo
     C                   KFLD                    W_Settccy
     C                   KFLD                    AccCode
     C                   KFLD                    AccSeq
     C                   KFLD                    Branch
 
      **  Retrieve Account details (Portfolio Reference)
     C     K_Accnt       CHAIN     ACCNT                              82
 
      **  If Account does not exist, handle database error.
     C     *IN82         IFEQ      True
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'ACCNT'
     C                   EVAL      Dbase  = 04
     C                   EVAL      DbKey = W_FullSettlAcc
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
     C                   ENDIF
 
     C                   EVAL      W_SettlAccP = A_PTFR
 
     C                   ENDIF
 
      ** End of Settlement Full Account
 
      ** Start of Conversion of Amount
     C     W_NomCcy      IFNE      W_Settccy
 
      **  Extract amount due from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'PAMD  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_AmountDue
 
      **  Extract charge amount from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'PCHA  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_ChargeAmount
 
      **  Extract commission amount from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'PCAM  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_CommAmount
 
      **  Extract tax at source from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'TASO  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_TaxAtSource
 
      **  Extract tax refundable from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'TASR  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_TaxRefund
 
      **  Extract tax by user from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'TAUS  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_TaxByUser
 
      **  Extract exchange rate from RPEOPSPD message data.
     C                   Z-ADD     1             X
     C     'PSXR  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_ExchgRateA
     C                             = %Replace('':
     C                                  %Subst(Transdata:
     C                                         ArrPos(X):
     C                                         ArrLen(X)):
     C                                  %Scan(RCDECSEP:
     C                                        %Subst(Transdata:
     C                                               ArrPos(X):
     C                                               ArrLen(X))):
     C                                  1)
     C                   MOVE      W_ExchgRateA  W_ExchgRate
     C     W_ExchgRate   MULT      10            W_ExchgRate
 
      **  Extract multiply/divide indicator
     C                   Z-ADD     1             X
     C     'PMDI  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_MultDivInd = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
     C                   MOVE      W_NomCcy      P_Curr
     C                   EXSR      GetCcyDet
     C                   MOVE      A6NBDP        ZCDPI
      *
     C                   MOVE      W_Settccy     P_Curr
     C                   EXSR      GetCcyDet
     C                   MOVE      A6NBDP        ZCDPO
      *
      ** Currency Conversion
     C                   CALLB     'ZCONV'
     C                   PARM      W_AmountDue   ZAMTCI           15 0
     C                   PARM      W_ExchgRate   ZEXCH            13 8
     C                   PARM      W_MultDivInd  ZMD               1
     C                   PARM      W_NomCcy      ZCCYI             3
     C                   PARM      W_Settccy     ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
      *
     C                   MOVE      ZAMTCO        WZAMTT_A         13
     C                   Z-ADD     1             X
     C     'PAMD  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      %Subst(TransData:ArrPos(X)+W_PosDebut:+
     C                             ArrLen(X)) = WZAMTT_A
 
     C                   CALLB     'ZCONV'
     C                   PARM      W_ChargeAmountZAMTCI           15 0
     C                   PARM      W_ExchgRate   ZEXCH            13 8
     C                   PARM      W_MultDivInd  ZMD               1
     C                   PARM      W_NomCcy      ZCCYI             3
     C                   PARM      W_Settccy     ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
      *
     C                   MOVE      ZAMTCO        WZAMTT_A         13
     C                   Z-ADD     1             X
     C     'PCHA  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      %Subst(TransData:ArrPos(X)+W_PosDebut:+
     C                             ArrLen(X)) = WZAMTT_A
 
     C                   CALLB     'ZCONV'
     C                   PARM      W_CommAmount  ZAMTCI           15 0
     C                   PARM      W_ExchgRate   ZEXCH            13 8
     C                   PARM      W_MultDivInd  ZMD               1
     C                   PARM      W_NomCcy      ZCCYI             3
     C                   PARM      W_Settccy     ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
      *
     C                   MOVE      ZAMTCO        WZAMTT_A         13
     C                   Z-ADD     1             X
     C     'PCAM  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      %Subst(TransData:ArrPos(X)+W_PosDebut:+
     C                             ArrLen(X)) = WZAMTT_A
 
     C                   CALLB     'ZCONV'
     C                   PARM      W_TaxAtSource ZAMTCI           15 0
     C                   PARM      W_ExchgRate   ZEXCH            13 8
     C                   PARM      W_MultDivInd  ZMD               1
     C                   PARM      W_NomCcy      ZCCYI             3
     C                   PARM      W_Settccy     ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
      *
     C                   MOVE      ZAMTCO        WZAMTT_A         13
     C                   Z-ADD     1             X
     C     'TASO  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      %Subst(TransData:ArrPos(X)+W_PosDebut:+
     C                             ArrLen(X)) = WZAMTT_A
 
     C                   CALLB     'ZCONV'
     C                   PARM      W_TaxRefund   ZAMTCI           15 0
     C                   PARM      W_ExchgRate   ZEXCH            13 8
     C                   PARM      W_MultDivInd  ZMD               1
     C                   PARM      W_NomCcy      ZCCYI             3
     C                   PARM      W_Settccy     ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
      *
     C                   MOVE      ZAMTCO        WZAMTT_A         13
     C                   Z-ADD     1             X
     C     'TASR  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      %Subst(TransData:ArrPos(X)+W_PosDebut:+
     C                             ArrLen(X)) = WZAMTT_A
 
     C                   CALLB     'ZCONV'
     C                   PARM      W_TaxByUser   ZAMTCI           15 0
     C                   PARM      W_ExchgRate   ZEXCH            13 8
     C                   PARM      W_MultDivInd  ZMD               1
     C                   PARM      W_NomCcy      ZCCYI             3
     C                   PARM      W_Settccy     ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
      *
     C                   MOVE      ZAMTCO        WZAMTT_A         13
     C                   Z-ADD     1             X
     C     'TAUS  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      %Subst(TransData:ArrPos(X)+W_PosDebut:+
     C                             ArrLen(X)) = WZAMTT_A
     C                   ENDIF
      ** End of Conversion of Amount
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   EVAL      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      IFEQ      0
     C     *Lock         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'MSG Type'
     C                   EVAL      DBase  = 06
     C                   EVAL      DBkey  = RAMSGTYPE
     C                   OUT       Lda
     C                   EVAL      ReturnCode = 'Image_Type'
 
     C                   EVAL      MessageInd = 'N'
     C                   EXSR      Repair
     C                   EVAL      MessageInd = 'Y'
     C                   ENDIF
 
     C                   EVAL      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
 
      **  Place the result in field CompData.
 
     C                   EVAL      CompData = %subst(TransData:1:EndPosition)
     C                                      + W_FullSettlAcc
     C                                      + W_SettlAccP
 
      ** End of Additionnal fields
 
      **  Call a standard routine to actually send the message.
     C                   CALLB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   IF        ReturnCode <> *blank
     C     *Lock         IN        LDA
     C                   MOVE      'RPSNDMSG  '  DBpgm
     C                   OUT       Lda
     C                   EXSR      Repair
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   ELSE
 
     C                   EXSR      WrtTrace
     C                   COMMIT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
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
 
     C     RtvPos        BEGSR
 
     C                   CALLB     'RPC1305'
     C                   PARM                    ScriptName
     C                   PARM      RAMSGTYPE     ImageName
     C                   PARM                    FieldName
     C                   PARM                    FieldType
     C                   PARM                    TransData
     C                   PARM      0             FieldPosition
     C                   PARM      0             FieldLength
     C                   PARM      *blank        FieldValue
     C                   PARM      *blank        ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     ReturnCode    IFNE      *blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 07
     C                   EVAL      DBkey  = 'RPC1305'
     C                   OUT       LDA
 
     C                   EVAL      MessageInd = 'N'
     C                   EXSR      Repair
     C                   EVAL      MessageInd = 'Y'
     C                   ENDIF
 
     C                   EVAL      X = X + 1
      **  If any error occurred while retrieving position, handle it.
     C                   IF        X > 100
     C     *Lock         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 08
     C                   EVAL      DBkey  = 'Index  '
     C                   OUT       LDA
     C                   EXSR      Repair
     C                   ENDIF
 
     C                   EVAL      ArrFld(X) = FieldName
     C                   EVAL      ArrPos(X) = FieldPosition
     C                   EVAL      ArrLen(X) = FieldLength
 
     C                   ENDSR
      /Eject
      *****************************************************************
      *                                                               *
      *  WrtTrace - Write a Trace of outgoing messages.               *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     WrtTrace      BEGSR
 
     C                   CALLB     'RP1590'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     ReturnCode    IFNE      *blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 08
     C                   EVAL      DBkey  = 'RP1590'
     C                   OUT       Lda
 
     C                   ENDIF
     C                   ENDSR
 
      /Eject
      *****************************************************************
      *                                                               *
      *  Repair   - Write a Trace of outgoing messages to repair      *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     Repair        BEGSR
 
     C                   MOVE      Dbase         dbasea            3
 
     C                   EVAL      DBErrText = 'DBError' +
     C                             ' in : ' + DBpgm +
     C                             ' at: ' + DBasea +
     C                             ' file : ' + DBfile +
     C                             ' Key : ' + DBKey +
     C                             ' Return :' + ReturnCode
 
     C                   EVAL      RAMSGTYPE = RAMSGOLD
 
     C                   CALLB     'RP1592'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    TransData
     C                   PARM                    MdHdAssoc
     C                   PARM                    AssocData
     C                   PARM                    CommitCtl
     C                   PARM                    DBErrText
     C                   PARM                    MessageInd
     C                   PARM      *Blanks       ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     ReturnCode    IFNE      *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 50
     C                   EVAL      DBkey  = 'RP1592'
     C                   OUT       Lda
 
     C                   EXSR      *PSSR
     C                   ELSE
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
 
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
 
     C     GetSetAc      BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAGETSETAC'
      **  Outputs
      **  -------
      **  Return code (10A).
     C                   PARM                    ReturnCode
      ****Account*code*(4,0S).*****************************************
      **  Account code (10,0S).
     C                   PARM                    AccCode
      **  Account sequence (2,0S).
     C                   PARM                    AccSeq
      **  MEMOS update required.
     C                   PARM                    MemosInd
      **  PRONO update required.
     C                   PARM                    PronoInd
      **  Input/output
      **  Transaction branch (3A) (can also be returned).
     C                   PARM                    Branch
      **  Tansaction customer (6,0S) (can also be returned).
     C                   PARM                    CustNo
      **  Sttlement currency (3A) (can also be returned).
     C                   PARM                    W_Settccy
      **  Inputs
      **  Settlement type (2,0S)
     C                   PARM                    SettleType
      **  Settlement account (12A)
     C                   PARM                    SettleAcc
 
      **  Retrieve data area QTEMP/APDUMP to check if any error
      **  occurred while getting Settlement Details without
      **  return code being set up.
     C                   IN        Apdump
 
      **  If any error occurred while getting Settlement Details, handle it.
     C     ReturnCode    IFNE      *blanks
     C     ARErrMod      ORNE      *blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 09
     C                   EVAL      DBkey  = 'ZAGETSETAC'
     C                   OUT       LDA
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      Repair
 
 
     C                   ENDIF
 
     C                   ENDSR
      /Eject
      *****************************************************************
      *                                                               *
      *  GetCcyDet - get currency details.                            *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     GetCcyDet     BEGSR
 
      **  Access to Currency Details, by using access object.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *blank        P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Curr            3
     C     Sdcurr        PARM      Sdcurr        Dssdy
 
      **  If currency does not exist, handle database error.
     C     P_Rtcd        IFNE      *blanks
     C     *lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDCURRPD'
     C                   EVAL      Dbase  = 10
     C                   EVAL      Dbkey  = P_Curr
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = P_RTCD
     C                   EXSR      Repair
 
     C                   ENDIF
 
     C                   ENDSR
 
      /Eject
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXS
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     W_RunBefore   IFEQ      *Blank
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
     C                   IF        CommitCtl = 'Y'
     C                   ROLBK
 
     C                   ENDIF
 
     C     *Lock         IN        LDA
     C     DBpgm         IFEQ      *Blanks
     C                   MOVE      PSProcName    DBpgm
     C                   OUT       LDA
 
     C                   ENDIF
 
     C                   MOVE      'Y'           W_RunBefore
     C                   DUMP
 
     C                   ENDIF
 
     C     ReturnCode    IFEQ      *Blank
     C                   EVAL      ReturnCode = '*PSSR'
     C                   ENDIF
 
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
      /Eject
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        BEGSR
 
     C     *Entry        PLIST
      ** MQSeries queue to write to - this parameter IS used in this module
     C                   PARM                    OutQueue
      ** Merdian header
     C                   PARM                    MdnHeadDS
      ** Transaction Data
     C                   PARM                    TransData
      ** Commitment control flag
     C                   PARM                    CommitCtl
      ** Return Code
     C                   PARM                    ReturnCode
 
     C                   EVAL      MessageInd = 'Y'
 
      **  Set up work fields for formatting that will not change if
      **  Replication formatting is required.
      **     - signs are not shown for Positive numbers.
      **     - get decimal separator from Replication data area RPDFTSDA.
     C                   IN        RPDftsDa
     C                   EVAL      fmDecSep   = RCDECSEP
     C                   EVAL      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   MOVE      fmDpLen       W_PosDebut
     C                   EVAL      fmShwPsSgn = 'N'
 
      **  Set up work fields that will not change if retrieve
      **  function is to be used.
     C                   EVAL      ScriptName = 'RP' + RATGTSYS
 
     C                   Z-ADD     0             X                 3 0
 
      **  Retrieve position and length of customer number from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PCPY'
     C**********         EVAL      FieldType = 'N'                                          AR970292
     C                   EVAL      FieldType = 'A'                                          AR970292
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of nominal ccy from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PNCY'
     C                   EVAL      FieldType = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of settlement ccy from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PSCU'
     C                   EVAL      FieldType = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of settlement branch from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PSEB'
     C                   EVAL      FieldType = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of settlement method from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PSMT'
     C                   EVAL      FieldType = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of settlement account from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PSEA'
     C                   EVAL      FieldType = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of amount due from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PAMD'
     C                   EVAL      FieldType = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of charge amount from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PCHA'
     C                   EVAL      FieldType = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of commission amount from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PCAM'
     C                   EVAL      FieldType = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of tax at source from RPEOPSPD message data.
     C                   EVAL      FieldName = 'TASO'
     C                   EVAL      FieldType = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of tax deductable from RPEOPSPD message data.
     C                   EVAL      FieldName = 'TASR'
     C                   EVAL      FieldType = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of tax by user from RPEOPSPD message data.
     C                   EVAL      FieldName = 'TAUS'
     C                   EVAL      FieldType = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of exchange rate from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PSXR'
     C                   EVAL      FieldType = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of mul/div indicator from RPEOPSPD message data.
     C                   EVAL      FieldName = 'PMDI'
     C                   EVAL      FieldType = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   EVAL      FieldName   = '*END_IMAGE'
     C                   EVAL      FieldType   = *blank
     C                   EXSR      RtvPos
     C                   EVAL      EndPosition = FieldPosition - 1
 
     C                   Endsr
      /Eject
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2010
