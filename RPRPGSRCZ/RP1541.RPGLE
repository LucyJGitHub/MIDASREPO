     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extract pgm binding program - GLATMIPD')   *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1541 - Extract module for GLATMIPD                         *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Currency Number of Decimal Places.          *
      *                 - Portfolio reference (Account).              *
      *                 - Reversal Indicator.                         *
      *                 - DR/CR/FEE Indicator.                        *
      *                                                               *
      *  Component of: RP1541 - Extract program for GLATMIPD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1026202 *CREATE  Date 15Oct12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1026202 - PBS Compatibility with BankFusion Midas 2.00     *
      *              Interface "Account Transfer" in real time        *
      *              (Child:AR1026203)                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Midas SD API Customer Private Banking Details file.
     FSDPBDSL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
 
      **  Midas GL Accounts Master
     FACCNT     IF   E           K DISK    IGNORE(ACCNTAAF:ACCNTACF)
     F                                     PREFIX(A_)
     F                                     INFSR(*PSSR)
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  82  -  CHAIN access to SDPBDSL0/ACCNT failed.                *
      *  89  -  Lookup error                                          *
      *                                                               *
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
      *       * 81   xx   83   84   85   86   87   88   xx   90 *     *
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
      *  SendMsg  - Send message to TOF                               *
      *  CheckFees - extract fee amount                               *
      *  RtvPos   - retrieve position in Meridian message.            *
      *  Repair   - Repair process                                    *
      *  WrtTrace - Trace process                                     *
      *  GetDecPl - get decimal place                                 *
      *  *Pssr    - Program exception error routine                   *
      *  *Inzsr   - Program Initialization routine.                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,STD_DCL
 
      ** The following /COPY contains the layout of the Meridian header
      ** as a data structure
     C/COPY RPCPYSRC,MDN_HD_DS
 
      ** Following /COPY is the declares for fields passed to the
      ** formatting routines
     C/COPY RPCPYSRC,RPFMTDCL
 
      ** Following /COPY is the procedure prototype for the Packed
      ** routine
     C/COPY RPCPYSRC,RPFMTPPP
 
      ** Following /COPY is the procedure prototype for the Signed
      ** routine
     C/COPY RPCPYSRC,RPFMTPPS
 
      ** Following /COPY is the procedure prototype for the Format
      ** routine that is used to process an entire record
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
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  Arrays used to store Position and Length of each fields
     D ArrFld          S              6    DIM(100)
     D ArrPos          S              7  0 DIM(100)
     D ArrLen          S              4  0 DIM(100)
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    EXTNAME(RPDFTSDA)
     D                                     DTAARA(RPDFTSDA)
 
      **  External data structure for Customer Details.
     D Sdcust        E DS                  EXTNAME(SDCUSTPD)
 
      **  Data structure used to group settlement account details.
     D W_FullSettlAcc  DS            24
     D   Branch                1      3
     D   CustNo                4      9
     D   Currency             10     12
     D   AccCode              13     22S 0
     D   AccSeq               23     24S 0
 
     D Sdacod        E DS                  EXTNAME(SDACODPD)
      **  External data structure for Account Code Details.
 
      **  External data structure for Currency Details.
     D Sdcurr        E DS                  EXTNAME(SDCURRPD)
 
      **  First Data Structure for Access Programs, short Data
      **  Structure.
     D Dsfdy         E DS                  EXTNAME(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data
      **  Structure.
     D Dssdy         E DS                  EXTNAME(DSSDY)
 
     D Dsldy         E DS                  EXTNAME(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D OutQueue        S                   LIKE(MQSQueue)
 
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
 
     D MessageInd      S              1A
 
     D RAMSGOLD        S                   LIKE(RAMSGTYPE)
 
      **   Database Error Messsage Text
     D DBErrText       S            256A
 
      **   Transaction Data of associated transaction
     D AssocData       S                   LIKE(TransData)
 
      **   Meridian header Layout of associated transaction
     D MdHdAssoc       S                   LIKE(MdnHeadDs)
 
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
      **  Key Status.
     D P_Kyst          S              7A
      **  Account Code.
     D P_Acod          S             10A
      **  Account Sequence.
     D P_Acsq          S              2A
 
     D   InData        S                   LIKE(TransData) INZ(*BLANKS)
     D   InDBFile      S             10A   INZ(*BLANKS)
 
     D K_CustNum       S              6A
 
     D W_CcyNbdp       S              1A
     D W_CcyNbdpDB     S              1A
     D W_CcyNbdpCR     S              1A
 
     D W_Ptfr          S              4A
     D W_PtfrDB        S              4A
     D W_PtfrCR        S              4A
 
     D W_ReverseAll    S              1A
 
     D W_DrCrFee       S              2A
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Composite Data.
     D CompData        S                   LIKE(TransData)
 
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
 
      **  Last Change Type Flag
     D W_LastChgType   S              1A
 
     D W_OneMsgForDel  S              1A
     D W_OneMsgForAmd  S              1A
 
      **  Work Field used to retrieve the Operation
     D W_Operation     S              2A
 
     D W_DB_CUST_PB    S              1A
     D W_CR_CUST_PB    S              1A
 
     D W_PayingFeeAcc  S              1A
     D W_FeeGrossNet   S              1A
     D W_Fees          S             13P 0
     D Dbasea          S              3A
     D P_Curr          S              3A
     D X               S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C     Start         TAG
 
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
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
 
     C                   EVAL      W_PosFin = %SCAN('_After':RAMSGTYPE)
 
      ** If it is impossible to determine the image type, handle error
 
     C     W_PosFin      IFEQ      0
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'MSG Type'
     C                   EVAL      DBase  = 01
     C                   EVAL      DBkey  = RAMSGTYPE
     C                   OUT       LDA
     C                   EVAL      ReturnCode = 'Image_Type'
     C                   EVAL      MessageInd = 'N'
     C                   EXSR      Repair
     C                   ENDIF
 
     C                   EVAL      RAMSGTYPE =
     C                             %SUBST(RAMSGTYPE:1:W_PosFin + 1)
 
      **  Enter the processing to read the additional files and produce
      **  composite message here.
 
      **  Retrieve operation in message.
 
     C                   EVAL      W_Operation = %SUBST(TransData:1:2)
 
      **  Extract Last Change Type Flag from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1CHTP'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_LastChgType = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Status Flag from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1STAT'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_Status = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
     C                   IF            W_status = 'X'
     C                                 OR W_Status = 'D'
 
      **  Define key list to access to Account Master Details file.
 
     C     K_Accnt       KLIST
     C                   KFLD                    CustNo
     C                   KFLD                    Currency
     C                   KFLD                    AccCode
     C                   KFLD                    AccSeq
     C                   KFLD                    Branch
 
     C                   MOVE      'N'           W_DB_CUST_PB
     C                   MOVE      'N'           W_CR_CUST_PB
     C                   MOVE      'N'           W_OneMsgForDel
     C                   MOVE      'N'           W_OneMsgForAmd
 
      **************************
      **  PROCESSING FOR DEBIT *
      **************************
 
      **  Extract Debit A/C Code from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1DBAC'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Acod = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
 
      ** Access Account Code details
 
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Acod
     C     SDACOD        PARM      SDACOD        Dsfdy
 
     C                   IF        A5ACTY = 'R'
 
      ** Extract Debit A/C Customer from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1DBCU'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Cust = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      ** Access Customer Details by using Access Object,
      ** to retrieve Private Banking Customer Indicator.
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *blanks       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust
     C                   PARM                    P_Kyst
     C     Sdcust        PARM      Sdcust        Dsldy
 
      **  If Customer Details do not exist, handle Database Error.
 
     C     P_Rtcd        IFNE      *BLANKS
     C     BBCLST        ANDNE     'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SDCUSTPD'
     C                   EVAL      DBase  = 02
     C                   EVAL      DBkey  = P_Cust
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = P_RTCD
     C                   EXSR      Repair
 
     C                   ENDIF
 
      **  If Customer is not a Private Banking customer, check
      **  Requested PB Customer flag in case it would have been
      **  set to 'Y'.
 
     C                   IF        BBPRBA <> 'Y'
 
     C                   MOVE      BBCUST        K_CustNum
 
      **  Access to Customer PB Details file.
 
     C     K_CustNum     CHAIN     SDPBDSL0                           82
 
      **  If Customer PB Details do not exist, handle database error.
 
     C     *IN82         IFEQ      TRUE
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 03
     C                   EVAL      Dbkey  = BBCUST
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer
 
     C                   IF        BBPRBA = 'Y'
     C                             OR  PBREPB = 'Y'
 
     C                   MOVE      'Y'           W_DB_CUST_PB
 
      **  Extract Debit A/C Currency from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1DBCY'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Curr = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Retrieve currency number of decimal places.
 
     C                   EXSR      GetDecPl
     C                   MOVE      A6NBDP        W_CcyNbdp
     C                   MOVE      A6NBDP        W_CcyNbdpDB
 
      **  Set up key for full account.
      **  Extract Debit A/C Branch from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1DBBR'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      Branch = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
     C                   MOVEL     P_Cust        CustNo
     C                   MOVE      P_Curr        Currency
     C                   MOVE      P_Acod        AccCode
 
      **  Extract Debit A/C Sequence from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1DBSQ'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Acsq = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVE      P_Acsq        AccSeq
 
      **  Retrieve Account details (Portfolio Reference)
 
     C     Branch        IFNE      '   '
     C     K_Accnt       CHAIN     ACCNT                              82
 
      **  If Account does not exist, handle database error.
 
     C     *IN82         IFEQ      TRUE
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'ACCNT'
     C                   EVAL      Dbase  = 03
     C                   EVAL      DbKey = W_FullSettlAcc
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      A_PTFR        W_Ptfr
 
      **  Keep value of DB A/C portfolio for later processing (fees)
 
     C                   MOVE      A_PTFR        W_PtfrDB
 
     C     W_Status      IFEQ      'D'
     C                   MOVE      'Y'           W_ReverseAll
     C                   MOVE      'Y'           W_OneMsgForDel
     C                   ELSE
     C                   MOVE      'N'           W_ReverseAll
     C     W_LastChgType IFEQ      'A'
     C                   MOVE      'Y'           W_OneMsgForAmd
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      'DR'          W_DrCrFee
 
      **  Send Message for DEBIT PART to TOF
 
     C                   EXSR      SendMsg
 
     C                   ENDIF
     C                   ENDIF
 
      ***************************
      **  PROCESSING FOR CREDIT *
      ***************************
 
      **  Extract Credit A/C Code from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1CRAC'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Acod = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
 
      ** Access Account Code details
 
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Acod
     C     SDACOD        PARM      SDACOD        Dsfdy
 
     C                   IF        A5ACTY = 'R'
 
      **  Extract Credit A/C Customer from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1CRCU'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Cust = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust
     C                   PARM                    P_Kyst
     C     Sdcust        PARM      Sdcust        Dsldy
 
      **  If Customer Details do not exist, handle Database Error.
 
     C     P_Rtcd        IFNE      *BLANKS
     C     BBCLST        ANDNE     'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SDCUSTPD'
     C                   EVAL      DBase  = 02
     C                   EVAL      DBkey  = P_Cust
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = P_RTCD
     C                   EXSR      Repair
 
     C                   ENDIF
 
      **  If Customer is not a Private Banking customer, check
      **  Requested PB Customer flag in case it would have been
      **  set to 'Y'.
 
     C                   IF        BBPRBA <> 'Y'
 
     C                   MOVE      BBCUST        K_CustNum
 
      **  Access to Customer PB Details file.
 
     C     K_CustNum     CHAIN     SDPBDSL0                           82
 
      **  If Customer PB Details do not exist, handle database error.
 
     C     *IN82         IFEQ      TRUE
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 03
     C                   EVAL      Dbkey  = BBCUST
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer
 
     C                   IF        BBPRBA = 'Y'
     C                             OR  PBREPB = 'Y'
 
     C                   MOVE      'Y'           W_CR_CUST_PB
 
      **  Extract Credit A/C Currency from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1CRCY'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Curr = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Retrieve currency number of decimal places.
 
     C                   EXSR      GetDecPl
     C                   MOVE      A6NBDP        W_CcyNbdp
     C                   MOVE      A6NBDP        W_CcyNbdpCR
 
      **  Set up key for full account.
      **  Extract Credit A/C Branch from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1CRBR'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      Branch = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
     C                   MOVEL     P_Cust        CustNo
     C                   MOVE      P_Curr        Currency
     C                   MOVE      P_Acod        AccCode
 
      **  Extract Credit A/C Sequence from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1CRSQ'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Acsq = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVE      P_Acsq        AccSeq
 
      **  Retrieve Account details (Portfolio Reference)
 
     C     Branch        IFNE      '   '
     C     K_Accnt       CHAIN     ACCNT                              82
 
      **  If Account does not exist, handle database error.
 
     C     *IN82         IFEQ      TRUE
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'ACCNT'
     C                   EVAL      Dbase  = 03
     C                   EVAL      DbKey = W_FullSettlAcc
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      A_PTFR        W_Ptfr
 
      **  Keep value of CR A/C portfolio for later processing (fees)
 
     C                   MOVE      A_PTFR        W_PtfrCR
 
     C     W_Status      IFEQ      'D'
     C                   MOVE      'Y'           W_ReverseAll
     C                   ELSE
     C                   MOVE      'N'           W_ReverseAll
     C                   ENDIF
 
     C                   MOVE      'CR'          W_DrCrFee
 
      **  Send Message for CREDIT PART to TOF
      **  (For an amend, just one message in enough as we just update
      **  extended narratives).
      **  (For a delete, just one message in enough. So, send CR
      **  only if DR not yet sent).
 
     C     W_Status      IFNE      'D'
     C     W_OneMsgForAmdANDNE     'Y'
     C     W_Status      OREQ      'D'
     C     W_OneMsgForDelANDNE     'Y'
     C                   EXSR      SendMsg
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      *****************************
      **  PROCESSING FOR FEES 1-6 *
      *****************************
 
      **  Extract Fee Gross/Net from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1FGRS'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_FeeGrossNet = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Send only details of fees when 'G'ross
      **  and not for delete/reverse (as only one message (either
      **  CR or DR) is enough)
      **  and only in insert mode (amend mode just allows to amend
      **  extended narratives)
 
     C     W_FeeGrossNet IFEQ      'G'
     C     W_Status      ANDEQ     'X'
     C     W_LastChgType ANDEQ     'I'
 
      **  Extract Paying Fee Account from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1FPAY'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      W_PayingFeeAcc = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  If DB Paying Fee Account for a Private Banking Retail Account
 
     C     W_DB_CUST_PB  IFEQ      'Y'
     C     W_PayingFeeAccANDEQ     'D'
 
     C                   MOVE      W_CcyNbdpDB   W_CcyNbdp
     C                   MOVE      W_PtfrDB      W_Ptfr
 
     C                   EXSR      CheckFees
 
     C                   ENDIF
 
      ** If CR Paying Fee Account for a Private Banking Retail Account
 
     C     W_CR_CUST_PB  IFEQ      'Y'
     C     W_PayingFeeAccANDEQ     'C'
 
     C                   MOVE      W_CcyNbdpCR   W_CcyNbdp
     C                   MOVE      W_PtfrCR      W_Ptfr
 
     C                   EXSR      CheckFees
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      **  If no error, commit the unit of work so that messages have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
 
     C                   IF        ReturnCode = *BLANK
     C                   COMMIT
 
     C                   ENDIF
 
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SendMsg - Send message to TOF                                *
      *                                                               *
      *  Called by : Main processing, CheckFees                       *
      *                                                               *
      *  Calls     : RPSNDMS, WrtTrace                                *
      *                                                               *
      *****************************************************************
 
     C     SendMsg       BEGSR
 
      **  Place the result in field CompData.
 
     C                   EVAL      CompData  = %SUBST(TransData:+
     C                                         1:EndPosition)
     C                                       + W_CcyNbdp
     C                                       + W_Ptfr
     C                                       + W_ReverseAll
     C                                       + W_DrCrFee
 
      **  Call a standard routine to actually send the message
 
     C                   CALLB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      **  If error then perform any special processing and exit.
 
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'RPSNDMSG  '  DBpgm
     C                   OUT       Lda
     C                   EXSR      Repair
 
     C                   ENDIF
 
     C                   EXSR      WrtTrace
 
     C                   ENDSR
 
      /Eject
      *****************************************************************
      *                                                               *
      *  CheckFees                                                    *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : SendMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     CheckFees     BEGSR
 
      **  Extract Fee Amount 1 from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1F1CE'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_Fees
 
     C     W_Fees        IFNE      *ZEROS
     C                   MOVE      'F1'          W_DrCrFee
 
      **  Send Message for Fees to TOF
 
     C                   EXSR      SendMsg
     C                   ENDIF
 
      **  Extract Fee Amount 2 from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1F2CE'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_Fees
 
     C     W_Fees        IFNE      *ZEROS
     C                   MOVE      'F2'          W_DrCrFee
 
      **  Send Message for Fees to TOF
 
     C                   EXSR      SendMsg
     C                   ENDIF
 
      **  Extract Fee Amount 3 from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1F3CE'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_Fees
 
     C     W_Fees        IFNE      *ZEROS
     C                   MOVE      'F3'          W_DrCrFee
 
      **  Send Message for Fees to TOF
 
     C                   EXSR      SendMsg
     C                   ENDIF
 
      **  Extract Fee Amount 4 from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1F4CE'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_Fees
 
     C     W_Fees        IFNE      *ZEROS
     C                   MOVE      'F4'          W_DrCrFee
 
      **  Send Message for Fees to TOF
 
     C                   EXSR      SendMsg
     C                   ENDIF
 
      **  Extract Fee Amount 5 from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1F5CE'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_Fees
 
     C     W_Fees        IFNE      *ZEROS
     C                   MOVE      'F5'          W_DrCrFee
 
      **  Send Message for Fees to TOF
 
     C                   EXSR      SendMsg
     C                   ENDIF
 
      **  Extract Fee Amount 6 from GLATMIPD message data.
 
     C                   Z-ADD     1             X
     C     'R1F6CE'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %SUBST(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    W_Fees
 
     C     W_Fees        IFNE      *ZEROS
     C                   MOVE      'F6'          W_DrCrFee
 
      **  Send Message for Fees to TOF
 
     C                   EXSR      SendMsg
     C                   ENDIF
 
     C                   ENDSR
 
      /Eject
      *****************************************************************
      *                                                               *
      *  RtvPos   - retrieve position in Meridian message.            *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : RPC1305                                          *
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
     C                   PARM      *BLANK        FieldValue
     C                   PARM      *BLANK        ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     ReturnCode    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 04
     C                   EVAL      DBkey  = 'RPC1305'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   EVAL      X = X + 1
 
      **  If any error occurred while retrieving position, handle it.
 
     C                   IF        X > 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 05
     C                   EVAL      DBkey  = 'Index  '
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
      *  Calls     : RP1590                                           *
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
 
     C     ReturnCode    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 08
     C                   EVAL      DBkey  = 'RP1590'
     C                   OUT       LDA
 
     C                   ENDIF
     C                   ENDSR
 
      /Eject
      *****************************************************************
      *                                                               *
      *  Repair   - Write a Trace of outgoing messages to repair      *
      *                                                               *
      *  Called by : Main processing, Repair                          *
      *                                                               *
      *  Calls     : RP1592                                           *
      *                                                               *
      *****************************************************************
 
     C     Repair        BEGSR
 
     C                   MOVE      Dbase         dbasea
 
     C                   EVAL      DBErrText = 'DBError' +
     C                             ' in : ' + DBpgm +
     C                             ' at: ' + DBasea +
     C                             ' file : ' + DBfile +
     C                             ' Key : ' + DBKey +
     C                             ' Return :' + ReturnCode +
     C                             ' Rollback: Check trigger process'
 
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
     C                   PARM      *BLANKS       ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
 
     C     ReturnCode    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 50
     C                   EVAL      DBkey  = 'RP1592'
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** At the moment, it's not possible to use repair process
 
     C                   EXSR      *PSSR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      /Eject
      *****************************************************************
      *                                                               *
      *  GetDecPl - get number of decimal places.                     *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : AOCURRR0                                         *
      *                                                               *
      *****************************************************************
 
     C     GetDecPl      BEGSR
 
      **  Access to Currency Details, by using access object.
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Curr
     C     Sdcurr        PARM      Sdcurr        Dssdy
 
      **  If currency does not exist, handle database error.
 
     C     P_Rtcd        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDCURRPD'
     C                   EVAL      Dbase  = 06
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
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     W_RunBefore   IFEQ      *BLANK
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
 
     C                   IF        CommitCtl = 'Y'
     C                   ROLBK
 
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C     DBpgm         IFEQ      *BLANKS
     C                   EVAL      DBpgm = PSProcName
     C                   OUT       LDA
 
     C                   ENDIF
 
     C                   MOVE      'Y'           W_RunBefore
     C                   DUMP
 
     C                   ENDIF
 
     C     ReturnCode    IFEQ      *BLANK
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
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
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
     C                   EVAL      fmDpLen  = %SUBST(RCZEROFLD:2:1)
     C                   MOVE      fmDpLen       W_PosDebut
     C                   EVAL      fmShwPsSgn = 'N'
 
      **  Set up work fields that will not change if retrieve
      **  function is to be used.
 
     C                   EVAL      ScriptName = 'RP' + RATGTSYS
 
     C                   Z-ADD     0             X
 
      **  Retrieve position and length of status flag from GLATMIPD
      **  message data.
 
     C                   EVAL      FieldName   = 'R1STAT'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of last change type flag from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1CHTP'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Paying Fee Account from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1FPAY'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Fee Gross/Net from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1FGRS'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Debit A/C Branch from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1DBBR'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Debit A/C Customer from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1DBCU'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Debit A/C Currency from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1DBCY'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Debit A/C Code from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1DBAC'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Debit A/C Sequence from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1DBSQ'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Credit A/C Branch from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1CRBR'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Credit A/C Customer from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1CRCU'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Credit A/C Currency from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1CRCY'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Credit A/C Code from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1CRAC'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Credit A/C Sequence from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1CRSQ'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Fee 1 Amount from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1F1CE'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Fee 2 Amount from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1F2CE'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Fee 3 Amount from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1F3CE'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Fee 4 Amount from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1F4CE'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Fee 5 Amount from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1F5CE'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Fee 6 Amount from
      **  GLATMIPD message data.
 
     C                   EVAL      FieldName   = 'R1F6CE'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
 
      **  Retrieve begin position of additionnal fields in Meridian
      **  message
 
     C                   EVAL      FieldName   = '*END_IMAGE'
     C                   EVAL      FieldType   = *BLANK
     C                   EXSR      RtvPos
     C                   EVAL      EndPosition = FieldPosition - 1
 
     C                   ENDSR
      /Eject
      *****************************************************************
**  Cpy@
(c) Misys International Banking Systems Ltd. 2012
