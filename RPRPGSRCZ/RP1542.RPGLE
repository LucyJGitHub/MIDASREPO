     H DEBUG FIXNBR(*INPUTPACKED)
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas PB Extraction Module for GLACNTQD & RPACNTQD')   *
      *****************************************************************
      *                                                               *
      *  Midas - Replication Module (Private Banking)                 *
      *                                                               *
      *  RP1542 - Extract module for GLACNTQD & RPACNTQD              *
      *                                                               *
      *  Function: This module only sends available balances relative *
      *            to Private Banking Customers.                      *
      *               List of additional fields:                      *
      *                 - Account portfolio reference                 *
      *                                                               *
      *  Component of: RP1542 - Extract program for GLACNTQD/RPACNTQD *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1055588 *CREATE   Date 08Feb13              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1055588 - Available balances in TOF (Child:AR1055591)      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      **  Midas SD API Customer Private Banking Details file.
      *
     FSDPBDSL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **  Midas GL Accounts Master
      *
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
     F                                     Infsr(*Pssr)
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  82  -  CHAIN access to SDPBDSL0/ACCNT failed.                *
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
      **--------------------------------------------------------------------------------------------
      *
      ** The following /COPY contains various standard declares
      *
     C/COPY RPCPYSRC,STD_DCL
      *
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
      *
     C/COPY RPCPYSRC,MDN_HD_DS
      *
      ** Following /COPY is the declares for fields passed to the formatting
      ** routines
      *
     C/COPY RPCPYSRC,RPFMTDCL
      *
      ** Following /COPY is the procedure prototype for the Packed routine
      *
     C/COPY RPCPYSRC,RPFMTPPP
      *
      ** Following /COPY is the procedure prototype for the Signed routine
      *
     C/COPY RPCPYSRC,RPFMTPPS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
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
      *
      ** Array containing Copyright statement
      *
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
      *
      ** Midas Local Data Area for database error reporting; based on
      ** external file
      *
     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
      *
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
      *
      *
      **  Arrays used to store Position and Length of each fields
      *
     D ArrFld          S              6    Dim(100)
     D ArrPos          S              7  0 Dim(100)
     D ArrLen          S              4  0 Dim(100)
      *
      ** Replication Defaults Data Area; based on external file.
      *
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
      *
      **  External data structure for Customer Details.
      *
     D Sdcust        E DS                  EXTNAME(SDCUSTPD)
      *
      **  Data structure used to group settlement account details.
      *
     D W_FullSettlAcc  DS            24
     D   Branch                1      3
     D   CustNo                4      9
     D   Currency             10     12
     D   AccCode              13     22S 0
     D   AccSeq               23     24S 0
 
     D Sdacod        E DS                  EXTNAME(SDACODPD)
      *
      **  External data structure for Account Code Details.
      *
      *
      **  First Data Structure for Access Programs, short Data Structure.
      *
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of parameters --------------------**
      **  Output queue name.
     D OutQueue        S                   LIKE(MQSQueue)
      **--------------------- End of parameters ---------------------**
 
      **-------------- Start of parameters for RPC1305 --------------**
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
      **--------------- End of parameters for RPC1305 ---------------**
      **---------------- start of Parameters for CPB010 --------------**
     D MessageInd      S              1A
 
     D RAMSGOLD        S                   LIKE(RAMSGTYPE)
 
      **   Database Error Messsage Text
     D DBErrText       S            256A
 
      **   Transaction Data of associated transaction
     D AssocData       S                   LIKE(TransData)
 
      **   Meridian header Layout of associated transaction
     D MdHdAssoc       S                   LIKE(MdnHeadDs)
      **----------------  End of Parameters for CPB010  --------------**
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
     D P_Acod          S             10A
     D P_Acsq          S              2A
      **  Key status.
     D P_Kyst          S              7A
      **  Switchable feature number.
     D P_Sard          S              6A
      ** ---------- End of fields used by access programs -----------**
 
      **----------------  Start of additional fields ----------------**
      **-----------------  End of additional fields -----------------**
 
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
 
     D K_CustNum       S              6A
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
     C                   EVAL      MessageInd = 'Y'
     C                   EVAL      RAMSGOLD = RAMSGTYPE
     C                   EVAL      AssocData = *Blanks
     C                   EVAL      MdHdAssoc = *Blanks
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
 
      **----------------- Start of Additionnal fields ---------------**
 
 
      **  Extract customer number from GL/RPACNTQD message data.
     C                   Z-ADD     1             X
     C     'F1CNUM'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Cust = %Subst(TransData:+
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
 
      **  Extract Branch code from GL/RPACNTQD message data.
     C                   Z-ADD     1             X
     C     'F1BRCA'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      Branch = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract CCY code from GL/RPACNTQD message data.
     C                   Z-ADD     1             X
     C     'F1CCY '      LOOKUP    Arrfld(X)                              89
     C                   EVAL      Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Extract Account Code    from GL/RPACNTQD message data.
     C                   Z-ADD     1             X
     C     'F1ACOD'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Acod = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
 
      ** Access Account Code details
 
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Acod
     C     SDACOD        PARM      SDACOD        Dsfdy
 
      **  Only Retails Accounts
     C                   IF        A5ACTY = 'R'
 
      **  Extract Account Sequence from GL/RPACNTQD message data.
     C                   Z-ADD     1             X
     C     'F1ACSQ'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Acsq = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
 
     C                   MOVEL     P_Cust        CustNo
     C                   MOVE      P_Acod        AccCode
     C                   MOVE      P_Acsq        Accseq
 
      **--------- Start of  Get Portfolio on Account ----------**
      **  Define key list to access to Account Master Details file.
     C     K_Accnt       KLIST
     C                   KFLD                    CustNo
     C                   KFLD                    Currency
     C                   KFLD                    AccCode
     C                   KFLD                    AccSeq
     C                   KFLD                    Branch
 
      **  Retrieve Account details (Portfolio Reference)
     C     K_Accnt       CHAIN     ACCNT                              82
 
      **  If Account does not exist, handle database error.
     C     *in82         IFEQ      True                                         Begin *in82
     C     *lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'ACCNT'                             ***************
     C                   EVAL      Dbase  = 03                                  * Db Error 03 *
     C                   EVAL      DbKey = W_FullSettlAcc                       ***************
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = W_NoRcdFnd
     C                   EXSR      Repair
     C                   ENDIF                                                  End  *in82
 
      **---------- End of Access account ------------**
 
      **------------------ End of Additionnal fields ----------------**
 
      **  Non closed Retails Accounts
     C                   IF        A_DACC = 0
 
      **  Change message Type from _A to _After (To activate later when repository is ready)
      ** Note this is opposite to standard to avoid MDBASCRIPT extract.)
      **  Determine Image Type.
     C                   EVAL      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      IFEQ      0                                            Begin W_PosFin
     C     *Lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'MSG Type'                          ***************
     C                   EVAL      DBase  = 06                                  * Db Error 06 *
     C                   EVAL      DBkey  = RAMSGTYPE                           ***************
     C                   OUT       Lda
     C                   EVAL      ReturnCode = 'Image_Type'
 
     C                   EVAL      MessageInd = 'N'
     C                   EXSR      Repair
     C                   EVAL      MessageInd = 'Y'
     C                   ENDIF                                                  End W_PosFin
 
      **  Change  Image Type.
 
     C                   EVAL      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
 
      **  Place the result in field CompData.
 
     C                   EVAL      CompData  = %subst(TransData:1:EndPosition)
     C                                       + A_PTFR                           Portfolio reference
 
      **  Call a standard routine to actually send the message.
     C                   CALLB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   IF        ReturnCode <> *blank                         Begin ReturnCode
     C     *Lock         IN        Lda
     C                   MOVE      'RPSNDMSG  '  DBpgm
     C                   OUT       Lda
     C                   EXSR      Repair
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   ELSE                                                   Else ReturnCode
 
     C                   EXSR      WrtTrace
     C                   COMMIT
 
     C                   ENDIF                                                  End ReturnCode
     C                   ENDIF
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
     C     ReturnCode    IFNE      *blanks                                      Begin ReturnCode
     C     *Lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '                          ***************
     C                   EVAL      DBase  = 04                                  * Db Error 04 *
     C                   EVAL      DBkey  = 'RPC1305'                           ***************
     C                   OUT       Lda
 
     C                   EVAL      MessageInd = 'N'
     C                   EXSR      Repair
     C                   EVAL      MessageInd = 'Y'
 
     C                   ENDIF                                                  End ReturnCode
 
     C                   EVAL      X = X + 1
      **  If any error occurred while retrieving position, handle it.
     C                   IF        X > 100
     C     *lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Array   '                          ***************
     C                   EVAL      DBase  = 05                                  * Db Error 05 *
     C                   EVAL      DBkey  = 'Index  '                           ***************
     C                   OUT       LDA
     C                   EXSR      Repair
     C                   ENDIF                                                  End ReturnCode
 
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
     C                   EVAL      DBfile = 'Call    '                          **************
     C                   EVAL      DBase  = 08                                  * Db Error 8 *
     C                   EVAL      DBkey  = 'RP1590'                            **************
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
     C                   EVAL      DBfile = 'Call    '                          **************
     C                   EVAL      DBase  = 50                                  * Db Error 50
     C                   EVAL      DBkey  = 'RP1592'                            **************
     C                   OUT       Lda
 
     C                   EXSR      *pssr
     C                   ELSE
     C                   RETURN
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
 
     C     W_RunBefore   IFEQ      *blank                                       Begin W_RunBefore
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
     C                   IF        CommitCtl = 'Y'                              Begin CommiCtl
     C                   ROLBK
 
     C                   ENDIF                                                  End CommitCtl
 
     C     *Lock         IN        Lda
     C     DBpgm         IFEQ      *blanks                                      Begin DBpgm
     C                   EVAL      DBpgm  = PSProcName
     C                   OUT       Lda
 
     C                   ENDIF                                                  End DBpgm
 
     C                   MOVE      'Y'           W_RunBefore
     C                   DUMP
 
     C                   ENDIF                                                  End W_RunBefore
 
     C     ReturnCode    IFEQ      *blank                                       Begin ReturnCode
     C                   EVAL      ReturnCode = '*PSSR'
     C                   ENDIF                                                  End ReturnCode
 
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
 
     C     *Inzsr        BEGSR
 
     C     *Entry        PLIST
      *
      **  MQSeries queue to write to - this parameter IS used in this module
      *
     C                   PARM                    OutQueue
      *
      **  Merdian header
      *
     C                   PARM                    MdnHeadDS
      *
      **  Transaction Data
      *
     C                   PARM                    TransData
      *
      **  Commitment control flag
      *
     C                   PARM                    CommitCtl
      *
      **  Return Code
      *
     C                   PARM                    ReturnCode
 
     C                   EVAL      MessageInd = 'Y'
      *
      **  Set up work fields for formatting that will not change if
      **  Replication formatting is required.
      **     - signs are not shown for Positive numbers.
      **     - get decimal separator from Replication data area RPDFTSDA.
      *
     C                   IN        RPDftsDa
     C                   EVAL      fmDecSep   = RCDECSEP
     C                   EVAL      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   MOVE      fmDpLen       W_PosDebut
     C                   EVAL      fmShwPsSgn = 'N'
      *
      **  Set up work fields that will not change if retrieve
      **  function is to be used.
      *
     C                   EVAL      ScriptName = 'RP' + RATGTSYS
 
     C                   Z-ADD     0             X                 3 0
 
      *
      **  Retrieve position and length of customer number from GL/RPACNTQD message data.
      *
     C                   EVAL      FieldName   = 'F1CNUM'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
      *
      **  Retrieve position and length of Purchase Ccy from GL/RPACNTQD message data.
      *
     C                   EVAL      FieldName   = 'F1CCY'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
      *
      **  Retrieve position and length of  Branch from GL/RPACNTQD message data.
      *
     C                   EVAL      FieldName   = 'F1BRCA'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
      *
      **  Retrieve position and length of Account Code from GL/RPACNTQD message data.
      *
     C                   EVAL      FieldName   = 'F1ACOD'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
      *
      **  Retrieve position and length of Account sequence  from GL/RPACNTQD.
      *
     C                   EVAL      FieldName   = 'F1ACSQ'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos
      *
      **  Retrieve begin position of additionnal fields in Meridian message.
      *
     C                   EVAL      FieldName   = '*END_IMAGE'
     C                   EVAL      FieldType   = *blank
     C                   EXSR      RtvPos
     C                   EVAL      EndPosition = FieldPosition - 1
 
     C                   ENDSR
      /Eject
      *****************************************************************
**  Cpy@
(c) Misys International Banking Systems Ltd. 2012
