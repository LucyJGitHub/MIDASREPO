     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PB Extraction module for SDACRVPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1544 - Extract module for SDACRVPD                         *
      *                                                               *
      *  Function: This module only sends transactions for Private    *
      *            Banking Customers Account review.                  *
      *                                                               *
      *  Component of: RP1544 - Extract program for SDACRVPD          *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD API Customer Private Banking Details file
     FSDPBDSL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
 
      *****************************************************************
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
      *  *Pssr    - Program exception error routine                   *
      *  *Inzsr   - Program Initialization routine.                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,STD_DCL
 
      ** The following /COPY contains the layout of the Meridian
      ** header as a data structure
     C/COPY RPCPYSRC,MDN_HD_DS
 
      ** Following /COPY is the declares for fields passed to the
      ** formatting  routines
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
 
      **  Array containing Copyright statement.
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D LDA           E DS           256    Extname(LDA) Dtaara
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
     D RPDftsDa      E DS           256    EXTNAME(RPDFTSDA) DTAARA(RPDFTSDA)
 
      ** API DUMP Information Data Area for database error reporting;
      ** based on external file
     D Apdump        E DS                  EXTNAME(APDUMP) DTAARA
 
      **  External Data structure for Run Date Informations.
     D Rundat        E DS                  EXTNAME(RUNDAT) DTAARA
 
      **  Data Structure for access to Customer Details.
      **  Also used to pass data to procedure ProcFormat.
     D Sdcust        E DS                  EXTNAME(SDCUSTPD)
 
      **  Data Structure for access to Currency Details.
     D Sdcurr        E DS                  EXTNAME(SDCURRPD)
 
      **  Data Structure for access to Bank Details.
     D Sdbank        E DS                  EXTNAME(SDBANKPD)
 
      **  Data structure for access programs, long data structure.
     D Dssdy         E DS                  EXTNAME(DSSDY)
 
      **  First Data Structure for Access Programs, short Data
      **  Structure
     D Dsfdy         E DS                  EXTNAME(DSFDY)
 
     D Dsldy         E DS                  EXTNAME(DSLDY)
 
      ** DS for Access Programs, Extend Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of parameters --------------------**
 
      **  Output queue name.
     D OutQueue        S                   Like(MQSQueue)
 
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
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
      **  Key status.
     D P_Kyst          S              7A
      ** ---------- End of fields used by access programs -----------**
 
      **  Work Field used as position for each numeric fields
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
 
      **  End Position.
     D EndPosition     S              7S 0
 
      **  Parameters for ProcFormat.
     D   InData        S                   LIKE(TransData) INZ(*BLANKS)
     D   InDBFile      S             10A   INZ(*BLANKS)
 
      **  Work Field used as key to access to Customer PB Details.
     D K_CustNum       S              6
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Composite Data.
     D CompData        S                   LIKE(TransData)
 
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
 
 
      **  Enter the processing to read the additional files and produce
      **  composite message here.
 
      **  Extract customer number from SDACRVPD message data.
     C                   Z-ADD     1             X
     C     'ARCUST'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      P_Cust = %SUBST(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Cust
     C                   PARM                    P_Kyst
     C     SDCUST        PARM      SDCUST        Dsldy
 
     C                   IF        P_Rtcd = *BLANKS
     C                   IF        BBPRBA <> 'Y'
 
     C                   MOVE      BBCUST        K_CustNum
     C     K_CustNum     CHAIN     SDPBDSL0                           81
 
     C     *IN81         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'SDPBDSL0'
     C                   EVAL      DBase  = 03
     C                   EVAL      DBkey  = BBCUST
     C                   OUT       LDA
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        BBPRBA = 'Y' OR
     C                             PBREPB = 'Y'
 
      **  Reformat entire SDCUSTPD record (SDCUSTD0).
      **  The relevant member in file RPMSGFPD contains details of the
      **  fields in the file to be processed (it is a DSPFFD outfile).
      **  This file must already be set up with the field data for the
      **  file to be processed.
     C                   EVAL      CompData = *BLANKS
 
      **  The SdcustpdData data structure has two sub-fields:
      **     - SdcustpdRec which now contains the formatted data, left
      **     - SdcustpdPosA/SdcustpdPosN which now contains the position
      **     of the first unused byte in SdcustpdRec.
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   EVAL      W_PosFin = %SCAN('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      IFEQ      0
     C     *Lock         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'MSG Type'
     C                   EVAL      DBase  = 02
     C                   EVAL      DBkey  = RAMSGTYPE
     C                   OUT       Lda
     C                   EVAL      ReturnCode = 'Image_Type'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RAMSGTYPE =
     C                             %SUBST(RAMSGTYPE:1:W_PosFin + 1)
     C
      **  Place the result in field CompData.
 
     C                   EVAL      CompData = %SUBST(TransData:1:
     C                                       EndPosition)
 
      **  Call a standard routine to actually send the message.
     C                   CALLB     'RPSNDMSG'
     C                   PARM                    OutQueue
     C                   PARM                    MdnHeadDS
     C                   PARM                    CompData
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'RPSNDMSG  '  DBpgm
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   ELSE
     C                   COMMIT
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
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
     C                   PARM      *BLANK        FieldValue
     C                   PARM      *BLANK        ReturnCode
 
      **  If any error occurred while retrieving position, handle it.
     C     RETURNCODE    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '
     C                   EVAL      DBase  = 03
     C                   EVAL      DBkey  = 'RPC1305'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   EVAL      X = X + 1
      **  If any error occurred while retrieving position, handle it.
     C                   IF        X > 100
     C     *LOCK         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Array   '
     C                   EVAL      DBase  = 04
     C                   EVAL      DBkey  = 'Index  '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ArrFld(X) = FieldName
     C                   EVAL      ArrPos(X) = FieldPosition
     C                   EVAL      ArrLen(X) = FieldLength
 
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
 
     C     W_RunBefore   IFEQ      *BLANK
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
     C                   IF        CommitCtl = 'Y'
     C                   ROLBK
 
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C     DBpgm         IfEQ      *BLANKS
     C                   MOVE      PSProcName    DBpgm
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
      *****************************************************************
      /EJECT
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
 
      **  Set up work fields for formatting that will not change if
      **  Replication formatting is required.
      **     - signs are not shown for Positive numbers.
      **     - get decimal separator from Replication data area
      **       RPDFTSDA.
     C                   IN        RPDftsDa
     C                   EVAL      fmDecSep   = RCDECSEP
     C                   EVAL      fmDpLen  = %SUBST(RCZEROFLD:2:1)
     C                   MOVE      fmDpLen       W_PosDebut
     C                   EVAL      fmShwPsSgn = 'N'
 
      **  Set up work fields that will not change if retrieve
      **  function is to be used.
     C                   EVAL      ScriptName = 'RP' + RATGTSYS
 
     C                   Z-ADD     0             X                 3 0
 
      **  Retrieve position and length of customer number from
      **  SDACRVPD message data.
     C                   EVAL      FieldName   = 'ARCUST'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   EVAL      FieldName   = '*END_IMAGE'
     C                   EVAL      FieldType   = *BLANK
     C                   EXSR      RtvPos
     C                   EVAL      EndPosition = FieldPosition - 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2014
