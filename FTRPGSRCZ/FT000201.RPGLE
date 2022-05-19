     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MTn99 REJT Message Generation and Formatting')   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  FT000201 - Midas MTn99 REJT Message Generation and Formatting*
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CSW122A *CREATE    Date 04May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW122A  - SWIFT ISO 20022 CCR1 Generation of MTn99          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05 - Indicator for writing in MGOREFPD                     *
      *    06 - Indicator for writing in MGOMSGPD                     *
      *    10 - Indicator for chaining FT Standing Data               *
      *    15 - Indicator for determining success of ZM0060           *
      *    98 - Indicator for updating MEINFTPD                       *
      *    99 - Indicator for reading MEINFTL6                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Outgoing payments details
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)

      ** Outgoing Payments Details Extension File
     FOTPAYXL0  IF   E           K DISK    INFSR(*PSSR)

      ** Incoming payments details
     FINPAY     IF   E           K DISK    INFSR(*PSSR)

      ** Incoming Payments Details Extension File
     FINPAYXL0  IF   E           K DISK    INFSR(*PSSR)

      ** Incoming Message Control by Message Tag
     FMEINDTL0  IF   E           K DISK    INFSR(*PSSR)

      ** Incoming Message FT Data
     FMEINFTPD  IF   E           K DISK    INFSR(*PSSR)

      ** Joint File for retrieving records in FTMG
     FMEINMPJ1  IF   E           K DISK    INFSR(*PSSR)

      ** Logical File for retrieving MT199 sender
     FMEINCRL1  IF   E           K DISK    INFSR(*PSSR)

      ** Logical File for retrieving Incoming Message Transaction Number
     FMEINMPL1  IF   E           K DISK    INFSR(*PSSR)

      ** Logical file for retrieving FT Standing Data
     FTABFP     IF   E           K DISK    IGNORE(TABTB20F:TABTG20F)
     F                                     IGNORE(TABLETHF:TABLETPF)
     F                                     IGNORE(TABLET5F:TABTE10F)
     F                                     INFSR(*PSSR)

      ** Retail Accounts file
     FACNUMA    IF   E           K DISK    RENAME(ACCNTABF:ACNUMAF)

      ** New Logical file that will filter MT199
     FMEINFTL6  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Outgoing Message Reference File
     FMGOREFPD  O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Outgoing Message File
     FMGOMSGPD  O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas MT199 Msg Extraction and Formatting Audit Rpt
     FFT000199AUO    E             PRINTER USROPN INFSR(*PSSR)

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
     D SValK2          C                   CONST('GenMTn99OnIgnore')
     D StsRJCT         C                   CONST('//RJCT/MS03')
     D RsnCode         C                   CONST('/REJT/')
     D FldNumber       C                   CONST('99')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

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
     D  WDFBR                 11     13

      ** External data structure for bank file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Data structure for SAR - Switchable features file
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External data structure for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

     D  QQDFA1       E                     EXTFLD(QQDFAC)

      **  Data structure for message management data.
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)

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
     D PGenFlg         S              1A
     D PMsgr           S              8P 0

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
     D WTag121Val      S             36A
     D WTag70Val       S             35A
     D WTag20Val       S             16A
     D WTag79L1Val     S             35A
     D WTag79L2Val     S             35A
     D WTag79L3Val     S             35A
     D WTag79L4Val     S             35A

      ** Work Variables
     D WReceiver       S             12A
     D WTag20a         S              8A
     D WTag20b         S              6A
     D WTag79L3a       S              6A
     D WTag79L3b       S             16A
     D CR              S              1A
     D LF              S              1A
     D CRLF            S              2A

      ** Variables for getting SWIFT BIC of destination
     D WSWIFT          S             11A

      ** Variables for getting formatted SWIFT date and time
     D WCurDTFlg       S              1A   INZ('Y')
     D WCurTmst        S              6S 0
     D WCurTmstC       S              6A
     D WCurTme         S              4A
     D WTmSt           S             26A
     D WDate           S              6A
     D WTime           S              4A   INZ('0000')
     D WUTCOffset      S              4A   INZ('0000')
     D WUTCOffSgn      S              1A   INZ('+')

      ** Parameters for converting Midas rundate YYMMDD format .
     D ZMDAY           S              5P 0
     D ZMDATE          S              6A

      ** Variables for getting formatted SWIFT amount
     D WICcy           S              3A
     D WIAmnt          S             13P 0
     D WOCcy           S              3A
     D WOAmnt          S             17A
     D WIMCcy          S              3A
     D WChgs           S             13P 0
     D WMChgs          S             13P 0
     D WNChgs          S             13P 0
     D WRChgs          S             13P 0

      ** Result fields of Swift Format Currency
     D ZAMNT           S             13P 0
     D ZCCY            S              3A
     D ZSAMNT          S             17A
     D ZSCCY           S              3A
     D ZERR            S              1A

      ** Variables for writing MGOREFPD
      * Transaction Ref. Number
     D WTRNo           S             16A
     D WTrnId          S             15A
     D WSeCN           S              6A
     D WBrCA           S              3A

      ** Parameters for calling Standing Data
     D @BRCD           S              3A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @SARD           S              6A

      ** Variables for Switchable Features
     D S01494          S              1A
     D S01499          S              1A
     D CFT009          S              1A
     D CFT014          S              1A
     D CSW122          S              1A

      ** Variable for accessing TABFP
     D ZTABKY          S             12A

      ** Temporary Variables
     D YY              S              2P 0
     D @HRDT           S              6A
     D WMTPY           S              3A

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

     C                   RETURN
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
     C                   PARM                    PMsgR
     C                   PARM                    PGenFlg

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
     C                   PARM      SValK2        PSValK2
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

     C                   IF        PSVal2 = '*NRF  '
     C                   MOVE      '001'         DBASE
     C                   MOVEL     SValK2        DBKEY
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

      ** Access SDMGMEPD for message management data.

     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMGME        PARM      SDMGME        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDMGMEPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
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

      **  Initialise constant fields

     C                   MOVE      *LOVAL        CR
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF
     C                   BITON     '257'         LF
     C                   MOVEL     CR            CRLF
     C                   MOVE      LF            CRLF

      ** CRLF Control Character for message data records

     C                   MOVE      CRLF          CTRC

      ** Default the message status whith the ICD.

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
      ** Convert run date to YYMMDD, for Message Generation Date
      *
     C                   CALL      'ZM0060'                             15
     C                   PARM      BJRDNB        ZMDAY
     C                   PARM                    ZMDATE

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0060'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZMDATE        WTag20b

      ** Convert history retention date to YYMMDD

     C     BJRDNB        ADD       ENDSMN        ZMDAY
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY
     C                   PARM                    ZMDATE

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0060'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZMDATE        @HRDT

      *
      ** Access Switchable Features file for S01494
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01494'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      '021'         DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           S01494
     C                   ELSE
     C                   MOVEL     'N'           S01494
     C                   ENDIF

      *
      ** Access Switchable Features file for S01499
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01499'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      '022'         DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           S01499
     C                   ELSE
     C                   MOVEL     'N'           S01499
     C                   ENDIF

      *
      ** Access Switchable Features file for CFT009
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      '023'         DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT009
     C                   ELSE
     C                   MOVEL     'N'           CFT009
     C                   ENDIF

      *
      ** Access Switchable Features file for CFT014
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      '024'         DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT014
     C                   ELSE
     C                   MOVEL     'N'           CFT014
     C                   ENDIF
      *
      ** Access Switchable Features file for CSW122
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW122'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      '024'         DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CSW122
     C                   ELSE
     C                   MOVEL     'N'           CSW122
     C                   ENDIF

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

     C                   EVAL      KFMsgR = PMsgR
      *
      ** If CSW122 is switched on, do processing for MT199UC.
      *
     C                   IF        CSW122 = 'Y'
     C                   EXSR      SRExtract103
     C                   ENDIF

     C                   EVAL      PGenFlg = 'Y'

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

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExtract103- Extract details for MT103                       *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      * Calls: SrFmDtTm, SrFAMT                                       *
      *                                                               *
      *****************************************************************

     C     SrExtract103  BEGSR

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
     C                   MOVE      '011'         DBASE
     C                   MOVEL     'KLIncMsg'    DBKEY
     C                   MOVEL     'MEINDTL0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** Get tag 20
      *
     C                   EVAL      Wtag20a = %CHAR(KFMsgR)
     C                   EVALR     Wtag20a = '00000000' + %TRIM(Wtag20a)
     C                   EVAL      WTag20Val = 'P' + WTag20a + WTag20b
     C                   EVAL      WTRNo = WTag20Val

      *
      ** If the transaction has no Payment Reference, default tag 20 to MTRN
      *
     C                   IF        WTrnId = *BLANKS
     C                   EVAL      WTrnId = WTRNo
     C                   ENDIF

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':20:'        MTAG
     C                   MOVEL     WTag20Val     MFLD

      *
      ** Get tag 79 Line 1
      *
     C                   EVAL      WTag79L1Val = RsnCode + FldNumber

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':79:'        MTAG
     C                   MOVEL     WTag79L1Val   MFLD

      *
      ** Get tag 79 Line 2
      *
     C                   EVAL      WTag79L2Val = '/XT99/' + 'MS03/'

      *
      ** Store tag 79 Line 2; Identified before entering this subroutine
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L2Val   MFLD

      *
      ** Get tag 79 Line 3
      *
     C                   EVAL      WTag79L3a = '/MREF/'
     C                   EVAL      WTag79L3b = WTRNo
     C                   EVAL      WTag79L3Val = WTag79L3a + WTag79L3b

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L3Val   MFLD

      *
      ** Get tag 70
      *
     C                   EVAL      KFMtag = ':70:'
     C     KLIncMsg      CHAIN     MEINDTL0
     C                   IF        %FOUND
     C                   EVAL      WTag70Val = DTMFLD

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':70:'        MTAG
     C                   MOVEL     WTag70Val     MFLD

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '011'         DBASE
     C                   MOVEL     'KLIncMsg'    DBKEY
     C                   MOVEL     'MEINDTL0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** Get tag 79 Line 4
      *
     C                   EVAL      WTag79L4Val = '/TREF/' + WTag70Val
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L4Val   MFLD

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrFmDtTm - Format Date and Time for Tag 79 Line 1            *
      *                                                               *
      *  Called by: SrExtract103                                      *
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
     C                   MOVE      '016'         DBASE
     C                   MOVEL     WBrCA         DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save the Branch Customer
     C                   EVAL      WSeCN = A8BICN

      ** Get current date from timestamp
     C                   TIME                    WCurTmst
     C                   EVALR     WCurTmstC = '000000' + %CHAR(WCurTmst)
      ** If Tag 79 Line 1 doesn't use current time
     C                   IF        WCurDTFlg = 'N'

      ** Convert transaction settlement date to YYMMDD
     C                   CALL      'ZM0060'                             15
     C                   PARM      PVDT          ZMDAY
     C                   PARM                    ZMDATE

     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '017'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0060'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZMDATE        WDate

     C                   EVAL      WTmSt = %CHAR(TMST)

      ** If message is sent on the same day as the transaction, use the transaction's timestamp
      ** Else default to '0000+0000'
     C                   IF        WDate = WTag20b
     C                   EVAL      WTime = %SUBST(WTmSt:12:2) +
     C                                     %SUBST(WTmSt:15:2)

     C                   IF        A8SIGN <> *BLANKS
     C                   EVAL      WUTCOffSgn = A8SIGN
     C                   ENDIF
     C                   EVALR     WUTCOffset = '0000' + %CHAR(A8TMOF)
     C                   ENDIF
      ** Else Tag 79 Line 1 uses current timestamp
     C                   ELSE

     C                   EVAL      WDate = WTag20b
     C                   EVAL      WCurTme = %SUBST(WCurTmstC:1:4)
     C                   EVAL      WTime = WCurTme
     C                   IF        A8SIGN <> *BLANKS
     C                   EVAL      WUTCOffSgn = A8SIGN
     C                   ENDIF
     C                   EVALR     WUTCOffset = '0000' + %CHAR(A8TMOF)

     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrFAmt - Format amount to SWIFT amount format                *
      *                                                               *
      *  Called by: SrExtract103                                      *
      *                                                               *
      *  Calls    : AOCURRR0, ZM0040                                  *
      *                                                               *
      *****************************************************************
     C     SrFAmt        BEGSR

     C                   MOVE      WICcy         ZCCY
     C                   MOVE      WIAmnt        ZAMNT

     C                   CALL      'ZM0040'
     C                   PARM                    ZAMNT
     C                   PARM                    ZCCY
     C                   PARM                    ZSAMNT
     C                   PARM                    ZSCCY
     C                   PARM      ' '           ZERR

      ** Error - indicate erroneous fields

     C     ZERR          IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '018'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0040  '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WOCcy = ZSCCY
     C                   EVAL      WOAmnt = ZSAMNT
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
     C                   CLOSE     FT000199AU

     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
