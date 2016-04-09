     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PB Extraction module for SDSECSPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1515 - Extract module for SDSECSPD                         *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               Additional file:                                *
      *                 - Customer Details file                       *
      *                                                               *
      *  Component of: RP1515 - Extract program for SDSECSPD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR1057854          Date 21Nov12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 CPB010             Date 16Jan03               *
      *                 211268             Date 29Oct02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002   *CREATE   Date 03May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1057854 - Geneva Drop 01 Build Issues - RPG Program        *
      *              Compilation Error                                *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
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
      *  211268 - Use image before to manage msg sending as it is     *
      *           possible to amend customer classification.          *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
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
      *  Repair   - Repair process                                    *         CPB010
      *  WrtTrace - Trace process                                     *         CPB010
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
     C***/COPY*RPCPYSRC,Std_Dcl                                                            AR1057854
     C/COPY RPCPYSRC,STD_DCL                                                               AR1057854
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C***/COPY*RPCPYSRC,Mdn_Hd_DS                                                          AR1057854
     C/COPY RPCPYSRC,MDN_HD_DS                                                             AR1057854
 
      ** Following /COPY is the declares for fields passed to the formatting
      **  routines
     C/COPY RPCPYSRC,RPFMTDCL
 
      ** Following /COPY is the procedure prototype for the Packed routine
     C/COPY RPCPYSRC,RPFMTPPP
 
      ** Following /COPY is the procedure prototype for the Signed routine
     C/COPY RPCPYSRC,RPFMTPPS
 
      ** Following /COPY is the procedure prototype for the Format routine
      ** that is used to process an entire record
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
 
      **  Array containing Copyright statement.
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
 
      **  Data Structure for access to Customer Details.
      **  Also used to pass data to procedure ProcFormat.
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
 
      **  Structure to receive a formatted customer details
      **  record from procedure ProcFormat.
      **  SdcustpdPosA (and SdcustpdPosN) contain the position of the first
      **  unused position in SdcustpdRec. If the input data is blank at the
      **  end this would be well after the last non-blank character.
     D SdcustpdData    DS
     D  SdcustpdRec                        Like(TransData)
     D  SdcustpdPosA                  4
     D  SDcustpdPosN                  4S 0 Overlay(SdcustpdPosA)
 
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
                                                                                CPB010
      **   Image Type - Amend Before, Amend After or Insert                     CPB010
     D ImageType       S             20A                                        CPB010
      **----------------  End of Parameters for CPB010  --------------**        CPB010
 
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
 
      ****Work*Field*used*as*key*to*access*to*Customer*PB*Details.*                           CSD027
     D*K_CustNum*      S              6  0                                                    CSD027
 
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
     D B_BFCLAS        S              1                                         211268
     D A_BFCLAS        S              1                                         211268
     D A_BFTYLC        S              1                                         211268
     D Action          S              2                                         211268
 
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
 
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                         CPB010
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
                                                                                211268
     C                   Eval      Action = %Subst(TransData:1:2)               211268
      **  Check image (Before or After) of the message                          211268
     C                   Eval      W_PosFin    = %Scan('_B':RAMSGTYPE)          211268
                                                                                211268
      **  Before Image Type                                                     211268
     C     W_PosFin      Ifne      0                                            211268
     C                   Eval      ImageType = 'Amend Before'                   CPB010
     C                   Eval      AssocData = TransData                        CPB010
     C                   Eval      MdHdAssoc = MdnHeadDs                        CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
                                                                                211268
      **  Extract Customer Classification from SDSECSPD message data.           211268
     C                   Z-add     1             X                              211268
     C     'BFCLAS'      Lookup    Arrfld(X)                              89    211268
     C                   Eval      B_BFCLAS = %Subst(TransData:+                211268
     C                             ArrPos(X):ArrLen(X))                         211268
                                                                                211268
     C                   If        (Action <> 'D ')                             211268
      ** DO NOT CONTINUE PROCESS IF BEFORE IMAGE IS PROCESSED                   211268
     C                   Return                                                 211268
     C                   Else                                                   211268
                                                                                CPB010
     C                   If        ImageType <> 'Amend Before'                  CPB010
     C                   Eval      ImageType = 'Insert'                         CPB010
     C                   Eval      AssocData = *Blanks                          CPB010
     C                   Eval      MdHdAssoc = *Blanks                          CPB010
     C                   Else                                                   CPB010
     C                   Eval      ImageType = 'Amend After'                    CPB010
     C                   EndIf                                                  CPB010
     C                                                                          CPB010
     C                   Eval      RAMSGTYPE= 'SDSECSPD_After'                  211268
     C                   Endif                                                  211268
                                                                                211268
     C                   Else                                                   211268
                                                                                211268
      **  After  Image Type                                                     211268
                                                                                211268
      **  Extract Customer Classification from SDSECSPD message data.           211268
     C                   Z-add     1             X                              211268
     C     'BFCLAS'      Lookup    Arrfld(X)                              89    211268
     C                   Eval      A_BFCLAS = %Subst(TransData:+                211268
     C                             ArrPos(X):ArrLen(X))                         211268
                                                                                211268
      **  Extract Customer Classification from SDSECSPD message data.           211268
     C                   Z-add     1             X                              211268
     C     'BFTYLC'      Lookup    Arrfld(X)                              89    211268
     C                   Eval      A_BFTYLC = %Subst(TransData:+                211268
     C                             ArrPos(X):ArrLen(X))                         211268
     C                   EndIf                                                  211268
     C                   If        (A_BFTYLC ='I' or Action=  'D ')             211268
     C                   If        (A_BFCLAS = 'D' or A_BFCLAS = 'S')           211268
     C                   Return                                                 211268
     C                   EndIf                                                  211268
     C                   Else                                                   211268
     C** TakeOn B_BFCLAS = ' '                                                  211268
     C                   If        (B_BFCLAS = 'D' or B_BFCLAS = 'S' or         211268
     C                              B_BFCLAS = ' ' )                  and       211268
     C                             (A_BFCLAS = 'D' or A_BFCLAS = 'S')           211268
     C                   Return                                                 211268
     C                   EndIf                                                  211268
     C                   EndIf                                                  211268
 
      **  Extract customer number from SDSECSPD message data.
     C                   Z-add     1             X
     C     'BFCUST'      Lookup    Arrfld(X)                              89
     C                   Eval      P_Cust = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
     C                   Callb     'AOCUSTR1'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm                    P_Cust
     C                   Parm                    P_Kyst
     C     Sdcust        Parm      Sdcust        Dsldy
 
     C     P_Rtcd        Ifeq      *blanks                                      Begin P_Rtcd
     C     BBCLST        ANDNE     'Y'                                          223644
 
      **----------------- Start of Additionnal fields ---------------**
 
      **  Reformat entire SDCUSTPD record (SDCUSTD0).
      **  The relevant member in file RPMSGFPD contains details of the fields
      **  in the file to be processed (it is a DSPFFD outfile).
      **  This file must already be set up with the field data for the
      **  file to be processed.
     C                   Eval      CompData = *blanks
     C                   Eval      InData   = Sdcust
     C                   Eval      InDBFile = 'SDCUSTPD  '
     C                   Eval      SdcustpdData = ProcFormat(InData:InDBFile:
     C                                        fmDecSep:fmShwPsSgn)
 
      **  The SdcustpdData data structure has two sub-fields:
      **     - SdcustpdRec which now contains the formatted data, left aligned.
      **     - SdcustpdPosA/SdcustpdPosN which now contains the position of
      **     the first unused byte in SdcustpdRec.
 
      **------------------ End of Additionnal fields ----------------**
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 02                                  * Db Error 02 *
     C                   Eval      DBkey  = RAMSGTYPE                           ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = 'Image_Type'
     C**********         Exsr      *Pssr                                        CPB010
                                                                                CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
     C                   Endif                                                  End W_PosFin
 
     C                   Eval      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
     C
      **  Place the result in field CompData.
 
     C                   Eval      CompData = %subst(TransData:1:EndPosition)
     C                                       + %subst(SdcustpdRec:1:+
     C                                                           SdcustpdPosN-1)
 
      **  Call a standard routine to actually send the message.
     C                   CallB     'RPSNDMSG'
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
     C**********         Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   Else                                                   Else ReturnCode
                                                                                CPB010
     C                   Exsr      WrtTrace                                     CPB010
     C                   Commit
 
     C                   Endif                                                  End ReturnCode
     C                   Endif                                                  End P_Rtcd
 
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
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 03                                  * Db Error 03 *
     C                   Eval      DBkey  = 'RPC1305'                           ***************
     C                   Out       LDA
     C**********         Exsr      *Pssr                                        CPB010
                                                                                CPB010
     C                   Eval      MessageInd = 'N'                             CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Eval      MessageInd = 'Y'                             CPB010
 
     C                   Endif                                                  End ReturnCode
 
     C                   Eval      X = X + 1
      **  If any error occurred while retrieving position, handle it.
     C                   If        X > 100
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Array   '                          ***************
     C                   Eval      DBase  = 04                                  * Db Error 04 *
     C                   Eval      DBkey  = 'Index  '                           ***************
     C                   Out       LDA
     C**********         Exsr      *Pssr                                        CPB010
     C                   Exsr      Repair                                       CPB010
     C                   Endif                                                  End ReturnCode
 
     C                   Eval      ArrFld(X) = FieldName
     C                   Eval      ArrPos(X) = FieldPosition
     C                   Eval      ArrLen(X) = FieldLength
 
     C                   Endsr
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
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *Lock         In        Lda                                          CPB010
     C                   Eval      DBpgm  = PSProcName                          CPB010
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 08                                  * Db Error 08 *
     C                   Eval      DBkey  = 'RP1590'                            ***************
     C                   Out       Lda                                          CPB010
                                                                                CPB010
     C                   Endif                                                  End ReturnCode
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
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *Lock         In        Lda                                          CPB010
     C                   Eval      DBpgm  = PSProcName                          CPB010
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 50                                  * Db Error 50 *
     C                   Eval      DBkey  = 'RP1592'                            ***************
     C                   Out       Lda                                          CPB010
                                                                                CPB010
     C                   exsr      *pssr                                        CPB010
     C                   Else                                                   CPB010
     C                   Return                                                 CPB010
     C                   Endif                                                  End ReturnCode
                                                                                CPB010
     C                   Endsr                                                  CPB010
                                                                                CPB010
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
 
     C     *Pssr         Begsr
 
     C     W_RunBefore   Ifeq      *blank                                       Begin W_RunBefore
 
      **  If commitment control required, back out the unit of work so
      **  that current message could be available again.
     C                   If        CommitCtl = 'Y'                              Begin CommiCtl
     C                   Rolbk
 
     C                   Endif                                                  End CommitCtl
 
     C     *Lock         In        Lda
     C     DBpgm         Ifeq      *blanks                                      Begin DBpgm
     C                   Move      PSProcName    DBpgm
     C                   Out       Lda
 
     C                   Endif                                                  End DBpgm
 
     C                   Move      'Y'           W_RunBefore
     C                   Dump
 
     C                   Endif                                                  End W_RunBefore
 
     C     ReturnCode    Ifeq      *blank                                       Begin ReturnCode
     C                   Eval      ReturnCode = '*PSSR'
     C                   Endif                                                  End ReturnCode
 
     C                   Seton                                        U7U8LR
     C                   Return
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        Begsr
 
     C     *Entry        Plist
      ** MQSeries queue to write to - this parameter IS used in this module
     C                   Parm                    OutQueue
      ** Merdian header
     C                   Parm                    MdnHeadDS
      ** Transaction Data
     C                   Parm                    TransData
      ** Commitment control flag
     C                   Parm                    CommitCtl
      ** Return Code
     C                   Parm                    ReturnCode
 
     C                   Eval      MessageInd = 'Y'                             CPB010
 
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
 
      **  Retrieve position and length of customer number from SDSECSPD message data.
     C                   Eval      FieldName   = 'BFCUST'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of classification  from SDSECSPD message 211268
     C                   Eval      FieldName   = 'BFCLAS'                       211268
     C                   Eval      FieldType   = 'A'                            211268
     C                   Exsr      RtvPos                                       211268
                                                                                211268
      **  Retrieve position and length of TYpe of Lst Chg from SDSECSPD message 211268
     C                   Eval      FieldName   = 'BFTYLC'                       211268
     C                   Eval      FieldType   = 'A'                            211268
     C                   Exsr      RtvPos                                       211268
                                                                                211268
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     C                   Endsr
      /Eject
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
