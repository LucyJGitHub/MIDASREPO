     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas RP PB Extraction Module for FCLTYFM.')           *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1503 - Extract module for FCLTYFM                          *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Facility Currency Number of Decimal Places. *
      *                                                               *
      *  Component of: RP1503 - Extract program for FCLTYFM           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. AR858264A          Date 16Jul12               *
      *                 AR970292           Date 14May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 223644             Date 16Jan03               *
      *                 CPB010             Date 16Jan03               *
      *                 205682             Date 10May02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002   *CREATE   Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR858264A - Compilation Issues on various RP programs        *
      *  AR970292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Complete CSD027 to process correctly cust. number *
      *             (Child:AR970293)                                  *
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
      *  205682 - Review sending of loans,loan amendments,facilities  *
      *           with feature CLE002 - Lending Authorisation         *
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
      *  Repair   - Repair process                                    *                       CPB010
      *  WrtTrace - Trace process                                     *                       CPB010
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
     C**********/COPY RPCPYSRC,Std_Dcl                                                     AR858264A
     C/COPY RPCPYSRC,STD_DCL                                                               AR858264A
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C**********/COPY RPCPYSRC,Mdn_Hd_DS                                                   AR858264A
     C/COPY RPCPYSRC,MDN_HD_DS                                                             AR858264A
 
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
                                                                                              205682
     D SDCLND        E DS                  Extname(SDCLNDPD)                                  205682
      ** DS for Customer Lending Details                                                      205682
 
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
      **---------------- start of Parameters for CPB010 --------------**                      CPB010
     D MessageInd      S              1A                                                      CPB010
                                                                                              CPB010
     D RAMSGOLD        S                   LIKE(RAMSGTYPE)                                    CPB010
                                                                                              CPB010
      **   Database Error Messsage Text                                                       CPB010
     D DBErrText       S            256A                                                      CPB010
                                                                                              CPB010
      **   Transaction Data of associated transaction                                         CPB010
     D AssocData       S                   LIKE(TransData)                                    CPB010
                                                                                              CPB010
      **   Meridian header Layout of associated transaction                                   CPB010
     D MdHdAssoc       S                   LIKE(MdnHeadDs)                                    CPB010
      **----------------  End of Parameters for CPB010  --------------**                      CPB010
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer.
     D P_Cust          S             10A
      **  Key status.
     D P_Kyst          S              7A
      **  Switchable feature number.                                                          205682
     D P_Sard          S              6A                                                      205682
      ** ---------- End of fields used by access programs -----------**
 
      **  Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
                                                                                              205682
      **  Work Fields used for Lending.                                                       205682
     D CLE002          S              1A                                                      205682
     D CLE105          S              1A                                                      205682
     D W_Send          S              1A                                                      205682
     D W_Status        S              1A                                                      205682
     D W_User          S             10A                                                      205682
     D W_Record        S              1A                                                      205682
 
      **----------------  Start of additional fields ----------------**
     D W_FcltyCcyNbdp  S              1A
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
                                                                                              CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   Eval      RAMSGOLD = RAMSGTYPE                                       CPB010
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **  Extract custoner number from FCLTYFM message data.
     C                   Z-add     1             X
     C     'CNUM  '      Lookup    Arrfld(X)                              89
     C**********         Eval      P_Cust = %Subst(TransData:+                              AR970292
     C**********                   ArrPos(X)+W_PosDebut:ArrLen(X))                          AR970292
     C                   EVAL      P_Cust = %Subst(TransData:+                              AR970292
     C                             ArrPos(X):ArrLen(X))                                     AR970292
 
      **  Access Customer Details by using Access Object,
      **  to retrieve Private Banking Customer Indicator.
     C                   Callb     'AOCUSTR1'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm                    P_Cust
     C                   Parm                    P_Kyst
     C     Sdcust        Parm      Sdcust        Dsldy
 
      **  If Customer Details do not exist, handle Database Error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     BBCLST        ANDNE     'Y'                                                        223644
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDCUSTPD'                          ***************
     C                   Eval      DBase  = 01                                  * Db Error 01 *
     C                   Eval      DBkey  = P_Cust                              ***************
     C                   Out       Lda
     C                   Eval       ReturnCode =  P_Rtcd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End P_Rtcd
 
      **  If Customer is not a Private Banking customer, check
      **  Requested PB Customer flag in case it would have been
      **  set to 'Y'.
     C                   If        BBPRBA      <> 'Y'                           Begin BBPRBA
 
      **  Define key list to access to Customer PB Details file.
     C     K_SDPbds      Klist
     C                   Kfld                    K_CustNum
     C                   Move      BBCUST        K_CustNum
 
      **  Access to Customer PB Details file.
     C     K_CustNum     Chain     SDPBDSL0                           81
 
      **  If Customer PB Details do not exist, handle database error.
     C     *in81         Ifeq      True                                         Begin *in81
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDPBDSL0'                          ***************
     C                   Eval      Dbase  = 02                                  * Db Error 02 *
     C                   Eval      Dbkey  = BBCUST                              ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = W_NoRcdFnd
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End  *in81
 
     C                   Endif                                                  End  BBPRBA
 
      **  Only send the message if Customer is a Private
      **  Banking Customer or flagged as requested to become
      **  a Private Banking Customer.
     C                   If            BBPRBA = 'Y'                             Begin BBPRBA
     C                             Or  PBREPB = 'Y'
                                                                                              205682
     C                   Eval      W_Send = 'Y'                                               205682
                                                                                              205682
      **  If features CLE105 - New Maint. Funct - Enhanced Lending Input                      205682
      **              CLE002 - Authorizations                                                 205682
      **  And ICD Field from PF/SDCLNDPD 'Facilities to be authorized' is 'Y'                 205682
     C                   If            CLE105 = 'Y'                                           205682
     C                             And CLE002 = 'Y'                                           205682
     C                             And BPFAAU = 'Y'                                           205682
                                                                                              205682
      **  Extract Loan Status Indicator.                                                      205682
     C                   Z-add     1             X                                            205682
     C     'FSTS  '      Lookup    Arrfld(X)                              89                  205682
     C                   Eval      W_Status = %Subst(TransData:+                              205682
     C                             ArrPos(X):ArrLen(X))                                       205682
                                                                                              205682
      **  If loan status indicator is not 'A', do not send the message !                      205682
     C                   If            W_Status <> 'A'                                        205682
     C                   Eval      W_send = 'N'                                               205682
     C                   Else                                                                 205682
                                                                                              205682
      **  Extract Record Id.                                                                  205682
     C                   Z-add     1             X                                            205682
     C     'RECI  '      Lookup    Arrfld(X)                              89                  205682
     C                   Eval      W_Record = %Subst(TransData:+                              205682
     C                             ArrPos(X):ArrLen(X))                                       205682
                                                                                              205682
      **  If it's a reverse, ensure loan was previously authorised (XUSR <> '')               205682
     C                   If            W_Record = 'R'                                         205682
                                                                                              205682
      **  Extract Authorise User.                                                             205682
     C                   Z-add     1             X                                            205682
     C     'XUSR  '      Lookup    Arrfld(X)                              89                  205682
     C                   Eval      W_User = %Subst(TransData:+                                205682
     C                             ArrPos(X):ArrLen(X))                                       205682
                                                                                              205682
      **  Loan not previously authorised, do not send the message !                           205682
     C                   If            W_User = *blanks                                       205682
     C                   Eval      W_send = 'N'                                               205682
     C                   Endif                                                                205682
                                                                                              205682
     C                   Endif                                                                205682
     C                   Endif                                                                205682
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
     C                   If            W_Send = 'Y'                                           205682
 
      **----------------- Start of Additionnal fields ---------------**
 
      **----------------- Start of Facility Currency ----------------**
      **                   Number of Decimal Places                  **
 
      **  Extract Currency Code.
     C                   Z-add     1             X
     C     'FCCY  '      Lookup    Arrfld(X)                              89
     C                   Eval      P_Curr = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Retrieve currency number of decimal places.
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_FcltyCcyNbdp
 
      **--------- End of Currency Number of Decimal Places ----------**
 
      **------------------ End of Additionnal fields ----------------**
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'MSG Type'                          ***************
     C                   Eval      DBase  = 03                                  * Db Error 03 *
     C                   Eval      DBkey  = RAMSGTYPE                           ***************
     C                   Out       Lda
     C                   Eval      ReturnCode = 'Image_Type'
     C**********         Exsr      *Pssr                                                      CPB010
                                                                                              CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
     C                   Endif                                                  End W_PosFin
 
     C                   Eval      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)
 
      **  Place the result in field CompData.
 
     C                   Eval      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_FcltyCcyNbdp                   Number Dec. Places
 
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
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
      **  If no error, commit the unit of work so that messages that have
      **  been got from a queue would be permanently deleted and put
      **  operations would be made permanent.
     C                   Else                                                   Else ReturnCode
                                                                                              CPB010
     C                   Exsr      WrtTrace                                                   CPB010
     C                   Commit
 
     C                   Endif                                                  End ReturnCode
                                                                                              205682
     C                   Endif                                                                205682
 
     C                   Endif                                                  End BBPRBA
 
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
     C**********         Exsr      *Pssr                                                      CPB010
                                                                                              CPB010
     C                   Eval      MessageInd = 'N'                                           CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Eval      MessageInd = 'Y'                                           CPB010
 
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
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
     C                   Endif                                                  End ReturnCode
 
     C                   Eval      ArrFld(X) = FieldName
     C                   Eval      ArrPos(X) = FieldPosition
     C                   Eval      ArrLen(X) = FieldLength
 
     C                   Endsr
      /Eject                                                                                  CPB010
      *****************************************************************                       CPB010
      *                                                               *                       CPB010
      *  WrtTrace - Write a Trace of outgoing messages.               *                       CPB010
      *                                                               *                       CPB010
      *  Called by : Main processing.                                 *                       CPB010
      *                                                               *                       CPB010
      *  Calls     : None.                                            *                       CPB010
      *                                                               *                       CPB010
      *****************************************************************                       CPB010
                                                                                              CPB010
     C     WrtTrace      Begsr                                                                CPB010
                                                                                              CPB010
     C                   Callb     'RP1590'                                                   CPB010
     C                   Parm                    OutQueue                                     CPB010
     C                   Parm                    MdnHeadDS                                    CPB010
     C                   Parm                    CompData                                     CPB010
     C                   Parm                    CommitCtl                                    CPB010
     C                   Parm                    ReturnCode                                   CPB010
                                                                                              CPB010
      **  If any error occurred while retrieving position, handle it.                         CPB010
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCoCPB010
     C     *Lock         In        Lda                                                        CPB010
     C                   Eval      DBpgm  = PSProcName                                        CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 08                                  * Db Error 08 CPB010
     C                   Eval      DBkey  = 'RP1590'                            **************CPB010
     C                   Out       Lda                                                        CPB010
                                                                                              CPB010
     C                   Endif                                                  End ReturnCodeCPB010
     C                   Endsr                                                                CPB010
                                                                                              CPB010
      /Eject                                                                                  CPB010
      *****************************************************************                       CPB010
      *                                                               *                       CPB010
      *  Repair   - Write a Trace of outgoing messages to repair      *                       CPB010
      *                                                               *                       CPB010
      *  Called by : Main processing.                                 *                       CPB010
      *                                                               *                       CPB010
      *  Calls     : None.                                            *                       CPB010
      *                                                               *                       CPB010
      *****************************************************************                       CPB010
                                                                                              CPB010
     C     Repair        Begsr                                                                CPB010
                                                                                              CPB010
     C                   Move      Dbase         dbasea            3                          CPB010
                                                                                              CPB010
     C                   Eval      DBErrText = 'DBError' +                                    CPB010
     C                             ' in : ' + DBpgm +                                         CPB010
     C                             ' at: ' + DBasea +                                         CPB010
     C                             ' file : ' + DBfile +                                      CPB010
     C                             ' Key : ' + DBKey +                                        CPB010
     C                             ' Return :' + ReturnCode                                   CPB010
                                                                                              CPB010
     C                   Eval      RAMSGTYPE = RAMSGOLD                                       CPB010
                                                                                              CPB010
     C                   Callb     'RP1592'                                                   CPB010
     C                   Parm                    OutQueue                                     CPB010
     C                   Parm                    MdnHeadDS                                    CPB010
     C                   Parm                    TransData                                    CPB010
     C                   Parm                    MdHdAssoc                                    CPB010
     C                   Parm                    AssocData                                    CPB010
     C                   Parm                    CommitCtl                                    CPB010
     C                   Parm                    DBErrText                                    CPB010
     C                   Parm                    MessageInd                                   CPB010
     C                   Parm      *Blanks       ReturnCode                                   CPB010
                                                                                              CPB010
      **  If any error occurred while retrieving position, handle it.                         CPB010
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCoCPB010
     C     *Lock         In        Lda                                                        CPB010
     C                   Eval      DBpgm  = PSProcName                                        CPB010
     C                   Eval      DBfile = 'Call    '                          **************CPB010
     C                   Eval      DBase  = 50                                  * Db Error 50 CPB010
     C                   Eval      DBkey  = 'RP1592'                            **************CPB010
     C                   Out       Lda                                                        CPB010
                                                                                              CPB010
     C                   exsr      *pssr                                                      CPB010
     C                   Else                                                                 CPB010
     C                   Return                                                               CPB010
     C                   Endif                                                  End ReturnCodeCPB010
                                                                                              CPB010
     C                   Endsr                                                                CPB010
                                                                                              CPB010
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
 
     C     GetDecPl      Begsr
 
      **  Access to Currency Details, by using access object.
     C                   Callb     'AOCURRR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    P_Curr            3            I:Key field
     C     Sdcurr        Parm      Sdcurr        Dssdy                          O:Format
 
      **  If currency does not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCURRPD'                          ***************
     C                   Eval      Dbase  = 06                                  * Db Error 06 *
     C                   Eval      Dbkey  = P_Curr                              ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = P_RTCD
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
 
     C                   Endif                                                  End  P_Rtcd
 
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
     C                   Eval      MessageInd = 'Y'                                           CPB010
                                                                                              205682
      **  Check if CLE105 (Lending) is installed.                                             205682
     C                   Eval      CLE105 = 'N'                                               205682
     C                   Callb     'AOSARDR0'                                                 205682
     C                   Parm      *blanks       P_Rtcd                                       205682
     C                   Parm      '*VERIFY'     P_Optn                                       205682
     C                   Parm      'CLE105'      P_Sard                                       205682
     C     Scsard        Parm      Scsard        Dsfdy                                        205682
                                                                                              205682
      **  If any error occurred when checking feature.                                        205682
     C     P_Rtcd        Ifne      *blanks                                                    205682
     C     P_Rtcd        andne     '*NRF   '                                                  205682
     C     *lock         in        Lda                                                        205682
     C                   Eval      DBpgm  = PSProcName                                        205682
     C                   Eval      DBfile = 'SCSARDPD'                                        205682
     C                   Eval      DBase  = 07                                                205682
     C                   Eval      DBkey  = P_Sard                                            205682
     C                   Out       Lda                                                        205682
     C                   Eval      ReturnCode = 'Error'                                       205682
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
      **  If feature is installed.                                                            205682
     C     P_Rtcd        Ifeq      *blanks                                                    205682
     C                   Eval      CLE105 = 'Y'                                               205682
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
      **  Check if CLE002 (Lending) is installed.                                             205682
     C                   Eval      CLE002 = 'N'                                               205682
     C                   Callb     'AOSARDR0'                                                 205682
     C                   Parm      *blanks       P_Rtcd                                       205682
     C                   Parm      '*VERIFY'     P_Optn                                       205682
     C                   Parm      'CLE002'      P_Sard                                       205682
     C     Scsard        Parm      Scsard        Dsfdy                                        205682
                                                                                              205682
      **  If any error occurred when checking feature.                                        205682
     C     P_Rtcd        Ifne      *blanks                                                    205682
     C     P_Rtcd        andne     '*NRF   '                                                  205682
     C     *lock         in        Lda                                                        205682
     C                   Eval      DBpgm  = PSProcName                                        205682
     C                   Eval      DBfile = 'SCSARDPD'                                        205682
     C                   Eval      DBase  = 08                                                205682
     C                   Eval      DBkey  = P_Sard                                            205682
     C                   Out       Lda                                                        205682
     C                   Eval      ReturnCode = 'Error'                                       205682
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
      **  If feature is installed.                                                            205682
     C     P_Rtcd        Ifeq      *blanks                                                    205682
     C                   Eval      CLE002 = 'Y'                                               205682
                                                                                              205682
     C                   Endif                                                                205682
                                                                                              205682
      **  Access Customer Lending Data                                                        205682
     C                   If            CLE002 = 'Y'                                           205682
                                                                                              205682
     C                   Call      'AOCLNDR0'                                                 205682
     C                   Parm      *blanks       P_Rtcd                                       205682
     C                   Parm      '*VERIFY'     P_Optn                                       205682
     C*****SDCLND        Parm      SDCLND        Dsfdy                                 205682 CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
                                                                                              205682
      **  If any error occurred when checking feature.                                        205682
     C     P_Rtcd        Ifne      *blanks                                                    205682
     C     *lock         in        Lda                                                        205682
     C                   Eval      DBpgm  = PSProcName                                        205682
     C                   Eval      DBfile = 'SDCLNDPD'                                        205682
     C                   Eval      DBase  = 09                                                205682
     C                   Eval      DBkey  = '*First'                                          205682
     C                   Out       Lda                                                        205682
     C                   Eval      ReturnCode = 'Error'                                       205682
     C**********         Exsr      *Pssr                                                      CPB010
     C                   Exsr      Repair                                                     CPB010
                                                                                              205682
     C                   Endif                                                                205682
     C                   Endif                                                                205682
 
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
 
      **  Retrieve position and length of customer number from FCLTYFM message data.
     C                   Eval      FieldName   = 'CNUM'
     C**********         Eval      FieldType   = 'N'                                        AR970292
     C                   EVAL      FieldType   = 'A'                                        AR970292
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Facility currency from FCLTYFM message data.
     C                   Eval      FieldName   = 'FCCY'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
                                                                                              205682
      **  Retrieve position and length of Loan Status Indicator from FCLTYFM                  205682
     C                   Eval      FieldName   = 'FSTS'                                       205682
     C                   Eval      FieldType   = 'A'                                          205682
     C                   Exsr      RtvPos                                                     205682
                                                                                              205682
      **  Retrieve position and length of Authorise user profile from FCLTYFM                 205682
     C                   Eval      FieldName   = 'XUSR'                                       205682
     C                   Eval      FieldType   = 'A'                                          205682
     C                   Exsr      RtvPos                                                     205682
                                                                                              205682
      **  Retrieve position and length of Record Id from FCLTYFM                              205682
     C                   Eval      FieldName   = 'RECI'                                       205682
     C                   Eval      FieldType   = 'A'                                          205682
     C                   Exsr      RtvPos                                                     205682
 
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     C                   Endsr
      /Eject
      *****************************************************************
**  Cpy@
(c) Misys International Banking Systems Ltd. 2001
