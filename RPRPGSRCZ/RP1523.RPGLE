     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Extract program for FFCOCH')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian DBA Replication                             *
      *                                                               *
      *  RP1523 - Extract module for FFCOCH                           *
      *                                                               *
      *  Function: This module only sends transactions for Private    *
      *  (I/C)     Banking Customers.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR858264A          Date 16Jul12               *
      *  Prev Amend No. AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245868             Date 21Feb07               *
      *                 220152             Date 01Aug03               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
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
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
      *  245868 - Apply 220152                                        *
      *  220152 - Do not send FFCOCH message anymore as FF charge     *
      *           are included in TRANSD message                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  223644 - Avoid DB error 01 if cust. closed                   *
      *  CPB010 - Avoid DB Error by write message in Repair File      *
      *           Execute Subroutine Repair instead of *Pssr in case  *
      *              of database error.                               *
      *           Two possibility, message can be repair or not:      *
      *               Set MessageInd to 'Y' in case of repair or 'N'  *
      *           If the message is associated to an other messages   *
      *           like xxx_B and xxx_After, xxx_B must be setup       *
      *           in the associated messages and _After is the master.*
      *           To manage the repair messages, call RPC1492.        *
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
      *    89         General-purpose indicator                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRRtvPos - retrieve position in Meridian message.            *
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
 
      ** Midas FF Transaction details - detail
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Contains various standard declares
     D**********/COPY RPCPYSRC,Std_Dcl                                                     AR858264A
     D/COPY RPCPYSRC,STD_DCL                                                               AR858264A
 
      ** Contains the layout of the Meridian header as a data structure
     D**********/COPY RPCPYSRC,Mdn_Hd_DS                                                   AR858264A
     D/COPY RPCPYSRC,MDN_HD_DS                                                             AR858264A
 
      ** Declaration for fields passed to the formatting routines
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
 
     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
      ** External Data structure for Local data area (db error details).
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
 
      ** Arrays used to store Position and Length of each fields
     D WArFld          S              6    Dim(100)
     D WArPos          S              7  0 Dim(100)
     D WArLen          S              4  0 Dim(100)
 
      ** Data Structure for access to Customer Details.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      ** External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      ** First data structure for access programs, short data structure
     D DsFdy         E DS                  Extname(DSFDY)
 
      ** Third data structure for access programs
     D Dsldy         E DS                  Extname(DSLDY)
 
      ** Structure based on Transaction file used to
      ** pass data to procedure ProcFormat.
     D TransdDs      E DS                  Extname(TRANSD)
 
      ** Structure to receive a formatted Transaction
      ** record from procedure ProcFormat.
      ** TransdPosA (and TransdPosN) contain position of 1st unused
      ** position in TransdRec.  If input data is blank at end, this
      ** could be well after the last non-blank character.
     D TransdData      DS
     D  TransdRec                          Like(TransData)
     D  TransdPosA                    4
     D  TransdPosN                    4S 0 Overlay(TransdPosA)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of parameters --------------------**
      ** Output queue name
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
 
      ** ----------- Start of parameters for ProcFormat -------------**
     D InData          S                   LIKE(TransData) INZ(*BLANKS)
     D InDBFile        S             10A   INZ(*BLANKS)
      **------------- End of Parameters for ProcFormat --------------**
 
      ** Work Field used as key to access to Customer PB Details
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      ** Work Field used as key to access to Transaction Details
     D K_Trans         S              6  0
 
      ** Composite Data
     D CompData        S                   LIKE(TransData)
 
      ** Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      ** Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
 
      ** Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
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
                                                                                              220152
      ** Do not process anymore                                                               220152
     C                   Return                                                               220152
                                                                                              220152
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                         CPB010
     C                   Eval      AssocData = *Blanks                          CPB010
     C                   Eval      MdHdAssoc = *Blanks                          CPB010
 
      ** Extract customer number from FFCOCH message data.
     C                   Z-ADD     1             X
     C     'CCCUST'      LOOKUP    WArFld(X)                              89
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
     C     P_Rtcd        IFNE      *BLANKS
     C     BBCLST        ANDNE     'Y'                                          223644
     C     *LOCK         IN        Lda
     C                   EVAL      DBfile = 'SDCUSTPD'
     C                   EVAL      DBase  = 01
     C                   EVAL      DBkey  = P_Cust
     C                   OUT       Lda
     C                   EVAL       ReturnCode =  P_Rtcd
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
     C     K_CustNum     CHAIN     SDPBDSL0                           89
      ** If Customer PB Details do not exist, handle database error.
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        Lda
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 02
     C                   EVAL      Dbkey  = BBCUST
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         EXSR      *PSSR                                        CPB010
     C                   EXSR      REPAIR                                       CPB010
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Only send the message if Customer is a Private
      ** Banking Customer or flagged as requested to become
      ** a Private Banking Customer.
     C                   IF            BBPRBA = 'Y'
     C                             Or  PBREPB = 'Y'
 
      **----------------- Start of Additionnal Messages ---------------**
 
      ** Extract Transaction Number from FFCOCH message data.
     C                   Z-ADD     1             X
     C     'CCTNBR'      LOOKUP    WArFld(X)                              89
     C                   EVAL      PFldVal = %Subst(TransData:+
     C                             WArPos(X)+W_Posdebut:WArLen(X))
     C                   MOVEL     PFldVal       K_Trans
 
      ** Define key list to access to FF Transaction Details.
     C     K_Transd      KLIST
     C                   KFLD                    K_Trans
 
      ** Access to Transaction details
     C     K_Trans       CHAIN     TRANS2                             89
      ** If Transaction Details do not exist, handle database error.
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        Lda
     C                   EVAL      Dbfile = 'TRANSD'
     C                   EVAL      Dbase  = 03
     C                   MOVEL     K_Trans       Dbkey
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C**********         EXSR      *PSSR                                        CPB010
     C                   EXSR      REPAIR                                       CPB010
     C                   ENDIF
 
      ** Reformat entire TRANSD record (TRANSDF).
      ** The relevant member in file RPMSGFPD contains dtls of the flds
      ** in the file to be processed (it is a DSPFFD outfile).
      ** This file must already be set up with the field data for the
      ** file to be processed.
     C                   EVAL      InData   = TransdDS
     C                   EVAL      InDBFile = 'TRANSD    '
     C                   EVAL      TransdData = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      ** The TransdData data structure has two sub-fields:
      **   - TransdRec w/c now contains the formatted dta, left aligned
      **   - TransdPosA/TransdPosN which now contains the position of
      **     the first unused byte in TransdRec.
 
      ** Change message Type from _After to _A
      ** Determine Image Type.
     C                   EVAL      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      ** If it is impossible to determine the image type, handle error.
     C     W_PosFin      IFEQ      0
     C     *LOCK         IN        Lda
     C                   EVAL      DBfile = 'MSG Type'
     C                   EVAL      DBase  = 04
     C                   EVAL      DBkey  = RAMSGTYPE
     C                   OUT       Lda
     C                   EVAL      ReturnCode = 'Image_Type'
     C**********         EXSR      *PSSR                                        CPB010
                                                                                CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   ENDIF
 
     C                   EVAL      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
 
      ** Place the result in field CompData.
     C                   EVAL      CompData  = %subst(TransData:1:WEndPos)
     C                                       + %subst(TransdRec:1:
     C                                                TransdPosN-1)
 
      ** Call a standard routine to actually send the message.
     C                   CallB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        Lda
     C                   EVAL      DBfile = 'RPSNDMSG'
     C                   EVAL      DBase  = 05
     C                   EVAL      DBkey  = '*CALL   '
     C                   OUT       Lda
     C****               EXSR      *PSSR                                        CPB010
     C                   EXSR      REPAIR                                       CPB010
     C                   ELSE
      ** If no error, commit the unit of work so that messages that have
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
     C                   PARM      *BLANK        PFldVal
     C                   PARM      *BLANK        ReturnCode
 
      ** If any error occurred while retrieving position, handle it.
     C     ReturnCode    IFNE      *BLANKS
     C     *LOCK         IN        Lda
     C                   EVAL      DBfile = 'RPC1305 '
     C                   EVAL      DBase  = 06
     C                   EVAL      DBkey  = '*CALL  '
     C                   OUT       Lda
     C**********         EXSR      *PSSR                                        CPB010
                                                                                CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   ENDIF
 
     C                   EVAL      X = X + 1
      ** If any error occurred while retrieving position, handle it.
     C                   IF        X > 100
     C     *LOCK         IN        Lda
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 07
     C                   EVAL      DBkey  = 'Index  '
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                        CPB010
     C                   EXSR      REPAIR                                       CPB010
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
      *  Called by:  (**calling routines**)                           *
      *                                                               *
      *  Calls:      None                                             *
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
      *  Calls:     AOBANKR0, *PSSR                                   *
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
                                                                                CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
 
     C                   EVAL      DBpgm  = PSProcName
 
      ** Access Bank details by using access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*FIRST '     P_optn
     C     Sdbank        PARM      Sdbank        DsFdy
     C     P_Rtcd        IFNE      *BLANKS
     C     *LOCK         IN        Lda
     C                   EVAL      Dbfile = 'SDBANKPD'
     C                   EVAL      Dbase  = 08
     C                   EVAL      Dbkey  = '*FIRST'
     C                   OUT       LDA
     C**********         EXSR      *PSSR                                        CPB010
     C                   EXSR      REPAIR                                       CPB010
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
 
      ** Retrieve position & length of customer num from FFCOCH msg dta
     C                   EVAL      PFldName   = 'CCCUST'
     C**********         EVAL      PFldType   = 'N'                                         AR970292
     C                   EVAL      PFldType   = 'A'                                         AR970292
     C                   EXSR      SRRtvPos
 
      ** Retrieve position & length of Transaction no. from FFCOCH
      ** message data
     C                   EVAL      PFldName   = 'CCTNBR'
     C                   EVAL      PFldType   = 'N'
     C                   EXSR      SRRtvPos
 
      ** Retrieve begin position of additionnal fields in Meridian msg
     C                   EVAL      PFldName   = '*END_IMAGE'
     C                   EVAL      PFldType   = *BLANK
     C                   EXSR      SRRtvPos
     C                   EVAL      WEndPos = PFldPos - 1
 
     C                   ENDSR
      *****************************************************************
