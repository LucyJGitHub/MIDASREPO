     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Retrieve position in Meridian message.')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1305 - Retrieve position in Meridian message.              *
      *                                                               *
      *  Function: this module allows to retrieve the position of a   *
      *            field or the begin position of additionnal fields  *
      *            in Meridian message.                               *
      *                                                               *
      *  Component of: RP1305 - Retrieve position in Meridian message *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 249010             Date 09Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  249010 - To properly handle decimal field.                   *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Source file that contains all scripts.
     FMDBASCRIPTIF   E             Disk    Rename(MDBASCRIPT:SCRIPT)
     F                                     Infds(ScriptDS)
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  77  -  Resultant indicator on LOOKUP operation.              *
      *                                                               *
      *  81  -  End of file MDBASCRIPT                                *
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
      *       * 71   72   73   74   75   76   xx   78   79   80 *     *
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
      *  #Sndms - Subroutine to send message to Program Message Queue.*
      *  *Pssr  - Program exception error routine.                    *
      *  *inzsr - Program Initialization routine.                     *
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
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **  The following /COPY contains various standard declares
     D/COPY RPCPYSRC,Std_Dcl
 
      **  The following /COPY contains the layout of the Meridian header as
      **  a data structure
     D/COPY RPCPYSRC,Mdn_Hd_DS
 
      **  Following /COPY is the declares for fields passed to the formatting
      **  routines
     D/COPY RPCPYSRC,RPFMTDCL
 
      **  Following /COPY is the procedure prototype for the Packed routine
     D/COPY RPCPYSRC,RPFMTPPP
 
      **  Following /COPY is the procedure prototype for the Signed routine
     D/COPY RPCPYSRC,RPFMTPPS
 
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
 
      ** Array containing Copyright statement
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  External Data structure for Local data area for database error details.
     D LDA           E DS           256    EXTNAME(LDA)
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      **  Replication defaults data area.
     D RPDFTSDA      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
 
      **  File Information Data Structure for file MDBASCRIPT.
     D ScriptDS        DS           500
     D   File                 83     92
     D   Library              93    102
     D   ScriptRrn           397    400I 0
 
      **  Alternate tables used to retrieve image type.
     D TabImageCode    S              1    Dim(2) Ctdata Perrcd(2)
     D TabImageType    S             10    Dim(2) Alt(TabImageCode)
 
      **  Arrays used to store image first record relative number.
     D ArrImage        S             32    Dim(100)
     D ArrFirst        S              6  0 Dim(100)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of Parameters --------------------**
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
     D FieldPosition   S              7A
      **  Field Length
     D FieldLength     S              4A
      **--------------------- End of Parameters ---------------------**
 
     D W_ImageCode     S              1A
 
     D W_ImageType     S             10A
 
     D W_File          S             10A
 
     D                 DS
     D  W_FirstRecord                 6S 0
     D  W_FirstRecAlp                 6    Overlay(W_FirstRecord)
 
     D W_ImageFound    S              1A
 
     D W_FieldFound    S              1A
 
     D Position        S              7S 0
 
     D Length          S              4S 0
 
     D W_PosDebut      S              3S 0
 
     D W_PosFin        S              3S 0
 
     D W_StringToScan  S            100A
 
     D W_StringLength  S              2S 0
 
     D W_CharLength    S              4A
 
     D W_NumLength     S              4S 0
 
     D W_FieldType     S              1A
 
     D W_String        S           9999A
 
     D W_SeparatorPos  S              2S 0
 
     D W_0dpFieldLen   S              1A
 
     D W_RunBefore     S              1A
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
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
 
      **  Determine Image Type.
     C                   Eval      W_PosFin    = %Scan('_':ImageName)
 
      **  If it is impossible to determine the image type, handle error.
     C     W_PosFin      Ifeq      0                                            Begin W_PosFin
     C                   Eval      ReturnCode = 'Image_Type'
     C                   Eval      P@MsgId    = 'RP00020'
     C                   Eval      P@MsgDta   = ImageName
     C                   Exsr      #Sndms
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End W_PosFin
 
     C                   Eval      W_ImageCode =
     C                             %Subst(ImageName:W_PosFin + 1:1)
 
     C     W_ImageCode   Lookup    TabImageCode  TabImageType             77
 
      **  If image code not found, handle error.
     C     *in77         Ifeq      False                                        Begin *in77
     C                   Eval      ReturnCode = 'Image_Code'
     C                   Eval      P@MsgId    = 'RP00021'
     C                   Eval      P@MsgDta   = W_ImageCode
     C                   Exsr      #Sndms
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End *in77
     C                   Eval      W_ImageType =  TabImageType
     C                   Eval      W_File      =  %Subst(ImageName:1:+
     C                                             (%Scan('_':ImageName) - 1))
 
      **  Initialize flag used to indicate image was found and
      **  is being processed.
     C                   Eval      W_ImageFound =  'N'
 
      **  Initialize flag used to indicate field was found.
     C                   Eval      W_FieldFound = 'N'
 
      **  Initialize work field  used to position to first record
      **  of image or script.
     C                   Eval      W_FirstRecord = 1
 
      **  Check if image was already processed.
     C                   Z-add     1             X                 3 0
     C     ImageName     Lookup    ArrImage(X)                            77
 
      **  If image was already processed, set up work field
      **  used to position to first record of image.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Eval      W_FirstRecord = ArrFirst(X)
 
      **  If image was not already processed, add image name
      **  in next available array entry.²
     C                   Else
     C                   Add       1             L                 3 0
     C                   Eval      X = L
     C                   Eval      ArrImage(X) = ImageName
 
     C                   Endif                                                  End *in77
 
      **  Position to first record of script, or first record
      **  of image if it was found.
     C     W_FirstRecord Chain     SCRIPT                             81
 
      **  If first record was not found, handle error.
     C     *in81         Ifeq      True                                         Begin *in81
     C                   Eval      ReturnCode = 'Script_Pos'
     C                   Eval      P@MsgId    = 'RP00022'
     C                   Eval      P@MsgDta   = W_FirstRecAlp + ScriptName
     C                   Exsr      #Sndms
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End *in81
     C                   Eval      *in81 = False
 
      **  While records to be processed.
     C     *in81         Doweq     False                                        Begin Do_W_81
 
      **  If image not already found.
     C     W_ImageFound  Ifeq      'N'                                          Begin W_ImageFound
 
      **  Scan for Image Name.
     C                   Eval      W_StringToScan = '<' + %Trimr(W_ImageType)
     C                                              + '>' + %Triml(ImageName)
     C                   Eval      W_PosDebut
     C                             = %Scan(%Trim(W_StringToScan):SRCDTA)
 
      **  If image not found, read next record from script.
     C                   If        W_PosDebut = 0                               Begin W_PosDebut
     C                   Goto      ReadNext
 
     C                   Endif                                                  End W_PosDebut
 
     C                   Eval      W_ImageFound = 'Y'
     C                   Eval      ArrFirst(X)  = ScriptRrn
     C                   Eval      Position     = 1
     C                   Goto      ReadNext
 
     C                   Endif                                                  End W_ImageFound
 
      **  Default Field Type to 'A'
     C                   Eval      W_FieldType = 'A'
 
      **  Retrieve length of field in character format.
     C                   Eval      W_StringToScan = '<LENGTH>'
     C                   Eval      W_PosDebut     =
     C                                     %Scan(%Trimr(W_StringToScan):SRCDTA)
 
      **  If not a field line.
     C                   If        W_PosDebut = 0                               Begin W_PosDebut
 
      **  Retrieve Type of field in character format.
     C                   Eval      W_StringToScan = '<TYPE>'
     C                   Eval      W_PosDebut     =
     C                                     %Scan(%Trimr(W_StringToScan):SRCDTA)
 
      **  If not a field line.
     C                   If        W_PosDebut <> 0                              Begin W_PosDebut
 
     C                   Eval      W_PosDebut     = W_PosDebut
     C                                            + %Len(%Trimr(W_StringToScan))
 
     C                   Eval      W_FieldType    = %subst(SRCDTA:W_PosDebut:1)
     C                   Else
 
      **  Check if end of image.
     C                   Eval      W_StringToScan = '</' + %Trimr(W_ImageType)
     C                                                   + '>'
     C                   Eval      W_PosFin =
     C                                     %Scan(%Trimr(W_StringToScan):SRCDTA)
     C                   If        W_PosFin   = 0                               Begin W_PosFin
     C                   Eval      ReturnCode = 'Filter_Def'
     C                   Eval      P@MsgId    = 'RP00026'
     C                   Eval      P@MsgDta   = W_File
     C                   Exsr      #Sndms
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End W_PosFin
     C                   Leave
 
     C                   Endif                                                  End W_PosDebut
     C                   Endif                                                  End W_PosDebut
 
     C                   Select                                                 Begin W_FieldType
 
      **  Field type equal to 'D': Timestamp for example
      **  Filed Lenght should be 26.
     C                   When      W_FieldType = 'D'
     C                   Z-add     26            W_NumLength
 
     C                   Other
     C                   Eval      W_PosDebut     = W_PosDebut
     C                                            + %Len(%Trimr(W_StringToScan))
     C                   Eval      W_StringToScan = '</FIELD>'
     C                   Eval      W_PosFin       =
     C                             %Scan(%Trimr(W_StringToScan):SRCDTA:+
     C                             W_PosDebut)
 
     C                   Eval      W_StringLength = W_PosFin - W_PosDebut
     C                   Eval      W_CharLength   =
     C                             %Trimr(%subst(SRCDTA:W_PosDebut:+
     C                             W_StringLength))
 
      **  Calculate position where to put character length so that
      **  it would be right-aligned.
     C                   Eval      W_PosFin       = %Len(W_CharLength)
     C                                            - %Len(%Trimr(W_CharLength))+
     C                                            + 1
 
      **  Rigth align character length before moving result in numeric field.
     C                   Eval      W_CharLength = *Blank
     C                   Eval      %Subst(W_CharLength:W_PosFin) =
     C                             %Trimr(%Subst(SRCDTA:W_PosDebut:+
     C                             W_StringLength))
     C                   Move      W_CharLength  W_NumLength
     C                   Endsl                                                  End W_FieldType
 
      **  Scan for field.
     C                   Eval      W_StringToScan = '<FIELD>' +
     C                                              %Triml(FieldName)
     C                   Eval      W_StringLength = %Len(%Trimr(W_StringToScan))
     C                   Eval      W_PosDebut
     C                                 = %Scan(%Trimr(W_StringToScan):SRCDTA)
 
      **  If field name was not found, just add length of current field.
     C                   If        W_PosDebut = 0                               Begin W_PosDebut
     C                   Eval      Position   = Position + W_NumLength
     C                   Goto      ReadNext
 
     C                   Endif                                                  End W_PosDebut
 
     C                   Eval      W_FieldFound = 'Y'
 
      **  Retrieve value of field.
     C                   Eval      W_String =
     C                                    %Subst(TransData:Position:W_NumLength)
 
     C                   Select                                                 Begin Select
 
      **  If field is numeric (Packed or zoned decimal), remove
      **  possible sign and decimal separator.
     C     FieldType     Wheneq    'N'                                          Zoned/Packed Decimal
     C                   Eval      W_SeparatorPos =  %SCAN(RCDECSEP:W_String)
     C                   Eval      W_StringLength = %Len(%Trimr(W_String))
 
     C                   Eval      W_PosDebut     =  0                                        249010
     C                   Move      W_0dpFieldLen W_PosDebut                                   249010
                                                                                              249010
     C                   If        W_SeparatorPos = 0                           Begin W_SeparatorPos
     C**********         Eval      W_0dpFieldLen  = %Subst(RCZEROFLD:2:1)                     249010
     C**********         Eval      W_PosDebut     =  0                                        249010
     C**********         Move      W_0dpFieldLen W_PosDebut                                   249010
     C                   Eval      W_StringLength = W_StringLength
     C                                            - W_PosDebut
     C                   Eval      FieldValue = %Subst(W_String:+
     C                                          (W_PosDebut + 1):W_StringLength)
 
     C                   Else                                                   Else W_SeparatorPos
     C                   Eval      FieldValue =
     C                             %Subst(W_String:W_PosDebut:+
     C                                          (W_SeparatorPos - W_PosDebut)) +
     C                             %Subst(W_String:(W_SeparatorPos +1):+
     C                                       (W_StringLength - W_SeparatorPos))
     C                   Endif                                                  End W_SeparatorPos
 
     C                   Move      W_StringLengthFieldLength
 
      **  If field is alphanumeric, field is extracted as it is in the message.
     C     FieldType     Wheneq    'A'                                          Alphanumeric
     C                   Eval      FieldValue = W_String
     C                   Move      W_NumLength   FieldLength
 
     C     FieldType     Wheneq    *blank                                       No type
     C                   Eval      FieldValue = '?'
 
     C                   Endsl                                                  End Select
 
     C                   Leave
 
      **  Read next record from script.
     C     ReadNext      TAG
     C                   Read      Script                                 81
 
     C                   Enddo                                                  End Do_W_81
 
      **  If image not found.
     C                   If        W_ImageFound = 'N'                           Begin W_ImageFound
     C                   Eval      ReturnCode = 'Image_Nfnd'
     C                   Eval      P@MsgId    = 'RP00023'
     C                   Eval      P@MsgDta   = ImageName + ScriptName +
     C                                          Library + File
     C                   Exsr      #Sndms
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End W_ImageFound
 
      **  If field not found.
     C                   If        W_FieldFound = 'N'                           Begin W_FieldFound
 
     C                   If        FieldName <> '*END_IMAGE'                    Begin FieldName
     C                   Eval      ReturnCode = 'Field_Nfnd'
     C                   Eval      P@MsgId    = 'RP00024'
     C                   Eval      P@MsgDta   = FieldName + ImageName +
     C                                          ScriptName + Library +
     C                                          File
     C                   Exsr      #Sndms
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End W_FieldName
 
     C                   Endif                                                  End W_FieldFound
     C                   Move      Position      FieldPosition
 
      **  Exit from program.
     C                   Return
 
      /Eject
      *****************************************************************
      /Title SR/#Sndms
      *****************************************************************
      *  #Sndms - Subroutine to send message to Program's Message     *
      *              Queue.                                           *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *****************************************************************
     C     #Sndms        Begsr                                                  ** #Sndms SR **
 
     C                   Call      'SNDERMSG'
     C                   Parm      PSProcName    P@PgmQueue       10            Program queue
     C                   Parm      '*PRV '       P@CallMsgQueue    5            Rel queue
     C                   Parm                    P@MsgId           7            Message Id.
     C                   Parm      'PBUSRMSG'    P@MsgFile        10            Message file.
     C                   Parm                    P@MsgDta        132            Message data.
     C                   Parm                    P@MsgType         7            Message type.
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/*Pssr
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
     C                   Move      'Y'           W_RunBefore
     C                   Dump
 
      **  If Return Code was not previously filled.
     C     ReturnCode    Ifeq      *blank                                       Begin ReturnCode
     C                   Eval      ReturnCode = 'ExcptError'
 
     C                   Endif                                                  End ReturnCode
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/*Inzsr
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        Begsr
 
      *
      **  List of parameters.
     C     *Entry        Plist
 
      **--------------------- input parameters ----------------------**
 
      **  Script name.
     C                   Parm                    ScriptName
      **  Image name.
     C                   Parm                    ImageName
      **  Transaction data
     C                   Parm                    TransData
      **  Field name
     C                   Parm                    FieldName
      **  Field type
     C                   Parm                    FieldType
 
      **--------------------- Output parameters ---------------------**
 
      **  Field position
     C                   Parm                    FieldPosition
      **  Field length
     C                   Parm                    FieldLength
      **  Field value
     C                   Parm                    FieldValue
      **  Return code
     C                   Parm                    ReturnCode
 
      **  Access to Data Area RPDFTSDA to get decimal separator
      **  (full stop or comma) and formatted length 0dp fields.
     C                   In        RPDFTSDA
 
      **  If either decimal separator or formatted length 0dp field
      ** is not filled, handle error.
     C     RCDECSEP      Ifeq      *blank                                       Begin RCDECSEP
     C     RCZEROFLD     Oreq      *blank
     C                   Eval      ReturnCode = 'NoDefaults'
     C                   Eval      P@MsgId    = 'RP00025'
     C                   Exsr      #Sndms
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End RCDECSEP
 
     C                   Eval      W_0dpFieldLen  = %Subst(RCZEROFLD:2:1)                     249010
                                                                                              249010
     C                   Endsr
      *****************************************************************
     C/Eject
      *****************************************************************
**  Cpy@
(c) Misys International Banking Systems Ltd. 2001
**  TabImageCode
AAFTER     BBEFORE
