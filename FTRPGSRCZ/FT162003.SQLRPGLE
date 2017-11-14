     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas FT MT900 Bank Transfer Supplementay Messages')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT162003 - MT900 Bank Transfers Supplementary Messages       *
      *                                                               *
      *  Function:  This program outputs a MT900 message for incoming *
      *             and outgoing payments in the following format:-   *
      *                                                               *
      *             :20:  Transaction                                 *
      *             :21:  Related Transaction                         *
      *             :25:  Account Identification                      *
      *             :32A: Value Date/CCY/Amount                       *
      *                                                               *
      *  Called By: FTC162003                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2017            *
      *                                                               *
      *  Last Amend No. CFT162  *Create    Date 07Sep17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation                  *
      *                                                               *
      *****************************************************************
      *
     FSDM901L0  IF   E           K DISK
      * SD Account/Customer MT900/MT910 Details
      *
     FOTPAY     IF   E           K DISK
      ** Funds Transfer Outgoing Payments
      *
     FOTPAYXL4  UF   E           K DISK
      ** Outgoing payments extension file - MT900 selection
      *
     FINPAY     IF   E           K DISK
      ** Funds Transfer Incoming Payments
      *
     FINPAYXL5  UF   E           K DISK
      ** Incoming payments extension file - MT900 selection
      *
     FACNUMA    IF   E           K DISK
      ** Retail Accounts LF
      *
     FSDCUSTL7  IF   E           K DISK
      * SD Customer details (SWIFT key)
      *
     FMGOREFPD  O  A E             DISK    COMMIT
      ** Master Message Reference File
      *
     FMGOMSGPD  O  A E           K DISK    COMMIT
      ** Master Message Data File
      *
     FFT162003P1O    E             PRINTER INFDS(SPOOL1)
      ** via SWIFT
      *
     FFT162003P2O    E             PRINTER INFDS(SPOOL2)
      ** Telex
      *
     FFT162003AUO    E             PRINTER INFDS(SPOOLU)
      ** Audit Control
      *
     D ZDEST           S             11    DIM(5)
     D AMT             S              1    DIM(13)                              AMOUNT ARRAY
     D AM              S              1    DIM(14)                              EDITED AMOUNT ARR
     D FAMT            S              1    DIM(15)                              LEFT ADJ AMNT ARR
     D ADDR            S             35    DIM(6)                               NAME/Address  ARR
     D GNR             S              3    DIM(15)                              msg gen released.
      *
     D/COPY FTCPYSRC,SFTADDRILE
      ** Address data structure
      *
     D SPOOLU          DS
      ** File Information Data Structure
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D SPOOL1          DS
      ** File Information Data Structure
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D SPOOL2          DS
      ** File Information Data Structure
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D                 DS
      *****************************************************************
      * Data Structure to save Fields from INSTALLATION CONTROL Data  *
      * area.                                                         *
      *****************************************************************
     D  SDFBR                  1      3  0
     D  SCSID                  4     15
     D  CSID9                 12     12
     D  CSID10                13     13
     D  CSID11                14     14
     D  CSID12                15     15
      *
     D                 DS
      *****************************************************************
      * Data Structure to convert Date from format YYMMDD to DDMMMYY. *
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
      ** Data Structure To Manipulate Amount
     D  WAMNT                  1     13  0
     D  RAMNT                  1     13
      ** For Editing on the Report
     D  P2AMT0                 1     13  0
     D  P2AMT1                 1     13  1
     D  P2AMT2                 1     13  2
     D  P2AMT3                 1     13  3
      *
     D OFSPT           DS           210
      ** Data Structure To Eliminate Blank Lines
     D  OFSPT1                 1     35
     D  OFSPT2                36     70
     D  OFSPT3                71    105
     D  OFSPT4               106    140
     D  OFSPT5               141    175
     D  OFSPT6               176    210
      *
     D                 DS
      ** Data Structure To Manipulate Pay Ref.
     D  DSPREF                 1     15
     D  PAYT                  12     13
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Structure to Retrieve Multibranch Indicator
      *
     D DST1            DS            35
      ** Data structure to split the full nostro number
     D  NOSTN                  4      5
      *
     D DSNOST          DS             5
     D  DSNCCY                 1      3
     D  DSNNNB                 4      5
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
      *****************************************************************
      * Data Structure - PROGRAM STATUS                               *
      *****************************************************************
     D  ##PGM                  1     10
     D  USRID                254    263
      *
     D MULT            DS                  OCCURS(95)
      ** Multiple occurrence data structure for message
     D  MTAG                   1      5
     D  MFLD                   6     55
      *
     D @MTAG           DS             5
      ** Data structure constructing message field tag
     D  COLON1                 1      1    INZ(':')
     D  FLDNO                  2      3
     D  TAG                    4      4
     D  COLON2                 5      5    INZ(':')
      *
     D P@IN            DS           256
      ** Data structure for input parameter
     D  I@SNBR                 1      3
     D  I@DSCN                 4      9
     D  I@MTPY                10     12
     D  I@SETT                13     14  0
     D  I@CONC                15     15
     D  I@FTCS                16     16
     D  I@MMOD                17     18
      *
     D P@OUT           DS           256
      ** Data structure for output parameter
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
      ** External Data structure for customer details.
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External Data structure for Nostro details.
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External Data structure for modules files.
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      ** External Data structure for MESSAGE MANAGEMENT file
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External Data structure for CURRENCIES file
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** Calling parameter data structure for ME1400
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      ** Calling parameter data structure for FT ICD
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Calling parameter data structure for SD ICD
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      ** Calling parameter data structure for ME1400
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
      ** Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access programs
      *
     D W8FT            DS           128
      *
      ** Address data structure
      *
      ** Currency
     D  W8CCY                  1      3
      ** Settlement Type
     D  W8STMT                 4      5
      ** Mandatory Text - convert BIC identifiers
     D  W8MTXT                 6      6
      ** Message Tag
     D  W8MTAG                 7     11
      ** Construct of data in field
     D  W8TYPE                12     12
      ** Number of Lines available
     D  W8NLIN                13     14  0
      ** Network and Message Type
     D  W8NWRK                15     20
     D  W8MTPY                21     23
      ** Calling Program
     D  W8CPGM                24     33
      ** Action *PRINT/*ENQ/*MSG GEN
     D  W8ACT                 34     41
      ** Critical reporting - Database error if 'Y'
      ** If no BIC directory and BIC entered no error
     D  W8CRIT                42     42
      ** Force Midas Address - where possible
     D  W8MADD                43     43
      ** If Retail get first address from account
     D  W8RTAD                44     44
      ** Alternative Address
     D  W8ALTN                45     45
      ** Address type selected in W0MSG
     D  W8ADTP                46     46
      *
      ** Full account data structure
     D                 DS
     D  FACCNT                 1     24
     D  FCNUM                  1      6
     D  FCCY                   7      9
     D  FACOD                 10     19
     D  FACSQ                 20     21
     D  FBRCA                 22     24
      ** Partial account data structure
     D                 DS
     D  PACCNT                 1     18
     D  PCNUM                  1      6
     D  PACOD                  7     16
     D  PACSQ                 17     18
      *
     D ISPT11          DS            11                                                           MD
     D  SLASH                  1      1                                                           MD
     D  ISPT10                 2     11                                                           MD
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D MTH             S              3    DIM(12) CTDATA PERRCD(12)            MONTH  SR. ARRAY
      *
     IACCNTABF
     I              BRCA                        ABRCA
      *
      /EJECT
      *
      ***************************
      * Input Output Parameters *
      ***************************
     C     *ENTRY        PLIST
     C                   PARM                    RMODE                          I-Input Parm
     C                   PARM                    OPPARM                         O-Output Parm
     C                   PARM                    RSEQ              5            IO-ZSFILE
      *
      ***************
      * First Cycle *
      ***************
     C     *IN40         IFEQ      *OFF
     C                   EXSR      FIRST
     C                   ENDIF
      *
      *********************
      * Detail Processing *
      *********************
      *
      ** Process Records on the Outgoing Payments Logical
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   READ      OTPAYXL4                               LR
      *
     C     *INLR         DOWEQ     *OFF
      *
      ** Retreive record from master file
     C     OPPREF        CHAIN     OTPAY                              88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     'OTPAYDD '    DBFNAM                         **************
     C                   MOVEL     OPPREF        DBERKY                         *DB ERROR 280*
     C                   Z-ADD     280           DBERR#                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Only generate message if authorise indicator is 'Y'.
     C     AUIN          IFEQ      'Y'
      *
      ** Set payment type to 'OP'- Outgoing payment.
     C                   MOVE      'OP'          PTYPE             2
     C                   MOVE      *ON           *IN21
      *
      ** Initialise non-constant fields
     C                   EXSR      INTF
      *
      ** Keep Tally of Number Of Records Read From OTPAYDD.
     C                   ADD       1             AUNO1
      *
      ** Setup Parameters and Execute SR01
     C     ORBT          IFNE      *BLANKS
      *
      ** Determine SWIFT Address of ORDERING BANK
     C                   MOVEL     ORBT          ISPTP             1
     C                   MOVEL(P)  ORBK          ISPTY1           35
     C                   MOVE      *BLANKS       ISPTY2           35
     C                   MOVE      *BLANKS       ISPTY3           35
     C                   MOVE      *BLANKS       ISPTY4           35
     C                   MOVE      *BLANKS       ISPTY5           35
     C                   MOVE      SMCY          ISCCY             3
     C                   MOVE      'A'           IVTAG1            1
     C                   MOVE      ' '           IVTAG2            1
     C                   MOVE      ' '           IVTAG3            1
      *
     C                   ELSE
      *
      ** Determine SWIFT Address of ORDERING CUSTOMER
     C                   MOVEL     ORCT          ISPTP             1
     C                   MOVEL(P)  ORC1          ISPTY1           35
     C                   MOVE(P)   ORC2          ISPTY2           35
     C                   MOVE(P)   ORC3          ISPTY3           35
     C                   MOVE(P)   ORC4          ISPTY4           35
     C                   MOVE      *BLANKS       ISPTY5           35
     C                   MOVE      SMCY          ISCCY             3
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
     C                   MOVE      *BLANKS       IBANRC           35
      *
     C     ORBT          IFNE      *BLANKS
      *
     C                   SELECT
     C     ORBT          WHENEQ    'N'
     C                   MOVE      A7BRCD        P2BRCA
     C     ORBT          WHENEQ    'R'
     C                   MOVE      ABRCA         P2BRCA
     C                   MOVEL     ORBK          IBANRC
     C     ORBT          WHENEQ    'P'
     C                   MOVE      ORBB          P2BRCA
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
     C     ORCT          WHENEQ    'P'
     C     3             SUBST     ORC1:19       P2BRCA
     C     ORCT          WHENEQ    'R'
     C                   MOVE      ABRCA         P2BRCA
     C                   MOVEL     ORC1          IBANRC
     C     ORCT          Wheneq    'I'
     C                   Move      CBRCA         P2BRCA
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Save Fields
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
     C                   ENDIF
      *
      * For each Destination Generate an MT9nn
     C                   Z-ADD     1             u                 1 0
     C                   DOU       u = 6
     C                   IF        ZDEST(u) <> *BLANKS
      *
      ** Field :20:  Transaction Reference Number
     C                   EXSR      FLD20
      *
      ** Field :21:  Related Reference
     C                   EXSR      FLD21
      *
      ** Field :25:  Account Reference
     C                   EXSR      FLD25
      *
      ** Field :32A: Value Date/Currency/Amount
     C                   EXSR      FLD32A
      *
      ** Output correctly generated message to PF/MGOMSGPD and write
      ** reference record to PF/MGOREFPD.
      *
     C                   EXSR      OMSG
      *
      ** Output to SWIFT or TELEX report.
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
      * Update the MT900 generated indicator
      *
     C                   MOVE      'C'           OPG900
     C                   UPDATE    OTPAYXDF
      *
      ** Comit Changes
     C                   COMMIT
     C                   ENDIF
      *
     C                   READ      OTPAYXL4                               LR
     C                   ENDDO
      *
      ** Process Records on the Incoming Payments Logical
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   READ      INPAYXL5                               LR
      *
     C     *INLR         DOWEQ     *OFF
      *
      ** Retreive record from master file
     C     INPREF        CHAIN     INPAY                              88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     'INPAYDD '    DBFNAM                         **************
     C                   MOVEL     INPREF        DBERKY                         *DB ERROR 290*
     C                   Z-ADD     290           DBERR#                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Only generate message if AUTHORISED.
     C     AUIN          IFEQ      'Y'
      *
      ** Set payment type to 'IN'- Incoming payment.
     C                   MOVE      'IN'          PTYPE
     C                   MOVE      *OFF          *IN21
      *
      ** Initialise non-constant fields
     C                   EXSR      INTF
      *
      ** Keep Tally of Number Of Records Read From INPAYDD.
     C                   ADD       1             AUNI1
      *
      ** Setup Parameters and Execute SR01
     C     INRCRT        IFNE      *BLANKS
      *
      ** Determine SWIFT Address of RECEIVER'S CORRESPONDENT
     C                   MOVEL     INRCRT        ISPTP
     C                   MOVEL(P)  INRCO1        ISPTY1
     C                   MOVE      *BLANKS       ISPTY2
     C                   MOVE      *BLANKS       ISPTY3
     C                   MOVE      *BLANKS       ISPTY4
     C                   MOVE      *BLANKS       ISPTY5
     C                   MOVE      SMCY          ISCCY
     C                   MOVE      'A'           IVTAG1
     C                   MOVE      ' '           IVTAG2
     C                   MOVE      ' '           IVTAG3
      *
     C                   ELSE
      *
      ** Determine SWIFT Address of SENDER
     C                   MOVEL     SNTP          ISPTP
     C                   MOVEL(P)  SND1          ISPTY1
     C                   MOVE(P)   SND2          ISPTY2
     C                   MOVE(P)   SND3          ISPTY3
     C                   MOVE(P)   SND4          ISPTY4
     C                   MOVE      *BLANKS       ISPTY5
     C                   MOVE      SMCY          ISCCY
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
     C                   MOVE      *BLANKS       IBANRC           35
      *
     C     INRCRT        IFNE      *BLANKS
      *
     C                   SELECT
     C     INRCRT        WHENEQ    'N'
     C     INRCRT        OREQ      'F'
     C                   MOVE      A7BRCD        P2BRCA
     C     INRCRT        WHENEQ    'R'
     C                   MOVE      ABRCA         P2BRCA
     C                   MOVEL     INRCO1        IBANRC
     C     INRCRT        WHENEQ    'I'
     C                   MOVE      CBRCA         P2BRCA
     C                   MOVEL     INRCO1        IBANRC
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
     C     SNTP          WHENEQ    'F'
     C     SNTP          OREQ      'N'
     C                   MOVE      A7BRCD        P2BRCA
     C     SNTP          WHENEQ    'G'
     C     3             SUBST     SND1:22       P2BRCA
     C     SNTP          WHENEQ    'R'
     C                   MOVE      ABRCA         P2BRCA
     C                   MOVEL     SND1          IBANRC
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Save Fields
     C                   MOVE      CUSTNO        SDECN                          Save Cust No
     C                   Move      CNUM          F25_CNUM          6
     C                   z-add     ACOD          F25_ACOD         10 0
     C                   z-add     ACSQ          F25_ACSQ          2 0
      *
     C     KM9ACC        CHAIN     SDM901L0                           88
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
      ** Field :20:  Transaction Reference Number
     C                   EXSR      FLD20
      *
      ** Field :21:  Related Reference
     C                   EXSR      FLD21
      *
      ** Field :25:  Account Reference
     C                   EXSR      FLD25
      *
      ** Field :32A: Value Date/Currency/Amount
     C                   EXSR      FLD32A
      *
      ** Output correctly generated message to PF/MGOMSGPD and write
      ** reference record to PF/MGOREFPD.
      *
     C                   EXSR      OMSG
      *
      ** Output to SWIFT or TELEX report.
      *
     C     NWRK          IFEQ      'SWIFT'
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
     C                   MOVE      'C'           ING900
     C                   UPDATE    INPAYXDF
      ** Comit Changes
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   READ      INPAYXL5                               LR
     C                   ENDDO
      *
      ** Last Record Processing
     C                   EXSR      LAST
      *
      /EJECT
      *****************************************************************
      * SR/FLD20 - Field :20:  Transaction Reference Number           *
      *****************************************************************
     C     FLD20         BEGSR
      *
     C                   Z-ADD     1             Q
     C     Q             OCCUR     MULT
      *
     C                   MOVEL(P)  ':20:'        MTAG                           Set TAG
     C     11            SUBST     PREF:2        WKA11            11            Remove 'P'
     C     'FT'          CAT       WKA11         WKA13            13            FTYYMMDDNNNNO
      ** Move 'C' into payment type to uniquely identify message
     C     WKA13         CAT       'D'           WKA14            14
     C     2             SUBST     PREF:14       WKA2              2            Last two chars
     C     WKA14         CAT       WKA2          WKA16            16
     C                   MOVEL(P)  WKA16         MFLD
      *
      ** Save the transaction Reference Number.
     C                   MOVEL     MFLD          TRNA             16
     C                   MOVEL     TRNA          MGTRNA           16
     C                   MOVE      U             MGTRNA
      *
      ** Populate printer file fields
     C                   MOVEL     MFLD          P1REF
      *
     C     MFLD          IFEQ      *BLANKS
     C                   SUB       1             Q
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SR/FLD21 - Field :21:  Related Reference                      *
      *****************************************************************
     C     FLD21         BEGSR
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
      ** Populate printer file fields
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
      * SR/FLD25 - Field :25:  Account Identification                 *
      *            15 character account id derived from Senders       *
      *            Correspondent.                                     *
      *****************************************************************
     C     FLD25         BEGSR
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
     C                   MOVEL(P)  ':25:'        MTAG                           Set TAG
      *
     C                   MOVEL(P)  F25_Cnum      F25F              9            Set A/C ID CUST
     C                   MOVE      SMCY          F25F                           Add A/C ID CCY
      *
     C                   MOVEL(P)  F25_Acod      F25L             12            Set A/C ID ACOD
     C                   MOVE      F25_Acsq      F25L                           Add A/C ID ACSQ
      *
     C     F25F          CAT(P)    F25L          MFLD                           Set Mess Field
      *
      ** Populate printer file fields
     C     F25F          CAT(P)    F25L          P1ACCT                         Set A/C ID
      *
     C                   MOVEL     F25_Cnum      P2IDCU                         Set A/C ID CUST
     C                   MOVEL     SMCY          P2IDCY                         Set A/C ID CCY
     C                   MOVEL     F25_Acod      P2IDAC                         Set A/C ID ACOD
     C                   MOVE      F25_Acsq      P2IDAS                         Set A/C ID ACSQ
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
     C     IBANRC        IFEQ      *BLANKS
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
     C                   MOVEL     IBANRC        MFLD
     C                   MOVE      *BLANKS       P1ACCT
     C                   MOVEL     IBANRC        P1ACCT
      *
     C                   ENDIF
      *
      *
     C     MFLD          IFEQ      *BLANKS
     C                   SUB       1             Q
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SR/FLD32A - Field :32A: Value Date/Currency/Amount            *
      *****************************************************************
     C     FLD32A        BEGSR
      *
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
      *
     C                   MOVEL(P)  ':32A:'       MTAG                           Set TAG
      ** Value Date.
     C                   MOVEL(P)  SLDTD3        MFLD
     C                   MOVEL(P)  SLDTD3        P1VDAT                         Set print fld
      ** Currency.
     C                   CAT       SMCY:0        MFLD
     C                   MOVEL(P)  SMCY          P1RCCY                         Set print fld
      ** Calculate & Format the Amount
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
      * SR/SR01 - To Format Settlement Party to Swift Format          *
      *****************************************************************
     C     SR01          BEGSR
      *
      ** Initialise output parameter fields
     C                   MOVE      *BLANKS       OFSPT1           35
     C                   MOVE      *BLANKS       OFSPT2           35
     C                   MOVE      *BLANKS       OFSPT3           35
     C                   MOVE      *BLANKS       OFSPT4           35
     C                   MOVE      *BLANKS       OFSPT5           35
     C                   MOVE      *BLANKS       OSTAG             1
     C                   MOVE      'N'           OSUFLG            1
     C                   MOVE      *BLANKS       CSID             12
      *
      ** Full Nostro processing - Append the pay currency to the
      ** first settlement party field to access Nostro details
      ** from PF/TABLETL to obtain CUST NO.
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
      ** Nostro No. processing - Append the pay currency to the first
      ** 2 chars of the 1st settlement party field to access Nostro
      ** details from PF/TABLETL to obtain CUST NO.
     C     ISPTP         IFEQ      'N'
      *
     C                   MOVEL     ISPTY1        DSNNNB
     C                   MOVEL     ISCCY         DSNCCY
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
      ** Retail Account processing -
      ** Use 1st 10 chars of the 1st settlement party field to access
      ** the account details from LF/ACNUMA to obtain CUST NO.
     C     ISPTP         IFEQ      'R'
     C                   MOVEL     ISPTY1        ISPT11
     C     SLASH         IFEQ      '/'
     C                   MOVEL     ISPT10        ACNUMK
     C                   ELSE
     C                   MOVEL     ISPTY1        ACNUMK           10 0
     C                   ENDIF
     C     ACNUMK        CHAIN     ACNUMA                             11        ON, DELETED
     C     *IN11         IFEQ      '1'
     C                   MOVEL     'ACNUMA'      DBFNAM                         *************
     C                   MOVEL     ACNUMK        DBERKY                         *DB ERROR 30*
     C                   Z-ADD     30            DBERR#                         *************
     C                   EXSR      DBERR
     C                   ENDIF
     C                   MOVE      CNUM          CUSTNO
     C                   ENDIF
      *
      * IBAN number processing.
      *
     C     ISPTP         IFEQ      'I'
     C                   Movel     ISPTY1        ##001             1
     C     ##001         Ifeq      '/'
     C                   Subst     ISPTY1:2      EIBAN
     C                   else
     C                   Move      ISPTY1        EIBAN            34
     C                   Endif
     C                   CALL      'AOIBANR4'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    EIBAN
     C     ACCNT         PARM                    DSSDY
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'ACCNTAB'     DBFNAM                         ***************
     C                   MOVEL     EIBAN         DBERKY                         **DB ERROR 300*
     C                   Z-ADD     300           DBERR#                         ***************
     C                   EXSR      DBERR
     C                   ENDIF
     C                   MOVE      CNUM          CUSTNO
     C                   ENDIF
      *
      *
      ** Full Account/Partial Account/Customer processing - CUST NO.
      ** is 1st 6 chars of the 1st settlement party field.
     C     ISPTP         IFEQ      'G'
     C     ISPTP         OREQ      'P'
     C     ISPTP         OREQ      'C'
      *
      ** If using account line construct then use second line
      *
     C                   MOVEL     ISPTY1        ##001             1
     C     ##001         IFEQ      '/'
     C                   MOVEL     ISPTY2        CUSTNO
     C                   ELSE
     C                   MOVEL     ISPTY1        CUSTNO
     C                   ENDIF
     C                   ENDIF
      *
      ** Full Account or Partial Account processing
      *
     C     ISPTP         IFEQ      'G'
     C     ISPTP         OREQ      'P'
      *
     C                   MOVEL     ISPTY1        ##001
     C                   MOVE      *BLANKS       FACCNT
     C                   MOVE      *BLANKS       PACCNT
      *
      ** If using account line construct then use second line
      *
     C     ##001         IFEQ      '/'
     C                   MOVEL     ISPTY2        FACCNT
     C                   ELSE
     C                   MOVEL     ISPTY1        FACCNT
     C                   ENDIF
      *
      ** Prcessing for Partial account
     C     FBRCA         IFEQ      *BLANKS
     C                   MOVEL     FACCNT        PACCNT
     C                   MOVEL     PCNUM         CNUM
     C                   MOVEL     PACOD         ACOD
     C                   MOVEL     PACSQ         ACSQ
      *
      ** Prcessing for Full account
     C                   ELSE
     C                   MOVEL     FCNUM         CNUM
     C                   MOVEL     FACOD         ACOD
     C                   MOVEL     FACSQ         ACSQ
     C                   ENDIF
     C                   ENDIF
      *
      ** If SWIFT identifier then use ME1400 to check details
      *
     C     ISPTP         IFEQ      'S'
      *
      ** Call Access object to validate identifier
      *
     C                   MOVEL     ISPTY1        ##001             1
     C     ##001         IFEQ      '/'
     C                   MOVEL     ISPTY2        W9BICC
     C     3             SUBST     ISPTY2:9      W9BICB
     C                   ELSE
     C                   MOVEL     ISPTY1        W9BICC
     C     3             SUBST     ISPTY1:9      W9BICB
     C                   ENDIF
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
      ** If customer details exist then set up CUSTNO
     C     W9CUST        IFEQ      'Y'
     C                   MOVEL     BBCUST        CUSTNO
     C                   ELSE
     C                   Move      *blanks       CUSTNO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access full Customer details from LF/CLINT
     C     ISPTP         IFEQ      'G'
     C     ISPTP         OREQ      'P'
     C     ISPTP         OREQ      'C'
     C     ISPTP         OREQ      'F'
     C     ISPTP         OREQ      'N'
     C     ISPTP         OREQ      'R'
     C     ISPTP         OREQ      'I'
     C     W9CUST        OREQ      'Y'
     C     ISPTP         ANDEQ     'S'
      *
     C                   MOVE      CUSTNO        CUSTKY            6
      *
      ** Access SDCUSTPD using customer number
      *
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     CUSTKY        @KEY1
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
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     40            DBERR#                         *************
     C                   MOVEL     @KEY1         DBERKY                         *DB ERROR 40*
     C                   MOVEL     'SDCUSTPD'    DBFNAM                         *************
     C                   EXSR      DBERR
     C                   ENDIF
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
      ** Access Destination address details via swift subroutine
      ** (20 only set ON for Destination)
      *
     C     *IN20         IFEQ      '1'
     C                   EXSR      SRROUT
     C                   ENDIF
      *
     C                   GOTO      SR01A
     C                   ENDIF
      *
      ** If SWIFT identifier and destination of message set up
      ** routing data
      *
     C     ISPTP         IFEQ      'S'
     C     *IN20         ANDEQ     '1'
     C                   MOVEL     'Y'           OSUFLG
     C                   Move      *Blanks       CPAR
     C                   MOVEL     ISPTY1        CRNM
     C                   MOVEL     SNCSID        NWSN
     C                   MOVEL     ISPTY1        NWDS
     C                   MOVEL     'SWIFT'       NWRK
     C                   MOVEL     *BLANKS       CTWN
     C                   MOVEL     ISPTY1        CSID
      *
      ** Default the message status whith the ICD.
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
      ** Swift address and at least one valid tag fields = 'A'
     C     ISPTP         IFEQ      'S'
     C     IVTAG1        ANDEQ     'A'
      *
      ** If using account line construct then use second line
      *
     C                   MOVEL     ISPTY1        ##001
     C     ##001         IFEQ      '/'
     C                   MOVEL     ISPTY2        SP12
     C                   MOVEL     SP12          SCSID
     C                   MOVEL     ISPTY1        OFSPT1
     C                   MOVEL     SCSID         OFSPT2
     C                   ELSE
     C                   MOVEL     ISPTY1        SP12             12            1ST 12 CHARS
     C                   MOVEL     SP12          SCSID                          1ST 12 CHARS
     C                   MOVEL     SCSID         OFSPT1
     C                   ENDIF
     C                   MOVE      'A'           OSTAG
     C                   GOTO      SR01N
     C                   ENDIF
      *
      ** Swift address and at least one valid tag fields = 'D'
     C     ISPTP         IFEQ      'S'
     C     IVTAG3        ANDEQ     'D'
      *
      ** Use FT0315 to format text for D address type
      *
      ** Set up general parameters
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
      ** Format data to be translated
      *
     C                   MOVEL     ISPTP         W8TYPE
     C                   MOVEL     ISCCY         W8CCY
     C                   MOVEL     *BLANKS       W8LINS
     C                   MOVEL     ISPTY1        ADCHK1
     C                   MOVEL     ISPTY2        ADCHK2
     C                   MOVEL     ISPTY3        ADCHK3
     C                   MOVEL     ISPTY4        ADCHK4
     C                   MOVEL     ISPTY5        ADCHK5
     C                   MOVEL     ADDRSS        W8LINS
      *
      ** Call expansion program
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
     C                   Z-ADD     50            DBERR#                         *************
     C                   MOVEL     '*CALL'       DBERKY                         *DB ERROR 50*
     C                   MOVEL     'FT0315'      DBFNAM                         *************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   MOVEL     W8MSG         ADDRSS
     C                   MOVEL     ADCHK1        OFSPT1
     C                   MOVEL     ADCHK2        OFSPT2
     C                   MOVEL     ADCHK3        OFSPT3
     C                   MOVEL     ADCHK4        OFSPT4
     C                   MOVEL     ADCHK5        OFSPT5
      *
     C                   MOVE      'D'           OSTAG
     C                   GOTO      SR01N
     C                   ENDIF
      *
      ** Full address and at least one valid tag fields = 'D'
     C     ISPTP         IFEQ      'A'
     C     IVTAG3        ANDEQ     'D'
     C                   MOVEL     ISPTY1        OFSPT1
     C                   MOVEL     ISPTY2        OFSPT2
     C                   MOVEL     ISPTY3        OFSPT3
     C                   MOVEL     ISPTY4        OFSPT4
     C                   MOVEL     ISPTY5        OFSPT5
     C                   MOVE      'D'           OSTAG
     C                   GOTO      SR01N
     C                   ENDIF
      *
     C     SR01A         TAG
      *
      ** Ignore if type ' '
     C     ISPTP         IFEQ      ' '                                          B001
     C                   GOTO      SR01N
     C                   ENDIF                                                  E001
      ** Valid tag field = 'D' and the Swift address on LF/CLINT is
      ** non blank
     C     IVTAG1        IFEQ      'A'
     C     CSID          ANDNE     *BLANK
      *
      ** If using account line construct then use second line
      *
     C                   MOVEL     ISPTY1        ##001
     C     ##001         IFEQ      '/'
     C                   MOVEL     CSID          SCSID
     C                   MOVEL     ISPTY1        OFSPT1
     C                   MOVEL     SCSID         OFSPT2
     C                   ELSE
     C                   MOVEL     CSID          SCSID
     C                   MOVEL     SCSID         OFSPT1
     C                   ENDIF
     C                   MOVE      'A'           OSTAG
     C                   GOTO      SR01N
     C                   ENDIF
      *
      ** Valid tag field = 'B' and the customer parent number from
      ** LF/CLINT is non zero and equal to the CUST. NO. of HEAD OFFICE
      *
      ** If using account line construct then 'B' not allowed
      *
     C                   MOVEL     ISPTY1        ##001
     C     IVTAG2        IFEQ      'B'
     C     CPAR          ANDNE     *Blanks
     C     CPAR          ANDEQ     SHEAD                                        SAVE 1ST CYCLE
     C     ##001         ANDNE     '/'
     C                   MOVEL     CTWN          OFSPT1
     C                   MOVE      'B'           OSTAG
     C                   GOTO      SR01N
     C                   ENDIF
      *
      ** Valid tag field = 'D'
     C     IVTAG3        IFEQ      'D'
      *
      ** Use FT0315 to format text for D address type
      *
      ** Set up general parameters
      *
     C                   CLEAR                   W8FT
     C                   MOVEL     *BLANKS       W8STMT
     C                   MOVEL     ##PGM         W8CPGM
     C                   MOVEL     '*MSG  '      W8ACT
     C                   Z-ADD     5             W8NLIN
     C                   MOVEL     'Y'           W8MTXT
      *
      ** Format data to be translated
      *
     C                   MOVEL     ISPTP         W8TYPE
     C                   MOVEL     ISCCY         W8CCY
     C                   MOVEL     *BLANKS       W8LINS
     C                   MOVEL     ISPTY1        ADCHK1
     C                   MOVEL     ISPTY2        ADCHK2
     C                   MOVEL     ISPTY3        ADCHK3
     C                   MOVEL     ISPTY4        ADCHK4
     C                   MOVEL     ISPTY5        ADCHK5
     C                   MOVEL     ADDRSS        W8LINS
      *
      ** Call expansion program
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
     C                   Z-ADD     60            DBERR#                         *************
     C                   MOVEL     '*CALL'       DBERKY                         *DB ERROR 60*
     C                   MOVEL     'FT0315'      DBFNAM                         *************
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
      * SR/EMBLK - To Eliminate Blank Lines on Name and Address Fields*
      *****************************************************************
     C     EMBLK         BEGSR
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
      * SR/SR03 - To Format Amount                                    *
      *****************************************************************
     C     SR03          BEGSR
      *
      ** Access SDCURRPD to find decimal position
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    SMCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   If        PRtCd <> *BLANKS
     C                   Movel     'SDCURRPD'    DBFNAM                         ***************
     C                   Movel     SMCY          DBERKY                         **DB ERROR 080*
     C                   Z-add     080           DBERR#                         ***************
     C                   Exsr      DBERR
     C                   Endif
      *
      ** The following amendment is because PLN is held in a compressed
      ** form in the Data Base, and thus needs to be expanded for
      ** external media, compressed for incoming data. In case of
      ** further changes a multiply divide indicator is also utilised
      ** to decide how to manipulate the Data.
      *
      ** Determine Decimal position (For Report)
     C     A6NBDP        COMP      2                                  33  32
     C     A6NBDP        COMP      1                                    3031
      *
      ** Determine Decimal Position
     C     14            SUB       A6NBDP        X                 2 0
      ** If 0 Decimal Places Don't edit
     C     A6NBDP        IFEQ      0
     C                   MOVE      *BLANK        AMT
     C                   MOVE      *ZEROS        AM
     C                   MOVEA     RAMNT         AMT(2)
     C                   MOVEA     RAMNT         AM(1)
     C                   Z-ADD     13            W
     C                   MOVE      ','           AM(X)
     C                   ELSE
      ** MOVE AMOUNT into ARRAY
     C                   MOVEA     RAMNT         AMT(1)
      ** Determine POSITION OF DECIMAL DIGITS IN 2ND ARRAY
     C     X             ADD       1             Y                 2 0
      ** MOVE DECIMAL DIGITS into 2ND ARRAY Field
     C                   MOVEA     AMT(X)        AM(Y)
      ** Determine POSITION & MOVE COMMA
     C                   SUB       1             Y
     C                   MOVE      ','           AM(Y)
      ** Determine POSITION OF DIGIT B4  COMMA
     C                   SUB       1             Y
      ** SAVE POSITION OF DIGIT B4  COMMA
     C                   Z-ADD     Y             W                 2 0
      ** Determine POSITION OF DIGIT TO BE MOVED B4  COMMA
     C                   SUB       1             X
     C                   Z-ADD     X             Z                 2 0
      ** DO OPERATIONS MOVING CHARACTERS ONE AT A TIME
      ** FROM RIGHT TO LEFT
     C                   DO        X
     C                   MOVE      AMT(Z)        AM(Y)
     C                   SUB       1             Z
     C                   SUB       1             Y
     C                   ENDDO
     C                   ENDIF
      ** Set Index to 1
     C                   Z-ADD     1             Y
      ** Replace leading ZEROS with BLANK
     C     AM(Y)         DOWEQ     '0'
     C     Y             CABEQ     W             SR03A
     C                   MOVE      ' '           AM(Y)
     C                   ADD       1             Y
     C                   ENDDO
      ** SAVE Field FROM ARRAY
     C     SR03A         TAG
     C                   MOVEA     AM            AMX              14
     C                   MOVE      AMX           SAM              15
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SR/SR06 - Determine and Format Amount Outgoing Payments       *
      *****************************************************************
     C     SR06          BEGSR
      *
      ** Check 'ADD/DEDUCT' IND = 'A' AND
      *
     C     ADDC          IFEQ      'A'
     C     SMAM          ADD       TXCH          WAMNT            13 0          Telex Charges
     C     WAMNT         ADD       CQCH          WAMNT                          Cheque Charges
     C     WAMNT         ADD       CSTA          WAMNT
     C     WAMNT         ADD       SPCH          WAMNT
     C     WAMNT         ADD       MSCH          WAMNT
     C     WAMNT         ADD       TRCM          WAMNT
     C                   ENDIF
      *
     C     ADDC          IFNE      'A'
     C                   Z-ADD     SMAM          WAMNT
     C                   ENDIF
      *
      ** Format The Amount
     C                   EXSR      SR03
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
      * SR/SRP1 -Output an entry to Swift Message Report PRTF/FT162003P1 *
      ********************************************************************
     C     SRP1          BEGSR
      *
     C                   MOVEL     PREF          P1PREF
      *
     C                   WRITE     HEADP1                               80
      *
     C     *IN80         IFEQ      *ON
     C                   MOVEL     'FT162003P1'  DBFNAM                         *************
     C                   MOVEL     '1'           DBERKY                         *DB ERROR 90*
     C                   Z-ADD     90            DBERR#                         *************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SR/SRP2 - To handle Telex Report                              *
      *****************************************************************
     C     SRP2          BEGSR
      *
     C                   MOVEL     PREF          P2PREF
      *
      ** Format Receiving Bank from Destination fields
     C                   MOVEL     DSTT          ISPTP
     C                   MOVEL     SMCY          ISCCY
     C                   MOVEL(P)  DST1          ISPTY1
     C                   MOVE(P)   DST2          ISPTY2
     C                   MOVE(P)   DST3          ISPTY3
     C                   MOVE(P)   DST4          ISPTY4
     C                   MOVE      *BLANKS       ISPTY5
      *
     C                   SETOFF                                       20
     C                   EXSR      SR01
      *
      ** Destination field print line
     C                   MOVEL     OFSPT1        P2DST1
     C                   MOVEL     OFSPT2        P2DST2
     C                   MOVEL     OFSPT3        P2DST3
     C                   MOVEL     OFSPT4        P2DST4
     C                   MOVEL     OFSPT5        P2DST5
      *
      ** Change of currency, then print else suppress currency
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
      ** Convert Pay Value Date from 'YYMMDD' to 'DDMMMYY'
     C                   MOVE      SLDTD3        SDATE
     C                   MOVE      MTH(SMM)      WMM
     C                   MOVE      SDD           WDD
     C                   MOVE      SYY           WYY
      *
      ** Change date then print else suppress date printing
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
      ** Print telex message
     C   14
     COR 15              WRITE     HEADP2                               80
      *
     C     *IN80         IFEQ      *ON
     C                   MOVEL     'FT162003P2'  DBFNAM                         **************
     C                   MOVEL     '2'           DBERKY                         *DB ERROR 100*
     C                   Z-ADD     100           DBERR#                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SR/SRROUT - Determine Message Routing                         *
      *                                                               *
      * Called by - SR01                                              *
      *****************************************************************
     C     SRROUT        BEGSR
      *
     C                   MOVE      BRCA          I@SNBR
     C                   MOVE      *BLANKS       I@DSCN
     C                   MOVE      CUSTNO        I@DSCN
     C                   MOVE      '900'         I@MTPY
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
     C                   Z-ADD     110           DBERR#                         **************
     C                   MOVEL     '*CALL'       DBERKY                         *DB ERROR 110*
     C                   MOVEL     'MG9900  '    DBFNAM                         **************
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
      * SR/INTF - Initalise non-constant fields                       *
      *****************************************************************
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
      ** Clear multiple occurrence data structure
      *
     C                   Z-ADD     1             Q                 2 0
     C     Q             OCCUR     MULT
      *
     C     Q             DOWLE     50
     C     MULT          ANDNE     *BLANKS
     C                   MOVE      *BLANKS       MULT
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SR/OMSG   - Output correctly generated Messages               *
      *                                                               *
      * Called by - Main process                                      *
      * Calls     - WREF Write o/p reference to PF/MGOREFPD.          *
      *****************************************************************
     C     OMSG          BEGSR
      *
      ** Write reference record to PF/MGOREFPD.
     C                   EXSR      WREF
      *
      ** Write multiple occurrence data structure to MGOMSGPD
     C                   Z-ADD     1             Q                 2 0
     C     Q             OCCUR     MULT
      *
     C     Q             DOWLE     50
     C     MFLD          ANDNE     *BLANKS
     C                   WRITE     MGOMSGD0                             42
      *
      ** Error on write to PF/MGOMSGPD (message data file)
      *
     C     *IN42         IFEQ      '1'
     C                   Z-ADD     150           DBERR#                         **************
     C                   MOVEL     '       '     DBERKY                         *DB ERROR 150*
     C                   MOVEL     'MGOMSGPD'    DBFNAM                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ADD       1             AUNO2
     C                   ADD       1             Q
     C     Q             OCCUR     MULT
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SR/WREF   - Write reference record to PF/MGOREFPD             *
      *                                                               *
      * Called by - OMSG  output message PF/MGOMSGPD                  *
      *****************************************************************
     C     WREF          BEGSR
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
     C                   MOVE      '900'         MTPY
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
     C                   Move      '900'         I@MTPY
     C                   Move      'N'           I@CONC
     C                   Z-Add     8             I@SETT
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
     C                   z-add     120           DBERR#                         **************
     C                   Movel     '*CALL'       DBERKY                         *DB ERROR 120*
     C                   Movel     'MG9900  '    DBFNAM                         **************
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
      *
      ** Format Swift priority code
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
      ** Convert run date to YYMMDD
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
     C                   MOVEL     SLDTD3        SVDT
     C                   MOVE      SMCY          CCY
     C                   MOVEL     *BLANKS       NSNO
     C*****DSTT*         IFEQ      'F'
     C**********         MOVE      NOSTN         NSNO
     C**********         ENDIF
     C                   MOVEL     *BLANKS       SACN
     C                   MOVEL     *BLANKS       AORR
     C                   MOVEL     *BLANKS       DESI
      *
      ** Branch Details
      *  ~~~~~~~~~~~~~~
      ** If Multibranch indicator from RUNDAT active
     C     *IN50         IFEQ      '1'
     C     BRCA          IFNE      ORBR
     C                   MOVE      ORBR          ORBR              3
     C                   MOVE      ORBR          OTHB
      ** Move "ORIGINATING BRANCH" to 'OTHER BRANCH TYPE'(OTHT)
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
      ** If Multibranch indicator from RUNDAT not active
     C                   ELSE
     C                   MOVE      *BLANKS       OTHB
     C                   MOVE      *BLANKS       OTHT
     C                   ENDIF
     C                   MOVE      *BLANKS       RCBR
      *
     C                   MOVE      *BLANKS       NETI
      *
      ** Read SDCURRPD for delivery notification and non-delivery
      ** warning flags.
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SMCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     170           DBERR#                         **************
     C                   MOVEL     @CCY          DBERKY                         *DB ERROR 170*
     C                   MOVEL     'SDCURRPD'    DBFNAM                         **************
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
      ** Ensure that message priority and delivery notification are
      ** valid combination :
      ** 1. for MPRY = 'U' DELC must be '1' or '3'.
      ** 2. for MPRY = 'N' DELC must be ' ' or '2'.
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
      ** Error on write to PF/MGOREFPD (message reference file)
      *
     C     *IN41         IFEQ      '1'
     C                   Z-ADD     180           DBERR#                         **************
     C                   MOVEL     '       '     DBERKY                         *DB ERROR 180*
     C                   MOVEL     'MGOREFPD'    DBFNAM                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ADD       1             AUNO3
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SR/FIRST - First Record Processing                            *
      *****************************************************************
     C     FIRST         BEGSR
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** If Multibranch indicator is active from RUNDAT
     C     AGMBIN        IFEQ      'Y'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
      *
      ** Move Report name and Spool file NBR to ZSFILE and call ZSFILE
     C                   Z-ADD     SFNUM1        SPLNO
     C                   MOVEL     SFILE1        SFILP
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ                           IO-Rpt Seq
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If error perform Database error handling and exit program
      *
     C     ZERR          IFEQ      'Y'
     C                   Z-ADD     190           DBERR#                         **************
     C                   MOVEL     'FT162003P1'  DBERKY                         *DB ERROR 190*
     C                   MOVEL     'ZSFILE'      DBFNAM                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Move Report name and Spool file NBR to ZSFILE and call ZSFILE
     C                   Z-ADD     SFNUM2        SPLNO
     C                   MOVEL     SFILE2        SFILP
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ                           IO-Rpt Seq
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If error perform Database error handling and exit program
      *
     C     ZERR          IFEQ      'Y'
     C                   Z-ADD     200           DBERR#                         **************
     C                   MOVEL     'FT162003P2'  DBERKY                         *DB ERROR 200*
     C                   MOVEL     'ZSFILE'      DBFNAM                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Move Audit Report name and Spool file NBR to ZSFILE and
      ** call ZSFILE.
     C                   Z-ADD     SFNUMU        SPLNO
     C                   MOVEL     SFILEU        SFILP
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ                           IO-Rpt Seq
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If error perform Database error handling and exit program
      *
     C     ZERR          IFEQ      'Y'
     C                   Z-ADD     210           DBERR#                         **************
     C                   MOVEL     'FT162003AU'  DBERKY                         *DB ERROR 210*
     C                   MOVEL     'ZSFILE'      DBFNAM                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Initialise Record Counters
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
     C                   MOVE      BJCUST        SHEAD             6
      *
      ** Access SDMMODPD for networks available.
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** If no record is found on SDMMODPD
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     240           DBERR#                         **************
     C                   MOVEL     'FIRST'       DBERKY                         *DB ERROR 240*
     C                   MOVEL     'SDMMODPD'    DBFNAM                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Access SDMGMEPD for drop SWIFT msg. no. days
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMGME        PARM      SDMGME        DSFDY
      *
      ** If no record is found on SDMGMEPD
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     250           DBERR#                         **************
     C                   MOVEL     'FIRST'       DBERKY                         *DB ERROR 250*
     C                   MOVEL     'SDMGMEPD'    DBFNAM                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Convert history retention date to YYMMDD
      *
     C     BJRDNB        ADD       ENDSMN        ZMDAY
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY
     C                   PARM                    ZMDATE
      *
      ** If the program ends in error
      *
     C     *IN15         IFEQ      '1'
     C                   Z-ADD     260           DBERR#                         **************
     C                   MOVEL     '       '     DBERKY                         *DB ERROR 260*
     C                   MOVEL     'ZM0060'      DBFNAM                         **************
     C                   EXSR      DBERR
     C                   ENDIF
     C                   MOVE      ZMDATE        @HRDT             6
      *
      ** Initialise constant fields
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
      ** CRLF Control Character for message data records
      *
     C                   MOVE      CRLF          CTRC
      *
      ** Check type of RUN
     C     RMODE         IFEQ      'I'
     C                   SETON                                        13
     C                   ENDIF
      ** Set message production parameter
     C                   MOVE      'N'           OPPARM            1
      *
      ** Define key list to access LF/SDM901L0
     C     KM9ACC        Klist
     C                   Kfld                    F25_Cnum
     C                   Kfld                    SMCY
     C                   Kfld                    F25_Acod
     C                   Kfld                    F25_Acsq
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
      * SR/LAST - Last Record Processing                              *
      *****************************************************************
     C     LAST          BEGSR
      *
      ** Output a RUN control Report
     C  N40              EXSR      FIRST
     C                   WRITE     HEADAU                               80
      *
     C     *IN80         IFEQ      *ON
     C                   MOVEL     'FT162003AU'  DBFNAM                         **************
     C                   MOVEL     'AU'          DBERKY                         *DB ERROR 270*
     C                   Z-ADD     270           DBERR#                         **************
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SR/DBERR - Set Up Data Structure for Database Errors.         *
      *****************************************************************
     C     DBERR         BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'FT162003'    DBPGM                          ) Set Up
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
      * SR/@DEFN - This subroutine is never invoked. Used to setup    *
      *            Key Lists etc.                                     *
      *****************************************************************
     C     @DEFN         BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Now our *LIKEs
      *
     C     *LIKE         DEFINE    DBKEY         DBERKY                         Key information
     C     *LIKE         DEFINE    DBASE         DBERR#                         Unique No
     C     *LIKE         DEFINE    DBFILE        DBFNAM                         File Name
     C     *LIKE         DEFINE    OPPARM        RMODE
     C     *LIKE         DEFINE    DECN          SDECN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2017
**  MTH - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
