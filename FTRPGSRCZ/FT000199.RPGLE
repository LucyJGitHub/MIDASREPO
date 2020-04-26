     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT MT199 Message Extraction and Formatting')     *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  FT000199 - Midas MT199 Message Extraction and Formatting     *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSW220  *CREATE    Date 09Mar20               *
      *  Prev Amend No.                    Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW220 - SWIFT Changes 2020                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    nn - <function of indicator>                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Outgoing payments details keyed by Message Unique Reference
     FOTPAYLA   IF   E           K DISK

      ** Incoming payments details keyed by Message Unique Reference
     FINPAYLA   IF   E           K DISK

      ** Incoming Message Control by Message Tag
     FMEINDTL0  IF   E           K DISK

      ** Incoming Message FT Data
     FMEINFTPD  IF   E           K DISK

      ** Joint File for retrieving records in FTMG
     FMEINMPJ1  IF   E           K DISK

      ** Logical File for retrieving MT199 sender
     FMEINCRL1  IF   E           K DISK

      ** Logical File for retrieving Incoming Message Transaction Number
     FMEINMPL1  IF   E           K DISK

      ** Logical file for retrieving FT Standing Data
     FTABFP     IF   E           K DISK    IGNORE(TABTB20F:TABTG20F)
     F                                     IGNORE(TABLETHF:TABLETPF)
     F                                     IGNORE(TABLET5F:TABTE10F)

      ** New Logical file that will filter MT199
     FMEINFTL6  UF   E             DISK

      ** Outgoing Message Extension File
     FMGOEXTPD  O    E           K DISK    COMMIT

      ** Outgoing Message Reference File
     FMGOREFPD  O    E           K DISK    COMMIT

      ** Outgoing Message File
     FMGOMSGPD  O    E           K DISK    COMMIT

      ** Midas MT199 Msg Extraction and Formatting Audit Rpt
     FFT000199AUO    E             PRINTER USROPN

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Data Area Giving Installation Control Details
     D*COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D SValK1          C                   CONST('MT199Destination')
     D StsACCC         C                   CONST('//ACCC')
     D StsRJCT         C                   CONST('//RJCT/MS03')
     D StsACSPH        C                   CONST('//ACSP/G002')
     D StsACSPT        C                   CONST('//ACSP/G001')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      *
      **  Multiple occurrence data structure for message
      *
     D MULT            DS                  OCCURS (50)
     D  MTAG                   1      5
     D  MFLD                   6     55
      * For exclusive use of Mult DS
     D Q               S              2P 0

      *  User / Branch data area
     D ZMUSER          DS            17
     D  WUSRID                 1     10
     D  WDFBR                 11     13
     D  WDPPT                 14     16

      *
      ** Multiple occurrence data structure for extension file
      * Temporarily excluded since i'm not sure if we need it.
      *
     D*EXTN            DS                  OCCURS(45)
     D* MPSN                   1      2  0
     D* MTG                    3      7
     D* MCSI                   8     15
      * For exclusive use of EXTN DS
     D*V               S              2P 0

      *
      ** Arrays for formatting Swift Amount
      *
      ** Amount Array
     D AMT             S              1A   DIM(13)
      ** Edited Amount Array
     D AM              S              1A   DIM(14)
      ** Left Adjust Amount Array
     D FAMT            S              1A   DIM(15)

      ** External data structure - SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External data structure for branch file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      **  Local data area
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry Parameter List
     D PCob            S              1A
     D PRtnCode        S              7A

      ** Parameter Variables to call 'AOSVALR0'
     D PRtcd           S              7A
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A

      *
      ** Key Fields
      *
     D KFMsgR          S              8P 0
     D KFMtag          S              5A

      *
      ** Variables for storing the final value of tags
      *
     D  WTag121Val     S             36A
     D  WTag20Val      S             16A
     D  WTag21Val      S             15A
     D  WTag79L1Val    S             17A
     D  WTag79L2Val    S             11A
     D  WTag79L3Val    S             14A
     D  WTag79L4Val    S             21A

      ** Work Variables
     D WIPRef          S             15A
     D WOPRef          S             15A
     D WSender         S             12A
     D WReceiver       S             12A
     D WTag20a         S              8A
     D WTag20b         S              6A
     D WGenFlg         S              1A

      ** Variables for getting formatted SWIFT date and time
     D WCurDteTme      S              1A
     D WTmSt           S             26A
     D WDate           S              6A
     D WTime           S              4A   INZ('0000')
     D WUTCOffset      S              4A   INZ('0000')
     D WUTCOffSgn      S              1A   INZ('+')

      ** Variables for getting formatted SWIFT amount
     D WICcy           S              3A
     D WIAmnt          S             13P 0
     D WOCcyS          S              3A
     D WOAmnt          S             15A
     D WAmta           S             13A
     D WODecS          S              1P 0
     D AMX             S             14A
     D W               S              2P 0
     D X               S              2P 0
     D Y               S              2P 0
     D Z               S              2P 0

      ** Variables for writing MGOREFPD
      * Transaction Ref. Number
     D WTRNo           S             16A
     D WTrnId          S             15A
     D WPyTp           S              2A
     D WPySt           S              2A
     D WBnCs           S             35A
     D WSeCN           S              6A
     D WSnCsID         S             12A
     D WBrCA           S              3A

      ** Parameters for calling AOCURRPD
     D POptn           S              7A
     D PWCcy           S              3A

      ** Parameters for calling Standing Data
     D @BRCD           S              3A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @SARD           S              6A

      ** Result fields of Swift Format Currency
     D ZAMNT           S             13P 0
     D ZCCY            S              3A
     D ZSAMNT          S             17A
     D ZSCCY           S              3A
     D ZERR            S              1A

      ** Feature Flags
     D CSW020          S              1A

      ** Variable for accessing TABFP
     D ZTABKY          S             12A

      ** Temporary Variables
     D YY              S              2P 0

      * Note: Ask Jhen if the lengths are correct

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      ****************************************************************
      /EJECT
      ****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Message Generation
     C                   EXSR      SrRdIncMsg

     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PCob
     C                   PARM                    PRtnCode

      *
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER

      *
      ** Key List for reading Incoming Messages
      *
     C     KLIncMsg      KLIST
     C                   KFLD                    KFMsgR
     C                   KFLD                    KFMtag

      *
      ** Retrieve Swift Universal Tracker Address from System Values
      *

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SValK1        PSValK1
     C                   PARM                    PSVal1
     C                   PARM      *BLANKS       PSValK2
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10

     C                   IF        PRtcd <> *BLANKS

     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSVALPD'    DBFILE

     C                   IF        PSVal1 = '*NRF  '
     C                   MOVE      '001'         DBASE
     C                   MOVEL     SValK1        DBKEY
     C                   ENDIF


     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE
      *
      ** Store value of Receiver from System Value to work variable
      ** Default Value: TRCKCHZZ
      *
     C                   EVAL      WReceiver = PSVal1
     C                   ENDIF

      *
      **  Access SAR details to determine if SWIFT Decimal Places is
      **  switched on (CSW020)
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW020'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** If core feature is switched ON, set a variable field to
      ** condition the rest of the processing
      *
     C                   IF        @RTCD = *BLANKS
      *
     C                   EVAL      CSW020 = 'Y'
      *
     C                   ELSE
      *
      ** else, database error (return code other than *NRF)
      *
     C                   IF        @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE
     C                   MOVEL     '*VERIFY'     DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF

      *
      ** Set up key and access installation control record (TABTB11F)
      *
     C                   MOVE      *BLANKS       ZTABKY
     C                   MOVEL     '01'          ZTABKY
     C                   MOVE      '11'          ZTABKY
     C     ZTABKY        CHAIN     TABFP                              10
      *
     C                   IF        *IN10 or RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE
     C                   MOVEL     'TABFP'       DBKEY
     C                   MOVEL     'ZTABKY'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C*
     C*  Default the message status whith the ICD.
     C*
     C                   IF        FTCS = 'R'
     C                   EVAL      MGST = 'RSND'
     C                   EVAL      MGSG = '2'
     C                   ELSE
     C                   EVAL      MGST = 'CRTD'
     C                   EVAL      MGSG = '1'
     C                   ENDIF

      *
      ** Access Bank details via access program (Includes Run Date)
      *  (database error handling done in access program)
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      *
      * disclaimer: not sure yet if this works
      *
      ** Convert rundate from MMDDYY to YYMMDD format .
      *
     C                   CALL      'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM      'M'           ZDATFM            1
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7

     C                   EVALR     WTag20b = '000000' + %CHAR(ZDATE)
     C                   EVAL      WTag20b = %SUBST(WTag20b:5:2)
     C                                     + %SUBST(WTag20b:1:4)

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRdIncMsg - Read Incoming Messages for MT199                 *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SrSvPyFld, SRExtract, SrOMSG, SrInitFld                *
      *                                                               *
      *****************************************************************

     C     SrRdIncMsg    BEGSR

      *
      ** Read All Records in MEINFTPD whose MT199 flag is not empty
      *

     C                   READ      MEINFTL6                               99

      ** Do While records found in Incoming Message
     C                   DOW       *IN99 = '0'

     C                   EVAL      KFMsgR = FTMSGR

      *
      ** MT199 Status is ACCC
      *
     C                   IF        FTM199 = 'A'
     C                   EVAL      WIPRef = FTIPRF
     C     KFMsgR        CHAIN     INPAYLA

     C                   IF        %FOUND
      *
      ** Check if IPAY transaction is Authorised
      *
     C                   IF        AUIN = 'Y'

     C                   EVAL      WTag79L2Val = StsACCC
     C                   EVAL      WCurDteTme = 'Y'
     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ENDIF

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE
     C                   MOVEL     'WIPref'      DBKEY
     C                   MOVEL     'INPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** MT199 Status is ACSP (Transferred)
      *
     C                   ELSEIF    FTM199 = 'T'

     C                   EVAL      WOPRef = FTOPRF
     C     KFMsgR        CHAIN     OTPAYLA

     C                   IF        %FOUND

     C                   IF        AUIN = 'Y'

     C                   EVAL      WTag79L2Val = StsACSPT
     C                   EVAL      WCurDteTme = 'Y'
     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ENDIF

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '006'         DBASE
     C                   MOVEL     'WOPref'      DBKEY
     C                   MOVEL     'OTPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** MT199 Status is RJCT
      *
     C                   ELSEIF    FTM199 = 'R' AND PCob = 'Y'

     C                   EVAL      WTag79L2Val = StsRJCT

      *
      ** Incoming Message was Ignored in FTMG
      *
     C                   IF        FTINFG = 'MIN0182'

     C                   EXSR      SrSvCmFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ELSE

      *
      ** Incoming Message routed to OPAY
      *
     C                   IF        FTOPRF <> *BLANKS
     C                   EVAL      WOPRef = FTOPRF
     C     KFMsgR        CHAIN     OTPAYLA

     C                   IF        %FOUND

     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '007'         DBASE
     C                   MOVEL     'WOPref'      DBKEY
     C                   MOVEL     'OTPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** Incoming Message routed to IPAY
      *
     C                   ELSEIF    FTIPRF <> *BLANKS
     C                   EVAL      WIPRef = FTIPRF
     C     KFMsgR        CHAIN     INPAYLA

     C                   IF        %FOUND

     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '008'         DBASE
     C                   MOVEL     'WIPref'      DBKEY
     C                   MOVEL     'INPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      *
      ** MT199 Status is ACSP (On-Hold)
      *
     C                   ELSEIF    FTM199 = 'H' AND PCob = 'Y'

     C                   EVAL      WTag79L2Val = StsACSPH

     C                   IF        FTOPRF <> *BLANKS
     C                   EVAL      WOPRef = FTOPRF
     C     KFMsgR        CHAIN     OTPAYLA

     C                   IF        %FOUND

     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '007'         DBASE
     C                   MOVEL     'WOPref'      DBKEY
     C                   MOVEL     'OTPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C                   ELSEIF    FTIPRF <> *BLANKS
     C                   EVAL      WIPRef = FTIPRF
     C     KFMsgR        CHAIN     INPAYLA

     C                   IF        %FOUND

     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '008'         DBASE
     C                   MOVEL     'WIPref'      DBKEY
     C                   MOVEL     'INPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C                   ELSE

     C                   EXSR      SrSvCmFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ENDIF

     C                   ENDIF

      *
      ** Writes to MGOMSGPD
      *
     C                   IF        WGenFlg = 'Y'
     C                   EXSR      SrOMSG

      *
      ** If generation is successful, turn MT199 to 'Z'
      *
     C                   EVAL      FTM199 = 'Z'
     C                   UPDATE    @INFTL6                              98

     C                   IF        *IN98 = *ON
     C     *LOCK         IN        LDA
     C                   MOVE      '009'         DBASE
     C                   MOVEL     'FTM199'      DBKEY
     C                   MOVEL     'MEINFTL6'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

      *
      ** Reinitialise fields for the next record
      *
     C                   EXSR      SRInitFld

      *
      ** Read next record
      *
     C                   READ      MEINFTL6                               99

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInitFld   - Initalise non-constant fields                   *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrInitFld     BEGSR

      *
      ** Set up LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'FT000199'    DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA

      *
      ** Reset value of Key fields
      *
     C                   EVAL      KFMsgR = *ZEROS
     C                   EVAL      KFMtag = *BLANKS

      *
      ** Reset variables for storing the final value of tags
      *
     C                   EVAL      WTag121Val = *BLANKS
     C                   EVAL      WTag20Val = *BLANKS
     C                   EVAL      WTag21Val = *BLANKS
     C                   EVAL      WTag79L1Val = *BLANKS
     C                   EVAL      WTag79L2Val = *BLANKS
     C                   EVAL      WTag79L3Val = *BLANKS
     C                   EVAL      WTag79L4Val = *BLANKS
     C                   EVAL      WGenFlg = *BLANKS

      *
      ** Reset work Variables
      *
     C                   EVAL      WIPRef = *BLANKS
     C                   EVAL      WOPRef = *BLANKS
     C                   EVAL      WSender = *BLANKS
     C                   EVAL      WTag20a = *BLANKS

      *
      ** Reset variables for getting formatted SWIFT amount
      *
     C                   EVAL      WICcy = *BLANKS
     C                   EVAL      WIAmnt = *ZEROS
     C                   EVAL      WOCcyS = *BLANKS
     C                   EVAL      WOAmnt = *BLANKS
     C                   EVAL      WAmta = *BLANKS
     C                   EVAL      AMX = *BLANKS
     C                   EVAL      W = *ZERO
     C                   EVAL      X = *ZERO
     C                   EVAL      Y = *ZERO
     C                   EVAL      Z = *ZERO
	
      *
      ** Clear arrays for formatting Swift Amount
      *
     C                   CLEAR                   AMT
     C                   CLEAR                   AM
     C                   CLEAR                   FAMT

      *
      ** Reset variables for getting formatted SWIFT date and time
      *
     C                   EVAL      WCurDteTme = *BLANKS
     C                   EVAL      WDate = *BLANKS
     C                   EVAL      WTime = '0000'
     C                   EVAL      WUTCOffset = '0000'
     C                   EVAL      WUTCOffSgn = '+'

      *
      ** Reset variables for writing MGOREFPD
      *
     C                   EVAL      WTRNo = *BLANKS
     C                   EVAL      WTrnId = *BLANKS
     C                   EVAL      WPyTp = *BLANKS
     C                   EVAL      WPySt = *BLANKS
     C                   EVAL      WBnCs = *BLANKS
     C                   EVAL      WBrCA = *BLANKS

      *
      ** Clear multiple occurrence data structure
      ** http://www.go4as400.com/rpgle-opcodes/as400.aspx?cid=214
      *
     C                   CLEAR     *ALL          MULT
     C                   EVAL      Q = 0

      ** Clear multiple occurrence DS for the extension file.
      * Temporarily excluded since i'm not sure if we need it.
     C*                  CLEAR     *ALL          MULT
     C*                  EVAL      V = 0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSvPyFld   - Saves fields from OPAY/IPAY to work variables   *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrSvPyFld     BEGSR

     C                   EVAL      WBrCA = BRCA
     C                   EVAL      WBnCs = BNC1
     C                   EVAL      WTrnId = PREF
     C                   EVAL      WPyTp = PYTP
     C                   EVAL      WPySt = PYST

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSvCmFld   - Saves common fields from incoming message to    *
      *               work variables                                  *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrSvCmFld     BEGSR

      *
      ** Use default branch for user if branch not from Payment Transaction
      *
     C                   IF        WBRCA = *BLANKS
     C                   EVAL      WBrCA = WDFBR
     C                   ENDIF
     C

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExtract   - Extract details                                 *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      * Calls: SrFmDtTm, SrFAMT                                       *
      *                                                               *
      *****************************************************************

     C     SrExtract     BEGSR

      *
      ** Get tag 20
      ** found in internet. need to test
      *
     C                   EVAL      Wtag20a = %CHAR(KFMsgR)
     C                   EVALR     Wtag20a = '00000000' + %TRIM(Wtag20a)
     C                   EVAL      WTag20Val = 'FT' + WTag20a + WTag20b
     C                   EVAL      WTRNo = WTag20Val

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':20:'        MTAG
     C                   MOVEL     WTag20Val     MFLD

      *
      ** Get tag 21
      *
     C     KFMsgR        CHAIN     MEINMPL1
     C                   IF        %FOUND

     C                   EVAL      WTag21Val = MPTRNO

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':21:'        MTAG
     C                   MOVEL     WTag21Val     MFLD

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '010'         DBASE
     C                   MOVEL     'KLMsgDtl'    DBKEY
     C                   MOVEL     'MEINMPL1'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** Get the value of Sender in MEINCRPD.CRMOR(Output) and tag :21:
      *
     C     KFMsgR        CHAIN     MEINCRL1
     C                   IF        %FOUND

     C                   EVAL      WSender = %SUBST(CRMOR:7:12)
     C                   EVAL      WICcy = CRCYCD

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '011'         DBASE
     C                   MOVEL     'KFMsgR'      DBKEY
     C                   MOVEL     'MEINCRL1'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** Get tag 121
      *
     C                   EVAL      KFMtag = '121:'
     C     KLIncMsg      CHAIN     MEINDTL0
     C                   IF        %FOUND
     C                   EVAL      WTag121Val = DTMFLD

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':121:'       MTAG
     C                   MOVEL     WTag121Val    MFLD

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '012'         DBASE
     C                   MOVEL     'KLIncMsg'    DBKEY
     C                   MOVEL     'MEINDTL0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** Get tag 79 Line 1
      *
     C                   EXSR      SrFmDtTm
     C                   EVAL      WTag79L1Val = '//' + WDate + WTime
     C                                        + WUTCOffSgn + WUTCOffset

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':79:'        MTAG
     C                   MOVEL     WTag79L1Val   MFLD

      *
      ** Store tag 79 Line 2; Identified before entering this subroutine
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':79:'        MTAG
     C                   MOVEL     WTag79L2Val   MFLD

      *
      ** Get tag 79 Line 3
      *
     C                   EVAL      WTag79L3Val = '//' + WSender

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':79:'        MTAG
     C                   MOVEL     WTag79L3Val   MFLD

      *
      ** Get tag 79 Line 4
      *
     C                   EVAL      WIAmnt = PYAM
     C                   EXSR      SrFAMT
     C                   EVAL      WTag79L4Val = '//' + WICcy + WOAmnt

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':79:'        MTAG
     C                   MOVEL     WTag79L4Val   MFLD

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrFmDtTm - Format Date and Time for Tag 79 Line 1            *
      *                                                               *
      *  Called by: SrExtract                                         *
      *                                                               *
      *  Calls    : AOBRCHR0                                          *
      *                                                               *
      *****************************************************************
     C     SrFmDtTm      BEGSR
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WBrCA         @BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY

      ** Branch record not found - DB Error

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '013'         DBASE
     C                   MOVEL     WBrCA         DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save the Branch Customer
     C                   EVAL      WSeCN = A8BICN
     C                   EVAL      WSnCsID = A8BTID

     C                   IF        A8TMOF <> *ZEROS AND
     C                             WCurDteTme = 'Y'
     C                   EVALR     WUTCOffset = '0000' + %CHAR(A8TMOF)
     C                   ENDIF
      *
     C                   IF        A8SIGN <> *BLANKS AND
     C                             WCurDteTme = 'Y'
     C                   EVAL      WUTCOffSgn = A8SIGN
     C                   ENDIF

     C                   EVAL      WTmSt = %CHAR(TMST)
     C                   EVAL      WDate = %SUBST(WTmSt:3:2) +
     C                                     %SUBST(WTmSt:6:2) +
     C                                     %SUBST(WTmSt:9:2)
     C                   EVAL      WTime = %SUBST(WTmSt:12:2) +
     C                                     %SUBST(WTmSt:15:2)

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrFAmt - Format amount to SWIFT amount format                *
      *                                                               *
      *  Called by: SrExtract                                         *
      *                                                               *
      *  Calls    : AOCURRR0, ZM0040                                  *
      *                                                               *
      *****************************************************************
     C     SrFAmt        BEGSR

      *
      ** Define WAMTA
      *
     C                   MOVE      WIAmnt        WAmta

      *
      ** Access Currency details.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WICcy         PWCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '014'         DBASE
     C                   MOVEL     WICcy         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WOCcyS = A6SWCY
     C                   EVAL      WODecS = A6NBDP

      *
      ** Perform old processing if CSW020 is not switched on.
      *
     C                   IF        CSW020 <> 'Y'
      *
     C                   EVAL      X = 14 - A6NBDP
      *
      ** If 0 decimal places, don't edit.
      *
     C                   IF        A6NBDP = 0
     C                   EVAL      AMT = *BLANK
     C                   EVAL      AM = *ZEROS
     C                   MOVEA     WAmta         AMT(2)
     C                   MOVEA     WAmta         AM(1)
     C                   EVAL      W = 13
     C                   EVAL      AM(X) = ','
      *
     C                   ELSE
      *
      ** Move amount into array.
      *
     C                   MOVEA     WAmta         AMT(1)
      *
      ** Determine position of decimal digits in 2nd array.
      *
     C                   EVAL      Y = X + 1
      *
      ** Move decimal digits into 2nd array field.
      *
     C                   MOVEA     AMT(X)        AM(Y)
      *
      ** Determine position & move comma.
      *
     C                   EVAL      Y = Y - 1
     C                   EVAL      AM(Y) = ','
      *
      ** Determine position of digit before comma.
      *
     C                   EVAL      Y = Y - 1
      *
      ** Save position of digit before comma.
      *
     C                   EVAL      W = Y
      *
      ** Determine position of digit to be moved before comma.
      *
     C                   EVAL      X = X - 1
     C                   EVAL      Z = X
      *
      ** Move characters one by one from right to left.
      *
     C                   DO        X
     C                   EVAL      AM(Y) = AMT(Z)
     C                   EVAL      Z = Z - 1
     C                   EVAL      Y = Y - 1
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   EVAL      Y = 1
      *
      ** Replace leading zeros with blank.
      *
     C                   DOW       AM(Y) = '0' AND Y <> W
     C                   EVAL      AM(Y) = *BLANK
     C                   EVAL      Y = Y + 1
     C                   ENDDO
      *
      ** Save field from array.
      *
     C                   MOVEA     AM            AMX
     C                   EVAL      WOAmnt = AMX
      *
     C                   ELSE
      *
      ** If CSW020 is switched on, perform decimal places prosessing.
      *
     C                   CALL      'ZM0040'
     C                   PARM      WIAmnt        ZAMNT
     C                   PARM      WICcy         ZCCY
     C                   PARM      *BLANKS       ZSAMNT
     C                   PARM      *BLANKS       ZSCCY
     C                   PARM      *BLANKS       ZERR
      *
     C                   IF        ZERR = '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '015'         DBASE
     C                   MOVEL     WICCY         DBKEY
     C                   MOVEL     'ZM0040  '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C                   EVAL      WOAmnt = ZSAMNT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Left-justify amount.
      *
     C                   EVAL      WOAmnt = %TRIM(WOAmnt)
      *

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SrOMSG - output correctly generated messages                *
      *                                                               *
      *   Called by: SrExtract                                        *
      *                                                               *
      *   Calls    : SrWref                                           *
      *                                                               *
      *****************************************************************
      *
     C     SrOMSG        BEGSR

      ** Write reference record  (PF/MGOREFPD)

     C                   EXSR      SrWRef

     C/COPY WNCPYSRC,MG0600CCP6

      ** Write multiple occurrence data structure to MGOMSGPD

     C                   Z-ADD     1             Q
     C     Q             OCCUR     MULT

     C     Q             DOWLE     95
     C     MULT          ANDNE     *BLANKS
     C                   WRITE     MGOMSGD0                             06

     C/COPY WNCPYSRC,MG0600CCP7

      **  Error on write to PF/MGOMSGPD (message data file)

     C     *IN06         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '016'         DBASE
     C                   MOVEL     '        '    DBKEY
     C                   MOVEL     'MGOMSGPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/COPY WNCPYSRC,MG0600C005

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   ENDDO

      ** Write multiple occurrence data structure to MGOEXTPD
      * Temporarily excluded since i'm not sure if we need it.

     C*                  Z-ADD     1             V                 2 0
     C*    V             OCCUR     EXTN
     C*    V             DOWLE     20
     C*    MCSI          ANDNE     *BLANKS
     C*                  WRITE     MGOEXTD0                             06

      ** Error on write to PF/MGOEXTPD (message data extension file)

     C*    *IN06         IFEQ      '1'
     C*    *LOCK         IN        LDA
     C*                  MOVE      '027'         DBASE
     C*                  MOVEL     '        '    DBKEY
     C*                  MOVEL     'MGOEXTPD'    DBFILE
     C*                  OUT       LDA
     C*                  EXSR      *PSSR
     C*                  ENDIF
     C*                  ADD       1             V
     C*    V             OCCUR     EXTN
     C*                  ENDDO

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SrWREF - Write reference record to PF/MGOREFPD              *
      *                                                               *
      *   Called by: SrOMSG                                           *
      *                                                               *
      *   Calls    : None                                             *
      *                                                               *
      *****************************************************************
     C     SrWREF        BEGSR

     C                   MOVE      *BLANKS       SYTM
     C                   MOVEL     'FT'          MODI
     C                   MOVEL     WTRNo         TRNO
     C                   MOVE      *BLANKS       TRNF
     C                   MOVE      *BLANKS       TRNM
     C                   MOVEL     WTrnId        MTRN
     C                   MOVE      WPyTp         TNTP
     C                   MOVE      WPySt         SBTP
     C                   MOVE      *BLANKS       EVTP
     C                   MOVEL     WSeCN         SECN
     C                   MOVE      *BLANKS       DECN
     C                   MOVEL     WReceiver     NWDS
     C                   MOVEL     WSnCsID       NWSN
     C                   MOVEL     WBnCs         NWBN
     C                   MOVE      'SWIFT'       NWRK
     C                   MOVE      '199'         MTPY
     C                   MOVE      'N'           MPRY
     C                   MOVEL     *BLANKS       LSCC
     C                   MOVEL     *BLANKS       PTST
     C                   MOVEL     *BLANKS       CARQ
     C                   MOVEL     *BLANKS       MPDE
     C                   MOVEL     WTag20b       HRDT
     C                   TIME                    MGTM
     C                   MOVE      BJMRDT        LADT
     C                   MOVE      MGTM          LATM
      * The next 2 fields are in FT0640 but not in MG000600
     C                   MOVE      ZDATE         MGDE
      *
      ** Set-up Message Generation  Century flag
      *
     C                   MOVEL     MGDE          YY
     C                   IF        YY < 72
     C                   EVAL      CIND = '2'
     C                   ELSE
     C                   EVAL      CIND = '1'
     C                   ENDIF

     C     MGST          IFEQ      'RSND'
     C                   MOVE      BJMRDT        RELD
     C                   MOVE      MGTM          RELT
     C                   ENDIF

     C                   MOVEL     WTag20b       SVDT
     C                   MOVEL     WICcy         CCY

     C                   IF        FTM199 = 'H' OR
     C                             FTM199 = 'A' OR
     C                             FTM199 = 'T'
     C                   MOVE      'I'           AORR
     C                   ELSE
     C                   MOVE      'D'           AORR
     C                   ENDIF

      *
      ** Setup century indicator CINDV for value date SVDT
      *
     C     SVDT          IFEQ      *BLANK
     C                   MOVE      *BLANK        CINDV
     C                   ELSE
     C                   MOVEL     SVDT          YY
     C     YY            IFLT      72
     C                   MOVE      '2'           CINDV
     C                   ELSE
     C                   MOVE      '1'           CINDV
     C                   ENDIF
     C                   ENDIF

     C                   MOVEL     *BLANKS       NSNO
     C                   MOVEL     *BLANKS       SACN
     C                   MOVEL     *BLANKS       DESI

     C                   MOVEL     *BLANKS       RUSR
     C                   MOVEL     *BLANKS       RWSN
     C                   MOVEL     *BLANKS       AMTS
     C                   MOVEL     *BLANKS       AMTX

      ** Branch details

     C                   MOVE      WBrCA         BRCA
      * Not sure. Since we're sending MT199, should there be ordering branch?
     C                   MOVE      *BLANKS       OTHB

     C                   MOVE      *BLANKS       NETI
     C                   MOVE      *BLANKS       DELC
     C                   MOVE      *BLANKS       DYST
     C                   MOVE      *BLANKS       RSID
     C                   MOVE      *BLANKS       MSE1
     C                   MOVE      *BLANKS       ELIN
     C                   MOVE      *BLANKS       SSAC
     C                   MOVE      *BLANKS       MIR
     C                   MOVE      *BLANKS       TSKS
     C                   MOVE      *BLANKS       TSKY

      * TEMPORARILY COMMENTED OUT BECAUSE OF RECURRING PASSWORD PROMPTS
     C*COPY WNCPYSRC,MG0600C035

     C                   WRITE     MGOREFD0                             05

      ** Error on write to PF/MGOREFPD (message reference file)

     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '015'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'MGOREFPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   *PSSR - Error handling                                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

      **  Write database error to report

     C                   OPEN      FT000199AU
     C                   WRITE     HEADER
     C                   WRITE     DBERROR

     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
