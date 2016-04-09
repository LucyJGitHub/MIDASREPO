     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Midas Extraction Module for MKCTLD CFF008')
      *****************************************************************
      *                                                               *
      *  Midas - Replication Module                                   *
      *                                                               *
      *  RP5512 - Extract module for MKCTLD                           *
      *                                                               *
      *  Function:    Extended Selection: None                        *
      *               List of additional fields:                      *
      *                 - INTYPD.xxxxxx: xxxxxxxxxxxxxxxx           *
      *                                                               *
      *  Component of: RP5512 - Extract program for MKCTLD            *
      *                                                               *
/*    *  (C) COPYRIGHT Misys International Banking Systems sa. 2005   *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. CFF008  *Create    Date 15/07/05              *
      *                                                               *
      *---------------------------------------------------------------*
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  CSF008 - INT-3 FF Static data Inteface MIDAS-OPICS INTERFACE *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Midas FF Instrument type details
     FINTYP     IF   E           K DISK    INFSR(*PSSR)
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
 
     D BANKD         E DS                  EXTNAME(SDBANKPD)
 
      **  Midas FF Market Centres details
     D MARKD         E DS                  EXTNAME(MARKTD)
 
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
     D  W_ISTT                        5A
     D  W_ISTI                        1A
     D  W_ISTN                       20A
     D  W_ISPT                        3A
     D  W_ISCY                        3A
     D  W_QOTC                        3A
     D  W_TKDM                        5A
     D  W_MNPF                       17A
     D  W_TKVL                       16A
     D  W_DBRK                        8A
     D  W_BCPT                        1A
     D  W_BCMC                        4A
     D  W_BCMS                        4A
     D  W_BCGP                        4A
     D  W_BCGS                        4A
     D  W_CCPT                        1A
     D  W_CCMC                        4A
     D  W_CCMS                        4A
     D  W_CCGP                        4A
     D  W_CCGS                        4A
     D  W_CTAM                       15A
     D  W_CMRF                       10A
     D  W_OTHC                        3A
     D  W_STRC                        5A
     D  W_PRRF                       10A
     D  W_ULPD                        5A
     D  W_FTRF                        3A
     D  W_PUPF                        1A
     D  W_FTDF                        7A
     D  W_SEDF                        7A
     D  W_SPMF                        7A
     D  W_FTDT                        7A
     D  W_SETD                        7A
     D  W_SPDT                        7A
     D  W_TFPD                        4A
     D  W_FSPM                        4A
     D  W_ISMQ                       12A
     D  W_CNTT                        3A
     D  W_AEIN                        1A
     D  W_ALPD                        7A
     D  W_CCAM                       15A
     D  W_CTCY                        3A
     D  W_FTTM                        6A
     D  W_INNR                        3A
     D  W_PLMIIT                      1A
     D  W_PLMITM                      4A
     D  W_PLMIMD                      7A
     D  W_PLMICP                     13A
     D  W_PLMICF                      1A
     D  W_PLMIPC                      1A
     D  W_PLMIVT                      1A
     D  W_PLMIPM                      1A
     D  W_PLMIPG                      8A
     D  W_PLMIRG                      8A
     D  W_PLMICR                      4A
     D  W_FRTK                        1A
     D  W_UNSE                       10A
     D  W_TECO                        3A
     D  W_TNAT                        3A
     D  W_CRIK                        2A
     D  W_CCYR                        3A
     D  W_TWEI                        4A
     D  W_FFZONE                     10A
 
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
     D ISTT            DS
     D  IMrkt                         2A
     D  IIstc                         3A
 
      **   Current Trading date - (MMDDYY or DDMMYY)
     D                 DS
     D  CTD                    1      6
     D  CT1                    1      2
     D  CT2                    3      4
     D  CT3                    5      6
 
 
      **   Previous Trading date - (MMDDYY or DDMMYY)
     D                 DS
     D  BTD                    1      6
     D  BT1                    1      2
     D  BT2                    3      4
     D  BT3                    5      6
 
      **  Work Field Definitions
     D W_BUSD          S              7A
     D W_MRKT          S              2A
     D W_INKY          S              5A
     D IMQ             S              1    DIM(12)
 
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
 
 
      **  Extract Market centre from MKCTLD message data.
     C                   Z-add     1             X
     C     'MRKT  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Mrkt = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
      **  Extract Current Trading Date from MKCTLD message data.
     C                   Z-add     1             X
     C     'BUSD  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_BUSD = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
 
     C                   MOVE      W_BUSD        W_BUSDN           5 0
     C*
      **  Access to Market Centre details, by using access object.
     C                   Call      'AOMKCDR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   PARM      W_MRKT        P@MRKT            2            I:Key field
     C     MARKD         Parm      MARKD         Dssdy                          O:Format
 
      **  Access previous working day before business day
     C                   Z-ADD     1             BKVDAYS           2 0
     C                   CALLB     'ZBKDT'
     C                   PARM      W_BUSDN       ZDAYNO            5 0          Value date
     C                   PARM      MKLC          ZCCY              3            CCY
     C                   PARM      MLOC          ZLOC              3            Location
     C                   PARM      BKVDAYS       ZNRDAYS           2 0          Back value days
     C                   PARM      *ZEROS        ZDYNBR            5 0          Midas day number
     C                   Z-ADD     ZDYNBR        W_PUSD            5 0
 
      **  Check month of business day against previous business day to see if they have changed
     C*
      **   1. Determine Current Trading Month
     C*
      **  Access to SDBANK details, by using access object.
     C                   Call      'AOBANKR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C     BANKD         Parm      BANKD         Dssdy                          O:Format
 
 
     C                   CALLB     'ZDATE2'
     C                   PARM      W_BUSDN       ZDAYNO            5 0          Value date
     C                   PARM      BJDFIN        PDATF             1            Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         CTD
 
 
      ** If = 'M' use MMDDYY as the date else use DDMMYY as the date format
     C     PDATF         COMP      'M'                                    98
     C     *IN98         IFEQ      '1'
     C                   MOVE      CT1           CM                2 0
     C                   ELSE
     C                   MOVE      CT2           CM
     C                   END
 
      **   2. Determine Previous Day Trading Month
     C                   CALLB     'ZDATE2'
     C                   PARM      W_PUSD        ZDAYNO            5 0          Value date
     C                   PARM      PDATF         BJDFIN            1            Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         BTD
 
 
      ** If = 'M' use MMDDYY as the date else use DDMMYY as the date format
     C     PDATF         COMP      'M'                                    98
     C     *IN98         IFEQ      '1'
     C                   MOVE      BT1           BM                2 0
     C                   ELSE
     C                   MOVE      BT2           BM
     C                   END
 
      **  Check if month changed if not no messages sent.
     C     BM            Ifne      CM                                           Begin Extended Filt1
 
     C                   MOVEL     W_MRKT        W_INKY
     C     W_INKY        SETLL     INTYP
     C                   READ      INTYP                                  99
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
      *
      * Read from transaction file
      *
      *
      * Move data into extended fields if market has not changed
      *
      *
     C     W_MRKT        IFEQ      IMRKT
      *
      * Check if a quoted month fields if market has not changed
      *
     C                   MOVEA     ISMQ          IMQ
      **     - traded month or forward month not blank
     C     IMQ(BM)       IFEQ      'Y'
     C     FSPM          ORNE      0
 
      **----------------- Start of Additionnal fields ---------------**
 
     C                   MOVE      ISTT          W_ISTT
     C                   MOVE      ISTI          W_ISTI
     C                   MOVE      ISTN          W_ISTN
     C                   MOVE      ISPT          W_ISPT
     C                   MOVE      ISCY          W_ISCY
     C                   MOVE      QOTC          W_QOTC
     C                   MOVE      TKDM          W_TKDM
     C                   MOVE      ISCY          W_ISCY
     C                   MOVE      QOTC          W_QOTC
     C                   MOVE      TKDM          W_TKDM
     C                   MOVE      MNPF          W_MNPF
     C                   MOVE      TKVL          W_TKVL
     C                   MOVE      DBRK          W_DBRK
     C                   MOVE      BCPT          W_BCPT
     C                   MOVE      BCMC          W_BCMC
     C                   MOVE      BCMS          W_BCMS
     C                   MOVE      BCGP          W_BCGP
     C                   MOVE      BCGS          W_BCGS
     C                   MOVE      CCPT          W_CCPT
     C                   MOVE      CCMC          W_CCMC
     C                   MOVE      CCMS          W_CCMS
     C                   MOVE      CCGP          W_CCGP
     C                   MOVE      CCGS          W_CCGS
     C                   MOVE      CTAM          W_CTAM
     C                   MOVE      CMRF          W_CMRF
     C                   MOVE      OTHC          W_OTHC
     C                   MOVE      STRC          W_STRC
     C                   MOVE      PRRF          W_PRRF
     C                   MOVE      ULPD          W_ULPD
     C                   MOVE      OTHC          W_OTHC
     C                   MOVE      STRC          W_STRC
     C                   MOVE      PRRF          W_PRRF
     C                   MOVE      ULPD          W_ULPD
     C                   MOVE      FTRF          W_FTRF
     C                   MOVE      PUPF          W_PUPF
     C                   MOVE      FTDF          W_FTDF
     C                   MOVE      SEDF          W_SEDF
     C                   MOVE      SPMF          W_SPMF
     C                   MOVE      FTDT          W_FTDT
     C                   MOVE      SETD          W_SETD
     C                   MOVE      SPDT          W_SPDT
     C                   MOVE      TFPD          W_TFPD
     C                   MOVE      FSPM          W_FSPM
     C                   MOVE      ISMQ          W_ISMQ
     C                   MOVE      CNTT          W_CNTT
     C                   MOVE      AEIN          W_AEIN
     C                   MOVE      ALPD          W_ALPD
     C                   MOVE      CCAM          W_CCAM
     C                   MOVE      CTCY          W_CTCY
     C                   MOVE      FTTM          W_FTTM
     C                   MOVE      INNR          W_INNR
     C                   MOVE      PLMIIT        W_PLMIIT
     C                   MOVE      PLMITM        W_PLMITM
     C                   MOVE      PLMIMD        W_PLMIMD
     C                   MOVE      PLMICP        W_PLMICP
     C                   MOVE      PLMICF        W_PLMICF
     C                   MOVE      PLMIPC        W_PLMIPC
     C                   MOVE      PLMIVT        W_PLMIVT
     C                   MOVE      PLMIPM        W_PLMIPM
     C                   MOVE      PLMIPG        W_PLMIPG
     C                   MOVE      PLMIRG        W_PLMIRG
     C                   MOVE      PLMICR        W_PLMICR
     C                   MOVE      FRTK          W_FRTK
     C                   MOVE      UNSE          W_UNSE
     C                   MOVE      TECO          W_TECO
     C                   MOVE      TNAT          W_TNAT
     C                   MOVE      CRIK          W_CRIK
     C                   MOVE      CCYR          W_CCYR
     C                   MOVE      TWEI          W_TWEI
     C                   MOVE      FFZONE        W_FFZONE
 
      **------------------ End of Additionnal fields ----------------**
 
 
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
 
     C                   Endif
     C                   Endif
 
     C                   READ      INTYP                                  99
 
     C                   ENDDO
 
     C                   Endif                                                  End Extended Filt 1
 
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
 
      **  Retrieve position and length of Market Centre from MKCTLD message data.
     C                   Eval      FieldName   = 'MRKT  '
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
 
      **  Retrieve position and length of Business date from MKCTLD message data.
     C                   Eval      FieldName   = 'BUSD  '
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
**  Cpy@
(C) Copyright Misys International Banking Systems sa. 2001
