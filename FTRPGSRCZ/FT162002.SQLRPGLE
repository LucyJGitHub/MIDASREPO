     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas FT MT910 Bank Transfer Supplementay Messages')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT162002 - MT910 Bank Transfers Supplementary Messages       *
      *                                                               *
      *  Function:  This program output a MT910 message               *
      *             :20:  Transaction                                 *
      *             :21:  Related Transaction                         *
      *             :25:  Account Identification                      *
      *             :32A: Value Date/CCY/Amount                       *
      *             :52x: Ordering Bank                               *
      *             :56x: Intermediary Bank                           *
      *             :72:  Bank to Bank Information                    *
      *                                                               *
      *  Called By: FTC162002                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2017            *
      *                                                               *
      *  Last Amend No. CFT162   *Create   Date 05Sep17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     FSDM901L0  IF   E           K DISK
      * SD Account/Customer MT900/MT910 Details
      *
     FOTPAY     IF   E           K DISK
      * Funds Transfer Outgoing Payments
      *
     FOTPAYXL3  UF   E           K DISK
      * Outgoing payments extension file - MT910 selection
      *
     FINPAY     IF   E           K DISK
      * Funds Transfer Incoming Payments
      *
     FINPAYXL4  UF   E           K DISK
      * Incoming payments extension file - MT910 selection
      *
     FACNUMA    IF   E           K DISK
      * Retail Accounts LF
      *
     FSDCUSTL7  IF   E           K DISK
      * SD Customer details (SWIFT key)
      *
     FMGOREFPD  O  A E             DISK    COMMIT
      * Master Message Reference File
      *
     FMGOMSGPD  O  A E           K DISK    COMMIT
      * Master Message Data File
      *
     FFT162002P1O    E             PRINTER INFDS(SPOOL1)
      * Via SWIFT
      *
     FFT162002P2O    E             PRINTER INFDS(SPOOL2)
      * Via Telex
      *
     FFT162002AUO    E             PRINTER INFDS(SPOOLU)
      * Audit Control
      *
     D AMT             S              1    DIM(13)                              AMOUNT ARRAY
     D AM              S              1    DIM(14)                              EDITED AMOUNT ARR
     D FAMT            S              1    DIM(15)                              LEFT ADJ AMNT ARR
     D ADDR            S             35    DIM(6)                               NAME/Address  ARR
     D GNR             S              3    DIM(15)                              msg gen released.
      *
      * Array to hold destinations
     D ZDEST           S             11    DIM(5)
      *
      *
     D SPOOLU          DS
      * File Information Data Structure
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D SPOOL1          DS
      * File Information Data Structure
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
      *
     D SPOOL2          DS
      * File Information Data Structure
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
      *
     D                 DS
     D  SDFBR                  1      3  0
     D  SCSID                  4     15
     D  CSID9                 12     12
     D  CSID10                13     13
     D  CSID11                14     14
     D  CSID12                15     15
      *
     D                 DS
      *****************************************************************
      * Data Structure To CONVERT DATE FROM FORMAT YYMMDD To DDMMMYY. *
      *****************************************************************
     D  SDATE                  1      6  0
     D  SYY                    1      2
     D  SMM                    3      4  0
     D  SDD                    5      6
     D                 DS
     D  WDATE                  1      7
     D  WDD                    1      2
     D  WMM                    3      5
     D  WYY                    6      7
      *
     D                 DS
      * Data Structure To Manipulate Amount
     D  WAMNT                  1     13  0
     D  RAMNT                  1     13
      * For Editing on the Report
     D  P2AMT0                 1     13  0
     D  P2AMT1                 1     13  1
     D  P2AMT2                 1     13  2
     D  P2AMT3                 1     13  3
      *
     D OFSPT           DS           210
      * Data Structure To Eliminate Blank Lines
     D  OFSPT1                 1     35
     D  OFSPT2                36     70
     D  OFSPT3                71    105
     D  OFSPT4               106    140
     D  OFSPT5               141    175
     D  OFSPT6               176    210
      *
     D                 DS
      * Data Structure To Manipulate Pay Ref.
     D  DSPREF                 1     15
     D  PAYT                  12     13
      *
     I/COPY FTCPYSRC,SFTADDRILE
      *
     D DSNOST          DS             5
     D  DSNCCY                 1      3
     D  DSNNNB                 4      5
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      * Data Structure to Retrieve Multibranch Indicator
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      **********************************************************************
      * Data Structure - PROGRAM STATUS                                    *
      **********************************************************************
     D  ##PGM                  1     10
     D  USRID                254    263
      *
     D MULT            DS                  OCCURS(95)
      * Multiple occurrence data structure for message
     D  MTAG                   1      5
     D  MFLD                   6     55
      *
     D @MTAG           DS             5
      * Data structure constructing message field tag
     D  COLON1                 1      1    INZ(':')
     D  FLDNO                  2      3
     D  TAG                    4      4
     D  COLON2                 5      5    INZ(':')
      *
     D P@IN            DS           256
      * Data structure for input parameter
     D  I@SNBR                 1      3
     D  I@DSCN                 4      9
     D  I@MTPY                10     12
     D  I@SETT                13     14  0
     D  I@CONC                15     15
     D  I@FTCS                16     16
     D  I@MMOD                17     18
      *
     D P@OUT           DS           256
      * Data structure for output parameter
     D  O@CNSN                 1      6
     D  O@SWSN                 7     18
     D  O@NWSN                19     38
     D  O@SWDS                39     49
     D  W@96CN                46     46
     D  W@BIC                 47     49
     D  O@NWDS                50     69
     D  O@NWRK                70     75
     D  O@MGSG                76     76
     D  O@MGST                77     80
     D  O@PAIN                81     81
     D  O@PCNB                82     87
     D  O@SPRS                88     90
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * External Data structure for customer details.
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **  External Data structure for modules files.
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      * External Data structure for MESSAGE MANAGEMENT file
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External Data structure for CURRENCIES file
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      * External Data structure for Nostro details
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      * Calling parameter data structure for ME1400
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      * Calling parameter data structure for FT ICD
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Calling parameter data structure for SD ICD
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      * Calling parameter data structure for ME1400
      *
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D CBRCA         E                     EXTFLD(BRCA)
      * Calling parameter data structure for AOACCTR0
      *
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QAACCD        E                     EXTFLD(QQACCD)
      * Calling parameter data structure for AOACODR0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Long data structure for access programs
      *
      *
     D MEBEIS        E DS                  EXTNAME(MEBEISPD)
      ** Data Structure for Business Entity Identifier file
     D W8FT            DS           128
      * Address data structure
      *
      * Currency
     D  W8CCY                  1      3
      * Settlement Type
     D  W8STMT                 4      5
      * Mandatory Text - convert BIC identifiers
     D  W8MTXT                 6      6
      * Message Tag
     D  W8MTAG                 7     11
      * Construct of data in field
     D  W8TYPE                12     12
      * Number of Lines available
     D  W8NLIN                13     14  0
      * Network and Message Type
     D  W8NWRK                15     20
     D  W8MTPY                21     23
      * Calling Program
     D  W8CPGM                24     33
      * Action *PRINT/*ENQ/*MSG GEN
     D  W8ACT                 34     41
      * Critical reporting - Database error if 'Y'
      * If no BIC directory and BIC entered no error
     D  W8CRIT                42     42
      * Force Midas Address - where possible
     D  W8MADD                43     43
      * If Retail get first address from account
     D  W8RTAD                44     44
      * Alternative Address
     D  W8ALTN                45     45
      * Address type selected in W0MSG
     D  W8ADTP                46     46
      *
      * Full account data structure
     D                 DS
     D  FACCNT                 1     24
     D  FCNUM                  1      6
     D  FCCY                   7      9
     D  FACOD                 10     19
     D  FACSQ                 20     21
     D  FBRCA                 22     24
      * Partial account data structure
     D                 DS
     D  PACCNT                 1     18
     D  PCNUM                  1      6
     D  PACOD                  7     16
     D  PACSQ                 17     18
      *
      * Constants
      *
     D F72@            C                   CONST('Cover for transfer f-
     D                                     or')
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D MTH             S              3    DIM(12) CTDATA PERRCD(12)
      *
     IACCNTABF
     I              BRCA                        ABRCA
      *
      /EJECT
      *
      ******************************
      * Input Output Parameters
      ******************************
     C     *ENTRY        PLIST
     C                   PARM                    RMODE                          I-Input Parm
     C                   PARM                    OPPARM                         O-Output Parm
     C                   PARM                    RSEQ              5            IO-ZSFILE
      *
      ***********************
      * FIRST CYCLE.        *
      ***********************
      *
     C     *IN40         IFEQ      *OFF
     C                   EXSR      FIRST
     C                   ENDIF
      *
      /EJECT
      *
      ****************************
      * DETAIL PROCESSING.       *
      ****************************
      *
      *****************************************************************
      * Record Read From OTPAYDD                                      *
      *****************************************************************
      *
      * Process records on the Outgoing Payments Logical
     C                   READ      OTPAYXL3                               LR
      *
     C     *INLR         DOWEQ     *OFF
      *
      * Retreive record from master file
     C     OPPREF        CHAIN     OTPAY                              88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     'OTPAYDD '    DBFNAM                         **************
     C                   MOVEL     OPPREF        DBERKY                         *DB ERROR 280*
     C                   Z-ADD     280           DBERR#                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      * Only generate message AUTHORISED
     C     AUIN          IFEQ      'Y'
      *
      * Keep Tally of Number Of RecordS Read From OTPAYDD.
     C                   ADD       1             AUNO1
      *
      * Set payment type to 'OP'- Outgoing payment.
     C                   MOVE      'OP'          PTYPE             2
     C                   MOVE      *ON           *IN21
      *
      * Initialise non-constant fields
     C                   EXSR      INTF
      *
      * Setup Parameters and Execute SR01
     C     SNCT          IFNE      *BLANKS
      *
      * Determine SWIFT Address Of SENDERS CORRESPONDENT
     C                   MOVEL     SNCT          ISPTP             1
     C                   MOVEL(P)  SNCO          ISPTY1           35
     C                   MOVE      *BLANKS       ISPTY2           35
     C                   MOVE      *BLANKS       ISPTY3           35
     C                   MOVE      *BLANKS       ISPTY4           35
     C                   MOVE      *BLANKS       ISPTY5           35
     C                   MOVE      PCCY          ISCCY             3
     C                   MOVE      'A'           IVTAG1            1
     C                   MOVE      ' '           IVTAG2            1
     C                   MOVE      ' '           IVTAG3            1
      *
     C                   ELSE
      *
      * Determine SWIFT Address OF RECEIVING BANK
     C                   MOVEL     DSTT          ISPTP             1
     C                   MOVEL(P)  DST1          ISPTY1           35
     C                   MOVE(P)   DST2          ISPTY2           35
     C                   MOVE(P)   DST3          ISPTY3           35
     C                   MOVE(P)   DST4          ISPTY4           35
     C                   MOVE      *BLANKS       ISPTY5           35
     C                   MOVE      PCCY          ISCCY             3
     C                   MOVE      'A'           IVTAG1            1
     C                   MOVE      ' '           IVTAG2            1
     C                   MOVE      ' '           IVTAG3            1
     C                   ENDIF
      *
     C                   SETON                                        20
     C                   EXSR      SR01
     C                   SETOFF                                       20
      * Set Branch Code
      *
     C                   MOVE      *BLANKS       P2BRCA            3
     C                   MOVE      *BLANKS       IBANBN           35
      *
      *
     C     SNCT          IFNE      *BLANKS
      *
     C                   SELECT
     C     SNCT          WHENEQ    'N'
     C                   MOVE      A7BRCD        P2BRCA
     C     SNCT          WHENEQ    'R'
     C                   MOVE      ABRCA         P2BRCA
     C                   MOVEL     SNCO          IBANBN
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
     C     DSTT          WHENEQ    'F'
     C                   MOVE      A7BRCD        P2BRCA
     C     DSTT          WHENEQ    'G'
     C     3             SUBST     DST1:22       P2BRCA
     C     DSTT          WHENEQ    'R'
     C                   MOVE      ABRCA         P2BRCA
     C                   MOVEL     DST1          IBANBN
     C                   ENDSL
      *
     C                   ENDIF
      *
      * Save Fields
     C                   Move      CUSTNO        SDECN                          Save Cust No
     C                   Move      CNUM          F25_CNUM          6
     C                   z-add     ACOD          F25_ACOD         10 0
     C                   z-add     ACSQ          F25_ACSQ          2 0
      *
     C     KM9ACC        Chain     SDM901L0                           88
      *
     C     *IN88         Ifeq      *ON
     C     KM9CUS        Chain     SDM901L0                           88
     C                   Endif
      *
     C     *IN88         Ifeq      *OFF
     C                   MOVE      M9NWRK        NWRK
     C                   MOVE      M9ACNO        A_ACNO           10
     C                   MOVEA     *BLANKS       ZDEST
     C                   MOVEL     M9DST1        ZDEST(1)
     C                   MOVEL     M9DST2        ZDEST(2)
     C                   MOVEL     M9DST3        ZDEST(3)
     C                   MOVEL     M9DST4        ZDEST(4)
     C                   MOVEL     M9DST5        ZDEST(5)
     C                   Endif
      *
      * For each Destination Generate an MT9nn
     C                   Z-ADD     1             u                 1 0
     C                   DOU       u = 6
     C                   IF        ZDEST(u) <> *BLANKS
      *
      * Field :20:  Transaction Reference Number
     C                   EXSR      FLD20
      *
      * Field :21:  Related Reference
     C                   EXSR      FLD21
      *
      *
      * Field :25:  Account Reference
     C                   EXSR      FLD25
      *
      * Field :32A: Value Date/Currency/Amount
     C                   EXSR      FLD32A
      *
      * Field :52x: Ordering Bank
     C                   EXSR      FLD52X
      *
      * Field :56x: Intermediary Bank
     C                   EXSR      FLD56X
      *
      * Field :72:  Bank to Bank information
     C                   EXSR      FLD72
      *
      *
      * Output correctly generated message to PF/MGOMSGPD and write
      * reference record to PF/MGOREFPD.
      *
     C                   EXSR      OMSG
      *
      * Output to SWIFT or TELEX report.
      *
      *
     C     M9NWRK        IFEQ      'SWIFT'
     C                   EXSR      SRP1                                         SWIFT
     C                   ELSE
     C                   EXSR      SRP2                                         Telex
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ADD       1             u
     C                   ENDDO
      *
      * Update the MT910 generated indicator
      *
     C                   MOVE      'C'           OPG910
     C                   UPDATE    OTPAYXDF
      *
      * Comit Changes
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   READ      OTPAYXL3                               LR
     C                   ENDDO
      *
      * Process records on the Incoming Payments Logical
     C                   READ      INPAYXL4                               LR
      *
     C     *INLR         DOWEQ     *OFF
      *
      * Retreive record from master file
     C     INPREF        CHAIN     INPAY                              88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     'INPAYDD '    DBFNAM                         **************
     C                   MOVEL     INPREF        DBERKY                         *DB ERROR 290*
     C                   Z-ADD     290           DBERR#                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      * Only generate message if AUTHORISED
     C     AUIN          IFEQ      'Y'
      *
      * Set payment type to 'IN'- Incoming payment.
     C                   MOVE      'IN'          PTYPE
     C                   MOVE      *OFF          *IN21
      *
      * Initialise non-constant fields
     C                   EXSR      INTF
      *
      * Keep Tally of Number Of Records Read From INPAYDD.
     C                   ADD       1             AUNI1
      *
      * Setup Parameters and Execute SR01
     C     ACBT          IFNE      *BLANKS
      *
      * Determine SWIFT Address Of A/C WITH BANK
     C                   MOVEL     ACBT          ISPTP
     C                   MOVEL(P)  ACBK          ISPTY1
     C                   MOVE      *BLANKS       ISPTY2
     C                   MOVE      *BLANKS       ISPTY3
     C                   MOVE      *BLANKS       ISPTY4
     C                   MOVE      *BLANKS       ISPTY5
     C                   MOVE      PCCY          ISCCY
     C                   MOVE      'A'           IVTAG1
     C                   MOVE      ' '           IVTAG2
     C                   MOVE      ' '           IVTAG3
      *
     C                   ELSE
      *
      * Determine SWIFT Address BENEFICIARY
     C                   MOVEL     BNCT          ISPTP
     C                   MOVEL(P)  BNC1          ISPTY1
     C                   MOVE(P)   BNC2          ISPTY2
     C                   MOVE(P)   BNC3          ISPTY3
     C                   MOVE(P)   BNC4          ISPTY4
     C                   MOVE(P)   BNC5          ISPTY5
     C                   MOVE      PCCY          ISCCY
     C                   MOVE      'A'           IVTAG1
     C                   MOVE      ' '           IVTAG2
     C                   MOVE      ' '           IVTAG3
     C                   ENDIF
      *
     C                   SETON                                        20
     C                   EXSR      SR01
     C                   SETOFF                                       20
      * Set Branch Code
      *
     C                   MOVE      *BLANKS       P2BRCA            3
     C                   MOVE      *BLANKS       IBANBN           35
      *
     C     ACBT          IFNE      *BLANKS
      *
     C                   SELECT
     C     ACBT          WHENEQ    'F'
     C     ACBT          OREQ      'N'
     C                   MOVE      A7BRCD        P2BRCA
     C     ACBT          WHENEQ    'R'
     C                   MOVE      ABRCA         P2BRCA
     C                   MOVEL     ACBB          IBANBN
     C     ACBT          WHENEQ    'P'
     C                   MOVE      ACBB          P2BRCA
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
     C     BNCT          WHENEQ    'P'
     C     3             SUBST     BNC1:19       P2BRCA
     C     BNCT          WHENEQ    'R'
     C                   MOVE      ABRCA         P2BRCA
     C                   MOVEL     BNC1          IBANBN
     C     BNCT          WHENEQ    'I'
     C                   MOVE      CBRCA         P2BRCA
     C                   MOVEL     BNC1          IBANBN
     C                   ENDSL
      *
     C                   ENDIF
      *
      * Save Fields
     C                   MOVE      CUSTNO        SDECN                          Save Cust No
     C                   Move      CNUM          F25_CNUM          6
     C                   z-add     ACOD          F25_ACOD         10 0
     C                   z-add     ACSQ          F25_ACSQ          2 0
      *
     C     KM9ACC        Chain     SDM901L0                           88
      *
     C     *IN88         Ifeq      *ON
     C     KM9CUS        Chain     SDM901L0                           88
     C                   Endif
      *
     C     *IN88         Ifeq      *OFF
     C                   MOVE      M9NWRK        NWRK
     C                   MOVE      M9ACNO        A_ACNO           10
     C                   MOVEA     *BLANKS       ZDEST
     C                   MOVEL     M9DST1        ZDEST(1)
     C                   MOVEL     M9DST2        ZDEST(2)
     C                   MOVEL     M9DST3        ZDEST(3)
     C                   MOVEL     M9DST4        ZDEST(4)
     C                   MOVEL     M9DST5        ZDEST(5)
     C                   Endif
      *
      * For each Destination Generate an MT9nn
     C                   Z-ADD     1             u                 1 0
     C                   DOU       u = 6
     C                   IF        ZDEST(u) <> *BLANKS
      *
      * Field :20:  Transaction Reference Number
     C                   EXSR      FLD20
      *
      * Field :21:  Related Reference
     C                   EXSR      FLD21
      *
      *
      * Field :25:  Account Reference
     C                   EXSR      FLD25
      *
      * Field :32A: Value Date/Currency/Amount
     C                   EXSR      FLD32A
      * Field :52x: Ordering Bank
     C                   EXSR      FLD52Z
      *
      * Field :56x: Intermediary Bank
     C                   EXSR      FLD56X
      *
      * Output correctly generated message to PF/MGOMSGPD and write
      * reference record to PF/MGOREFPD.
      *
     C                   EXSR      OMSG
      *
      * Output to SWIFT or TELEX report.
      *
     C     M9NWRK        IFEQ      'SWIFT'
     C                   EXSR      SRP1                                         SWIFT
     C                   ELSE
     C                   EXSR      SRP2                                         Telex
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ADD       1             u
     C                   ENDDO
      *
      * Update the MT910 generated indicator
      *
     C                   MOVE      'C'           ING910
     C                   UPDATE    INPAYXDF
      * Comit Changes
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   READ      INPAYXL4                               LR
     C                   ENDDO
      *
      * Last Record Processing
     CLR                 EXSR      LAST
      *
      /EJECT
      *****************************************************************
     C     FLD20         BEGSR
      *---------------------------------------------------------------*
      * Field :20:  Transaction Reference Number                      *
      *---------------------------------------------------------------*
      *
     C                   Z-ADD     1             Q
     C     Q             OCCUR     MULT
      *
     C                   MOVEL(P)  ':20:'        MTAG                           Set TAG
     C     11            SUBST     PREF:2        WKA11            11            Remove 'P'
     C     'FT'          CAT       WKA11         WKA13            13            FTYYMMDDNNNNO
      * Move 'C' into payment type to uniquely identify message
     C     WKA13         CAT       'C'           WKA14            14
     C     2             SUBST     PREF:14       WKA2              2            Last two chars
     C     WKA14         CAT       WKA2          WKA16            16
     C                   MOVEL(P)  WKA16         MFLD
      *
      * Save the transaction Reference Number.
     C                   MOVEL     MFLD          TRNA             16
     C                   MOVEL     TRNA          MGTRNA           16
     C                   MOVE      U             MGTRNA
      *
      * Populate printer file fields
     C                   MOVEL     MFLD          P1REF
      *
     C     MFLD          IFEQ      *BLANKS
     C                   SUB       1             Q
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     FLD21         BEGSR
      *---------------------------------------------------------------*
      * Field :21:  Related Reference                                 *
      *---------------------------------------------------------------*
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
     C                   MOVEL(P)  ':21:'        MTAG                           Set TAG
     C     RLPR          IFNE      *BLANKS
     C                   MOVEL(P)  RLPR          MFLD
     C                   ELSE
     C                   MOVEL(P)  'NONREF'      MFLD
     C                   ENDIF
      *
      * Populate printer file fields
     C                   MOVEL     MFLD          P1RREF
     C                   MOVEL     MFLD          P2RREF
      *
     C     MFLD          IFEQ      *BLANKS
     C                   SUB       1             Q
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     FLD25         BEGSR
      *---------------------------------------------------------------*
      * Field :25:  Account Identification                            *
      *             15 character account id derived from Senders      *
      *             Correspondent.                                    *
      *---------------------------------------------------------------*
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
     C                   MOVEL(P)  ':25:'        MTAG                           Set TAG
      *
     C                   MOVEL(P)  F25_CNUM      F25F              9            Set A/C ID CUST
     C                   MOVE      PCCY          F25F                           Add A/C ID CCY
      *
     C                   MOVEL(P)  F25_ACOD      F25L             12            Set A/C ID ACOD
     C                   MOVE      F25_ACSQ      F25L                           Add A/C ID ACSQ
      *
     C     F25F          CAT(P)    F25L          MFLD                           Set Mess Field
      *
      * Populate printer file fields
     C     F25F          CAT(P)    F25L          P1ACCT                         Set A/C ID
      *
     C                   MOVEL     F25_CNum      P2IDCU                         Set A/C ID CUST
     C                   MOVEL     PCCY          P2IDCY                         Set A/C ID CCY
     C                   MOVEL     F25_ACOD      P2IDAC                         Set A/C ID ACOD
     C                   MOVE      F25_ACSQ      P2IDAS                         Set A/C ID ACSQ
      *
     C                   CALL      'AOACODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      P2IDAC        P@ACCD           10
     C     SDACOD        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   Z-ADD     201           DBERR#                         ***************
     C                   MOVEL     '*CALL   '    DBERKY                         * DB ERROR 201*
     C                   MOVEL     'AOACODR0'    DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   END
      *
      * If Loro - output IBAN number.
      *
      *
     C     IBANBN        IFEQ      *BLANKS
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *BLANKS       P@RETL           10
     C                   PARM      P2IDCU        P@CNUM            6
     C                   PARM      P2IDCY        P@CUCD            3
     C                   PARM      P2IDAC        P@ACCD           10
     C                   PARM      P2IDAS        P@ACSQ            2
     C                   PARM      P2BRCA        P@BRCA            3
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   Z-ADD     200           DBERR#                         ***************
     C                   MOVEL     '*CALL   '    DBERKY                         * DB ERROR 200*
     C                   MOVEL     'AOACCTR0'    DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   END
      * Output IBAN
     C     IBAN          IFNE      *BLANKS
     C                   MOVE      *BLANKS       MFLD
     C                   MOVEL     IBAN          MFLD
     C                   MOVE      *BLANKS       P1ACCT
     C                   MOVEL     IBAN          P1ACCT
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       MFLD
     C                   MOVEL     IBANBN        MFLD
     C                   MOVE      *BLANKS       P1ACCT
     C                   MOVEL     IBANBN        P1ACCT
      *
     C                   ENDIF
      *
     C     MFLD          IFEQ      *BLANKS
     C                   SUB       1             Q
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     FLD32A        BEGSR
      *---------------------------------------------------------------*
      * Field :32A: Value Date/Currency/Amount                        *
      *---------------------------------------------------------------*
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
     C                   MOVEL(P)  ':32A:'       MTAG                           Set TAG
      * Value Date.
     C                   MOVEL(P)  PVDTD3        MFLD
     C                   MOVEL(P)  PVDTD3        P1VDAT                         Set print fld
      * Currency.
     C                   CAT       PCCY:0        MFLD
     C                   MOVEL(P)  PCCY          P1RCCY                         Set print fld
      * Calculate & Format the Amount
     C                   EXSR      SR06
     C                   MOVEA     SAM           FAMT
     C                   Z-ADD     1             S                 3 0
     C     FAMT(S)       DOWEQ     ' '
     C                   ADD       1             S
     C                   ENDDO
     C                   MOVE      *BLANKS       AMNT32
     C                   MOVEA     FAMT(S)       AMNT32           15
      *
     C                   CAT       AMNT32:0      MFLD
     C                   MOVEL(P)  AMNT32        P1AMNT                         Set print fld
      *
     C     MFLD          IFEQ      *BLANKS
     C                   SUB       1             Q
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     FLD52X        BEGSR
      *---------------------------------------------------------------*
      * Field :52x: Ordering Bank                                     *
      *---------------------------------------------------------------*
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
      * Setup Parameters and Execute SR01 To
      * Format the Ordering Bank.
     C                   MOVEL     ORBT          ISPTP                          SETTLMT TYPE
     C                   MOVEL(P)  ORBK          ISPTY1                         SETTLMT ADD1
     C                   MOVE      *BLANKS       ISPTY2                         SETTLMT ADD2
     C                   MOVE      *BLANKS       ISPTY3                         SETTLMT ADD3
     C                   MOVE      *BLANKS       ISPTY4                         SETTLMT ADD4
     C                   MOVE      *BLANKS       ISPTY5                         SETTLMT ADD5
     C                   MOVEL     ORBB          ISBRCA            3
     C                   MOVE      SMCY          ISCCY             3            CURRENCY
     C                   MOVE      'A'           IVTAG1            1            TAG IND 1
     C                   MOVE      ' '           IVTAG2            1            TAG IND 2
     C                   MOVE      'D'           IVTAG3            1            TAG IND 3
      *
      * SET OFF INDICATOR FOR BLOCK OF SWFT CALL FOR DETAIL
      * Field Address(Rather than Destination Address)
     C                   SETOFF                                       20
      *
     C                   EXSR      SR01
      *
      * Move Formatted Ordering Bank Fields into Data Structure
     C                   MOVEL(P)  '52'          FLDNO
     C                   EXSR      FSWAD
      *
      * Populate printer file fields
     C                   MOVEL(P)  OSTAG         P1ORBT                         Tag Type
     C                   MOVEL(P)  OFSPT1        P1ORB1
     C                   MOVEL(P)  OFSPT2        P1ORB2
     C                   MOVEL(P)  OFSPT3        P1ORB3
     C                   MOVEL(P)  OFSPT4        P1ORB4
     C                   MOVEL(P)  OFSPT5        P1ORB5
      *
     C                   MOVEL(P)  OFSPT1        P2ORB1
     C                   MOVEL(P)  OFSPT2        P2ORB2
     C                   MOVEL(P)  OFSPT3        P2ORB3
     C                   MOVEL(P)  OFSPT4        P2ORB4
     C                   MOVEL(P)  OFSPT5        P2ORB5
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     FLD56X        BEGSR
      *---------------------------------------------------------------*
      **Field*:56x:*Intermediary*Bank                                 *
      *---------------------------------------------------------------*
      *
      * Clear Printer file fields
      *
     C                   MOVE      *BLANKS       P1INB1
     C                   MOVE      *BLANKS       P1INB2
     C                   MOVE      *BLANKS       P1INB3
     C                   MOVE      *BLANKS       P1INB4
     C                   MOVE      *BLANKS       P1INB5
      *
     C                   MOVE      *BLANKS       P2INB1
     C                   MOVE      *BLANKS       P2INB2
     C                   MOVE      *BLANKS       P2INB3
     C                   MOVE      *BLANKS       P2INB4
     C                   MOVE      *BLANKS       P2INB5
      *
     C     INB1          IFNE      *BLANKS
     C     INB2          ORNE      *BLANKS
     C     INB3          ORNE      *BLANKS
     C     INB4          ORNE      *BLANKS
     C     INB5          ORNE      *BLANKS
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
      *
      * Setup Parameters and Execute SR01 to
      * FORMAT THE INTERMEDIARY BANK
     C                   MOVEL     INBT          ISPTP
     C                   MOVEL(P)  INB1          ISPTY1
     C                   MOVEL(P)  INB2          ISPTY2
     C                   MOVEL(P)  INB3          ISPTY3
     C                   MOVEL(P)  INB4          ISPTY4
     C                   MOVEL(P)  INB5          ISPTY5
     C                   MOVE      PCCY          ISCCY
     C                   MOVE      'A'           IVTAG1                          TAG IND 1
     C                   MOVE      ' '           IVTAG2                          TAG IND 2
     C                   MOVE      'D'           IVTAG3                          TAG IND 3
      *
      * SET OFF INDICATOR FOR BLOCK OF SWFT CALL FOR DETAIL
      * Field Address(RATHER THAN DESTINATION Address)
      *
     C                   SETOFF                                       20
      *
     C                   EXSR      SR01
      *
      * Move Formatted Account With Bank Fields into Data Structure
     C                   MOVEL(P)  '56'          FLDNO
     C                   EXSR      FSWAD
      *
      * Populate printer file fields
     C                   MOVEL(P)  OSTAG         P1INBT                         Tag Type
     C                   MOVEL     OFSPT1        P1INB1
     C                   MOVEL     OFSPT2        P1INB2
     C                   MOVEL     OFSPT3        P1INB3
     C                   MOVEL     OFSPT4        P1INB4
     C                   MOVEL     OFSPT5        P1INB5
      *
     C                   MOVEL     OFSPT1        P2INB1
     C                   MOVEL     OFSPT2        P2INB2
     C                   MOVEL     OFSPT3        P2INB3
     C                   MOVEL     OFSPT4        P2INB4
     C                   MOVEL     OFSPT5        P2INB5
      *
     C                   ENDIF
      *
     C                   ENDSR
      *EJECT
      /EJECT
      *****************************************************************
     C     FLD52Z        BEGSR
      *---------------------------------------------------------------*
      **Field*:52x:*Ordering Institution for Incoming                 *
      *---------------------------------------------------------------*
      *
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
      *
      * Setup Parameters and Execute SR01 to
      * FORMAT THE INTERMEDIARY BANK
      *
     C     ORBT          IFNE      ' '
     C                   MOVEL     ORBT          ISPTP
     C                   MOVEL(P)  ORB1          ISPTY1
     C                   MOVEL(P)  ORB2          ISPTY2
     C                   MOVEL(P)  ORB3          ISPTY3
     C                   MOVEL(P)  ORB4          ISPTY4
     C                   MOVEL(P)  ORB5          ISPTY5
     C                   ELSE
     C                   MOVEL     ORCT          ISPTP
     C                   MOVEL(P)  ORC1          ISPTY1
     C                   MOVEL(P)  ORC2          ISPTY2
     C                   MOVEL(P)  ORC3          ISPTY3
     C                   MOVEL(P)  ORC4          ISPTY4
     C                   MOVEL     *BLANKS       ISPTY5
     C                   ENDIF
     C                   MOVE      PCCY          ISCCY
     C                   MOVE      'A'           IVTAG1                          TAG IND 1
     C                   MOVE      ' '           IVTAG2                          TAG IND 2
     C                   MOVE      'D'           IVTAG3                          TAG IND 3
      *
      * SET OFF INDICATOR FOR BLOCK OF SWFT CALL FOR DETAIL
      * Field Address(RATHER THAN DESTINATION Address)
      *
     C                   SETOFF                                       20
      *
     C                   EXSR      SR01
      *
      * Move Formatted Account With Bank Fields into Data Structure
     C                   MOVEL(P)  '52'          FLDNO
     C                   EXSR      FSWAD
      *
      * Populate printer file fields
     C                   MOVEL(P)  OSTAG         P1ORBT                         Tag Type
     C                   MOVEL(P)  OFSPT1        P1ORB1
     C                   MOVEL(P)  OFSPT2        P1ORB2
     C                   MOVEL(P)  OFSPT3        P1ORB3
     C                   MOVEL(P)  OFSPT4        P1ORB4
      *
     C                   MOVEL(P)  OFSPT1        P2ORB1
     C                   MOVEL(P)  OFSPT2        P2ORB2
     C                   MOVEL(P)  OFSPT3        P2ORB3
     C                   MOVEL(P)  OFSPT4        P2ORB4
      *
      *
     C                   ENDSR
      *EJECT
      *****************************************************************
     C     FLD72         BEGSR
      *---------------------------------------------------------------*
      * Field :72:  Bank to Bank Information                          *
      *                                                               *
      * Output the following for MT910 but do not update OTPAYDD      *
      * Pokrycie za przekaz do NNN na rzeca BBB                       *
      * NNN = name of the Destination Bank                            *
      * BBB = name of the Beneficiary                                 *
      *                                                               *
      *---------------------------------------------------------------*
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
     C                   MOVEL     ':72:'        MTAG                           Set TAG
      *
     C                   MOVEL(P)  F72@          OFSPT1
     C                   MOVEL(P)  DST1          OFSPT2
     C     'in favou'    CAT(P)    'r of'        OFSPT3
     C                   MOVEL(P)  BNC1          OFSPT4
     C                   MOVEL(P)  BNC2          OFSPT5
     C                   MOVEL(P)  BNC3          OFSPT6
      *
      * Bank to Bank Line 1
     C     Q             OCCUR     MULT
     C                   MOVEL     OFSPT1        MFLD
      *
      * Bank to Bank Line 2
     C     OFSPT2        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT2        MFLD
     C                   ENDIF
      *
      * Bank to Bank Line 3
     C     OFSPT3        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT3        MFLD
     C                   ENDIF
      *
      * Bank to Bank Line 4
     C     OFSPT4        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT4        MFLD
     C                   ENDIF
      *
      * Bank to Bank Line 5
     C     OFSPT5        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT5        MFLD
     C                   ENDIF
      *
      * Bank to Bank Line 6
     C     OFSPT6        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT6        MFLD
     C                   ENDIF
      *
      * Populate printer file fields
     C                   MOVEL(P)  OFSPT1        P1BTB1
     C                   MOVEL(P)  OFSPT2        P1BTB2
     C                   MOVEL(P)  OFSPT3        P1BTB3
     C                   MOVEL(P)  OFSPT4        P1BTB4
     C                   MOVEL(P)  OFSPT5        P1BTB5
     C                   MOVEL(P)  OFSPT6        P1BTB6
      *
     C                   MOVEL(P)  OFSPT1        P2BTB1
     C                   MOVEL(P)  OFSPT2        P2BTB2
     C                   MOVEL(P)  OFSPT3        P2BTB3
     C                   MOVEL(P)  OFSPT4        P2BTB4
     C                   MOVEL(P)  OFSPT5        P2BTB5
     C                   MOVEL(P)  OFSPT6        P2BTB6
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     FSWAD         BEGSR
      *---------------------------------------------------------------*
      * FSWAD - Format SWIFT address                                  *
      *---------------------------------------------------------------*
      *
      * Address 1
     C                   MOVEL     OFSPT1        MFLD
      *
      * SWIFT address;  Else full address
     C     OSTAG         IFEQ      'A'
     C                   MOVE      'A'           TAG
     C                   MOVE      @MTAG         MTAG                           Set TAG
      * Address 2
     C     OFSPT2        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT2        MFLD
     C                   ENDIF
     C                   ENDIF
      *
      * TAG = B
     C     OSTAG         IFEQ      'B'
     C                   MOVE      'B'           TAG
     C                   MOVE      @MTAG         MTAG                           Set TAG
     C                   ENDIF
      *
      * TAG = D
     C     OSTAG         IFEQ      'D'
     C                   MOVE      'D'           TAG
     C                   MOVE      @MTAG         MTAG                           Set TAG
      * Address 2
     C     OFSPT2        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT2        MFLD
      * Address 3
     C     OFSPT3        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVEL     OFSPT3        MFLD
      * Address 4
     C     OFSPT4        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT4        MFLD
      * Address 5
     C     OFSPT5        IFNE      *BLANKS
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   MOVE      *BLANKS       MULT
     C                   MOVEL     OFSPT5        MFLD
     C                   ENDIF                                                  Address 5
     C                   ENDIF                                                  Address 4
     C                   ENDIF                                                  Address 3
     C                   ENDIF                                                  Address 2
     C                   ENDIF                                                  Address 1
      *
     C     OFSPT1        IFEQ      *BLANKS
     C     OFSPT2        ANDEQ     *BLANKS
     C     OFSPT3        ANDEQ     *BLANKS
     C     OFSPT4        ANDEQ     *BLANKS
     C     OFSPT5        ANDEQ     *BLANKS
     C                   SUB       1             Q
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SR01          BEGSR
      *---------------------------------------------------------------*
      * To Format Settlement Party to SWIFT format                    *
      *---------------------------------------------------------------*
      *
      * Initialise output parameter fields
     C                   MOVE      *BLANKS       OFSPT1           35
     C                   MOVE      *BLANKS       OFSPT2           35
     C                   MOVE      *BLANKS       OFSPT3           35
     C                   MOVE      *BLANKS       OFSPT4           35
     C                   MOVE      *BLANKS       OFSPT5           35
     C                   MOVE      *BLANKS       OSTAG             1
     C                   MOVE      'N'           OSUFLG            1
     C                   MOVE      *BLANKS       CSID             12
      * Initialise
     C                   MOVEL     *BLANKS       ##BEID            1
      *
      * Full Nostro processing - Append the pay currency to the
      * first settlement party field to access Nostro details
      *
     C     ISPTP         IFEQ      'F'
      *
     C                   MOVEL     ISPTY1        DSNOST
     C                   Call      'AONOSTR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY'        POptn
     C                   Parm      *Blanks       PMCustNo          6
     C                   Parm                    DSNCcy
     C                   Parm                    PMAccCode        10
     C                   Parm                    PMAcctSeq         2
     C                   Parm                    DSNNNB
     C                   Parm                    PMBranch          3
     C                   Parm                    PMCustSName      10
     C                   Parm                    PMPNostro         2
     C     SDNOST        Parm      SDNOST        DSSDY
      *
     C     PRtcd         Ifne      *Blanks
     C                   MOVEL     'SDNOSTPD'    DBFNAM                         ***************
     C                   MOVEL     DSNOST        DBERKY                         **DB ERROR    *
     C                   Z-ADD     10            DBERR#                         ***************
     C                   EXSR      DBERR
     C                   Endif
      *
     C                   Move      A7CUST        CUSTNO            6
     C                   Move      A7CUST        CNum
     C                   Move      A7Brcd        BRCA
     C                   Move      A7Accd        ACOD
     C                   Move      A7Acsn        ACSQ
     C                   Move      A7Cycd        CCY
     C                   ENDIF
      *
      * Nostro No. processing - Append the pay ccy to the 1st two
      * chars of the 1st Setl Pty field so as to access Nostro Details
      *
     C     ISPTP         IFEQ      'N'
      *
     C                   MOVEL     ISPTY1        DSNNNB                         BUILD
     C                   MOVEL     ISCCY         DSNCCY                           KEY
      *
     C                   Call      'AONOSTR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY'        POptn
     C                   Parm      *Blanks       PMCustNo          6
     C                   Parm                    DSNCcy
     C                   Parm                    PMAccCode        10
     C                   Parm                    PMAcctSeq         2
     C                   Parm                    DSNNNB
     C                   Parm                    PMBranch          3
     C                   Parm                    PMCustSName      10
     C                   Parm                    PMPNostro         2
     C     SDNOST        Parm      SDNOST        DSSDY
      *
     C     PRtcd         Ifne      *Blanks
     C                   MOVEL     'SDNOSTPD'    DBFNAM                         ***************
     C                   MOVEL     DSNOST        DBERKY                         **DB ERROR    *
     C                   Z-ADD     20            DBERR#                         ***************
     C                   EXSR      DBERR
     C                   Endif
      *
     C                   MOVE      A7CUST        CUSTNO
     C                   Move      A7CUST        CNum
     C                   Move      A7Brcd        BRCA
     C                   Move      A7Accd        ACOD
     C                   Move      A7Acsn        ACSQ
     C                   Move      A7Cycd        CCY
     C                   ENDIF
      *
      * Retail Accnt processing -
      * Use 1st 10 chars of the 1st Setl Pty field to access
      * account details from LF/ACNUMA
      *
     C     ISPTP         IFEQ      'R'
      *
     C                   MOVEL     ISPTY1        ACNUMK           10 0
     C     ACNUMK        CHAIN     ACNUMA                             11
     C     *IN11         Ifeq      '1'
     C                   Movel     'ACNUMA'      DBFNAM                         ***************
     C                   Movel     ACNUMK        DBERKY                         **DB ERROR 030*
     C                   Z-add     30            DBERR#                         ***************
     C                   Exsr      DBERR
     C                   Endif
      *
     C                   MOVE      CNUM          CUSTNO
     C                   ENDIF
      *
      * IBAN number processing.
      *
     C     ISPTP         Ifeq      'I'

     C                   Movel     ISPTY1        ##001
     C     ##001         Ifeq      '/'
     C                   Subst     ISPTY1:2      EIBAN
     C                   else
     C                   Move      ISPTY1        EIBAN            34
     C                   Endif

     C                   Call      'AOIBANR4'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*KEY   '     POPTN
     C                   Parm                    EIBAN
     C     ACCNT         Parm                    DSSDY
      *
     C     PRTCD         Ifne      *BLANKS
     C                   Movel     'ACCNTAB'     DBFNAM                         ***************
     C                   Movel     EIBAN         DBERKY                         **DB ERROR 300*
     C                   Z-add     300           DBERR#                         ***************
     C                   Exsr      DBERR
     C                   Endif
      *
     C                   Move      CNUM          CUSTNO
     C                   ENDIF
      *
      *   Full Account/Partial Account/Customer processing - Cust no.
      *   is 1st 6 chars of the 1st Setl Pty field
     C     ISPTP         Ifeq      'G'
     C     ISPTP         Oreq      'P'
     C     ISPTP         Oreq      'C'
      *
      * If using account line construct then use second line
      *
     C                   MOVEL     ISPTY1        ##001             1
     C     ##001         IFEQ      '/'
     C                   MOVEL     ISPTY2        CUSTNO
     C                   ELSE
     C                   MOVEL     ISPTY1        CUSTNO
     C                   Endif
      *
     C                   Endif
      *
      ** Full Account or Partial Account processing
      *
     C     ISPTP         IFEQ      'G'
     C     ISPTP         OREQ      'P'
      *
     C                   Movel     ISPTY1        ##001
     C                   Move      *BLANKS       FACCNT
     C                   Move      *BLANKS       PACCNT
      *
      ** If using account line construct then use second line
      *
     C     ##001         Ifeq      '/'
     C                   Movel     ISPTY2        FACCNT
     C                   Else
     C                   Movel     ISPTY1        FACCNT
     C                   Endif
      *
      ** Prcessing for Partial account
     C     ISPTP         Ifeq      'P'
     C                   Movel     FACCNT        PACCNT
     C                   Movel     PCNUM         CNUM
     C                   Movel     PACOD         ACOD
     C                   Movel     PACSQ         ACSQ
      *
      ** Prcessing for Full account
     C                   Else
     C                   Movel     FCNUM         CNUM
     C                   Movel     FACOD         ACOD
     C                   Movel     FACSQ         ACSQ
     C                   Endif
      *
     C                   Endif
      *
      * If SWIFT identifier then use ME1400 to check details
      *
     C     ISPTP         IFEQ      'S'
      *
      *  Call Access object to validate identifier
      *
     C                   MOVEL     ISPTY1        ##001             1
     C     ##001         Ifeq      '/'
     C                   Movel     ISPTY2        W9BICC
     C     3             SUBST     ISPTY2:9      W9BICB
     C                   Else
     C                   Movel     ISPTY1        W9BICC
     C     3             SUBST     ISPTY1:9      W9BICB
     C                   Endif
      *
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       W9RTN             7
     C                   PARM                    W9BICC            8
     C                   PARM                    W9BICB            3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
      *
      * Check if special type of BIC
     C     W9BICD        Ifeq      'Y'
     C                   Call      'AOBEISR0'
     C                   Parm      *BLANKS       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      BDSUBT        PBIC              4
     C     MEBEIS        Parm      MEBEIS        DSFDY
      *
      * Check if special type of BIC
     C     PRTCD         Ifeq      *BLANKS
     C                   Movel     'Y'           ##BEID            1
     C                   Endif
     C                   Endif
      *
      * If customer details exist then set up CUSTNO
     C     W9CUST        Ifeq      'Y'
     C                   Movel     BBCUST        CUSTNO
     C                   Else
     C                   Movel     *Blanks       CUSTNO
     C                   Endif
      *
     C                   ENDIF
      *
      * Access Full customer details from LF/CLINT
      *
     C     ISPTP         Ifeq      'G'
     C     ISPTP         Oreq      'P'
     C     ISPTP         Oreq      'C'
     C     ISPTP         Oreq      'F'
     C     ISPTP         Oreq      'N'
     C     ISPTP         Oreq      'R'
     C     W9CUST        Oreq      'Y'
     C     ISPTP         andeq     'S'
     C     ISPTP         Oreq      'I'
      *
     C                   Move      CUSTNO        CUSTKY            6
      *
      *   Access SDCUSTPD using customer number
      *
     C                   Move      *BLANKS       @KEY1
     C                   Movel     CUSTKY        @KEY1
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Customer record not found - Error
      *
     C     @RTCD         Ifne      *BLANKS
     C                   Z-add     40            DBERR#                         ***************
     C                   Movel     @KEY1         DBERKY                         **DB ERROR 040*
     C                   Movel     'SDCUSTPD'    DBFNAM                         ***************
     C                   Exsr      DBERR
     C                   Endif
      *
      ** Move old field names to new to retain pgm continuity.
      *
     C                   MOVEL     BBPCNB        CPAR              6
     C                   MOVEL     BBCRNM        CRNM             20
     C                   MOVEL     BBCRTN        CTWN             10
     C                   MOVEL     BBCSID        CSID
     C                   MOVEL     BBCNA1        CNA1             35
     C                   MOVEL     BBCNA2        CNA2             35
     C                   MOVEL     BBCNA3        CNA3             35
     C                   MOVEL     BBCNA4        CNA4             35
      *
      * Get SWIFT BIC Details
      *
     C     BBCSID        Ifne      *BLANKS
     C                   Movel     BBCSID        W9BICC
     C     3             Subst     BBCSID:9      W9BICB
      *
     C                   Call      'ME1400'
     C                   Parm      *BLANKS       W9RTN
     C                   Parm                    W9BICC
     C                   Parm                    W9BICB
     C                   Parm                    SDCUST
     C                   Parm                    SDCNST
     C                   Parm                    MEBICD
     C                   Parm      *BLANKS       W9CUST
     C                   Parm      *BLANKS       W9CNST
     C                   Parm      *BLANKS       W9BICD
      *
      * Check if special type of BIC
     C     W9BICD        Ifeq      'Y'
     C                   Call      'AOBEISR0'
     C                   Parm      *BLANKS       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      BDSUBT        PBIC              4
     C     MEBEIS        Parm      MEBEIS        DSFDY
      *
      * Check if special type of BIC
     C     PRTCD         Ifeq      *BLANKS
     C                   Movel     'Y'           ##BEID            1
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      * Access Destination Address details via SWFT subroutine
      * (20 only set on for destination)
      *
     C     *IN20         Ifeq      '1'
     C                   Exsr      SRROUT
     C                   Endif
      *
     C                   Goto      SR01A
     C                   Endif
      *
      * If SWIFT identifier and destination of message set up
      * routing data
      *
     C     ISPTP         Ifeq      'S'
     C     *IN20         andeq     '1'
     C                   Movel     'Y'           OSUFLG
     C                   Move      *Blanks       CPAR
     C                   Movel     ISPTY1        CRNM
     C                   Movel     SNCSID        NWSN
     C                   Movel     ISPTY1        NWDS
     C                   MOVEL     'SWIFT'       NWRK
     C                   MOVEL     *BLANKS       CTWN
     C                   MOVEL     ISPTY1        CSID
      *
      * Default the message status whith the ICD.
      *
     C     BTMSCS        IFEQ      'R'
     C                   MOVE      'RSND'        MGST
     C                   MOVE      '2'           MGSG
     C                   ELSE
     C                   MOVE      'CRTD'        MGST
     C                   MOVE      '1'           MGSG
     C                   ENDIF
     C                   ENDIF
      *
      * Swift Address and at least one valid tag fields = 'A'
      *
     C     ISPTP         Ifeq      'S'
     C     IVTAG1        andeq     'A'
      *
      * If using account line construct then use second line
      *
     C                   Movel     ISPTY1        ##001
     C     ##001         Ifeq      '/'
     C                   Movel     ISPTY2        SP12
     C                   Movel     SP12          SCSID
     C                   Movel     ISPTY1        OFSPT1
     C                   Movel     SCSID         OFSPT2
     C                   Else
     C                   Movel     ISPTY1        SP12             12            1ST 12 CHARS
     C                   Movel     SP12          SCSID                          1ST 12 CHARS
     C                   Movel     SCSID         OFSPT1
     C                   Endif
      *
     C                   MOVE      'A'           OSTAG
     C                   GOTO      SR01N
      *
     C                   ENDIF
      *
      *   SWIFT Address and at least one valid tag fields = 'D'
      *
     C     ISPTP         Ifeq      'S'
     C     IVTAG3        andeq     'D'
      *
      * Use FT0315 to format text for D address type
      *  Set up general parameters
      *
     C     *LIKE         DEFINE    BJCYCD        XCCY
      *
     C                   CLEAR                   W8FT
     C                   MOVEL     *BLANKS       W8STMT
     C                   MOVEL     ##PGM         W8CPGM
     C                   MOVEL     '*MSG  '      W8ACT
     C                   Z-ADD     5             W8NLIN
     C                   MOVEL     'Y'           W8MTXT
      *
      *  Format data to be translated
      *
     C                   MOVEL     ISPTP         W8TYPE
     C                   MOVEL     ISCCY         W8CCY
     C                   MOVEL     *BLANKS       W8LINS
     C                   MOVEL     ISPTY1        ADCHK1
     C                   MOVEL     ISPTY2        ADCHK2
     C                   MOVEL     ISPTY3        ADCHK3
     C                   MOVEL     ISPTY4        ADCHK4
     C                   MOVEL     ISPTY5        ADCHK5
      *
     C     W8TYPE        Ifeq      'P'
     C     ISBRCA        andne     *BLANKS
     C                   Movel     ISBRCA        ADPBRC
     C                   Endif
      *
     C                   Movel     ADDRSS        W8LINS
      *
      * Call expansion program
      *
     C                   Call      'FT0315'                             1111
     C                   Parm                    W8RTN             7
     C                   Parm                    W8FT
     C                   Parm                    W8LINS          256
     C                   Parm                    W8RPT           256
     C                   Parm                    W8MSG           256
     C                   Parm                    W8SCR           256
      *
      ** Check if database error occurred
      *
     C     *IN11         Ifeq      '1'
     C     W8RTN         orne      *BLANKS
     C                   Z-add     50            DBERR#                         ***************
     C                   Movel     '*CALL'       DBERKY                         **DB ERROR 050*
     C                   Movel     'FT0315'      DBFNAM                         ***************
     C                   Exsr      DBERR
     C                   Endif
      *
     C                   Movel     W8MSG         ADDRSS
     C                   Movel     ADCHK1        OFSPT1
     C                   Movel     ADCHK2        OFSPT2
     C                   Movel     ADCHK3        OFSPT3
     C                   Movel     ADCHK4        OFSPT4
     C                   Movel     ADCHK5        OFSPT5
      *
     C                   MOVE      'D'           OSTAG
     C                   GOTO      SR01N
      *
     C                   ENDIF
      *
      * Full Address and at least one valid tag fields = 'D'
     C     ISPTP         Ifeq      'A'
     C     IVTAG3        andeq     'D'
     C                   Movel     ISPTY1        OFSPT1
     C                   Movel     ISPTY2        OFSPT2
     C                   Movel     ISPTY3        OFSPT3
     C                   Movel     ISPTY4        OFSPT4
     C                   Movel     ISPTY5        OFSPT5
     C                   Move      'D'           OSTAG
     C                   Goto      SR01N
     C                   Endif
      *
     C     SR01A         TAG
      *
      * IGNORE IF TYPE ' '
     C     ISPTP         Ifeq      ' '                                          B001
     C                   GOTO      SR01N
     C                   Endif                                                  E001
      *
      *   Valid TAG Field = 'D' and SWIFT address on LF/CLINT is <> Blank
      *
     C     IVTAG1        Ifeq      'A'
     C     CSID          andne     *BLANK
     C     ##BEID        andeq     *BLANK
      *
      * If using account line construct then use second line
      *
     C                   MOVEL     ISPTY1        ##001
     C     ##001         Ifeq      '/'
     C                   Movel     CSID          SCSID
     C                   Movel     ISPTY1        OFSPT1
     C                   Movel     SCSID         OFSPT2
     C                   Else
     C                   Movel     CSID          SCSID
     C                   Movel     SCSID         OFSPT1
     C                   Endif
      *
     C                   MOVE      'A'           OSTAG
     C                   GOTO      SR01N
      *
     C                   Endif
      *
      *   VALID TAG FIELD = 'B' AND THE CUSTOMER PARENT NUMBER FROM
      *  LF/CLINT IS NON ZERO AND EQUAL TO THE CUST. NO. OF HEAD OFFICE***
      *
      * If using account line construct then 'B' not allowed
      *
     C                   MOVEL     ISPTY1        ##001
     C     IVTAG2        IFEQ      'B'
     C     CPAR          ANDNE     *BLANKS
     C     CPAR          ANDEQ     SHEAD                                        SAVE 1ST CYCLE
     C     ##001         ANDNE     '/'
     C                   MOVEL     CTWN          OFSPT1
     C                   MOVE      'B'           OSTAG
     C                   GOTO      SR01N
     C                   ENDIF
      *
      *   VALID TAG FIELD = 'D'
     C     IVTAG3        IFEQ      'D'
      *
     C     IVTAG1        OREQ      'A'
     C     CSID          ANDNE     *BLANK
     C     ##BEID        ANDEQ     *BLANK
      *
      * Use FT0315 to format text for D address type
      *  Set up general parameters
      *
     C                   CLEAR                   W8FT
     C                   MOVEL     *BLANKS       W8STMT
     C                   MOVEL     ##PGM         W8CPGM
     C                   MOVEL     '*MSG  '      W8ACT
     C                   Z-ADD     5             W8NLIN
     C                   MOVEL     'Y'           W8MTXT
      *
      *  Format data to be translated
      *
     C                   MOVEL     ISPTP         W8TYPE
     C                   MOVEL     ISCCY         W8CCY
     C                   MOVEL     *BLANKS       W8LINS
     C                   MOVEL     ISPTY1        ADCHK1
     C                   MOVEL     ISPTY2        ADCHK2
     C                   MOVEL     ISPTY3        ADCHK3
     C                   MOVEL     ISPTY4        ADCHK4
     C                   MOVEL     ISPTY5        ADCHK5
     C     W8TYPE        IFEQ      'P'
     C     ISBRCA        ANDNE     *BLANKS
     C                   MOVEL     ISBRCA        ADPBRC
     C                   ENDIF
     C                   MOVEL     ADDRSS        W8LINS
      *
      * Call expansion program
      *
     C                   CALL      'FT0315'                             1111
     C                   PARM                    W8RTN             7
     C                   PARM                    W8FT
     C                   PARM                    W8LINS          256
     C                   PARM                    W8RPT           256
     C                   PARM                    W8MSG           256
     C                   PARM                    W8SCR           256
      *
      ** Check if database error occurred
      *
     C     *IN11         IFEQ      '1'
     C     W8RTN         ORNE      *BLANKS
     C                   Z-ADD     60            DBERR#                         ***************
     C                   MOVEL     '*CALL'       DBERKY                         **DB ERROR 060*
     C                   MOVEL     'FT0315'      DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   MOVEL     W8MSG         ADDRSS
     C                   MOVEL     ADCHK1        OFSPT1
     C                   MOVEL     ADCHK2        OFSPT2
     C                   MOVEL     ADCHK3        OFSPT3
     C                   MOVEL     ADCHK4        OFSPT4
     C                   MOVEL     ADCHK5        OFSPT5
     C                   MOVE      'D'           OSTAG
     C                   ENDIF
      *
      *
     C     SR01N         TAG
     C                   EXSR      EMBLK
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     EMBLK         BEGSR
      *---------------------------------------------------------------*
      * To Eliminate Blank Lines on Name and Address Fields           *
      *****************************************************************
      *
     C                   MOVEA     *BLANKS       ADDR
     C                   Z-ADD     1             A                 1 0
      *
     C     OFSPT1        IFNE      *BLANK
     C                   MOVE      OFSPT1        ADDR(A)
     C                   ADD       1             A
     C                   ENDIF
      *
     C     OFSPT2        IFNE      *BLANK
     C                   MOVE      OFSPT2        ADDR(A)
     C                   ADD       1             A
     C                   ENDIF
      *
     C     OFSPT3        IFNE      *BLANK
     C                   MOVE      OFSPT3        ADDR(A)
     C                   ADD       1             A
     C                   ENDIF
      *
     C     OFSPT4        IFNE      *BLANK
     C                   MOVE      OFSPT4        ADDR(A)
     C                   ADD       1             A
     C                   ENDIF
      *
     C     OFSPT5        IFNE      *BLANK
     C                   MOVE      OFSPT5        ADDR(A)
     C                   ADD       1             A
     C                   ENDIF
      *
     C                   MOVEA     ADDR          OFSPT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SR03          BEGSR
      *****************************************************************
      * TO FORMAT AMOUNT                                              *
      *****************************************************************
      *
      *   Access SDCURRPD to find decimal position
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   If        PRtCd <> *BLANKS
     C                   Movel     'SDCURRPD'    DBFNAM                         ***************
     C                   Movel     PCcy          DBERKY                         **DB ERROR 080*
     C                   Z-add     080           DBERR#                         ***************
     C                   Exsr      DBERR
     C                   Endif
      *
      * The following amendment is because PLN is held in a compressed
      * form in the dbase, and this needs to be expanded for External media,
      * compressed for incoming data. In case of further changes, a M/D indicator
      * is also used to decide how to manupulate the data.
      *
      * Determine DECIMAL POSITION (FOR REPORT)
     C     A6NBDP        COMP      2                                  33  32
     C     A6NBDP        COMP      1                                    3031
      *
      * Determine DECIMAL POSITION
     C     14            SUB       A6NBDP        X                 2 0
      * IF 0 DECIMAL PLACES DON'T EDIT
     C     A6NBDP        Ifeq      0
     C                   Move      *BLANK        AMT
     C                   Move      *ZEROS        AM
     C                   Movea     RAMNT         AMT(2)
     C                   Movea     RAMNT         AM(1)
     C                   Z-add     13            W
     C                   MOVE      ','           AM(X)
     C                   Else
      * MOVE AMOUNT into ARRAY
     C                   Movea     RAMNT         AMT(1)
      * Determine POSITION OF DECIMAL DIGITS IN 2ND ARRAY
     C     X             Add       1             Y                 2 0
      * MOVE DECIMAL DIGITS into 2ND ARRAY Field
     C                   Movea     AMT(X)        AM(Y)
      * Determine POSITION & MOVE COMMA
     C                   Sub       1             Y
     C                   Move      ','           AM(Y)
      * Determine POSITION OF DIGIT B4  COMMA
     C                   Sub       1             Y
      * SAVE POSITION OF DIGIT B4  COMMA
     C                   Z-add     Y             W                 2 0
      * Determine POSITION OF DIGIT TO BE MOVED B4  COMMA
     C                   Sub       1             X
     C                   Z-add     X             Z                 2 0
      * DO OPERATIONS MOVING CHARACTERS ONE AT A TIME
      * FROM RIGHT TO LEFT
     C                   DO        X
     C                   MOVE      AMT(Z)        AM(Y)
     C                   SUB       1             Z
     C                   SUB       1             Y
     C                   ENDDO
     C                   Endif
      * SET INDEX TO 1
     C                   Z-ADD     1             Y
      * REPLACE LEADING ZEROS WITH BLANK
     C     AM(Y)         DOWEQ     '0'
     C     Y             CABEQ     W             SR03A
     C                   MOVE      ' '           AM(Y)
     C                   ADD       1             Y
     C                   ENDDO
      * SAVE Field FROM ARRAY
     C     SR03A         TAG
     C                   MOVEA     AM            AMX              14
     C                   MOVE      AMX           SAM              15
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SR06          BEGSR
      *****************************************************************
      * Determine and Format Amount Outgoing Payments                 *
      *****************************************************************
      *
      * CHECK 'ADD/DEDUCT' IND NOT = 'A' AND
      * 'CHARGES TO THE DEBIT ACCOUNT' IS BLANK
      *
     C     ADDC          IFNE      'A'
     C     CDRO          ANDEQ     *BLANKS
     C     PYAM          SUB       TXCH          WAMNT            13 0          Telex Charges
     C     WAMNT         SUB       CQCH          WAMNT                          Cheque Charges
      *
      ** Subtract CSTA (cost abroad) and SPCH (SWIFT PR charge) from
      ** amount only for Outgoing Payment.
      *

     C     PYTP          IFEQ      'OP'
     C     WAMNT         SUB       CSTA          WAMNT
     C     WAMNT         SUB       SPCH          WAMNT
     C                   ENDIF
     C     WAMNT         SUB       MSCH          WAMNT
     C     WAMNT         SUB       TRCM          WAMNT
     C                   ENDIF
      *
     C     ADDC          IFEQ      'A'
     C     CDRO          ORNE      *BLANKS
     C                   Z-ADD     PYAM          WAMNT
     C                   ENDIF
      *
      * Format The Amount
     C                   EXSR      SR03
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRP1          BEGSR
      *---------------------------------------------------------------*
      * Output AN ENTRY TO SWIFT MESSAGE Report PRTF/FT162002P1       *
      *---------------------------------------------------------------*
      *
      *
     C                   MOVEL     PREF          P1PREF
      *
     C                   WRITE     HEADP1                               80
      *
     C     *IN80         IFEQ      *ON
     C                   MOVEL     'FT162002P1'  DBFNAM                         ***************
     C                   MOVEL     '1'           DBERKY                         **DB ERROR 090*
     C                   Z-ADD     090           DBERR#                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C     SRP2          BEGSR
      *****************************************************************
      * TO HANDLE TELEX REPORT
      *****************************************************************
      *
     C                   MOVEL     PREF          P2PREF
      *
      * FORMAT RECEIVING BANK FROM DESTINATION FIELDS
     C                   MOVEL     DSTT          ISPTP
     C                   MOVEL     PCCY          ISCCY
     C                   MOVEL(P)  DST1          ISPTY1
     C                   MOVE(P)   DST2          ISPTY2
     C                   MOVE(P)   DST3          ISPTY3
     C                   MOVE(P)   DST4          ISPTY4
     C                   MOVE(P)   *BLANKS       ISPTY5
      *
     C                   SETOFF                                       20
     C                   EXSR      SR01
      *
      * DESTINATION FIELD PRINT LINE
     C                   MOVEL     OFSPT1        P2DST1
     C                   MOVEL     OFSPT2        P2DST2
     C                   MOVEL     OFSPT3        P2DST3
     C                   MOVEL     OFSPT4        P2DST4
     C                   MOVEL     OFSPT5        P2DST5
      *
      * Change of ccy, then print; else suppress ccy
      * 'A6CYNM' is from SDCURRPD access in SR03 via SR06
     C     P2CCY         IFNE      A6CYNM
     C                   SETON                                        14
     C                   Z-ADD     0             MREC              1 0
     C                   MOVE      A6CYNM        P2CCY
     C                   ELSE
     C                   ADD       1             MREC
     C                   SETOFF                                       14
     C                   ENDIF
      *
     C     MREC          IFGT      1
     C                   SETON                                        14
     C                   Z-ADD     0             MREC
     C                   ENDIF
      *
      * CONVERT PAY VALUE DATE FROM 'YYMMDD' TO 'DDMMMYY'
     C                   MOVE      PVDTD3        SDATE
     C                   MOVE      MTH(SMM)      WMM
     C                   MOVE      SDD           WDD
     C                   MOVE      SYY           WYY
      *
      * CHANGE DATE THEN PRINT ELSE SUPRESS DATE PRINTING
     C     WDATE         IFNE      P2VAL
     C                   SETON                                        15
     C                   Z-ADD     0             DREC              1 0
     C                   MOVEL     WDATE         P2VAL
     C                   ELSE
     C                   ADD       1             DREC
     C                   SETOFF                                       15
     C                   ENDIF
      *
     C     DREC          IFGT      1
     C                   SETON                                        15
     C                   Z-ADD     0             DREC
     C                   ENDIF
      *
      *
      *
      * PRINT TELEX MESSAGE
     C   14
     COR 15              WRITE     HEADP2                               80
      *
     C     *IN80         IFEQ      *ON
     C                   MOVEL     'FT162002P2'  DBFNAM                         ***************
     C                   MOVEL     '2'           DBERKY                         **DB ERROR 100*
     C                   Z-ADD     100           DBERR#                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRROUT        BEGSR
      *---------------------------------------------------------------*
      *   SRROUT - determine message routing                          *
      *   Called by - SR01                                            *
      *   Calls -                                                     *
      *---------------------------------------------------------------*
      *
     C                   MOVE      BRCA          I@SNBR
     C                   MOVE      *BLANKS       I@DSCN
     C                   MOVE      CUSTNO        I@DSCN
     C                   MOVE      '910'         I@MTPY
     C                   MOVE      'N'           I@CONC
     C                   Z-ADD     8             I@SETT
     C                   MOVE      BTMSCS        I@FTCS
     C                   MOVE      MODI          I@MMOD
      *
     C                   CALL      'MG9900'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    P@IN
     C                   PARM      *BLANKS       P@OUT
     C                   PARM                    P@ZZ            256
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     110           DBERR#                         ***************
     C                   MOVEL     '*CALL'       DBERKY                         **DB ERROR 110*
     C                   MOVEL     'MG9900  '    DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ELSE
     C                   MOVE      O@CNSN        SBICN             6
     C                   MOVE      O@SWSN        SNCSID
     C                   MOVE      O@SWSN        SCSID
     C                   MOVE      O@NWRK        NWRK
     C                   MOVE      O@NWSN        NWSN                           Network Senders
     C                   MOVE      O@NWSN        P1NWSN                         Network Senders
     C                   MOVE      O@NWDS        NWDS                           Network Dest Ad
     C                   MOVE      O@NWDS        P1NWDS                         Network Dest Ad
     C                   MOVE      O@MGSG        MGSG
     C                   MOVE      O@MGST        MGST
     C                   MOVE      O@PCNB        CPAR
     C                   ENDIF
      *
     C     BBDNW1        IFEQ      *BLANKS
     C     NWRK          IFEQ      'SWIFT'
     C                   MOVE      'S'           SWTX              1
     C                   ENDIF
     C     NWRK          IFEQ      'TELEX'
     C                   MOVE      'T'           SWTX
     C                   ENDIF
     C     NWRK          IFEQ      'STTX'
     C                   MOVE      'X'           SWTX
     C                   ENDIF
     C                   ENDIF
      *
     C     NWRK          IFNE      'PAPER'
     C                   MOVE      'Y'           OSUFLG
     C                   ELSE
     C                   MOVE      'N'           OSUFLG
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   INTF - Initalise non-constant fields                        *
      *   Called by - main process                                    *
      *   Calls     -                                                 *
      *****************************************************************
      *
     C     INTF          BEGSR
      *
     C                   MOVE      '      '      NWRK
     C                   MOVE      *BLANKS       SECN
     C                   MOVE      *BLANKS       NWSN
     C                   MOVE      *BLANKS       DECN
     C                   MOVE      *BLANKS       NWDS
     C                   MOVE      *BLANKS       MGSG
     C                   MOVE      *BLANKS       MGST
     C                   Z-ADD     0             MGTM
     C                   Z-ADD     0             LATM
     C                   MOVE      *BLANKS       RELD
     C                   Z-ADD     0             RELT
     C                   MOVE      *BLANKS       AMTS
     C                   MOVE      *BLANKS       SVDT
      *
     C                   MOVE      *BLANKS       SNCSID           12
     C                   MOVE      *BLANKS       STELX            10
     C                   MOVE      *BLANKS       SSTTX            12
     C                   MOVE      *BLANKS       SCRNM            20
      *
     C                   MOVE      *BLANKS       P1BTB1
     C                   MOVE      *BLANKS       P1BTB2
     C                   MOVE      *BLANKS       P1BTB3
     C                   MOVE      *BLANKS       P1BTB4
     C                   MOVE      *BLANKS       P1BTB5
     C                   MOVE      *BLANKS       P1BTB6
     C                   MOVE      *BLANKS       P2BTB1
     C                   MOVE      *BLANKS       P2BTB2
     C                   MOVE      *BLANKS       P2BTB3
     C                   MOVE      *BLANKS       P2BTB4
     C                   MOVE      *BLANKS       P2BTB5
     C                   MOVE      *BLANKS       P2BTB6
      *
      **  Clear multiple occurrence data structure
      *
     C                   Z-ADD     1             Q                 2 0
     C     Q             OCCUR     MULT
      *
     C     Q             DOWLE     94
     C                   MOVE      *BLANKS       MULT
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     OMSG          BEGSR
      *---------------------------------------------------------------*
      *   OMSG - output correctly generated messages                  *
      *   Called by - main process                                    *
      *   Calls - WREF Write o/p reference to PF/MGOREFPD.            *
      *---------------------------------------------------------------*
      *
      **  Write reference record to PF/MGOREFPD.
     C                   EXSR      WREF
      *
      **  Write multiple occurrence data structure to MGOMSGPD
     C                   Z-ADD     1             Q                 2 0
     C     Q             OCCUR     MULT
      *
     C     Q             DOWLE     50
     C     MFLD          ANDNE     *BLANKS
     C                   WRITE     MGOMSGD0                             42
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C     *IN42         IFEQ      '1'
     C                   Z-ADD     150           DBERR#                         ***************
     C                   MOVEL     '       '     DBERKY                         **DB ERROR 150*
     C                   MOVEL     'MGOMSGPD'    DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ADD       1             AUNO2
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   ENDDO
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
     C     WREF          BEGSR
      *---------------------------------------------------------------*
      *   WREF - Write reference record to PF/MGOREFPD                *
      *   Called by - OMSG  output message PF/MGOMSGPD                *
      *   Calls     -                                                 *
      *****************************************************************
      *
     C                   MOVE      *BLANKS       SYTM
     C                   MOVEL     'FT'          MODI
     C                   MOVEL     MGTRNA        TRNO
     C                   MOVE      *BLANKS       TRNF
     C                   MOVE      *BLANKS       TRNM
     C                   MOVEL     PREF          MTRN
     C                   MOVE      PYTP          TNTP
     C                   MOVE      PYST          SBTP
     C                   MOVE      *BLANKS       EVTP
     C                   MOVEL     SBICN         SECN
     C                   MOVEL     SDECN         DECN
     C                   MOVEL     BNC1          NWBN
     C                   MOVE      '910'         MTPY
      *
      ** Set-up Destination with details from PF/SDM901PD
      *
      ** If destination is a customer, load destination.
      ** Otherwise, leave the defaulted customer of the account

     C                   Move      *Blanks       WkCnum            6
     C                   Eval      WkCnum = %Subst(ZDEST(u):1:6)
     C                   If        %Subst(ZDEST(u):7:4) = *Blanks
     C                   Movel     ZDEST(u)      DECN
     C                   Endif

      ** If the destination is a SWIFT address, retrieve the customer
      ** number of destination.
     C                   IF        %Subst(ZDEST(u):7:4) <> *Blanks

     C                   Movel     ZDEST(u)      WSwiftId         12
     C     WSwiftId      Chain     @CUSTGE                            44
      ** Try removing branch 'XXX' if fails the first time.
     C                   If        *IN44 = *ON And
     C                             %Subst(WSwiftId:9:3) = 'XXX'
     C                   Eval      %Subst(WSwiftId:9:3) = '   '
     C     WSwiftId      Chain     @CUSTGE                            44
     C                   Endif
     C                   If        *IN44 = *OFF
     C                   Movel     BBCUST        DECN
     C                   Eval      NWDS = ZDEST(u)
     C                   If        P1NWDS = O@NWDS
     C                             and NWDS <> P1NWDS
     C                   Eval      P1NWDS = NWDS
     C                   Endif
     C                   Endif

      ** If the destination is a customer number, retrieve the SWIFT address of customer.
     C                   ELSE
     C
     C                   Call      'AOCUSTR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY'        POptn
     C                   Parm      ZDEST(u)      P@KEY1           10
     C                   Parm                    P@KYST            7
     C     SDCUST        Parm      SDCUST        DSSDY

     C                   If        PRtcd = *Blanks
     C                   Movel     BBCUST        DECN
     C                   If        BBCSID <> *BLANKS
     C                   Movel     BBCSID        NWDS
     C                   Eval      P1NWDS = BBCSID
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   Move      BRCA          I@SNBR
     C                   Move      *BLANKS       I@DSCN
     C                   Move      DECN          I@DSCN
     C                   Move      '910'         I@MTPY
     C                   Move      'N'           I@CONC
     C                   z-add     8             I@SETT
     C                   Move      BTMSCS        I@FTCS
     C                   Move      MODI          I@MMOD
      *
     C                   Call      'MG9900'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm                    P@IN
     C                   Parm      *BLANKS       P@OUT
     C                   Parm                    P@ZZ            256
      *
     C     @RTCD         Ifne      *BLANKS
     C                   z-add     120           DBERR#                         ***************
     C                   Movel     '*CALL'       DBERKY                         **DB ERROR 120*
     C                   Movel     'MG9900  '    DBFNAM                         ***************
     C                   Exsr      DBERR
     C                   Else
     C                   Move      O@CNSN        SBICN             6
     C                   Move      O@SWSN        SNCSID
     C                   Move      O@SWSN        SCSID
     C                   Move      O@NWRK        NWRK
     C                   Move      O@NWSN        NWSN                           Network Senders
     C                   Move      O@NWSN        P1NWSN                         Network Senders
     C                   Move      O@NWDS        NWDS                           Network Dest Ad
     C                   Move      O@NWDS        P1NWDS                         Network Dest Ad
     C                   Move      O@MGSG        MGSG
     C                   Move      O@MGST        MGST
     C                   Move      O@PCNB        CPAR
     C                   Endif
      *
      * Set Network to default from SDM910PD
      *
     C                   Eval      NWRK = M9NWRK
      *
     C     NWRK          IFEQ      'SWIFT'
     C                   MOVE      'S'           SWTX              1
     C                   ENDIF
     C     NWRK          IFEQ      'TELEX'
     C                   MOVE      'T'           SWTX
     C                   ENDIF
     C     NWRK          IFEQ      'STTX'
     C                   MOVE      'X'           SWTX
     C                   ENDIF

      * FORMAT SWIFT PRIORITY CODE
     C     SWPC          IFEQ      1
     C                   MOVE      'U'           MPRY
     C                   ELSE
     C     SWPC          IFEQ      2
     C                   MOVE      'N'           MPRY
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     *BLANKS       LSCC
     C                   MOVEL     *BLANKS       PTST
     C                   MOVEL     *BLANKS       CARQ
     C                   MOVEL     *BLANKS       MPDE
     C                   MOVEL     @HRDT         HRDT
     C                   TIME                    MGTM
     C                   MOVE      SRUNA         LADT
     C                   MOVE      MGTM          LATM
      *
      **  Convert run date to YYMMDD
      *
     C                   CALL      'ZM0060'
     C                   PARM      BJRDNB        ZMDAY             5 0
     C                   PARM                    ZMDATE            6
     C                   MOVE      ZMDATE        MGDE
      *
      ** Set-up Message Generation  Century flag
      *
     C                   MOVEL     MGDE          YY                2 0
     C     YY            IFLT      72
     C                   MOVE      '2'           CIND
     C                   ELSE
     C                   MOVE      '1'           CIND
     C                   ENDIF
      *
     C     MGST          IFEQ      'RSND'
     C                   MOVE      SRUNA         RELD
     C                   MOVE      LATM          RELT
     C                   ENDIF
      *
     C     AUP2          IFNE      *BLANK
     C                   MOVE      AUP2          RUSR
     C                   ELSE
     C                   MOVE      AUP1          RUSR
     C                   ENDIF
     C                   MOVEL     *BLANKS       RWSN
     C                   MOVEL     P1AMNT        AMTS
     C                   MOVEL     P1AMNT        AMTX
     C                   MOVEL     PVDTD3        SVDT
     C                   MOVE      PCCY          CCY
     C                   MOVEL     *BLANKS       NSNO
     C*****DSTT          IFEQ      'F'
     C**********         MOVE      NOSTN         NSNO
     C**********         ENDIF
     C                   MOVEL     *BLANKS       SACN
     C                   MOVEL     *BLANKS       AORR
     C                   MOVEL     *BLANKS       DESI
      *
      **  Branch details
      *
      * IF MULTIBRANCH INDICATOR FROM RUNDAT ACTIVE
     C     *IN50         IFEQ      '1'
     C     BRCA          IFNE      ORBR
     C                   MOVE      ORBR          ORBR              3
     C                   MOVE      ORBR          OTHB
      * MOVE "ORIGINATING BRANCH" TO 'OTHER BRANCH TYPE'(OTHT)
     C                   MOVE      ' BRANCH"'    FLD1             20
     C                   MOVEL     '"ORIGINA'    FLD2             12
     C                   MOVE      'TING'        FLD2
     C                   MOVEL     FLD2          FLD1
     C                   MOVE      FLD1          OTHT
      *
     C                   ELSE
     C                   MOVE      *BLANKS       OTHB
     C                   MOVE      *BLANKS       OTHT
     C                   ENDIF
      * IF MULTIBRANCH INDICATOR FROM RUNDAT NOT ACTIVE
     C                   ELSE
     C                   MOVE      *BLANKS       OTHB
     C                   MOVE      *BLANKS       OTHT
     C                   ENDIF
     C                   MOVE      *BLANKS       RCBR
      *
     C                   MOVE      *BLANKS       NETI
      *
      * READ SDCURRPD FOR DELIVERY NOTIFICATION AND NON-DELIVERY
      * WARNING FLAGS
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      PCCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     170           DBERR#                         ***************
     C                   MOVEL     @CCY          DBERKY                         **DB ERROR 170*
     C                   MOVEL     'SDCURRPD'    DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C     A6NDWR        IFEQ      'Y'
     C     A6DNOR        ANDEQ     'Y'
     C                   MOVE      '3'           DELC
     C                   ENDIF
     C     A6NDWR        IFNE      'Y'
     C     A6DNOR        ANDEQ     'Y'
     C                   MOVE      '2'           DELC
     C                   ENDIF
     C     A6NDWR        IFEQ      'Y'
     C     A6DNOR        ANDNE     'Y'
     C                   MOVE      '1'           DELC
     C                   ENDIF
     C     A6NDWR        IFNE      'Y'
     C     A6DNOR        ANDNE     'Y'
     C                   MOVEL     *BLANKS       DELC
     C                   ENDIF
      *
      * Ensure that message priority and delivery notification are
      * valid combination :
      * 1. for MPRY = 'U' DELC must be '1' or '3',
      * 2. for MPRY = 'N' DELC must be ' ' or '2'.
      *
     C     MPRY          IFEQ      'U'
     C     DELC          ANDEQ     ' '
     C     MPRY          OREQ      'U'
     C     DELC          ANDEQ     '2'
     C                   MOVEL     '1'           DELC
     C                   ENDIF
      *
     C     MPRY          IFEQ      'N'
     C     DELC          ANDEQ     '1'
     C     MPRY          OREQ      'N'
     C     DELC          ANDEQ     '3'
     C                   MOVEL     '2'           DELC
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       DYST
     C                   MOVE      *BLANKS       RSID
     C                   MOVE      *BLANKS       MSE1
     C                   MOVE      *BLANKS       ELIN
     C                   MOVE      *BLANKS       SSAC
     C                   MOVE      *BLANKS       MIR
     C                   MOVE      'Y'           TSKS
     C                   MOVE      *BLANKS       TSKY
      *
     C                   WRITE     MGOREFD0                             41
      *
      **  Error on write to PF/MGOREFPD (message reference file)
      *
     C     *IN41         IFEQ      '1'
     C                   Z-ADD     180           DBERR#                         ***************
     C                   MOVEL     '       '     DBERKY                         **DB ERROR 180*
     C                   MOVEL     'MGOREFPD'    DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ADD       1             AUNO3
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     FIRST         BEGSR
      *---------------------------------------------------------------*
      * First Record Processing                                       *
      *---------------------------------------------------------------*
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      * IF MULTIBRANCH INDICATOR IS ACTIVE FROM RUNDAT
     C     AGMBIN        IFEQ      'Y'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
      *
      * MOVE REPORT NAME AND SPOOL FILE NBR TO ZSFILE AND CALL ZSFILE
     C                   Z-ADD     SFNUM1        SPLNO
     C                   MOVEL     SFILE1        SFILP
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ                           IO-Rpt Seq
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      * IF ERROR PERFORM DATABASE ERROR HANDLING AND EXIT PROGRAM
      *
     C     ZERR          IFEQ      'Y'
     C                   Z-ADD     190           DBERR#                         ***************
     C                   MOVEL     'FT162002P1'  DBERKY                         **DB ERROR 190*
     C                   MOVEL     'ZSFILE'      DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      * MOVE REPORT NAME AND SPOOL FILE NBR TO ZSFILE AND CALL ZSFILE
     C                   Z-ADD     SFNUM2        SPLNO
     C                   MOVEL     SFILE2        SFILP
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ                           IO-Rpt Seq
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      * IF ERROR PERFORM DATABASE ERROR HANDLING AND EXIT PROGRAM
      *
     C     ZERR          IFEQ      'Y'
     C                   Z-ADD     200           DBERR#                         ***************
     C                   MOVEL     'FT162002P2'  DBERKY                         **DB ERROR 200*
     C                   MOVEL     'ZSFILE'      DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      * MOVE AUDIT REPORT NAME AND SPOOL FILE NBR TO ZSFILE AND
      * CALL ZSFILE
     C                   Z-ADD     SFNUMU        SPLNO
     C                   MOVEL     SFILEU        SFILP
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ                           IO-Rpt Seq
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      * IF ERROR PERFORM DATABASE ERROR HANDLING AND EXIT PROGRAM
      *
     C     ZERR          IFEQ      'Y'
     C                   Z-ADD     210           DBERR#                         ***************
     C                   MOVEL     'FT162002AU'  DBERKY                         **DB ERROR 210*
     C                   MOVEL     'ZSFILE'      DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      * Initialise Record Counters
     C                   Z-ADD     0             AUNO1
     C                   Z-ADD     0             AUNI1
     C                   Z-ADD     0             AUNO2
     C                   Z-ADD     0             AUNO3
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If error, then do
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFnam = 'SDBANKPD'
     C                   EVAL      DBErr# = 220
     C                   EVAL      DBerky = POptn
     C                   Exsr      DBErr
     C                   ENDIF
      *
      ** Get Funds Transfer ICD
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDFTFRPD'    DBFILE
     C                   MOVEL     '230'         DBASE
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   MOVE      BJMRDT        SRUNA                          SAVE ALPHA DATE
     C                   MOVE      BJURPT        STITL            53            SAVE TITLE
     C                   MOVEL     BJCUST        SHEAD             6            SAVE CUST NO OF
      *
      *
      **  Access SDMMODPD for networks available.
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** If no record is found on sdmmodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     240           DBERR#                         ***************
     C                   MOVEL     'FIRST'       DBERKY                         **DB ERROR 240*
     C                   MOVEL     'SDMMODPD'    DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      **  Access SDMGMEPD for drop SWIFT msg. no. days
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMGME        PARM      SDMGME        DSFDY
      *
      ** If no record is found on SDMGMEPD.
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     250           DBERR#                         ***************
     C                   MOVEL     'FIRST'       DBERKY                         **DB ERROR 250*
     C                   MOVEL     'SDMGMEPD'    DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      **  Convert history retention date to YYMMDD
      *
     C     BJRDNB        ADD       ENDSMN        ZMDAY
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY
     C                   PARM                    ZMDATE
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C                   Z-ADD     260           DBERR#                         ***************
     C                   MOVEL     '       '     DBERKY                         **DB ERROR 260*
     C                   MOVEL     'ZM0060'      DBFNAM                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
     C                   MOVE      ZMDATE        @HRDT             6
      *
      **  Initialise constant fields
      *
     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVEL     CR            CRLF              2
     C                   MOVE      LF            CRLF
     C                   MOVE      ':'           COLON1
     C                   MOVE      ':'           COLON2
      *
      **  CRLF Control Character for message data records
      *
     C                   MOVE      CRLF          CTRC
      *
      * CHECK TYPE OF RUN
     C     RMODE         IFEQ      'I'
     C                   SETON                                        13
     C                   ENDIF
      * SET MESSAGE PRODUCTION PARAMETER
     C                   MOVE      'N'           OPPARM            1
      *
      ** Define key list to access LF/SDM901L0
     C     KM9ACC        Klist
     C                   Kfld                    CNUM
     C                   Kfld                    PCCY
     C                   Kfld                    ACOD
     C                   Kfld                    ACSQ
     C                   Kfld                    P2BRCA
      *
     C                   Move      *Blanks       K9Ccy             3
     C                   z-add     0             K9Acod           10 0
     C                   z-add     0             K9Acsq            2 0
     C                   Move      *Blanks       K9Brca            3
     C     KM9CUS        Klist
     C                   Kfld                    F25_Cnum
     C                   Kfld                    K9Ccy
     C                   Kfld                    K9Acod
     C                   Kfld                    K9Acsq
     C                   Kfld                    K9Brca
      *
     C     TAGEND        TAG
     C                   SETON                                        40         1ST CYCLE DONE
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     LAST          BEGSR
      *---------------------------------------------------------------*
      * Last Record Processing                                        *
      *---------------------------------------------------------------*
      *
      * Output A RUN CONTROL REPORT
     C  N40              EXSR      FIRST
     C                   WRITE     HEADAU                               80
      *
     C     *IN80         IFEQ      *ON
     C                   MOVEL     'FT162002AU'  DBFNAM                         ***************
     C                   MOVEL     'AU'          DBERKY                         **DB ERROR 270*
     C                   Z-ADD     270           DBERR#                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     DBERR         BEGSR
      *---------------------------------------------------------------*
      * Set Up Data Structure FOR Database Errors.                    *
      *---------------------------------------------------------------*
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'FT162002'    DBPGM                          ) Set Up
     C                   MOVE      DBFNAM        DBFILE                         ) Data Base
     C                   MOVEL     DBERKY        DBKEY                          ) Error
     C                   Z-ADD     DBERR#        DBASE                          ) Fields
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     @DEFN         BEGSR
      *---------------------------------------------------------------*
      * This subroutine is never invoked. Used to setup Key Lists etc *
      *---------------------------------------------------------------*
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      * Now our *LIKEs
      *
     C     *LIKE         DEFINE    DBKEY         DBERKY                         Key information
     C     *LIKE         DEFINE    DBASE         DBERR#                         Unique No
     C     *LIKE         DEFINE    DBFILE        DBFNAM                         File Name
     C     *LIKE         DEFINE    OPPARM        RMODE
     C     *LIKE         DEFINE    DECN          SDECN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2017
**  MTH - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
