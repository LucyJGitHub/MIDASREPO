     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Extraction Module for SDFOCSPD')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian DBA Replication                             *
      *                                                               *
      *  RP1516 - Extract module for SDFOCSPD                         *
      *                                                               *
      *  Function: This module only sends transactions for Private    *
      *  (I/C)     Banking Customers.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 CPB010             Date 16Jan03               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007   *CREATE   Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  CPB010 - Avoid DB Error by write message in Repair File      *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    81         General file-access indicator                   *
      *    89         General-purpose indicator                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRRtvPos - Retrieve position in Meridian message.            *
      *  Repair   - Repair process                                    *         CPB010
      *  WrtTrace - Trace process                                     *         CPB010
      *  *PSSR    - Program exception error routine                   *
      *  *INZSR   - Program Initialization routine.                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD API Customer Private Banking Details file
     FSDPBDSL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY contains various standard declares
     D/COPY RPCPYSRC,Std_Dcl
 
      ** Contains the layout of the Meridian header as a data structure
     D/COPY RPCPYSRC,Mdn_Hd_DS
 
      ** Declaration of fields passed to the formatting routines
     D/COPY RPCPYSRC,RPFMTDCL
 
      ** Procedure prototype for the Packed routine
     D/COPY RPCPYSRC,RPFMTPPP
 
      ** Procedure prototype for the Signed routine
     D/COPY RPCPYSRC,RPFMTPPS
 
      ** Procedure prototype for the Format routine used to process
      ** an entire record
     D/COPY RPCPYSRC,RPFMTPPF
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA
      ** External Data structure for Local data area (db error details).
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    EXTNAME(RPDFTSDA) DTAARA(RPDFTSDA)
 
      ** API DUMP Information Data Area for database error reporting;
      ** based on external file
     D Apdump        E DS                  EXTNAME(APDUMP) DTAARA
 
      ** External Data structure for Run Date Informations.
     D Rundat        E DS                  EXTNAME(RUNDAT) DTAARA
 
      ** Arrays used to store Position and Length of each fields
     D WArFld          S              6    Dim(100)
     D WArPos          S              7  0 Dim(100)
     D WArLen          S              4  0 Dim(100)
 
      ** First data structure for access programs, short data structure
     D Dsfdy         E DS                  EXTNAME(DSFDY)
 
      ** Third data structure for access programs, extended ds
     D Dsldy         E DS                  EXTNAME(DSLDY)
 
      ** Data Structure for access to Bank Details.
     D Sdbank        E DS                  EXTNAME(SDBANKPD)
 
      ** Data Structure for access to Customer Details.
      ** Also used to pass data to procedure ProcFormat.
     D Sdcust        E DS                  EXTNAME(SDCUSTPD)
 
      ** Structure to receive a formatted customer details
      ** record from procedure ProcFormat.
      ** WSDCustPosA (and WSDCustPosN) contain the position of first
      ** unused position in WSDCustRec. If the input data is blank at
      ** end this would be well after the last non-blank character.
     D WDsSDCust       DS
     D  WSDCustRec                          LIKE(TransData)
     D  WSDCustPosA                   4
     D  WSDCustPosN                   4S 0 OVERLAY(WSDCustPosA)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of parameters --------------------**
      ** Output queue name.
     D OutQueue        S                   Like(MQSQueue)
      **--------------------- End of parameters ---------------------**
 
      **-------------- Start of parameters for RPC1305 --------------**
     D PScriptName     S             10A
     D PImageName      S             32A
     D PFldName        S             10A
     D PFldType        S              1A
     D PFldPos         S              7S 0
     D PFldLen         S              4S 0
     D PFldValue       S           9999A
      **--------------- End of parameters for RPC1305 ---------------**
                                                                                CPB010
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
      **----------------  End of Parameters for CPB010  --------------**        CPB010
 
      ** --------- Start of fields used by access programs ----------**
     D P_RtCd          S              7A
     D P_Optn          S              7A
     D P_Cust          S             10A
     D P_Kyst          S              7A
      ** ---------- End of fields used by access programs -----------**
 
      ** Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      ** End Position
     D WEndPos         S              7S 0
 
      ** Parameters for ProcFormat
     D InData          S                   LIKE(TransData) INZ(*BLANKS)
     D InDBFile        S             10A   INZ(*BLANKS)
 
      ** Work Field used as key to access to Customer PB Details
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      ** Work Field used to produce only one dump
     D W_RunBefore     S              1A
 
      ** Composite Data
     D CompData        S                   LIKE(TransData)
 
      ** Work field used to set up return code when no record found
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      ** Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** Work field used to retrieve Broker Indicator
     D W_BrokerInd     S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
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
 
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                         CPB010
     C                   Eval      AssocData = *Blanks                          CPB010
     C                   Eval      MdHdAssoc = *Blanks                          CPB010
 
      ** Enter the processing to read the additional files and produce
      ** a composite message here.
 
      ** Extract customer number from SDFOCSPD message data.
     C                   EVAL      X = 1
     C     'BHCUST'      LOOKUP    WArFld(X)                              89
     C                   EVAL      P_Cust = %Subst(TransData:+
     C                             WArPos(X):WArLen(X))
 
      ** Access Customer Details by using Access Object,
      ** to retrieve Private Banking Customer Indicator.
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust
     C                   PARM                    P_Kyst
     C     SdCust        PARM      SdCust        Dsldy
      ** If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        IFNE      *BLANKS
     C     BBCLST        ANDNE     'Y'                                          223644
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile     = 'SDCUSTPD'
     C                   EVAL      DBase      = 01
     C                   EVAL      DBkey      = P_Cust
     C                   OUT       LDA
     C                   EVAL      ReturnCode = P_Rtcd
     C**********         EXSR      *PSSR                                        CPB010
     C                   EXSR      REPAIR                                       CPB010
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
     C     *IN81         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 02
     C                   EVAL      Dbkey  = BBCUST
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         EXSR      *PSSR                                        CPB010
     C                   EXSR      REPAIR                                       CPB010
     C                   ENDIF
 
     C                   ENDIF
 
      ** Extract broker indicator from SDFOCSPD message data.
     C                   EVAL      X = 1
     C     'BHBKIN'      LOOKUP    WArFld(X)                              89
     C                   EVAL      W_BrokerInd = %Subst(TransData:+
     C                             WArPos(X):WArLen(X))
 
      ** Only send the message if Customer is a Broker
     C                   IF            W_BrokerInd = 'Y'
 
      **----------------- Start of Additionnal fields ---------------**
 
      ** Reformat entire SDCUSTPD record (SDCUSTD0).
      ** The relevant member in file RPMSGFPD contains dtls of fields
      ** in the file to be processed (it is a DSPFFD outfile).
      ** This file must already be set up with the field data for the
      ** file to be processed.
     C                   EVAL      CompData = *BLANKS
     C                   EVAL      InData   = Sdcust
     C                   EVAL      InDBFile = 'SDCUSTPD  '
     C                   EVAL      WDsSDCust = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      ** The WDsSDCust data structure has two sub-fields:
      **    - WSDCustRec w/c now contains formatted data, left aligned
      **    - WSDCustPosA/WSDCustPosN w/c now contains position of
      **      the first unused byte in WSDCustRec.
 
      **------------------ End of Additionnal fields ----------------**
 
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
     C**********         EXSR      *PSSR                                        CPB010
                                                                                CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   ENDIF
 
     C                   EVAL      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
     C
 
      ** Place the result in field CompData.
     C                   EVAL      CompData = %subst(TransData:1:WEndPos)
     C                                       + %subst(WSDCustRec:1:+
     C                                                           WSDCustPosN-1)
 
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
     C                   EVAL      DBfile     = 'RPSNDMSG'
     C                   EVAL      DBase      = 04
     C                   EVAL      DBkey      = '*CALL   '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                        CPB010
     C                   EXSR      REPAIR                                       CPB010
     C                   ELSE
      ** If no error, commit the unit of work so that msgs that have
      ** been got from a queue would be permanently deleted and put
      ** operations would be made permanent.
                                                                                CPB010
     C                   Exsr      WrtTrace                                     CPB010
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      *ON           *INLR
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
     C                   PARM      *BLANK        PFldValue
     C                   PARM      *BLANK        ReturnCode
      ** If any error occurred while retrieving position, handle it.
     C     ReturnCode    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'RPC1305 '
     C                   EVAL      DBase  = 05
     C                   EVAL      DBkey  = '*CALL  '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                        CPB010
                                                                                CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   ENDIF
 
     C                   EVAL      X = X + 1
      ** If any error occurred while retrieving position, handle it.
     C                   IF        X > 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 06
     C                   EVAL      DBkey  = 'Index  '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                        CPB010
     C                   EXSR      Repair                                       CPB010
     C                   ENDIF
 
     C                   EVAL      WArFld(X) = PFldName
     C                   EVAL      WArPos(X) = PFldPos
     C                   EVAL      WArLen(X) = PFldLen
 
     C                   ENDSR
      *****************************************************************         CPB010
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
     C     ReturnCode    Ifne      *blanks                                      CPB010
     C     *Lock         In        Lda                                          CPB010
     C                   Eval      DBpgm  = PSProcName                          CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 08                                  * Db Error 8 *CPB010
     C                   Eval      DBkey  = 'RP1590'                            **************CPB010
     C                   Out       Lda                                          CPB010
                                                                                CPB010
     C                   Endif                                                  CPB010
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
     C     ReturnCode    Ifne      *blanks                                      CPB010
     C     *Lock         In        Lda                                          CPB010
     C                   Eval      DBpgm  = PSProcName                          CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 50                                  * Db Error 50 CPB010
     C                   Eval      DBkey  = 'RP1592'                            **************CPB010
     C                   Out       Lda                                          CPB010
                                                                                CPB010
     C                   exsr      *pssr                                        CPB010
     C                   Else                                                   CPB010
     C                   Return                                                 CPB010
     C                   Endif                                                  CPB010
                                                                                CPB010
     C                   Endsr                                                  CPB010
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
      *  Calls:     SRRtvPos                                          *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
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
                                                                                CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
 
     C                   EVAL      DBpgm      = PSProcName
 
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
 
      ** Retrieve position and length of customer number from
      ** SDFOCSPD message data.
     C                   EVAL      PFldName   = 'BHCUST'
     C                   EVAL      PFldType   = 'A'
     C                   EXSR      SRRtvPos
 
      ** Retrieve position and length of Broker indicator from
      ** SDFOCSPD message data.
     C                   EVAL      PFldName   = 'BHBKIN'
     C                   EVAL      PFldType   = 'A'
     C                   EXSR      SRRtvPos
 
      ** Retrieve begin position of additionnal fields in Meridian msg
     C                   EVAL      PFldName   = '*END_IMAGE'
     C                   EVAL      PFldType   = *BLANK
     C                   EXSR      SRRtvPos
     C                   EVAL      WEndPos = PFldPos - 1
 
     C                   ENDSR
      *****************************************************************
