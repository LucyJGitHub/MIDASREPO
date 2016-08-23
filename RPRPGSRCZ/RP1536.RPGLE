     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas PB Extraction Module for GTEESGT')               *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1536 - Extract module for GTEESGT                          *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *               Banking Customers.                              *
      *               List of additional fields:                      *
      *                 - Guarantee Currency Number of Decimal Places *
      *                                                               *
      *  Component of: RP1536 - Extract program for GTEESGT           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. AR970292           Date 14May12               *
      *                 259242  *CREATE    Date 10Mar09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  259242 - Lombard Credit and Pledge Analysis                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Midas SD API Customer Private Banking Details file.
     FSDPBDSL0  IF   E           K Disk
     F                                     Infsr(*Pssr)
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  CHAIN access to SDPBDSL0 failed.                      *
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
      *  Repair   - Repair process                                    *
      *  WrtTrace - Trace process                                     *
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
 
      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,STD_DCL
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C/COPY RPCPYSRC,MDN_HD_DS
 
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
 
     D SDCLND        E DS                  Extname(SDCLNDPD)
      ** DS for Customer Lending Details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  Output queue name.
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
 
      **   Image Type - Amend Before, Amend After or Insert
     D ImageType       S             20A
 
      **  Work Fields used to check guarantee status flag values, before and after
     D W_GSTS_Before   S              1A
     D W_GSTS_After    S              1A
 
      **  Work Fields used tfor the take-on
     D W_ZZ004_Before  S              4A
     D W_ZZ004_After   S              4A
 
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer (Received)
     D P_Cust_Rcv      S             10A
      **  Customer (Given)
     D P_Cust_Gvn      S             10A
      **  Key status.
     D P_Kyst          S              7A
      **  Switchable feature number.
     D P_Sard          S              6A
 
      **  Work Field used as key to access to Customer PB Details.
     D K_CustNum       S              6A
 
      **  Work Fields used for Lending.
     D CLE002          S              1A
     D CLE105          S              1A
     D W_Send          S              1A
     D W_User          S             10A
     D W_Record        S              1A
 
      ** Start of additional fields
     D W_GuarCcyNbdp   S              1A
      ** End of additional fields
 
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
 
      **  Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /Eject
      *****************************************************************
     C     Start         TAG
 
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
 
     C                   Z-ADD     1             X
     C     'GSTS  '      LOOKUP    ArrFld(X)                              89
 
      ** Check image (Before or After) of the message.
     C                   EVAL      W_PosFin    = %Scan('_B':RAMSGTYPE)
 
      ** Before Image Type.
     C     W_PosFin      IFNE      0
     C                   EVAL      ImageType = 'Amend Before'
     C                   EVAL      AssocData = TransData
     C                   EVAL      MdHdAssoc = MdnHeadDs
     C                   EVAL      MessageInd = 'N'
 
      ** Extract GSTS indicator.
     C                   EVAL      W_GSTS_Before = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      ** Extract filler (used for take-on ONLY)
     C                   Z-ADD     1             X
     C     'ZZ004 '      LOOKUP    ArrFld(X)                              89
     C                   EVAL      W_ZZ004_Before = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                   RETURN
 
      ** After Image Type.
     C                   Else
     C                   IF        ImageType <> 'Amend Before'
     C                   EVAL      ImageType = 'Insert'
     C                   EVAL      AssocData = *Blanks
     C                   EVAL      MdHdAssoc = *Blanks
 
     C                   ELSE
     C                   EVAL      ImageType = 'Amend After'
 
     C                   ENDIF
 
      ** Extract GSTS indicator.
     C                   EVAL      W_GSTS_After = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      ** Extract filler (used for take-on ONLY)
     C                   Z-ADD     1             X
     C     'ZZ004 '      LOOKUP    ArrFld(X)                              89
     C                   EVAL      W_ZZ004_After = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
     C                   ENDIF
 
      **  If features CLE105 - New Maint. Funct - Enhanced Lending Input
      **              CLE002 - Authorizations
      **  And ICD Field from PF/SDCLNDPD 'Guarantees to be authorized' is 'Y'
     C                   IF            CLE105 = 'Y'
     C                             And CLE002 = 'Y'
     C                             And BPGUAU = 'Y'
 
      ** Process only After image
     C                   IF        ImageType = 'Insert'
     C                   RETURN
     C                   ELSE
 
      **  If guarantee status indicator updated from 'C' or 'R' to 'A' or
      **  If guarantee status indicator updated from 'A' or 'R' to 'D'
      **  Send the message
     C                   IF            W_GSTS_Before = 'C'
     C                             AND W_GSTS_After  = 'A'
     C                             OR  W_GSTS_Before = 'R'
     C                             AND W_GSTS_After  = 'A'
     C                             OR  W_GSTS_Before = 'A'
     C                             AND W_GSTS_After  = 'D'
     C                             OR  W_GSTS_Before = 'R'
     C                             AND W_GSTS_After  = 'D'
     C                             OR  W_ZZ004_Before = '    '
     C                             And W_ZZ004_After  = 'TKON'
     C                   ELSE
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **  Extract customer number (received) from GTEESGT message data.
     C                   Z-ADD     1             X
     C     'CNUM  '      LOOKUP    Arrfld(X)                              89
     C**********         EVAL      P_Cust_Rcv = %Subst(TransData:+                          AR970292
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                          AR970292
     C                   EVAL      P_Cust_Rcv = %Subst(TransData:+                          AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *blanks       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust_Rcv
     C                   PARM                    P_Kyst
     C     Sdcust        PARM      Sdcust        Dsldy
 
      **  If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        IFNE      *blanks
     C     BBCLST        ANDNE     'Y'
     C     *Lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SDCUSTPD'
     C                   EVAL      DBase  = 01
     C                   EVAL      DBkey  = P_Cust_Rcv
     C                   OUT       Lda
     C                   EVAL       ReturnCode =  P_Rtcd
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
     C     *in81         IFEQ      True
     C     *lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 02
     C                   EVAL      Dbkey  = BBCUST
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      W_Send = 'N'
 
     C                   IF            BBPRBA = 'Y'
     C                             Or  PBREPB = 'Y'
     C                   EVAL      W_Send = 'Y'
     C                   ELSE
      **  Update customer number (received) from GTEESGT message data.
     C                   Z-ADD     1             X
     C     'CNUM  '      LOOKUP    Arrfld(X)                              89
     C**********         EVAL      %Subst(TransData:ArrPos(X)+W_PosDebut:+                  AR970292
     C                   EVAL      %Subst(TransData:ArrPos(X):+                             AR970292
     C                             ArrLen(X)) = '000000'
     C                   ENDIF
 
      **  Extract customer number (given) from GTEESGT message data.
     C                   Z-ADD     1             X
     C     'GBCN  '      LOOKUP    Arrfld(X)                              89
     C**********         EVAL      P_Cust_Gvn = %Subst(TransData:+                          AR970292
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                          AR970292
     C                   EVAL      P_Cust_Gvn = %Subst(TransData:+                          AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *blanks       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust_Gvn
     C                   PARM                    P_Kyst
     C     Sdcust        PARM      Sdcust        Dsldy
 
      **  If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        IFNE      *blanks
     C     BBCLST        ANDNE     'Y'
     C     *Lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SDCUSTPD'
     C                   EVAL      DBase  = 03
     C                   EVAL      DBkey  = P_Cust_Gvn
     C                   OUT       Lda
     C                   EVAL       ReturnCode =  P_Rtcd
     C                   EXSR      Repair
 
     C                   ENDIF
 
      **  If Customer is not a Private Banking customer, check
      **  Requested PB Customer flag in case it would have been
      **  set to 'Y'.
     C                   IF        BBPRBA      <> 'Y'
     C                   MOVE      BBCUST        K_CustNum
 
      **  Access to Customer PB Details file.
     C     K_CustNum     CHAIN     SDPBDSL0                           81
 
      **  If Customer PB Details do not exist, handle database error.
     C     *IN81         IFEQ      True
     C     *Lock         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 04
     C                   EVAL      Dbkey  = BBCUST
     C                   Out       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF            BBPRBA = 'Y'
     C                             Or  PBREPB = 'Y'
     C                   EVAL      W_Send = 'Y'
     C                   ELSE
      **  Update customer number (given) from GTEESGT message data.
     C                   Z-ADD     1             X
     C     'GBCN  '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      %Subst(TransData:ArrPos(X)+W_PosDebut:+
     C                             ArrLen(X)) = '000000'
     C                   ENDIF
 
      **  Only send the message if at least one of the customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer.
     C                   IF            W_Send = 'Y'
 
 
      **  Number of Decimal Places **
 
      **  Extract Currency Code.
     C                   Z-ADD     1             X
     C     'CCY   '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Curr = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Retrieve currency number of decimal places.
     C                   EXSR      GetDecPl
     C                   MOVE      A6NBDP        W_GuarCcyNbdp
 
      ** End of Currency Number of Decimal Places
 
      ** End of Additionnal fields
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   EVAL      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      IFEQ      0
     C     *Lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'MSG Type'
     C                   EVAL      DBase  = 05
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
 
     C                   EVAL      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_GuarCcyNbdp
 
      **  Call a standard routine to actually send the message.
     C                   CALLB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   IF        ReturnCode <> *blank
     C     *Lock         IN        Lda
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
     C     *Lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 06
     C                   EVAL      DBkey  = 'RPC1305'
     C                   OUT       Lda
     C                   EVAL      MessageInd = 'N'
     C                   EXSR      Repair
     C                   EVAL      MessageInd = 'Y'
     C                   ENDIF
 
     C                   EVAL      X = X + 1
      **  If any error occurred while retrieving position, handle it.
     C                   IF        X > 100
     C     *lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 07
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
     C     *Lock         IN        Lda
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
     C     ReturnCode    IFNE      *blanks
     C     *Lock         IN        Lda
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
      *  GetDecPl - get number of decimal places.                     *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     GetDecPl      BEGSR
 
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
     C                   EVAL      Dbase  = 09
     C                   EVAL      Dbkey  = P_Curr
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = P_RTCD
     C                   EXSR      Repair
 
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C     *Pssr         BEGSR
 
     C     W_RunBefore   IFEQ      *Blank
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
     C                   IF        CommitCtl = 'Y'
     C                   ROLBK
 
     C                   ENDIF
 
     C     *Lock         IN        Lda
     C     DBpgm         IFEQ      *blanks
     C                   EVAL      DBpgm  = PSProcName
     C                   OUT       Lda
 
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
      * Called at : program initialization time.                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      **  MQSeries queue to write to - this parameter IS used in this module
     C                   PARM                    OutQueue
      **  Merdian header
     C                   PARM                    MdnHeadDS
      **  Transaction Data
     C                   PARM                    TransData
      **  Commitment control flag
     C                   PARM                    CommitCtl
      **  Return Code
     C                   PARM                    ReturnCode
 
     C                   EVAL      MessageInd = 'Y'
 
      **  Check if CLE105 (Lending) is installed.
     C                   EVAL      CLE105 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *blanks       P_Rtcd
     C                   PARM      '*VERIFY'     P_Optn
     C                   PARM      'CLE105'      P_Sard
     C     Scsard        PARM      Scsard        Dsfdy
 
      **  If any error occurred when checking feature.
     C     P_Rtcd        IFNE      *blanks
     C     P_Rtcd        ANDNE     '*NRF   '
     C     *lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SCSARDPD'
     C                   EVAL      DBase  = 10
     C                   EVAL      DBkey  = P_Sard
     C                   OUT       Lda
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      Repair
 
     C                   ENDIF
 
      **  If feature is installed.
     C     P_Rtcd        IFEQ      *blanks
     C                   EVAL      CLE105 = 'Y'
 
     C                   ENDIF
 
      **  Check if CLE002 (Lending) is installed.
     C                   EVAL      CLE002 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *blanks       P_Rtcd
     C                   PARM      '*VERIFY'     P_Optn
     C                   PARM      'CLE002'      P_Sard
     C     Scsard        PARM      Scsard        Dsfdy
 
      **  If any error occurred when checking feature.
     C     P_Rtcd        IFNE      *blanks
     C     P_Rtcd        ANDNE     '*NRF   '
     C     *Lock         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SCSARDPD'
     C                   EVAL      DBase  = 11
     C                   EVAL      DBkey  = P_Sard
     C                   OUT       LDA
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      Repair
 
     C                   ENDIF
 
      **  If feature is installed.
     C     P_Rtcd        IFEQ      *BLANKS
     C                   EVAL      CLE002 = 'Y'
 
     C                   ENDIF
 
      **  Access Customer Lending Data
     C                   IF            CLE002 = 'Y'
 
     C                   CALL      'AOCLNDR0'
     C                   PARM      *blanks       P_Rtcd
     C                   PARM      '*VERIFY'     P_Optn
     C*****SDCLND        PARM      SDCLND        Dsfdy                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
 
      **  If any error occurred when checking feature.
     C     P_Rtcd        IFNE      *blanks
     C     *lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SDCLNDPD'
     C                   EVAL      DBase  = 12
     C                   EVAL      DBkey  = '*First'
     C                   OUT       Lda
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      Repair
 
     C                   ENDIF
     C                   ENDIF
 
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
 
      **  Retrieve position and length of customer number (received) from GTEESGT message data.
     C                   EVAL      FieldName   = 'CNUM'
     C**********         EVAL      FieldType   = 'N'                                        AR970292
     C                   EVAL      FieldType   = 'A'                                        AR970292
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of customer number (given) from GTEESGT message data.
     C                   EVAL      FieldName   = 'GBCN'
     C**********         EVAL      FieldType   = 'N'                                        AR970292
     C                   EVAL      FieldType   = 'A'                                        AR970292
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of guarantee currency from GTEESGT message data.
     C                   EVAL      FieldName   = 'CCY'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Authorise user profile from GTEESGT
     C                   EVAL      FieldName   = 'XUSR'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of Guarantee status from GTEESGT
     C                   EVAL      FieldName   = 'GSTS'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve position and length of filler field from GTEESGT (used for take-on)
     C                   EVAL      FieldName   = 'ZZ004'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   EVAL      FieldName   = '*END_IMAGE'
     C                   EVAL      FieldType   = *blank
     C                   EXSR      RtvPos
     C                   EVAL      EndPosition = FieldPosition - 1
 
     C                   ENDSR
      /Eject
      *****************************************************************
**  Cpy@
(c) Misys International Banking Systems Ltd. 2009
