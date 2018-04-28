     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas Extraction Module for SDCUSTPD UTROPX')          *
      *****************************************************************
      *                                                               *
      *  Midas - Replication Module                                   *
      *                                                               *
      *  RP5505 - Extract module for SDCUSTPD                         *
      *                                                               *
      *  Function:    Extended Selection: None                        *
      *               List of additional fields:                      *
      *                 - SDCTRYPD.A4ISOC: Country ISO Code           *
      *                                                               *
      *  Component of: RP5505 - Extract program for SDCUSTPD          *
      *                                                               *
      *  (C) COPYRIGHT Misys International Banking Systems sa. 2001   *
      *                                                               *
/*    *  Last Amend No. AR1057854          Date 19Nov12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD026             Date 05Apr05               *
      *                 UTROPX  *CREATE    Date 12Dec01               *
      *                                                               *
      *---------------------------------------------------------------*
/*    *  AR1057854 - Geneva Drop 01 Build Issues - RPG Program        *
/*    *              Compilation Error                                *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE026 - Consumer Banking                                    *
      *  CSD026 - MIDAS-TROPICS INTERFACE UPGRADE TO MIDASPLUS        *
      *         - remove LBWLON1                                      *
      *  LBWLON1- For London Only - Prepare HOCLNAME based on LBBW    *
      *           HOCLNXP content (Switch in Repository)              *
      *  UTROPX - Midas TrOpics Interface                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
                                                                                             LBWLON1
      **  Midas Host Customer details                                                        LBWLON1
     F******P   IF   E           K Disk                                               LBWLON1 CSD026
     F******                               Infsr(*Pssr)                               LBWLON1 CSD026
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
     C*COPY*RPCPYSRC,Std_Dcl                                                               AR1057854
     C/COPY RPCPYSRC,STD_DCL                                                               AR1057854
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C*COPY*RPCPYSRC,Mdn_Hd_DS                                                             AR1057854
     C/COPY RPCPYSRC,MDN_HD_DS                                                             AR1057854
 
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
 
      ** Data Structure for access to Country  Details.
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
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
     D  W_BBCNCZ                      2A
     D  W_BBCOLC                      2A
     D  HOCLNAME                     40A                                                     LBWLON1
 
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
 
      **  Enter the processing to read the additional files and produce a
      **  composite message here.
 
      **----------------- Start of Extended Selection ---------------**
 
 
      **  Extract Country code from SDCUSTPD message data.
     C                   Z-add     1             X
     C     'BBCNCZ'      Lookup    Arrfld(X)                              89
     C                   Eval      W_Ctry = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Retrieve country details if field not blank.
     C     W_Ctry        Ifne      *blank                                       Begin Extended Filt1
     C                   Exsr      GetCtry
 
      **----------------- Start of Additionnal fields ---------------**
 
     C                   MOVE      A4ISOC        W_BBCNCZ
 
      **------------------ End of Additionnal fields ----------------**
     C                   Endif                                                  End Extended Filt 1
      **----------------- Start of Extended Selection ---------------**
 
      **  Extract Country code from SDCUSTPD message data.
     C                   Z-add     1             X
     C     'BBCOLC'      Lookup    Arrfld(X)                              89
     C                   Eval      W_Ctry = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
      **  Retrieve country details if field not blank
     C     W_Ctry        Ifne      *blank                                       Begin Extended Filt2
     C                   Exsr      GetCtry
 
      **----------------- Start of Additionnal fields ---------------**
 
     C                   MOVE      A4ISOC        W_BBCOLC
      *                                                                                      LBWLON1
      *** LBWLON1 : Add Extended Details of Customer to format Long Name                     LBWLON1
      *** Extract Customer Number from SDCUSTPD Message Data                                 LBWLON1
      *                                                                                      LBWLON1
     C                   MOVEL     *BLANKS       HOCLNAME         40                  LBWLON1 CSD026
     C*****              MOVEL     *BLANKS       HOCLNAME                             LBWLON1 CSD026
     C*****              MOVEL     *ALL'-'       HOCLNAME                               TEST  CSD026
     C*****              Z-add     1             X                                    LBWLON1 CSD026
     C*****'BBCUST'      Lookup    Arrfld(X)                              89          LBWLON1 CSD026
     C*****              MOVEL     *BLANKS       WKCUST            6                  LBWLON1 CSD026
     C*****              Eval      WKCUST = %Subst(TransData:+                        LBWLON1 CSD026
     C*****                        ArrPos(X):ArrLen(X))                               LBWLON1 CSD026
     C*****              MOVE      WKCUST        KeyCUST           6 0                LBWLON1 CSD026
     C*****KeyCUST       CHAIN     HOCLNXP                            99              LBWLON1 CSD026
     C*****              if        %Found                                      Found  LBWLON1 CSD026
     C****               MOVEL(P)  CLNCNM        WK31A            31                         LBWLON1
     C****               MOVEL(P)  CLNCRT        WK08A             8                         LBWLON1
     C****               MOVEL     WK31A         HOCLNAME                                    LBWLON1
     C****               MOVE      WK08A         HOCLNAME                                    LBWLON1
     C****               MOVE      'FOUND'       HOCLNAME                                       TEST
     C*****              Endif                                                        LBWLON1 CSD026
      **------------------ End of Additionnal fields ----------------**
 
      **  Change message Type from _After to _A
      **  Determine Image Type.
     C*********          Eval      W_PosFin    = %Scan('_After':RAMSGTYPE)                    CSD026
 
      **  If it is impossible to determine the image type, handle error.
     C**** W_PosFin      Ifeq      0                                         Begin W_PosFin   CSD026
     C**** *Lock         In        Lda                                                        CSD026
     C*****              Eval      DBpgm  = PSProcName                                        CSD026
     C*****              Eval      DBfile = 'MSG Type'                       ***************  CSD026
     C*****              Eval      DBase  = 03                               * Db Error 03 *  CSD026
     C*****              Eval      DBkey  = RAMSGTYPE                        ***************  CSD026
     C*****              Out       Lda                                                        CSD026
     C*****              Eval      ReturnCode = 'Image_Type'                                  CSD026
     C*****              Exsr      *Pssr                                                      CSD026
     C*****              Endif                                                  End W_PosFin  CSD026
 
     C*****              Eval      RAMSGTYPE =                                                CSD026
     C*****                        %Subst(RAMSGTYPE:1:W_PosFin + 1)                           CSD026
 
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
 
     C                   Endif                                                  End Extended Filt 2
 
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
 
      **  Retrieve position and length of Country codes from SDCUSTPD message data.
     C                   Eval      FieldName   = 'BBCNCZ'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Country codes from SDCUSTPD message data.
     C                   Eval      FieldName   = 'BBCOLC'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Customer number from SDCUSTPD message data.        LBLLON1
     C****               Eval      FieldName   = 'BBCUST'                             LBWLON1 CSD026
     C****               Eval      FieldType   = 'A'                                  LBWLON1 CSD026
     C****               Exsr      RtvPos                                             LBWLON1 CSD026
                                                                                      LBWLON1 CSD026
      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  GetCtry  - get Country ISO code                              *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
 
     C     GetCtry       Begsr
 
      **  Access to Currency Details, by using access object.
     C                   Call      'AOCTRYR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    W_Ctry            2            I:Key field
     C     Sdctry        Parm      Sdctry        Dssdy                          O:Format
 
      **  If currency does not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCTRYPD'                          ***************
     C                   Eval      Dbase  = 06                                  * Db Error 06 *
     C                   Eval      Dbkey  = W_Ctry                              ***************
     C                   Out       LDA
     C                   Eval      ReturnCode  = P_RTCD
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   Endsr
      /Eject
      *****************************************************************
**  Cpy@
(C) Copyright Misys International Banking Systems sa. 2001
