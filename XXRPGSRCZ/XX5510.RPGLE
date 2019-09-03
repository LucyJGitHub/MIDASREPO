     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas XX Extended Messages for RSACMTPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Replication Module                                   *
      *                                                               *
      *  XX5510 - Create an extended message for RSACMTPD with        *
      *           the Retail Account No. from ACCNTAB for STPAYMENT   *
      *                                                               *
      *  Function:    Extended Selection: None                        *
      *               List of additional fields:                      *
      *               File ACCNTAB - ACNO: Retail Account No.         *
      *                                                               *
      *               Get ACNO from ACCNTAB and create an extended    *
      *               message for RSACMTPD.                           *
      *                                                               *
      *  Component of: XX5510 - Extract program for RSACMTPD          *
      *                                                               *
      ***(C)*Copyright*Misys*International*Banking*Systems*Ltd,*2013***             NCI102
      *  (C) Copyright Finastra International Ltd. 2019               *             NCI102
      *                                                               *
      *  Last Amend No. NCI102              Date 17Jul19              *
      *  Prev Amend No. NCI002  *Create     Date 28Aug13              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  NCI102 - Replication changes to create extended messages     *
      *           (Upgrade to FM2.1 SP20)                             *
      *  NCI002 - Replication changes to create extended messages     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FACCNTL0   IF   E           K DISK

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
     **COPY*RPCPYSRC*Std_Dcl****                                                         NCI102
     C/COPY RPCPYSRC,STD_DCL                                                             NCI102

      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     **COPY*RPCPYSRC*Mdn_Hd_DS****                                                       NCI102
     C/COPY RPCPYSRC,MDN_HD_DS                                                           NCI102

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

      **  First Data Structure for Access Programs, short Data Structure.
     D Dsfdy         E DS                  Extname(DSFDY)

      **  Second Data Structure foR Access Programs, long Data Structure.
     D Dssdy         E DS                  Extname(DSSDY)

      **  DS to hold SCSARDPD details
     D SCSARD        E DS                  Extname(SCSARDPD)

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
     D  W_ACNO                       10  0
     D
     D  GL_Acct        DS
     D    CUSN                        6A
     D    CCYD                        3A
     D    ACDE                       10  0
     D    ASNC                        2  0
     D    BRCA                        3A
      ** Rename fields to alpha fields
     D    ACDEA                      10
     D    ASNCA                       2
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

     C*****NCI002        Ifeq      'N'                                                   NCI102
     C     NCI102        Ifeq      'N'                                                   NCI102
     C                   Return
     C                   Endif

      **  Enter the processing to read the additional files and produce a
      **  composite message here.

      **----------------- Start of Extended Selection ---------------**

     C**  Extract GL Account No from RSACMTPD message data.
     C                   Eval      CUSN = %subst(Transdata:21:6)
     C                   Eval      CCYD = %subst(Transdata:27:3)
     C                   Eval      ACDEA = %subst(Transdata:32:10)
     C                   Eval      ASNCA = %subst(Transdata:44:2)
     C                   Eval      BRCA = %subst(Transdata:46:3)
      *
     C                   Movel     ACDEA         ACDE
     C                   Move      ASNCA         ASNC
      *
      **  Retrieve Account details if field not blank.
     C     GL_Acct       Ifne      *blank                                       Begin Extended Filt1
     C                   Exsr      GetRetNo
      ** If retail account not found, do not create a message. Exit
      *
     C     W_ACNO        IFEQ      0
     C                   Return
     C                   End
      *
      **----------------- Start of Extended Selection ---------------**

      **----------------- Start of Additionnal fields ---------------**
      **------------------ End of Additionnal fields ----------------**
      *
      *   Change message Type from _A to _Composite
      *   Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_A':RAMSGTYPE)
     C
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 03                                  * Db Error 03 *
     C                   Eval      DBkey  = RAMSGTYPE                           ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = 'Image_Type'
     C                   Exsr      *Pssr
     C                   Endif                                                  End W_PosFin
     C
     C                   Eval      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin)  +
     C                             'Composite'
     C
      **  Place the result in field CompData.
      *
     C                   Eval      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_Extended

      **  Call a standard routine to actually send the message.
     C                   Callb     'RPSNDMSG'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   Parm                    CompData
     C                   Parm                    CommitCtl
     C                   Parm                    ReturnCode
      *
      ** If error then perform any special processing and exit
     C                   If        ReturnCode <> *blank                         Begin ReturnCode
     C     *Lock         In        Lda
     C                   Move      'RPSNDMSG  '  DBpgm
     C                   Out       Lda
     C                   Exsr      *Pssr
      *
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   Else                                                   Else ReturnCode
     C                   Commit
     C                   Endif                                                  End ReturnCode

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

     C**  Retrieve position and length of GL Account No from RSACMTPD message data.
     C                   Eval      FieldName   = 'CUSN'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos

     C**  Retrieve position and length of Currency Code from RSACMTPD message data.
     C                   Eval      FieldName   = 'CCYD'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Account codes from RSACMTPD message data.
     C                   Eval      FieldName   = 'ACDE'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Account Seq   from RSACMTPD message data.
     C                   Eval      FieldName   = 'ASNC'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos

      **  Retrieve position and length of Branch Code  from RSACMTPD messag e data.
     C                   Eval      FieldName   = 'BRCA'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
      *
     C                   Eval      EndPosition = FieldPosition - 1
      *
     C                   Call      'AOSARDR0'
     C                   PARM      *Blanks       P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C**********         PARM      'NCI002'      WSard             7                     NCI102
     C                   PARM      'NCI102'      WSard             7                     NCI102
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   If        P_Rtcd = *Blank
     C**********         move      'Y'           NCI002            1                     NCI102
     C                   move      'Y'           NCI102            1                     NCI102
     C                   else
     C**********         move      'N'           NCI002                                  NCI102
     C                   move      'N'           NCI102                                  NCI102
     C                   Endif
      *
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  GetRetNo - Get Retail Account Number                         *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************

     C     GetRetNo      Begsr

      **  Extract Retail Account No from ACCNTAB
     C     KACCNT        KLIST
     C                   KFLD                    CUSN
     C                   KFLD                    CCYD
     C                   KFLD                    ACDE
     C                   KFLD                    ASNC
     C                   KFLD                    BRCA
      **
     C     KACCNT        Chain     ACCNTL0                            89
     C     *IN89         Ifeq      '0'
     C     ATYP          Andeq     'R'
     C     ACST          Andne     'C'
     C                   Z-add     ACNO          W_ACNO
     C                   Else
     C                   Z-add     *ZERO         W_ACNO
     C                   Endif
     C
     C                   Endsr
      /Eject
      *****************************************************************
**  Cpy@
(C) Copyright Finastra International Ltd 2019
