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

      **  Data structure for SAR - Switchable features file
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

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
     D WTag20a         S              8A
     D WTag20b         S              6A
     D WTag79L3a       S              6A
     D WTag79L3b       S             16A

      ** Variables for writing MGOREFPD
      * Transaction Ref. Number
     D WTRNo           S             16A
     D WTrnId          S             15A

      ** Parameters for calling Standing Data
     D @BRCD           S              3A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @SARD           S              6A

      ** Variables for Switchable Features
     D CSW122          S              1A

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

      *
      ** Key List for reading Incoming Messages
      *
     C     KLIncMsg      KLIST
     C                   KFLD                    KFMsgR
     C                   KFLD                    KFMtag

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
      *
      ** If Message Type is equal to 103
      *
     C                   IF        PMtpy = '103'
     C                   EXSR      SRExtract103
     C                   ENDIF
      *
     C                   ENDIF

     C                   EVAL      PGenFlg = 'Y'

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
