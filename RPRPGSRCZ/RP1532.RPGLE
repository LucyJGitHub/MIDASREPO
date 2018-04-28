     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Extraction Module for SDACTXPD')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1532 - Midas RP PB Extraction Module for SDACTXPD          *
      *                                                               *
      *  Function:  This module sends Customer Details by Country     *
      *             of Tax information from Midas to TOF for Private  *
      *             Customers only.                                   *
      *                                                               *
      *  Component of: RP1532 - Extract program for SDACTXPD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Midas SD API Customer Private Banking Details file.
     FSDPBDSL0  IF   E           K Disk
     F                                     INFSR(*Pssr)
 
      /EJECT
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
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
      *       * 81   82   83   84   85   86   87   88   89   90 *     *
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
      *  *PSSR    - Program exception error routine                   *
      *  *INZSR   - Program Initialization routine.                   *
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
      /COPY RPCPYSRC,Std_Dcl
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
      /COPY RPCPYSRC,Mdn_Hd_DS
 
      ** Following /COPY is the declares for fields passed to the formatting
      **  routines
      /COPY RPCPYSRC,RPFMTDCL
 
      ** Following /COPY is the procedure prototype for the Packed routine
      /COPY RPCPYSRC,RPFMTPPP
 
      ** Following /COPY is the procedure prototype for the Signed routine
      /COPY RPCPYSRC,RPFMTPPS
 
      ** Following /COPY is the procedure prototype for the Format routine
      ** that is used to process an entire record
      /COPY RPCPYSRC,RPFMTPPF
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
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
 
      ** Arrays used to store Position and Length of each fields
     D ArrFld          S              6    Dim(100)
     D ArrPos          S              7  0 Dim(100)
     D ArrLen          S              4  0 Dim(100)
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) Dtaara(RPDFTSDA)
 
      ** API DUMP Information Data Area for database error reporting;
      ** based on external file
     D Apdump        E DS                  Extname(APDUMP) Dtaara
 
      ** External Data structure for Run Date Informations.
     D Rundat        E DS                  Extname(RUNDAT) Dtaara
 
      ** Data Structure for access to Customer Details.
      ** Also used to pass data to procedure ProcFormat.
     D Sdcust        E DS                  Extname(SDCUSTPD)
 
      ** Data Structure for access to Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      ** Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
      ** First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure
 
      ** Structure to receive a formatted customer details
      ** record from procedure ProcFormat.
      ** SdcustpdPosA (and SdcustpdPosN) contain the position of the first
      ** unused position in SdcustpdRec. If the input data is blank at the
      ** end this would be well after the last non-blank character.
     D SdcustpdData    DS
     D  SdcustpdRec                        Like(TransData)
     D  SdcustpdPosA                  4
     D  SDcustpdPosN                  4S 0 Overlay(SdcustpdPosA)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for Output queue
      ** Output queue name.
     D OutQueue        S                   Like(MQSQueue)
 
      ** Parameter for RPC1305
      ** Script Name.
     D ScriptName      S             10A
      ** Image Name.
     D ImageName       S             32A
      ** Field Name.
     D FieldName       S             10A
      ** Field Type.
     D FieldType       S              1A
      ** Field Value.
     D FieldValue      S           9999A
      ** Field Position.
     D FieldPosition   S              7S 0
      ** Field Length
     D FieldLength     S              4S 0
 
      ** Parameter for access programs
      ** Return code.
     D P_RtCd          S              7A
      ** Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
      **  Key status.
     D P_Kyst          S              7A
 
      ** Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      ** End Position.
     D EndPosition     S              7S 0
 
      ** Parameters for ProcFormat.
     D   InData        S                   Like(TransData) Inz(*Blanks)
     D   InDBFile      S             10A   Inz(*Blanks)
 
      ** Work Field used as key to access to Customer PB Details.
     D*K_CustNum****   S              6  0                                                   CSD027A
     D K_CustNum       S              6A                                                     CSD027A
 
      ** Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      ** Composite Data.
     D CompData        S                   Like(TransData)
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** Work field used to set up return code when no record found.
     D W_NoRcdFnd      C                   Const('*NoRcdFnd')
 
      ** Work field used for change message type
     D W_PosFin        S              3S 0
 
      ** Work field used as index for an array
     D X               S              3  0 Inz
 
      **   Database Error Messsage Text
     D DBErrText       S            256A
 
      **   Transaction Data of associated transaction
     D AssocData       S                   LIKE(TransData)
 
      **   Meridian header Layout of associated transaction
     D MdHdAssoc       S                   LIKE(MdnHeadDs)
 
     D MessageInd      S              1A
     D RAMSGOLD        S                   LIKE(RAMSGTYPE)
     D Dbasea          S              3
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     C     Start         TAG
 
      ** Note: the above TAG is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
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
 
     C                   Eval      MessageInd = 'Y'
     C                   Eval      RAMSGOLD = RAMSGTYPE
 
      ** Enter the processing to read the additional files and produce a
      ** composite message here.
 
      ** Extract customer number from SDACTXPD message data.
 
     C                   Z-ADD     1             X
     C     'AXCUST'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Cust = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      ** Access Customer Details by using Access Object,
      ** to retrieve Private Banking Customer Indicator.
 
     C                   CALL      'AOCUSTR1'
     C                   PARM      *Blanks       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust
     C                   PARM                    P_Kyst
     C     Sdcust        PARM      Sdcust        Dsldy
 
      **  If Customer Details do not exist, handle Database Error.
 
     C     P_Rtcd        IFNE      *Blanks
     C     BBCLST        ANDNE     'Y'
     C     *Lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SDCUSTPD'
     C                   EVAL      DBase  = 05
     C                   EVAL      DBkey  = P_Cust
     C                   OUT       Lda
     C                   EVAL      ReturnCode  = P_RTCD
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
     C     *LOCK         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDPBDSL0'
     C                   EVAL      Dbase  = 06
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
 
      **----------------- Start of Additionnal fields ---------------**
 
      ** Reformat entire SDCUSTPD record (SDCUSTD0).
      ** The relevant member in file RPMSGFPD contains details of the fields
      ** in the file to be processed (it is a DSPFFD outfile).
      ** This file must already be set up with the field data for the
      ** file to be processed.
 
     C                   EVAL      CompData = *Blanks
     C                   EVAL      InData   = Sdcust
     C                   EVAL      InDBFile = 'SDCUSTPD  '
     C                   EVAL      SdcustpdData = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      ** The SdcustpdData data structure has two sub-fields:
      **    - SdcustpdRec which now contains the formatted data, left aligned.
      **    - SdcustpdPosA/SdcustpdPosN which now contains the position of
      **    the first unused byte in SdcustpdRec.
 
      **------------------ End of Additionnal fields ----------------**
 
      ** Change message Type from _After to _A
      ** Determine Image Type.
     C                   EVAL      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      ** If it is impossible to determine the image type, handle error.
 
     C     W_PosFin      IFEQ      0
     C     *LOCK         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'MSG Type'
     C                   EVAL      DBase  = 02
     C                   EVAL      DBkey  = RAMSGTYPE
     C                   OUT       Lda
     C                   EVAL      ReturnCode = 'Image_Type'
 
     C                   Eval      MessageInd = 'N'
     C                   EXSR      Repair
     C                   Eval      MessageInd = 'Y'
 
     C                   ENDIF
 
     C                   EVAL      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
     C
      ** Place the result in field CompData.
 
     C                   EVAL      CompData = %subst(TransData:1:EndPosition)
     C                                       + %subst(SdcustpdRec:1:+
     C                                                           SdcustpdPosN-1)
 
      ** Call a standard routine to actually send the message.
 
     C                   CALLB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      ** If error then perform any special processing and exit
 
     C                   IF        ReturnCode <> *Blanks
     C     *LOCK         IN        Lda
     C                   MOVE      'RPSNDMSG  '  DBpgm
     C                   OUT       Lda
     C                   EXSR      Repair
 
      ** If no error, commit the unit of work so that messages that have
      ** been got from a queue would be permanently deleted and put
      ** operations would be made permanent.
 
     C                   ELSE
     C                   EXSR      WrtTrace
     C                   COMMIT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RtvPos   - Retrieve position in Meridian message.            *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     RtvPos        BEGSR
 
     C                   CALL      'RPC1305'
     C                   PARM                    ScriptName
     C                   PARM      RAMSGTYPE     ImageName
     C                   PARM                    FieldName
     C                   PARM                    FieldType
     C                   PARM                    TransData
     C                   PARM      0             FieldPosition
     C                   PARM      0             FieldLength
     C                   PARM      *Blanks       FieldValue
     C                   PARM      *Blanks       ReturnCode
 
      ** If any error occurred while retrieving position, handle it.
 
     C     ReturnCode    IFNE      *Blanks
     C     *LOCK         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 03
     C                   EVAL      DBkey  = 'RPC1305'
     C                   OUT       Lda
 
     C                   Eval      MessageInd = 'N'
     C                   EXSR      Repair
     C                   Eval      MessageInd = 'Y'
 
     C                   ENDIF
 
     C                   EVAL      X = X + 1
 
      ** If any error occurred while retrieving position, handle it.
 
     C                   IF        X > 100
     C     *LOCK         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 04
     C                   EVAL      DBkey  = 'Index  '
     C                   OUT       Lda
     C                   EXSR      Repair
     C                   ENDIF
 
     C                   EVAL      ArrFld(X) = FieldName
     C                   EVAL      ArrPos(X) = FieldPosition
     C                   EVAL      ArrLen(X) = FieldLength
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
     C                   EVAL      DBase  = 51
     C                   EVAL      DBkey  = 'RP1590'
     C                   OUT       Lda
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
 
     C                   MOVE      Dbase         dbasea
 
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
      *****************************************************************
      /EJECT
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
 
     C     W_RunBefore   IFEQ      *Blanks
 
      ** If commitment control required, back out the unit of work so
      ** that current message could be available again.
 
     C                   IF        CommitCtl = 'Y'
     C                   ROLBK
     C                   ENDIF
 
     C     *LOCK         IN        Lda
     C     DBpgm         IFEQ      *Blanks
     C                   MOVE      PSProcName    DBpgm
     C                   OUT       Lda
 
     C                   ENDIF
 
     C                   MOVE      'Y'           W_RunBefore
     C                   DUMP
 
     C                   ENDIF
 
     C     ReturnCode    IFEQ      *Blanks
     C                   EVAL      ReturnCode = '*PSSR'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
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
 
      ** Set up work fields for formatting that will not change if
      ** Replication formatting is required.
      **    - signs are not shown for Positive numbers.
      **    - get decimal separator from Replication data area RPDFTSDA.
 
     C                   IN        RPDftsDa
     C                   EVAL      fmDecSep   = RCDECSEP
     C                   EVAL      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   MOVE      fmDpLen       W_PosDebut
     C                   EVAL      fmShwPsSgn = 'N'
 
      ** Set up work fields that will not change if retrieve
      ** function is to be used.
 
     C                   EVAL      ScriptName = 'RP' + RATGTSYS
 
      ** Retrieve position and length of customer number from SDJACCPD message data.
 
     C                   EVAL      FieldName   = 'AXCUST'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      ** Retrieve begin position of additionnal fields in Meridian message.
 
     C                   EVAL      FieldName   = '*END_IMAGE'
     C                   EVAL      FieldType   = *Blanks
     C                   EXSR      RtvPos
     C                   EVAL      EndPosition = FieldPosition - 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
