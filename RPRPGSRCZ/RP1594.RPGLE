     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas PB Extraction Module for RPDPMVPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Replication Module (Private Banking)                 *
      *                                                               *
      *  RP1594 - Extract module for RPDPMVPD                         *
      *                                                               *
      *  Function:    This module only sends transactions for Private *
      *            Banking Customers.                                 *
      *               List of additional fields:                      *
      *                 - Exchange rate                               *
      *                                                               *
      *  Component of: RP1594 - Extract program for RPDPMVPD          *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059754           Date 19Apr22               *
      *  Prev Amend No. AR981194  *CREATE  Date 29May12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059754 - Replication job RPTRGSRV01 dumps with signature   *
      *             violation. (Recompile)                            *
      *  AR981194 - PBS Compatibility with BankFusion Midas 2.00      *
      *             (Child:AR981196)                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **  Midas All value date portfolio positions
     FPMVPOSLL  IF   E           K Disk
     F                                     Infsr(*Pssr)

      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
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
      *       * 81   xx   xx   84   85   86   87   88   89   90 *     *
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

      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,STD_DCL

      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C/COPY RPCPYSRC,MDN_HD_DS

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
      ** Array for manipulating decimal positions
     D POWER8          S              8  4 Dim(8) Ctdata Perrcd(1)

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

     D Dsldy         E DS                  Extname(DSLDY)
      ** DS for Access Programs, Extend Data Structure

      ** Data Structure for access to Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)

      ** +-@KINVT-------------------------------+
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

     D MessageInd      S              1A

     D RAMSGOLD        S                   LIKE(RAMSGTYPE)

      **   Database Error Messsage Text
     D DBErrText       S            256A

      **   Transaction Data of associated transaction
     D AssocData       S                   LIKE(TransData)

      **   Meridian header Layout of associated transaction
     D MdHdAssoc       S                   LIKE(MdnHeadDs)

      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Depository
     D P_Depos         S              6A
      **  Industru Code
     D P_Indus         S              3A
      ** ---------- End of fields used by access programs -----------**

      **----------------  Start of additional fields ----------------**
     D W_ExchangeRate  S             15A
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
     C                   EVAL      MessageInd = 'Y'
     C                   EVAL      RAMSGOLD = RAMSGTYPE
     C                   EVAL      AssocData = *Blanks
     C                   EVAL      MdHdAssoc = *Blanks

      **  Enter the processing to read the additional files and produce a
      **  composite message here.


      **----------------- Start of Additionnal fields ---------------**
      **  Define key lists to access to Portfolio Positions Details file.
     C     @KeyPM1       KLIST
     C                   KFLD                    @KCNUM            6
     C                   KFLD                    @KPTFR            4
     C                   KFLD                    @KTDSS           10
     C                   KFLD                    @KPDAT            5 0
      *
     C     @KeyPM2       KLIST
     C                   KFLD                    @KCNUM
     C                   KFLD                    @KPTFR
     C                   KFLD                    @KTDSS

      **  Extract Customer Number from RPDPMVPD message data.
     C                   Z-ADD     1             X
     C     'RPCNUM'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    @KCNUM

      **  Extract Portfolio Reference from RPDPMVPD message data.
     C                   Z-ADD     1             X
     C     'RPPTFR'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      @KPTFR = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))

      **  Extract Security Shortname from RPDPMVPD message data.
     C                   Z-ADD     1             X
     C     'RPDPSS'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      @KTDSS = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))

      **  Extract Value Date from RPDPMVPD message data.
     C                   Z-ADD     1             X
     C     'RPDPVD'      LOOKUP    Arrfld(X)                              89
     C                   EVAL      FieldValue = %Subst(TransData:+
     C                             ArrPos(X)+W_PosDebut:ArrLen(X))
     C                   MOVEL     FieldValue    @KPDAT

     C     @KeyPM1       SETGT     PMVPOSLL
     C     @KeyPM2       READPE    PMVPOSLL                               89

      **   Calculate the customer FX rate using SR/ZFXAVP subroutine
     C     QAAPNM        IFEQ      *ZERO
     C                   Z-ADD     1             ZAVFX            13 8
     C                   ELSE
     C                   Z-ADD     QAAPNM        ZAPNM            15 0
     C                   Z-ADD     QAFXAP        ZFXAP            15 0
      *
      **  Retrieve currency number of decimal places.
     C                   EVAL      P_Curr = QATNMC
     C                   EXSR      GetDecPl
     C                   Z-ADD     A6NBDP        ZNMCD             1 0
      *
     C                   Z-ADD     QAPCDP        ZPTCD             1 0
     C                   Z-ADD     *ZERO         ZAVFX
      *
      ** Divide FX AP Numerator by AP Numerator
     C     ZFXAP         DIV(H)    ZAPNM         WWAVFX           21 8
      *
      ** Set POWER8 Index to 5 - Nbr Nom Ccy Dec. Places + Nbr Port Ccy Dec. Pl.
     C     5             SUB       ZNMCD         ZI                1 0
     C                   ADD       ZPTCD         ZI
      *
      ** Divide Average Price by Power
     C     WWAVFX        DIV(H)    POWER8(ZI)    ZAVFX
      *
      ** Set Average Price Positive
     C     ZAVFX         IFLE      0
     C                   Z-SUB     ZAVFX         ZAVFX
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      fmLength = 13
     C                   EVAL      fmDecPos = 8
     C                   EVAL      fmSign3010 = ZAVFX
     C                   EVAL      fmAlpNum32 =
     C                                ProcSigned(fmSign3010 : fmLength :
     C                                           fmDecPos : fmDecSep :
     C                                           fmShwPsSgn)
     C                   EVAL      W_ExchangeRate = %subst(fmAlpNum32 : 1 : 15)

      **------------------ End of Additionnal fields ----------------**

      **  Change message Type from _A to _After (To activate later when repository is ready)
      ** Note this is oposite to standard to avoid MDBASCRIPOT extract.)
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
     C                   EXSR      Repair
     C                   ENDIF                                                  End W_PosFin

      **  Change  Image Type.

     C                   EVAL      RAMSGTYPE =
     C                             %Subst(RAMSGTYPE:1:W_PosFin + 1)

      **  Place the result in field CompData.

     C                   EVAL      CompData  = %subst(TransData:1:EndPosition)
     C                                       + W_ExchangeRate

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
     C     ReturnCode    IFNE      *Blanks                                      Begin ReturnCode
     C     *Lock         IN        Lda
     C                   EVAL      DBpgm  = PSProcName
     C                   EVAL      DBfile = 'Call    '                          ***************
     C                   EVAL      DBase  = 04                                  * Db Error 04 *
     C                   EVAL      DBkey  = 'RPC1305'                           ***************
     C                   OUT       Lda
     C                   EXSR      *Pssr

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
     C                   EXSR      *Pssr
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
     C     ReturnCode    IFNE      *Blanks
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
     C     ReturnCode    IFNE      *Blanks
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
     C     DBpgm         IFEQ      *Blanks                                      Begin DBpgm
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
      **  MQSeries queue to write to - this parameter IS used in this module
     C                   PARM                    OutQueue
      **  Merdian header
     C                   PARM                    MdnHeadDS
      **  Transaction Data
     C                   PARM                    TransData
      **  Commitment control flag
     C                   PARM                    CommitCtl
      **  Return Code
     C                   PARM                    ReturnCode

     C                   EVAL      MessageInd = 'Y'

      **  Set up work fields for formatting that will not change if
      **  Replication formatting is required.
      **     - signs are not shown for Positive numbers.
      **     - get decimal separator from Replication data area RPDFTSDA.
     C                   IN        RPDftsDa
     C                   EVAL      fmDecSep   = RCDECSEP
     C                   EVAL      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   MOVE      fmDpLen       W_PosDebut
     C                   EVAL      fmShwPsSgn = 'N'

      **  Set up work fields that will not change if retrieve
      **  function is to be used.
     C                   EVAL      ScriptName = 'RP' + RATGTSYS

     C                   Z-ADD     0             X                 3 0

      **  Retrieve position and length of Beneficial Customer from RPDPMVPD msg
     C                   EVAL      FieldName   = 'RPDPBN'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos

      **  Retrieve position and length of Portfolio Reference from RPDPMVPD msg
     C                   EVAL      FieldName   = 'RPPTFR'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos

      **  Retrieve position and length of Security Shortname from RPDPMVPD msg
     C                   EVAL      FieldName   = 'RPDPSS'
     C                   EVAL      FieldType   = 'A'
     C                   EXSR      RtvPos

      **  Retrieve position and length of Value Date from RPDPMVPD msg
     C                   EVAL      FieldName   = 'RPDPVD'
     C                   EVAL      FieldType   = 'N'
     C                   EXSR      RtvPos

      **  Retrieve begin position of additionnal fields in Meridian message.
     C                   EVAL      FieldName   = '*END_IMAGE'
     C                   EVAL      FieldType   = *blank
     C                   EXSR      RtvPos
     C                   EVAL      EndPosition = FieldPosition - 1

     C                   ENDSR
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

     C     GetDecPl      BEGSR

      **  Access to Currency Details, by using access object.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *blank        P_Rtcd
     C                   PARM      '*KEY   '     P_Optn
     C                   PARM                    P_Curr            3
     C     Sdcurr        PARM      Sdcurr        Dssdy

      **  If currency does not exist, handle database error.
     C     P_Rtcd        IFNE      *Blanks
     C     *Lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDCURRPD'
     C                   EVAL      Dbase  = 10
     C                   EVAL      Dbkey  = P_Curr
     C                   OUT       LDA
     C                   EVAL      ReturnCode  = P_RTCD
     C                   EXSR      Repair

     C                   ENDIF

     C                   ENDSR
      /Eject
      *****************************************************************
**  Cpy@
(c) Finastra International Limited 2021
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
