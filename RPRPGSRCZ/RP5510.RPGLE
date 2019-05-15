     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas Extraction Module for DEFLTD CFF008')
      *****************************************************************
      *                                                               *
      *  Midas - Replication Module                                   *
      *                                                               *
      *  RP5510 - Extract module for DEFLTD                           *
      *                                                               *
      *  Function:    Extended Selection: None                        *
      *               List of additional fields:                      *
      *                 - CHGCMD.xxxxxx: xxxxxxxxxxxxxxxx             *
      *                   (all fields from TTFI-CZONE)                *
      *                                                               *
      *  Component of: RP5510 - Extract program for DEFLTD            *
      *                                                               *
/*    *  (C) COPYRIGHT Finastra International Limited 2005            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 03May06               *
      *                 CFF008 CR          Date 15/07/05              *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CSF008 - INT-3 FF Static data Inteface MIDAS-OPICS INTERFACE *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      /Eject
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
 
      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,Std_Dcl
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C/COPY RPCPYSRC,Mdn_Hd_DS
 
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
 
      ** Data Structure for access to Instrument  Details.
     D INSTR         E DS                  EXTNAME(INTYPD)
     D                                     PREFIX(I)
      ** Data Structure for access to Country  Details.
     D CHGCM         E DS                  EXTNAME(CHGCMD)
     D                                     PREFIX(C)
 
      ** Replication Defaults Data Area; based on external file.
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
 
      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
     D*Dsldy         E DS                  Extname(DSLDY)
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
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      ** ---------- End of fields used by access programs -----------**
 
      **----------------  Start of additional fields ----------------**
     D W_Extended      DS
     D  W_TTFI                        1A
     D  W_MINC                       15A
     D  W_MAXC                       15A
     D  W_LR01                        7A
     D  W_LR02                        7A
     D  W_LR03                        7A
     D  W_LR04                        7A
     D  W_LR05                        7A
     D  W_LR06                        7A
     D  W_LR07                        7A
     D  W_LR08                        7A
     D  W_LR09                        7A
     D  W_CA01                       15A
     D  W_CA02                       15A
     D  W_CA03                       15A
     D  W_CA04                       15A
     D  W_CA05                       15A
     D  W_CA06                       15A
     D  W_CA07                       15A
     D  W_CA08                       15A
     D  W_CA09                       15A
     D  W_PRFC                        4A
     D  W_BOTR                        1A
     D  W_ZONE                       10A
 
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
 
      ** Instrument types key
     D W_Instr         DS
     D  W_Mrkt                        2A
     D  W_Istc                        3A
 
      ** Commissions and charges key
     D W_Chgc          DS
     D  W_Iscy                        3A
     D  W_Cmcd                        2A
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
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **----------------- Start of Extended Selection ---------------**
 
 
      **  Extract Market centre from DEFLTD message data.
     C                   Z-add     1             X
     C     'MRKT  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Mrkt = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
      **  Extract Instrument code from DEFLTD message data.
     C                   Z-add     1             X
     C     'ISTC  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Istc = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
      **  Extract Commission code from DEFLTD message data.
     C                   Z-add     1             X
     C     'CMCD  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Cmcd = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Retrieve instrument ccy if field not blank.
     C     W_Instr       Ifne      *blank                                       Begin Extended Filt1
     C                   Exsr      GetInstr
     C                   MOVE      IISCY         W_Iscy
     C                   Endif                                                  End Extended Filt 1
 
      **  Retrieve commission code if field not blank.
     C     W_Cmcd        Ifne      '00'                                         Begin Extended Filt1
     C                   Exsr      GetChgcd
     C*
 
      **----------------- Start of Additionnal fields ---------------**
 
     C                   MOVE      CTTFI         W_TTFI
     C                   MOVE      CMINC         W_MINC
     C                   MOVE      CMAXC         W_MAXC
     C                   MOVE      CLR01         W_LR01
     C                   MOVE      CLR02         W_LR02
     C                   MOVE      CLR03         W_LR03
     C                   MOVE      CLR04         W_LR04
     C                   MOVE      CLR05         W_LR05
     C                   MOVE      CLR06         W_LR06
     C                   MOVE      CLR07         W_LR07
     C                   MOVE      CLR08         W_LR08
     C                   MOVE      CLR09         W_LR09
     C                   MOVE      CCA01         W_CA01
     C                   MOVE      CCA02         W_CA02
     C                   MOVE      CCA03         W_CA03
     C                   MOVE      CCA04         W_CA04
     C                   MOVE      CCA05         W_CA05
     C                   MOVE      CCA06         W_CA06
     C                   MOVE      CCA07         W_CA07
     C                   MOVE      CCA08         W_CA08
     C                   MOVE      CCA09         W_CA09
     C                   MOVE      CPRFC         W_PRFC
     C                   MOVE      CBOTR         W_BOTR
     C                   MOVE      CZONE         W_ZONE
 
     C                   ELSE                                                   Begin Extended Filt1
 
     C                   MOVE      *blanks       W_TTFI
     C                   MOVE      *blanks       W_MINC
     C                   MOVE      *blanks       W_MAXC
     C                   MOVE      *blanks       W_LR01
     C                   MOVE      *blanks       W_LR02
     C                   MOVE      *blanks       W_LR03
     C                   MOVE      *blanks       W_LR04
     C                   MOVE      *blanks       W_LR05
     C                   MOVE      *blanks       W_LR06
     C                   MOVE      *blanks       W_LR07
     C                   MOVE      *blanks       W_LR08
     C                   MOVE      *blanks       W_LR09
     C                   MOVE      *blanks       W_CA01
     C                   MOVE      *blanks       W_CA02
     C                   MOVE      *blanks       W_CA03
     C                   MOVE      *blanks       W_CA04
     C                   MOVE      *blanks       W_CA05
     C                   MOVE      *blanks       W_CA06
     C                   MOVE      *blanks       W_CA07
     C                   MOVE      *blanks       W_CA08
     C                   MOVE      *blanks       W_CA09
     C                   MOVE      *blanks       W_PRFC
     C                   MOVE      *blanks       W_BOTR
     C                   MOVE      *blanks       W_ZONE
 
      **------------------ End of Additionnal fields ----------------**
     C                   Endif                                                  End Extended Filt 1
 
 
      **  Place the result in field CompData.
 
     C                   Eval      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_Extended
 
      **  Call a standard routine to actually send the message.
     C                   Callb     'RPSNDMSG'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   Parm                    CompData
     C                   Parm                    CommitCtl
     C                   Parm                    ReturnCode
 
      ** If error then perform any special processing and exit
     C                   If        ReturnCode <> *blank                         Begin ReturnCode
     C     *Lock         In        Lda
     C                   Move      'RPSNDMSG  '  DBpgm
     C                   Out       Lda
     C                   Exsr      *Pssr
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   Else                                                   Else ReturnCode
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
     C     *Lock         In        Lda
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
     C                   Eval      DBpgm  = PSProcName
     C                   Out       Lda
 
     C                   Endif                                                  End DBpgm
 
     C                   Move      'Y'           W_RunBefore
     C                   Dump
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Seton                                        U7U8LR
     C                   Return
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called at : program initialization time.                      *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        Begsr
 
     C     *Entry        Plist
      **  MQSeries queue to write to - this parameter IS used in this module
     C                   Parm                    OutQueue
      **  Merdian header
     C                   Parm                    MdnHeadDS
      **  Transaction Data
     C                   Parm                    TransData
      **  Commitment control flag
     C                   Parm                    CommitCtl
      **  Return Code
     C                   Parm                    ReturnCode
 
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
 
     C                   Z-add     0             X                 3 0
 
      **  Retrieve position and length of Market Centre from DEFLTD message data.
     C                   Eval      FieldName   = 'MRKT  '
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Instrument code from DEFLTD message data.
     C                   Eval      FieldName   = 'ISTC  '
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Commission code from DEFLTD message data.
     C                   Eval      FieldName   = 'CMCD  '
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
                                                                                    LBWLON1/CSD026
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  GetInstr - get Instrument code                               *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     GetInstr      Begsr
 
      **  Access to Instrument details, by using access object.
     C                   Call      'AOFFITR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    W_Instr                        I:Key field
     C     INSTR         Parm      INSTR         Dssdy                          O:Format
 
      **  If instrument does not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'INTYPD'                            ***************
     C                   Eval      Dbase  = 06                                  * Db Error 06 *
     C                   Eval      Dbkey  = W_Instr                             ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = P_RTCD
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   Endsr
      *****************************************************************
 
     C     GetChgcd      Begsr
 
      **  Access to Instrument details, by using access object.
     C                   Call      'AOCCOMR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    W_Iscy                         I:Key field
     C                   Parm                    W_Cmcd                         I:Key field
     C     CHGCM         Parm      CHGCM         Dssdy                          O:Format
 
      **  If commission does not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'CHGCMD'                             ***************
     C                   Eval      Dbase  = 07                                  * Db Error 06 *
     C                   Eval      Dbkey  = W_Chgc                              ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = P_RTCD
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   Endsr
      /Eject
      *****************************************************************
**  Cpy@
(C) Copyright Finastra International Limited 2001
