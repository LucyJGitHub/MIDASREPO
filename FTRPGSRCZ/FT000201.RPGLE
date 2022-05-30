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
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Incoming Message Control by Message Tag
     FMEINDTL0  IF   E           K DISK    INFSR(*PSSR)

      ** Logical File for retrieving MT199 sender
     FMEINCRL1  IF   E           K DISK    INFSR(*PSSR)

      ** Logical File for Message Incoming Details by Message Tag
     FMEIN35L0  IF   E           K DISK    INFSR(*PSSR)

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

      ** External data structure for bank file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      **  Data structure for SAR - Switchable features file
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

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
     D PMtpy           S              3A
     D PBrCA           S              3A
     D PFTMsgR         S              8P 0
     D PFTKPRT         S              3P 0

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
     D KFTMsgR         S              8P 0
     D KFTKPRT         S              3P 0

      *
      ** Variables for storing the final value of tags
      *
     D WTag121Val      S             36A
     D WTag70Val       S             35A
     D WTag20Val       S             16A
     D WTag21Val       S             35A
     D WTag79L1Val     S             35A
     D WTag79L2Val     S             35A
     D WTag79L3Val     S             35A
     D WTag79L4Val     S             35A

      ** Work Variables
     D WSender         S             11A
     D WReceiver       S             12A
     D WBIC            S              8A
     D WBranch         S              3A
     D WTag20a         S              8A
     D WTag20b         S              6A
     D WTag79L3a       S              6A
     D WTag79L3b       S             16A
     D WTag202COV      S              1A
     D WTag205COV      S              1A
     D WGenFlg         S              1A

      ** Variables for writing MGOREFPD
      * Transaction Ref. Number
     D WTRNo           S             16A
     D WTrnId          S             15A
     D WPyTp           S              2A
     D WPySt           S              2A
     D WBnCs           S             35A
     D WSeCN           S              6A
     D WBrCA           S              3A

      ** Variables for getting formatted SWIFT amount
     D WICcy           S              3A

      ** Parameters for converting Midas rundate YYMMDD format .
     D ZMDAY           S              5P 0
     D ZMDATE          S              6A

      ** Parameters for calling Standing Data
     D @BRCD           S              3A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @SARD           S              6A

      ** Variables for Switchable Features
     D CSW122          S              1A

      ** Temporary Variables
     D YY              S              2P 0
     D @HRDT           S              6A

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
     C                   PARM                    PMtpy
     C                   PARM                    PBrCA
     C                   PARM                    PFTMsgR
     C                   PARM                    PFTKPRT

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
      ** Key List for MEINFTL0
      *
     C     KLMEFTL6      KLIST
     C                   KFLD                    KFTMsgR
     C                   KFLD                    KFTKPRT

      *
      ** Retrieve Swift Universal Tracker Address from System Values
      *

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SValK1        PSValK1
     C                   PARM                    PSVal1
     C                   PARM                    PSValK2
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

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRdIncMsg - Read Incoming Messages for MT199, MT299          *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SrExtract103, SRExtract202, SRExtract205, SrOMSG       *
      *                                                               *
      *****************************************************************

     C     SrRdIncMsg    BEGSR

     C                   EVAL      KFMsgR = PMsgR
     C                   EVAL      KFTMsgR = PFTMsgR
     C                   EVAL      KFTKPRT = PFTKPRT
     C                   EVAL      WBrCA = PBrCA

      ** If CSW122 is switched on, do processing for MT199UC.

     C                   IF        CSW122 = 'Y'

      ** Enter subroutine for different Message Type.

     C                   IF        PMtpy = '103'
     C                   EXSR      SRExtract103
     C                   EVAL      WGenFlg = 'Y'
     C                   ELSEIF    PMtpy = '202'
     C                   EXSR      SRExtract202
     C                   EVAL      WGenFlg = 'Y'
     C                   ELSEIF    PMtpy = '205'
     C                   EXSR      SRExtract205
     C                   EVAL      WGenFlg = 'Y'
     C                   ENDIF

      ** Writes to MGOMSGPD

     C                   IF        WGenFlg = 'Y'
     C                   EXSR      SrOMSG

      *
     C                   EVAL      PGenFlg = 'Y'
      *
     C                   ENDIF
      *
     C                   ENDIF

      *
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
     C                   MOVEL     'FT000201'    DBPGM
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
     C                   EVAL      WTag79L1Val = *BLANKS
     C                   EVAL      WTag79L2Val = *BLANKS
     C                   EVAL      WTag79L3Val = *BLANKS
     C                   EVAL      WTag79L4Val = *BLANKS

      *
      ** Reset work Variables
      *
     C                   EVAL      WTag20a = *BLANKS
      ** WTag20b not blanked since it is the rundate
     C                   EVAL      WTag79L3a = *BLANKS
     C                   EVAL      WTag79L3b = *BLANKS

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
      * SrExtract103- Extract details for MT103                       *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrExtract103  BEGSR

     C
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
     C                   EVAL      WTag20Val = 'P' + WTag20a + WTag20b + 'A'
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
      ** Get the value of Sender in MEINCRPD.CRMOR(Output)
      *
     C     KFMsgR        CHAIN     MEINCRL1
     C                   IF        %FOUND

     C                   EVAL      WBIC = %SUBST(CRMOR:7:8)
     C                   EVAL      WBranch = %SUBST(CRMOR:16:3)
     C                   EVAL      WSender = WBIC + WBranch

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
     C                   EXSR      SrGetSeCN
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
     C     KLIncMsg      CHAIN     MEIN35L0
     C                   IF        %FOUND
     C                   EVAL      WTag70Val = DSMF35

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':70:'        MTAG
     C                   MOVEL     WTag70Val     MFLD

      *
      ** Get tag 79 Line 4
      *
     C                   EVAL      WTag79L4Val = '/TREF/' + WTag70Val
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L4Val   MFLD

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExtract202- Extract details for MT202                       *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrExtract202  BEGSR
      *
      ** Check if 202 is COV.
      *
     C                   EVAL      KFMtag = '119:'
     C     KLIncMsg      CHAIN     MEIN35L0
     C                   IF        %FOUND
     C                   EVAL      WTag202COV = DSMF35

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':119:'       MTAG
     C                   MOVEL     WTag70Val     MFLD

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '011'         DBASE
     C                   MOVEL     'KLIncMsg'    DBKEY
     C                   MOVEL     'MEIN35L0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF
      *
      ** Mapping for MT202COV
      *
     C                   IF        WTag202COV = 'COV'
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
     C                   EVAL      WTag20Val = 'P' + WTag20a + WTag20b + 'A'
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
     C                   EXSR      SrGetSeCN
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
      ** Get tag 21
      *
     C                   EVAL      KFMtag = ':21:'
     C     KLIncMsg      CHAIN     MEIN35L0
     C                   IF        %FOUND
     C                   EVAL      WTag70Val = DSMF35

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':21:'        MTAG
     C                   MOVEL     WTag70Val     MFLD

      *
      ** Get tag 79 Line 4
      *
     C                   EVAL      WTag79L4Val = '/TREF/' + WTag70Val
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L4Val   MFLD

     C                   ENDIF

      *
      ** Mapping for MT202
      *
     C                   ELSE
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
     C                   EVAL      WTag20Val = 'P' + WTag20a + WTag20b + 'A'
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
     C                   EXSR      SrGetSeCN
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
      ** Get tag 21
      *
     C                   EVAL      KFMtag = ':21:'
     C     KLIncMsg      CHAIN     MEIN35L0
     C                   IF        %FOUND
     C                   EVAL      WTag21Val = DSMF35

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':21:'        MTAG
     C                   MOVEL     WTag21Val     MFLD

      *
      ** Get tag 79 Line 4
      *
     C                   EVAL      WTag79L4Val = '/TREF/' + WTag21Val
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L4Val   MFLD

     C                   ENDIF
      *
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExtract205- Extract details for MT205                       *
      *                                                               *
      * Called by: SrRdIncMsg                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrExtract205  BEGSR
      *
      ** Check if 205 is COV.
      *
     C                   EVAL      KFMtag = '119:'
     C     KLIncMsg      CHAIN     MEIN35L0
     C                   IF        %FOUND
     C                   EVAL      WTag205COV = DSMF35

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':119:'       MTAG
     C                   MOVEL     WTag70Val     MFLD

     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      '011'         DBASE
     C                   MOVEL     'KLIncMsg'    DBKEY
     C                   MOVEL     'MEIN35L0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF
      *
      ** Mapping for MT205COV
      *
     C                   IF        WTag205COV = 'COV'
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
      ** Get tag 21
      *
     C                   EVAL      KFMtag = ':21:'
     C     KLIncMsg      CHAIN     MEIN35L0
     C                   IF        %FOUND
     C                   EVAL      WTag21Val = DSMF35

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':21:'        MTAG
     C                   MOVEL     WTag70Val     MFLD

      *
      ** Get tag 79 Line 4
      *
     C                   EVAL      WTag79L4Val = '/TREF/' + WTag70Val
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L4Val   MFLD

     C                   ENDIF

      *
      ** Mapping for MT205
      *
     C                   ELSE
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
     C                   EVAL      WTag20Val = 'P' + WTag20a + WTag20b + 'A'
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
      ** Get tag 21
      *
     C                   EVAL      KFMtag = ':21:'
     C     KLIncMsg      CHAIN     MEIN35L0
     C                   IF        %FOUND
     C                   EVAL      WTag21Val = DSMF35

     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      ':21:'        MTAG
     C                   MOVEL     WTag21Val     MFLD

      *
      ** Get tag 79 Line 4
      *
     C                   EVAL      WTag79L4Val = '/TREF/' + WTag21Val
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     WTag79L4Val   MFLD

     C                   ENDIF
      *
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SrOMSG - output correctly generated messages                *
      *                                                               *
      *   Called by: SrRdIncMsg                                       *
      *                                                               *
      *   Calls    : SrWref199, SrWref299                             *
      *                                                               *
      *****************************************************************
      *
     C     SrOMSG        BEGSR

      ** Write reference record  (PF/MGOREFPD)
     C                   IF        Pmtpy = '103'
     C                   EXSR      SrWRef199
     C                   ELSEIF    Pmtpy = '202' OR Pmtpy = '205'
     C                   EXSR      SrWRef299
     C                   ENDIF

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
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrWREF199 - Write reference record to PF/MGOREFPD (MT199)   *
      *                                                               *
      *   Called by: SrOMSG                                           *
      *                                                               *
      *   Calls    : None                                             *
      *                                                               *
      *****************************************************************
     C     SrWREF199     BEGSR

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
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrWREF299 - Write reference record to PF/MGOREFPD (MT299)   *
      *                                                               *
      *   Called by: SrOMSG                                           *
      *                                                               *
      *   Calls    : None                                             *
      *                                                               *
      *****************************************************************
     C     SrWREF299     BEGSR

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
     C                   MOVE      '299'         MTPY
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
      *  SrGetSeCN - Save Branch Customer from SDBRANCHPD             *
      *                                                               *
      *  Called by: SrExtract                                         *
      *                                                               *
      *  Calls    : AOBRCHR0                                          *
      *                                                               *
      *****************************************************************
     C     SrGetSeCN     BEGSR
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PBrCA         @BRCD
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
      *
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
