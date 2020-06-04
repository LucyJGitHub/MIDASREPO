     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
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
      *  Last Amend No. MD055939           Date 03Jun20               *
      *  Prev Amend No. MD055900           Date 28May20               *
      *                 MD055883           Date 22May20               *
      *                 CSW220  *CREATE    Date 09Mar20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055939 - MT199 ACCC & ACSP Field 79 Line 4 Currency should *
      *             get its value from Transaction                    *
      *           - Amount for MT199 Transferred should Include       *
      *             deduction from charges                            *
      *  MD055900 - Revert changes of MD055883                        *
      *  MD055883 - Field 79 Line 3 is not displaying "/" when        *
      *             Destination do not have a BIC defined             *
      *  CSW220 - SWIFT Changes 2020                                  *
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
                                                                                            MD055939
      ** Outgoing Payments Details Extension File                                           MD055939
     FOTPAYXL0  IF   E           K DISK    INFSR(*PSSR)                                     MD055939

      ** Incoming payments details
     FINPAY     IF   E           K DISK    INFSR(*PSSR)
                                                                                            MD055939
      ** Incoming Payments Details Extension File                                           MD055939
     FINPAYXL0  IF   E           K DISK    INFSR(*PSSR)                                     MD055939

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
     D StsACCC         C                   CONST('//ACCC')
     D StsRJCT         C                   CONST('//RJCT/MS03')
     D StsACSPH        C                   CONST('//ACSP/G002')
     D StsACSPT        C                   CONST('//ACSP/G001')

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
     D  WUSRID                 1     10
     D  WDFBR                 11     13
     D  WDPPT                 14     16

      *
      ** Arrays for formatting Swift Amount
      *
      ** Amount Array
     D AMT             S              1A   DIM(13)
      ** Edited Amount Array
     D AM              S              1A   DIM(14)
      ** Left Adjust Amount Array
     D FAMT            S              1A   DIM(15)

      ** External data structure for bank file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Data structure for SAR - Switchable features file                                 MD055939
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD055939

      ** External data structure for nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** External data structure for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External data structure for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
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
     D WTag121Val      S             36A
     D WTag20Val       S             16A
     D WTag21Val       S             15A
     D WTag79L1Val     S             17A
     D WTag79L2Val     S             11A
     D WTag79L3Val     S             27A
     D WTag79L4Val     S             22A

      ** Work Variables
     D WIPRef          S             15A
     D WOPRef          S             15A
     D WSender         S             12A
     D WReceiver       S             12A
     D WTag20a         S              8A
     D WTag20b         S              6A
     D WTag79L3a       S             14A
     D WTag79L3b       S             13A
     D WGenFlg         S              1A
     D WIOFlg          S              1A                                                    MD055939
     D CR              S              1A
     D LF              S              1A
     D CRLF            S              2A

      ** Variables for getting SWIFT BIC of destination
     D WDstT           S              1A
     D WDst1           S             35A
     D WSWIFT          S             11A
     D WCNum           S             10A
     D WKey            S              5A
     D PACCD           S             10A
     D @CUST           S              6A
     D @CYCD           S              3A
     D @ACSN           S              2A
     D @NONB           S              2A
     D @CSSN           S             10A
     D @PNOI           S              1A
     D @KEY1           S             10A
     D @KYST           S              7A

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
     D WIMCcy          S              3A                                                    MD055939
     D WChgs           S             13P 0                                                  MD055939
     D WMChgs          S             13P 0                                                  MD055939
     D WNChgs          S             13P 0                                                  MD055939
     D WRChgs          S             13P 0                                                  MD055939

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
     D WPyTp           S              2A
     D WPySt           S              2A
     D WBnCs           S             35A
     D WSeCN           S              6A
     D WBrCA           S              3A

      ** Parameters for calling Standing Data
     D @BRCD           S              3A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @SARD           S              6A                                                    MD055939
                                                                                            MD055939
      ** Variables for Switchable Features                                                  MD055939
     D S01494          S              1A                                                    MD055939
     D S01499          S              1A                                                    MD055939
     D CFT009          S              1A                                                    MD055939
     D CFT014          S              1A                                                    MD055939

      ** Variable for accessing TABFP
     D ZTABKY          S             12A

      ** Temporary Variables
     D YY              S              2P 0
     D @HRDT           S              6A

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

      *                                                                                     MD055939
      ** Access Switchable Features file for S01494                                         MD055939
      *                                                                                     MD055939
     C                   CALL      'AOSARDR0'                                               MD055939
     C                   PARM      *BLANKS       @RTCD                                      MD055939
     C                   PARM      '*VERIFY'     @OPTN                                      MD055939
     C                   PARM      'S01494'      @SARD                                      MD055939
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD055939
                                                                                            MD055939
     C     @RTCD         IFNE      *BLANKS                                                  MD055939
     C     @RTCD         ANDNE     '*NRF   '                                                MD055939
     C     *LOCK         IN        LDA                                                      MD055939
     C                   MOVE      '021'         DBASE                                      MD055939
     C                   MOVEL     @SARD         DBKEY                                      MD055939
     C                   MOVEL     'SCSARDPD'    DBFILE                                     MD055939
     C                   OUT       LDA                                                      MD055939
     C                   EXSR      *PSSR                                                    MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
     C     @RTCD         IFEQ      *BLANKS                                                  MD055939
     C                   MOVEL     'Y'           S01494                                     MD055939
     C                   ELSE                                                               MD055939
     C                   MOVEL     'N'           S01494                                     MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
      *                                                                                     MD055939
      ** Access Switchable Features file for S01499                                         MD055939
      *                                                                                     MD055939
     C                   CALL      'AOSARDR0'                                               MD055939
     C                   PARM      *BLANKS       @RTCD                                      MD055939
     C                   PARM      '*VERIFY'     @OPTN                                      MD055939
     C                   PARM      'S01499'      @SARD                                      MD055939
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD055939
                                                                                            MD055939
     C     @RTCD         IFNE      *BLANKS                                                  MD055939
     C     @RTCD         ANDNE     '*NRF   '                                                MD055939
     C     *LOCK         IN        LDA                                                      MD055939
     C                   MOVE      '022'         DBASE                                      MD055939
     C                   MOVEL     @SARD         DBKEY                                      MD055939
     C                   MOVEL     'SCSARDPD'    DBFILE                                     MD055939
     C                   OUT       LDA                                                      MD055939
     C                   EXSR      *PSSR                                                    MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
     C     @RTCD         IFEQ      *BLANKS                                                  MD055939
     C                   MOVEL     'Y'           S01499                                     MD055939
     C                   ELSE                                                               MD055939
     C                   MOVEL     'N'           S01499                                     MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
      *                                                                                     MD055939
      ** Access Switchable Features file for CFT009                                         MD055939
      *                                                                                     MD055939
     C                   CALL      'AOSARDR0'                                               MD055939
     C                   PARM      *BLANKS       @RTCD                                      MD055939
     C                   PARM      '*VERIFY'     @OPTN                                      MD055939
     C                   PARM      'CFT009'      @SARD                                      MD055939
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD055939
                                                                                            MD055939
     C     @RTCD         IFNE      *BLANKS                                                  MD055939
     C     @RTCD         ANDNE     '*NRF   '                                                MD055939
     C     *LOCK         IN        LDA                                                      MD055939
     C                   MOVE      '023'         DBASE                                      MD055939
     C                   MOVEL     @SARD         DBKEY                                      MD055939
     C                   MOVEL     'SCSARDPD'    DBFILE                                     MD055939
     C                   OUT       LDA                                                      MD055939
     C                   EXSR      *PSSR                                                    MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
     C     @RTCD         IFEQ      *BLANKS                                                  MD055939
     C                   MOVEL     'Y'           CFT009                                     MD055939
     C                   ELSE                                                               MD055939
     C                   MOVEL     'N'           CFT009                                     MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
      *                                                                                     MD055939
      ** Access Switchable Features file for CFT014                                         MD055939
      *                                                                                     MD055939
     C                   CALL      'AOSARDR0'                                               MD055939
     C                   PARM      *BLANKS       @RTCD                                      MD055939
     C                   PARM      '*VERIFY'     @OPTN                                      MD055939
     C                   PARM      'CFT014'      @SARD                                      MD055939
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD055939
                                                                                            MD055939
     C     @RTCD         IFNE      *BLANKS                                                  MD055939
     C     @RTCD         ANDNE     '*NRF   '                                                MD055939
     C     *LOCK         IN        LDA                                                      MD055939
     C                   MOVE      '024'         DBASE                                      MD055939
     C                   MOVEL     @SARD         DBKEY                                      MD055939
     C                   MOVEL     'SCSARDPD'    DBFILE                                     MD055939
     C                   OUT       LDA                                                      MD055939
     C                   EXSR      *PSSR                                                    MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
     C     @RTCD         IFEQ      *BLANKS                                                  MD055939
     C                   MOVEL     'Y'           CFT014                                     MD055939
     C                   ELSE                                                               MD055939
     C                   MOVEL     'N'           CFT014                                     MD055939
     C                   ENDIF                                                              MD055939

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
     C     WIPRef        CHAIN     INPAY

     C                   IF        %FOUND
      *
      ** Check if IPAY transaction is Authorised
      *
     C                   IF        AUIN = 'Y'

     C                   EVAL      WTag79L2Val = StsACCC
     C                   EVAL      WCurDTFlg = 'N'
     C                   EVAL      WIOFlg = 'I'                                             MD055939
     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ENDIF

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '006'         DBASE
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
     C     WOPRef        CHAIN     OTPAY

     C                   IF        %FOUND

     C                   IF        AUIN = 'Y'

     C                   EVAL      WTag79L2Val = StsACSPT
     C                   EVAL      WDstT = DSTT
     C                   EVAL      WDst1 = DST1
     C                   EVAL      WIOFlg = 'O'                                             MD055939
     C**********         EVAL      WTag79L3b = '/'                                 MD055883 MD055900
     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ENDIF

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '007'         DBASE
     C                   MOVEL     'WOPref'      DBKEY
     C                   MOVEL     'OTPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      *
      ** MT199 Status is RJCT
      *
     C                   ELSEIF    FTM199 = 'R'

     C                   EVAL      WTag79L2Val = StsRJCT

     C                   EXSR      SrSvCmFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

      *
      ** MT199 Status is ACSP (On-Hold)
      *
     C                   ELSEIF    FTM199 = 'H' AND PCob = 'Y'

     C                   EVAL      WTag79L2Val = StsACSPH
      ** Transaction is held in OPAY
     C                   IF        FTOPRF <> *BLANKS
     C                   EVAL      WOPRef = FTOPRF
     C     WOPRef        CHAIN     OTPAY

     C                   IF        %FOUND

     C                   EVAL      WIOFlg = 'O'                                             MD055939
     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '008'         DBASE
     C                   MOVEL     'WOPref'      DBKEY
     C                   MOVEL     'OTPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF
      ** Transaction is held in IPAY
     C                   ELSEIF    FTIPRF <> *BLANKS
     C                   EVAL      WIPRef = FTIPRF
     C     WIPRef        CHAIN     INPAY

     C                   IF        %FOUND

     C                   EVAL      WIOFlg = 'I'                                             MD055939
     C                   EXSR      SrSvPyFld
     C                   EXSR      SRExtract
     C                   EVAL      WGenFlg = 'Y'

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '009'         DBASE
     C                   MOVEL     'WIPref'      DBKEY
     C                   MOVEL     'INPAY'       DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF
      ** Transaction is held in FTMG
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
     C                   MOVE      '010'         DBASE
     C                   MOVEL     'FTM199'      DBKEY
     C                   MOVEL     'MEINFTL6'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** COMMIT all changes since no error on writing the message

     C                   COMMIT

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

      *
      ** Reset work Variables
      *
     C                   EVAL      WIPRef = *BLANKS
     C                   EVAL      WOPRef = *BLANKS
     C                   EVAL      WSender = *BLANKS
      ** WReceiver not blanked since its value comes from system value
     C                   EVAL      WTag20a = *BLANKS
      ** WTag20b not blanked since it is the rundate
     C                   EVAL      WTag79L3a = *BLANKS
     C                   EVAL      WTag79L3b = *BLANKS
     C                   EVAL      WGenFlg = *BLANKS
     C                   EVAL      WIOFlg = *BLANKS                                         MD055939

      *
      ** Reset variables for getting SWIFT BIC of destination
      *
     C                   EVAL      WDstT = *BLANKS
     C                   EVAL      WDst1 = *BLANKS
     C                   EVAL      WSWIFT = *BLANKS
     C                   EVAL      WCNum = *BLANKS
     C                   EVAL      WKey = *BLANKS

      *
      ** Reset variables for getting formatted SWIFT date and time
      *
     C                   EVAL      WCurDTFlg = 'Y'
     C                   EVAL      WTmSt = *BLANKS
     C                   EVAL      WDate = *BLANKS
     C                   EVAL      WTime = '0000'
     C                   EVAL      WUTCOffset = '0000'
     C                   EVAL      WUTCOffSgn = '+'

      *
      ** Reset variables for getting formatted SWIFT amount
      *
     C                   EVAL      WICcy = *BLANKS
     C                   EVAL      WIAmnt = *ZEROS
     C                   EVAL      WOCcy = *BLANKS
     C                   EVAL      WOAmnt = *BLANKS
     C                   EVAL      WIMCcy = *BLANKS                                         MD055939
     C                   EVAL      WChgs = *ZEROS                                           MD055939
     C                   EVAL      WMChgs = *ZEROS                                          MD055939
     C                   EVAL      WNChgs = *ZEROS                                          MD055939
     C                   EVAL      WRChgs = *ZEROS                                          MD055939
      *
      ** Clear arrays for formatting Swift Amount
      *
     C                   CLEAR                   AMT
     C                   CLEAR                   AM
     C                   CLEAR                   FAMT

      *
      ** Reset variables for writing MGOREFPD
      *
     C                   EVAL      WTRNo = *BLANKS
     C                   EVAL      WTrnId = *BLANKS
     C                   EVAL      WPyTp = *BLANKS
     C                   EVAL      WPySt = *BLANKS
     C                   EVAL      WBnCs = *BLANKS
     C                   EVAL      WSeCN = *BLANKS
     C                   EVAL      WBrCA = *BLANKS

      *
      ** Clear multiple occurrence data structure
      *
     C                   CLEAR     *ALL          MULT
     C                   EVAL      Q = 0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSvPyFld   - Saves fields from OPAY/IPAY to work variables   *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      **Calls:*None****************************************************                     MD055939
      * Calls: SrCalcChgs                                             *                     MD055939
      *                                                               *
      *****************************************************************
     C     SrSvPyFld     BEGSR

     C                   EVAL      WBrCA = BRCA
     C                   EVAL      WBnCs = BNC1
     C                   EVAL      WTrnId = PREF
     C                   EVAL      WPyTp = PYTP
     C                   EVAL      WPySt = PYST
     C                   EVAL      WIAmnt = PYAM
     C                   EVAL      WICcy = PCCY                                             MD055939
                                                                                            MD055939
     C                   IF        ADDC = 'D' AND CDRO = *BLANKS                            MD055939
     C                   EXSR      SrCalcChgs                                               MD055939
     C                   EVAL      WIAmnt = WIAmnt - WChgs + WRChgs                         MD055939
     C                   ENDIF                                                              MD055939

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
      *****************************************************************                     MD055939
      /EJECT                                                                                MD055939
      *****************************************************************                     MD055939
      *                                                               *                     MD055939
      * SrCalcChgs  - Calculate Charges to be deducted from pay amount*                     MD055939
      *             - Used for setting value of Tag 79 Line 4         *                     MD055939
      *                                                               *                     MD055939
      * Called by: SrSvPyFld                                          *                     MD055939
      *                                                               *                     MD055939
      * Calls: SrNewChgs                                              *                     MD055939
      *                                                               *                     MD055939
      *****************************************************************                     MD055939
     C     SrCalcChgs    BEGSR                                                              MD055939
                                                                                            MD055939
      *                                                                                     MD055939
      ** Charges for both IPAY and OPAY                                                     MD055939
      *                                                                                     MD055939
     C     TRCM          ADD       TXCH          WChgs                                      MD055939
     C                   ADD       CQCH          WChgs                                      MD055939
     C                   ADD       MSCH          WChgs                                      MD055939
      *                                                                                     MD055939
      ** Charges only for OPAY                                                              MD055939
      *                                                                                     MD055939
     C                   IF        WIOFlg = 'O'                                             MD055939
     C                   ADD       CSTA          WChgs                                      MD055939
     C                   ADD       SPCH          WChgs                                      MD055939
      *                                                                                     MD055939
     C     S01494        IFEQ      'Y'                                                      MD055939
     C                   ADD       OPCHCM        WChgs                                      MD055939
     C                   ENDIF                                                              MD055939
      *                                                                                     MD055939
     C     S01499        IFEQ      'Y'                                                      MD055939
     C                   ADD       OPVATT        WChgs                                      MD055939
     C                   ENDIF                                                              MD055939
      *                                                                                     MD055939
      ** Charges only for IPAY                                                              MD055939
      *                                                                                     MD055939
     C                   ELSE                                                               MD055939
     C                   ADD       ADCH          WChgs                                      MD055939
     C                   ADD       TLCH          WChgs                                      MD055939
      *                                                                                     MD055939
     C     S01494        IFEQ      'Y'                                                      MD055939
     C                   ADD       INCHCM        WChgs                                      MD055939
     C                   ENDIF                                                              MD055939
      *                                                                                     MD055939
     C     S01499        IFEQ      'Y'                                                      MD055939
     C                   ADD       INVATT        WChgs                                      MD055939
     C                   ENDIF                                                              MD055939
      *                                                                                     MD055939
     C                   ENDIF                                                              MD055939
      *                                                                                     MD055939
      ** If CFT009 is on, new charges are added                                             MD055939
      *                                                                                     MD055939
     C     CFT009        IFEQ      'Y'                                                      MD055939
     C                   EXSR      SrNewChgs                                                MD055939
     C                   ADD       WNChgs        WChgs                                      MD055939
     C                   ENDIF                                                              MD055939
     C                                                                                      MD055939
                                                                                            MD055939
     C                   ENDSR                                                              MD055939
      *****************************************************************                     MD055939
      /EJECT                                                                                MD055939
      *****************************************************************                     MD055939
      *                                                               *                     MD055939
      * SrNewChgs   - Calculate New Charges                           *                     MD055939
      *                                                               *                     MD055939
      * Called by: SrCalcChgs                                         *                     MD055939
      *                                                               *                     MD055939
      * Calls: None                                                   *                     MD055939
      *                                                               *                     MD055939
      *****************************************************************                     MD055939
     C     SrNewChgs     BEGSR                                                              MD055939
                                                                                            MD055939
     C                   SELECT                                                             MD055939
     C                   WHEN      WIOFlg = 'O'                                             MD055939
     C     PREF          CHAIN     OTPAYXL0                                                 MD055939
      *                                                                                     MD055939
     C                   IF        %FOUND                                                   MD055939
     C     SWSCHG        ADD       MISC01        WMChgs                                     MD055939
     C                   ADD       MISC02        WMChgs                                     MD055939
     C                   ADD       MISC03        WMChgs                                     MD055939
     C                   ADD       MISC04        WMChgs                                     MD055939
     C                   ADD       MISC05        WMChgs                                     MD055939
      *                                                                                     MD055939
     C                   Z-ADD     WMChgs        WNChgs                                     MD055939
      *                                                                                     MD055939
      ** Add Receiver's Charges Remitted from the extension file.                           MD055939
      *                                                                                     MD055939
     C     CFT014        IFEQ      'Y'                                                      MD055939
     C                   ADD       OPRCRM        WRChgs                                     MD055939
     C                   ENDIF                                                              MD055939
      *                                                                                     MD055939
     C                   ELSE                                                               MD055939
     C     *LOCK         IN        LDA                                                      MD055939
     C                   MOVE      '025'         DBASE                                      MD055939
     C                   MOVEL     'PREF'        DBKEY                                      MD055939
     C                   MOVEL     'OTPAYXL0'    DBFILE                                     MD055939
     C                   OUT       LDA                                                      MD055939
     C                   ENDIF                                                              MD055939
      *                                                                                     MD055939
     C                   WHEN      WIOFlg = 'I'                                             MD055939
     C     PREF          CHAIN     INPAYXL0                                                 MD055939
      *                                                                                     MD055939
     C                   IF        %FOUND                                                   MD055939
     C     MSC01         ADD       MSC02         WMChgs                                     MD055939
     C                   ADD       MSC03         WMChgs                                     MD055939
     C                   ADD       MSC04         WMChgs                                     MD055939
     C                   ADD       MSC05         WMChgs                                     MD055939
      *                                                                                     MD055939
     C                   Z-ADD     WMChgs        WNChgs                                     MD055939
      *                                                                                     MD055939
      ** Add Receiver's Charges Remitted from the extension file.                           MD055939
      *                                                                                     MD055939
     C     CFT014        IFEQ      'Y'                                                      MD055939
     C                   ADD       INRCRM        WRChgs                                     MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
     C                   ELSE                                                               MD055939
     C     *LOCK         IN        LDA                                                      MD055939
     C                   MOVE      '026'         DBASE                                      MD055939
     C                   MOVEL     'PREF'        DBKEY                                      MD055939
     C                   MOVEL     'INPAYXL0'    DBFILE                                     MD055939
     C                   OUT       LDA                                                      MD055939
     C                   ENDIF                                                              MD055939
                                                                                            MD055939
     C                   ENDSL                                                              MD055939
                                                                                            MD055939
     C                   ENDSR                                                              MD055939
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
      ** found in internet. need to test
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
      ** Get tag 21
      *
     C     KFMsgR        CHAIN     MEINMPL1
     C                   IF        %FOUND

     C                   EVAL      WTag21Val = MPTRNO

      *
      ** Use amount in incoming message if Pay Amount not set
      *
     C                   IF        WIAmnt = *ZEROS
     C                   EVAL      WOAmnt = MPAMTS
     C                   ENDIF

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     ':21:'        MTAG
     C                   MOVEL     WTag21Val     MFLD

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '012'         DBASE
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
      ** Save the value of Incoming Message Currency
     C**********         EVAL      WICcy = CRCYCD                                           MD055939
     C                   EVAL      WIMCcy = CRCYCD                                          MD055939

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '013'         DBASE
     C                   MOVEL     'KFMsgR'      DBKEY
     C                   MOVEL     'MEINCRL1'    DBFILE
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
     C                   MOVEL     WTag79L2Val   MFLD

      *
      ** Get tag 79 Line 3
      *
     C                   EVAL      WTag79L3a = '//' + WSender
     C                   EXSR      SrDstSwBIC
     C                   IF        WSWIFT <> *BLANKS
     C                   EVAL      WTag79L3b = '/' + WSWIFT
     C                   ENDIF
     C                   EVAL      WTag79L3Val = WTag79L3a + WTag79L3b

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L3Val   MFLD

      *
      ** Get tag 79 Line 4
      ** Amount comes from either incoming message or FT transaction
      *
     C                   IF        WOAmnt = *BLANKS
     C                   EXSR      SrFAMT
     C                   ENDIF
     C                   IF        WOCcy = *BLANKS
     C**********         EVAL      WOCcy = WICcy                                           MD055939
     C                   EVAL      WOCcy = WIMCcy                                           MD055939
     C                   ENDIF
     C                   EVAL      WTag79L4Val = '//' + WOCcy + WOAmnt

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L4Val   MFLD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDsTSwBIC  - Extracts SWIFT BIC of Destination if existing   *
      *                                                               *
      * Called By: VAL@S subroutine                                   *
      *                                                               *
      * Calls:                                                        *
      * AOCUSTR0  - Access Object to get customer details             *
      * AOBRCHR0  - Access Object to get branch details               *
      * ME1730    - Determines whether an MT103 exists                *
      *                                                               *
      *****************************************************************
     C     SrDsTSwBIC    BEGSR
      *
      ** Get SWIFT-BIC of destination
      *
     C                   IF        WDstT = 'S'
     C                   EVAL      WSWIFT = %SUBST(WDst1:1:11)
     C                   ENDIF
      *
      ** Destination type is a full nostro 'F', customer number 'C'
      ** retail account 'R' or GL account 'G', get SWIFT ID through
      ** customer number
      *
     C                   IF        (WDstT = 'F') Or (WDstT = 'C') Or
     C                             (WDstT = 'R') Or (WDstT = 'G')
      *
     C                   SELECT
     C                   WHEN      WDstT = 'F'
     C                   EVAL      @CYCD = %SUBST(WDst1:1:3)
     C                   EVAL      @NONB = %SUBST(WDst1:4:2)
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST
     C                   PARM                    @CYCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       @ACSN
     C                   PARM                    @NONB
     C                   PARM      *BLANKS       @BRCD
     C                   PARM      *BLANKS       @CSSN
     C                   PARM      *BLANKS       @PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
      *
      ** Error on CALL
      *
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   MOVEL     '014'         DBASE
     C                   MOVEL     @CYCD         WKey
     C                   MOVE      @NONB         WKey
     C                   MOVEL     WKey          DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     A7CUST        WCNum
      *
     C                   WHEN      WDstT = 'C'
     C                   EVAL      WCNum = %SUBST(WDst1:1:10)
      *
     C                   OTHER
     C                   EVAL      WCNum = %SUBST(WDst1:1:6)
     C                   ENDSL
      *
      ** Access customer's file to get SWIFT id
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNum         @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RTCD = *BLANKS
     C                   IF        BBCSID <> *BLANKS
     C                   MOVEL     BBCSID        WSWIFT
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '015'         DBASE
     C                   MOVEL     WCNum         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
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
     C                   PARM      SLDT          ZMDAY
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
      *  Called by: SrExtract                                         *
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

      ** Write multiple occurrence data structure to MGOMSGPD

     C                   Z-ADD     1             Q
     C     Q             OCCUR     MULT

     C     Q             DOWLE     95
     C     MULT          ANDNE     *BLANKS
     C                   WRITE     MGOMSGD0                             06

      **  Error on write to PF/MGOMSGPD (message data file)

     C     *IN06         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '019'         DBASE
     C                   MOVEL     '        '    DBKEY
     C                   MOVEL     'MGOMSGPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   ENDDO

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
     C                   MOVEL     WSender       NWSN
     C                   MOVEL     WBnCs         NWBN
     C                   MOVEL     'SWIFT'       NWRK
     C                   MOVE      '199'         MTPY
     C                   MOVE      'N'           MPRY
     C                   MOVEL     *BLANKS       LSCC
     C                   MOVEL     *BLANKS       PTST
     C                   MOVEL     *BLANKS       CARQ
     C                   MOVEL     *BLANKS       MPDE
     C                   MOVEL     @HRDT         HRDT
     C                   MOVE      WTag20b       MGDE
     C                   TIME                    MGTM
     C                   MOVE      BJMRDT        LADT
     C                   MOVE      MGTM          LATM
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

     C                   WRITE     MGOREFD0                             05

      ** Error on write to PF/MGOREFPD (message reference file)

     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '020'         DBASE
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
     C                   CLOSE     FT000199AU

     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
